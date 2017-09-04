/**
 * Created by wangwenliang on 2017/5/30.
 */

import {
    StyleSheet,
    View,
    Dimensions,
    Text,
    Image,
    TouchableOpacity,
    Linking,
    Alert,
    DeviceEventEmitter,
    Animated
} from 'react-native'
import {
    routeConfig,
    RouteManager,
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Colors,
    Actions,
    DataAnalyticsModule,
    Global,
} from '../../../config/UtilComponent';

import GoodsSaveRequest from '../../../../foundation/net/GoodsDetails/GoodsSaveRequest';
import GoodsUnSaveRequest from '../../../../foundation/net/GoodsDetails/GoodsUnSaveRequest';
import CartNumRequest from '../../../../foundation/net/GoodsDetails/CartNumRequest';
import KeFuRequest from '../../../../foundation/net/GoodsDetails/KeFuRequest';
import AddCartRequest from '../../../../foundation/net/GoodsDetails/AddCartRequest';
import CheckUseEmpDiscountRequest from '../../../../foundation/net/GoodsDetails/CheckUseEmpDiscountRequest';
import AddToCartAtOnceRequest from '../../../../foundation/net/GoodsDetails/AddToCartAtOnceRequest';

import ToastShow from '../../../../foundation/common/ToastShow';
import SendGoodsTime from '../../../../foundation/net/GoodsDetails/SendGoodsTime';
import CheckToken from '../../../../foundation/net/group/CheckToken';
import CartShowErroMessage from './CartShowErroMessage';

import Notification from '../../../constants/NotificationCenterInfo';
const {width} = Dimensions.get('window');

const PUTONG_LIJIGOUMAI = 'PUTONG_LIJIGOUMAI'; //普通立即购买
const PUTONG_JIARUGOUWUCHE = 'PUTONG_JIARUGOUWUCHE'; //普通加入购物车
const TESHU_LIJIGOUMAI = 'TESHU_LIJIGOUMAI'; //特殊 立即购买
const MIAOSHA = 'MIAOSHA'; //秒杀
const MIAOSHA_WEIKAISHI = 'MIAOSHA_WEIKAISHI'; //秒杀未开始
const YUSHOU = 'YUSHOU'; //预售
const YUYUE = 'YUYUE'; //预约
const BODADIANHUA = 'BODADIANHUA'; //拨打电话
const WUHUO = 'WUHUO'; //无货
const JUMP_GOUWUCHE = 'JUMP_GOUWUCHE';//跳转购物车
const KEFU_JUMP_REQUEST = 'KEFU_JUMP_REQUEST'; //客服 并请求网络
const SHOUCANG = 'SHOUCANG';//收藏

/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;

//内部封装动态显示时间，目前精确到天和小时和分钟
class ShowTime extends Com {

    constructor(props) {
        super(props);
        this.state = {
            // nowTime: (new Date()).valssueOf(),
            nowTime: parseInt(this.props.allDatas.goodsDetail.system_current_dt),
            circleRadius: ScreenUtils.scaleSize(10)
        }
    }

    componentDidMount() {
        this.timer = setInterval(
            () => {
                // this.setState({nowTime: (new Date()).valueOf()})
                this.setState({nowTime: this.state.nowTime + 1000});
                // console.log('#####把一个定时器的引用挂在this上:' + this.state.nowTime);
            },
            1000
        );
    }

    componentWillUnmount() {
        // 如果存在this.timer，则使用clearTimeout清空。
        // 如果你使用多个timer，那么用多个变量，或者用个数组来保存引用，然后逐个clear
        this.timer && clearInterval(this.timer);
        DeviceEventEmitter.removeListener('DELCET_COLLECT_GOODS');
        this.changeNum && clearTimeout(this.changeNum);
    }

    render() {
        // this.getTime();

        if (this.props.allDatas.goodsDetail.disp_start_dt === null || this.props.allDatas.goodsDetail.disp_start_dt === "") {
            this.props.changeId();
            this.props.refreshGoodsDetailDatas();
        }
        let sendTime = parseInt(this.props.allDatas.goodsDetail.disp_start_dt);


        let nowTime = parseInt(this.state.nowTime);
        // console.log("#######:" + nowTime);
        let time = sendTime - nowTime;

        //倒计时结束后 会改变底部状态栏的状态，并且重新刷整个商品详情页面
        if (time < 0 || time === 0) {
            this.props.changeId();
            this.props.refreshGoodsDetailDatas();
        }
        let temp1 = time % (24 * 3600 * 1000);
        let hours = Math.floor(time / (3600 * 1000));
        let temp2 = temp1 % (3600 * 1000);
        let minutes = Math.floor(temp2 / (60 * 1000));

        let temp3 = temp2 % (60 * 1000);
        let seconds = Math.round(temp3 / 1000);

        return (
            <View>
                <Text allowFontScaling={false}
                      style={styles.textW}>还有{hours + ''}:{minutes + ''}:{seconds + ''}开始秒杀</Text>
            </View>
        )
    }
}

export default class BottomCartBar extends Com {

    constructor(props) {
        super(props);
        this.state = {
            id: this.props.allDatas.button_controll,
            save: (this.props.allDatas.isFavorite == 'N' || this.props.allDatas.isFavorite == null) ? false : true,
            cartNum: 0,
            // url:"",
            dcrate_yn: "0",
            // refreshCartNum: this.props.refreshCartNum,
            token: "aaa",
            bottomButtonId: this.props.bottomButtonId,
            addressCode: this.props.addressCode,
            sendResponseMsg: this.props.sendResponseMsg,
            canClick: true,
            selectCodeStr: this.props.selectCodeStr,
            goodsNum: this.props.goodsNum,
        }
        // console.log("------> isFavorite:"+this.props.allDatas.isFavorite);
        this.renderBtn = this.renderBtn.bind(this);
        this.cartNumRequest = this.cartNumRequest.bind(this);
        this.cartNumRequest();

    }

    componentDidMount() {
        let bc2 = (this.props.allDatas.button_controll2 !== undefined && this.props.allDatas.button_controll2 !== null && this.props.allDatas.button_controll2) || '-1';
        if (bc2 === '6') {
            this.setState({id: '6'});
        }
    }

