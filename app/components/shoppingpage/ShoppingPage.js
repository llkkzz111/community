/**
 * Created by xiongmeng on 2017/5/1.
 * updated by Wjj on 2017/5/13
 * add a page description
 * 首屏第三个tab
 */
import React from 'react'
import {
    StyleSheet,
    Platform,
    View,
    Text,
    Image,
    ScrollView,
    TouchableOpacity,
    FlatList,
    RefreshControl,
    DeviceEventEmitter,
    StatusBar,
    NetInfo
} from 'react-native'
import {Actions} from 'react-native-router-flux';
import ViewPager from 'react-native-viewpager';
import Toast, {DURATION} from 'react-native-easy-toast';

import Fonts from '../../config/fonts';
import Colors from '../../config/colors';
import NavigationBar from '../../../foundation/common/NavigationBar';
import * as ScreenUtil from '../../../foundation/utils/ScreenUtil';
import VideoImageItem from '../../../foundation/shoppingpage/VideoImageItem';
import PreparationItem from '../../../foundation/shoppingpage/PreparationItem';
import PopularColumnItem from '../../../foundation/shoppingpage/PopularColumnItem';
import VideoNewest from '../../../foundation/shoppingpage/VideoNewest';
import BillboardItem from '../../../foundation/shoppingpage/BillboardItem';
import SelectionTitle from '../../../foundation/shoppingpage/SelectionTitle';

import GetVideoPageData from '../../../foundation/net/video/GetVideoPageData';
import Carousel from '../../../foundation/common/loop_carousel/Carousel';

import {DataAnalyticsModule} from '../../config/AndroidModules';
import * as RouteManager from '../../config/PlatformRouteManager';
import * as routeConfig from '../../config/routeConfig';
import NetErro from '../../components/error/NetErro';
import AdFloatingLayer from '../AdFloatinglayer'
import GetAdShowType from '../../../foundation/net/AdFloatingLayer/GetAdShowType'
import GetAdResult from '../../../foundation/net/AdFloatingLayer/GetAdResult'
import Swiper from 'react-native-swiper';

let codeValue = '';
let pageVersionName = '';
let self;
export default class ShoppingPage extends React.PureComponent {
    constructor(props) {
        super(props);
        this._scrollView = {};
        this.state = {
            selectTab: 0,
            data: [],
            isRefreshing: false,
            positions: {},
            other: 0,
            netStatus: true,//true:网络正常,false异常
            errStatus: true,//true:无错误,false有错误
            AdFloatingLayerData: {}, // 浮层数据
            showAd: false,
            showCircle: false,
        };
        // this.tabClick = this.tabClick.bind(this);
        this._getData = this._getData.bind(this);
    }

    componentDidMount() {
        this._getData();
        DeviceEventEmitter.addListener('showToast', () => {
            this.refs.toast.show("请先登录", DURATION.LENGTH_LONG);
        });
        DeviceEventEmitter.addListener('refreshVideoStatus', () => {
            this.setState({
                other: this.state.other + 1
            })
        });
    }

    _keyExtractor = (item, index) => index + Math.random();

