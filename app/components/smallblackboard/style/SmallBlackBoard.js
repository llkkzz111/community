/**
* @file 小黑板列表页样式
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import { StyleSheet } from 'react-native';
import Colors from 'CONFIG/colors';
import * as ScreenUtils from 'UTILS/ScreenUtil';

export const SmallBlackBoardStyle = StyleSheet.create({
    box: {
        flex: 1
    },
    navBgStyle:{
        position: 'absolute',
        top: 0,
        zIndex: -1,
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(120)
    },
    titleBox:{
        position: 'absolute',
        top: 0,
        left: 0,
        zIndex: -1,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'flex-end',
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(120)
    },
    titleText:{
        marginBottom: ScreenUtils.scaleSize(20),
        backgroundColor: 'transparent',
        width: ScreenUtils.scaleSize(131),
        height: ScreenUtils.scaleSize(42)
    },
    tab: {
        height: 49,
        alignItems: 'center',
        justifyContent: 'center',
        paddingLeft: 20,
        paddingRight: 20,
    },
    scrollableTabViewStyle: {
        marginTop: 0,
        flex: 1
    },
    tabBarUnderLine: {
        height: ScreenUtils.scaleSize(4),
        backgroundColor: Colors.main_color,
    }
});
