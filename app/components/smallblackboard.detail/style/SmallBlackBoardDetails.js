/**
* @file 小黑板商品详情样式
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import { StyleSheet } from 'react-native';
import Colors from 'CONFIG/colors';
import * as ScreenUtils from 'UTILS/ScreenUtil';

export const SmallBlackBoardDetailsStyle = StyleSheet.create({
    box: {
        flex: 1,
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_white
    },
    articleBox: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_white
    },
    navBgStyle:{
        width:ScreenUtils.screenW,
        position:'absolute',
        top:0,
        zIndex:-1,
        height:ScreenUtils.scaleSize(120)
    },
    titleBox:{
        position:'absolute',
        top: 0,
        left: 0,
        zIndex: -1,
        width:ScreenUtils.screenW,
        height:ScreenUtils.scaleSize(120),
        flexDirection:'row',
        justifyContent:'center',
        alignItems:'flex-end'
    },
    titleText:{
        backgroundColor:'transparent',
        marginBottom:ScreenUtils.scaleSize(20),
        width:ScreenUtils.scaleSize(131),
        height:ScreenUtils.scaleSize(42)
    },
    navRightStyle: {
        width: ScreenUtils.scaleSize(120),
        alignItems: 'flex-end',
        paddingRight: ScreenUtils.scaleSize(20),
    },
    navRightShareStyle: {
        width: ScreenUtils.scaleSize(36),
        height: ScreenUtils.scaleSize(38),
        marginLeft: ScreenUtils.scaleSize(15)
    },
    articleTitle: {
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: '#DDDDDD'
    },
    bottomBox: {
        marginVertical: ScreenUtils.setSpText(30)
    },
    angularBox: {
        justifyContent: 'center'
    },
    angular: {
        color: '#999999',
        fontSize: ScreenUtils.setSpText(18)
    },
    moreTitle: {
        color: '#999999',
        fontSize: ScreenUtils.setSpText(22)
    },
    more: {
        color: '#5E8FF4',
        lineHeight: 20,
        fontSize: ScreenUtils.setSpText(26)
    },
    container: {
        backgroundColor: Colors.background_grey
    },
    titleView: {
        height: ScreenUtils.scaleSize(84),
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_white,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: ScreenUtils.scaleSize(20),
        marginBottom: StyleSheet.hairlineWidth * 2
    },
    titleTextStyle: {
        marginLeft: ScreenUtils.scaleSize(10),
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(32)
    },
    titleStyle: {
        fontSize: ScreenUtils.setSpText(36),
        color: Colors.text_black,
        marginLeft: ScreenUtils.scaleSize(20),
        marginTop: ScreenUtils.scaleSize(23),
        fontWeight: 'bold'
    },
    countContent: {
        paddingBottom: ScreenUtils.scaleSize(20),
        flexDirection: 'row',
        marginTop: ScreenUtils.scaleSize(20),
        alignItems: 'center'
    },
    publishTime: {
        fontSize: ScreenUtils.setSpText(24),
        color: Colors.text_light_grey,
        marginLeft: ScreenUtils.scaleSize(20)
    },
    labelName: {
        fontSize: ScreenUtils.setSpText(24),
        color: Colors.text_light_grey,
        marginLeft: ScreenUtils.scaleSize(20)
    },
    watchNumber: {
        fontSize: ScreenUtils.setSpText(24),
        color: Colors.text_light_grey,
        marginLeft: ScreenUtils.scaleSize(20)
    },
    contentValueBox: {
        paddingHorizontal: ScreenUtils.scaleSize(20)
    },
    contentValue: {
        fontSize: ScreenUtils.setSpText(28),
        color: Colors.text_dark_grey,
        paddingTop: ScreenUtils.scaleSize(20),
        paddingLeft: ScreenUtils.scaleSize(30)
    },
    contentImage: {
        width: ScreenUtils.scaleSize(692),
        height: ScreenUtils.scaleSize(390),
        marginLeft: ScreenUtils.scaleSize(30),
        marginBottom: ScreenUtils.scaleSize(30)
    },
    loadingBox: {
        justifyContent: 'center',
        alignItems: 'center',
        height: 200,
        backgroundColor: 'white'
    },
    officialWebsiteBox: {
        alignItems: 'center',
        justifyContent: 'center'
    },
    officialWebsite: {
        justifyContent: 'center',
        alignItems: 'center',
        marginVertical:ScreenUtils.scaleSize(30),
        backgroundColor: 'red',
        width: ScreenUtils.scaleSize(500),
        height: ScreenUtils.scaleSize(88),
        borderRadius: ScreenUtils.scaleSize(4)
    },
    officialWebsiteText: {
        color: '#fff'
    },
    goodsList: {
        marginTop: ScreenUtils.scaleSize(20)
    }
});
