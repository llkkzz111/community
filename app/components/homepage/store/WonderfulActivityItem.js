/**
 * Created by YASIN on 2017/6/1.
 * 精彩内容
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    TouchableOpacity,
    StyleSheet,
    Text,
    Platform
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

export default class WonderfulActivityItem extends React.PureComponent {
    static propTypes = {
        ...View.propTypes,
        title: React.PropTypes.string,
        desc: React.PropTypes.string,
        icons: React.PropTypes.array,
        titleStyle: Text.propTypes.style,
        onItemClick: React.PropTypes.func
    }
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this._renderIcon = this._renderIcon.bind(this);
    }

    render() {
        return (
            <TouchableOpacity
                activeOpacity={1}
                onPress={this.props.onItemClick}
                style={[styles.container, this.props.style]}>
                <View>
                    <Text allowFontScaling={false}
                        style={[styles.titleStyle, this.props.titleStyle]}>{this.props.title ? this.props.title : ''}</Text>
                    <Text allowFontScaling={false} style={styles.descStyle}>{this.props.desc ? this.props.desc : ''}</Text>
                    <View style={styles.bottomContainerStyle}>
                        {this.props.icons ? this.props.icons.map(this._renderIcon) : null}
                    </View>
                </View>
            </TouchableOpacity>
        );
    }

    /**
     *
     * @private
     */
    _renderIcon(icon, index) {
        return (
            <View style={styles.iconContainer} key={index}>
                <Image
                    style={styles.iconStyle}
                    source={icon}
                />
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        padding: ScreenUtils.scaleSize(20)
    },
    titleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28),
        fontWeight: 'bold'
    },
    descStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
        ...Platform.select({
            ios: {
                marginTop: ScreenUtils.scaleSize(10)
            },
            android: {
                marginTop: ScreenUtils.scaleSize(0),
            }
        })
    },
    bottomContainerStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: ScreenUtils.scaleSize(20)
    },
    iconStyle: {
        flex:1,
        height: ScreenUtils.scaleSize(138)
    },
    iconContainer: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection:'row'
    }
});