/**
 * created by zhenzhen
 * 订单列表footview
 */

'use strict';
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Text,
    Image,
    TouchableOpacity,
} from 'react-native';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
export default class OrderFootView extends Component {
    static propTypes = {
        isMore: PropTypes.bool,
        reachedEnd: PropTypes.bool,
        isShowClickMore: PropTypes.bool,
        onLoadMore: PropTypes.func
    }

    render() {
        let footComponent = null;
        if (this.props.isMore && this.props.reachedEnd) {
            footComponent = (
                <View style={styles.loadingBottom}>
                    <Image source={require('IMG/pageLoading.gif')}/>
                    <Text
                        allowFontScaling={false}
                        style={[styles.evaluateBottomText, styles.ladingPaddingLeft]}
                    >加载中...</Text>
                </View>
            );
        } else if (!this.props.isMore) {
            footComponent = (
                <View style={styles.loadingBottom}>
                    <Text
                        allowFontScaling={false}
                        style={styles.evaluateBottomText}
                    >
                        已经没有更多啦～
                    </Text>
                </View>
            );
        } else if (this.props.isShowClickMore) {
            footComponent = (
                <TouchableOpacity
                    style={styles.loadingBottom}
                    onPress={this.props.onLoadMore}
                >
                    <Text
                        allowFontScaling={false}
                        style={styles.evaluateBottomText}
                    >
                        点击加载更多
                    </Text>
                </TouchableOpacity>
            );
        }
        return footComponent;
    }
}

const styles = StyleSheet.create({
    container: {},
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

