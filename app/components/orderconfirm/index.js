/**
 * Created by YASIN on 2017/6/9.
 * 填写订单页面
 */
import React from 'react';
import {
    View,
    StyleSheet,
    Platform,
    ScrollView,
    DeviceEventEmitter,
    InteractionManager
} from 'react-native';
import Colors from '../../config/colors';
import NavigationBar from '../../../foundation/common/NavigationBar';
import GetOrderInfoRequest from '../../../foundation/net/order/GetOrderInfoRequest';
import OrderAddPotentialorder from '../../../foundation/net/order/OrderAddPotentialorder';
import OrderUpdatePotentialorder from '../../../foundation/net/order/OrderUpdatePotentialorder';
import OrderInfoImmediatelyRequest from '../../../foundation/net/order/OrderInfoImmediatelyRequest';
import OrderFillRequest, {formatParams, potentialOrderInfo} from '../../../foundation/net/order/OrderFillRequest';
import OrderMoneyInfo from './OrderMoneyInfo';
import OrderAddress from './OrderAddress';
import OrderBottomSubmitView from  './OrderBottomSubmitView';
import OrderIDVerify from  './OrderIDVerify';
import OrderGoodList from './OrderGoodList';
import OrderDistributionDate from  './OrderDistributionDate';
import OrderPayMethod from './OrderPayMethod';
import CouponList from './CouponList';
import InvoiceInfo from './InvoiceInfo';
import {Actions}from 'react-native-router-flux';
import * as routeConfig from '../../../app/config/routeConfig';
import Toast, {DURATION} from 'react-native-easy-toast';
import NetErro from '../../components/error/NetErro';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import {DataAnalyticsModule} from '../../config/AndroidModules';
import * as RouteManager from '../../config/PlatformRouteManager';
let firstRender = true;
export default class OrderConfirm extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            showLoading: false,
            showErro: false,
            amountDetail: {
                foodsAmount: '0',  // 商品总额
                discount: '0',     // 优惠价格
                voucher: '0',      // 抵用券
                tax: '0',          // 跨境税
                freight: '0',      // 运费
                totalAmount: '0'   // 应付金额
            },
            address: {
                addressSeq: '',//地址唯一标示
                hasAddress: false,//是否有地址
                receiveName: '',//收货人姓名
                receivePhone: '',//收货人手机
                receivePhoneWidthStart: '',//带星号手机号码
                isDefaultAdd: '0',//是否是默认地址
                address: '',//地址名称
                orderUserName: '',//下单人姓名,
                orderUserPhone: '',//下单人手机,
                orderUserDefault: false,//下单人是否为默认,
                hasOrderUser: false,//是否有下单人
            },
            // 默认的发票 配送时间 全球购用户添加身份信息
            baseInfo: {
                defaultDistributionDate: '', // 默认配送时间
                canInvoice: false, // 是否可以开发票
                needInvoice: true, // 是否需要发票
                invoiceType: false,//是否需要电子版发票 true需要 false不需要
                invoiceName: '',//发票收票人
                invoicePhone: '',//收票人手机号码
                invoiceType1: 0,//0个人发票，1公司发票
                invoiceNum: '',//公司发票纳税人识别号
                invoiceEmail: '',//收票人邮箱
                userName: '',   // 全球购用户的姓名
                userIDString: '', // 全球购用户的身份证信息
                isNeedFillInfo: false,//是否需要填写证件信息（全球购商品...）
                totalCount: 0,//商品总数量
                onlinePayCutDown: false, // 在线支付立减五元标示
            },
            orders: [],
            isSingle: undefined, // 是否是单商品
            showBottomAdd: false,// 是否展示底部的地址
        };
    }

    componentWillMount() {
        DeviceEventEmitter.addListener('REFRESH_MONEY_INFO', () => this.refreshMoneyInfo());
    }

    componentDidMount() {
        //上个页面传过来的参数
        let page = this.props.page;
        //根据不同的页面做不同的请求
        this._doPostData(page);
    }

    componentWillUnmount() {
        DeviceEventEmitter.removeListener('REFRESH_MONEY_INFO');
        DeviceEventEmitter.removeListener('REQUEST_CHANGE_ADDRESS');
    }

    render() {
        let self = this;
        return (
            <View style={styles.container}>
                {self._renderNavBar()}
                {this.state.showErro ? (
                    <NetErro
                        style={{flex: 1}}
                        title={'您的网络好像很傲娇'}
                        confirmText={'刷新试试'}
                        onButtonClick={() => {
                            //上个页面传过来的参数
                            let page = this.props.page;
                            //根据不同的页面做不同的请求
                            this.setState({
                                showErro: false
                            }, () => {
                                //上个页面传过来的参数
                                let page = this.props.page;
                                //根据不同的页面做不同的请求
                                this._doPostData(page);
                            });
                        }}
                    />
                ) : ((this.state.orders && this.state.orders.length > 0) ? (
                        <View style={{width: ScreenUtils.screenW, flex: 1}}>
                            <ScrollView
                                keyboardShouldPersistTaps='handled'
                                ref='scrollView'
                                scrollEventThrottle={30}
                                onScroll={(e) => this._onScroll(e)}
                                showsVerticalScrollIndicator={false}
                            >
                                {/*渲染地址选择*/}
                                {this._renderAddress()}
                                {/*渲染商品信息*/}
                                {this._renderGoodsInfo()}
                                {/* 全球购用户需要身份信息填写 */}
                                {this._renderIDVerify()}
                                {/* 支付方式 */}
                                {this._renderPayMethod()}
                                {/* 配送时间选择 */}
                                {this._renderOrderDistributionDate()}
                                {/*渲染发票信息*/}
                                {this._renderInvoiceInfo()}
                                {/*渲染抵用券信息*/}
                                {this._renderCouponList()}
                                {/* 渲染底部账单信息 */}
                                {this._renderBillAmount()}
                            </ScrollView>
                            {/* 渲染底部提交按钮以及地址提示 */}
                            {this._renderBottomSubmitView()}
                        </View>
                    ) : null
                )}
                <Toast ref="toast"/>
            </View>
        );
    }

    _onScroll(e) {
        const { address } = this.state
        let contentOffsetY = e.nativeEvent.contentOffset.y
        if (contentOffsetY >  ScreenUtils.scaleSize(200)) {
            if (address && address.hasAddress) {
                this.setState({
                    showBottomAdd: true
                })
            }
        } else {
            this.setState({
                showBottomAdd: false
            })
        }
    }

    /**
     * 渲染navbar
     * @private
     */
    _renderNavBar() {
        return (
            <NavigationBar
                title={'填写订单'}
                navigationBarBackgroundImage={require('../../../foundation/Img/order/icon_orderconfirm_topbar_.png')}
                navigationStyle={{
                    ...Platform.select({ios: {marginTop: -22}}),
                    height: ScreenUtils.scaleSize(128)
                }}
                titleStyle={styles.titleTextStyle}
                leftButton={require('../../../foundation/Img/home/store/icon_back_white_.png')}
                onLeftPress={ () => {
                    if (this.state.isSingle === true) {
                        DataAnalyticsModule.trackEvent2("AP1706C016D003001C003001", "");
                    } else if (this.state.isSingle === false) {
                        DataAnalyticsModule.trackEvent2("AP1706C017D003001C003001", "");
                    }
                    let params = potentialOrderInfo(this.state.baseInfo, this.state.amountDetail, this.state.address, this.state.orders);
                    params.order_cfm_yn = '0';
                    new OrderUpdatePotentialorder(params, 'POST').start();
                    Actions.pop();
                }}
            />
        );
    }

    /**
     * 渲染地址选择
     * @private
     */
    _renderAddress() {
        return (
            <OrderAddress
                isSingle={this.state.isSingle}
                hasAddress={this.state.address.hasAddress}
                receiveName={this.state.address.receiveName}
                receivePhone={this.state.address.receivePhoneWidthStart}
                isDefaultAdd={this.state.address.isDefaultAdd === '1'}
                address={this.state.address.address}
                onAddressUpdate={(address) => {
                    address.hasAddress = true;
                    let address1 = Object.assign(this.state.address, address);
                    this.setState({
                        address: address1
                    }, () => {
                        //选择地址后重新请求
                        let page = this.props.page;
                        //根据不同的页面做不同的请求
                        this._doPostData(page);
                    })
                }}
            />
        );
    }

    /**
     * 全球购用户需要身份验证
     * onNameTextChanged 获取姓名填写的回调
     * onIDTextChanged 身份证信息的回调
     * @private
     */
    _renderIDVerify() {
        if (this.state.baseInfo.isNeedFillInfo) {
            return (
                <OrderIDVerify
                    onNameTextChanged={(name) => this._getUserName(name)}
                    onIDTextChanged={(IDString) => this._getIDString(IDString)}
                    onFocus={(offsetY) => this.onKeyboardShowChangeScrollViewOffSet(offsetY) }
                />
            )
        } else {
            return null;
        }
    }

    /**
     * 支付方式选择
     * @private
     */
    _renderPayMethod() {
        return (
            <OrderPayMethod isSingle={this.state.isSingle}
                            data={this.state.orders}
                            onlinePayDown={this.state.baseInfo.onlinePayCutDown}/>
        )
    }

    /**
     * 配送日期选择
     * @private
     */
    _renderOrderDistributionDate() {
        return (
            <OrderDistributionDate isSingle={this.state.isSingle}
                                   data={this.state.orders}/>
        )
    }

    /**
     * 渲染底部账单信息
     * @private
     */
    _renderBillAmount() {
        return (
            <OrderMoneyInfo isSingle={this.state.isSingle}
                            billAmount={this.state.amountDetail}
                            data={this.state.orders}
                            isNeedFillInfo={this.state.baseInfo.isNeedFillInfo}/>
        )
    }

    /**
     * 渲染底部提交按钮以及地址提示
     * @private
     */
    _renderBottomSubmitView() {
        let {amountDetail, address, showBottomAdd} = this.state
        return (
            <OrderBottomSubmitView
                showBottomAdd={showBottomAdd}
                address={address.address}
                totalAmount={amountDetail.totalAmount}
                onPress={this._submitOrder.bind(this)}/>)
    }

    /**
     * 渲染商品信息
     * @private
     */
    _renderGoodsInfo() {
        if (this.state.orders && this.state.orders.length > 0) {
            let goods = [];
            this.state.orders.forEach((order, index) => {
                if (order.carts && order.carts.length >= 0) {
                    goods.push.apply(goods, order.carts);
                }
            });
            return (
                <OrderGoodList
                    style={{marginTop: ScreenUtils.scaleSize(20)}}
                    goods={goods}
                    totalCount={this.state.baseInfo.totalCount}
                />
            );
        } else {
            return null;
        }
    }

    /**
     * 全球购获取用户填写的姓名
     * @private
     */
    _getUserName(name) {
        if (this.state.baseInfo.userName !== name) {
            this.state.baseInfo.userName = name;
        }
    }

    /**
     * 全球购获取用户填写的身份证
     * @private
     */
    _getIDString(userIDString) {
        if (this.state.baseInfo.userIDString !== userIDString) {
            this.state.baseInfo.userIDString = userIDString;
        }
    }

    /**
     * 渲染发票信息
     * @private
     */
    _renderInvoiceInfo() {
        let self = this;
        if (this.state.baseInfo.canInvoice) {
            return (
                <InvoiceInfo
                    ref='invoiceInfo'
                    style={{marginTop: ScreenUtils.scaleSize(20)}}
                    invoiceType1={this.state.baseInfo.invoiceType1}
                    invoiceNum={this.state.baseInfo.invoiceNum}
                    isNeedInvoice={this.state.baseInfo.needInvoice}
                    title={this.state.baseInfo.invoiceName}
                    phone={this.state.baseInfo.invoicePhone}
                    mail={this.state.baseInfo.invoiceEmail}
                    isNeedCallBack={(need) => {
                        this.state.baseInfo.needInvoice = need;
                        if (this.state.isSingle === true) {
                            if (need === true) {
                                DataAnalyticsModule.trackEvent2("AP1706C016F005002K001001", "");
                            } else {
                                DataAnalyticsModule.trackEvent2("AP1706C016F005002K001002", "");
                            }
                        } else if (this.state.isSingle === false) {
                            if (need === true) {
                                DataAnalyticsModule.trackEvent2("AP1706C017F005001K001001", "");
                            } else {
                                DataAnalyticsModule.trackEvent2("AP1706C017F005001K001002", "");
                            }
                        }
                    }}
                    checked={this.state.baseInfo.invoiceType}
                    onInvoiceTypeChange={(event) => {
                        this.state.baseInfo.invoiceType = event.checked;
                        DataAnalyticsModule.trackEvent2("AP1706C016F011002O009001", "");
                    }}
                    onInvoiceNameChange={(name) => {
                        this.state.baseInfo.invoiceName = name;
                    }}
                    onInvoiceEmailChange={(email) => {
                        this.state.baseInfo.invoiceEmail = email;
                    }}
                    onInvoicePhoneChange={(phone) => {
                        this.state.baseInfo.invoicePhone = phone;
                    }}
                    onInvoiceType1Change={(num) => {
                        this.state.baseInfo.invoiceNum = num;
                    }}
                    onInvoiceType1Change1={(type) => {
                        this.state.baseInfo.invoiceType1 = type;
                    }}
                    onFocus={(y) => this.onKeyboardShowChangeScrollViewOffSet(y)}
                />
            );
        } else {
            return null;
        }
    }

    /**
     * 当填写发票信息的时候 防止键盘遮挡输入框
     * refName TextInput的指针
     * @private
     */
    onKeyboardShowChangeScrollViewOffSet(y) {
        // if (Platform.OS === 'ios') {
            // let scrollResponder = this.refs.scrollView.getScrollResponder();
            // scrollResponder.scrollResponderScrollNativeHandleToKeyboard(
            //     ReactNative.findNodeHandle(this.refs.invoiceInfo.refs[refName]),
            //     ScreenUtils.scaleSize(340), true);
            this.refs.scrollView && this.refs.scrollView.scrollTo({y: y}, true)
        // }
    }

    /**
     * 渲染抵用券
     * @private
     */
    _renderCouponList() {
        return (
            <CouponList
                style={{marginTop: ScreenUtils.scaleSize(20)}}
                orders={this.state.orders}
            />
        );
    }

    /**
     * 当接受到修改抵用券的消息的时候 修改账单信息
     * @private
     */
    refreshMoneyInfo() {
        let data = this.state.orders;
        let amount = 0;
        for (let index in data) {
            let tempData = data[index];
            if (tempData.isCouponUsable === 'YES' && tempData.couponList && tempData.couponList.length > 0) {
                if (Number(tempData.couponIndex)) {
                    if (Number(tempData.couponIndex) >= 0) {
                        amount += Number(tempData.couponList[Number(tempData.couponIndex)].real_coupon_amt)
                    }
                } else {
                    amount += Number(tempData.couponList[0].real_coupon_amt)
                }
            }
        }
        let tempAmount = this.state.amountDetail;
        tempAmount.voucher = amount;
        tempAmount.totalAmount = Number((tempAmount.foodsAmount * 100 - tempAmount.discount * 100 - amount * 100 -
            tempAmount.freight * 100 + tempAmount.tax * 100 + tempAmount.freight * 100) / 100).toFixed(2)
        this.setState({
            amountDetail: tempAmount
        })
    }


    /**
     * 获取订单数据
     * @private
     */
    _doPostData(page) {
        if ('PAGE_FROM_CATRS' === page) {//购物车跳转到填写订单
            this._doPostFromCart({cartSeqs, dcrate_yn, app_first_dc_yn} = this.props);
        } else if ('PAGE_FROM_LIJI' === page) {//商品详情（立即购买）跳转到填写订单
            this._doPostFromImm({
                item_codes: this.props.item_codes,
                item_units: this.props.item_units,
                emp_yn: this.props.emp_yn,
                gift_item_code_str: this.props.gift_item_code_str,
                item_counts: this.props.item_counts,
                media_channel: this.props.media_channel,
                memberPromo: this.props.memberPromo,
                receiver_seq: this.props.receiver_seq,
                imgSize: this.props.imgSize,
            });
        } else if ('PAGE_FROM_YUYUE' === page) {//商品详情（预约）跳转到填写订单
            this._doPostFromAppoint();
        }
        // this._doPostFromCart({cartSeqs, dcrate_yn, app_first_dc_yn} = this.props);
    }

    /**
     * 购物车（获取订单信息）
     * @param cartSeqs array 购物车序列号
     * @param dcrate_yn 是否使用员工折扣
     * @param app_first_dc_yn 是否app首购
     * @private
     */
    _doPostFromCart({cartSeqs, dcrate_yn, app_first_dc_yn}) {
        if (!cartSeqs || cartSeqs.length == 0)return;
        if (this.getOrderInfoRequest) this.getOrderInfoRequest.setCancled(true);
        cartSeqs = cartSeqs.join(',');
        let params = {
            cartSeqs: cartSeqs,
            dcrate_yn: dcrate_yn,
            receiver_seq: this.state.address.addressSeq,
            app_first_dc_yn: app_first_dc_yn,
            imgSize: 'P'
        };
        this.getOrderInfoRequest = new GetOrderInfoRequest(params, 'POST');
        this.getOrderInfoRequest.showLoadingView();
        this.getOrderInfoRequest.start((response) => {
            // 判断是否为单商品
            if (response.orders && response.orders.length > 0 && response.orders[0].carts &&
                response.orders[0].carts.length === 1) {
                this.state.isSingle = true
            } else {
                this.state.isSingle = false
            }
            this.setState({
                address: Object.assign(this.state.address, response.address),
                amountDetail: Object.assign(this.state.amountDetail, response.amountDetail),
                baseInfo: Object.assign(this.state.baseInfo, response.baseInfo),
                orders: response.orders,
            });
            if (!firstRender) {
                DeviceEventEmitter.emit('REQUEST_CHANGE_ADDRESS', '切换地址的时候重新初始化数据')
            } else {
                let params = potentialOrderInfo(this.state.baseInfo, this.state.amountDetail, this.state.address, this.state.orders);
                params.order_cfm_yn = '0'
                new OrderAddPotentialorder(params, 'POST').start();
            }
            firstRender = false
        }, (erro) => {
            this.setState({
                showErro: true
            });
        });
    }

    /**
     * 立即购买跳转过来
     * @param item_codes //商品编号
     * @param item_units //商品规格号
     * @param emp_yn //是否app首购
     * @param gift_item_code_str //赠品编号str 可以为空
     * @param item_counts //物品数量
     * @param media_channel//不明确，可为空
     * @param memberPromo//不明确，可为空
     * @param receiver_seq//地址seq
     * @param imgSize//图片质量，默认P
     * @private
     */
    _doPostFromImm(params = {imgSize: 'P'}) {
        //判断是否有订单号
        if (params.item_codes && params.item_codes.length > 0) {
            //如果选择了地址就拿当次地址请求
            if (this.state.address.addressSeq && this.state.address.addressSeq.length > 0) {
                params.receiver_seq = this.state.address.addressSeq;
            }
            this.immediatelyRequest && this.immediatelyRequest.setCancled(true);
            this.immediatelyRequest = new OrderInfoImmediatelyRequest(params, 'POST');
            this.immediatelyRequest.showLoadingView().start((response) => {
                // console.log(JSON.stringify(response));
                // 判断是否为单商品
                if (response.orders && response.orders.length > 0 && response.orders.carts &&
                    response.orders.carts.length === 1) {
                    this.state.isSingle = true
                } else if (response.orders && response.orders.length > 0 && response.orders.carts &&
                    response.orders.carts.length >= 1) {
                    this.state.isSingle = false
                }
                this.setState({
                    address: Object.assign(this.state.address, response.address),
                    amountDetail: Object.assign(this.state.amountDetail, response.amountDetail),
                    baseInfo: Object.assign(this.state.baseInfo, response.baseInfo),
                    orders: response.orders,
                });
                if (!firstRender) {
                    DeviceEventEmitter.emit('REQUEST_CHANGE_ADDRESS', '切换地址的时候重新初始化数据')
                } else {
                    let params = formatParams(this.state.baseInfo, this.state.amountDetail, this.state.address, this.state.orders);
                    params.order_cfm_yn = '0';
                    new OrderAddPotentialorder(params, 'POST').start();
                }
                firstRender = false
            }, (erro) => {
                this.setState({
                    showErro: true
                });
            });
        }
    }

    /**
     * 预约商品跳转过来
     * @private
     */
    _doPostFromAppoint() {
    }

    /**
     * 提交订单
     * @private
     */
    _submitOrder() {
        if (this.state.orders && this.state.orders.length > 0) {
            // 验证姓名是否为中文
            let nameReg = /^[\u4E00-\u9FA5]+$/;
            if (this.state.isSingle === true) {
                DataAnalyticsModule.trackEvent2("AP1706C016F008001O008001", "");
            } else if (this.state.isSingle === false) {
                DataAnalyticsModule.trackEvent2("AP1706C017F008001O008001", "");
            }
            //如果没有填写订单地址
            if (!this.state.address.addressSeq || this.state.address.addressSeq.length === 0) {
                this.showMessage('请选择收获地址', DURATION.LENGTH_SHORT);
                return;
            }
            //如果是驴妈妈或者全球购等商品 必须填写个人信息
            if (this.state.baseInfo.isNeedFillInfo) {
                if (this.state.baseInfo.userName.length === 0 || this.state.baseInfo.userIDString.length === 0) {
                    this.showMessage('请完善证件信息', DURATION.LENGTH_SHORT);
                    return;
                }
                if (!nameReg.test(this.state.baseInfo.userName)) {
                    this.showMessage('请输入正确的姓名', DURATION.LENGTH_SHORT);
                    return;
                }
                // 验证身份证
                let reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
                if (!reg.test(this.state.baseInfo.userIDString)) {
                    this.showMessage('请输入正确的身份证信息', DURATION.LENGTH_SHORT);
                    return;
                }
            }
            //需要发票信息 判断发票信息是否完整
            if (this.state.baseInfo.needInvoice && this.state.baseInfo.canInvoice) {
                let {invoiceName, invoicePhone, invoiceType1, invoiceNum} = this.state.baseInfo;
                if ((invoiceType1 === 1)) {
                    if (invoiceNum.length === 0) {
                        this.showMessage('请输入纳税人识别号', DURATION.LENGTH_SHORT);
                        return;
                    }
                    if (invoiceName.length === 0) {
                        this.showMessage('请完善公司名称', DURATION.LENGTH_SHORT);
                        return;
                    }
                    // 纳税人识别码 基本校验
                    let taxNumber = /(^[0-9A-Za-z]{15}$)|(^[0-9A-Za-z]{17}$)|(^[0-9A-Za-z]{18}$)|(^[0-9A-Za-z]{20}$)/
                    if (!taxNumber.test(invoiceNum)) {
                        this.showMessage('请输入正确的纳税人识别号', DURATION.LENGTH_SHORT);
                        return;
                    }
                } else if (invoiceType1 !== 1) {
                    if (invoiceName.length === 0 || invoicePhone.length === 0) {
                        this.showMessage('请完善发票信息', DURATION.LENGTH_SHORT);
                        return;
                    }
                    // 手机号基本校验
                    let phoneNuber = /(^1[0-9]{10}$)/
                    if (!phoneNuber.test(invoicePhone)) {
                        this.showMessage('请填写正确的手机号码', DURATION.LENGTH_SHORT);
                        return;
                    }

                }
            }
            if (this.orderFillRequest) this.orderFillRequest.setCancled(true);
            //格式化提交参数
            let params = formatParams(this.state.baseInfo, this.state.amountDetail, this.state.address, this.state.orders);
            this.orderFillRequest = new OrderFillRequest(params, 'POST');
            this.orderFillRequest.showLoadingView();
            this.orderFillRequest.start((response) => {
                if (response.data) {
                    let potentialOrder = potentialOrderInfo(this.state.baseInfo, this.state.amountDetail, this.state.address, this.state.orders);
                    potentialOrder.order_cfm_yn = '1';
                    //订单提交成功
                    if (response.data.order_noList && response.data.order_noList.length > 0) {
                        this.showMessage('订单提交成功', DURATION.LENGTH_SHORT);
                        // Actions.pop({popNum: 1});
                        let orders = [];
                        response.data.order_noList.forEach((order, index) => {
                            orders.push(order.order_no);
                            if (potentialOrder.orders && potentialOrder.orders[index]) {
                                potentialOrder.orders[index].final_order_no = order.order_no;
                            }
                        });
                        new OrderUpdatePotentialorder(potentialOrder, 'POST').start();
                        if (Platform.OS === 'ios') {
                            setTimeout(() => {
                                Actions.pop();
                                // RNconnect.pushs({
                                //     page: routeConfig.MePageocj_Pay,
                                //     param: {orders: orders}
                                // }, (events) => {
                                //     NativeRouter.nativeRouter(events);
                                // });
                                RouteManager.routeJump({
                                    page: routeConfig.Pay,
                                    param: {orders: orders}
                                })
                            }, 500);
                        } else {
                            Actions.pop();
                            // RNconnect.pushs({page: routeConfig.MePageocj_Pay, param: {orders: orders}}, (events) => {
                            //     NativeRouter.nativeRouter(events);
                            // });
                            RouteManager.routeJump({
                                page: routeConfig.Pay,
                                param: {orders: orders}
                            })

                        }
                    }
                }
            }, (erro) => {
                if (erro.message && erro.message.length > 0) {
                    if (erro.code && String(erro.code) === '400') {
                        this.showMessage(erro.message, DURATION.LENGTH_LONG);
                    } else {
                        this.showMessage('网络异常', DURATION.LENGTH_LONG);
                    }
                }
            });
        }
    }

    /**
     * toast弹出信息
     * @param text 信息
     * @param duration 时间
     */
    showMessage(text, duration) {
        this.refs.toast && this.refs.toast.show(text, duration);
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.background_grey
    },
    titleTextStyle: {
        color: Colors.text_white,
        backgroundColor: 'transparent'
    },
    bottomSubmitView: {}

});

