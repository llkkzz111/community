/**
 * Created by wangwenliang on 2017/5/5.
 */
/**
 * 商品详情主页
 */
'use strict';
import React, {Component, PureComponent} from 'react';
import {connect} from 'react-redux'
import {
    StyleSheet,
    View,
    Text,
    Image,
    TouchableOpacity,
    ScrollView,
    Dimensions,
    StatusBar,
    NetInfo,
    Platform,
    findNodeHandle,
    DeviceEventEmitter,
    Alert,
    BackAndroid,
    Animated,
    Easing
} from 'react-native';
import ViewPager from 'react-native-viewpager';
import {Actions} from 'react-native-router-flux';
import MenuModal from './classifycomponents/MenuModal';
import * as routeConfig from '../../config/routeConfig';
//图文详情，规格参数，评价详情 组件
import PicAndText from './classifycomponents/PicAndText';
import StandardNum from './classifycomponents/StandardNum';
import EvaluateAll from './classifycomponents/EvaluateAll';
//相关dialog
import GiftToastDialog from '../../../foundation/dialog/GiftToastDialog';
import CategoryDialog from '../../../foundation/dialog/CategoryDialog';
import GiftPickUpDialog from '../../../foundation/dialog/GiftPickUpDialog';
import PromotionDialog from '../../../foundation/dialog/PromotionDialog';
import JiFen from './classifycomponents/JiFen';

import ToastShow from '../../../foundation/common/ToastShow';

//相关内部组件
import GoodsDetailsVoucher from '../classificationpage/classifycomponents/GoodsDetailsVoucher';
import GoodsAddress from '../classificationpage/classifycomponents/GoodsAddress';
import AddService from './classifycomponents/AddService';
import BottomCartBar from './classifycomponents/BottomCartBar';
import NetErro from '../error/NetErro';

import ScrollTabViewComponent from './classifycomponents/ScrollTabViewComponent';
import GoodsDetailTopBar from './classifycomponents/GoodsDetailTopBar';
import GoodsDetailTopViewPager from './classifycomponents/GoodsDetailTopViewPager';

//界面item
import SaleAndVoucherItem from './classifycomponents/SaleAndVoucherItem';

//相关action
import * as classificationPageAction from '../../../app/actions/classificationpageaction/ClassificationPageAction';
//字体颜色统一引用
import Colors from '../../config/colors';
import Fonts from '../../config/fonts';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Global from '../../../app/config/global';
//网络请求
import GoodsDetailRequest from '../../../foundation/net/GoodsDetails/GoodsDetailRequest';
import VoucherRequest from '../../../foundation/net/GoodsDetails/VoucherRequest';
import SendGoodsTime from '../../../foundation/net/GoodsDetails/SendGoodsTime';
import UserFootPrintsRequest from '../../../foundation/net/GoodsDetails/UserFootPrintsRequest';
import {getStatusHeight} from '../../../foundation/common/NavigationBar';
import BuyNoticeDialog from './classifycomponents/BuyNotice';
import * as NetUtils from './classifycomponents/NetUtilsOfGoodsDetail';
//埋点
import {DataAnalyticsModule} from '../../config/AndroidModules';

import GoodsDetailNewClass from './classifycomponents/GoodsDetail';
import EvaluateClassNewClass from './classifycomponents/EvaluateClass';

import routeByUrl from '../../../app/components/homepage/RoutePageByUrl';
import * as RouteManager from '../../../app/config/PlatformRouteManager';

const {width, height} = Dimensions.get('window');
const bottomHeight = ScreenUtils.scaleSize(50);
const paddingBothSide = ScreenUtils.scaleSize(30);
const ViewPagerHeight = ScreenUtils.scaleSize(692);

/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;

//商品详情主页
export class GoodsDetailMain extends Com {
    constructor(props) {
        super(props);
        let dataSource = new ViewPager.DataSource({
            pageHasChanged: (p1, p2) => p1 !== p2,
        });
        this.state = {
            opa: 0,
            allDatas: null,
            dataSource: dataSource,
            topBackColor: 'rgba(225,225,225, 0)',
            showModal: false,
            expend: false,
            evaPage: 0,
            scrollTabViewHeight: 0,
            jumpToPic: false,
            goodsDetailsVoucherShow: false,
            goodsAddressShow: false,
            topBarShow: false,
            promotionDialogShow: false,
            refresh: false,
            voucherDatas: null,
            address: null,
            senddate: null,
            addressCode: null,
            topPage: 0,
            jifenShow: false,
            itemcode: this.props.itemcode,
            showErro: false,
            bottomButtonId: '-1',
            showNoticeBuy: false,//是否显示购物须知dialog
            showErroMsg: '您的网络好像很傲娇',
            showErroCode: null,
            showErroTopBarMsg: '网络异常',
            makeSureType: null,
            sendResponseMsg: null,
            canBack: false,
            NetWork: true,
            addServiceDialogShow: false,
            isYuYue: false,

            requestCart: false,
            goodsNum: "",
            categoryShow: false,

            giftPickUpDialogShow: false,
            giftData: [],

            //记录上一次选择的规格
            defaultSelect: {
                noStockCodes: "",
                sizeSelectStr: "",
                sizeSelectCode: "",
                colorSelectStr: "",
                colorSelectCode: "",
                colorSizeSelectStr: "",
                colorSizeSelectCode: "",
            },

            //记录用户选择的规格信息和数量信息
            showInGD: { //展示给商品详情主页面的内容
                selectStr: "",//选中的规格字符串,再次展开要传
                seq: "",
                selectStr2: "",
                selectCodeStr: "",
            },

            giftList: [
                {
                    select: false,
                    text: "还有赠品未选择，请选择赠品",
                    nextAction: "领取赠品",
                    gift_item_codes: "",//赠品编号
                    gift_unit_codes: "",//赠品规格编号
                }
            ],

            sizeColorData: null,
            heightValue: new Animated.Value(0),   //购物车动画
            springValue: new Animated.Value(0),
        };
        this.NetWork = this.haveNetWork();

        this.clearReducer = {
            // giftPickUpDialogDatas: { //赠品相关数据，输入与输出
            //     giftData: [],
            //     // show: false,//显示与否
            // },
            categoryDialog: { //规格选择，输入与输出
                // giftList: [
                //     {
                //         select: false,
                //         text: "还有赠品未选择，请选择赠品",
                //         nextAction: "领取赠品",
                //         gift_item_codes: "",//赠品编号
                //         gift_unit_codes: "",//赠品规格编号
                //     }
                // ],
                // show: false,//显示与否
                // goodsNum: "",
                // requestCart: false,
                throught: false,
                makeGiftCodes: {
                    ics: "",
                    ucs: "",
                    giftPromoNo: "",
                },
                // refreshCartNum: 0,
            },
        };

        console.log('{{{{{{{{{ action constucter.itemcode:' + this.props.itemcode);
        //埋点 进入商品详情页面埋点
        DataAnalyticsModule.trackEvent2("AP1706C032", "");
    }

