/**
 * Created by YASIN on 2017/7/31.
 * 订单中心基本数据
 */
//全部
import OrderAllPage from './OrderAllPage';
//待支付
import OrderRequirePay from './OrderRequirePay';
//待发货
import OrderRequireSend from './OrderRequireSend';
//配送中
import OrderSending from './OrderSending';
//待评价
import OrderRequireComment from './OrderRequireComment';
//退换货
import OrderRequireExchange from './OrderRequireExchange';
//预约中
import OrderAppointment from './OrderAppointment';
const listFlags = {
    all: 'all',//全部
    nopay: 'nopay',//待支付
    payover: 'payover',//待发货
    peisong: 'peisong',//配送中
    preorder: 'preorder',//预约订单
    comment: 'comment',//待评价
    return: 'return',//退换货
}
export default {
    TEXTS: {
        cancleTitle: '订单取消后将无法恢复，您确定要取消订单吗？',
        cancleText: '取消',
        confirmText: '确定',
    },
    cardText: {
        cancelTitle: '获取成功！如需查询或充值，请至"个人中心 > 礼包 > 充值',
        cancelText: '取消',
        confirmText: '确定',
    },
    telephoneText: {
        cancelTitle: '如需申请退换货，请拨打客服电话400-889-8000',
        cancelText: '取消',
        confirmText: '确定',
    },
    cancleReasons: [
        {
            key: '184',
            value: '现在不想购买'
        },
        {
            key: '162',
            value: '等待时间过长'
        },
        {
            key: '108',
            value: '支付不成功'
        },
        {
            key: '111',
            value: '更换或添加新商品'
        },
        {
            key: '135',
            value: '分期付款审核未通过'
        },
        {
            key: '199',
            value: '配送地址变更'
        }],
    flags: {
        refrushOrder: 'refrushOrder',
    },
    components: [
        {
            tabLabel: '全部',
            procState: listFlags.all,
            component: OrderAllPage,
        },
        {
            tabLabel: '待支付',
            procState: listFlags.nopay,
            component: OrderAllPage,
        },
        {
            tabLabel: '待发货',
            procState: listFlags.payover,
            component: OrderAllPage,
        },
        {
            tabLabel: '配送中',
            procState: listFlags.peisong,
            component: OrderAllPage,
        },
        {
            tabLabel: '待评价',
            procState: listFlags.comment,
            component: OrderAllPage,
        },
        {
            tabLabel: '退换货',
            procState: listFlags.return,
            component: OrderAllPage,
        },
        {
            tabLabel: '预约中',
            procState: listFlags.preorder,
            component: OrderAllPage,
        },
    ],
    returnFlags: {
        returnGoodsOne: '1',
        returnGoodsTwo: '30',
        exchangeGoodsOne: '2',
        exchangeGoodsTwo: '45',
    },
    orderTypes: {
        preOrder: 'PREORDER'
    }
}
