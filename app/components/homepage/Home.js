/**
 * Created by xian on 2017/5/23.
 * 首页
 */
'use strict';


import {
    DeviceEventEmitter,
    View,
    Text,
    StyleSheet,
    Image,
    FlatList,
    Platform,
    StatusBar,
    TouchableWithoutFeedback,
    AsyncStorage,
    NetInfo,
    Animated,
    Easing,
} from 'react-native';

import {
    RnConnect,
    routeConfig,
    RouteManager,
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Colors,
    Fonts,
    Actions,
    NetErro,
    getStatusHeightHome,
} from '../../config/UtilComponent';

import Swiper from 'react-native-swiper';
import ViewPager from '../../../foundation/common/lzy_viewpager/ViewPager';
import RefreshFlatList, {RefreshState, ViewType} from '../../../foundation/common/headerlistview/RefreshFlatList';
import Toast, {DURATION} from 'react-native-easy-toast';
import SmallBlack from './componets/SmallBlack';
import AppConst from '../../../app/constants/AppConstant';
import VideoItem from './componets/VideoItem';
import TuanItem from './componets/TuanItem';
import DoumaluItem from './componets/DoumaluItem';
import DoumaluItem2 from './componets/DoumaluItem2';
import Item from './componets/Item';
import GetHomeData from '../../../foundation/net/home/GetHomeData';
import RecommendItem from './componets/RecommendItem';
import YouLikeItem from './componets/YouLikeItem';
import GetMoreListData from '../../../foundation/net/home/GetMoreListData';
import RectangleViews from './componets/RectangleViews';
import * as ActionsJump from '../../../foundation/common/ActionsJump';
import TuanDoor from './componets/TuanDoor';
import VideoBottomItem from './componets/VideoBottomItem';
import routeByUrl from './RoutePageByUrl';
import GuidePage from './GuidePage'
import VipGuidePage from './VipGuidePage'
import {DataAnalyticsModule} from '../../config/AndroidModules';
import PressTextColor from '../../../foundation/pressTextColor';
import Carousel from '../../../foundation/common/loop_carousel/Carousel';
import {AndroidRouterModule} from '../../config/AndroidModules';


let topimg = '';
let self = {};
let toTop = true;
//分类对象
let tlistSwiper = [];
let keyIndex = 0;
let pullCount = 0; // 团购模块 拖到右边的次数  当位2的倍数的时候 跳转
const DACK_CONTENT = 'dark-content';
const LIGHT_CONTENT = 'light-content';
let key = 0;
let jumpflag = true;
let codeValue = '';
let pageVersionName = '';
let clickHomeTab = false; // 点击了首页tabbar的标示

let flatposition = 0;
let huojian = false;
let homeOffSet = 0;
let xiaoheiban1 = [];
let xiaoheiban2 = [];

const Com = __DEV__ ? Component : PureComponent;

export default class Home extends Com {
    constructor(props) {
        super(props);
        this.state = {
            fadeAnim: new Animated.Value(0),
            swiperShow: Platform.OS === 'ios',
            data: [],
            headerHeight: 150,
            isRefreshing: false,
            pageSize: 20,
            pageNum: 2,
            likedata: [],
            id: 0,
            searchBarState: 1,      //0 隐藏 1正常， 2变色
            clickable: false,
            headerTop: -200,
            other: 0,
            ishavMsg: 1,
            blackBoardOffSet: {
                x: 0,
                y: 0
            },
            vipOffSet: {
                x: 0,
                y: 0,
            },
            netStatus: true,//true:网络正常,false异常
            errStatus: true,//true:无错误,false有错误
        };
        this.contentOffsetY = 0;
        this._getData = this._getData.bind(this);
        this._getMore = this._getMore.bind(this);
        this._renderVideo = this._renderVideo.bind(this);
        this._renderItemComponent = this._renderItemComponent.bind(this);
        this._checkNetWork = this._checkNetWork.bind(this);
    }


    //判断是否有网络
    _checkNetWork(haveNet, noNet) {

        NetInfo.isConnected.fetch().done((isConnected) => {
            if (isConnected) {
                //有网络
                haveNet && haveNet();
            } else {
                //网络异常
                noNet && noNet();
            }
        });
    }

    _renderStatus() {
        return (
            <StatusBar
                ref="statusbar"
                key={++key}
                translucent={true}
                barStyle={this.state.searchBarState === 1 ? LIGHT_CONTENT : DACK_CONTENT}
                backgroundColor={'rgba(255,255,255,0)'}
            />
        );
    }