    componentWillMount() {
        this.props.openCategoryDialog(this.clearReducer.categoryDialog);
        // this.props.clearGiftUpDialog(this.clearReducer.giftPickUpDialogDatas);
        // this.props.copenCategoryShow(false);

        // if (Platform.OS === 'android') {
        //     BackAndroid.addEventListener('hardwareBackPress', this.onBackAndroid);
        // }

    }

    componentDidMount() {
        this.getGoodsDetailDatas(true);
        this.getVoucherRequest();
        this.cartNumReshEmitter = DeviceEventEmitter.addListener('RFRESHGOODDETAILS', () => {
            setTimeout(() => {
                // Actions.refresh({cartGoodCount: this.props.categoryDialogData.refreshCartNum + 1});
                this.refs.BottomCartBarRef.cartNumRequest();
            }, 500);
        });

        //埋点 进入商品详情界面
        // DataAnalyticsModule.trackPageBegin("");

    }

    // onBackAndroid = () => {
    //     //监听android手机的物理返回键
    //     // RouteManager.routeBack(this.props.beforepage);
    //     return false;
    // };

    componentWillReceiveProps(nextProps) {
        let cartGoodCount = nextProps.cartGoodCount;
        if (cartGoodCount !== null && typeof cartGoodCount !== 'undefined') {
            this.refs.BottomCartBarRef.cartNumRequest();
        }

        //防止退出商品详情后 快速进入新的商品详情 展示的还是之前的商品（原因是还没有pop掉之前的就跳转导致新的商品详情展示的是老的）；
        let itemcode = nextProps.itemcode;
        if (this.state.itemcode !== itemcode) {
            // this.getGoodsDetailDatas(true);
            // this.getVoucherRequest();
            Actions.pop();
            this.setPopTiemOut = setTimeout(() => {
                Actions.GoodsDetailMain(nextProps);
            }, 500);
        }
    }

    componentWillUnmount() {

        // if (Platform.OS === 'android') {
        //     BackAndroid.removeEventListener('hardwareBackPress', this.onBackAndroid);
        // }


        this.props.openCategoryDialog(this.clearReducer.categoryDialog);
        // this.props.clearGiftUpDialog(this.clearReducer.giftPickUpDialogDatas);
        // this.props.copenCategoryShow(false);

        try {
            this.cartNumReshEmitter && this.cartNumReshEmitter.remove('RFRESHGOODDETAILS');
        } catch (err) {
            console.log('====== 移除通知失败 RFRESHGOODDETAILS');
        }

        if (this.goodsDeR) {
            this.goodsDeR.setCancled(true)
        }
        if (this.userFPR) {
            this.userFPR.setCancled(true)
        }
        if (this.sendGTR) {
            this.sendGTR.setCancled(true)
        }
        if (this.voucherR) {
            this.voucherR.setCancled(true)
        }

        //关闭当前页面的时候 清除计时器
        this.requestAddressTimeOut && clearTimeout(this.requestAddressTimeOut);
        this.canBackTime && clearTimeout(this.canBackTime);
        this.canBackTimeClick && clearTimeout(this.canBackTimeClick);
        this.timer && clearTimeout(this.timer);
        //埋点 离开商品详情界面
        // DataAnalyticsModule.trackPageEnd("");
    }

    shouldComponentUpdate(nextProps, nextState) {
        return true;
    }

    //请求颜色规格数据
    getSizeColorRequest(itemcode, addressCode, IsNewSingle) {
        NetUtils.getGoodsSizeColorRequest('GET', {
            item_code: itemcode || '',
            IsNewSingle: IsNewSingle || '',
            lcode: (addressCode && addressCode.provinceCode) ? addressCode.provinceCode : "",
            mcode: (addressCode && addressCode.cityCode) ? addressCode.cityCode : "",
            scode: (addressCode && addressCode.districtCode) ? addressCode.districtCode : "",
            // ml_msale_gb:'03', 后台说不用传
        }, (data) => {
            this.setState({sizeColorData: data});
        }, (err) => {

        });
    }

    //API.02.18.001用户行为记录接口 会员管理接口文档
    userFootPrintsRequest(allDatas) {
        if (this.userFPR) {
            this.userFPR.setCancled(true)
        }
        let req = {
            item_code: allDatas.goodsDetail.item_code || "",
            sitem_code: allDatas.goodsDetail.sitem_code || "",
            item_name: allDatas.goodsDetail.item_name || "",
            item_img_url: allDatas.goodsDetail.shareImg || "",

            item_sale_price: allDatas.goodsDetail.cust_price || "",
            item_preferential_price: allDatas.goodsDetail.last_sale_price || allDatas.goodsDetail.sale_price || "",
            item_accumulate_score: allDatas.goodsDetail.saveamt_maxget + "" || "0.0",
            item_purchase_frequency: "",

        };
        this.userFPR = new UserFootPrintsRequest(req, "POST");
        this.userFPR.start((response) => {
            if (response.code !== null && response.code === 200 && response.message !== null && response.message === "succeed") {
                // alert(JSON.stringify(response));
            } else {

            }
        }, (err) => {
            // alert("网络请求错误:" + JSON.stringify(err));
        });
    }

    //配送时效接口文档
    sendGoodsTimeRequest(addressCode) {

        if (this.sendGTR) {
            this.sendGTR.setCancled(true)
        }
        let req = {
            item_code: this.state.allDatas.goodsDetail.item_code,
            unit_code: this.state.showInGD.selectCodeStr || this.state.allDatas.goodsDetail.unit_code || (this.state.allDatas.goodsDetail.defaultTwunit && this.state.allDatas.goodsDetail.defaultTwunit.unit_Code) || "001",
            lcode: (addressCode !== null && addressCode.provinceCode !== null) ? addressCode.provinceCode : "",
            mcode: (addressCode !== null && addressCode.cityCode !== null) ? addressCode.cityCode : "",
            scode: (addressCode !== null && addressCode.districtCode !== null) ? addressCode.districtCode : "",

            ml_msale_gb: "",
            itype: "",
        };


        this.sendGTR = new SendGoodsTime(req, "GET");
        this.sendGTR.start((response) => {
            // alert("##### 配送时效：" + JSON.stringify(response));
            if (response.code !== null && response.code === 200 && response.message !== null && response.message === "succeed") {
                //获取到商品配送时效
                let msg = JSON.parse(response.data.result);
                this.setState({senddate: msg.s_msg, bottomButtonId: msg.s_status});
                if (msg.s_status === '2') { //判断是不是预约商品
                    this.setState({isYuYue: true});
                } else {
                    this.setState({isYuYue: false});
                }
                // this.setState({senddate: msg.s_msg});
            } else {

            }
        }, (err) => {
            // alert("网络请求错误:" + JSON.stringify(err));
        });
    }