    componentWillUnmount() {
        // 如果存在this.timer，则使用clearTimeout清空。
        // 如果你使用多个timer，那么用多个变量，或者用个数组来保存引用，然后逐个clear
        this.canClickTimer && clearTimeout(this.canClickTimer);
    }

    componentWillReceiveProps(nextProps) {

        if (this.state.goodsNum !== nextProps.goodsNum) {
            this.setState({goodsNum: nextProps.goodsNum});
        }

        if (this.state.selectCodeStr !== nextProps.selectCodeStr) {
            this.setState({selectCodeStr: nextProps.selectCodeStr})
        }

        if (Global.token !== this.state.token) {
            this.setState({token: Global.token});

            let bc2 = (nextProps.allDatas.button_controll2 !== undefined && nextProps.allDatas.button_controll2 !== null && nextProps.allDatas.button_controll2) || '-1';
            if (bc2 === '6') {
                this.setState({id: '6'});
            } else {
                this.setState({id: nextProps.allDatas.button_controll});
            }
            this.cartNumRequest();
        }

        // if (this.state.refreshCartNum !== nextProps.refreshCartNum) {
        //     this.setState({refreshCartNum: nextProps.refreshCartNum});
        //     this.cartNumRequest();
        // }

        if (this.state.bottomButtonId !== nextProps.bottomButtonId) {
            this.changButtonId(nextProps.bottomButtonId);
            this.setState({bottomButtonId: nextProps.bottomButtonId});
        }

        let sa = this.state.addressCode;
        let na = nextProps.addressCode;
        if (this.state.addressCode !== nextProps.addressCode || (na !== null && sa !== null && (sa.provinceCode !== na.provinceCode || sa.cityCode !== na.cityCode || sa.districtCode !== na.districtCode))) {
            this.setState({addressCode: nextProps.addressCode});
        }

        if (this.state.sendResponseMsg !== nextProps.sendResponseMsg && nextProps.sendResponseMsg) {
            this.setState({sendResponseMsg: nextProps.sendResponseMsg});
            this.automateClick(nextProps.sendResponseMsg);
        }

    }

    changButtonId(id) {

        let bc2 = (this.props.allDatas.button_controll2 !== undefined && this.props.allDatas.button_controll2 !== null && this.props.allDatas.button_controll2) || '-1';
        if (bc2 === '6') {
            this.setState({id: '6'});
            return;
        }

        if (id === '0') { //无货 不可预约
            // this.setState({id:'7'});
            ToastShow.toast('库存不足，请重新选择规格或地区');
        } else if (id === '1') {// 有货

            this.changeToRealType();

        } else if (id === '2') {//无货 可预约
            this.setState({id: '5'})
        }
    }

    //根据button_controll2来判断商品原来的类型
    changeToRealType() {
        let bc2 = (this.props.allDatas.button_controll2 !== undefined && this.props.allDatas.button_controll2 !== null && this.props.allDatas.button_controll2) || '-1';
        if (bc2 === '0' || bc2 === 'N') { //普通商品
            this.setState({id: '0'});
        } else if (bc2 === '1') { //特殊立即购买商品
            this.setState({id: '1'});
        } else if (bc2 === '2') { //秒杀商品 未开始
            this.setState({id: '2'});
        } else if (bc2 === '3') { //秒杀商品 已开始
            this.setState({id: '3'});
        } else if (bc2 === '4') { //预售商品
            this.setState({id: '4'});
        } else if (bc2 === '6') { //拨打电话商品
            this.setState({id: '6'});
        }
    }


    automateClick(type) {
        switch (type) {
            case PUTONG_LIJIGOUMAI: //普通立即购买
                this.sendGoodsTimeRequest(this.state.addressCode, '0');
                break;
            case TESHU_LIJIGOUMAI: //特殊立即购买
                this.sendGoodsTimeRequest(this.state.addressCode, '1');
                break;
            case MIAOSHA: //秒杀
                this.sendGoodsTimeRequest(this.state.addressCode, '3');
                break;
            case YUSHOU: //预售
                this.sendGoodsTimeRequest(this.state.addressCode, '4');
                break;
            case YUYUE: //预约
                this.sendGoodsTimeRequest(this.state.addressCode, '5');
                break;
        }
    }


    //跳转：预约 ；
    jumpToYuYueClick(msg) {
        // if (Global.token === '' || Global.tokenType === 'guest') {
        //     RnConnect.pushs({page: RouteConfig.MePageocj_Login}, ((event) => {
        //         if (event.tokenType === "self") {
        //             this.props.refreshGoodsDetailDatas();
        //         }
        //     }));
        // } else {
        //  RouteManager.routeJump({
        //      page: routeConfig.Login,
        //      fromRNPage:routeConfig.GoodsDetailMain,
        //  },(event)=>{
        //      if (event.tokenType === "self") {
        //          this.props.refreshGoodsDetailDatas();
        //      }
        //  });
        let noCS = false;
        let colorsize = this.props.allDatas.colorsize;
        if ((colorsize.sizes !== null && colorsize.sizes.length === 0) && (colorsize.colorsizes !== null && colorsize.colorsizes.length === 0) && (colorsize.colors !== null && colorsize.colors.length === 0)) {
            noCS = true;
        } else if (colorsize.sizes === null && colorsize.colorsizes === null && colorsize.colors === null) {
            noCS = true;
        }

            if (this.props.categoryDialogData.throught || noCS) {

                let item_code = this.props.allDatas.goodsDetail.item_code || "";
                let item_units = this.state.selectCodeStr || this.props.allDatas.goodsDetail.unit_code || (this.props.allDatas.goodsDetail.defaultTwunit && this.props.allDatas.goodsDetail.defaultTwunit.unit_Code ) || "001";
                let gift_item_code = this.props.categoryDialogData.makeGiftCodes.ics || this.props.allDatas.gift_item_code || "";
                let gift_unit_code = this.props.categoryDialogData.makeGiftCodes.ucs || this.props.allDatas.gift_unit_code || "";
                let giftPromoNo = this.props.categoryDialogData.makeGiftCodes.giftPromoNo || "";
                let shopNo = this.props.allDatas.store.gmallSetNum || "";
                let giftPromo_seq = this.props.allDatas.giftPromo_seq || "";

                let params = {
                    item_code: item_code,
                    unit_code: item_units,
                    qty: this.state.goodsNum || "1",
                    shop_no: shopNo,
                    memberPromo: (this.props.isBone !== undefined && this.props.isBone !== null && this.props.isBone === '1') ? this.props.isBone : "",
                    gift_item_code: gift_item_code,
                    gift_unit_code: gift_unit_code,
                    giftPromo_no: giftPromoNo,
                    giftPromo_seq: giftPromo_seq,
                    receiver_seq: "",
                };
                //if (Platform.OS === 'ios') {
                //    setTimeout(() => {
                //        RnConnect.pushs({
                //            page: RouteConfig.GoodsDetailMainocj_Reserve,
                //            param: params
                //        }, (event) => {
                //            //跳转到预约订单页面
                //            // console.log('====== 预约返回值：'+JSON.stringify(event));
                //            NativeRouter.nativeRouter(event)
                //        });
                //    }, 500);
                //} else {
                //    RnConnect.pushs({
                //        page: RouteConfig.GoodsDetailMainocj_Reserve,
                //        param: params
                //    }, (event) => {
                //        //跳转到预约订单页面
                //        // console.log('====== 预约返回值：'+JSON.stringify(event));
                //        NativeRouter.nativeRouter(event)
                //    });
                //}
                RouteManager.routeJump({
                    page: routeConfig.Reserve,
                    param: params,
                    fromRNPage: routeConfig.GoodsDetailMain,
                })
            } else {
                this.props.isYuYue(true);
                //如果没有选择 打开规格弹窗
                this.props.openCategoryDialog(false);
            }
        // }
    }

