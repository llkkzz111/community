/**
 * Created by Administrator on 2017/6/2.
 * 搜索页面没有检索结果
 */

'use strict';
import React from 'react'
import {
    View,
    StyleSheet,
    Image,
    Text,
} from 'react-native'

import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';

export default class NoSearchResult extends React.PureComponent {
    constructor(props) {
        super(props);
    }
    // render 渲染页面
    render() {
        return (
            <View style={styles.noResultViewStyle}>
                <Image source={require('../Img/searchpage/noResult.png')} style={styles.noResultImgStyle}/>
                <Text style={styles.noNetText} allowFontScaling={false}>很抱歉！没能找到相关商品，要不换个关键词？</Text>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    noResultViewStyle: {
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.background_white,
        width: ScreenUtil.screenW,
        height: ScreenUtil.scaleSize(352),
    },
    noResultImgStyle: {
        width: ScreenUtil.scaleSize(300),
        height: ScreenUtil.scaleSize(250),
    },
    noNetText: {
        fontSize: ScreenUtil.setSpText(28),
        color: Colors.text_light_grey,
    },
});