    //获取抵用券网络请求
    getVoucherRequest() {
        if (this.voucherR) {
            this.voucherR.setCancled(true)
        }
        let req = {
            // area_lgroup: "38",
            // area_mgroup: "022",
            // area_sgroup: "028"
        };
        let itemcode = this.state.itemcode;
        // console.log("######### 上个页面传过来的itemcode：" + itemcode);
        this.voucherR = new VoucherRequest(req, "GET");//todo 测试完修改回去
        this.voucherR.setItemCode(itemcode);
        this.voucherR.start((response) => {
            if (response.code !== null && response.code === 200 && response.data !== null && response.data.length > 0) {
                //获取到抵用券相关信息
                // console.log("##### 抵用券请求数据：" + JSON.stringify(response));
                if (response.code === 200 && response.data !== null && response.data.length > 0) {
                    console.log('=========== voucherDatas:' + JSON.stringify(response.data));

                    let isShow = false;
                    for (let i = 0; i < response.data.length; i++) {
                        if (response.data[i].use_now === 'YES') {
                            isShow = true;
                        }
                    }
                    if (isShow) {
                        this.setState({voucherDatas: response.data});
                    }
                }
            }
        }, (err) => {
            // alert("网络请求错误:" + JSON.stringify(err));
        });
    }

    //获取商品详情主页面数据
    getGoodsDetailDatas(isFirst) {
        if (this.goodsDeR) {
            this.goodsDeR.setCancled(true)
        }
        let isBone = "";
        if (typeof this.props.isBone !== 'undefined' && this.props.isBone !== null) {
            isBone = this.props.isBone;
        }
        let req = {
            isBone: isBone
        };
        let itemcode = this.state.itemcode;
        console.log("######### 上个页面传过来的itemcode：" + itemcode);
        this.goodsDeR = new GoodsDetailRequest(req, "GET");
        this.goodsDeR.setItemCode(itemcode);
        this.goodsDeR.showLoadingView(true).start((response) => {

            //首次进入商品详情  设置 网络请求结束3秒后才允许用户点击返回键
            if (isFirst) {
                this.canBackTime = setTimeout(() => {
                    this.setState({canBack: true});
                }, 1500);
            }

            // console.log("#### 主页面网络请求数据:" + JSON.stringify(response));
            if (response.code !== null && response.code === 200 && response.data !== null) {

                if (response.data.goodsDetail.closeState === 'N') {
                    this.setState({
                        showErro: true,
                        showErroMsg: response.data.goodsDetail.showMsg || '',
                        showErroTopBarMsg: '',
                    });
                    return;
                }
                this.setState({
                    allDatas: response.data,
                    sizeColorData: response.data.colorsize,
                });

                if (response.data.button_controll === '5') {
                    this.setState({isYuYue: true});
                } else {
                    this.setState({isYuYue: false});
                }

                try {
                    this.userFootPrintsRequest(response.data);
                } catch (erro) {
                }
                this.setAddress(response.data);
            } else {


                NetInfo.isConnected.fetch().done((isConnected) => {
                    //有网络
                    if (isConnected) {
                        ToastShow.toast('服务异常');

                        this.setState({
                            showErro: true,
                            showErroTopBarMsg: '服务异常',
                            showErroMsg: ''
                        });
                    } else {
                        //网络异常
                        ToastShow.toast('网络异常');

                        this.setState({
                            showErro: true,
                            showErroTopBarMsg: '网络异常',
                            showErroMsg: ''
                        });
                    }
                });


            }
        }, (err) => {
            if (err.code !== undefined && err.code === '1010500299') {//不是寿星
                this.setState({
                    showErro: true,
                    showErroTopBarMsg: '',
                    showErroMsg: err.message !== undefined ? err.message : '',
                });

                Alert.alert('温馨提示！', err.message !== undefined ? err.message : '寿星价商品，只有本月寿星能够购买。', [


                    {
                        text: '返回', onPress: () => {

                        RouteManager.routeBack(this.props.beforepage);
                    }
                    }

                ])


            } else {


                NetInfo.isConnected.fetch().done((isConnected) => {
                    //有网络
                    if (isConnected) {
                        ToastShow.toast('服务异常');

                        this.setState({
                            showErro: true,
                            showErroTopBarMsg: '服务异常',
                            showErroMsg: ''
                        });
                    } else {
                        //网络异常
                        ToastShow.toast('网络异常');

                        this.setState({
                            showErro: true,
                            showErroTopBarMsg: '网络异常',
                            showErroMsg: ''
                        });
                    }
                });


            }
        });
    }

    //设置地址
    setAddress(allDatas) {
        let ad = allDatas.defaultTreceiver;
        if (ad && ad.area_lgroup && ad.area_mgroup && ad.area_sgroup) {

            let addressCode = {
                provinceCode: ad.area_lgroup || "",
                cityCode: ad.area_mgroup || "",
                districtCode: ad.area_sgroup || "",
            };

            this.setState({
                addressCode: addressCode,
                address: ad.addr_m,
            })
            // this.sendGoodsTimeRequest(addressCode);
        }
    }

    //全球购 购买须知
    renderBuyNotice() {
        return (
            <View style={styles.mainItemStyle}>
                <TouchableOpacity activeOpacity={0.6} style={[styles.mainI3, {alignItems: 'center'}]} onPress={() => {
                    this.setState({
                        showNoticeBuy: !this.state.showNoticeBuy
                    });
                }}>
                    <Text allowFontScaling={false}
                          style={{fontSize: ScreenUtils.setSpText(30), color: '#333',}}>购买须知</Text>

                    <Image style={styles.rightArrow} resizeMode={'contain'}
                           source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>
                </TouchableOpacity>

            </View>
        )
    }

    //render增值服务
    renderAddServiceMethod(allDatas) {
        return (
            <TouchableOpacity
                onPress={() => {

                    this.setState({addServiceDialogShow: true});

                    //埋点 点击增值服务
                    DataAnalyticsModule.trackEvent2("AP1706C032F010001A001001", "");
                }}
                activeOpacity={0.8}
                style={[styles.mainItemStyle1, {
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                    alignItems: 'flex-start',
                    paddingBottom: ScreenUtils.scaleSize(20),
                    paddingTop: ScreenUtils.scaleSize(30),
                }]}>
                <View style={{flexDirection: 'row', flexWrap: 'wrap', flex: 1}}>
                    {allDatas.itemTips.map((item, i) => {
                        return (
                            <View key={i} style={{flexDirection: 'row', alignItems: 'center', marginBottom: 6}}>

                                <Image style={{width: ScreenUtils.scaleSize(30), height: ScreenUtils.scaleSize(30)}}
                                       resizeMode={'contain'}
                                       source={require('../../../foundation/Img/icons/Icon_mark_@3x.png')}/>
                                <Text allowFontScaling={false} style={{
                                    marginRight: 30,
                                    fontSize: ScreenUtils.setSpText(26),
                                    marginLeft: ScreenUtils.scaleSize(6)
                                }}>{item.tips_title}</Text>

                            </View>
                        );
                    })}
                </View>
                <View>
                    <Image style={[styles.rightArrow, {marginTop: ScreenUtils.scaleSize(5)}]} resizeMode={'contain'}
                           source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>
                </View>

            </TouchableOpacity>
        )
    }

