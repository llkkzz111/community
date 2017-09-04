/**
 * created by zhenzhen
 * 订单中心主页
 */

'use strict';
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    DeviceEventEmitter,
    Platform,
    Text,
    Dimensions,
    TouchableOpacity,
    ScrollView,
    FlatList,
    Image,
    Linking
} from 'react-native';
import NavigationBar from '../../../foundation/common/NavigationBar';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
import OrderAddress from './details/OrderAddress';
import GoodInfo from './GoodInfo';
import OrderItemDetails from './details/OrderItemDetails';
import OrderStatus from './details/OrderStatus';
import OrderPriceInfo from './details/OrderPriceInfo';
import OrderButton from './details/OrderButton';
import KeFuRequest from '../../../foundation/net/GoodsDetails/KeFuRequest';
import {Actions} from 'react-native-router-flux';
import GetOderListDetailRequest from '../../../foundation/net/mine/GetOrderListDetailRequest';
import CancelOtherOrder from '../../../foundation/net/mine/CancelOtherOrder';
import CancelSubscribeOrder from '../../../foundation/net/mine/CancelSubscribeOrder';
import AllCommonDialog from '../../../foundation/dialog/AllCommonDialog';
import CancelReasonDialog from './details/CancleReasonDialog';
import Datas from './Datas';
import * as RouteManager from '../../config/PlatformRouteManager';
import * as routeConfig from '../../config/routeConfig'
import GetBillDetailRequest from '../../../foundation/net/mine/GetBillDetailRequest';
import OrderInstallRequest from '../../../foundation/net/order/OrderInstallRequest';
import RnConnect from '../../config/rnConnect';
import {
    detailsBackPress as TDDetailsBackPress,
    connectService as TDConnectService,
    cancelOrder as TDCancelOrder,
    detailsGoPay as TDDetailsGoPay,
    detailsLookLogistis as TDDetailsLookLogistis,
    detailsAllReturn as TDDetailsAllReturn,
    applyReturn as TDApplyReturn,
    applyExchange as TDApplyExchange,
    applyInstall as TDApplyInstall
} from './OrderTdUtils';