    _getData() {
        NetInfo.fetch().done((status) => {
            if (status !== 'none' || status !== 'NONE') {
                this._getVideoPage();
            } else {
                this.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        })
    }

    _getVideoPage() {
        if (this.GetVideoData) {
            this.GetVideoData.setCancled(true);
        }
        this.GetVideoData = new GetVideoPageData({id: 'AP1706A046'}, 'GET');
        self.GetVideoData.showLoadingView().start(
            (response) => {
                if (response.code === 200) {
                    if (response.data && response.data.packageList) {
                        this.setState({
                            data: response.data.packageList,
                            isRefreshing: false,
                            netStatus: true,
                            errStatus: true,
                        });
                    }
                    this.getAdShowTypeData();
                    //视频页面埋点
                    codeValue = response.data.codeValue;
                    pageVersionName = response.data.pageVersionName;
                    DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                } else {
                    this.refs.toast.show(response.code, DURATION.LENGTH_LONG);
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
                // alert(this.state.errStatus);
                // console.log(erro);
            });
    }

    /**
     * 获取浮层数据
     */
    getAdShowTypeData() {
        new GetAdShowType({contentCode: 'AP1708A001E004002'}, 'GET').start(
            (resp) => {
                if (resp.code === 200 && resp.data && resp.data.open_state === 'Y') {
                    this.setState({
                        AdFloatingLayerData: resp.data,
                        showCircle: true,
                    })
                }
            })
    }


    getAdResultData() {
        new GetAdResult({
            eventNo: this.state.AdFloatingLayerData.event_no,
            contentCode: 'AP1708A001E004002'
        }, 'GET').start(
            (resp) => {
                if (resp.code === 200 && resp.data) {
                    let temp = Object.assign(this.state.AdFloatingLayerData, resp.data);
                    this.setState({
                        AdFloatingLayerData: temp,
                        showAd: true,
                        showCircle: false
                    })
                }
            },
            (error) => {
                if (Number(error.code) >= 4010 && Number(error.code) <= 4014) {
                    RouteManager.routeJump({
                        page: routeConfig.Login,
                    })
                }
            }
        )
    }

    /**
     * 渲染导航栏
     * @private
     */
    _renderNav() {
        return (
            <NavigationBar
                title={'看直播'}
                titleStyle={{
                    color: Colors.text_white,
                    fontSize: ScreenUtil.scaleSize(34),
                    backgroundColor: 'transparent',
                    alignItems: 'center',
                    includeFontPadding: false,
                }}
                navigationStyle={{
                    ...Platform.select({ios: {marginTop: -22}}),
                    height: ScreenUtil.scaleSize(128)
                }}
                showLeft={false}
                rightText="全部视频"
                onRightPress={this.shoptoAll}
                rightStyle={{
                    backgroundColor: 'transparent',
                    color: Colors.text_white,
                    fontSize: ScreenUtil.scaleSize(24),
                    justifyContent: 'center'
                }}
                rightContainerStyle={{
                    marginRight: ScreenUtil.scaleSize(30),
                }}
                barStyle={'light-content'}
                navigationBarBackgroundImage={require('../../../foundation/Img/groupbuy/Icon_brand_bg_.png')}
            />
        );
    }

    shoptoAll() {
        Actions.allVideoListPage({select: 1001});
    }

    toAllVideo(v) {
        if (v) {
            Actions.allVideoListPage({video: v});
        }
    }

    hottoAllVideo(video) {
        Actions.allVideoListPage({video: video});
        DataAnalyticsModule.trackEvent3(video.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
    }

    toMorePreparationVideo() {
        Actions.onLiveVideoPage();
    }

    tabClick(index) {

        switch (index) {
            case 0:
                this._scrollView.scrollTo({y: this.state.positions.a + 1});
                break;
            case 1:
                this._scrollView.scrollTo({y: this.state.positions.b + 1});
                break;
            case 2:
                this._scrollView.scrollTo({y: this.state.positions.c + 1});
                break;
            case 3:
                this._scrollView.scrollTo({y: this.state.positions.d + 1});
                break;
            case 4:
                this._scrollView.scrollTo({y: this.state.positions.e + 1});
                break;
            case 5:
                this._scrollView.scrollTo({y: this.state.positions.f + 1});
                break;
            case 6:
                this._scrollView.scrollTo({y: this.state.positions.g + 1});
                break;
            default:
                break;
        }
        //this._scrollView.scrollTo({y: this.positions[index] + ScreenUtil.scaleSize(330)});
    }

    _scroll(e) {
        let y = e.nativeEvent.contentOffset.y;
        if (this.state.positions.g && y >= this.state.positions.g && this.state.selectTab !== 6) {
            this.setState({
                selectTab: 6
            });
            this.refs._flatlist.scrollToEnd();
        } else if (this.state.positions.f && y < this.state.positions.g && y >= this.state.positions.f && this.state.selectTab !== 5) {
            this.setState({
                selectTab: 5
            });
            this.refs._flatlist.scrollToEnd();
        } else if (this.state.positions.e && y < this.state.positions.f && y >= this.state.positions.e && this.state.selectTab !== 4) {
            this.setState({
                selectTab: 4
            });
        } else if (this.state.positions.d && y < this.state.positions.e && y >= this.state.positions.d && this.state.selectTab !== 3) {
            this.setState({
                selectTab: 3
            });
        } else if (this.state.positions.c && y < this.state.positions.d && y >= this.state.positions.c && this.state.selectTab !== 2) {
            this.setState({
                selectTab: 2
            });
        } else if (this.state.positions.b && y < this.state.positions.c && y >= this.state.positions.b && this.state.selectTab !== 1) {
            this.setState({
                selectTab: 1
            });
            this.refs._flatlist.scrollToIndex({viewPosition: 0.5, index: 1});
        } else if (this.state.positions.a && y < this.state.positions.b && this.state.selectTab !== 0) {
            this.setState({
                selectTab: 0
            });
            this.refs._flatlist.scrollToIndex({viewPosition: 0.5, index: 1});
        }
    }

    swiperItemClick(v) {
        if (v) {
            if (v.url) {
                RouteManager.routeJump({
                    page: routeConfig.WebView,
                    param: {url: v.url},
                    fromPage: routeConfig.ShoppingPage,
                });
            }
            if (v.codeValue) {
                DataAnalyticsModule.trackEvent3(v.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
            }
        }
    }

    _renderPages1(data, pageID) {
        return (
            <TouchableOpacity
                activeOpacity={1}
                onPress={(v) => self.swiperItemClick({url: data.destinationUrl, codeValue: data.codeValue})}>
                <Image style={styles.swiperImg}
                       source={{uri: data.firstImgUrl}}/>
            </TouchableOpacity>
        )
    }

    _separatorComponent() {
        return (
            <View style={{
                width: ScreenUtil.screenW,
                backgroundColor: '#ddd',
                height: ScreenUtil.scaleSize(2)
            }}></View>
        )
    }

    //图片点击
    imgClick(video) {
        console.log(video);
        switch (video.type) {
            case 1:   //tv
                RouteManager.routeJump({
                    page: routeConfig.Video,
                    param: {id: video.id, fromPage: routeConfig.ShoppingPage}
                });
                break;
            case 2:   //网络
                Actions.VipPromotion({value: video.url});
                break;
            case 3:
                RouteManager.routeJump({
                    page: routeConfig.Video,
                    param: {id: video.id, fromPage: routeConfig.ShoppingPage}
                });
                break;
            default:
                break;
        }
    }

    /**
     * 关闭浮层
     * @private
     */
    closeAdFloatingLayer() {
        this.setState({
            AdFloatingLayerData: {},
            showAd: false
        })
    }

    render() {
        self = this;
        let datas = this.state.data;
        let lunbo = [];       //轮播
        let lives = [];       //直播
        let willAirs = [];   //即将播出
        let hots = [];       //热门栏目
        let newest = [];     //最新
        let laboratory = [];  //实验室
        let list = [];       //榜单
        let types = [];    //分类
        let titles = [];
        if (datas && datas.length > 0) {
            if (datas[0] && datas[0].componentList) {
                lunbo = datas[0].componentList;
            }
            if (datas[1] && datas[1].componentList && datas[1].componentList[0].componentList && datas[1].componentList[0].componentList.length > 0) {
                lives = datas[1].componentList[0].componentList;
                titles.push({key: 0, title: '直播'});
            }
            if (datas[2] && datas[2].componentList[0] && datas[2].componentList[0].componentList && datas[2].componentList[0].componentList.length > 0) {
                willAirs = datas[2].componentList[0].componentList; //视频带的商品在willAirs.componentList中
                titles.push({key: 1, title: '即将播出'});
            }
            if (datas[3] && datas[3].componentList && datas[3].componentList.length > 0) {
                hots = datas[3].componentList;
                titles.push({key: 2, title: '热门栏目'});
            }
            if (datas[4] && datas[4].componentList && datas[4].componentList[0].componentList && datas[4].componentList[0].componentList.length > 0) {
                newest = datas[4].componentList[0].componentList;
                titles.push({key: 3, title: '最新'});
            }
            if (datas[5] && datas[5].componentList && datas[5].componentList[0].componentList && datas[5].componentList[0].componentList.length > 0) {
                laboratory = datas[5].componentList[0].componentList;
                titles.push({key: 4, title: '实验室'});
            }
            if (datas[6] && datas[6].packageList && datas[6].packageList.length > 0) {
                list = datas[6].packageList;
                titles.push({key: 5, title: '有意思'});
            }
            if (datas[7] && datas[7].packageList && datas[7].packageList.length > 0) {
                types = datas[7].packageList;
                titles.push({key: 6, title: '分类精选'});
            }
        }

        const {AdFloatingLayerData, showAd, showCircle} = this.state

        //网络错误
        if (!this.state.netStatus) {
            return (
                <View style={{flex: 1}}>
                    {
                        /*渲染navigator*/
                        this._renderNav()

                    }
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
                <View style={styles.container}>
                    {
                        /*渲染navigator*/
                        this._renderNav()

                    }
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
        /* let titles = [{key: 0, title: '直播'}, {key: 1, title: '即将播出'}, {key: 2, title: '热门栏目'},
         {key: 3, title: '最新'}, {key: 4, title: '实验室'}, {key: 5, title: '榜单'}, {key: 6, title: '分类精选'},];*/
        return (

            <View style={styles.container}>
                {
                    /*渲染navigator*/
                    this._renderNav()

                }
                {titles.length > 0 ? <View style={styles.itemsTab}>
                    <FlatList
                        ref="_flatlist"
                        contentContainerStyle={{
                            alignItems: 'center',
                            paddingHorizontal: ScreenUtil.scaleSize(20)
                        }}
                        keyExtractor={this._keyExtractor}
                        bounces={false}
                        data={titles}
                        showsVerticalScrollIndicator={false}
                        horizontal={true}
                        showsHorizontalScrollIndicator={false}
                        renderItem={({item}) =>
                            <TouchableOpacity activeOpacity={1} style={styles.itemTab}
                                              onPress={(index) => this.tabClick(item.key)}>
                                <View style={this.state.selectTab === item.key ? styles.selectedView :
                                    styles.unselectedView}>
                                    <Text allowFontScaling={false}
                                          style={this.state.selectTab === item.key ? styles.selectedTab :
                                              styles.unSelectedTab}>{item.title}</Text></View>
                            </TouchableOpacity>
                        }
                    />
                </View> : null}
                <ScrollView
                    keyExtractor={this._keyExtractor}
                    scrollEventThrottle={20}
                    onScroll={(e) => this._scroll(e)}
                    ref={(scrollView) => {
                        this._scrollView = scrollView;
                    }}
                    showsHorizontalScrollIndicator={this.state.isRefreshing}
                    refreshControl={
                        <RefreshControl
                            refreshing={false}
                            onRefresh={() => {
                                this._getData()
                            }}
                        />
                    }
                >
                    {lunbo.length > 0 ?
                        <View style={{height: ScreenUtil.scaleSize(300)}}>
                            <Swiper
                                height={ScreenUtil.scaleSize(300)}
                                autoplayTimeout={4}
                                paginationStyle={{bottom: ScreenUtil.scaleSize(10)}}
                                dot={<View style={styles.noChoseBtn}/>}
                                activeDot={<View style={styles.choseBtn}/>}
                                loop={true}
                                autoplay={true}
                            >
                                {lunbo.map((item, index) => {
                                    return (
                                        <TouchableOpacity
                                            key={index}
                                            activeOpacity={1}
                                            onPress={(v) => self.swiperItemClick({
                                                url: item.destinationUrl,
                                                codeValue: item.codeValue
                                            })}>
                                            <Image style={styles.swiperImg}
                                                   source={{uri: item.firstImgUrl}}/>
                                        </TouchableOpacity>
                                    )
                                })
                                }
                            </Swiper>
                            <View style={{height:ScreenUtil.scaleSize(20)}}></View>
                        </View> : null
                    }

                    {/*直播*/
                    }
                    {
                        lives.length > 0 ? <View style={[styles.onLivingView, {marginTop: 0}]}
                                                 onLayout={(e) => {
                                                     this.state.positions.a = (e.nativeEvent.layout.y);
                                                 }}
                        >
                            <View style={styles.centerViewStyle}>
                                <Image source={require('../../../foundation/Img/shoppingPage/Icon_living_.png')}
                                       style={styles.livingImg}/>
                                <Text allowFontScaling={false} style={styles.onLiveTextStyle}>直播</Text>
                            </View>
                            <FlatList
                                keyExtractor={this._keyExtractor}
                                data={lives}
                                renderItem={({item, index}) => {
                                    return (
                                        <VideoImageItem imageType={'0'} videoImageItem={item} imgClick={(video) => {
                                            this.imgClick(video);
                                        }}/>
                                    )
                                }}>
                            </FlatList>
                        </View> : null
                    }
                    {/*即将播出*/
                    }
                    {
                        willAirs.length > 0 ? <View style={styles.preparationView}
                                                    onLayout={(e) => {
                                                        this.state.positions.b = (e.nativeEvent.layout.y);
                                                    }}
                        >
                            <View style={styles.centerViewStyle}>
                                <Text allowFontScaling={false} style={styles.onLiveTextStyle}>· 即将播出 ·</Text>
                            </View>

                            <FlatList
                                keyExtractor={this._keyExtractor}
                                ListFooterComponent={this._HotFoot}
                                data={willAirs}
                                renderItem={({item, index}) => {
                                    return (
                                        <PreparationItem preparationItem={item}/>
                                    )
                                }}>
                            </FlatList>
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={this.toMorePreparationVideo}>
                                <View style={{height: ScreenUtil.scaleSize(1), backgroundColor: '#EDEDED'}}/>
                                <View style={{
                                    width: ScreenUtil.screenW,
                                    paddingVertical: ScreenUtil.scaleSize(10),
                                    flexDirection: 'row',
                                    justifyContent: 'center',
                                    alignItems: 'center',
                                    height: ScreenUtil.scaleSize(74),
                                }}>
                                    <Text allowFontScaling={false} style={{
                                        marginRight: ScreenUtil.scaleSize(20),
                                        color: '#666',
                                        fontSize: ScreenUtil.setSpText(24)
                                    }}>查看节目单</Text>
                                    <Image style={{
                                        width: ScreenUtil.scaleSize(16),
                                        height: ScreenUtil.scaleSize(24)
                                    }}
                                           source={require('../../../foundation/Img/common/right.png')}/>
                                </View></TouchableOpacity>
                        </View> : null
                    }

                    {/*热门栏目*/
                    }
                    {
                        hots.length > 0 ? <View style={styles.popularColumnView}
                                                onLayout={(e) => {
                                                    this.state.positions.c = (e.nativeEvent.layout.y);
                                                }}
                        >
                            <View style={styles.centerViewStyle}>
                                <Image
                                    source={require('../../../foundation/Img/shoppingPage/Icon_popularsection_.png')}
                                    style={styles.livingImg}/>
                                <Text allowFontScaling={false} style={styles.onLiveTextStyle}>热门栏目</Text>
                            </View>

                            <FlatList
                                keyExtractor={this._keyExtractor}
                                showsHorizontalScrollIndicator={false}
                                horizontal={true}
                                data={hots}
                                renderItem={({item, index}) => {

                                    return (
                                        <PopularColumnItem popularColumnItem={item}
                                                           onClick={(i) => {
                                                               this.hottoAllVideo(i);
                                                           }}/>
                                    )
                                }}>
                            </FlatList>

                        </View> : null
                    }

                    {/*最新*/}
                    {
                        newest.length > 0 ? <View
                            onLayout={(e) => {
                                this.state.positions.d = (e.nativeEvent.layout.y);
                            }}
                            style={styles.popularColumnView}>
                            <View style={styles.centerViewStyle}>
                                <Image source={require('../../../foundation/Img/shoppingPage/Icon_neweast_@3x.png')}
                                       style={styles.livingImg}/>
                                <Text allowFontScaling={false} style={styles.onLiveTextStyle}>最新</Text>
                            </View>
                            <View style={{
                                width: ScreenUtil.screenW,
                                height: ScreenUtil.scaleSize(2),
                                backgroundColor: '#ddd'
                            }}/>
                            <View style={{backgroundColor: '#ddd'}}>
                                <FlatList data={newest}
                                          keyExtractor={this._keyExtractor}
                                          numColumns={2}
                                          renderItem={({item, index}) => {

                                              return (
                                                  <VideoNewest item={item} pressbtn={(v) => {
                                                      this.imgClick(v);
                                                  }}/>
                                              )
                                          }}
                                          ItemSeparatorComponent={this._separatorComponent}
                                >
                                </FlatList></View>
                            <TouchableOpacity activeOpacity={1} style={styles.newestVideoCount}
                                              onPress={() => {
                                                  this.toAllVideo({lgroup: '6288968517370773504'})
                                              }}>
                                <Text allowFontScaling={false} style={styles.newestVideoText}>还有更多，进去看看
                                    ＞</Text>
                            </TouchableOpacity>
                        </View> : null
                    }

                    {/*实验室*/
                    }
                    {
                        laboratory.length > 0 ? <View style={styles.popularColumnView}
                                                      onLayout={(e) => {
                                                          this.state.positions.e = (e.nativeEvent.layout.y);
                                                      }}
                        >
                            <View style={styles.centerViewStyle}>
                                <Image source={require('../../../foundation/Img/shoppingPage/Icon_laboratory_@3x.png')}
                                       style={styles.livingImg}/>
                                <Text allowFontScaling={false} style={styles.onLiveTextStyle}>实验室</Text>
                            </View>
                            <View style={{
                                width: ScreenUtil.screenW,
                                height: ScreenUtil.scaleSize(2),
                                backgroundColor: '#ddd'
                            }}/>
                            <View style={{backgroundColor: '#ddd'}}>
                                <FlatList data={laboratory}
                                          numColumns={2}
                                          keyExtractor={this._keyExtractor}
                                          renderItem={({item, index}) => {

                                              return (
                                                  <VideoNewest item={item} pressbtn={(v) => {
                                                      this.imgClick(v);
                                                  }}/>
                                              )
                                          }}
                                          ItemSeparatorComponent={this._separatorComponent}
                                >
                                </FlatList></View>
                            <TouchableOpacity activeOpacity={1} style={styles.newestVideoCount}
                                              onPress={() => {
                                                  this.toAllVideo({lgroup: '6283847057337745408'})
                                              }}>
                                <Text allowFontScaling={false} style={styles.newestVideoText}>查看更多
                                    ＞</Text>
                            </TouchableOpacity>
                        </View> : null
                    }

                    {/*有意思*/
                    }
                    {
                        list.length > 0 ? <View style={styles.popularColumnView}
                                                onLayout={(e) => {
                                                    this.state.positions.f = (e.nativeEvent.layout.y);
                                                }}
                        >
                            <View style={styles.lineCenterViewStyle}>
                                <Image source={require('../../../foundation/Img/shoppingPage/Icon_list_@3x.png')}
                                       style={styles.livingImg}/>
                                <Text allowFontScaling={false} style={styles.onLiveTextStyle}>有意思</Text>
                            </View>

                            <View style={{height: ScreenUtil.scaleSize(2), backgroundColor: '#ddd'}}/>
                            <FlatList
                                keyExtractor={this._keyExtractor}
                                data={list}
                                renderItem={({item, index}) => {

                                    return (
                                        <BillboardItem billboardItem={item} pressbtn={(v) => {
                                            this.imgClick(v);
                                        }}/>
                                    )
                                }}>
                            </FlatList>
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {
                                    this.shoptoAll()
                                }}>
                                <View style={{
                                    width: ScreenUtil.screenW,
                                    marginTop: ScreenUtil.scaleSize(20),
                                    paddingVertical: ScreenUtil.scaleSize(10),
                                    flexDirection: 'row',
                                    justifyContent: 'center',
                                    alignItems: 'center',
                                    marginBottom: ScreenUtil.scaleSize(10),
                                    borderTopWidth: 1,
                                    borderColor: '#efefef'
                                }}>
                                    <Text allowFontScaling={false} style={{
                                        marginRight: ScreenUtil.scaleSize(20),
                                        color: '#666',
                                        fontSize: ScreenUtil.setSpText(24),
                                        marginTop: ScreenUtil.scaleSize(8)
                                    }}>更多榜单</Text>
                                    <Image style={{
                                        marginTop: ScreenUtil.scaleSize(8)
                                    }} source={require('../../../foundation/Img/common/right.png')}/>
                                </View></TouchableOpacity>
                        </View> : null
                    }
                    {/*分类精选*/
                    }
                    {
                        types.length > 0 ? <View style={styles.popularColumnView}
                                                 onLayout={(e) => {
                                                     this.state.positions.g = (e.nativeEvent.layout.y);
                                                 }}
                        >
                            <View style={styles.lineCenterViewStyle}>
                                <Image source={require('../../../foundation/Img/shoppingPage/Icon_selection_@3x.png')}
                                       style={styles.livingImg}/>
                                <Text allowFontScaling={false} style={styles.onLiveTextStyle}>分类精选</Text>
                            </View>
                            <View style={{height: ScreenUtil.scaleSize(2), backgroundColor: '#ddd'}}/>

                            <SelectionTitle selections={types} pressbtn={(v) => {
                                this.imgClick(v);
                            }}/>

                            <TouchableOpacity activeOpacity={1} style={[styles.centerViewStyle, styles.moreBox]}
                                              onPress={this.shoptoAll}>
                                <Text allowFontScaling={false} style={styles.moreTextStyle}>更多视频 ＞</Text>
                            </TouchableOpacity>
                        </View> : null
                    }
                </ScrollView>
                <Toast ref="toast"/>
                {
                    AdFloatingLayerData && AdFloatingLayerData.open_state === 'Y' ?
                        <AdFloatingLayer style={{flex: 1}}
                                         ref='AdFloatingLayer'
                                         showAd={showAd}
                                         showCircle={showCircle}
                                         icon={AdFloatingLayerData.firstImgUrl}
                                         title={AdFloatingLayerData.msg}
                                         image={AdFloatingLayerData.secondImgUrl}
                                         onShow={() => this.getAdResultData()}
                                         onClose={() => this.closeAdFloatingLayer()}/>
                        :
                        null
                }
            </View>
        )
    }

    componentWillUnmount() {
        //页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }
}

// export default connect(state => ({
//     currentState: state,
// }), dispatch => ({}))(ShoppingPage)
const styles = StyleSheet.create({

    container: {
        flex: 1,
        backgroundColor: Colors.background_grey,
    },
    itemsTab: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.background_white,
        height: ScreenUtil.scaleSize(70),
        borderBottomWidth: ScreenUtil.scaleSize(1),
        borderBottomColor: '#bbb'
    },
    allContents: {
        paddingTop: ScreenUtil.scaleSize(20),
    },
    itemTab: {
        alignItems: 'center',
    },
    swiperImg: {
        height: ScreenUtil.scaleSize(300),
        width: ScreenUtil.screenW,
    },
    onLivingView: {
        backgroundColor: Colors.background_white,
        marginBottom: ScreenUtil.scaleSize(20),
        marginTop: ScreenUtil.scaleSize(20)
    },
    selectedTab: {
        marginTop: ScreenUtil.scaleSize(14),
        fontSize: ScreenUtil.setSpText(28),
        color: Colors.main_color,
    },
    unSelectedTab: {
        marginTop: ScreenUtil.scaleSize(14),
        fontSize: ScreenUtil.setSpText(28),
        color: Colors.text_dark_grey,
    },
    onLiveTitleViewStyle: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: ScreenUtil.scaleSize(80),
    },
    centerViewStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        height: ScreenUtil.scaleSize(100),
    },
    lineCenterViewStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        height: ScreenUtil.scaleSize(90),
        borderBottomWidth: 1,
        borderColor: '#efefef',
    },
    livingImg: {
        height: ScreenUtil.scaleSize(36),
        width: ScreenUtil.scaleSize(38),
    },

    onLiveTextStyle: {
        fontSize: ScreenUtil.setSpText(32),
        color: Colors.text_black,
        marginLeft: ScreenUtil.scaleSize(10),
    },
    moreBox: {
        borderTopWidth: ScreenUtil.scaleSize(2),
        borderColor: Colors.border_color,
    },
    moreTextStyle: {
        fontSize: Fonts.standard_normal_font(),
        color: Colors.text_dark_grey,
    },

    preparationView: {
        backgroundColor: Colors.background_white,
        marginBottom: ScreenUtil.scaleSize(20),
    },
    preparationTitleViewStyle: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: ScreenUtil.scaleSize(80),
    },

    preparationImg: {
        height: ScreenUtil.scaleSize(50),
        width: ScreenUtil.scaleSize(50),
    },

    preparationTextStyle: {
        fontSize: Fonts.standard_title_font(),
        color: Colors.text_black,
        marginLeft: ScreenUtil.scaleSize(10),
    },
    popularColumnView: {
        backgroundColor: Colors.background_white,
        marginBottom: ScreenUtil.scaleSize(20),
    },
    newestVideoCount: {
        height: ScreenUtil.scaleSize(80),
        alignItems: 'center',
        justifyContent: 'center',
        // flexDirection: 'row',
        borderTopWidth: 1,
        borderColor: Colors.border_color,
        marginTop: ScreenUtil.scaleSize(8)
    },
    newestVideoText: {
        color: Colors.text_dark_grey,
        fontSize: Fonts.secondary_font()
    },
    selectedView: {
        height: ScreenUtil.scaleSize(70),
        borderBottomWidth: ScreenUtil.scaleSize(3),
        borderBottomColor: Colors.main_color,
        marginHorizontal: ScreenUtil.scaleSize(20),
    },
    unselectedView: {
        height: ScreenUtil.scaleSize(70),
        marginHorizontal: ScreenUtil.scaleSize(20),
    },
    choseBtn: {
        backgroundColor: '#E5290D',
        width: ScreenUtil.scaleSize(10),
        height: ScreenUtil.scaleSize(10),
        marginHorizontal: ScreenUtil.scaleSize(7),
        borderRadius: ScreenUtil.scaleSize(5),
    },
    noChoseBtn: {
        backgroundColor: '#fff',
        width: ScreenUtil.scaleSize(10),
        height: ScreenUtil.scaleSize(10),
        marginHorizontal: ScreenUtil.scaleSize(10),
        borderRadius: ScreenUtil.scaleSize(7),

    }
});