    //根据传入的数据来显示几颗星
    renderStars(num) {
        let arry = [];
        for (let i = 0; i < Math.ceil(num); i++) {
            arry[i] = i;
        }
        return (
            arry.map((item, i) => {
                return (
                    <View key={i}>
                        <Image style={styles.star}
                               source={require('../../../foundation/Img/icons/icon_star_lighten_@3x.png')}/>
                    </View>
                );
            })
        )
    }

    //精品评价
    renderEvaluate(scroll, allDatas) {
        // console.log(allDatas)
        return (
            <View>
                <View style={[styles.mainItemStyle, {paddingBottom: 0}]}>
                    <View style={styles.evaluateTop}>
                        <Text allowFontScaling={false}
                              style={styles.evaluateTopT1}>商品评价（{String(allDatas.comments.comment_cnt)}）</Text>
                        <Text allowFontScaling={false} style={styles.evaluateTopT2}>综合评分</Text>
                        <View style={styles.evaluateTopRightStars}>
                            {this.renderStars(allDatas.comments.comment_starcnt && Math.round(allDatas.comments.comment_starcnt))}
                        </View>
                    </View>

                    {allDatas.comments && allDatas.comments.itemCommList && allDatas.comments.itemCommList.map((item, i) => {
                        return (
                            <EvaluateClassNewClass key={i} item={item} i={i} allDatas={allDatas}/>
                        )
                    })}

                    <TouchableOpacity
                        onPress={() => {
                            Actions.GoodsDetailAllEvaluatePage({allDatas: allDatas});

                            //埋点 查看更多评价
                            DataAnalyticsModule.trackEvent2("AP1706C032F008001O008001", "");

                        }}
                        activeOpacity={0.8}
                        style={{
                            backgroundColor: '#fff',
                            height: ScreenUtils.scaleSize(73),
                            justifyContent: 'center',
                            alignItems: 'center',
                            flexDirection: 'row',
                            flex: 1
                        }}>
                        <Text allowFontScaling={false}
                              style={{fontSize: ScreenUtils.setSpText(24), color: '#666'}}
                        >查看更多</Text>
                        <Image style={{
                            width: ScreenUtils.scaleSize(16),
                            height: ScreenUtils.scaleSize(24),
                            marginLeft: ScreenUtils.scaleSize(20)
                        }} resizeMode={'stretch'}
                               source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>
                    </TouchableOpacity>
                </View>
            </View>
        );
    }

    //配送信息
    renderAddress(allDatas) {
        return (
            <View style={styles.mainItemStyle}>
                <TouchableOpacity activeOpacity={1} style={[styles.mainI3, {alignItems: 'center'}]} onPress={() => {
                    this.setState({goodsAddressShow: true});

                    //埋点 配送地址
                    DataAnalyticsModule.trackEvent2("AP1706C032F010005A001001", "");
                }}>
                    <View style={{width: width * 0.6, flexDirection: 'row', alignItems: 'center'}}>
                        <Text allowFontScaling={false}
                              style={{
                                  fontSize: ScreenUtils.scaleSize(30),
                                  marginRight: ScreenUtils.scaleSize(30),
                                  color: '#333'
                              }}>配送至 </Text>
                        <Image source={require('../../../foundation/Img/cart/location_red.png')}
                               resizeMode={'contain'}
                               style={{width: ScreenUtils.scaleSize(22), height: ScreenUtils.scaleSize(31)}}/>
                        <Text allowFontScaling={false} style={{
                            fontSize: ScreenUtils.setSpText(26),
                            color: '#666',
                            marginLeft: ScreenUtils.scaleSize(10),
                            width: width * 0.3
                        }}>{this.state.address === null ?
                            ( allDatas.defaultTreceiver &&
                                allDatas.defaultTreceiver.addr_m || "")
                            :
                            this.state.address}</Text>
                    </View>


                    <Text allowFontScaling={false} style={{
                        color: cg,
                        flex: 1,
                        textAlign: 'right',
                        marginRight: 3,
                        fontSize: ScreenUtils.setSpText(26)
                    }}>{this.state.senddate === null ?
                        (allDatas.defaultStock || "")
                        :
                        this.state.senddate}</Text>
                    <Image style={styles.rightArrow} resizeMode={'contain'}
                           source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>
                </TouchableOpacity>
            </View>
        )
    }

    //选择规格
    renderStandard(allDatas) {

        let length = this.state.giftList.length;
        let temp = 0;
        for (let i = 0; i < length; i++) {
            if (this.state.giftList[i].select) {
                temp = temp + 1;
                if (temp == 3) {
                    length = i + 1;
                }
            }
        }
        let gL = this.state.giftList;

        return (
            <View style={styles.mainItemStyle}>
                <TouchableOpacity activeOpacity={0.6} style={[styles.mainI3, {alignItems: 'center'}]} onPress={() => {
                    // this.props.copenCategoryShow(true);
                    this.setState({categoryShow: true});
                    // this.props.openCategoryDialog({//将商品详情中关于规格参数的东西给他
                    //     // show: true,
                    //     requestCart: false,
                    // });

                    this.setState({requestCart: false});
                    //埋点 选择规格
                    DataAnalyticsModule.trackEvent2("AP1706C032F010004A001001", "");
                }}>
                    <Text allowFontScaling={false}
                          style={{fontSize: ScreenUtils.setSpText(30), color: '#333',}}>选择规格</Text>

                    <View style={{flex: 1, flexDirection: 'row', justifyContent: 'flex-end', alignItems: 'center'}}>
                        <Text allowFontScaling={false} style={{
                            color: cg,
                            // flex: 1,
                            // textAlign: 'right',
                            marginRight: 3,
                            marginLeft: ScreenUtils.scaleSize(20)
                        }}>{this.state.showInGD.selectStr2 && (this.state.showInGD.selectStr2 + "，")}{this.state.goodsNum && (this.state.goodsNum + "件")}</Text>

                    </View>

                    <Image style={styles.rightArrow} resizeMode={'contain'}
                           source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>
                </TouchableOpacity>

                {(this.state.giftList.length > 0 && temp > 0) ?
                    <View style={{
                        marginTop: ScreenUtils.scaleSize(20),
                        borderTopColor: '#ddd',
                        borderTopWidth: ScreenUtils.scaleSize(2),
                        paddingTop: ScreenUtils.scaleSize(15)
                    }}>

                        {gL !== null ?
                            <View>
                                {(gL.length > 0 && gL[0].select) ? <Text allowFontScaling={false} style={{
                                    fontSize: ScreenUtils.setSpText(24),
                                    color: '#666',
                                    paddingTop: ScreenUtils.scaleSize(5)
                                }}>[商品赠品] {gL[0].text}</Text> : null}
                                {(gL.length > 1 && gL[1].select) ? <Text allowFontScaling={false} style={{
                                    fontSize: ScreenUtils.setSpText(24),
                                    color: '#666',
                                    paddingTop: ScreenUtils.scaleSize(5)
                                }}>[商品赠品] {gL[1].text}</Text> : null}
                                {(gL.length > 2 && gL[2].select) ? <Text allowFontScaling={false} style={{
                                    fontSize: ScreenUtils.setSpText(24),
                                    color: '#666',
                                    paddingTop: ScreenUtils.scaleSize(5)
                                }}>[商品赠品] {gL[2].text}</Text> : null}
                                {(gL.length > 3 && gL[3].select ) ?
                                    <Text allowFontScaling={false} style={{
                                        fontSize: ScreenUtils.setSpText(24),
                                        color: '#666'
                                    }}>．．．</Text> : null}
                            </View> : null
                        }
                    </View> : null
                }
            </View>
        )
    }

