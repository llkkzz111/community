/**
 * Created by dongfanggouwu-xiong on 2017/6/21.
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
} from 'react-native';

import { Actions } from 'react-native-router-flux';

export default class OrderBlankPage extends Component {
    constructor(props) {
        super(props);
    }

    render() {

        return (
            <View style={styles.OrderBlank}>
                <Image style={styles.orderImg}
                       source={(require('../Img/order/img_DD_2x.png'))}
                       />
                <Text allowFontScaling={false} style={styles.orderText}>您还没有相关订单</Text>
                <TouchableOpacity activeOpacity={1} onPress={this.goHomePage}>
                <Text allowFontScaling={false} style={styles.Text}>去逛逛</Text>
                </TouchableOpacity>
            </View>
        )
    }
    //去逛逛
    goHomePage() {
        Actions.pop();
        setTimeout(() => {
            Actions.popTo('Home')
        }, 100);
    }
}



const styles = StyleSheet.create({
    OrderBlank:{
        alignItems:'center'
   },
    orderImg:{
        marginTop:120,
        height:120,
        width:120,

    },
    orderText:{
        marginTop:30,
        color:'#000000',
    },
    Text:{
        marginTop:20,
        borderWidth:1,
        paddingLeft:20,
        paddingRight:20,
        borderRadius:3,
        paddingTop:5,
        paddingBottom:5,
        color:'#9da1a1',
        borderColor:'#b4b4b4'
    }
});