export default class OrderDetail extends Component {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            orderDetail: null
        }
        this._cancelOrder = this._cancelOrder.bind(this);
        this._onCancelOrder = this._onCancelOrder.bind(this);
    }

    render() {
        return (
            <View style={styles.container}>
                {/*渲染navbar*/}
                {this._renderNavbar()}
                {/*主内容模块*/}
                {this.state.orderDetail !== null ? (
                    <ScrollView
                        style={styles.contentContainer}
                    >
                        {/*渲染头部status模块*/}
                        {this._renderStatus()}
                        {/*渲染地址信息模块*/}
                        {this._renderAddress()}
                        {/*渲染商品详情模块*/}
                        {this._renderItems()}
                        {/*渲染订单价格信息模块*/}
                        {this._renderPriceModel()}
                        {/*渲染订单交易信息模块*/}
                        {this._renderOrderTransactionInfo()}
                        {/*渲染联系客服模块*/}
                        {this._renderContactCustomerService()}
                        {/*渲染底部button*/}
                        {this._renderBottomButton()}
                    </ScrollView>
                ) : null}
                <AllCommonDialog
                    ref={(ref) => this.cancleDialog = ref}
                    titleContainer={{
                        paddingHorizontal: ScreenUtils.scaleSize(50),
                        paddingVertical: ScreenUtils.scaleSize(50)
                    }}
                    title={Datas.TEXTS.cancleTitle}
                    cancelText={Datas.TEXTS.cancleText}
                    onCancle={() => {
                        this.cancleDialog && this.cancleDialog.show(false);
                    }}
                    confirmText={Datas.TEXTS.confirmText}
                    onConfirm={() => {
                        this.cancleDialog && this.cancleDialog.show(false);
                        setTimeout(() => {
                            this.cancelReasonDialog && this.cancelReasonDialog.show(true);
                        }, 200);
                    }}
                />
                <AllCommonDialog
                    ref={(ref) => this.telephoneDialog = ref}
                    titleContainer={{
                        paddingHorizontal: ScreenUtils.scaleSize(50),
                        paddingVertical: ScreenUtils.scaleSize(50)
                    }}
                    title={Datas.telephoneText.cancelTitle}
                    cancelText={Datas.telephoneText.cancelText}
                    onCancle={() => {
                        this.telephoneDialog && this.telephoneDialog.show(false);
                    }}
                    confirmText={Datas.telephoneText.confirmText}
                    onConfirm={() => {
                        try {
                            this.telephoneDialog && this.telephoneDialog.show(false);
                            setTimeout(() => {
                                Linking.openURL("tel:" + "4008898000").catch(err => {
                                })
                            }, 200);
                        } catch (erro) {
                        }
                    }}
                />
                <AllCommonDialog
                    ref={(ref) => this.commonDialog = ref}
                    titleContainer={{
                        paddingHorizontal: ScreenUtils.scaleSize(50),
                        paddingVertical: ScreenUtils.scaleSize(50)
                    }}
                    cancelText={Datas.telephoneText.cancelText}
                    confirmText={Datas.telephoneText.confirmText}
                />
                <CancelReasonDialog
                    ref={(ref) => this.cancelReasonDialog = ref}
                    onConfirmClick={this._onCancelOrder}
                />
            </View>
        );
    }

    /**
     * 渲染navbar
     * @private
     */
    _renderNavbar() {
        return (
            <NavigationBar
                title={'订单详情'}
                navigationStyle={{...Platform.select({ios: {marginTop: -22}}), marginBottom: ScreenUtils.scaleSize(1)}}
                titleStyle={{
                    color: Colors.text_black,
                    backgroundColor: 'transparent',
                    fontSize: ScreenUtils.scaleSize(36)
                }}
                barStyle={'dark-content'}
                onLeftPress={() => {
                    TDDetailsBackPress(this.props.page);
                    Actions.pop();
                }}
            />
        );
    }

    /**
     * 渲染status模块
     * @private
     */
    _renderStatus() {
        let status = '';
        let orderNo = this.props.orderNo;
        let orderTime = '';
        let cancleReason = ''
        if (this.state.orderDetail && this.state.orderDetail !== null) {
            orderTime = ScreenUtils.toDate(parseFloat(this.state.orderDetail.order_date));
            cancleReason = this.state.orderDetail.cancleReason;
            status = this.state.orderDetail.proc_state_str;
        }
        return (
            <OrderStatus
                status={status}
                orderNo={orderNo}
                orderTime={orderTime}
                cancleReason={cancleReason}/>
        );
    }

    /**
     * 渲染地址模块
     * @private
     */
    _renderAddress() {
        let name = '';
        let phone = '';
        let address = '';
        if (this.state.orderDetail && this.state.orderDetail !== null && this.state.orderDetail.receiver) {
            let receiver = this.state.orderDetail.receiver;
            name = receiver.receiver_name;
            phone = receiver.hp_no;
            address = receiver.receiver_addr;
        }
        return (
            <OrderAddress
                style={{marginTop: ScreenUtils.scaleSize(20)}}
                receiveName={name}
                receivePhone={phone}
                address={address}
                hasAddress={true}
            />
        );
    }

    /**
     * 渲染物品信息
     * @private
     */
    _renderItems() {
        let items = [];
        let orderNo = this.props.orderNo;
        let isShowAllReturn = false;//需要从接口返回
        if (this.state.orderDetail && this.state.orderDetail !== null && this.state.orderDetail.items) {
            if (this.state.orderDetail.items.length > 0) {
                items = this.state.orderDetail.items;
                isShowAllReturn = this.state.orderDetail.isAllReturn;
            }
        }
        return (
            <OrderItemDetails
                style={{marginTop: ScreenUtils.scaleSize(20)}}
                datas={items}
                isShowAllReturn={isShowAllReturn}
                onAllReturnClick={() => {
                    this._allReturn();
                }}
                orderNo={orderNo}
                onReturnClick={(goods) => {
                    this._goReturnOrExchange(true, goods);
                }}
                onExchangeClick={(goods) => {
                    this._goReturnOrExchange(false, goods);
                }}
                onInstallClick={(goods) => {
                    this._goInstallGoods(goods);
                }}
                onSendClick={(goods) => {
                    this._goSendGoods(goods);
                }}
                onExchangeDetails={(goods) => {
                    this._goExchangeDetails(goods);
                }}
                page={this.props.page}
            />
        );
    }

    /**
     * 渲染订单交易信息模块
     * @returns {XML}
     * @private
     */
    _renderOrderTransactionInfo() {
        let {orderDetail} = this.state;
        let orderNo = this.props.orderNo;
        let createTime = '';//待给出
        let autoCloseTime = '';//待给出
        let closeTime = '';//待给出
        let payTime = '';//待给出
        if (orderDetail && orderDetail !== null) {
            if (parseFloat(orderDetail.order_date) !== NaN) {
                createTime = ScreenUtils.toDate(parseFloat(orderDetail.order_date));
            }
            if (parseFloat(orderDetail.payDate) !== NaN) {
                payTime = ScreenUtils.toDate(parseFloat(orderDetail.payDate));
            }
            if (parseFloat(orderDetail.end_time) !== NaN) {
                autoCloseTime = ScreenUtils.toDate(parseFloat(orderDetail.end_time));
            }
            if (parseFloat(orderDetail.order_close_date) !== NaN) {
                closeTime = ScreenUtils.toDate(parseFloat(orderDetail.order_close_date));
            }
        }
        return (
            <View style={styles.transactionInfo}>
                {this._renderTransactionInfoItem('订单编号：', orderNo)}
                {(createTime && createTime.length > 0) ? this._renderTransactionInfoItem('创建时间：', createTime) : null}
                {(autoCloseTime && autoCloseTime.length > 0) ? this._renderTransactionInfoItem('交易自动关闭时间：', autoCloseTime) : null}
                {(closeTime && closeTime.length > 0) ? this._renderTransactionInfoItem('交易关闭时间：', closeTime) : null}
                {(payTime && payTime.length > 0) ? this._renderTransactionInfoItem('付款时间：', payTime) : null}
            </View>
        );
    }

    _renderTransactionInfoItem(type, info) {
        return (
            <View style={styles.transactionInfoView}>
                <Text
                    allowFontScaling={false}
                    style={styles.transactionInfoText}>
                    {type}
                </Text>
                <Text
                    allowFontScaling={false}
                    style={styles.transactionInfoText}>
                    {info}
                </Text>
            </View>
        );
    }

    /**
     * 渲染联系客服模块
     * @returns {XML}
     * @private
     */
    _renderContactCustomerService() {
        return (
            <TouchableOpacity onPress={this._goCustomerService.bind(this)}>
                <View style={styles.contactCustomerService}>
                    <Image
                        style={styles.imaStyle}
                        source={require('../../../foundation/Img/goodsdetail/kefu_.png')}
                    />
                    <Text
                        allowFontScaling={false}
                        style={styles.customerServiceText}>
                        联系客服
                    </Text>
                </View>
            </TouchableOpacity>
        );
    }

    /**
     * 渲染价格模块
     * @private
     */
    _renderPriceModel() {
        let payType = '';//支付方式
        let goodsSumAmt = '';//商品总额
        let beneficialPrice = '';//优惠价格
        let couponPrice = '';
        let prepaymentsAmt = '';
        let sumPoints = '';
        let freight = '';
        let orderSumPrice = '';
        let showAmtStr = '';
        let showAmt = '';
        let giftCard = '';
        let globalTax = ''; //跨境综合税
        let onLineSub = ''; //在线立减5元
        let noPayOnlineSub = ''; //在线立减优惠提示
        let orderDetails = this.state.orderDetail;
        if (orderDetails && orderDetails !== null) {
            payType = orderDetails.linePay_name;
            goodsSumAmt = orderDetails.itemsSumAmt;
            beneficialPrice = orderDetails.youhu_dcamt;
            sumPoints = orderDetails.saveamt;
            freight = orderDetails.freight;
            couponPrice = orderDetails.cupon_dcamt;
            prepaymentsAmt = orderDetails.deposit;
            orderSumPrice = orderDetails.showAmt;
            showAmtStr = orderDetails.showAmtStr;
            showAmt = orderDetails.showAmt;
            giftCard = orderDetails.giftcard;
            globalTax = orderDetails.postalTaxAmt;
            onLineSub = orderDetails.OnlineSub;
            noPayOnlineSub = orderDetails.noPayOnlineSub;
        }
        return (
            <OrderPriceInfo
                payType={payType}
                goodsSumAmt={goodsSumAmt}
                beneficialPrice={beneficialPrice}
                couponPrice={couponPrice}
                prepaymentsAmt={prepaymentsAmt}
                sumPoints={sumPoints}
                freight={freight}
                orderSumPrice={'' + orderSumPrice}
                showAmt={'' + showAmt}
                showAmtStr={showAmtStr}
                globalTax={globalTax}
                onTaxClick={() => {
                    Actions.OrderWebViewHideNavBar({url: 'http://m.ocj.com.cn/staticPage/shop/m/tarrif_rules.jsp'});
                }}
                giftCard={giftCard}
                onLineSub={onLineSub}
                noPayOnlineSub={noPayOnlineSub}
            />
        );
    }

    /**
     * 渲染底部button
     * @private
     */
    _renderBottomButton() {
        let {orderDetail} = this.state;
        let isNoPay = false;
        let isShowFapiao = false;
        let isShowWuliu = false;
        let isShowComment = false;
        let isShowCancel = false;
        let currTime = '';
        let endTime = '';
        if (orderDetail && orderDetail !== null) {
            isShowCancel = orderDetail.showCancelOrderButtonYn;
            isShowFapiao = orderDetail.isShowFapiao;
            isNoPay = orderDetail.isNoPayButton;
            isShowWuliu = orderDetail.isShowWuliu;
            isShowComment = orderDetail.isShowComment;
            endTime = orderDetail.end_time;
            currTime = orderDetail.curr_time;
        }
        return (
            <OrderButton
                isNoPay={isNoPay}
                isShowFapiao={isShowFapiao}
                isShowWuliu={isShowWuliu}
                isShowComment={isShowComment}
                isShowCancel={isShowCancel}
                onCancleClick={this._cancelOrder}
                immediatePay={this._immediatePay.bind(this)}
                viewWuliu={() => {
                    this._viewWuliu();
                }}
                viewFapiao={() => {
                    this._viewFapiao();
                }}
                goComment={() => {
                    this._goComment();
                }}
                currTime={currTime}
                endTime={endTime}
            />
        );
    }

    /**
     * 跳转客服
     * @private
     */
    _goCustomerService() {
        TDConnectService(this.props.page);
        if (this.ContactCustomerService) {
            this.ContactCustomerService.setCancled(true)
        }
        this.ContactCustomerService = new KeFuRequest({
            order_no: "",
            item_code: "",
            imsource: "",
            last_sale_price: "",
        }, "GET");
        this.ContactCustomerService.showLoadingView(true).start((response) => {
            if (response.code === 200 && response.data !== null && response.data.url) {
                Actions.VipPromotionGoodsDetail({value: response.data.url});
            } else {
            }
        }, (err) => {
        });
    }

    componentDidMount() {
        this._doPost();
    }

    /**
     * 请求数据
     * @private
     */
    _doPost() {
        let self = this;
        const {orderNo, orderType, cCode} = this.props;
        if (this.getOderListDetailRequest) {
            this.getOderListDetailRequest.setCancled(true);
        }
        //创建一个请求，参数（请求参数、请求方法）
        this.getOderListDetailRequest = new GetOderListDetailRequest({
            order_no: orderNo,
            order_type: orderType,
            c_code: cCode,
        }, 'GET');
        this.getOderListDetailRequest.showLoadingView().start(
            (response) => {
                if (response.data) {
                    this.setState({
                        orderDetail: response.data
                    });
                }
            }, (erro) => {
            });
    }

    /**
     * 弹出取消订单dialog
     * @private
     */
    _cancelOrder() {
        TDCancelOrder(this.props.page);
        this.cancleDialog && this.cancleDialog.show(true);
    }

    /**
     *弹出取消订单dialog并且点击确定
     * @private
     */
    _onCancelOrder(reasonCode) {
        if (this.cancelOrder) {
            this.cancelOrder.setCancled(true);
        }
        const {orderNo, orderType} = this.props;
        let params = {
            order_no: orderNo,
            cancel_code: reasonCode
        };
        if (orderType === Datas.orderTypes.preOrder) {
            this.cancelOrder = new CancelSubscribeOrder(params, 'POST');
        } else {
            this.cancelOrder = new CancelOtherOrder(params, 'POST');
        }
        this.cancelOrder.showLoadingView().start(
            (response) => {
                if (response.code === '200' || response.code === 200) {
                    DeviceEventEmitter.emit(Datas.flags.refrushOrder);
                    Actions.pop();
                }
            }, (erro) => {
            });
    }

    /**
     * 立即付款
     * @private
     */
    _immediatePay() {
        TDDetailsGoPay(this.props.page);
        let orderNo = this.props.orderNo;
        RouteManager.routeJump({
            page: routeConfig.Pay,
            param: {orders: [orderNo]}
        }, (event) => {
            //刷新订单列表数据
            DeviceEventEmitter.emit(Datas.flags.refrushOrder, {refresh: false});
            //刷新订单详情数据
            this._doPost();
        })
    }

    /**
     * 申请退货或换货
     * @private
     */
    _goReturnOrExchange(isReturn, goods) {
        // this._telephoneReturnOrExchange();
        // return;
        let orderNo = this.props.orderNo;
        if (this.state.orderDetail && this.state.orderDetail.items && goods) {
            if (isReturn) {
                TDApplyReturn(this.props.page);
                RouteManager.routeJump({
                    page: routeConfig.Return,
                    param: {
                        items: [goods],
                        orderNo: orderNo,
                        retExchYn: '1'
                    }
                }, (event) => {
                    this._refreshCurrentPage();
                });
            } else {
                TDApplyExchange(this.props.page);
                RouteManager.routeJump({
                    page: routeConfig.Exchange,
                    param: {
                        items: [goods],
                        orderNo: orderNo,
                        retExchYn: '2'
                    }
                }, (event) => {
                    this._refreshCurrentPage();
                });
            }
        }
    }

    /**
     * 申请安装
     * @private
     */
    _goInstallGoods(goods) {
        TDApplyInstall(this.props.page);
        if (this.orderInstallRequest) {
            this.orderInstallRequest.setCancled(true);
        }
        this.orderInstallRequest = new OrderInstallRequest({
            order_no: this.props.orderNo,
            order_g_seq: goods.order_g_seq,
            item_code: goods.item_code
        }, 'POST');
        this.orderInstallRequest.showLoadingView().start(
            (response) => {
                if (response && response.data && response.data.result && response.data.result.length > 0) {
                    this.commonDialog.showDialog(true, response.data.result, () => {
                        this.commonDialog.show(false);
                    }, () => {
                        this.commonDialog.show(false);
                    })
                }
            }, (erro) => {
                if (erro && erro.message && erro.message.length > 0) {
                    this.commonDialog.showDialog(true, erro.message, () => {
                        this.commonDialog.show(false);
                    }, () => {
                        this.commonDialog.show(false);
                    })
                }
            });
    }

    /**
     * 申请送货
     * @private
     */
    _goSendGoods(goods) {
        alert('申请送货')
    }

    /**
     * 查看退换货详情
     * @private
     */
    _goExchangeDetails(goods) {
        Actions.ExchangeDetail({orderNo: this.props.orderNo});
    }

    /**
     * 查看物流
     * @private
     */
    _viewWuliu() {
        TDDetailsLookLogistis(this.props.page);
        Actions.ViewLogistics({orderNo: this.props.orderNo});
    }

    /**
     * 查看发票
     * @private
     */
    _viewFapiao() {
        if (this.getBillDetailRequest) {
            this.getBillDetailRequest.setCancled(true);
        }
        let orderSeq = '';
        if (this.state.orderDetail && this.state.orderDetail.items && this.state.orderDetail.items.length > 0) {
            orderSeq = this.state.orderDetail.items[0].order_g_seq;
        }
        this.getBillDetailRequest = new GetBillDetailRequest({
            order_no: this.props.orderNo,
            order_g_seq: orderSeq
        }, 'GET');
        this.getBillDetailRequest.showLoadingView().start(
            (response) => {
                if (response && response.data && response.data.length >= 0) {
                    let url = response.data[0].rcpt_url;
                    if (url && url.length > 0) {
                        if (Platform.OS === 'ios') {
                            Actions.BillListDetailPage({data: url});
                        } else {
                            AndroidRouterModule.startSystemBrowser(url);
                        }
                    }
                }
            }, (erro) => {
            });
    }

    /**
     * 去评价
     * @private
     */
    _goComment() {
        let orderNo = this.props.orderNo;
        let orderType = this.props.orderType;
        RouteManager.routeJump({
            page: routeConfig.Valuate,
            param: {orderNo: orderNo, ordertype: orderType}
        }, (event) => {
            this._refreshCurrentPage();
        })
    }

    /**
     * 整单退货
     * @private
     */
    _allReturn() {
        TDDetailsAllReturn(this.props.page);
        // this._telephoneReturnOrExchange();
        // return;
        let orderNo = this.props.orderNo;
        if (this.state.orderDetail && this.state.orderDetail.items) {
            let items = this.state.orderDetail.items;
            RouteManager.routeJump({
                page: routeConfig.Return,
                param: {
                    items: items,
                    orderNo: orderNo,
                    retExchYn: '1'
                }
            }, (event) => {
                this._refreshCurrentPage();
            })
        }
    }

    /**
     *  刷新页面
     */
    _refreshCurrentPage() {
        //刷新订单列表数据
        DeviceEventEmitter.emit(Datas.flags.refrushOrder, {refresh: false});
        //刷新订单详情数据
        this._doPost();
    }

    _telephoneReturnOrExchange() {
        this.telephoneDialog && this.telephoneDialog.show(true);
    }

    componentWillUnMount() {
        if (this.getOderListDetailRequest) {
            this.getOderListDetailRequest.setCancled(true);
        }

        if (this.cancelOrder) {
            this.cancelOrder.setCancled(true);
        }

        if (this.getBillDetailRequest) {
            this.getBillDetailRequest.setCancled(true);
        }

        if (this.ContactCustomerService) {
            this.ContactCustomerService.setCancled(true)
        }
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_grey
    },
    contentContainer: {
        flex: 1,
        width: ScreenUtils.screenW,
    },
    transactionInfo: {
        width: ScreenUtils.screenW,
        flex: 1,
        backgroundColor: Colors.background_white,
        padding: ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(20),
    },
    transactionInfoView: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: ScreenUtils.scaleSize(10),
    },
    transactionInfoText: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(26),
    },
    contactCustomerService: {
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.background_white,
        padding: ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(20),
        flexDirection: 'row'
    },
    customerServiceText: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(26),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    imaStyle: {
        width: ScreenUtils.scaleSize(59 / 2),
        height: ScreenUtils.scaleSize(51 / 2),
        resizeMode: 'stretch'
    }
});