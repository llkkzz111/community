/**
 * Created by Administrator on 2017/5/7.
 */


import React, {Component, PropTypes} from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    Platform
} from 'react-native';

import * as ScreenUtils from '../utils/ScreenUtil';

export default class CommonCell extends Component {
    constructor(props) {
        super(props);
    }

    static propTypes = {
        leftIconName: React.PropTypes.string,      //左侧图片图标
        leftText: React.PropTypes.string,         //左侧文字
        middleText: React.PropTypes.string,     //中间文字
        rightText: React.PropTypes.string, //右侧文字
        isMoudle: React.PropTypes.bool, //右侧文字
        noRightImage: PropTypes.bool, //右侧文字
        moudle: PropTypes.func, //右侧文字
    };

    //左侧图标，可选
    _renderLeftViewImage() {
        return (
            <Image style={styles.leftImageStyle} source={{uri: this.props.leftImageUri}} resizeMode={'contain'}/>
        );
    }

    //左侧文字，可选
    _renderLeftText() {
        return (
            <Text style={[styles.leftTextStyle, {
                color: '#333333',
                marginLeft: this.props.leftImageUri ? 5 : ScreenUtils.scaleSize(30)
            }]} allowFontScaling={false}>{this.props.leftText ? this.props.leftText : " "}</Text>
        );
    }

    //右侧文字，可选
    _renderRightText() {
        return (
            <Text style={[styles.rightTextStyle, {marginRight: this.props.noRightImage ? 0 : 5}]}
                  allowFontScaling={false}>{this.props.rightText}</Text>
        );
    }

    //中间文字，可选
    _renderMiddleText() {
        return (
            <Text style={styles.middleTextStyle} allowFontScaling={false}>{this.props.middleText}</Text>
        );
    }

    // 中间moulde，可选
    _renderMiddleMoule() {
        return (
            this.props.children
        );
    }

    //先判断传进来的是moudle还是简单的text，然后再渲染
    _renderMiddleMouldOrText() {
        // this.props.isMoudle ? this._renderMiddleMoule() : this._renderMiddleText();
        return (
            this.props.isMoudle ? this._renderMiddleMoule() : this._renderMiddleText()
        );
    }

    _renderRightImage() {
        return (
            <Image
                style={[{width: ScreenUtils.scaleSize(16), height: ScreenUtils.scaleSize(24),marginRight:15}]}
                resizeMode={'stretch'}
                source={require('../Img/home/store/icon_more_right_.png')}/>
        );
    }

    _renderView() {
        return (
            <View style={{width: 1, height: 1}}/>
        );
    }

    render() {
        return (
            <View style={styles.container}>
                <View style={styles.leftViewStyle}>
                    {this.props.leftImageUri && this._renderLeftViewImage()}
                    {this.props.leftText ? this._renderLeftText() : this._renderView()}
                </View>
                <View style={styles.middleViewStyle}>
                    {this._renderMiddleMouldOrText()}
                </View>
                <View style={styles.rightViewStyle}>
                    {this.props.rightText && this._renderRightText()}
                    {this.props.noRightImage ? this._renderView() : this._renderRightImage()}
                </View>
            </View>
        );
    }
}


const styles = StyleSheet.create({
    container: {
        flexDirection: "row",
        justifyContent: "space-between",
        backgroundColor: "#FFFFFF",
        alignItems: "center",
        borderBottomColor: "#dddddd",
        borderBottomWidth: 0.5,
        height: 44,
    },
    leftViewStyle: {
        flexDirection: "row",
        // marginLeft:10,
    },
    leftImgStyle: {
        width: 30,
        height: 30,
    },
    leftTitleStyle: {
        alignItems: "center",
        // marginLeft:8,
        alignSelf: "center"
    },
    rightViewStyle: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    rightTextStyle: {
        color: '#666666'
    },
    renderRightImage: {
        marginRight: 15,
        marginBottom: 5,
        // backgroundColor: 'red'
    },

    goIconRight: {
        ...Platform.select({
            ios: {
                width: 8,
                height: 12,
                marginTop: 6
            },

            android: {
                width: 30,
                height: 28,
                marginTop: 4
            }
        })
    }


});

//组件引用说明
CommonCell.propTypes = {
    leftImageUri: PropTypes.string, //左侧图片uri
    leftText: PropTypes.string, //左侧文字
    middleText: PropTypes.string, //中间文字
    rightText: PropTypes.string, //右侧文字
    isMoudle: PropTypes.bool, //右侧文字
    noRightImage: PropTypes.bool, //右侧文字
    moudle: PropTypes.func, //右侧文字
}