    //跳转： 秒杀、预售、立即购买；
    jumpClick(msg) {
        // if (Global.token === '' || Global.tokenType === 'guest') {
        //     RnConnect.pushs({page: RouteConfig.MePageocj_Login}, ((event) => {
        //         if (event.tokenType === "self") {
        //             this.props.refreshGoodsDetailDatas();
        //         }
        //     }));
        // } else {
            // 赠品编号字符串，item_code + "_" + unit_code + "_" + gift_item_code + "_" + gift_unit_code, giftPromoNo
            // ","隔开
            // 示例：2643302013_001_1859222012_001,201307100027

            if (this.props.categoryDialogData.throught) {

                let item_code = this.props.allDatas.goodsDetail.item_code || "";
                let item_units = this.state.selectCodeStr || this.props.allDatas.goodsDetail.unit_code || (this.props.allDatas.goodsDetail.defaultTwunit && this.props.allDatas.goodsDetail.defaultTwunit.unit_Code) || "001";
                let gift_item_code = this.props.categoryDialogData.makeGiftCodes.ics || this.props.allDatas.gift_item_code || "";
                let gift_unit_code = this.props.categoryDialogData.makeGiftCodes.ucs || this.props.allDatas.gift_unit_code || "";
                let giftPromoNo = this.props.categoryDialogData.makeGiftCodes.giftPromoNo || ""; //todo 待确定
                // console.log("################## :"+gift_item_code+"yyyy"+gift_unit_code);
                Actions.OrderFill({
                    page: "PAGE_FROM_LIJI",
                    item_codes: item_code,
                    item_units: item_units,
                    emp_yn: "0",
                    gift_item_code_str: item_code + "_" + item_units + "_" + gift_item_code + "_" + gift_unit_code + "," + giftPromoNo,
                    item_counts: this.state.goodsNum || "1",
                    media_channel: "",
                    memberPromo: (this.props.isBone !== undefined && this.props.isBone !== null && this.props.isBone === '1') ? this.props.isBone : "",
                    receiver_seq: "",
                    imgSize: "P"
                });

            } else {
                //如果没有选择 打开规格弹窗
                this.props.isYuYue(false);
                this.props.openCategoryDialog(false);
            }

        // }
    }

    //检查token isGuest：是否是游客token
    _checkToken(token, isGuest, type) {
        if (this.CheckToken) {
            this.CheckToken.setCancled(true);
        }
        this.CheckToken = new CheckToken({token: token ? token : Global.token}, 'GET');
        this.CheckToken.start(
            (response) => {
                // console.log('checktoken' + response.code);
                if (response.code === 200 && response.data.isLogin) { //登录状态
                    //已登录 登录token有效

                    if (type === JUMP_GOUWUCHE) {
                        //登录token跳转购物车
                        Actions.cartFromGoodsDetail({});
                        return;
                    }else if (type === KEFU_JUMP_REQUEST){
                        //判断客服
                        this.kefuRequest();
                        return;
                    }  else if (type === SHOUCANG){
                        //收藏
                        this.saveRequest();
                        return;
                    }



                    if (this.state.addressCode === null) {
                        ToastShow.toast('请选择送货地址');
                        return;
                    }


                    //如果是登录后的加入购物车 进行拦截 不需要判断是否选择规格
                    if (type === PUTONG_JIARUGOUWUCHE) {
                        // this.sendGoodsTimeRequest(this.state.addressCode, '-1');
                        //每次点击加入购物车都重新弹出规格
                        this.props.openCategoryDialog(true);
                        return;
                    }

                    if (this.props.categoryDialogData.throught) { //判断是否选择了规格和数量

                        switch (type) {
                            case PUTONG_LIJIGOUMAI: //普通立即购买
                                this.sendGoodsTimeRequest(this.state.addressCode, '0');
                                break;
                            case TESHU_LIJIGOUMAI: //特殊立即购买
                                this.sendGoodsTimeRequest(this.state.addressCode, '1');
                                break;
                            case MIAOSHA: //秒杀
                                this.sendGoodsTimeRequest(this.state.addressCode, '3');
                                break;
                            case YUSHOU: //预售
                                this.sendGoodsTimeRequest(this.state.addressCode, '4');
                                break;
                            case YUYUE: //预约
                                this.sendGoodsTimeRequest(this.state.addressCode, '5');
                                break;
                            case PUTONG_JIARUGOUWUCHE://普通加入购物车 登录状态
                                // this.sendGoodsTimeRequest(this.state.addressCode, '-1');
                                //每次点击加入购物车都重新弹出规格
                                this.props.openCategoryDialog(true);
                                break;
                        }


                    } else {

                        if (type === YUYUE) {
                            this.props.isYuYue(true);
                        } else {
                            this.props.isYuYue(false);
                        }
                        //如果没有选择规格 打开规格弹窗
                        this.props.openCategoryDialog(false);
                        //如果没有选择规格 打开规格弹窗的同时 告诉弹窗用户点击的是什么类型
                        this.props.makeSureType(type);
                    }


                } else if (response.code === 200 && response.data.isVisitor) { //游客状态
                    // 未登录 游客token有效

                    if (isGuest) {
                        //游客可访问

                        if (type === PUTONG_JIARUGOUWUCHE) { //普通加入购物车  未登录状态
                            // this.sendGoodsTimeRequest(this.state.addressCode, '-1');

                            if (this.state.addressCode === null) {
                                ToastShow.toast('请选择送货地址');
                                return;
                            }
                            //每次点击加入购物车都重新弹出规格
                            this.props.openCategoryDialog(true);
                        } else if (type === JUMP_GOUWUCHE) {
                            //游客token跳转购物车
                            Actions.cartFromGoodsDetail({});
                        }

                    } else {
                        //游客token不可访问
                        this._toLogin();
                    }
                } else {
                    //既不是游客token，也不是登录token，token失效， 重新登录
                    this._toLogin();
                }
            }, (erro) => {
                this._toLogin();
            });
    }