    //店铺
    renderStore(allDatas) {
        return (
            <TouchableOpacity
                onPress={() => {

                    //埋点 进入店铺
                    DataAnalyticsModule.trackEvent3("AP1706C032F008002O008001", "", {shopid: allDatas.store.gmallSetNum + ""});

                    if (allDatas.store.gmallUrl) {
                        Actions.VipPromotionGoodsDetail({value: allDatas.store.gmallUrl});
                    }
                }}
                activeOpacity={0.8}
                style={[styles.mainItemStyle, {
                    flexDirection: 'row',
                    alignItems: 'center',
                    justifyContent: 'flex-end'
                }]}>
                <View style={{flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-start', flex: 1}}>
                    <Image resizeMode={'stretch'}
                           style={{width: ScreenUtils.scaleSize(90), height: ScreenUtils.scaleSize(90)}}
                           source={{uri: (allDatas.store.gmallLogo && allDatas.store.gmallLogo.length > 0 ) ? allDatas.store.gmallLogo : ""}}/>
                    <View style={{marginLeft: ScreenUtils.scaleSize(20), width: ScreenUtils.scaleSize(400)}}>
                        <View style={{flexDirection: 'row'}}>
                            <Text allowFontScaling={false}
                                  numberOfLines={1}
                                  style={{
                                      fontSize: ScreenUtils.setSpText(30),
                                      color: '#333'
                                  }}>{allDatas.store.gmallName}
                            </Text>
                            {/*<Text style={{marginLeft:ScreenUtils.scaleSize(30)}}> 商品共{allDatas.store.gmallItemSize}件</Text>*/}
                        </View>

                        <Text allowFontScaling={false} style={{fontSize: ScreenUtils.setSpText(28), color: "#666"}}
                              numberOfLines={1}>{allDatas.store.gmallContent}</Text>
                    </View>
                </View>
                <View
                    style={{
                        justifyContent: 'center',
                        alignItems: 'center',
                        marginRight: ScreenUtils.scaleSize(1),
                        padding: ScreenUtils.scaleSize(2),
                        flexDirection: 'row',
                    }}>
                    <Text allowFontScaling={false} style={{
                        color: '#666',
                        textAlign: 'center',
                        fontSize: ScreenUtils.setSpText(26),
                    }}>进入店铺</Text>

                    <Image style={{
                        width: ScreenUtils.scaleSize(12),
                        height: ScreenUtils.scaleSize(17),
                        marginLeft: ScreenUtils.scaleSize(20)
                    }} resizeMode={'stretch'}
                           source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>

                </View>
            </TouchableOpacity>
        )
    }

    //同品推荐
    renderRecomend(allDatas) {
        return (
            <View style={styles.mainItemStyle}>
                <Text allowFontScaling={false} style={styles.recomendTopText}>同品推荐</Text>
                <ScrollView style={styles.evaSV} horizontal={true}>
                    {allDatas.otherItemJsonObj.map((item, i) => {
                        return (
                            <TouchableOpacity onPress={() => {
                                if (item.ITEM_CODE === null || item.ITEM_CODE === "") {
                                    return;
                                }
                                this.props.openCategoryDialog(this.clearReducer.categoryDialog);
                                // this.props.clearGiftUpDialog(this.clearReducer.giftPickUpDialogDatas);
                                // this.props.copenCategoryShow(false);
                                Actions.GoodsDetailMain({itemcode: item.ITEM_CODE});
                                RouteManager.cacheRNPage({itemcode: item.ITEM_CODE});
                            }} style={styles.recomendItemView} key={i}>
                                <Image style={styles.recomendItemImage} resizeMode={'contain'}
                                       source={{uri: item.url}}/>
                                <Text allowFontScaling={false} style={styles.recomendItemContent}
                                      numberOfLines={2}>{item.ITEM_NAME}</Text>
                                <View style={[styles.recomendItemViewC, {marginBottom: 0, flex: 1}]}>
                                    <View style={{flexDirection: 'row', alignItems: 'flex-end'}}>
                                        <Text allowFontScaling={false}
                                              style={{fontSize: ScreenUtils.setSpText(24), color: cr}}>¥</Text>
                                        <Text allowFontScaling={false}
                                              style={styles.recomendItemLeft}>{item.SALE_PRICE + ""}</Text>
                                    </View>
                                    {/* <Text style={styles.recomendItemRight}>已售{item.SALES_VOLUME + ""}件</Text> */}
                                </View>
                            </TouchableOpacity>
                        );
                    })}
                </ScrollView>
            </View>
        )
    }

    //判断网络状态
    haveNetWork() {

        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                this.setState({NetWork: true});
            } else {
                //网络异常
                this.setState({NetWork: false});
            }
        });

    }

    //错误页面顶部导航栏
    renderErrTopBar(title) {
        return (
            <View style={[{flexDirection: 'row', alignItems: 'center'},
                {backgroundColor: '#fff'},
                {
                    ...Platform.select({ios: {marginTop: -22}}),
                    paddingTop: getStatusHeight(),
                    paddingBottom: ScreenUtils.scaleSize(10)
                },
            ]}>

                <View style={{marginLeft: ScreenUtils.scaleSize(27)}}>
                    <TouchableOpacity
                        style={{
                            width: ScreenUtils.scaleSize(60),
                            height: ScreenUtils.scaleSize(60),
                            justifyContent: 'center',
                            alignItems: 'center'
                        }}
                        activeOpacity={1}
                        onPress={() => {



                            //无论之前是否允许点击  手动点击后2秒后允许点击
                            this.canBackTimeClick = setTimeout(() => {
                                this.setState({canBack: true});
                            }, 1500);
                            //判断是否允许点击返回键
                            if (this.state.canBack) {

                                RouteManager.routeBack(this.props.beforepage);

                                this.setState({canBack: false});
                            }


                        }}>
                        <Image style={{width: ScreenUtils.scaleSize(25), height: ScreenUtils.scaleSize(31),}}
                               source={require('../../../foundation/Img/goodsdetail/icon_back666_@3x.png')}
                               resizeMode={'contain'}/>
                    </TouchableOpacity>
                </View>
                <View style={{
                    flex: 1,
                    marginRight: ScreenUtils.scaleSize(90),
                    justifyContent: 'center',
                    alignItems: 'center'
                }}>
                    <Text allowFontScaling={false}
                          style={{fontSize: ScreenUtils.setSpText(34), color: '#333'}}>{title}</Text>
                </View>

            </View>
        );
    }

    render() {

        let allDatas = this.state.allDatas;
        if (allDatas) {

        } else {
            if (this.state.showErro) {
                return (
                    <View style={{flex: 1}}>
                        <StatusBar
                            translucent={true}
                            barStyle={'dark-content'}
                            backgroundColor={'#fff'}
                        />
                        {this.renderErrTopBar(this.state.showErroTopBarMsg)}
                        <NetErro
                            style={{flex: 1}}
                            title={this.state.showErroMsg}
                            titleStyle={{
                                paddingLeft: ScreenUtils.scaleSize(100),
                                paddingRight: ScreenUtils.scaleSize(100)
                            }}
                            confirmText={'刷新试试'}
                            onButtonClick={() => {
                                this.getGoodsDetailDatas();
                                this.getVoucherRequest();
                            }}
                        />
                    </View>
                );
            } else {
                return (
                    <View style={{flex: 1}}>
                        <StatusBar
                            translucent={true}
                            barStyle={'dark-content'}
                            backgroundColor={'#fff'}
                        />
                        {this.renderErrTopBar('')}
                        <View
                            style={{flex: 1, backgroundColor: Colors.background_grey}}
                        />
                    </View>
                );
            }
        }

        let sX = 0;
        return (

            //1 商品详情主页面
            <View style={[styles.container, {...Platform.select({ios: {marginTop: -22}})}]}>
                {/*2 商品详情顶部StatusBar*/}
                <StatusBar
                    translucent={true}
                    barStyle={'dark-content'}
                    backgroundColor={'transparent'}
                />

                {/*3 主页面scrollview*/}
                <ScrollView
                    ref={(scrollView) => {
                        this._scrollView = scrollView;
                    }}
                    showsVerticalScrollIndicator={false}
                    style={styles.scrollViewStyle}
                    scrollEventThrottle={100}
                    onScroll={(e) => {
                        let y = e.nativeEvent.contentOffset.y;
                        this.y = y;
                        //offset为tabview的高度
                        let offset = ViewPagerHeight * 0.8;
                        //滑动y开始
                        let belowLimit = 0;
                        //滑动的进度（0-1）
                        let progressY = (y - belowLimit) / offset;
                        let topShow;
                        if (progressY <= 0) {
                            progressY = 0;
                            topShow = false;
                        } else if (progressY >= 1) {
                            progressY = 1;
                            topShow = true;
                        } else {
                            topShow = false;
                        }
                        if (this.state.topBarShow !== topShow) {
                            this.setState({
                                topBarShow: topShow
                            })
                        }
                        if (this.titleBar) {
                            this.titleBar.setNativeProps({
                                style: {
                                    backgroundColor: `rgba(255,255,255,${progressY})`,
                                    borderBottomColor: progressY >= 1 ? `#dddddd` : `transparent`
                                }
                            })
                        }
                    }}
                >

                    {/*顶部图片viewpager*/}
                    <GoodsDetailTopViewPager allDatas={allDatas}
                                             scrollDetails={
                                                 () =>
                                                     this._scrollView.scrollTo({
                                                         y: this.state.scrollTabViewHeight - getStatusHeight() - (Platform.OS === 'ios' ? 22 : 0),
                                                         animated: false
                                                     })}
                    />


                    {/*8 商品主要内容*/}
                    <GoodsDetailNewClass
                        refreshData={() => {
                            this.getGoodsDetailDatas();
                            this.getVoucherRequest();
                        }}
                        allDatas={allDatas}
                        jifenShow={(e) => {
                            this.setState({jifenShow: e})
                        }}/>

                    {/*9 购买须知*/}
                    {allDatas.itemProperty !== null &&
                    allDatas.itemProperty === '2' &&
                    allDatas &&
                    allDatas.goodsDetail &&
                    allDatas.goodsDetail.global_type !== null &&
                    allDatas.goodsDetail.global_type !== 'N' &&
                    this.renderBuyNotice()}

                    {/*10 增值服务*/}
                    {allDatas.itemTips_frame !== null &&
                    allDatas.itemTips_frame !== '' &&
                    allDatas.itemTips_frame.length > 0 &&
                    allDatas.itemTips !== null &&
                    allDatas.itemTips !== "" &&
                    allDatas.itemTips.length > 0 &&
                    this.renderAddServiceMethod(allDatas)}

                    {/*11 促销和抵用券*/}
                    {(allDatas.promoms.length > 0 || this.state.voucherDatas != null  ) &&
                    <SaleAndVoucherItem
                        allDatas={allDatas}
                        voucherDatas={this.state.voucherDatas}
                        promotionDialogShow={() => {
                            this.setState({promotionDialogShow: true});
                        }}
                        goodsDetailsVoucherShow={() => {
                            this.setState({goodsDetailsVoucherShow: true});
                        }}
                    />
                    }

                    {/*12 选择规格*/}
                    {allDatas.button_controll2 !== '6' && this.renderStandard(allDatas)}

                    {/*13 选择地址*/}
                    {allDatas.button_controll2 !== '6' && this.renderAddress(allDatas)}

                    {/*14 精品评价*/}
                    {allDatas.comments !== "" && allDatas.comments && allDatas.comments.itemCommList && allDatas.comments.itemCommList.length > 0 && this.renderEvaluate(this._scrollView, allDatas)}

                    {/*15 主页面商店*/}
                    {allDatas.store.gmallYn === "Y" && allDatas.store.gmallUrl !== "" && allDatas.store.gmallUrl && this.renderStore(allDatas)}

                    {/*16 同品推荐*/}
                    {allDatas.otherItemJsonObj !== null && allDatas.otherItemJsonObj.length > 0 && this.renderRecomend(allDatas)}

                    <View onLayout={({nativeEvent: e}) => {
                        if (this.state.scrollTabViewHeight !== e.layout.y) {
                            this.setState({scrollTabViewHeight: e.layout.y});
                        }
                    }}>
                        {/*17 图文详情和商品详情描述和全部评价*/}
                        <ScrollTabViewComponent
                            scrollTabViewHeight={this.state.scrollTabViewHeight}
                            _scrollView={this._scrollView}
                            allDatas={allDatas}
                        />

                    </View>

                </ScrollView>

                {/*18 底部状态栏*/}

                <Animated.Image
                    ref="animage"
                    source={{uri: allDatas.goodsDetail.shareImg || ''}}
                    style={{
                        opacity: this.state.opa,
                        width: ScreenUtils.scaleSize(40),
                        height: ScreenUtils.scaleSize(40),
                        position: 'absolute',
                        bottom: this.state.heightValue.interpolate({
                            inputRange: [0, 0.25, 0.5, 0.75, 1],
                            outputRange: [ScreenUtils.scaleSize(60), ScreenUtils.scaleSize(160), ScreenUtils.scaleSize(250), ScreenUtils.scaleSize(160), ScreenUtils.scaleSize(60)]
                        }),
                        left: this.state.heightValue.interpolate({
                            inputRange: [0, 1],
                            outputRange: [ScreenUtils.screenW * 0.5, ScreenUtils.screenW * 0.267
                            ]
                        })
                    }}/>

                <BottomCartBar
                    springBig={this.state.springValue.interpolate({
                        inputRange: [0, 0.5, 1],
                        outputRange: [1, 1.5, 1]
                    })}
                    allDatas={allDatas}
                    categoryDialogData={this.props.categoryDialogData}
                    isYuYue={(msg) => {
                        this.setState({isYuYue: msg});
                    }}
                    openCategoryDialog={(requestCart) => {
                        // this.props.copenCategoryShow(true);
                        this.setState({categoryShow: true})
                        // this.props.openCategoryDialog({
                        //     // show: true,
                        //     requestCart: requestCart,
                        // });
                        this.setState({requestCart: requestCart});
                    }}
                    refreshGoodsDetailDatas={() => {
                        this.getGoodsDetailDatas()
                        this.getVoucherRequest();
                    }}
                    // refreshCartNum={this.props.categoryDialogData.refreshCartNum}
                    bottomButtonId={this.state.bottomButtonId}
                    sendGoodsTimeRequest={() => {
                        if (this.state.addressCode != null) {
                            this.sendGoodsTimeRequest(this.state.addressCode);
                        }
                    }}
                    addressCode={this.state.addressCode}
                    isBone={(this.props.isBone != undefined && this.props.isBone != null) ? this.props.isBone : '-1'}
                    makeSureType={(makeSureType) => {
                        this.setState({makeSureType: makeSureType});
                    }}
                    sendResponseMsg={this.state.sendResponseMsg}

                    selectCodeStr={this.state.showInGD.selectCodeStr}

                    ref="BottomCartBarRef"

                    goodsNum={this.state.goodsNum}

                />


                {/*19 商品详情顶部导航栏*/}
                <GoodsDetailTopBar
                    titleBar={(ref) => {
                        this.titleBar = ref;
                    }}
                    showModal={() => {
                        this.setState({showModal: !this.state.showModal});
                    }}
                    beforepage={this.props.beforepage}
                    topBarShow={this.state.topBarShow}
                    allDatas={allDatas}/>


                {/*20 顶部菜单modal*/}
                <MenuModal
                    allDatas={allDatas}
                    // width={60}
                    // height={100}
                    show={this.state.showModal}
                    beforepage={this.props.beforepage}
                    refreshGoodsDetailDatas={() => {
                        this.getGoodsDetailDatas();
                        this.getVoucherRequest();
                    }}
                    closeModal={(show) => {
                        this.setState({showModal: show})
                    }}/>


                {/*21 促销modal*/}
                {this.state.promotionDialogShow ?
                    <View style={{position: 'absolute', top: 0, left: 0, width: width, height: height}}>
                        <PromotionDialog
                            show={this.state.promotionDialogShow}
                            close={(e) => {
                                this.setState({promotionDialogShow: e})
                            }}
                            datas={allDatas.promoms}/>
                    </View> : null
                }


                {/*22 抵用券modal*/}
                {this.state.goodsDetailsVoucherShow ?
                    <View style={{position: 'absolute', top: 0, left: 0, width: width, height: height}}>
                        <GoodsDetailsVoucher
                            close={(e) => {
                                this.setState({goodsDetailsVoucherShow: e})
                            }}
                            show={this.state.goodsDetailsVoucherShow}
                            datas={this.state.voucherDatas}
                            allDatas={allDatas}
                            refreshGoodsDetailData={() => {
                                this.getGoodsDetailDatas();
                                this.getVoucherRequest();
                            }}
                        />
                    </View> : null
                }

                {/*23 地址modal*/}
                {this.state.goodsAddressShow ?
                    <View style={{position: 'absolute', top: 0, left: 0, width: width, height: height}}>
                        <GoodsAddress
                            datas={allDatas}
                            show={this.state.goodsAddressShow}
                            setAddress={(address) => {
                                this.setState({address: address});
                            }}
                            setAddressCode={(addressCode) => {
                                this.setState({addressCode: addressCode});
                                this.sendGoodsTimeRequest(addressCode);
                                this.getSizeColorRequest(allDatas.goodsDetail.item_code, addressCode, allDatas.goodsDetail.isNewSingle);
                            }}
                            refreshGoodsDetailDatas={() => this.getGoodsDetailDatas()}
                            setStateAddress={this.state.address}
                            setStateAddressCode={this.state.addressCode}
                            close={(e) => {
                                this.setState({goodsAddressShow: e})
                            }}/>
                    </View> : null
                }

                {/*24 增值服务modal*/}
                <AddService
                    show={this.state.addServiceDialogShow}
                    closeDialog={() => {
                        this.setState({addServiceDialogShow: false});
                    }}
                    datas={allDatas.itemTips_frame}/>


                {/*26 赠品modal*/}
                {this.state.giftPickUpDialogShow ?
                    <View style={{position: 'absolute', top: 0, left: 0, width: width, height: height}}>
                        <GiftPickUpDialog
                            openCategoryDialogShow={(show) => {
                                this.setState({categoryShow: show})
                            }}
                            openGiftPickUpDialogShow={(show) => {
                                this.setState({giftPickUpDialogShow: show});
                            }}

                            getGiftData={this.state.giftData}

                            giftList={this.state.giftList}

                            setGiftList={(list) => {
                                this.setState({giftList: list});
                            }}

                            allDatasFromMain={allDatas}/>
                    </View> : null
                }


                {/*27 积分modal*/}
                {this.state.jifenShow ?
                    <View style={{position: 'absolute', top: 0, left: 0, width: width, height: height}}>
                        <JiFen
                            datas={allDatas}
                            show={this.state.jifenShow}
                            close={(e) => {
                                this.setState({jifenShow: e})
                            }}/>
                    </View> : null
                }


                {/*28 购买须知modal*/}
                <BuyNoticeDialog
                    show={this.state.showNoticeBuy}
                    onClose={() => {
                        this.state.showNoticeBuy = false;
                    }}
                    allDatas={allDatas}
                />
                {/*25 规格component*/}
                {this.state.categoryShow ?
                    <CategoryDialog
                        allDatasFromMain={allDatas}

                        setDatas={{
                            uri: allDatas.goodsDetail.shareImg,//商品图片地址
                            price: allDatas.goodsDetail.last_sale_price || allDatas.goodsDetail.sale_price,//商品销售价格
                            num: allDatas.min_num_controll || "1",//最小限购数量
                            numLimit: this.state.isYuYue ? '1' : (allDatas.max_num_controll || "99"),//最大限购数量
                            sizeItems: (this.state.sizeColorData != null && this.state.sizeColorData.sizes ) ? this.state.sizeColorData.sizes : [],
                            colorItems: (this.state.sizeColorData != null && this.state.sizeColorData.colors) ? this.state.sizeColorData.colors : [],
                            colorsizes: (this.state.sizeColorData != null && this.state.sizeColorData.colorsizes) ? this.state.sizeColorData.colorsizes : [],//UI缺失
                        }}

                        defaultSelect={this.state.defaultSelect}
                        setDefaultSelect={(body) => {
                            this.setState({defaultSelect: body})
                        }}
                        showInGD={this.state.showInGD}
                        setShowInGD={(body) => {
                            this.setState({showInGD: Object.assign(this.state.showInGD, body)});
                        }}

                        cartNumRequest={() => {
                            this.refs.BottomCartBarRef.cartNumRequest()
                        }}
                        requestCart={this.state.requestCart}
                        goodsNum={this.state.goodsNum}
                        setGoodsNum={(num) => {
                            this.setState({goodsNum: num})
                        }}
                        openCategoryDialogShow={(show) => {
                            this.setState({categoryShow: show})
                        }}

                        openGiftPickUpDialogShow={(show) => {
                            this.setState({giftPickUpDialogShow: show});
                        }}

                        setGiftData={(data) => {
                            this.setState({giftData: data || []})
                        }}

                        giftList={this.state.giftList}

                        addressCode={this.state.addressCode}
                        makeSureType={this.state.makeSureType}
                        sendResponseMsg={(type) => {
                            this.setState({sendResponseMsg: type});
                        }}

                        startAnimated={() => {
                            this.startAnim();
                        }
                        }

                        refreshAddress={() => {
                            if (this.state.addressCode) {
                                this.requestAddressTimeOut = setTimeout(() => {
                                    this.sendGoodsTimeRequest(this.state.addressCode);
                                }, 500);
                            }
                        }}
                    /> : null
                }
            </View>
        )
    }

    /**
     * 开始购物车动画
     */
    startAnim() {
        this.state.heightValue.setValue(0);
        this.setState({
            opa: 1,
        })
        Animated.timing(this.state.heightValue, {
            toValue: 1,
            duration: 750,
            easing: Easing.linear,// 线性的渐变函数
        }).start(() => {
            this.spring();
            this.setState({
                opa: 0,
            });
        });
    }

    spring() {
        this.state.springValue.setValue(0);
        Animated.spring(
            this.state.springValue,
            {
                toValue: 1,
                firction: 1
            }).start();
    }
}

