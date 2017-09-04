/**
 * Created by MASTERMIAO on 2017/6/4.
 * 立即购买 获取订单详情
 */
import BaseRequest from '../BaseRequest';

export default class OrderInfoImmediatelyRequest extends BaseRequest {
    requestUrl() {
        return '/api/orders/orders/singleorderconfirm';
    }
    handleResponse(responseJson, successCallBack) {
        super.handleResponse(responseJson, (responseJson)=> {
            let response = {
                //返回给页面的地址信息
                address: {
                    address: ''
                },
                //对应页面中的订单价格信息
                amountDetail: {},
                //对应所有的购物车订单
                orders: [],
                baseInfo: {
                    isNeedFillInfo: false,//是否是全球购或者驴妈妈商品
                    canInvoice: false,//是否可以开发票
                    invoiceName: '',//发票收票人
                    invoicePhone: '',//收票人手机号码
                    invoiceEmail: '',//收票人邮箱
                }
            };

            if (responseJson && responseJson.data) {
                let data = responseJson.data;
                //获取地址信息
                if ((data && data.selectedTreceiver) || (data && data.receivers)) {
                    let receivers = data.selectedTreceiver || data.receivers;
                    if (receivers.receiver_seq && receivers.receiver_seq.length > 0) {
                        response.address.hasAddress = true;//有地址信息
                        response.address.addressSeq = receivers.receiver_seq;//地址序列号
                        response.address.receiveName = receivers.receiver_name;
                        response.address.receivePhone = receivers.receiver_hp;
                        response.address.isDefaultAdd = false;
                        if (receivers.default_yn && receivers.default_yn === '1') {
                            response.address.isDefaultAdd = '1';
                        }
                        if (receivers.receiver_hp && receivers.receiver_hp.length >= 11) {//带星号的手机号
                            let phoneWidthStart = '';
                            let length = receivers.receiver_hp.length;
                            phoneWidthStart = receivers.receiver_hp.substring(0, 3) + '****' + receivers.receiver_hp.substring(length - 4, length);
                            response.address.receivePhoneWidthStart = phoneWidthStart;
                        }
                        //获取省市区
                        if (receivers.addr_m) {
                            response.address.address = receivers.addr_m;
                        }
                        //获取详细地址
                        if (receivers.receiver_addr) {
                            response.address.address += receivers.receiver_addr;
                        }
                    }
                }
                //获取订单金额数据
                if (data.total_price) {
                    response.amountDetail.foodsAmount = data.total_price;
                }
                //优惠总金额
                if (data.dc_amt) {
                    response.amountDetail.discount = data.dc_amt;
                }
                //抵用券优惠金额
                if (data.coupon_price) {
                    response.amountDetail.voucher = data.coupon_price;
                }
                //配送费
                if (data.delivery_price) {
                    response.amountDetail.freight = data.delivery_price;
                }
                //关税
                if (data.total_postal_amt) {
                    response.amountDetail.tax = data.total_postal_amt;
                }
                //商品总价
                if (data.total_real_price) {
                    response.amountDetail.totalAmount = data.total_real_price;
                }
                //获取所有订单
                if (data.orders && data.orders.length > 0) {
                    response.orders.push.apply(response.orders, data.orders);
                }
                //获取isNeedFillInfo(验证是否是全球购商品)
                if (data.realNameInfo) {
                    response.baseInfo.isNeedFillInfo = data.realNameInfo;
                }
                //获取isInvoice(是否可以开发票)
                if (data.isInvoice) {
                    response.baseInfo.canInvoice = data.isInvoice;
                }
                //获取isInvoice(默认发票人信息)
                if (data.isInvoice && data.invoice) {
                    let invoice = data.invoice;
                    //姓名
                    if (invoice.tax_title) {
                        response.baseInfo.invoiceName = invoice.tax_title
                    }
                    //email
                    if (invoice.email_addr) {
                        response.baseInfo.invoiceEmail = invoice.email_addr;
                    }
                    //电话号码
                    if (invoice.tel) {
                        response.baseInfo.invoicePhone = invoice.tel;
                    }
                }
                //获取商品总件数
                if (data.total_count) {
                    response.baseInfo.totalCount=data.total_count;
                }
            }
            successCallBack(response);
        });
    }
}