    //登录
    _toLogin() {
        // RnConnect.pushs({page: RouteConfig.MePageocj_Login}, ((event) => {
        //     if (event.tokenType === "self") {
        //         this.props.refreshGoodsDetailDatas();
        //     }
        // }));
        RouteManager.routeJump({
            page: routeConfig.Login,
            fromRNPage: routeConfig.GoodsDetailMain,
        }, (event) => {
            if (event.tokenType === "self") {
                this.props.refreshGoodsDetailDatas();
            }
        })
    }

    //根据错误返回值来判断是否登录
    _toLoginByErrCode(err) {
        let login = (err && err.code && (err.code === 4010 || err.code === 4011 || err.code === 4012 || err.code === 4013 || err.code === 4014)) ? true : false;
        if (login) {
            this._toLogin();
        } else {
            ToastShow.toast(CartShowErroMessage.errShow(err));
        }
    }

    //检测 1、是否登录 2、是否选择了规格
    checkLoadingAndSizeColor(type) {
        // console.log('++++++++++ token:'+Global.token);
        // console.log('++++++++++ tokenType:'+Global.tokenType);
        // if (Global.token === '' || Global.tokenType === 'guest') {  //判断是否登录
        //     RnConnect.pushs({page: RouteConfig.MePageocj_Login}, ((event) => {
        //         if (event.tokenType === "self") {
        //             this.props.refreshGoodsDetailDatas();
        //         }
        //     }));
        // } else {
        //
        //     //noCS用来判断 是否没有规格和颜色
        //     //即使预约商品只能选择一件商品，但是预约商品可能会有赠品，所以还是让预约商品弹出规格选择框
        //
        //     this._checkToken(null,false,type)
        //
        //
        // }

        this._checkToken(null, false, type)

    }


