/**
 * Created by 卓原 on 2017/6/6.
 *
 */

import React, {Component, PureComponent} from 'react';
import {
    TouchableOpacity,
    Image,
    Text,
    StyleSheet
} from 'react-native';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import Colors from '../../../config/colors';
import PressTextColor from 'FOUNDATION/pressTextColor';

const Com = __DEV__ ? Component : PureComponent;

// 看直播尾部3个按钮
export default class VideoBottomItem extends Com {

    render() {

        let i = this.props.item;
        return (
            <PressTextColor onPress={() => this.props.onClick({
                destinationUrl: i.destinationUrl,
                lgroup: i.lgroup,
                contentType: i.contentType,
                codeValue: i.codeValue
            })}>

                <Image style={styles.threeImg} source={{uri: i.firstImgUrl ? i.firstImgUrl : '11'}}>
                    <Text
                        allowFontScaling={false}
                        style={styles.threeImgText}>{i.title}</Text>
                </Image>
            </PressTextColor>)
    }
}

const styles = StyleSheet.create({
    threeImg: {
        width: ScreenUtils.screenW / 3 - ScreenUtils.scaleSize(10),
        height: ScreenUtils.scaleSize(120),
        marginHorizontal: ScreenUtils.scaleSize(4),
        alignItems: 'center',
    },
    threeImgText: {
        marginTop: ScreenUtils.scaleSize(17),
        backgroundColor: 'transparent',
        fontSize: ScreenUtils.setSpText(28),
        color: '#333',
    },
    liveSmallImg: {
        width: ScreenUtils.scaleSize(34),
        height: ScreenUtils.scaleSize(34),
        resizeMode: 'cover',
        marginTop: ScreenUtils.scaleSize(5),
    }
    ,
})
