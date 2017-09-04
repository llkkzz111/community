/**
 * Created by 卓原 on 2017/5/30.
 *
 */

import React, { Component, PureComponent } from 'react';
import {
    View,
    Image,
    Text,
    StyleSheet
} from 'react-native';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import Colors from '../../../config/colors';
import PressTextColor from 'FOUNDATION/pressTextColor';

const Com = __DEV__ ? Component : PureComponent;

export default class DoumaluItem2 extends Com {
    render() {
        let item = this.props.item;
        return (
            <PressTextColor
                onPress={() => this.props.onClick({id: 12, value: item.destinationUrl, codeValue: item.codeValue})}>
                <View style={styles.douView2}>
                    <Text
                        allowFontScaling={false}
                        style={styles.douTextStyle1}>{item.title}</Text>
                    <Text
                        allowFontScaling={false}
                        style={styles.douTextStyle2}>{item.subtitle}</Text>
                    <View
                        allowFontScaling={false}
                        style={{flexDirection: 'row', justifyContent: 'center'}}>

                        {item.firstImgUrl ?
                            <Image style={{
                                resizeMode: 'contain',
                                height: ScreenUtils.scaleSize(138),
                                width: ScreenUtils.scaleSize(340)
                            }} source={{uri: item.firstImgUrl}}/> : null}
                    </View>
                </View>
            </PressTextColor>
        )
    }
}

const styles = StyleSheet.create({
    douView2: {
        padding: ScreenUtils.scaleSize(10),
        backgroundColor: '#fff',
        width: ScreenUtils.screenW / 2 + 0.5,    //2张图
        //marginRight: ScreenUtils.scaleSize(0),
        borderRightWidth:1,
        borderBottomWidth:1,
        borderRightColor: '#dddddd',
        borderBottomColor: '#dddddd',
        //marginBottom: ScreenUtils.scaleSize(0),
        height: ScreenUtils.scaleSize(243)
    },
    douTextStyle1: {
        color: '#333',
        fontSize: ScreenUtils.setSpText(28),
    },
    douTextStyle2: {
        color: '#999',
        fontSize: ScreenUtils.setSpText(26),
        marginTop:ScreenUtils.scaleSize(10),
    },
})