    renderBtn() {

        if (this.props.allDatas.button_controll === "9") { //特殊状态，商品已下架
            return (
                <View
                    activeOpacity={1}
                    style={styles.btnStyle4}>
                    <Text allowFontScaling={false} style={styles.textB}>商品已下架</Text>
                </View>
            )
        }


        switch (this.state.id) {

            case "1"://礼品卡，内买，特殊，tv限制商品
                return (
                    <TouchableOpacity
                        onPress={() => {

                            if (this.state.canClick) {
                                this.setState({canClick: false});

                                this.checkLoadingAndSizeColor(TESHU_LIJIGOUMAI);

                                this.canClickTimer = setTimeout(() => {
                                    this.setState({canClick: true})
                                }, 3000);
                            }

                            {/*this.sendGoodsTimeRequest(this.state.addressCode,'1');*/
                            }
                            {/*this.jumpClick("立即购买");*/
                            }
                        }}
                        activeOpacity={1}
                        style={styles.btnStyle2}>

                        <Image style={[styles.bottomBtnOne, {width: width * 0.6}]}
                               source={require('../../../../foundation/Img/goodsdetail/determine_background@3x.png')}>
                            <Text allowFontScaling={false}
                                  style={[styles.textW, {backgroundColor: 'transparent'}]}>立即购买</Text>
                        </Image>

                    </TouchableOpacity>
                )
                break;
            case "3"://秒杀商品 已开始
                return (
                    <TouchableOpacity
                        onPress={() => {

                            if (this.state.canClick) {
                                this.setState({canClick: false});

                                this.checkLoadingAndSizeColor(MIAOSHA);

                                this.canClickTimer = setTimeout(() => {
                                    this.setState({canClick: true})
                                }, 3000);
                            }

                        }}
                        activeOpacity={1}
                        style={styles.btnStyle2}>

                        <Image style={[styles.bottomBtnOne, {width: width * 0.6}]}
                               source={require('../../../../foundation/Img/goodsdetail/determine_background@3x.png')}>
                            <Text allowFontScaling={false}
                                  style={[styles.textW, {backgroundColor: 'transparent'}]}>秒杀</Text>
                        </Image>

                    </TouchableOpacity>
                )
                break;
            case "2"://等待秒杀 秒杀未开始
                return (
                    <View
                        activeOpacity={0.8}
                        style={styles.btnStyle5}>
                        <ShowTime
                            changeId={() => {
                                this.setState({id: "3"});
                            }}
                            refreshGoodsDetailDatas={() => {
                                this.props.refreshGoodsDetailDatas();
                            }}
                            allDatas={this.props.allDatas}/>
                    </View>
                )
                break;
            case "4"://预售商品（可点击进去填写订单）
                return (
                    <TouchableOpacity
                        onPress={() => {

                            if (this.state.canClick) {
                                this.setState({canClick: false});

                                this.checkLoadingAndSizeColor(YUSHOU);

                                this.canClickTimer = setTimeout(() => {
                                    this.setState({canClick: true})
                                }, 3000);
                            }

                        }}
                        activeOpacity={1}
                        style={styles.btnStyle3}>

                        <Image style={[styles.bottomBtnOne, {width: width * 0.6}]}
                               source={require('../../../../foundation/Img/goodsdetail/cancel_background@3x.png')}>
                            <Text allowFontScaling={false}
                                  style={[styles.textW, {backgroundColor: 'transparent'}]}>预售</Text>
                        </Image>

                    </TouchableOpacity>
                );
                break;
            case "5"://预约商品（可点击进去填写订单）
                return (
                    <TouchableOpacity
                        onPress={() => {

                            if (this.state.canClick) {
                                this.setState({canClick: false});

                                this.checkLoadingAndSizeColor(YUYUE);

                                this.canClickTimer = setTimeout(() => {
                                    this.setState({canClick: true})
                                }, 3000);
                            }

                        }}
                        activeOpacity={1}
                        style={styles.btnStyle3}>

                        <Image style={[styles.bottomBtnOne, {width: width * 0.6}]}
                               source={require('../../../../foundation/Img/goodsdetail/cancel_background@3x.png')}>
                            <Text allowFontScaling={false}
                                  style={[styles.textW, {backgroundColor: 'transparent'}]}>预约</Text>
                        </Image>

                    </TouchableOpacity>
                );
                break;
            case "6"://医疗，保险类商品-拨打电话
                return (
                    <TouchableOpacity
                        onPress={() => {
                            Linking.openURL("tel:" + "4008898000").catch(err => {
                            });
                        }}
                        activeOpacity={1}
                        style={styles.btnStyle2}>

                        <Image style={[styles.bottomBtnOne, {width: width * 0.6}]}
                               source={require('../../../../foundation/Img/goodsdetail/determine_background@3x.png')}>
                            <Text allowFontScaling={false}
                                  style={[styles.textW, {backgroundColor: 'transparent'}]}>拨打电话</Text>
                        </Image>

                    </TouchableOpacity>
                )
                break;
            case "7"://商品无货状态
                return (
                    <View
                        activeOpacity={1}
                        style={styles.btnStyle4}>
                        <Text allowFontScaling={false} style={styles.textB}>来晚啦，卖光了</Text>
                    </View>
                )
                break;

            case "9"://商品下架
                return (
                    <View
                        activeOpacity={1}
                        style={styles.btnStyle4}>
                        <Text allowFontScaling={false} style={styles.textB}>商品已下架</Text>
                    </View>
                )
                break;

            default:
                return (
                    <View style={styles.btn}>
                        <TouchableOpacity
                            onPress={() => {

                                if (this.state.canClick) {
                                    this.setState({canClick: false});

                                    this._checkToken(null, true, PUTONG_JIARUGOUWUCHE);

                                    //埋点 加入购物车
                                    DataAnalyticsModule.trackEvent3("AP1706C032C007001O001001", "", {
                                        type: "加入购物车",
                                        itemcode: this.props.allDatas.goodsDetail.item_code,
                                    });

                                    this.canClickTimer = setTimeout(() => {
                                        this.setState({canClick: true})
                                    }, 3000);
                                }


                            }}
                            activeOpacity={1}
                            style={styles.btnStyle3}>

                            <Image style={styles.bottomBtnOne}
                                   source={require('../../../../foundation/Img/goodsdetail/cancel_background@3x.png')}>
                                <Text allowFontScaling={false} style={[styles.textW, {backgroundColor: 'transparent'}]}>加入购物车</Text>
                            </Image>

                        </TouchableOpacity>
                        <TouchableOpacity
                            onPress={() => {


                                if (this.state.canClick) {
                                    this.setState({canClick: false});

                                    this.checkLoadingAndSizeColor(PUTONG_LIJIGOUMAI);

                                    //埋点 立即购买
                                    DataAnalyticsModule.trackEvent3("AP1706C032C007001O001002", "", {
                                        type: "立即订购",
                                        itemcode: this.props.allDatas.goodsDetail.item_code,
                                    });

                                    this.canClickTimer = setTimeout(() => {
                                        this.setState({canClick: true})
                                    }, 3000);
                                }


                            }}
                            activeOpacity={1}
                            style={styles.btnStyle2}>

                            <Image style={styles.bottomBtnOne}
                                   source={require('../../../../foundation/Img/goodsdetail/determine_background@3x.png')}>
                                <Text allowFontScaling={false} style={[styles.textW, {backgroundColor: 'transparent'}]}>立即购买</Text>
                            </Image>
                        </TouchableOpacity>
                    </View>
                );
                break;
        }
    }

    //普通商品立即购买跳转到订单页
    jumpToFillOrder(yn, cartSeqs) {

        Actions.OrderFill({
            page: "PAGE_FROM_CATRS",
            cartSeqs: [cartSeqs],
            dcrate_yn: yn,
            app_first_dc_yn: "yes",
            imgSize: "P",
        });
    }

