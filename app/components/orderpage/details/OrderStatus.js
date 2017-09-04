/**
 * Created by pactera on 2017/7/27.
 */
'use strict';
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Text,
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

export default class OrderStatus extends Component {
    static propTypes = {
        ...View.PropTypes, // 包含默认的View的属性
        status: PropTypes.string,
        orderNo: PropTypes.string,
        orderTime: PropTypes.string,
        cancleReason: PropTypes.string
    }
    static defaultProps = {
        status: '',
        orderNo: '',
        orderTime: '',
        cancleReason: ''
    }

    render() {
        return (
            <View style={[styles.container, this.props.style]}>
                <Text
                    allowFontScaling={false}
                    style={styles.orderStatus}>
                    状态：{this.props.status}
                </Text>
                {this.props.cancleReason ?
                    <Text style={styles.orderNoAndTimeText} allowFontScaling={false}>
                        {this.props.cancleReason}
                    </Text> :
                    <View style={styles.orderNoAndTime}>
                        {(this.props.orderNo && this.props.orderNo.length > 0) ? (
                            <Text
                                allowFontScaling={false}
                                style={styles.orderNoAndTimeText}>
                                订单编号：{this.props.orderNo}
                            </Text>
                        ) : null}
                        {(this.props.orderTime && this.props.orderTime.length > 0) ? (
                            <Text
                                allowFontScaling={false}
                                style={styles.orderNoAndTimeText}>
                                {this.props.orderTime}
                            </Text>
                        ) : null}
                    </View> }
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        flex: 1,
        backgroundColor: Colors.background_white,
        padding: ScreenUtils.scaleSize(30),
    },
    orderStatus: {
        fontSize: ScreenUtils.setSpText(28),
        marginBottom: ScreenUtils.scaleSize(10),
        color: Colors.text_black
    },
    orderNoAndTime: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    orderNoAndTimeText: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(24),
    },

});