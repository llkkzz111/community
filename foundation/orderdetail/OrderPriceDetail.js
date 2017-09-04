/**
 * Created by Administrator on 2017/5/13.
 */
'use strict';

import React, {
    Component,
    PropTypes
} from 'react';

import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    Dimensions
} from 'react-native';

var {width, height, scale} = Dimensions.get('window');

export default class OrderPriceDetail extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        let { orderStatus } = this.props;
        let texts = '';
        // if (orderStatus == 0) {
        //     texts = "待支付";
        // } else {
        //     texts = "实付"
        // }
        return (
            <View style={styles.alPriceDetailView}>
                <View style={styles.priceDetailView}>
                    {(orderStatus.time.linePay_name === '')||(orderStatus.time.linePay_name===null)||(orderStatus.time.linePay_name==='null')?null:
                    <View style={[styles.priceChildView]}>
                        <Text allowFontScaling={false} style={{fontSize:15,color:'#666666'}}>支付方式</Text>
                        <Text allowFontScaling={false} style={{fontSize:15,color:'#666666'}}>{orderStatus.time.linePay_name}</Text>
                    </View>}
                    <View style={{width:width,height:1,backgroundColor:'#DDDDDD'}}/>
                    <View style={styles.priceChildView}>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>优惠价格</Text>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>{String(orderStatus.time.youhu_dcamt)}</Text>
                    </View>
                    <View style={styles.priceChildView}>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>抵用券价格</Text>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>{String(orderStatus.time.cupon_dcamt)}</Text>
                    </View>
                    {(orderStatus.time.giftcard ===undefined)||(orderStatus.time.giftcard ==='')||(orderStatus.time.giftcard ===null)?null:
                    <View style={styles.priceChildView}>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>礼包</Text>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>{String(orderStatus.time.giftcard)}</Text>
                    </View>}
                    {(orderStatus.time.saveamt ===undefined)||(orderStatus.time.saveamt ==='')||(orderStatus.time.saveamt ===null)?null:
                    <View style={styles.priceChildView}>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>积分</Text>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>{orderStatus.time.saveamt}</Text>
                    </View>}
                    {(orderStatus.time.deposit === undefined)||(orderStatus.time.deposit === '')||(orderStatus.time.deposit === null)?null:
                    <View style={styles.priceChildView}>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>预付款</Text>
                        <Text allowFontScaling={false} style={{color:'#666666'}}>{String(orderStatus.time.deposit)}</Text>
                    </View>}

                </View>
                <View style={styles.unPayPriceView}>
                    <Text allowFontScaling={false} style={{color:'#666666'}}>{orderStatus.type === '待支付'?'待支付':orderStatus.type ==='预约接收'?'待支付':
                        orderStatus.type ==='预约取消'?'待支付':orderStatus.type ==='取消订单'?'订单总价':
                            orderStatus.type ==='交易关闭'?'订单总价':'实付款'}</Text>
                    <Text allowFontScaling={false} style={styles.unPayPriceText}>¥ {orderStatus.type === '待支付'?String(orderStatus.time.no_pay_amt):orderStatus.type ==='预约接收'?String(orderStatus.time.no_pay_amt):
                        orderStatus.type ==='预约取消'?String(orderStatus.time.sum_amt):orderStatus.type ==='取消订单'?String(orderStatus.time.sum_amt):
                            orderStatus.type ==='交易关闭'?String(orderStatus.time.sum_amt):String(orderStatus.time.pay_amt)}</Text>
                </View>
            </View>
        )
    }
}

// OrderPriceDetail.propTypes = {
//     orderStatus:PropTypes.number, //订单状态
//     reductionPrice: PropTypes.string, //优惠价格
//     couponPrice: PropTypes.string, //抵用券价格
//     farePrice: PropTypes.string, //运费
//     fareDangerPrice: PropTypes.string, //运费险
//     unPayPrice: PropTypes.string, //待支付
// };
//
// OrderPriceDetail.defaultProps = {
//     orderStatus:1,
//     reductionPrice: '-￥40', //优惠价格
//     couponPrice: '-￥20', //抵用券价格
//     farePrice:'￥0', //运费
//     fareDangerPrice: '￥0', //运费险
//     unPayPrice: '￥398', //待支付
// };

const styles = StyleSheet.create({
    alPriceDetailView:{
        backgroundColor:'#FFFFFF',
        marginTop:10,
        marginBottom:10
    },
    priceDetailView:{

    },
    priceChildView:{
        flexDirection: 'row',
        justifyContent: 'space-between',
        height:30,
        paddingLeft:10,
        paddingRight:10,
        marginTop:8
    },
    unPayPriceView:{
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems:'center',
        height:40,
        borderTopWidth:0.5,
        borderColor:'#DDDDDD',
        paddingRight:10,
        paddingLeft:10
    },
    unPayPriceText:{
        color:'#FF0000',
        fontSize:16
    }

});