/**
 * Created by zhuoy on 2017/5/23.
 */

import React, {Component, PureComponent} from 'react';
import {
    Text,
    View,
    StyleSheet,
    Image,
} from 'react-native';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import PressTextColor from 'FOUNDATION/pressTextColor';

const Com = __DEV__ ? Component : PureComponent;

export default class Item extends Com {
    render() {
        let row = this.props.row;
        return (
            <PressTextColor
                onPress={() => this.props.onClick({
                    shortNumber: row.shortNumber,
                    destinationUrl: row.destinationUrl,
                    title: row.title,
                    lgroup: row.lgroup,
                    codeValue: row.codeValue
                })}
            >
                <View style={styles.itemview}>

                    <View style={{
                        backgroundColor: '#EFF1EE',
                        width: ScreenUtils.scaleSize(100),
                        height: ScreenUtils.scaleSize(100),
                        borderRadius: ScreenUtils.scaleSize(50),
                        justifyContent: 'center',
                        alignItems: 'center'
                    }}>
                        <Image source={{uri: row.firstImgUrl ? row.firstImgUrl : '111'}} style={styles.img}/>
                    </View>

                    <Text
                        allowFontScaling={false}
                        numberOfLines={1} style={styles.text}>{row.title}</Text>
                </View>
            </PressTextColor>
        )
    }
}

const styles = StyleSheet.create({
    img: {
        width: ScreenUtils.scaleSize(100),
        height: ScreenUtils.scaleSize(100),
        borderRadius: ScreenUtils.scaleSize(50),
        resizeMode: "cover",
        //overlayColor: '#fff'
    },
    itemview: {
        width: ScreenUtils.screenW / 5,
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: ScreenUtils.scaleSize(20),
    },
    text: {
        fontSize: ScreenUtils.setSpText(26),
        color: '#444',
        marginTop: ScreenUtils.scaleSize(20)
    },
})
