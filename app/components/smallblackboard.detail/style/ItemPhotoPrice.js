/**
* @file 小黑板商品详情相关商品item样式
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import { StyleSheet } from 'react-native';
import Colors from 'CONFIG/colors';
import * as ScreenUtils from 'UTILS/ScreenUtil';

export const ItemPhotoPriceStyle = StyleSheet.create({
    imgStyle: {
        height: 100,
         width: 100
    },
    footPointGoods: {
        padding: 10,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'flex-start',
        backgroundColor: '#FFFFFF'
    },
    goodsInfor: {
        flex: 1,
        borderColor: '#DDDDDD',
        borderBottomWidth: StyleSheet.hairlineWidth,
        flexDirection: 'column',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        marginLeft: 5
    },
    prductNameTextStyle: {
        flexWrap: "wrap",
        color: '#333333'
    },
    priceViewStyle: {
        flex: 1,
        flexDirection: 'row',
        marginTop: 15
    },
    priceTextStyle: {
        color: '#E5290D',
        marginRight: 10
    },
    unPriceTextStyle: {
        textDecorationLine: "line-through",
        marginRight: 10
    },
    alreadyBuyViewStyle: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'flex-end',
        paddingBottom: 15
    },
    iconStyle: {
        position: 'absolute',
        left: 0,
        zIndex: 11,
        borderRadius: 0,
        resizeMode: 'contain',
        justifyContent:'center',
        alignItems:'center',
        width: ScreenUtils.scaleSize(70),
        height: ScreenUtils.scaleSize(26),
        top: ScreenUtils.scaleSize(7)
    },
    cheep: {
        textAlign: 'center',
        fontSize: ScreenUtils.setSpText(14),
        color: Colors.main_color
    }
});
