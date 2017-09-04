/**
 * Created by YASIN on 2017/6/1.
 * 全球购公共title头部
 */
import React, {Component, PropTypes}from 'react';
import {
    View,
    Image,
    TouchableOpacity,
    Text,
    StyleSheet,
}from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
export default class GlobalCommonTitle extends Component {
    static propTypes = {
        ...View.props,
        title: PropTypes.string,
        icon: Image.propTypes.source,
        onRightClick:PropTypes.func,
        desc:PropTypes.string
    };

    render() {
        return (
            <View style={[styles.container,this.props.style]}>
                <View style={styles.leftContainer}/>
                <View style={styles.centerContainer}>
                    <Text
                        allowFontScaling={false}
                        style={styles.titleStyle}>{this.props.title}</Text>
                </View>
                <View style={styles.rightContainer}>
                    {this._renderRight()}
                </View>
            </View>
        );
    }

    /**
     * 渲染右边部分
     * @private
     */
    _renderRight() {
        let RightComponent = null;
        if (this.props.desc) {
            RightComponent = (
                <TouchableOpacity activeOpacity={1} onPress={this.props.onRightClick}>
                    <View style={styles.rightInnerContainer}>
                        <Text
                            allowFontScaling={false}
                            style={styles.descTextStyle}>{this.props.desc}</Text>
                    </View>
                </TouchableOpacity>
            );
        }
        return RightComponent;
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(85),
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        backgroundColor:Colors.text_white
    },
    leftContainer: {
        flex: 1,
        alignItems: 'center'
    },
    rightContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent:'flex-end',
        flexDirection:'row',
        paddingRight:ScreenUtils.scaleSize(30)
    },
    centerContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    titleStyle: {
        color: '#A72AFF',
        fontSize: ScreenUtils.setSpText(32),
    },
    rightInnerContainer: {
        flexDirection: 'row',
        alignItems:'center',
    },
    descTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(26),
        marginBottom:ScreenUtils.scaleSize(1)
    }
});