/**
 * Created by YASIN on 2017/5/31.
 * 网络连接失败等公共页面
 */
import React, {Component, PropTypes}from 'react';
import {
    View,
    Text,
    Image,
    StyleSheet,
    TouchableOpacity,
    TouchableWithoutFeedback
}from 'react-native';

import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';

export default class NetErro extends Component {
    static propTypes = {
        ...View.propTypes,
        icon: Image.propTypes.source,//头部icon，格式为image soure格式
        title: PropTypes.string,//title标题
        desc: PropTypes.string,//描述
        confirmText: PropTypes.string,//按钮确定信息
        onButtonClick: PropTypes.func,//按钮点击
        iconStyle: Image.propTypes.style,
        titleStyle: Text.propTypes.style,
        descStyle: Text.propTypes.style,
        buttonStyle: View.propTypes.style,
        buttonTextStyle: Text.propTypes.style,
        onIconClick: PropTypes.func
    };
    static defaultProps = {
        icon: require('../../../foundation/Img/error/common_error_page_img.png'),
        title:'您的网络好像很傲娇',
    };
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this._renderBottomContainer = this._renderBottomContainer.bind(this);
    }

    render() {
        return (
            <View style={[styles.container, this.props.style]}>
                <TouchableWithoutFeedback onPress={this.props.onIconClick}>
                    <Image
                        style={[styles.iconStyle, this.props.iconStyle]}
                        source={this.props.icon}
                    />
                </TouchableWithoutFeedback>
                {this._renderBottomContainer()}
            </View>
        );
    }

    /**
     * 渲染底部container
     * 如果传了confirmText的话就返回按钮样式
     * 没传就显示title跟desc样式
     * @private
     */
    _renderBottomContainer() {
        let bottomContainer = null;
        if (this.props.confirmText || this.props.onButtonClick) {
            bottomContainer = (

            <View style={styles.bottomContainer}>
                <Text allowFontScaling={false} style={[styles.titleStyle, this.props.titleStyle]}>{this.props.title}</Text>
                <Text allowFontScaling={false} style={[styles.descStyle, this.props.descStyle]}>{this.props.desc}</Text>
                <TouchableOpacity
                    activeOpacity={1}
                    style={[styles.buttonStyle, this.props.buttonStyle]}
                    onPress={this.props.onButtonClick}
                >
                    <Text allowFontScaling={false} style={[styles.buttonTextStyle, this.props.buttonTextStyle]}>{this.props.confirmText}</Text>
                </TouchableOpacity>
            </View>
            );
        } else {
            bottomContainer = (
                <View style={styles.bottomContainer}>
                    <Text allowFontScaling={false} style={[styles.titleStyle, this.props.titleStyle]}>{this.props.title}</Text>
                    <Text allowFontScaling={false} style={[styles.descStyle, this.props.descStyle]}>{this.props.desc}</Text>
                </View>
            );
        }
        return bottomContainer;
    }
}
const styles = StyleSheet.create({
    container: {
        backgroundColor: Colors.background_grey,
        width: ScreenUtils.screenW,
        justifyContent: 'center',
        alignItems: 'center',
    },
    iconStyle: {
        width: ScreenUtils.scaleSize(370),
        height: ScreenUtils.scaleSize(235),
        resizeMode: 'stretch'
    },
    titleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(30),
    },
    descStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.scaleSize(24),
        marginTop: ScreenUtils.scaleSize(20)
    },
    buttonStyle: {
        width: ScreenUtils.scaleSize(222),
        height: ScreenUtils.scaleSize(64),
        marginTop: ScreenUtils.scaleSize(45),
        justifyContent: 'center',
        alignItems: 'center',
        borderColor: Colors.line_grey,
        borderWidth: ScreenUtils.scaleSize(1),
        borderRadius: ScreenUtils.scaleSize(5)
    },
    buttonTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24)
    },
    bottomContainer: {
        marginTop: ScreenUtils.scaleSize(30),
        alignItems: 'center'
    }
});