/**
 * @file 滑动分页
 * @author 魏毅
 * @version 0.0.2
 * @license 东方购物 2017
 * @see {@link weiyi@ocj.com.cn}
 */
"use strict";
import React, {Component} from 'react';
import {
    Text,
    View,
    Image,
    StyleSheet
} from 'react-native';
import {connect} from 'react-redux';
import {
  List, Seq, Map, is
} from 'immutable';
import { Action as ScrollAction, selector} from 'REDUX/common/Page/ScrollPage';
import * as ScreenUtils from 'FOUNDATION/utils/ScreenUtil';

// 尾部加载组件
@connect(state => ({
    getScrollPage: () => selector.getScrollPage(state)
}), {})
export default class extends Component {
    shouldComponentUpdate(newProps, newState) {
        return !is(Map({
            isFirst: this.props.getScrollPage()[this.props.namespace].isFirst,
            isEnd: this.props.getScrollPage()[this.props.namespace].isEnd
        }), Map({
            isFirst: newProps.getScrollPage()[this.props.namespace].isFirst,
            isEnd: newProps.getScrollPage()[this.props.namespace].isEnd
        }));
    }
    render() {
        const {isFirst, isEnd} = this.props.getScrollPage()[this.props.namespace];
        return !isFirst ? (
            isEnd ? (
                <View style={styles.evaluateBottom}>
                    <Text
                        allowFontScaling={false}
                        style={styles.evaluateBottomText}
                    >已经没有更多啦～</Text>
                </View>
            ) : (
                <View style={styles.loadingBottom}>
                    <Image source={require('IMG/pageLoading.gif')}/>
                    <Text
                        allowFontScaling={false}
                        style={[styles.evaluateBottomText, styles.ladingPaddingLeft]}
                    >加载中...</Text>
                </View>
            )
        ) : null;
    }
}

const styles = StyleSheet.create({
    evaluateBottom: {
        backgroundColor: '#ededed',
        height: ScreenUtils.scaleSize(97),
        width: ScreenUtils.screenW,
        justifyContent: 'center',
        alignItems: 'center'
    },
    loadingBottom: {
        backgroundColor: '#ededed',
        height: ScreenUtils.scaleSize(97),
        width: ScreenUtils.screenW,
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'row'
    },
    evaluateBottomText: {
        fontSize: ScreenUtils.setSpText(26),
        color: '#999'
    },
    ladingPaddingLeft: {
        paddingLeft: ScreenUtils.scaleSize(30)
    },
    red: {
        color: 'red'
    }
});
