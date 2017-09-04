/**
 * Created by MASTERMIAO on 2017/6/2.
 * 订单写入接口函数定义
 */
import BaseRequest from '../BaseRequest';
import {toDate}from '../../utils/ScreenUtil';
export default class OrderFillRequest extends BaseRequest {
    requestUrl() {
        return '/api/orders/orders/create_order';
    }
}

/**
 *
 * @param baseInfo 基本信息
 * @param amountDetail 价格详情
 * @param address 地址信息
 * @param orders 订单信息
 * @returns {{orders: Array, receiver_seq: string, msg: string, texbill_name: string, phone_invoice: string, email_invoice: string, invoice_type: string, invoice_taitou: string, taxpayer_invoice: string, order_token: string, total_amt: string}}
 */
export function formatParams(baseInfo, amountDetail, address, orders) {
    let params = {
        orders: [],
        receiver_seq: '',//地址seq 不能为空
        msg: '',//备注消息
        texbill_name: '',//发票抬头
        phone_invoice: '',//填发票时的手机
        email_invoice: '',//填发票时的邮箱
        invoice_type: '',//发票类型 电子还是打印电子发票 [ELECTRONICS_INVOICE  ELECTRONICS_INVOICE_PRINT]
        invoice_taitou: '', // 不要发票的时候传空  需要发票 传PERSONAL_INVOICE 公司：COMPANY_INVOICE
        taxpayer_invoice: '',// 纳税人识别号 给""
        order_token: '',//给""order_token 
        total_amt: '',//总金额      不能为空
    };

    orders.forEach((order, index) => {
        let tempOrder = {
            item_codes: [], //商品编号  不能为空
            unit_codes: [],//商品规格编号  不能为空
            cart_seqs: [], //购物车序号  不能为空
            qtys: [],//商品数量  不能为空
            msale_codes: [],//对应文档的 item下面的msale_code
            gift_item_codes: [],//赠品编号 可为空数组
            gift_unit_codes: [],//赠品代码 可为空数组
            gift_promo_no: [], //活动促销编号gift_promo_no 可为空数组
            media_channels: [],//媒体频道 可为空数组
            source_urls: [], //item下面的source_url
            source_objs: [],//item下面的source_obj
            emp_yn: '', //是否使用员工折扣,1表示使用0表示不使用 order--->emp_yn
            single_total_amt: '',//订单金额   不能为空 order-->total_real_price
            contact_name: '',//真实姓名         全球购/跨境通不能为空
            contact_resident_no: '',//真实身份证号     全球购/跨境通不能为空
            payStyle: '',//onlinePay在线支付  payOnDelivery货到付款
            itemCodeCoupon: '',//默认第一个优惠券的编号  目前默认给""
            dccoupon_amt: '',//优惠券金额 优惠券中的 real_coupon_amt
            memberPromo: '',//是不是会员特价  1表示是会员特价0表示不是会员特价 order--》memberPromo
            zhiDingRiQi: '',//appointData下面的date_day_t
            sendTime: '',//"指定日配送,20170518"或者任意时间收货
            app_first_dc_yn: '',//首购立减"no"/"yes" order-->app_first_dc_yn
        };
        /*------------------提交中的多个订单----------------------*/
        order.carts.forEach((good, index) => {
            let item = good.item;
            tempOrder.item_codes.push(item.item_code);
            tempOrder.unit_codes.push(item.unit_code);
            //没有购物车序列号就传0
            if (good.cart_seq && String(good.cart_seq).length > 0) {
                tempOrder.cart_seqs.push(String(good.cart_seq));
            } else {
                tempOrder.cart_seqs.push('0');
            }
            tempOrder.qtys.push(good.cart_qty);
            tempOrder.msale_codes.push(item.msale_code);
            if (good.twgiftcartVO && good.twgiftcartVO.length > 0) {
                let item_code = good.twgiftcartVO[0].item_code
                let unit_code = good.twgiftcartVO[0].unit_code
                let giftcart_seq = good.twgiftcartVO[0].giftcart_seq
                let gift_item_code = good.twgiftcartVO[0].gift_item_code
                let gift_unit_code = good.twgiftcartVO[0].gift_unit_code
                tempOrder.gift_item_codes.push(item_code + '_' + unit_code + '_' + gift_item_code) //测试
                tempOrder.gift_unit_codes.push(item_code + '_' + unit_code + '_' + gift_unit_code)//测试
                tempOrder.gift_promo_no.push(item_code + '_' + unit_code + '_' + giftcart_seq)//测试
            } else {
                tempOrder.gift_item_codes.push('');//测试
                tempOrder.gift_unit_codes.push('');//测试
                tempOrder.gift_promo_no.push('');//测试
            }
            tempOrder.media_channels = [];//测试
            tempOrder.source_urls.push(item.source_url);
            tempOrder.source_objs.push(item.source_obj);
        });

        tempOrder.emp_yn = order.emp_yn;
        //每个订单的支付类型
        if (order.selectPayStyle === '0') {//在线支付
            tempOrder.payStyle = 'onlinePay';
        } else if (order.selectPayStyle === '1') {//货到付款
            tempOrder.payStyle = 'payOnDelivery';
        }
        // 优惠券信息
        if (order.couponIndex && order.couponList &&
            order.couponList.length > 0 && Number(order.couponIndex) >= 0) {
            let currentCoupon = order.couponList[Number(order.couponIndex)]
            let itemCode = currentCoupon.item_code === null ? '' : currentCoupon.item_code
            tempOrder.itemCodeCoupon = itemCode + '_' + currentCoupon.coupon_no + '_' + currentCoupon.coupon_seq;
            tempOrder.dccoupon_amt = order.couponList[Number(order.couponIndex)].real_coupon_amt;
            ;
        } else {
            tempOrder.itemCodeCoupon = '';
            tempOrder.dccoupon_amt = '';
        }

        tempOrder.single_total_amt =Number((order.total_real_price * 100 - tempOrder.dccoupon_amt * 100) / 100).toFixed(2) ;
        tempOrder.memberPromo = order.memberPromo;

        //填写配送时间
        tempOrder.zhiDingRiQi = '';//
        tempOrder.sendTime = '';//
        if (order.selectDateType === '1') {//指定日期
            if (order.appointData) {
                order.appointData.forEach((date, index)=> {
                    if (date.date_day && date.date_day_t === order.selectDate) {
                        let date1 = toDate(date.date_day, 'yyyyMMdd');
                        tempOrder.zhiDingRiQi = date1;
                        tempOrder.sendTime = '指定日配送,' + date1;
                        return;
                    }
                });
            }
        } else if (order.selectDateType === '0') {//任意日期
            tempOrder.zhiDingRiQi = '';
            tempOrder.sendTime = '任意时间收货';
        } else if (order.selectDateType === '2') {
            if (order.selectDate !== '任意日期配送') {
                if (order.appointData) {
                    order.appointData.forEach((date, index)=> {
                        if (date.date_day && date.date_day_t === order.selectDate) {
                            let date1 = toDate(date.date_day, 'yyyyMMdd');
                            tempOrder.zhiDingRiQi = date1;
                            tempOrder.sendTime = '指定日配送,' + date1;
                            return;
                        }
                    });
                }
            } else {
                tempOrder.zhiDingRiQi = '';
                tempOrder.sendTime = '任意时间收货';
            }
        }
        //是否是首次
        tempOrder.app_first_dc_yn = order.app_first_dc_yn;
        //如果是驴妈妈等商品---添加个人信息
        if (!!order.realNameInfo) {
            //姓名
            tempOrder.contact_name = baseInfo.userName;
            //身份证信息
            tempOrder.contact_resident_no = baseInfo.userIDString;
        }

        params.orders.push(tempOrder);
        /*------------------提交基本信息----------------------*/
        //订单总金额
        params.total_amt = Number(amountDetail.totalAmount).toFixed(2);
        //地址seq
        params.receiver_seq = address.addressSeq;
        //用户如果需要发票信息
        if (baseInfo.needInvoice) {
            //发票抬头
            params.texbill_name = baseInfo.invoiceName;
            //发票人手机
            params.phone_invoice = baseInfo.invoicePhone;
            //发票人邮箱
            params.email_invoice = baseInfo.invoiceEmail;
            // 发票类型
            params.invoice_taitou = (baseInfo.invoiceType1===0)?'PERSONAL_INVOICE':'COMPANY_INVOICE';
            //纳税人识别号 公司发票才要
            if(baseInfo.invoiceType1===1){
                params.taxpayer_invoice=baseInfo.invoiceNum;
            }
            //电子发票还是纸质true为电子版，false为纸质
            //发票类型 电子还是打印电子发票 [ELECTRONICS_INVOICE  ELECTRONICS_INVOICE_PRINT]
            if (baseInfo.invoiceType) {
                params.invoice_type = 'ELECTRONICS_INVOICE';
            } else {
                params.invoice_type = 'ELECTRONICS_INVOICE_PRINT';
            }
        }
    });

    // console.log(params)
    return params;
}