const ts12 = Fonts.tag_font();
const ts14 = Fonts.standard_normal_font();
const ts16 = Fonts.page_normal_font();
const ts18 = Fonts.page_title_font();
const cb = Colors.text_black;
const cg = Colors.text_dark_grey;
const cr = Colors.main_color;
const cy = Colors.yellow;
const styles = StyleSheet.create({
    container: {
        width: width,
        // height: height,
        flex: 1,
        backgroundColor: Colors.text_white
    },
    scrollViewStyle: {
        width: width,
        // height: height - bottomHeight,
        flex: 1,
    },
    topBar: {
        flexDirection: 'row',
        position: 'absolute',
        top: 0,
        left: 0,
        // backgroundColor:'#0f0',
        width: width,
        backgroundColor: 'rgba(225,225,225, 0)',
        alignItems: 'center',
        justifyContent: 'flex-end'
    },
    bottomBar: {
        flexDirection: 'row',
        width: width,
        height: bottomHeight,
        backgroundColor: 'white',
        alignItems: 'center',
        marginBottom: 0,
        position: 'absolute',
        bottom: 0,
    },
    topBarImage: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(36),
    },
    mainItemStyle: {
        borderBottomWidth: ScreenUtils.scaleSize(20),
        borderBottomColor: '#ededed',
        overflow: 'hidden',
        paddingTop: ScreenUtils.scaleSize(20),
        paddingLeft: paddingBothSide,
        paddingRight: paddingBothSide,
        paddingBottom: ScreenUtils.scaleSize(20),
    },
    mainItemStyle1: {
        borderBottomWidth: ScreenUtils.scaleSize(20),
        borderBottomColor: '#ededed',
        overflow: 'hidden',
        paddingTop: ScreenUtils.scaleSize(20),
        paddingLeft: paddingBothSide,
        paddingRight: paddingBothSide,
        paddingBottom: ScreenUtils.scaleSize(40),
    },
    mainItemT1: {
        fontSize: ts14,
        color: cg,
    },
    mainI3: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        // marginTop: ScreenUtils.scaleSize(10),

    },
    mainI3_1: {
        flex: 1,
        paddingLeft: 20,
        flexDirection: 'column'
    },
    rightArrow: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
        flex: 0,
        marginLeft: ScreenUtils.scaleSize(30),
    },
    mainItemT12: {
        fontSize: ScreenUtils.setSpText(24),
        color: '#fff',
    },
    evaluateTop: {
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: '#dddddd',
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingTop: 10,
        paddingBottom: 20,
    },
    evaluateTopT1: {
        color: '#444',
        flex: 0,
        fontSize: ScreenUtils.setSpText(28),
    },
    evaluateTopT2: {
        color: cr,
        flex: 1,
        textAlign: 'right',
        marginRight: 3,
        fontSize: ScreenUtils.setSpText(28),
    },
    evaluateTopRightStars: {
        // width: ScreenUtils.scaleSize(163),
        flex: 0,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        marginRight: 5
    },
    star: {
        width: ScreenUtils.scaleSize(20),
        height: ScreenUtils.scaleSize(20),
        marginLeft: 6,
    },
    star1: {
        width: ScreenUtils.scaleSize(26),
        height: ScreenUtils.scaleSize(26),
        marginLeft: 6,
    },
    evaSV: {
        width: width - paddingBothSide * 2,
        // height:90,
    },
    evaSVImage: {
        width: ScreenUtils.scaleSize(220),
        height: ScreenUtils.scaleSize(220),
        margin: 6,
    },
    recomendTopText: {
        color: cg,
        fontSize: ts16,
        marginBottom: paddingBothSide,
    },
    recomendItemView: {
        width: 140,
        marginRight: ScreenUtils.scaleSize(40),
        marginTop: ScreenUtils.scaleSize(10),
        marginBottom: ScreenUtils.scaleSize(10),
    },
    recomendItemImage: {
        width: ScreenUtils.scaleSize(300),
        height: ScreenUtils.scaleSize(300),
        marginBottom: ScreenUtils.scaleSize(14),
    },
    recomendItemContent: {
        marginBottom: 3,
        color: '#333',
        fontSize: ScreenUtils.setSpText(24),
    },
    recomendItemViewC: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-end',
    },
    recomendItemLeft: {
        color: cr,
        fontSize: ScreenUtils.setSpText(34),
    },
    recomendItemRight: {
        color: cg,
        fontSize: ScreenUtils.setSpText(22),
    },
    tabContainer: {
        flex: 1,
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center'
    }
});
let dis = (dispatch) => {
    return ({
        openCategoryDialog: (data) => dispatch(classificationPageAction.categoryDialogDatas(data)),
        // copenCategoryShow: (data) => dispatch(classificationPageAction.categoryShow(data)),
        // clearGiftUpDialog: (data) => dispatch(classificationPageAction.giftPickUpDialogDatas(data)),
    })
}
export default connect(state => ({
        // getGiftPickUpDialogDatas: state.ClassificationPageReducer.giftPickUpDialogDatas,
        // categoryDialogShow: state.ClassificationPageReducer.categoryShow,
        // giftPickUpDialogShow: state.ClassificationPageReducer.giftshow,
        categoryDialogData: state.ClassificationPageReducer.categoryDialog,
    }),
    dispatch => dis
)(GoodsDetailMain)
