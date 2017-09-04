/**
 * author: lu weiguo
 * 个人中心首页
 */
'use strict';
import React, {Component}from 'react'
import {
    StyleSheet,
    View,
    StatusBar,
    Platform,
    DeviceEventEmitter,
    ScrollView,
    RefreshControl,
    TouchableOpacity,
    Image
} from 'react-native'
import PersonLevelDesc from '../../../foundation/me/PersonLevelDesc';
import Colors from '../../config/colors';
import CategoryItems from '../../../foundation/me/CategoryItems';
import * as routeConfig from '../../config/routeConfig'
import RnConnect from '../../config/rnConnect';
import Global from '../../config/global';
import {Actions} from 'react-native-router-flux';
import Swiper from 'react-native-swiper';
import * as RouteManager from '../../../app/config/PlatformRouteManager';
// 引入外部组件
import LogisticalStatus from '../../../foundation/me/LogisticalStatus';
import FootItem from '../../../foundation/me/FootItem';
import History from '../../../foundation/me/History';
import PersonalComment from '../../../foundation/me/PersonalComment';
import UserInfoRequest from '../../../foundation/net/mine/UserInfoRequest';

import UserWalletOrderRequest from '../../../foundation/net/mine/UserWalletOrderRequest';
import UserOrderRequest from '../../../foundation/net/mine/UserOrderRequest';
import CheckToken from '../../../foundation/net/group/CheckToken';
import UserFootRequest from '../../../foundation/net/mine/UserFootRequest';
import ToastShow from '../../../foundation/common/ToastShow';
import routeByUrl from '../homepage/RoutePageByUrl';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil'
import {getStatusHeightHome} from '../../../foundation/common/NavigationBar';
//埋点
import {DataAnalyticsModule} from '../../config/AndroidModules';
import AdFloatingLayer from '../AdFloatinglayer';
import AdFloatingLayerRequest from '../../../foundation/net/AdFloatingLayer/AdFloatingLayer'
import GetAdShowType from '../../../foundation/net/AdFloatingLayer/GetAdShowType'
import GetAdResult from '../../../foundation/net/AdFloatingLayer/GetAdResult'
let codeValue = 'AP1706C019';
let pageVersionName = 'V1';

let key = 0;
let isShowLogin = false;//默认登录不会展示
let requestBody = {
    curr_page_no: "1"
};
export default class MePage extends Component {
    constructor(props) {
        super(props);
        this.curr_page_no = 1;
        this.state = {
            footDatas: [],       // 浏览历史记录
            userInfo: {},        // 个人信息
            pgetlist: [],         // 用户评论信息
            materialFlow: [],    // 物流查询
            walletiters: '',     // 钱包 积分
            walletquan: '',
            walletgift: "",
            walletMoney: '',
            walletOu: "",
            orderData: {},   //订单
            returnsNum: "",

            typeName: "",
            isRefreshing: false,

            orderFlow: [],   // 物流信息

            rollingCoupon: "",    //   即将过期的抵用券
            rollingSaveamt: "",     //   即将过期的积分
            personAds: [],   //个人广告位数据
            firstTime: 0,
            secondTime: 0,
            flag: true,
            AdFloatingLayerData: {}, // 浮层数据
            showAd: false,
            showCircle: false,
        };
        this.soonexpiringsaveamt = [];  //钱包轮播信息数组

    }


    _renderStatus() {
        return (
            <StatusBar
                key={key}
                translucent={true}
                barStyle={'light-content'}
                backgroundColor={'transparent'}
            />
        );
    }


    componentDidMount() {
        let self = this;
        // 个人中心  订单 钱包 最新信息
        DeviceEventEmitter.addListener('refreshOrderCenter1', () => this._refWalletAndOrder())
//        DeviceEventEmitter.addListener('refreshCartData', function () {
        //           self._refWalletAndOrder();
        //       });
        /*        DeviceEventEmitter.addListener('START_REFME', function () {
         self._refWalletAndOrder();
         });*/

    }

