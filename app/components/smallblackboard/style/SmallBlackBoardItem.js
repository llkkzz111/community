/**
* @file 小黑板列表页item样式
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import { StyleSheet } from 'react-native';
import * as ScreenUtils from 'UTILS/ScreenUtil';
import Colors from 'CONFIG/colors';

export const SmallBlackBoardItemStyle = StyleSheet.create({
    rowstyle: {
        flex: 1,
        padding: ScreenUtils.scaleSize(30),
        flexDirection: 'row',
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(212),
        backgroundColor: Colors.background_white,
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: Colors.line_grey,
    },
    outImgStyle: {
        width: ScreenUtils.scaleSize(219),
        height: ScreenUtils.scaleSize(151),
        marginRight: ScreenUtils.scaleSize(20)
    },
    textViewStyle: {
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(219 + 60),
        height: ScreenUtils.scaleSize(151.5),
    },
    text: {
        fontSize: ScreenUtils.setSpText(30)
    },
    watchNumber: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(24),
        position: 'absolute',
        bottom: 0
    }
});