//意向订单的数据
export function potentialOrderInfo(baseInfo, amountDetail, address, orders) {
    let params = {
        orders: [],
        receiver_seq: '',//地址seq 不能为空
        msg: '',//备注消息
        texbill_name: '',//发票抬头
        phone_invoice: '',//填发票时的手机
        email_invoice: '',//填发票时的邮箱
        invoice_type: '',//发票类型 电子还是打印电子发票 [ELECTRONICS_INVOICE  ELECTRONICS_INVOICE_PRINT]
        invoice_taitou: '', // 不要发票的时候传空  需要发票 传PERSONAL_INVOICE 公司：COMPANY_INVOICE
        taxpayer_invoice: '',// 纳税人识别号 给""
        order_token: '',//给""order_token 
        total_amt: '',//总金额      不能为空
    };
    orders.forEach((order, index) => {
        let tempOrder = {
            item_codes: [], //商品编号  不能为空
            unit_codes: [],//商品规格编号  不能为空
            cart_seqs: [], //购物车序号  不能为空
            qtys: [],//商品数量  不能为空
            msale_codes: [],//对应文档的 item下面的msale_code
            gift_item_codes: [],//赠品编号 可为空数组
            gift_unit_codes: [],//赠品代码 可为空数组
            gift_promo_no: [], //活动促销编号gift_promo_no 可为空数组
            media_channels: [],//媒体频道 可为空数组
            source_urls: [], //item下面的source_url
            source_objs: [],//item下面的source_obj
            emp_yn: '', //是否使用员工折扣,1表示使用0表示不使用 order--->emp_yn
            single_total_amt: '',//订单金额   不能为空 order-->total_real_price
            contact_name: '',//真实姓名         全球购/跨境通不能为空
            contact_resident_no: '',//真实身份证号     全球购/跨境通不能为空
            payStyle: '',//onlinePay在线支付  payOnDelivery货到付款
            itemCodeCoupon: '',//默认第一个优惠券的编号  目前默认给""
            dccoupon_amt: '',//优惠券金额 优惠券中的 real_coupon_amt
            memberPromo: '',//是不是会员特价  1表示是会员特价0表示不是会员特价 order--》memberPromo
            zhiDingRiQi: '',//appointData下面的date_day_t
            sendTime: '',//"指定日配送,20170518"或者任意时间收货
            app_first_dc_yn: '',//首购立减"no"/"yes" order-->app_first_dc_yn
        };
        /*------------------提交中的多个订单----------------------*/
        order.carts.forEach((good, index) => {
            let item = good.item;
            tempOrder.item_codes.push(item.item_code);
            tempOrder.unit_codes.push(item.unit_code);
            //没有购物车序列号就传0
            if (good.cart_seq && String(good.cart_seq).length > 0) {
                tempOrder.cart_seqs.push(String(good.cart_seq));
            } else {
                tempOrder.cart_seqs.push('0');
            }
            tempOrder.qtys.push(item.count);
            tempOrder.msale_codes.push(item.msale_code);
            if (good.twgiftcartVO && good.twgiftcartVO.length > 0) {
                let item_code = good.twgiftcartVO[0].item_code
                let unit_code = good.twgiftcartVO[0].unit_code
                let giftcart_seq = good.twgiftcartVO[0].giftcart_seq
                let gift_item_code = good.twgiftcartVO[0].gift_item_code
                let gift_unit_code = good.twgiftcartVO[0].gift_unit_code
                tempOrder.gift_item_codes.push(item_code + '_' + unit_code + '_' + gift_item_code) //测试
                tempOrder.gift_unit_codes.push(item_code + '_' + unit_code + '_' + gift_unit_code)//测试
                tempOrder.gift_promo_no.push(item_code + '_' + unit_code + '_' + giftcart_seq)//测试
            } else {
                tempOrder.gift_item_codes.push('');//测试
                tempOrder.gift_unit_codes.push('');//测试
                tempOrder.gift_promo_no.push('');//测试
            }
            tempOrder.media_channels = [];//测试
            tempOrder.source_urls.push(item.source_url);
            tempOrder.source_objs.push(item.source_obj);
        });

        tempOrder.emp_yn = order.emp_yn;
        //每个订单的支付类型
        if (order.selectPayStyle === '0') {//在线支付
            tempOrder.payStyle = 'onlinePay';
        } else if (order.selectPayStyle === '1') {//货到付款
            tempOrder.payStyle = 'payOnDelivery';
        }
        // 优惠券信息
        if (order.couponIndex && order.couponList &&
            order.couponList.length > 0 && Number(order.couponIndex) >= 0) {
            let currentCoupon = order.couponList[Number(order.couponIndex)]
            let itemCode = currentCoupon.item_code === null ? '' : currentCoupon.item_code
            tempOrder.itemCodeCoupon = itemCode + '_' + currentCoupon.coupon_no + '_' + currentCoupon.coupon_seq;
            tempOrder.dccoupon_amt = order.couponList[Number(order.couponIndex)].real_coupon_amt;
            ;
        } else {
            tempOrder.itemCodeCoupon = '';
            tempOrder.dccoupon_amt = '';
        }

        tempOrder.single_total_amt = (order.total_real_price * 100 - tempOrder.dccoupon_amt * 100) / 100;
        tempOrder.memberPromo = order.memberPromo;

        //填写配送时间
        tempOrder.zhiDingRiQi = '';//
        tempOrder.sendTime = '';//
        if (order.selectDateType === '1') {//指定日期
            if (order.appointData) {
                order.appointData.forEach((date, index)=> {
                    if (date.date_day && date.date_day_t === order.selectDate) {
                        let date1 = toDate(date.date_day, 'yyyyMMdd');
                        tempOrder.zhiDingRiQi = date1;
                        tempOrder.sendTime = '指定日配送,' + date1;
                        return;
                    }
                });
            }
        } else if (order.selectDateType === '0') {//任意日期
            tempOrder.zhiDingRiQi = '';
            tempOrder.sendTime = '任意时间收货';
        } else if (order.selectDateType === '2') {
            if (order.selectDate !== '任意日期配送') {
                if (order.appointData) {
                    order.appointData.forEach((date, index)=> {
                        if (date.date_day && date.date_day_t === order.selectDate) {
                            let date1 = toDate(date.date_day, 'yyyyMMdd');
                            tempOrder.zhiDingRiQi = date1;
                            tempOrder.sendTime = '指定日配送,' + date1;
                            return;
                        }
                    });
                }
            } else {
                tempOrder.zhiDingRiQi = '';
                tempOrder.sendTime = '任意时间收货';
            }
        }
        //是否是首次
        tempOrder.app_first_dc_yn = order.app_first_dc_yn;
        //如果是驴妈妈等商品---添加个人信息
        if (!!order.realNameInfo) {
            //姓名
            tempOrder.contact_name = baseInfo.userName;
            //身份证信息
            tempOrder.contact_resident_no = baseInfo.userIDString;
        }

        params.orders.push(tempOrder);
        /*------------------提交基本信息----------------------*/
        //订单总金额
        params.total_amt = amountDetail.totalAmount;
        //地址seq
        params.receiver_seq = address.addressSeq;
        //用户如果需要发票信息
        //发票抬头
        params.texbill_name = baseInfo.invoiceName;
        //发票人手机
        params.phone_invoice = baseInfo.invoicePhone;
        //发票人邮箱
        params.email_invoice = baseInfo.invoiceEmail;
        // 发票类型
        params.invoice_taitou = (baseInfo.invoiceType1 === 0) ? 'PERSONAL_INVOICE' : 'COMPANY_INVOICE';
        //纳税人识别号 公司发票才要
        if (baseInfo.invoiceType1 === 1) {
            params.taxpayer_invoice = baseInfo.invoiceNum;
        }
        //电子发票还是纸质true为电子版，false为纸质
        //发票类型 电子还是打印电子发票 [ELECTRONICS_INVOICE  ELECTRONICS_INVOICE_PRINT]
        if (baseInfo.invoiceType) {
            params.invoice_type = 'ELECTRONICS_INVOICE';
        } else {
            params.invoice_type = 'ELECTRONICS_INVOICE_PRINT';
        }

    });

    // console.log(params)
    return params;
}