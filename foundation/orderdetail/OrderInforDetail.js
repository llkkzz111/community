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
    Image
} from 'react-native';

export default class OrderInforDetail extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        let { orderStatus} = this.props;

        return (
            <View style={styles.orderInforDetailView}>
                <View style={styles.priceChildView}>
                    <Text allowFontScaling={false} style={{color:"#666666"}}>订单编号：{orderStatus.time.order_no}</Text>
                </View>
                <View style={styles.priceChildView}>
                    <Text allowFontScaling={false} style={{color:"#666666"}}>下单时间：{orderStatus.time.order_date}</Text>
                </View>
                <View style={styles.priceChildView}>
                    {(orderStatus.type ==='待支付')||(orderStatus.type ==='预约取消')||(orderStatus.type ==='交易关闭')||
                    (orderStatus.type ==='预约接收')||(orderStatus.type ==='取消订单')||((orderStatus.type ==='订单取消'))?
                    <Text allowFontScaling={false} style={{color:"#666666"}}>交易关闭时间：{orderStatus.time.order_date.substr(0,8)}
                        {Number(orderStatus.time.order_date.substr(8,2))+1}  {orderStatus.time.order_date.substr(11,8)}
                    </Text>:<Text allowFontScaling={false} style={{color:"#666666"}}>付款时间：{orderStatus.time.payDate}</Text>}
                </View>
            </View>
        )
    }
}

// OrderInforDetail.propTypes = {
//     orderNo: PropTypes.string, //订单编号
//     orderTime: PropTypes.string, //下单时间
//     orderAutoCloseTime: PropTypes.string, //交易自动关闭时间
// };
//
// OrderInforDetail.defaultProps = {
//     orderNo: '910276289393dc9008', //订单编号
//     orderTime: '2017.05.12', //下单时间
//     orderAutoCloseTime: '2017.05.12 20: 22: 21', //交易自动关闭时间
// };

const styles = StyleSheet.create({
    orderInforDetailView:{
        backgroundColor:'#FFFFFF',
        padding:10,
        marginBottom:10
    },
    priceDetailView:{

    },
    priceChildView:{
        flexDirection: 'row',
        justifyContent: 'space-between',
        height:30
    },
    unPayPriceView:{
        flexDirection: 'row',
        justifyContent: 'space-between',
        height:40,
        borderTopWidth:0.5,
        borderColor:'#DDDDDD'
    },
    unPayPriceText:{
        color:'#FF0000',
        fontSize:16
    }

});