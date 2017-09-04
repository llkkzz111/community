/**
 * Created by YASIN on 2017/6/1.
 * 商城公共title头部
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    TouchableOpacity,
    Text,
    StyleSheet
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

export default class StoreCommonTitle extends React.PureComponent {
    static propTypes = {
        ...View.props,
        title: React.PropTypes.string,
        icon: Image.propTypes.source,
        onRightClick: React.PropTypes.func,
        desc: React.PropTypes.string
    }

    render() {
        return (
            <View style={[styles.container,this.props.style]}>
                <View style={styles.leftContainer}></View>
                <View style={styles.centerContainer}>
                    <Image
                        style={styles.iconStyle}
                        source={this.props.icon}
                    />
                    <Text allowFontScaling={false} style={styles.titleStyle}>{this.props.title}</Text>
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
                <TouchableOpacity onPress={this.props.onRightClick} activeOpacity={1}>
                    <View style={styles.rightInnerContainer}>
                        <Text allowFontScaling={false} style={styles.descTextStyle}>{this.props.desc}</Text>
                        <Image
                            style={styles.descIconRight}
                            source={require('../../../../foundation/Img/home/store/icon_view_more_.png')}
                        />
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
    iconStyle: {
        width: ScreenUtils.scaleSize(40),
        height: ScreenUtils.scaleSize(40),
        resizeMode: 'stretch'
    },
    titleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(32),
        marginLeft: ScreenUtils.scaleSize(20)
    },
    rightInnerContainer: {
        flexDirection: 'row',
        alignItems:'center',
    },
    descTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(28),
    },
    descIconRight: {
        width: ScreenUtils.scaleSize(10),
        height: ScreenUtils.scaleSize(15),
        marginLeft:ScreenUtils.scaleSize(10)
    }
});