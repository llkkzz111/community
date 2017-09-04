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


export default class OrderStatus extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        let { orderStatus,timeText } = this.props;
        return (
            <View style={styles.orderStatusView}>
                <Text allowFontScaling={false} style={styles.statusText}>状态：{orderStatus.type}</Text>
                <View style={{flexDirection:'row'}}>
                    <Text allowFontScaling={false} style={styles.timeText}>订单编号:{orderStatus.time.order_no}</Text>
                    <Text allowFontScaling={false} style={[styles.DateText]}>{orderStatus.time.order_date}</Text>
                </View>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    orderStatusView: {
        flexDirection: 'column',
        //justifyContent: 'space-between',
        alignItems: 'flex-start',
        backgroundColor: '#FFFFFF',
        padding:10,
        height:80,
        marginBottom:10,
        justifyContent:'center',
    },
    statusText:{
        color:'#333333',
        fontSize:16,
    },
    timeText:{
        color:'#666666',
        fontSize:13,
        marginTop:10
    },
    DateText:{
        color:'#666666',
        fontSize:13,
        marginTop:10,
        marginLeft:25
    }
});