    /**
     * 获取浮层数据
     */
    getAdShowTypeData() {
        new GetAdShowType({contentCode: 'AP1708A001E004003'}, 'GET').start(
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
        new GetAdResult({eventNo: this.state.AdFloatingLayerData.event_no, contentCode: 'AP1708A001E004003'}, 'GET').start(
            (resp) => {
                if (resp.code === 200 && resp.data) {
                    let temp = Object.assign(this.state.AdFloatingLayerData,resp.data);
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
     * 关闭浮层
     * @private
     */
    closeAdFloatingLayer() {
        this.setState({
            AdFloatingLayerData: {},
            showAd: false
        })
    }

    /**
     * 渲染 UI 组件
     * @returns {XML}
     */
    render() {
        const {AdFloatingLayerData, showAd,showCircle} = this.state;
        this.soonexpiringsaveamt = [];
        this.soonexpiringsaveamt.push("•  您有" + this.state.rollingSaveamt + "积分即将过期");
        this.soonexpiringsaveamt.push("•  您有" + this.state.rollingCoupon + "抵用券即将过期");
        this.soonexpiringsaveamt.push("•  您有" + this.state.rollingSaveamt + "积分即将过期");
        if (this.soonexpiringsaveamt && this.soonexpiringsaveamt.length > 1) {
            DeviceEventEmitter.emit('ROLLING_MSG', '我的钱包消息滚动');
        }
        return (
            <View style={[{flex: 1}, styles.container]}>
                <ScrollView
                    style={{flex: 1, width: ScreenUtils.screenW}}
                    onScroll={this._onScroll.bind(this)}
                    scrollEventThrottle={50}
                    refreshControl={
                        <RefreshControl
                            refreshing={this.state.isRefreshing}
                            onRefresh={() => {
                                this.setState({
                                    isRefreshing: true
                                }, () => {
                                    this._renderRefresh();
                                    this.originContentHeight = -1;
                                });
                            }}
                            tintColor="#333333"
                            titleColor="#333333"
                            colors={['#ff0000', '#00ff00', '#0000ff']}
                            progressBackgroundColor="#ffffff"/>
                    }>
                    {this._renderStatus()}
                    <PersonLevelDesc
                        codeValue = {codeValue}
                        pageVersionName = {pageVersionName}
                        userInfo={this.state.userInfo}/>
                    <CategoryItems
                        kind={0}
                        returnsNum={this.state.returnsNum}
                        orderData={this.state.orderData}/>
                    {this.state.materialFlow.length ?
                        <LogisticalStatus materialFlow={this.state.materialFlow}/> : null}
                    <View style={{marginTop: 10}}>
                        <CategoryItems
                            kind={1}
                            walletiters={this.state.walletiters}
                            walletquan={this.state.walletquan}
                            walletgift={this.state.walletgift}
                            walletMoney={this.state.walletMoney}
                            walletOu={this.state.walletOu}
                            soonexpiringsaveamt={this.soonexpiringsaveamt}/>
                    </View>
                    {this._renderAd()}
                    {this._renderComment(this.state.pgetlist.length)}
                    <View style={{marginTop: 10}}>
                        <CategoryItems
                            kind={2} data={[]}
                        />
                    </View>
                    <View style={{marginTop: 10}}>
                        <History />
                        <FootItem
                            ref={(ref) => this.footItem = ref}
                            footDatas={this.state.footDatas}/>
                    </View>
                </ScrollView>
                {this._showNavigationBar()}
                {
                    AdFloatingLayerData &&  AdFloatingLayerData.open_state === 'Y' ?
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
        );
    }

    _showNavigationBar() {
        return (
            <View
                style={styles.navBarBgView}>
                <Image
                    ref={(ref) => this.topBar = ref}
                    style={styles.navBarBgImg}
                    source={require('../../../foundation/Img/me/bg_topbar_.png')}/>
                <View style={styles.navBarContent}>
                    <TouchableOpacity onPress={() => this._onSettingClick()} style={styles.setting}>
                        <Image style={styles.navBarImg}
                               source={require('../../../foundation/Img/me/icon_setting_.png')}/>
                    </TouchableOpacity>
                    <TouchableOpacity onPress={() => this._onMessageClick()} style={styles.message}>
                        <View>
                            <Image style={styles.navBarImg}
                                   source={require('../../../foundation/Img/me/icon_message_.png')}/>
                            {this.state.userInfo && this.state.userInfo.messages_count && this.state.userInfo.messages_count.result ?
                                <View style={styles.messageHintPoint}/> : null}
                        </View>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }

    /**
     * 请求个人足迹
     * @private
     */
    _getUserFoots() {
        let self = this;
        //当请求之前存在的时候，取消之前请求
        if (this.userFootRequest) {
            this.userFootRequest.setCancled(true);
        }
        //创建一个请求，参数（请求参数、请求方法）
        this.userFootRequest = new UserFootRequest(null, 'GET');
        //显示一个进度条showLoadingView()，默认不显示
        //失败后显示后台message，setShowMessage(true) 默认不显示
        this.userFootRequest.setShowMessage(false).start(
            (response) => {
                if (response.code === 200) {
                    //接口请求成功
                    if (response.data.items && response.data.items.length > 0) {
                        self.setState({
                            footDatas: response.data.items,
                            isRefreshing: false
                        });
                    } else {
                        self.setState({
                            footDatas: [],
                            isRefreshing: false
                        });
                    }

                }
            }, (erro) => {
                // console.log(erro);
                self.setState({
                    footDatas: [],
                    isRefreshing: false
                });
            });
    }

    /**
     * scrollview滑动的时候
     * @private
     */
    _onScroll(event) {
        let y = event.nativeEvent.contentOffset.y;
        let navBarHeight = ScreenUtils.scaleSize(128);
        let progress = y / navBarHeight;
        if (progress > 1) {
            progress = 1;
        }
        if (progress < 0) {
            progress = 0;
        }
        if (this.topBar) {
            this.topBar.setNativeProps({
                style: {
                    opacity: progress
                }
            });
        }
        let height = event.nativeEvent.layoutMeasurement.height;
        let contentHeight = event.nativeEvent.contentSize.height;
        if (contentHeight > height && (y + height >= contentHeight - 20)) {
            //如果满足上啦条件，并且上一次子内容高度=这一次子内容高度说明没有数据了～
            if (this.originContentHeight === contentHeight) {
                return;
            }
            this.originContentHeight = contentHeight;
            this._nextPage();
        }
    }

    _renderRefresh() {
        DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
        //请求个人信息
        this._getUserInfo();
        // //请求浏览足迹
        this._getUserFoots();
        // //请求钱包跟订单信息
        this._getWalletAndOrder();
        //请求物流信息
        this._materialFlow();
        // 请求浮层信息
        this.getAdShowTypeData();
    }

    /**
     *  判断用户是否登录状态
     *  请求网络数据
     */
    componentWillMount() {
        RnConnect.get_token((events) => {
            this._checkToken(events.token);
        });
        DeviceEventEmitter.addListener('refreshApp', (noti) => {
            if (noti.type === 'refreshToHomePage') {
                RnConnect.get_token();
            } else if (noti.type === 'refreshMePage') {
                //刷新
                isShowLogin = false;//重置登录展示状态
                this._renderRefresh();
            } else if (noti.type === 'checkMePage') {
                this._checkToken(Global.token);
            }
        });
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            userInfo: nextProps.userInfo
        })
    }

    _checkToken(token) {
        key++;
        if (this.CheckToken) {
            this.CheckToken.setCancled(true);
        }
        this.CheckToken = new CheckToken({token: token ? token : Global.token}, 'GET');
        this.CheckToken.start(
            (response) => {
                if (response.code === 200 && response.data.isLogin) {
                    //刷新
                    this._renderRefresh();
                } else {
                    this._toLogin();
                }
            }, (erro) => {
            //    this._toLogin();
            });
    }

    _toLogin() {
        // RnConnect.pushs({page: routeConfig.MePageocj_Login}, (events) => {
        //     if (events.tokenType === 'self') {
        //         //刷新
        //         this._checkToken();
        //     } else {
        //         RnConnect.get_token();
        //         RnConnect.showSign();
        //         Actions.popTo('Home');
        //     }
        // });
        if(!isShowLogin){
            isShowLogin = true;//正在展示登录
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.MePage,
            }, (event) => {
                isShowLogin = false;//重置登录状态
                if (event.tokenType === 'self') {
                    //刷新
                    this._checkToken();
                } else {
                    RnConnect.get_token();
                    RnConnect.showSign();
                    Actions.popTo('Home');
                }
            });
        }
    }

    /**
     * 获取个人信息
     * @private
     */
    _getUserInfo() {
        let self = this;
        if (this.userInfoRequest) {
            this.userInfoRequest.setCancled(true);
        }
        this.userInfoRequest = new UserInfoRequest(null, 'GET');
        this.userInfoRequest.start(
            (response) => {
                this.setState({
                    isRefreshing: false
                });
                // console.log(response.data);
                if (response.code === 200) {
                    //alert('' + response.data.check_member_info.hpd)
                    //接口请求成功
                    self.setState({
                        userInfo: response.data,
                        pgetlist: response.data.pgetlist.orderItems,
                        isRefreshing: false
                    });
                    if (response.data.person_ads) {
                        self.setState({
                            personAds: response.data.person_ads
                        });
                    } else {
                        self.setState({
                            personAds: []
                        });
                    }
                }
            }, (erro) => {
                this.setState({
                    isRefreshing: false
                });
            });
    }

    /**
     * 请求钱包跟订单信息
     * @private
     */
    _getWalletAndOrder() {
        let self = this;
        this.userWalletOrderRequest = new UserWalletOrderRequest(null, 'GET');
        this.userWalletOrderRequest.setShowMessage(false).start(
            (response) => {
                //接口请求成功
                if (response.code === 200) {
                    self.setState({
                        walletiters: response.data.left_save_amt.num,
                        walletquan: response.data.left_cust_coupon.num,
                        walletgift: response.data.left_gift_card.num,
                        walletMoney: response.data.left_deposit.num,
                        walletOu: response.data.left_ou_save_amt,

                        returnsNum: response.data.returns.result,
                        orderData: response.data.order_count,
                        isRefreshing: false,

                        rollingCoupon: response.data.rolling ? response.data.rolling.coupon : '',
                        rollingSaveamt: response.data.rolling ? response.data.rolling.saveamt : '',
                    });
                    //console.log(response.data);
                } else {
                    ToastShow.toast(response.message);
                }
            }, (erro) => {
                //   ToastShow.toast("用户钱包订单查询失败！");
            }
        );
    }

    /**
     * 刷新 钱包跟订单信息
     * @private
     */
    _refWalletAndOrder() {
        let self = this;
        this.userWalletOrderRequest1 = new UserWalletOrderRequest(null, 'GET');
        this.userWalletOrderRequest1.setShowMessage(false).start(
            (response) => {
                //接口请求成功
                if (response.code === 200) {
                    self.setState({
                        walletiters: response.data.left_save_amt.num,
                        walletquan: response.data.left_cust_coupon.num,
                        walletgift: response.data.left_gift_card.num,
                        walletMoney: response.data.left_deposit.num,
                        walletOu: response.data.left_ou_save_amt,

                        returnsNum: response.data.returns.result,
                        orderData: response.data.order_count,
                        isRefreshing: false
                    });
                } else {
                    ToastShow.toast(response.message);
                }
            }, (erro) => {
                //ToastShow.toast("查询失败！");
            }
        );
    }

    /**
     * 请求物流数据
     * @private
     */
    _materialFlow() {
        let self = this;
        if (this.UserOrderRequest) {
            this.UserOrderRequest.setCancled(true);
        }
        this.userOrderRequest = new UserOrderRequest(null, "GET");
        this.userOrderRequest.setShowMessage(false).start(
            (response) => {
                if (response.code === 200) {
                    // console.log(response);
                    //接口请求成功
                    if (response && response.data.length > 0) {
                        let len = response.data;
                        let wuliu = [];
                        for (let i = 0; i < len.length; i++) {
                            if (len[i] && len[i].logistics && len[i].logistics.length > 0) {
                                wuliu.push(len[i]);
                            }
                        }
                        self.setState({
                            materialFlow: wuliu,
                            isRefreshing: false
                        });
                    } else {
                        self.setState({
                            materialFlow: [],
                            isRefreshing: false
                        });
                    }

                }
            }, (erro) => {
                // console.log(erro);
                self.setState({
                    materialFlow: [],
                    isRefreshing: false
                });
            }
        );
    }

    /**
     * 底部加载更多
     * @private
     */
    _nextPage() {
        let self = this;
        this.curr_page_no = this.curr_page_no + 1;
        requestBody.curr_page_no = this.curr_page_no.toString();
        if (this.userFootRequest) {
            this.userFootRequest.setCancled(true);
        }
        this.userFootRequest = new UserFootRequest(requestBody, 'GET');
        this.userFootRequest.start(
            (response) => {
                // console.log(response);
                self.setState({
                    footDatas: this.state.footDatas.concat(response.data.items)
                });
            }, (erro) => {
                // console.log(erro);
            });
    }

    /**
     * 广告位结构渲染
     */
    _renderAd() {
        if (this.state.personAds && this.state.personAds.length) {
            let self = this;
            return (
                <View style={styles.adView}>
                    <Swiper
                        height={ScreenUtils.scaleSize(200)}
                        showsButtons={false}
                        index={0}
                        autoplay={false}
                        dot={
                            <View
                                style={{
                                    backgroundColor: Colors.text_white,
                                    width: 6,
                                    height: 6,
                                    borderRadius: 3,
                                    marginLeft: 3,
                                    marginRight: 3,
                                }}
                            />
                        }
                        activeDot={
                            <View
                                style={{
                                    backgroundColor: Colors.magenta,
                                    width: 6,
                                    height: 6,
                                    borderRadius: 3,
                                    marginLeft: 3,
                                    marginRight: 3,
                                    marginTop: 3,
                                    marginBottom: 3
                                }}
                            />
                        }
                        paginationStyle={{
                            bottom: 3,
                            left: 0,
                            right: 0
                        }}
                        loop={false}
                    >
                        {
                            this.state.personAds.map((item, index) => {
                                return self._renderAdImg(item, index);
                            })
                        }
                    </Swiper>
                </View>
            )
        }
    }

    //广告位图片
    _renderAdImg(item, index) {
        return (
            <TouchableOpacity activeOpacity={1} onPress={() => this._accessAd(item.DESTINATION_URL)} key={key}>
                <Image source={{uri: item.FIRST_IMG_URL}} style={styles.adImage}/>
            </TouchableOpacity>
        )
    }

    _accessAd(url) {
        if (url && url.indexOf('http') !== -1) {
            routeByUrl(url);
        }
    }

    /**
     * 展示评论信息
     * @returns {XML}
     * @private
     */

    _renderComment(num) {
        if (num > 0) {
            return (
                <View style={{marginTop: 10}}>
                    <PersonalComment  codeValue = {codeValue}
                                      pageVersionName = {pageVersionName}
                                      pgetlist={this.state.pgetlist}/>
                </View>
            )
        }
    }

    /**
     * 点击设置按钮
     * @private
     */
    _onSettingClick() {
        let date = new Date(); //点击后首先获取当前时间
        let seconds = date.getTime(); //返回从 1970 年 1 月 1 日至今的毫秒数。
        if (this.state.flag) {
            this.setState({
                firstTime: seconds,
                flag: false
            });
        } else {
            this.setState({
                secondTime: seconds,
                flag: true
            });
        }
        if (this.state.secondTime === 0) { //第一次点击时
            DataAnalyticsModule.trackEvent3('AP1706C019C005001C003001', "", {'pID': codeValue, 'vID': pageVersionName});
            // RnConnect.pushs({page: routeConfig.MePageocj_Setting}, (event) => {
            // });
            RouteManager.routeJump({
                page: routeConfig.Setting,
                fromRNPage: routeConfig.MePage,
            });
        } else { //如果是第二次点击时，就进行时间间隔控制
            if (Math.abs(this.state.secondTime - this.state.firstTime) > 1000) //如果两次点击间隔大于1秒
            {
                // RnConnect.pushs({page: routeConfig.MePageocj_Setting}, (event) => {
                // });
                RouteManager.routeJump({
                    page: routeConfig.Setting,
                    fromRNPage: routeConfig.MePage,
                });
            } else { //如果两次点击间隔小于1秒

            }
        }
    }

    /**
     * 点击message按钮
     * @private
     */
    _onMessageClick() {
        DataAnalyticsModule.trackEvent3('AP1706C019C005001A001001', "", {'pID': codeValue, 'vID': pageVersionName});
        Actions.MessageListPage({fromPage: 'MePage'});
    }

    /**
     * 即将退出页面时 结束网络请求
     */
    componentWillUnmount() {
        isShowLogin = false;//重置登录状态
        if(codeValue){
            DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
        }
        if (this.userInfoRequest) this.userInfoRequest.setCancled(true);
        if (this.userFootRequest) this.userFootRequest.setCancled(true);
        if (this.userWalletOrderRequest) this.userWalletOrderRequest.setCancled(true);
        if (this.userOrderRequest) this.userOrderRequest.setCancled(true);
        if (this.CheckToken) this.CheckToken.setCancled(true);
        DeviceEventEmitter.removeListener("refreshApp");
        DeviceEventEmitter.removeListener("refreshOrderCenter");
        DeviceEventEmitter.removeListener("START_REFME");
    }
    ;

}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: "#ededed",
        ...Platform.select({ios: {marginTop: -22}}),
    },

    noPunStyle: {
        height: 80,
        justifyContent: "center",
        alignItems: "center"
    },
    adView: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(220),
        paddingLeft: ScreenUtils.scaleSize(30),
        paddingRight: ScreenUtils.scaleSize(30),
        paddingTop: ScreenUtils.scaleSize(20)
    },
    adImage: {
        width: ScreenUtils.scaleSize(690),
        height: ScreenUtils.scaleSize(200)
    },
    navBarBgView: {
        position: 'absolute',
        top: 0,
        left: 0,
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(128),
    },
    navBarBgImg: {
        position: 'absolute',
        top: 0,
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(128),
        opacity: 0,
    },
    navBarContent: {
        justifyContent: 'space-between',
        flexDirection: 'row',
        alignSelf: 'stretch',
        backgroundColor: 'transparent',
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(128),
        paddingTop: getStatusHeightHome(),
        paddingHorizontal: ScreenUtils.scaleSize(20)
    },
    setting: {
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
        alignItems: 'center',
        justifyContent: 'center',
    },
    message: {
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
        alignItems: 'center',
        justifyContent: 'center'
    },
    navBarImg: {
        width: ScreenUtils.scaleSize(40),
        height: ScreenUtils.scaleSize(40)
    },
    messageHintPoint: {
        width: ScreenUtils.scaleSize(10),
        height: ScreenUtils.scaleSize(10),
        borderRadius: ScreenUtils.scaleSize(5),
        backgroundColor: 'white',
        position: 'absolute',
        top: ScreenUtils.scaleSize(1),
        right: ScreenUtils.scaleSize(-4)
    },
});