    _jump(v) {
        // 通知flatList更新数据
        this.setState({random: Math.random()});
        let NETInfo = true;
        if (!NETInfo) {
            return;
        }
        switch (v.id) {
            case 0:
                //搜索
                if (v.value) {
                    Actions.KeywordSearchPageHome({fromPage: 'Home', searchText: v.value.searchtext});
                }
                if (v.value && v.value.searchCode) {
                    DataAnalyticsModule.trackEvent3(v.value.searchCode, "", {'pID': codeValue, 'vID': pageVersionName});

                }
                break;
            case 1:
                //广告页
                if (v.value && v.value.indexOf('http') !== -1) {
                    routeByUrl(v.value);
                }
                if (v.codeValue) {
                    DataAnalyticsModule.trackEvent3(v.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                }
                break;
            case 2:
                //分类页
                if (tlistSwiper.length < 19 && v.value.shortNumber === 9 || tlistSwiper.length === 19 && v.value.shortNumber === 19) {
                    Actions.popTo('ClassificationPage');
                } else if (v.value) {
                    Actions.ClassificationChannel({
                        title: v.value.title,
                        destinationUrl: v.value.destinationUrl,
                        lgroup: v.value.lgroup
                    });
                }
                if (v.value) {
                    DataAnalyticsModule.trackEvent3(v.value.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                }
                break;
            case 3:
                //小黑板
                Actions.SmallBlackBoard();
                if (v.value) {
                    DataAnalyticsModule.trackEvent3(v.value, "", {'pID': codeValue, 'vID': pageVersionName});
                }
                break;
            case 4:
                // RectangleViews
                ActionsJump.actionsJump(v.value);
                if (v.value.codeValue) {
                    DataAnalyticsModule.trackEvent3(v.value.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                }
                break;
            case 5:
                //视频/直播播放页
                switch (v.value.type) {
                    case 1:   //tv
                        RouteManager.routeJump({
                            page: routeConfig.Video,
                            param: {id: v.value.id},
                            fromRNPage: routeConfig.Home,
                        });
                        break;
                    case 2:   //网络
                        routeByUrl(v.value.url);
                        break;
                    case 3:   //短视频
                        RouteManager.routeJump({
                            page: routeConfig.Video,
                            param: {id: v.value.id},
                            fromRNPage: routeConfig.Home,
                        });
                        break;
                    default:
                        break;
                }
                if (v.value.codeValue) {
                    DataAnalyticsModule.trackEvent3(v.value.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                }
                break;
            case 6:
                //视频列表
                if (v.value) {
                    if (v.value.destinationUrl === 'AP1706A047') {
                        Actions.Home_OnLive();
                    } else if (v.value.destinationUrl === 'AP1706A049') {
                        Actions.Home_VideoList({video: v.value});
                    }
                    if (v.value.codeValue) {
                        DataAnalyticsModule.trackEvent3(v.value.codeValue, "", {
                            'pID': codeValue,
                            'vID': pageVersionName
                        });
                    }
                }
                break;
            case 7:
                //团购页
                let pageID = 'TodayGroupBuy';
                if (v.value && v.value.index && v.value.index === 1) {
                    pageID = 'TVGroupBuy';
                } else if (v.value && v.value.index && v.value.index === 2) {
                    pageID = 'BrandGroup';
                }
                Actions.Group({pageID: pageID, fromPage: 'Home'});//pageID  TodayGroupBuy  BrandGroup TVGroupBuy
                if (v.value && v.value.codeValue) {
                    DataAnalyticsModule.trackEvent3(v.value.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                }
                break;
            case 8:
                //消息
                this.refs.msgimg.setNativeProps({
                    style: {width: 0, height: 0}
                })
                Actions.MessageFromHome({fromPage: 'HomePage'});
                break;
            case 9:
                //商品详情
                if (v.value) {
                    Actions.GoodsDetailMain({'itemcode': v.value.contentCode});
                    DataAnalyticsModule.trackEvent3(v.value.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                }
                break;
            case 10:
                //签到
                //RnConnect.pushs({page: routeConfig.Homeocj_Sign});
                break;
            case 11:
                //扫一扫
                //RnConnect.pushs({page: routeConfig.Homeocj_Sweep}, (event) => {
                // routeByUrl(event.url);
                // Actions.GoodsDetailMain(event);
                //});
                RouteManager.routeJump({
                    page: routeConfig.Sweep,
                    fromRNPage: routeConfig.Home,
                })
                break;
            case 12:
                //会员特价
                routeByUrl(v.value);
                if (v.codeValue) {
                    DataAnalyticsModule.trackEvent3(v.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                }
                break;
            case 13:
                //小黑板
                Actions.SmallBlackBoardDetails({destinationUrl: v.url, contentCode: v.code});
                if (v.codeValue) {
                    DataAnalyticsModule.trackEvent3(v.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                }
                break;
            case 14:
                Actions.popTo('ShoppingPage');
            default:
                break;
        }
    }

    //扫码跳详情页 or H5
    checkToGodds(url) {
        if (url.indexOf('/detail/') !== -1) {
            let detailUrl = url.split('/detail/')[1];
            if (detailUrl.indexOf('?') !== -1) {
                let params = detailUrl.split('?');
                let itemCode = params[0];
                if (params[1].indexOf('isBone') !== -1) {
                    Actions.GoodsDetailMain({itemcode: itemCode, isBone: '1'});
                } else {
                    Actions.GoodsDetailMain({itemcode: itemCode});
                }
            } else {
                Actions.GoodsDetailMain({itemcode: detailUrl});
            }
        } else {
            routeByUrl(url);
        }
    }

    _getData(refresh = true) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            if (isConnected || !refresh) {
                this._getNetData();
            } else {
                this.refs.toast.show('亲！请检查你的网络！', DURATION.LENGTH_LONG);
                this.setState({
                    isRefreshing: false,//重置刷新状态
                });
            }
        })
    }

    _getNetData() {
        if (toTop) {
            toTop = false;
        } else {
            return;
        }
        if (this.GetHomeDataRequest) {
            this.GetHomeDataRequest.setCancled(true);
        }
        this.GetHomeDataRequest = new GetHomeData({id: 'AP1706A001'}, 'GET');
        if (!this.state.isRefreshing) this.GetHomeDataRequest.showLoadingView();
        this.GetHomeDataRequest.start(
            (response) => {
                if (this.titleBar && Platform.OS === 'android') {
                    this.titleBar.setNativeProps({
                        style: {opacity: 1}
                    });
                }
                if (response.code === 200) {
                    keyIndex += 1;
                    if (response.data && response.data.packageList && response.data.packageList.length > 17 &&
                        response.data.packageList[17].componentList && response.data.packageList[17].componentList.length) {
                        this.setState({
                            data: response.data.packageList,
                            isRefreshing: false,
                            id: response.data.packageList[17].componentList[0].id,
                            likedata: response.data.packageList[17].componentList[0].componentList,
                            netStatus: true,
                            errStatus: true,
                        });
                        codeValue = response.data.codeValue;
                        pageVersionName = response.data.pageVersionName;
                        //首页页面埋点
                        DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                        toTop = true;
                    } else {
                        this.setState({
                            data: response.data.packageList,
                            isRefreshing: false,
                        });
                        toTop = true;
                    }
                    // 展示引导动画UI  第一次展示
                    AsyncStorage.getItem('IS_FIRST_REFRESH', (error, object) => {
                        if (object !== 'NO') {
                            setTimeout(() => this.refs.guidePageRef.show(), 100);
                            AsyncStorage.setItem('IS_FIRST_REFRESH', 'NO');
                        } else if (object === 'NO') {
                            // let homeDataSource = response.data.packageList
                            // if (homeDataSource && homeDataSource.length && homeDataSource[6].componentList &&
                            //     homeDataSource[6].componentList.length === 6) {
                            //     AsyncStorage.getItem('CAN_VIP_SHOW', (err, obj) => {
                            //         if (obj !== 'NO') {
                            //             setTimeout(() => this.refs.vipGuidePageRef.show(), 100);
                            //             AsyncStorage.setItem('CAN_VIP_SHOW', 'NO');
                            //         }
                            //     })
                            // }
                        }
                    })
                    // LocalStorage.saveCms(Global.CMS_CACHE_HOME, response.data.packageList);
                    // console.log('------------save home-------');
                } else {
                    this.refs.toast.show(response.code, DURATION.LENGTH_LONG);
                    toTop = true;
                    this.setState({
                        isRefreshing: false,
                        netStatus: true,
                        errStatus: false,
                    });
                }
            }, (erro) => {
                this.setState({
                    isRefreshing: false,
                    netStatus: true,
                    errStatus: false,
                });
                if (this.titleBar && Platform.OS === 'android') {
                    this.titleBar.setNativeProps({
                        style: {opacity: 1}
                    });
                }
                toTop = true;
            });

    }

    //TODO
    // home_to_others(route, id) {
    //     LocalStorage.remove("jumpkey");
    //     RnConnect.pushs({page: route, param: {id: id}}, (event) => {
    //         NativeRouter.nativeRouter(event);
    //     });
    // }
    //
    // onScanningResult = () => {
    //     clearTimeout(this.time);
    //     this.time = setTimeout(() => {
    //         LocalStorage.load("jumpkey", (ret) => {
    //             if (ret.Globalocj !== undefined || ret.VIPocj !== undefined
    //                 || ret.Vedioocj !== undefined || ret.returnocj !== undefined
    //                 || ret.MessageListocj !== undefined || ret.iOSocj_Cart !== undefined) {
    //                 if (ret.Globalocj === routeConfig.Globalocj_GoodsDetailMain) {
    //                    // this.home_to_others(routeConfig.Homeocj_Global)
    //                 } else if (ret.VIPocj === routeConfig.VIPocj_GoodsDetailMain) {
    //                     this.home_to_others(routeConfig.Homeocj_VIP)
    //                 } else if (ret.Vedioocj === routeConfig.Vedioocj_GoodsDetailMain) {
    //                     if (ret.fromPage && ret.fromPage === 'ShoppingPage') {
    //                         Actions.popTo('ShoppingPage');
    //                     }
    //                     this.home_to_others(routeConfig.Homeocj_Video)
    //                 } else if (ret.Vedioocj === routeConfig.Videoocj_cartFrmRoot) {
    //                     this.home_to_others(routeConfig.Homeocj_Video, ret.id)//视频ID
    //                 } else if (ret.returnocj === routeConfig.returnocj_WebView) {
    //                     NativeRouter.nativeRouter({beforepage: routeConfig.returnocj_WebView});
    //                 } else if (ret.iOSocj_Cart === routeConfig.iOSocj_CartPage) {
    //                     LocalStorage.remove("jumpkey");
    //                     NativeRouter.nativeRouter({beforepage: routeConfig.returnocj_WebView});
    //                 } else if (ret.MessageListocj === routeConfig.Globalocj_MessageListPage) {
    //                     this.home_to_others(routeConfig.Globalocj_MessageListPage)
    //                 }
    //             }
    //         }, (erro) => {
    //             // console.log("---> erro " + erro.message);
    //         })
    //     });
    // };

    componentWillMount() {
        //DeviceEventEmitter.addListener('jumpkey', this.onScanningResult);
        DeviceEventEmitter.addListener('refreshApp', (noti) => {
            if (noti.type === 'refreshToHomePage') {
                //退出登陆拉起h5问题
                // Actions.Indexocj_Tab({type: 'reset'});
                // Actions.JumpTo({hideNavBar: true});
                Actions.popTo('Home');
                this._getData();
            } else if (noti.type === 'refreshMePage') {
                this._getData();
            } else if (noti.type === 'refreshToken') {
                RnConnect.get_token();
            }

        });
    }

    componentDidMount() {
        // console.log('---> componentDidMount ');
        this._getData(false);
        DeviceEventEmitter.addListener('refreshOrderCenter', () => {
            setTimeout(() => {
                this._getData();
            }, 100);
        });
        DeviceEventEmitter.addListener('HomePageRefresh', () => {
            setTimeout(() => {
                this._getData();
            }, 100);
        });

        DeviceEventEmitter.addListener('scrollTop', () => {
            if (this.refs.vipNeedScroll !== undefined) {
                this.refs.vipNeedScroll.scrollToY(0.1);
            }
        });
        DeviceEventEmitter.addListener('refreshhomestatus', () => {
            this.setState({
                other: this.state.other + 1
            })
        });
        //跳去原生页面
        DeviceEventEmitter.addListener('goToNativeView', (video) => {
            RouteManager.routeJump({
                isPush: true,
                page: video.page,
                param: video.param.orderNo ? video.param.orderNo : video.param,
            })
        });
        //关闭Fetching js bundle的dialog,不要注释掉！
        if (Platform.OS === 'android') {
            AndroidRouterModule.hide();
        }
    }

    _renderItemComponent = ({item}) => {
        switch (item.key) {
            case 1:
                return this._renderFirst();
                break;
            case 2:
                return this._renderSecond();
                break;
            case 3:
                return this._renderThird();
                break;
            case 4:
                return this._renderFour();
                break;
            default:
                break;
        }
    };

    _renderFour() {
        return (
            <View style={{width: ScreenUtils.screenW}}>
                {
                    self.state.likedata && self.state.likedata.length > 0 ? (
                        <View style={{marginTop: ScreenUtils.scaleSize(20)}}>
                            <View style={styles.titleView}>
                                <Text style={styles.titleTextStyle} allowFontScaling={false}>· 猜你喜欢 ·</Text>
                            </View>
                            <FlatList
                                keyExtractor={this._keyExtractor}
                                scrollEnabled={false}
                                extraData={this.state}
                                data={self.state.likedata}
                                renderItem={({item, index}) => <YouLikeItem
                                    item={item}
                                    index={index}
                                    length={self.state.likedata ? self.state.likedata.length : 0}
                                    onClick={(v) => this._jump({
                                        id: 9,
                                        value: v
                                    })}/>}
                                ItemSeparatorComponent={this.youLikeItem}
                            />
                        </View>
                    ) : null
                }
            </View>
        )
    }

    youLikeItem() {
        return (
            <View style={{flexDirection: 'row'}}>
                <View style={{
                    height: ScreenUtils.scaleSize(1),
                    width: ScreenUtils.scaleSize(270),
                    backgroundColor: '#fff',
                }}></View>
                <View style={{
                    height: ScreenUtils.scaleSize(1),
                    width: ScreenUtils.scaleSize(480),
                    backgroundColor: '#DDD',
                }}></View></View>
        )
    }

    _getMore() {

        if (this.GetMoreListDataRequest) {
            this.GetMoreListDataRequest.setCancled(true);
        }
        this.GetMoreListDataRequest = new GetMoreListData({
            id: this.state.id, pageNum: this.state.pageNum, pageSize: this.state.pageSize
        }, 'GET');
        this.GetMoreListDataRequest.start(
            (response) => {
                if (response.code === 200) {
                    if (response.data && response.data.list && response.data.list.length > 0) {
                        let list = this.state.likedata;
                        for (let i = 0; i < response.data.list.length; i++) {
                            list.push(response.data.list[i]);
                        }
                        this.setState({
                            pageNum: this.state.pageNum + 1,
                            likedata: list,
                        });
                        if (response.data.list.length < this.state.pageSize) {
                            this.setState({
                                clickable: true,
                            })
                        }
                    } else {
                        this.setState({
                            clickable: true,
                        })
                    }
                } else {
                    this.setState({
                        clickable: true,
                    });
                    this.refs.toast.show(response.code, DURATION.LENGTH_LONG);
                }
            }, (erro) => {
                this.setState({
                    clickable: true,
                })
            });
    }

    _renderPages1(item, pageID) {
        return (
            <TouchableWithoutFeedback
                onPress={() => self._jump({id: 1, value: item.destinationUrl, codeValue: item.codeValue})}>
                <View>
                    {item.firstImgUrl ? <Image
                        style={styles.swiperItem}
                        source={{uri: item.firstImgUrl}}/> : null}
                </View>
            </TouchableWithoutFeedback>
        );
    }

    _renderPagesX(item, pageID) {
        return (
            <View style={{
                width: ScreenUtils.screenW - ScreenUtils.scaleSize(118),
                height: ScreenUtils.scaleSize(118),
            }}>
                {
                    pageID % 2 === 0 ?
                        <FlatList
                            data={xiaoheiban1}
                            renderItem={({item}) => <SmallBlack item={item}/>}
                        />
                        :
                        <FlatList
                            data={xiaoheiban2}
                            renderItem={({item}) => <SmallBlack item={item}/>}
                        />
                }
            </View>
        );
    }

    _renderPages2(item, pageID) {
        return (
            <TouchableWithoutFeedback
                onPress={() => {
                    self._checkNetWork(() => {
                        self._jump({id: 1, value: item.destinationUrl, codeValue: item.codeValue})
                    }, () => {
                        self.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                    });
                }}>
                <View style={{alignItems: 'center', width: ScreenUtils.screenW, height: ScreenUtils.scaleSize(200)}}>
                    {item.firstImgUrl ? <Image
                        style={{
                            width: ScreenUtils.screenW - ScreenUtils.scaleSize(60),
                            height: ScreenUtils.scaleSize(200),
                            resizeMode: 'contain',
                        }}
                        source={{uri: item.firstImgUrl}}/> : null}</View>
            </TouchableWithoutFeedback>
        );
    }

    _renderPagesB(item, pageID) {
        return (
            <TouchableWithoutFeedback
                onPress={() => {

                    self._checkNetWork(() => {
                        self._jump({
                            id: 1,
                            value: item.destinationUrl,
                            codeValue: item.codeValue
                        })
                    }, () => {
                        self.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                    });

                }}>
                <View>
                    {item.firstImgUrl ? <Image
                        style={styles.swiperItem}
                        source={{uri: item.firstImgUrl}}/> : null}
                </View>
            </TouchableWithoutFeedback>
        );
    }

    _renderFirst() {
        // 源数据
        let datas = this.state.data;
        // 判断轮播的个数
        let d = [];
        let advertisement = {};
        // 顶部轮播
        let swiperList = [];
        let xiaoheibans = [];

        let someFiles = [];        //vip 全球购等6个
        let heibancode = '';
        if (datas && datas.length > 0) {
            if (datas[0] && datas[0].componentList && datas[0].componentList[0] && datas[0].componentList[0].firstImgUrl)
                topimg = datas[0].componentList[0];
            if (datas[2] && datas[2].componentList) {
                swiperList = datas[2].componentList;
            }
            if (datas[3] && datas[3].componentList && datas[3].componentList.length > 0) {
                advertisement = datas[3].componentList[0];
            }
            if (datas[4] && datas[4].componentList) {
                tlistSwiper = datas[4].componentList;
            }
            let tlistSwiperLength = tlistSwiper.length;
            if (tlistSwiperLength > 0 && tlistSwiperLength < 19) {
                d.push(1);
            } else if (tlistSwiperLength > 10 && tlistSwiperLength < 21) {
                d.push(1);
                d.push(2);
            }
            if (datas[5] && datas[5].componentList && datas[5].componentList.length) {
                xiaoheibans = datas[5].componentList[0].componentList;
                heibancode = datas[5].codeValue;
            }
            if (xiaoheibans.length > 0) {
                for (let i = 0; i < xiaoheibans.length; i++) {
                    if (i < 2) {
                        xiaoheiban1.push(xiaoheibans[i]);
                    } else if (i < 4) {
                        xiaoheiban2.push(xiaoheibans[i]);
                    }
                }
            }
            if (datas[6]) {
                someFiles = datas[6].componentList;
            }
        }
        return (
            <View>
                {/*大图轮播*/}
                {
                    swiperList.length > 0 ? <View style={styles.interimImgStyle}>

                        <Swiper
                            height={ScreenUtils.scaleSize(350)}
                            autoplayTimeout={4}
                            paginationStyle={{bottom: ScreenUtils.scaleSize(20)}} //小圆点的位置：距离底部10px
                            dot={<View style={styles.noChoseBtn}/>}
                            activeDot={<View style={styles.choseBtn}/>}
                            loop={true}
                            autoplay={true}
                        >
                            {swiperList.map((item, index) => {
                                return (
                                    <TouchableWithoutFeedback
                                        key={index}
                                        onPress={() => self._jump({
                                            id: 1,
                                            value: item.destinationUrl,
                                            codeValue: item.codeValue
                                        })}>
                                        <View>
                                            {item.firstImgUrl ? <Image
                                                style={styles.swiperItem}
                                                source={{uri: item.firstImgUrl}}/> : null}
                                        </View>
                                    </TouchableWithoutFeedback>
                                )
                            })
                            }
                        </Swiper>
                    </View> : null}
                {/*广告图 + 10个小图标轮播*/}
                <View style={styles.combineShape}>
                    {advertisement && advertisement.firstImgUrl ?
                        (
                            <PressTextColor onPress={() => {
                                self._checkNetWork(() => {
                                    self._jump({
                                        id: 1,
                                        value: advertisement.destinationUrl,
                                        codeValue: advertisement.codeValue
                                    })
                                }, () => {
                                    self.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                                });
                            }}>
                                <View style={styles.horizontalCenter}>
                                    <Image style={{
                                        resizeMode: 'cover',
                                        width: ScreenUtils.screenW,
                                        height: ScreenUtils.scaleSize(200)
                                    }} source={{uri: advertisement.firstImgUrl}}/>
                                </View>
                            </PressTextColor>
                        )
                        : null
                    }
                    {tlistSwiper.length === 20 ?

                        <ViewPager
                            keyExtractor={this._keyExtractor}
                            //key={keyIndex}
                            //style={{height: ScreenUtils.screenW / 2.5 + ScreenUtils.scaleSize(30)}}
                            dataSource={new ViewPager.DataSource({
                                pageHasChanged: (p1, p2) => p1 !== p2,
                            }).cloneWithPages(d)}
                            renderPage={this._renderPageTen}
                        />
                        :
                        tlistSwiper.length > 0 && tlistSwiper.length < 19 ?
                            <View
                                style={{
                                    width: ScreenUtils.screenW
                                }}>
                                <FlatList
                                    keyExtractor={this._keyExtractor}
                                    alwaysBounceVertical={false}
                                    numColumns={5}
                                    data={tlistSwiper}
                                    renderItem={({item}) => <Item row={item}
                                                                  onClick={(v) => self._jump({id: 2, value: v})}/>}
                                />
                            </View> : null
                    }
                </View>
                {/*小黑板*/}
                {xiaoheiban1.length > 0 && xiaoheiban2.length > 0 ?
                    <PressTextColor onPress={() => this._jump({id: 3, value: heibancode})}
                                    onLayout={({nativeEvent: {layout: {x, y, width, height}}}) => {
                                        // console.log(y + height);

                                        let offsetY = y + height + ScreenUtils.scaleSize(120) + 22;
                                        if (Platform.OS !== 'ios') {
                                            offsetY += 22;
                                        }
                                        // console.log(offsetY);
                                        if (offsetY > ScreenUtils.screenH - ScreenUtils.scaleSize(169)) {
                                            if (Platform.OS === 'ios') {
                                                offsetY = ScreenUtils.screenH - ScreenUtils.scaleSize(169)
                                            } else {
                                                offsetY = ScreenUtils.screenH - ScreenUtils.scaleSize(69) - ScreenUtils.scaleSize(100) - 22
                                            }
                                            homeOffSet = y + height + ScreenUtils.scaleSize(120) -
                                                ScreenUtils.screenH + ScreenUtils.scaleSize(49) + ScreenUtils.scaleSize(100)
                                        }
                                        // console.log(homeOffSet);
                                        // console.log(offsetY);
                                        this.setState({
                                            blackBoardOffSet: {
                                                x: x,
                                                y: y,
                                            },
                                            vipOffSet: {
                                                x: x,
                                                y: offsetY,
                                            }
                                        })
                                    }}>
                        <View style={styles.smallblackboardBoxStyle}>
                            <Image source={require('../../../foundation/Img/home/img_xiaoheiban_.png')}
                                   style={styles.smallblackboardImgStyle}/>
                            {Platform.OS === 'ios' ?
                                <Swiper
                                    key={keyIndex}
                                    keyExtractor={this._keyExtractor}
                                    height={ScreenUtils.scaleSize(118)}
                                    horizontal={false}
                                    showsPagination={false}
                                    autoplay
                                    removeClippedSubviews={false}
                                >
                                    <View style={{justifyContent: 'center', height: ScreenUtils.scaleSize(118)}}>
                                        <FlatList
                                            key={keyIndex}
                                            keyExtractor={this._keyExtractor}
                                            data={xiaoheiban1}
                                            renderItem={({item}) => <SmallBlack item={item}/>}
                                        />
                                    </View>
                                    <View style={{justifyContent: 'center', height: ScreenUtils.scaleSize(118)}}>
                                        <FlatList
                                            keyExtractor={this._keyExtractor}
                                            //key={keyIndex}
                                            data={xiaoheiban2}
                                            renderItem={({item}) => <SmallBlack item={item}/>}
                                        />
                                    </View>
                                </Swiper> :
                                <View style={{
                                    width: ScreenUtils.screenW - ScreenUtils.scaleSize(118),
                                    height: ScreenUtils.scaleSize(118)
                                }}>
                                    <ViewPager
                                        keyExtractor={this._keyExtractor}
                                        //key={keyIndex}
                                        style={{
                                            height: ScreenUtils.scaleSize(118),
                                        }}
                                        dataSource={new ViewPager.DataSource({
                                            pageHasChanged: (p1, p2) => p1 !== p2,
                                        }).cloneWithPages(xiaoheiban1)}
                                        renderPage={this._renderPagesX}
                                        isLoop={true}
                                        autoPlay={true}
                                        renderPageIndicator={this.pagein}
                                    />
                                </View>

                            }
                        </View>
                    </PressTextColor> : null
                }
                {/*导航*/}
                <RectangleViews list={someFiles} onClick={(v) => this._jump({id: 4, value: v})}/>
            </View>
        )
    }

    pagein() {
        return (
            <View style={{width: 0, height: 0}}/>
        )
    }

    _viewpagerIndicator() {
        return (
            <View style={{width: 5, height: 5, backgroundColor: '#fff'}}/>)
    }

    _renderVideo(item) {
        return (
            <VideoItem
                item={item}
                onClick={() => this._jump({
                    id: 5, value: {
                        id: item.id,
                        type: 1
                    }
                })}/>
        );
    }


    _renderSecond() {
        let datas = this.state.data;
        let videoList = [];
        let viewVideos = [];        //看直播3个模块
        let tuanList = [];          //团购商品列表
        let adlunbo = [];
        let tuanDoors = [];
        if (datas && datas.length > 7) {
            if (datas[7].componentList && datas[7].componentList[0]) {
                videoList = datas[7].componentList[0].componentList;
            }
            if (datas[8] && datas[8].componentList) {
                viewVideos = datas[8].componentList;
            }
            if (datas[9] && datas[9].componentList) {
                adlunbo = datas[9].componentList;
            }
            if (datas[10] && datas[10].componentList && datas[10].componentList[0]) {
                tuanList = datas[10].componentList[0].componentList;
            }
            if (datas[11] && datas[11].componentList) {
                tuanDoors = datas[11].componentList;
            }
        }
        return (
            <View>
                {/*看直播*/}
                <View style={styles.blockViewStyle}>

                    {videoList.length > 0 || viewVideos.length > 0 ? < View style={styles.titleView}>
                        <Image style={styles.titleImgStyles}
                               source={require('./../../../foundation/Img/home/icon_title1_.png')}/>
                        <Text style={styles.titleTextStyle} allowFontScaling={false}>看直播</Text>
                    </View> : null}

                    <View style={styles.liveView}>
                        <FlatList
                            keyExtractor={this._keyExtractor}
                            //key={keyIndex}
                            showsHorizontalScrollIndicator={false}
                            horizontal={true}
                            data={videoList}
                            renderItem={({item}) => <VideoItem item={item} onClick={(v) => this._jump({
                                id: 5, value: v
                            })}/>}
                            ListFooterComponent={() => {
                                return (
                                    <View>
                                        {
                                            videoList && videoList.length > 0 ?
                                                <PressTextColor style={styles.moreStyle}
                                                                onPress={() => {
                                                                    this._jump({id: 14})
                                                                }}>
                                                    <Text allowFontScaling={false}
                                                    >更多视频</Text>
                                                </PressTextColor>
                                                : <View/>
                                        }
                                    </View>
                                )
                            }}
                        />

                        <View style={{
                            display: 'flex', flex: 1, flexDirection: 'row', justifyContent: 'space-around',
                            paddingVertical: ScreenUtils.scaleSize(20)
                        }}>
                            {
                                viewVideos ? viewVideos.map((d, index) => (
                                    <VideoBottomItem key={index + d.title} item={d}
                                                     onClick={(v) => this._jump({id: 6, value: v})}/>
                                )) : null
                            }
                        </View>
                    </View>
                    {adlunbo.length > 0 ?
                        <View style={{marginVertical: ScreenUtils.scaleSize(20), height: ScreenUtils.scaleSize(200)}}>
                            <ViewPager
                                keyExtractor={this._keyExtractor}
                                // key={keyIndex}
                                style={{height: ScreenUtils.scaleSize(200)}}
                                dataSource={new ViewPager.DataSource({
                                    pageHasChanged: (p1, p2) => p1 !== p2,
                                }).cloneWithPages(adlunbo)}
                                renderPage={this._renderPages2}
                                isLoop={true}
                                autoPlay={true}/>
                        </View>
                        : null}
                </View>
                {/*团购*/}
                <View style={styles.blockViewStyle}>
                    {tuanList.length > 0 || tuanDoors.length > 0 ?
                        <View>
                            <View style={styles.titleView}>
                                <Image style={styles.titleImgStyles}
                                       source={require('./../../../foundation/Img/home/icon_title2_.png')}/>
                                <Text style={styles.titleTextStyle} allowFontScaling={false}>团 购</Text>
                                <View style={styles.viewStyle}>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.viewTextStyle}>每日 0 点上新</Text>
                                </View>
                            </View>
                            <View style={styles.flatOutView}>
                                <FlatList
                                    keyExtractor={this._keyExtractor}
                                    //key={keyIndex}
                                    // onScroll={(e) => this.groupBuyFlatListOnScroll(e, tuanList) }
                                    contentContainerStyle={{alignItems: 'center'}}
                                    showsHorizontalScrollIndicator={false}
                                    horizontal={true}
                                    data={tuanList}
                                    renderItem={({item}) => <TuanItem
                                        item={item}
                                        onClick={(v) => this._jump({id: 9, value: v})}/>}
                                    ListFooterComponent={this._tuanFooter}
                                />
                            </View></View> : null}
                    {tuanDoors.length > 0 ? <TuanDoor
                        //key={keyIndex}
                        data={tuanDoors}
                        onClick={(v) => this._jump({id: 7, value: v})}/> : null}
                </View>
                {/*会员特价，福利*/}
                {datas.length > 10 ? <View style={{
                    flexDirection: 'row', justifyContent: 'space-between',
                    marginVertical: ScreenUtils.scaleSize(20)
                }}>
                    <PressTextColor
                        style={{
                            width: '50%',
                            paddingVertical: ScreenUtils.scaleSize(20),
                            flexDirection: 'row',
                            backgroundColor: '#fff',
                            justifyContent: 'space-around',
                            alignItems: 'center',
                            height: ScreenUtils.scaleSize(150),
                            borderRightColor: '#ddd',
                            borderRightWidth: StyleSheet.hairlineWidth
                        }}
                        onPress={() => {

                            self._checkNetWork(() => {
                                this._jump({id: 12, value: AppConst.H5_BASE_URL + '/oclub/moblieOclubFamilyDayList',});
                            }, () => {
                                self.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                            });

                        }}
                    >
                        <View>
                            <Text
                                allowFontScaling={false}
                                style={{
                                    color: '#333',
                                    fontSize: ScreenUtils.setSpText(28),
                                }}>会员特价</Text>
                            <Text
                                allowFontScaling={false}
                                style={{
                                    marginTop: ScreenUtils.scaleSize(10),
                                    color: '#999',
                                    fontSize: ScreenUtils.setSpText(26),
                                }}>特权独享 超低价</Text>
                        </View>
                        <Image
                            style={{
                                width: ScreenUtils.scaleSize(95), height: ScreenUtils.scaleSize(95),
                                resizeMode: 'contain',
                            }}
                            source={require('../../../foundation/Img/home/icon__specialOffers_.png')}/>
                    </PressTextColor>
                    <PressTextColor
                        onPress={() => {

                            self._checkNetWork(() => {
                                this._jump({
                                    id: 12, value: AppConst.H5_BASE_URL +
                                    '/oclub/tryout'
                                })
                            }, () => {
                                self.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                            });


                        }}
                        style={{
                            width: '50%',
                            paddingVertical: ScreenUtils.scaleSize(20),
                            flexDirection: 'row',
                            backgroundColor: '#fff',
                            justifyContent: 'space-around',
                            alignItems: 'center',
                            height: ScreenUtils.scaleSize(150)
                        }}>
                        <View>
                            <Text
                                allowFontScaling={false}
                                style={{
                                    color: '#333',
                                    fontSize: ScreenUtils.setSpText(28),
                                }}>福利派</Text>
                            <Text
                                allowFontScaling={false}
                                style={{
                                    color: '#999',
                                    fontSize: ScreenUtils.setSpText(26),
                                    marginTop: ScreenUtils.scaleSize(10),
                                }}>免费试用 限时抢</Text>
                        </View>
                        <Image
                            style={{
                                width: ScreenUtils.scaleSize(95), height: ScreenUtils.scaleSize(95),
                                resizeMode: 'contain',
                            }}
                            source={require('../../../foundation/Img/home/icon_welfare_.png')}/>
                    </PressTextColor>
                </View> : null}
            </View>)
    }

    _renderThird() {
        let datas = this.state.data;
        let roadAdverImgs = [];
        let recommends = [];
        let doumaluList1 = [];
        let doumaluList2 = [];
        let doumaluList111 = [];
        if (datas && datas.length > 12 && datas[12].componentList) {
            doumaluList1 = datas[12].componentList;
            if (datas[13] && datas[13].componentList) {
                doumaluList111 = datas[13].componentList;
            }
            if (datas[14] && datas[14].componentList) {
                doumaluList2 = datas[14].componentList;
            }
            if (datas[15] && datas[15].componentList) {
                roadAdverImgs = datas[15].componentList;
            }
            if (datas[16] && datas[16].componentList && datas[16].componentList[0]) {
                recommends = datas[16].componentList[0].componentList;
            }
        }
        return (<View>
            {/* 兜马路*/}
            <View>
                {doumaluList1.length > 1 || doumaluList111.length > 1 || doumaluList2.length > 2 ?
                    <View>
                        <View style={styles.titleView}>
                            <Text
                                allowFontScaling={false}
                                style={styles.titleTextStyle}>· 兜马路 ·</Text>
                        </View>
                        <FlatList
                            keyExtractor={this._keyExtractor}
                            //key={keyIndex}
                            numColumns={2}
                            data={doumaluList1}
                            renderItem={({item}) =>
                                <DoumaluItem2 item={item}
                                              onClick={(v) => {
                                                  self._checkNetWork(() => {
                                                      this._jump(v)
                                                  }, () => {
                                                      self.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                                                  });
                                              }}/>}/>
                    </View> : null}
                {doumaluList111.length > 1 ?
                    <FlatList
                        keyExtractor={this._keyExtractor}
                        //key={keyIndex}
                        numColumns={2}
                        data={doumaluList111}
                        renderItem={({item}) => <DoumaluItem2 item={item}
                                                              onClick={(v) => {
                                                                  self._checkNetWork(() => {
                                                                      this._jump(v)
                                                                  }, () => {
                                                                      self.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                                                                  });
                                                              }}/>}/> : null}
                {doumaluList2.length > 2 ?
                    <FlatList
                        keyExtractor={this._keyExtractor}
                        //key={keyIndex}
                        numColumns={3}
                        data={doumaluList2}
                        renderItem={({item}) => <DoumaluItem item={item}
                                                             onClick={(v) => {
                                                                 self._checkNetWork(() => {
                                                                     this._jump(v)
                                                                 }, () => {
                                                                     self.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                                                                 });
                                                             }}/>}/> : null}
            </View>
            {/*广告*/}
            {roadAdverImgs.length > 0 ?
                <View style={{marginVertical: ScreenUtils.scaleSize(20), height: ScreenUtils.scaleSize(200)}}>
                    <ViewPager
                        //key={keyIndex}
                        keyExtractor={this._keyExtractor}
                        dataSource={new ViewPager.DataSource({
                            pageHasChanged: (p1, p2) => p1 !== p2,
                        }).cloneWithPages(roadAdverImgs)}
                        renderPage={this._renderPages2}
                        isLoop={true}
                        autoPlay={true}/>
                </View>
                : null}
            {/*小编推荐*/}
            {
                recommends && recommends.length > 0 ?
                    <View>
                        <View style={styles.titleView}>
                            <Text
                                allowFontScaling={false}
                                style={styles.titleTextStyle}>· 小编推荐 ·</Text>
                        </View>
                        <View style={{paddingLeft: ScreenUtils.scaleSize(30), backgroundColor: '#fff'}}>
                            <FlatList
                                keyExtractor={key => key.contentCode}
                                // keyExtractor={this._keyExtractor}
                                data={recommends}
                                extraData={this.state.random || Math.random()}
                                renderItem={({item}) =>
                                    <RecommendItem item={item} onClick={(v) => this._jump(v)}/>
                                }
                            />
                        </View>
                    </View> : null
            }
        </View>)
    }

    // 团购flatList滑动
    groupBuyFlatListOnScroll(e, list) {
        let offSetX = e.nativeEvent.contentOffset.x;
        let length = list && list.length ? list.length : 0;
        let contentOffset = ScreenUtils.scaleSize(220) * length -
            ScreenUtils.screenW + ScreenUtils.scaleSize(85) + length + 1;
        if (offSetX - contentOffset === 0) {
            pullCount += 1;
            if (pullCount === 2) {
                self._jump({'id': 7});
                pullCount = 0;
            }
        } else if (offSetX - contentOffset < 0) {
            pullCount = 0;
        }
    }

    //自定义头部
    _customerHeader = (refreshState, percent) => {
        const {headerHeight} = this.state;
        //判断类型
        switch (refreshState) {
            case RefreshState.pullToRefresh:
                if (!this.isAnimating) {
                    this.isAnimating = true;
                    Animated.timing(this.state.fadeAnim, {
                        toValue: 0,
                        duration: 100,
                        easing: Easing.linear,
                    }).start(() => {
                        this.isAnimating = false
                    })
                }
                jumpflag = true;
                return (
                    <View style={{height: headerHeight}}>
                        <Image style={{
                            width: ScreenUtils.screenW, height: headerHeight,
                            alignItems: 'center', resizeMode: 'stretch', paddingTop: ScreenUtils.scaleSize(44)
                        }}
                               source={{uri: topimg ? topimg.firstImgUrl : '11'}}>
                            <Animated.Image style={{
                                width: ScreenUtils.scaleSize(20), height: ScreenUtils.scaleSize(43)
                                , transform: [{
                                    rotateZ: this.state.fadeAnim.interpolate({
                                        inputRange: [0, 1],
                                        outputRange: ['0deg', '180deg']
                                    })
                                }]
                            }}
                                            source={require('../../../foundation/Img/home/icon_refresh_.png')}/>
                            <Text
                                allowFontScaling={false}
                                style={{
                                    color: '#EA513B', fontSize: ScreenUtils.setSpText(22),
                                    backgroundColor: 'transparent',
                                }}>下拉进入...</Text></Image></View>
                );
                break;
            case RefreshState.releaseToRefresh:
                if (!this.isAnimating) {
                    this.isAnimating = true;
                    Animated.timing(this.state.fadeAnim, {
                        toValue: 1,
                        duration: 100,
                        easing: Easing.linear,
                    }).start(() => {
                        this.isAnimating = false
                    })
                }
                if (Platform.OS === 'ios' && flatposition < 0) {
                    //在这里可以做跳转事件
                    if (toTop && topimg.destinationUrl) {
                        RouteManager.routeJump({
                                page: routeConfig.WebView,
                                openType: 'present',
                                param: {url: topimg.destinationUrl},
                                fromRNPage: routeConfig.Home,
                            },
                        );
                    }
                } else if (Platform.OS === 'android' && flatposition === 0 && jumpflag) {
                    //在这里可以做跳转事件
                    if (toTop && topimg.destinationUrl) {
                        RouteManager.routeJump({
                                page: routeConfig.WebView,
                                openType: 'present',
                                param: {url: topimg.destinationUrl},
                                fromRNPage: routeConfig.Home,
                            },
                        );
                    }
                }
                return (
                    <View style={{height: headerHeight}}>
                        <Image style={{
                            width: ScreenUtils.screenW, height: headerHeight,
                            alignItems: 'center', resizeMode: 'stretch', paddingTop: ScreenUtils.scaleSize(44)
                        }}
                               source={{uri: topimg ? topimg.firstImgUrl : '11'}}>
                            <Animated.Image style={{
                                width: ScreenUtils.scaleSize(20), height: ScreenUtils.scaleSize(43)
                                , transform: [{
                                    rotateZ: this.state.fadeAnim.interpolate({
                                        inputRange: [0, 1],
                                        outputRange: ['0deg', '180deg']
                                    })
                                }]
                            }}
                                            source={require('../../../foundation/Img/home/icon_refresh_.png')}/>
                            <Text
                                allowFontScaling={false}
                                style={{
                                    color: '#EA513B', fontSize: ScreenUtils.setSpText(22),
                                    backgroundColor: 'transparent',
                                }}>释放即可进入...</Text></Image>
                    </View>
                );
                break;
            case RefreshState.refreshing:
                return (
                    <View style={{height: headerHeight}}>
                        <Image style={{
                            width: ScreenUtils.screenW, height: headerHeight,
                            alignItems: 'center', resizeMode: 'stretch', paddingTop: ScreenUtils.scaleSize(44)
                        }}
                               source={{uri: topimg ? topimg.firstImgUrl : '11'}}>
                            <Image style={{width: ScreenUtils.scaleSize(20), height: ScreenUtils.scaleSize(43)}}
                                   source={require('../../../foundation/Img/home/icon_refresh_.png')}/>
                            <Text
                                allowFontScaling={false}
                                style={{
                                    color: '#EA513B', fontSize: ScreenUtils.setSpText(22),
                                    backgroundColor: 'transparent',
                                }}>正在进入...</Text></Image></View>
                );
                break;
            case RefreshState.refreshdown:
                break;
            default:
                break;
        }
    };

    _foot = () => {
        return (
            <PressTextColor onPress={
                () => {
                    this._getMore();
                }
            }>
                {this.state.data.length > 1 ? <View style={{alignItems: 'center',}}>
                    {this.state.clickable ?
                        <Image
                            style={{
                                margin: ScreenUtils.scaleSize(30),
                                width: ScreenUtils.scaleSize(180),
                                height: ScreenUtils.scaleSize(106)
                            }}
                            source={require('../../../foundation/Img/home/IMG_nomore.png')}/> :
                        <Text
                            allowFontScaling={false}
                            style={{
                                color: '#999',
                                textAlign: 'center',
                                fontSize: ScreenUtils.setSpText(26),
                                margin: ScreenUtils.scaleSize(40),
                            }}>点击加载更多</Text>}
                </View> : null}
            </PressTextColor>
        );
    };

    render() {
        self = this;
        let datas = this.state.data;
        let searchtext = '';
        let searchCode = '';
        if (datas && datas.length > 1) {
            if (datas[1].componentList && datas[1].componentList.length > 1) {
                if (datas[1].componentList[0]) {
                    searchtext = datas[1].componentList[0].title;
                    searchCode = datas[1].componentList[0].codeValue;
                }
                if (datas[1].componentList[1]) {
                    this.state.ishavMsg = datas[1].componentList[1].title;
                }
            }
        }
        //网络错误
        if (!this.state.netStatus) {
            return (
                <View style={{flex: 1}}>
                    {this._renderStatus()}
                    <NetErro
                        style={{flex: 1}}
                        title={'您的网络好像很傲娇'}
                        confirmText={'刷新试试'}
                        icon={require('../../../foundation/Img/cart/img_net_error_3x.png')}
                        onButtonClick={() => {
                            //根据不同的页面做不同的请求
                            this._getData();
                        }}
                    />
                    <Toast ref="toast"/>
                </View>

            );
        }
        //异常发生
        if (!this.state.errStatus) {
            return (
                <View style={{flex: 1}}>
                    {this._renderStatus()}
                    <NetErro
                        style={{flex: 1}}
                        title={'亲,服务异常啦!'}
                        confirmText={'刷新试试'}
                        onButtonClick={() => {
                            this._getData();
                        }}
                    />
                    <Toast ref="toast"/>
                </View>
            );
        }
        return (
            <View style={{flex: 1, marginTop: 0, ...Platform.select({ios: {marginTop: -22}})}}>
                {this._renderStatus()}
                {/* 主试视图 */}
                <View style={{flex: 1, width: ScreenUtils.screenW}}>
                    <RefreshFlatList
                        removeClippedSubviews={false}
                        key={keyIndex}
                        ListFooterComponent={this._foot}
                        style={{backgroundColor: Colors.background_grey}}
                        refreshing={this.state.isRefreshing}
                        viewType={ViewType.ListView}
                        ref="vipNeedScroll"
                        renderItem={this._renderItemComponent}
                        customRefreshView={this._customerHeader}
                        showsVerticalScrollIndicator={false}
                        data={[{key: 1}, {key: 2}, {key: 3}, {key: 4}]}
                        extraData={this.state}
                        contentOffsetY={this.contentOffsetY}
                        onScroll={this.onScroll.bind(this)}
                        // style={styles.container}
                        //onEndReached={this._getMore}
                        //onEndReachedThreshold={0.1}
                        onRefreshFun={() => {
                            if (this.titleBar && Platform.OS === 'android') {
                                this.titleBar.setNativeProps({
                                    style: {opacity: 0}
                                });
                            }
                            this.setState({
                                isRefreshing: true
                            }, () => {
                                this._getData();
                            })
                        }}
                    />
                    {/*<FlatList
                     onRefresh={() => {
                     if (this.titleBar && Platform.OS === 'android') {
                     this.titleBar.setNativeProps({
                     style: {opacity: 0}
                     });
                     }
                     this.setState({
                     isRefreshing: true
                     }, () => {
                     this._getData();
                     });
                     }}
                     refreshing={this.state.isRefreshing}
                     onScroll={this.onScroll}
                     showsVerticalScrollIndicator={false}
                     style={styles.container}
                     extraData={this.state}
                     //onEndReached={this._getMore}
                     //onEndReachedThreshold={0.1}
                     data={[{key: 1}, {key: 2}, {key: 3}, {key: 4}]}
                     renderItem={this._renderItemComponent}
                     ListFooterComponent={this._foot}
                     />*/}
                </View>

                <View
                    style={[styles.seatchBar, {
                        width: ScreenUtils.screenW,
                        flexDirection: 'row',
                        justifyContent: 'space-around',
                        alignItems: 'center',
                        paddingTop: getStatusHeightHome(),
                        borderBottomWidth: this.state.searchBarState === 2 ? StyleSheet.hairlineWidth : null,
                        borderColor: this.state.searchBarState === 2 ? '#dddddd' : null,
                        height: getStatusHeightHome() + ScreenUtils.scaleSize(98)
                    }]}
                    ref={(ref) => this.titleBar = ref}
                >
                    {this.state.searchBarState === 1 ?
                        <Image source={require('../../../foundation/Img/home/bg_banner_.png')} style={{
                            width: ScreenUtils.screenW,
                            height: getStatusHeightHome() + ScreenUtils.scaleSize(98), position: 'absolute',
                            top: 0, left: 0, resizeMode: 'stretch',
                        }}/> : null}
                    <PressTextColor onPress={() => this._jump({id: 11})}>
                        <View style={styles.searchBarImgView}>
                            <Image
                                style={styles.searchBarImg}
                                source={this.state.searchBarState === 1 ? require('../../../foundation/Img/home/icon_scan_.png') : require('../../../foundation/Img/home/icon_scan_black_.png')
                                }
                            />
                            <Text
                                allowFontScaling={false}
                                style={[styles.searchBarText, this.state.searchBarState === 2 ? {color: Colors.text_black} : null]}>扫一扫</Text>
                        </View>
                    </PressTextColor>
                    <PressTextColor onPress={() => this._jump({
                        id: 0,
                        value: {
                            searchtext: searchtext,
                            searchCode: searchCode
                        }
                    })}>
                        <View style={styles.textInputView}>
                            <Image
                                style={styles.inputImg}
                                source={require('../../../foundation/Img/home/Icon_search_.png')}/>
                            <Text allowFontScaling={false} style={styles.textInput}>{searchtext}</Text>
                        </View>
                    </PressTextColor>
                    <PressTextColor onPress={() => {
                        this._jump({id: 8})
                    }}>
                        <View style={styles.searchBarImgView}>
                            <Image
                                style={styles.searchBarImg}
                                source={this.state.searchBarState === 1 ? require('../../../foundation/Img/home/Icon_Message_.png') :
                                    require('../../../foundation/Img/home/Icon_Message_Black.png')}>

                                <Image style={styles.searchBarImg}
                                       ref="msgimg"
                                       source={this.state.ishavMsg === '1' ? require('../../../foundation/Img/home/Icon_RedDotMessage_.png') :
                                           null}/>
                            </Image>
                            <Text
                                allowFontScaling={false}
                                style={[styles.searchBarText, this.state.searchBarState === 2 ? {color: Colors.text_black} : null]}>消息</Text>
                        </View>
                    </PressTextColor>
                    {/*</Image>*/}
                </View>

                <Toast ref="toast"/>
                <GuidePage blackBoardOffSet={this.state.blackBoardOffSet}
                           ref="guidePageRef"
                           showBlackboard={datas && datas.length && datas[5].componentList &&
                           datas[5].componentList.length ? true : false}
                           showVipGuide={datas && datas.length && datas[6].componentList &&
                           datas[6].componentList.length === 6 ?
                               true : false}
                           showVipGuideNeedScroll={() => this.vipGuideNeedScroll()}
                           vipOffSet={this.state.vipOffSet}/>
                <VipGuidePage vipOffSet={this.state.vipOffSet}
                              ref="vipGuidePageRef"
                              showVipGuideNeedScroll={() => this.vipGuideNeedScroll()}/>
            </View>
        )
    }

    vipGuideNeedScroll() {
        this.refs.vipNeedScroll.scrollToY(homeOffSet)
    }

    onScroll = (e) => {
        let y = e.nativeEvent.contentOffset.y;
        flatposition = y;
        this.contentOffsetY = y;
        if (y > ScreenUtils.scaleSize(1334)) {
            if (huojian === false) {
                DeviceEventEmitter.emit('huojian', true);
                huojian = true
            }
        }
        else {
            if (huojian) {
                DeviceEventEmitter.emit('huojian', false);
                huojian = false;
            }
        }
        //offset为tabview的高度
        let offset = ScreenUtils.scaleSize(98) + getStatusHeightHome();
        //滑动y开始
        let belowLimit = 0;
        //滑动的进度（0-1）
        let progressY = (y - belowLimit) / offset;
        let opacity = 1;
        if (progressY <= 0) {
            opacity = 1 - Math.abs(progressY - 0.2);
            progressY = 0;
            if (this.setState.searchBarState !== 1) {
                this.setState({
                    searchBarState: 1
                })
            }
        } else if (progressY >= 1) {
            progressY = 1;
            if (this.setState.searchBarState !== 2) {
                this.setState({
                    searchBarState: 2
                })
            }
        }
        this.titleBar && this.titleBar.setNativeProps({
            style: {
                backgroundColor: `rgba(255,255,255,${progressY})`,
                opacity: opacity
            }
        })
    };

    _tuanFooter = () => {
        return (
            <PressTextColor onPress={() => this._jump({id: 7})}>
                <View style={{
                    alignItems: 'center', marginRight: ScreenUtils.scaleSize(40),
                    marginLeft: ScreenUtils.scaleSize(20), justifyContent: 'center',
                    width: ScreenUtils.scaleSize(25),
                }}>
                    <Text
                        allowFontScaling={false}
                        style={{
                            color: '#999',
                            fontSize: ScreenUtils.setSpText(24)
                        }}>查看更多</Text>
                </View>
            </PressTextColor>
        )
    };

    _keyExtractor = (item, index) => index;

    componentWillUnmount() {
        //首页页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
        if (this.GetHomeDataRequest) this.GetHomeDataRequest.setCancled(true);
        if (this.GetMoreListDataRequest) this.GetMoreListDataRequest.setCancled(true);
    }
}
const styles = StyleSheet.create({
    blockViewStyle: {
        width: ScreenUtils.screenW,
    },
    horizontalCenter: {
        alignItems: 'center',
        backgroundColor: '#fff',
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(200),
        marginBottom: ScreenUtils.scaleSize(10),
    },
    img: {
        height: 150,
        width: ScreenUtils.screenW,
    },
    horizontalStyle: {
        flexDirection: 'row',
        width: ScreenUtils.screenW,
    },
    titleView: {
        height: 42,
        width: ScreenUtils.screenW,
        backgroundColor: '#fff',
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        //marginTop: ScreenUtils.scaleSize(20),
        //marginBottom: ScreenUtils.scaleSize(1),

        borderBottomWidth: 1,
        borderBottomColor: '#dddddd'

    },
    titleImgStyles: {
        width: ScreenUtils.scaleSize(38),
        height: ScreenUtils.scaleSize(40),
        resizeMode: 'cover',
    },
    titleTextStyle: {
        marginLeft: ScreenUtils.scaleSize(10),
        color: '#D1442C',
        fontSize: ScreenUtils.setSpText(32),
        // lineHeight: ScreenUtils.scaleSize(45),
    },
    seatchBar: {
        position: 'absolute',
        left: 0,
        top: 0,
        backgroundColor: 'transparent',
        height: ScreenUtils.scaleSize(98),
    },
    seatchBarBlack: {
        position: 'absolute',
        left: 0,
        top: 0,
        backgroundColor: '#fff',
        height: ScreenUtils.scaleSize(98),
        width: ScreenUtils.screenW,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        paddingTop: ScreenUtils.scaleSize(10),
    },
    textInputView: {
        top: 0,
        borderColor: '#DDD',
        borderWidth: ScreenUtils.scaleSize(1),
        width: ScreenUtils.scaleSize(550),
        height: ScreenUtils.scaleSize(50),
        backgroundColor: '#fff',
        // marginHorizontal: ScreenUtils.scaleSize(35),
        flexDirection: 'row',
        alignItems: 'center',
        borderRadius: ScreenUtils.scaleSize(4),
    },
    textInputViewBlack: {
        width: ScreenUtils.scaleSize(550),
        height: ScreenUtils.scaleSize(50),
        backgroundColor: '#fff',
        marginHorizontal: ScreenUtils.scaleSize(20),
        flexDirection: 'row',
        alignItems: 'center',
        borderColor: '#666',
        borderWidth: ScreenUtils.scaleSize(1),
        borderRadius: ScreenUtils.scaleSize(4),
    },
    inputImg: {
        marginHorizontal: ScreenUtils.scaleSize(10),
        width: ScreenUtils.scaleSize(22.5),
        height: ScreenUtils.scaleSize(21),
    },
    textInput: {
        flex: 1,
        padding: 0,
        color: '#999',
        fontSize: ScreenUtils.setSpText(22),
    },
    searchBarImgView: {
        width: ScreenUtils.scaleSize(100),
        alignItems: 'center',
        justifyContent: 'space-around',
    },
    searchBarImg: {
        width: ScreenUtils.scaleSize(40),
        height: ScreenUtils.scaleSize(40),
        resizeMode: 'contain',
    },
    searchBarText: {
        color: '#fff',
        fontSize: ScreenUtils.setSpText(20),
        backgroundColor: 'transparent',
        marginTop: ScreenUtils.scaleSize(5),
        //lineHeight: ScreenUtils.scaleSize(28),
    },
    searchBarTextBlack: {
        color: '#666',
        fontSize: ScreenUtils.setSpText(20),
        backgroundColor: 'transparent',
        marginTop: ScreenUtils.scaleSize(5),
        //lineHeight: ScreenUtils.scaleSize(28),
    },
    liveView: {
        paddingTop: ScreenUtils.scaleSize(20),
        justifyContent: 'center',
        backgroundColor: '#fff',
    },
    liveImgView: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(120)
    },
    navigatorItemStyle: {
        alignItems: 'center',
    },
    container: {
        backgroundColor: Colors.background_grey,
    },
    swiperItem: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(350),
    },
    combineShape: {
        width: ScreenUtils.screenW,
        marginTop: ScreenUtils.scaleSize(20),
        backgroundColor: '#fff',
        alignItems: 'center',
        paddingVertical: ScreenUtils.scaleSize(20),
    },
    flatOutView: {
        flexDirection: 'row',
        backgroundColor: '#fff',
        alignItems: 'center'
    },
    tuanViewFirst: {
        alignItems: 'center',
        paddingBottom: ScreenUtils.scaleSize(10),
        width: (ScreenUtils.screenW - 2) / 3,
        height: ScreenUtils.scaleSize(220),
        backgroundColor: '#fff'
    },
    tuanView: {
        alignItems: 'center',
        paddingBottom: ScreenUtils.scaleSize(10),
        width: (ScreenUtils.screenW - 2) / 3,
        marginLeft: ScreenUtils.scaleSize(1),
        height: ScreenUtils.scaleSize(220),
        backgroundColor: '#fff'
    },
    tuanText: {
        margin: ScreenUtils.scaleSize(10),
        width: (ScreenUtils.screenW - 4) / 3 - 20,
        fontSize: ScreenUtils.setSpText(28),
        //lineHeight: ScreenUtils.scaleSize(40),
        color: '#333'
    },
    tuanTextRed: {
        margin: ScreenUtils.scaleSize(10),
        width: (ScreenUtils.screenW - 4) / 3 - 20,
        fontSize: ScreenUtils.setSpText(28),
        //lineHeight: ScreenUtils.scaleSize(40),
        color: '#E5290D'
    },
    timelimit: {
        margin: 10,
        width: (ScreenUtils.screenW - 4) / 3 - 20,
        fontSize: 14,
        //lineHeight: 20,
        color: Colors.main_color
    },
    tuanImg: {
        resizeMode: 'contain',
        flex: 1,
        width: 60,
        height: 65
    },
    //兜马路
    interimImgStyle: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(350),
    },
    //小黑板
    smallblackboardBoxStyle: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(118),
        flexDirection: 'row',
        marginVertical: ScreenUtils.scaleSize(20),
        backgroundColor: '#fff'
    },
    smallblackboardImgStyle: {
        width: ScreenUtils.scaleSize(118),
        height: ScreenUtils.scaleSize(118),
        marginLeft: -1
    },
    //标题
    titleViewStyle: {
        width: ScreenUtils.screenW,
        height: 42,
        marginTop: 10,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.background_white,
    },
    titleImgStyle: {
        width: 20,
        height: 20,
        color: Colors.text_black,
        fontSize: Fonts.page_title_font()
    },
    timelimitBox: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(522),
        marginTop: ScreenUtils.scaleSize(20)
    },
    timelimitTop: {
        flexDirection: 'row',
        position: 'absolute',
        height: ScreenUtils.scaleSize(100),
        backgroundColor: 'transparent',
        justifyContent: 'space-between',
        alignItems: 'center',
    },
    timelimitStyle: {
        width: ScreenUtils.scaleSize(50),
        height: ScreenUtils.scaleSize(30),
        backgroundColor: '#FF8399',
        borderRadius: 4,
        marginLeft: ScreenUtils.scaleSize(10),
        marginRight: ScreenUtils.scaleSize(10)
    },
    timelimitTextStyle: {
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(28),
        textAlign: 'center',
    },
    timelimitText: {
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(32),
    }
    ,
    timelimitolon: {
        color: '#FF8399',
        fontSize: ScreenUtils.setSpText(32)
    },
    timeView: {
        flexDirection: 'row',
        marginLeft: ScreenUtils.scaleSize(10)
    },
    //标题 查看
    viewStyle: {
        flexDirection: 'row',
        position: 'absolute',
        right: ScreenUtils.scaleSize(20),
        alignItems: 'center'
    },
    viewTextStyle: {
        fontSize: Fonts.standard_normal_font(),
        color: Colors.text_light_grey
    },
    moreStyle: {
        width: 15,
        paddingTop: 35,
        marginLeft: 15,
        marginRight: 15,
        justifyContent: 'center'
    },
    choseBtn: {
        backgroundColor: '#E5290D',
        width: ScreenUtils.scaleSize(10),
        height: ScreenUtils.scaleSize(10),
        marginHorizontal: ScreenUtils.scaleSize(7),
        borderRadius: ScreenUtils.scaleSize(5),
    },
    noChoseBtn: {
        backgroundColor: '#fff',
        width: ScreenUtils.scaleSize(10),
        height: ScreenUtils.scaleSize(10),
        marginHorizontal: ScreenUtils.scaleSize(7),
        borderRadius: ScreenUtils.scaleSize(5),

    }
});