    //配送时效接口文档
    sendGoodsTimeRequest(addressCode, from) {
        // alert(this.state.addressCode.provinceCode);

        let colorsize = this.props.allDatas.colorsize;
        let sizes = ((colorsize !== null && colorsize.sizes !== null && colorsize.sizes.length > 0 ) ? colorsize.sizes : null);
        let colors = ((colorsize !== null && colorsize.colors !== null && colorsize.colors.length > 0 ) ? colorsize.colors : null);
        let css = ((colorsize !== null && colorsize.colorsizes !== null && colorsize.colorsizes.length > 0 ) ? colorsize.colorsizes : null);

        let unit = '';
        if (css !== null) {
            unit = css[0].cs_code;
        } else {
            if (sizes !== null && colors !== null) {
                unit = colors[0].cs_code + ':' + sizes[0].cs_code;
            } else if (sizes === null && colors !== null) {
                unit = colors[0].cs_code;
            } else if (sizes !== null && colors === null) {
                unit = sizes[0].cs_code;
            }
        }


        if (addressCode === null) {
            ToastShow.toast('请选择送货地址');
            return;
        }

        if (this.sendGTR) {
            this.sendGTR.setCancled(true)
        }

        let req = {
            item_code: this.props.allDatas.goodsDetail.item_code,
            unit_code: this.state.selectCodeStr || this.props.allDatas.goodsDetail.unit_code || ( this.props.allDatas.goodsDetail.defaultTwunit && this.props.allDatas.goodsDetail.defaultTwunit.unit_Code ) || "001",
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
                // this.setState({senddate: msg.s_msg, bottomButtonId: msg.s_status});
                let id = msg.s_status;


                if (from === '0') {//普通物品 立即购买

                    if (id === '1') {//有货
                        if (this.props.categoryDialogData.throught) { // 3、判断是否已经选择了规格和赠品，如果已经选择，直接加入购物车并跳转
                            //不提示加入购物车成功的加入购物车
                            this.addCartRequestAndJump();
                        } else { // 4、没有选择规格 弹出规格弹窗，让用户去选择规格，然后重新点击立即购买 跳转到订单填写页
                            this.props.isYuYue(false);
                            this.props.openCategoryDialog(false);
                        }
                    } else {
                        this.changButtonId(id);
                    }

                } else if (from === '-1') {//普通物品 加入购物车

                    if (id === '1') { //加入购物车
                        // if (this.props.categoryDialogData.throught) {
                        //     //如果选择了规格  加入购物车
                        //     this.addCartRequest();
                        // } else {
                        //     //如果没有选择 打开规格弹窗
                        //     this.props.openCategoryDialog(true);
                        // }

                        //每次点击加入购物车都重新弹出规格
                        this.props.isYuYue(false);
                        this.props.openCategoryDialog(true);

                    } else {
                        this.changButtonId(id);
                    }

                } else if (from === '1') {//特殊 立即购买

                    if (id === '1') { //立即购买

                        this.jumpClick("立即购买");

                    } else {
                        this.changButtonId(id);
                    }

                } else if (from === '3') {//秒杀

                    if (id === '1') { //秒杀
                        this.jumpClick("秒杀");
                    } else {
                        this.changButtonId(id);
                    }

                } else if (from === '4') {//预售商品
                    if (id === '1') { //预售
                        this.jumpClick("预售");
                    } else {
                        this.changButtonId(id);
                    }

                } else if (from === '5') {//预约商品
                    if (id === '1') { //有货
                        this.changButtonId(id);
                    } else if (id === '2') {//无货可预约
                        this.jumpToYuYueClick("预约");
                    } else {//无货
                        this.changButtonId(id);
                    }
                }

            } else {
                this._toLoginByErrCode(response);
            }
        }, (err) => {
            this._toLoginByErrCode(err);
        });
    }


    //判断是否是内部员工，内部员工是否使用员工折扣，然后进行相关跳转
    checkUseEmpDisRequest(cartSeqs) {
        let req = {
            cartSeqs: cartSeqs + "",
        };
        if (this.checkR) {
            this.checkR.setCancled(true)
        }
        this.checkR = new CheckUseEmpDiscountRequest(req, "GET");
        this.checkR.start((response) => {
            // alert(JSON.stringify(response));
            if (response.code && response.code === 200) {//网络访问成功

                if (response.data !== null && response.data.resword !== null) {

                    if (response.data.resword === "1") {//网络访问成功并且是 内部员工  并且有员工折扣
                        //弹出提示框，询问员工是否使用员工折扣

                        Alert.alert('温馨提示！', '是否使用员工折扣？', [

                            {
                                text: '否', onPress: () => {//是内部员工，不接受员工折扣
                                this.jumpToFillOrder("0", cartSeqs);
                            }
                            },

                            {
                                text: '是', onPress: () => {//是内部员工，接受员工折扣
                                this.jumpToFillOrder("1", cartSeqs);
                            }
                            }

                        ])
                    } else { //网络访问成功，不是内部员工，或者没有员工折扣
                        this.jumpToFillOrder("0", cartSeqs);
                    }
                } else {
                    ToastShow.toast(response.message);
                }

            } else {
                this._toLoginByErrCode(response);
            }
        }, (err) => {
            this._toLoginByErrCode(err);
            // console.log(JSON.stringify(err));
        });
    }

    //收藏请求
    saveRequest() {
        // console.log("------------> savRequest token:"+Global.token);
        // console.log("------------> savRequest tokenType:"+Global.tokenType);
        // console.log("------------> savRequest testToken:"+Global.testToken);
        if (this.state.save) {//已经收藏，点击取消收藏
            if (this.goodsUnSaveRequest) {
                this.goodsUnSaveRequest.setCancled(true)
            }
            this.goodsUnSaveRequest = new GoodsUnSaveRequest({
                item_code: this.props.allDatas.goodsDetail.item_code
            }, "POST");
            this.goodsUnSaveRequest.start((response) => {
                // console.log("-----------aaa取消收藏:"+JSON.stringify(response));
                if (response.code === 200) {
                    this.setState({save: false});
                    ToastShow.toast("取消收藏成功");
                    DeviceEventEmitter.emit(Notification.REFRESH_COLLECT_GOODS,{showLoading: false});
                } else {
                    ToastShow.toast(response.message)
                }
            }, (err) => {
                this.setState({save: false});
            });
        } else {//没有收藏，点击请求收藏
            if (this.goodsSaveRequest) {
                this.goodsSaveRequest.setCancled(true)
            }
            this.goodsSaveRequest = new GoodsSaveRequest({
                item_code: this.props.allDatas.goodsDetail.item_code
            }, "POST");
            this.goodsSaveRequest.start((response) => {
                // console.log("-----------aaa请求收藏:"+JSON.stringify(response));
                if (response.code === 200) {
                    this.setState({save: true});
                    ToastShow.toast("收藏成功");
                    DeviceEventEmitter.emit(Notification.REFRESH_COLLECT_GOODS,{showLoading: false});
                } else {
                    ToastShow.toast(response.message)
                }
            }, (err) => {
                this.setState({save: true});
            });

        }

    }


    //购物车总数量请求
    cartNumRequest() {
        if (this.cartNumR) {
            this.cartNumR.setCancled(true)
        }
        this.cartNumR = new CartNumRequest({}, "POST");
        this.cartNumR.start((response) => {
            if (response.code && response.code === 200) {
                // alert("购物车总数量："+response.data.carts_num)
                this.changeNum = setTimeout(()=>{
                    this.setState({cartNum: response.data && response.data.carts_num})
                }, 750);
            }
        }, (err) => {
            // console.log(JSON.stringify(err));
        });
    }

    //东东客服url请求
    kefuRequest() {
        if (this.kefuR) {
            this.kefuR.setCancled(true)
        }
        this.kefuR = new KeFuRequest({
            order_no: "",
            item_code: this.props.allDatas.goodsDetail.item_code || "",
            imsource: "",
            last_sale_price: this.props.allDatas.goodsDetail.last_sale_price || "",
        }, "GET");
        // console.log("======== 客服请求参数itemcode:"+this.props.allDatas.goodsDetail.item_code);
        // console.log("======== 客服请求参数token:"+Global.token);
        this.kefuR.start((response) => {
            if (response.code !== null && response.code === 200 && response.data !== null && response.data.url) {
                // console.log("##### kefu:" + response.data.url);
                Actions.VipPromotionGoodsDetail({value: response.data.url});
                // Actions.VipPromotionGoodsDetail({
                //     value: response.data.url,
                // });

            } else {
                this._toLoginByErrCode(response);
            }
        }, (err) => {
            this._toLoginByErrCode(err);
        });
    }

    //普通商品加入购物车并且跳转 ，不显示刷新购物车数量，不显示加入购物车成功
    addCartRequestAndJump() {

        if (this.addCartR) {
            this.addCartR.setCancled(true)
        }

        let reqBody = {
            item_code: this.props.allDatas.goodsDetail.item_code,
            qty: this.state.goodsNum || "1",
            unit_code: this.state.selectCodeStr || this.props.allDatas.goodsDetail.unit_code || (this.props.allDatas.goodsDetail.defaultTwunit && this.props.allDatas.goodsDetail.defaultTwunit.unit_Code) || "001",
            gift_item_code: this.props.categoryDialogData.makeGiftCodes.ics || '',
            gift_unit_code: this.props.categoryDialogData.makeGiftCodes.ucs || '',
            giftPromo_no: this.props.allDatas.goodsDetail.giftPromo_no || '',
            giftPromo_seq: this.props.allDatas.goodsDetail.giftPromo_seq || '',
            media_channel: "",
            msale_source: "",
            msale_cps: "",
            source_url: "http://ocj.com.cn",
            source_obj: "",
            ml_msale_gb: "",

            item_price: (this.props.allDatas.goodsDetail.last_sale_price + "") || (this.props.allDatas.goodsDetail.sale_price + "") || "",
            event_end_date: this.props.allDatas.goodsDetail.disp_end_dt ? (this.props.allDatas.goodsDetail.disp_end_dt + "") : "",

            area_lcode: (this.state.addressCode !== null && this.state.addressCode.provinceCode !== null) ? this.state.addressCode.provinceCode : "", /*省*/
            area_mcode: (this.state.addressCode !== null && this.state.addressCode.cityCode !== null) ? this.state.addressCode.cityCode : "", /*市*/
            area_scode: (this.state.addressCode !== null && this.state.addressCode.districtCode !== null) ? this.state.addressCode.districtCode : "", /*地区*/

        };

        // console.log('============ 普通商品立即购买参数：'+JSON.stringify(reqBody));
        // console.log('============ 普通商品立即购买token：'+Global.token);
        this.addCartR = new AddToCartAtOnceRequest(reqBody, "POST");
        this.addCartR.showLoadingView(true).start((response) => {
            let jsonData = response.data;
            // let jsonData = JSON.parse(response.data);
            // console.log('============ 普通商品立即购买返回数据：'+JSON.stringify(response));

            if (response.code && response.code === 200 && response.message === 'succeed') {

                for (let a in response.data) {
                    this.checkUseEmpDisRequest(jsonData.result.cart_seq);
                    return;
                }
                ToastShow.toast('立即购买失败');
            } else {
                this._toLoginByErrCode(response);
            }

        }, (err) => {
            this._toLoginByErrCode(err);
        });
    }

    //只是加入加入购物车
    addCartRequest() {
        if (this.addCartR) {
            this.addCartR.setCancled(true)
        }

        let reqBody = {
            item_code: this.props.allDatas.goodsDetail.item_code,
            qty: this.state.goodsNum || "1",
            unit_code: this.state.selectCodeStr || this.props.allDatas.goodsDetail.unit_code || (this.props.allDatas.goodsDetail.defaultTwunit && this.props.allDatas.goodsDetail.defaultTwunit.unit_Code) || "001",
            gift_item_code: this.props.categoryDialogData.makeGiftCodes.ics || '',
            gift_unit_code: this.props.categoryDialogData.makeGiftCodes.ucs || '',
            giftPromo_no: '',
            giftPromo_seq: '',
            media_channel: '',
            msale_source: '',
            msale_cps: '',
            source_url: 'http%3A%2F%2Fm.ocj.com.cn%2Fsettle%2Fm_shop%2F9228%3Fdomain_id%3D7781_6481_12081_2_14318_WASTE',
            source_obj: '',
            timeStamp: '',
            ml_msale_gb: '',
            item_price: (this.props.allDatas.goodsDetail.last_sale_price + "") || (this.props.allDatas.goodsDetail.sale_price + "") || "",
            event_end_date: this.props.allDatas.goodsDetail.disp_end_dt ? (this.props.allDatas.goodsDetail.disp_end_dt + "") : "",

            area_lcode: (this.state.addressCode !== null && this.state.addressCode.provinceCode !== null) ? this.state.addressCode.provinceCode : "", /*省*/
            area_mcode: (this.state.addressCode !== null && this.state.addressCode.cityCode !== null) ? this.state.addressCode.cityCode : "", /*市*/
            area_scode: (this.state.addressCode !== null && this.state.addressCode.districtCode !== null) ? this.state.addressCode.districtCode : "", /*地区*/
        };
        // let request = new AddCartRequest(reqBody, 'POST');
        // console.log('-------- 加入购物车请求参数:'+JSON.stringify(reqBody));
        this.addCartR = new AddCartRequest(reqBody, "POST");
        this.addCartR.showLoadingView(true).start((response) => {
            let jsonData = response.data;
            if (response.code && response.code === 200) {
                ToastShow.toast('加入购物车成功');
                this.cartNumRequest();//专门用请求购物车接口请求的购物车数量
            } else {
                this._toLoginByErrCode(response);
            }

        }, (err) => {
            this._toLoginByErrCode(err);
        });
    }

    render() {

        let savedIcon = require('../../../../foundation/Img/goodsdetail/Icon_favorites_details_@3x.png');
        if (this.state.save) {
            savedIcon = require('../../../../foundation/Img/goodsdetail/Icon_favorites_details_red_@3x.png');
        }

        if (this.props.allDatas.button_controll2 && this.props.allDatas.button_controll2 === '2') {
            if (this.state.id !== '3') {
                this.setState({id: '2'});
            }
        }


        return (
            <View style={styles.bottomBar}>

                <View
                    style={{flexDirection: 'row', alignItems: 'center', height: bottomHeight, width: width * 0.4}}>
                    <TouchableOpacity
                        onPress={() => {
                                this._checkToken(null,false,KEFU_JUMP_REQUEST);
                            //联系客服 埋点
                            DataAnalyticsModule.trackEvent3("AP1706C032C007001C009001", "", {
                                itemcode: this.props.allDatas.goodsDetail.item_code
                            });
                        }}
                        activeOpacity={1}
                        style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
                        <Image style={{marginBottom: ScreenUtils.scaleSize(8)}}
                               source={require('../../../../foundation/Img/goodsdetail/kefu_@3x.png')}/>
                        <Text allowFontScaling={false}
                              style={{color: '#666', fontSize: ScreenUtils.setSpText(22)}}>客服</Text>
                    </TouchableOpacity>

                    <TouchableOpacity
                        onPress={() => {


                            this._checkToken(null,false,SHOUCANG);

                            //点击收藏 埋点
                            DataAnalyticsModule.trackEvent3("AP1706C032C007001C009002", "", {
                                type: "加入收藏",
                                itemcode: this.props.allDatas.goodsDetail.item_code
                            });

                        }}
                        activeOpacity={1}
                        style={{
                            flex: 1,
                            justifyContent: 'center',
                            alignItems: 'center',
                            borderRightWidth: StyleSheet.hairlineWidth,
                            borderLeftWidth: StyleSheet.hairlineWidth,
                            borderColor: '#ddd',
                            height: bottomHeight,
                        }}>
                        <Image style={{marginBottom: ScreenUtils.scaleSize(8)}}
                               source={savedIcon}/>
                        <Text allowFontScaling={false}
                              style={{color: '#666', fontSize: ScreenUtils.setSpText(22)}}>收藏</Text>
                    </TouchableOpacity>


                    <TouchableOpacity
                        onPress={() => {

                            //点击购物车 埋点
                            DataAnalyticsModule.trackEvent3("AP1706C032C007001C009003", "", {
                                type: "购物车"
                            });

                            this._checkToken(null, true, JUMP_GOUWUCHE);

                        }}
                        activeOpacity={1}
                        style={{
                            flex: 1,
                            justifyContent: 'center',
                            alignItems: 'center',
                            height: bottomHeight - ScreenUtils.scaleSize(4),
                            backgroundColor: 'white'
                        }}>
                        <Image
                            resizeMode={'stretch'}
                            style={{marginBottom: ScreenUtils.scaleSize(8)}}
                            source={require('../../../../foundation/Img/goodsdetail/Icon_cart_details_@3x.png')}/>
                        <Text allowFontScaling={false}
                              style={{color: '#666', fontSize: ScreenUtils.setSpText(22)}}>购物车</Text>

                        {this.state.cartNum != 0 ?
                            <Animated.View style={[styles.cartNum, {
                                height: this.state.circleRadius,
                                borderRadius: this.state.circleRadius / 2,
                                transform: [{
                                    scale: this.props.springBig
                                }]
                            }]}>

                                <Text allowFontScaling={false}
                                      style={[styles.cartNumText, {backgroundColor: 'transparent'}]}
                                      onLayout={({nativeEvent: {layout: {x, y, width, height}}}) => {
                                          if (this.state.circleRadius !== height) {
                                              this.setState({
                                                  circleRadius: height
                                              });
                                          }
                                      }}>{this.state.cartNum + ""}</Text>
                            </Animated.View> : null
                        }
                    </TouchableOpacity>
                </View>


                <View style={{width: width * 0.6}}>
                    {this.renderBtn()}
                </View>
            </View>
        )
    }
}
const bottomHeight = ScreenUtils.scaleSize(100);
const styles = StyleSheet.create({
    bottomBar: {
        flexDirection: 'row',
        width: width,
        height: bottomHeight,
        backgroundColor: 'white',
        alignItems: 'center',
        borderTopWidth: StyleSheet.hairlineWidth,
        borderColor: Colors.line_grey,
        // marginBottom: 20,
    },
    btn: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        height: bottomHeight,
    },
    bottomBtnOne: {
        justifyContent: 'center',
        alignItems: 'center',
        height: bottomHeight,
        resizeMode: 'stretch',
        width: width * 0.3,

    },
    btnStyle2: {
        flex: 1,
        backgroundColor: '#EA543D',
        justifyContent: 'center',
        alignItems: 'center',
        height: bottomHeight
    },
    btnStyle3: {
        flex: 1,
        backgroundColor: Colors.yellow,
        justifyContent: 'center',
        alignItems: 'center',
        height: bottomHeight
    },
    btnStyle4: {
        flex: 1,
        backgroundColor: Colors.background_grey,
        justifyContent: 'center',
        alignItems: 'center',
        height: bottomHeight
    },
    btnStyle5: {
        flex: 1,
        backgroundColor: '#EC6955',
        justifyContent: 'center',
        alignItems: 'center',
        height: bottomHeight
    },
    textW: {
        textAlign: 'center',
        color: 'white',
        fontSize: ScreenUtils.setSpText(30),
        backgroundColor: 'transparent'
    },
    textB: {
        textAlign: 'center',
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(30),
    },
    cartNum: {
        position: 'absolute',
        top: ScreenUtils.scaleSize(3),
        right: ScreenUtils.scaleSize(10),
        backgroundColor: '#E5290D',
        borderRadius: ScreenUtils.scaleSize(12),
        // padding:ScreenUtils.scaleSize(5),
        paddingLeft: ScreenUtils.scaleSize(6),
        paddingRight: ScreenUtils.scaleSize(6),
    },
    cartNumText: {
        fontSize: ScreenUtils.scaleSize(20),
        color: '#fff'
    }
});

// export default connect(state=>({
//     // resultDatas:state.ClassificationPageReducer.result
//     // resultDatas:state.ClassificationPageReducer,
//     categoryDialogData: state.ClassificationPageReducer.categoryDialog,
// }),dispatch=>({
//     // getDatas:(data)=>dispatch(ClassificationPagaAction.getEvaluateDatas(data)),
//     addCart: (data, successCallback, failCallback) => dispatch(CartAction.addCart(data, successCallback, failCallback)),
//     openCategoryDialog: (data) => dispatch(classificationPageAction.categoryDialogDatas(data)),
// }))(BottomCartBar)
