/**
 * Created by 卓原 on 2017/5/31.
 *
 */
import React, {Component, PureComponent} from 'react';
import {
    Text,
    View,
    StyleSheet,
    Image
} from 'react-native';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import Colors from '../../../config/colors';
import PressTextColor from 'FOUNDATION/pressTextColor';

const Com = __DEV__ ? Component : PureComponent;

export default class RecommendItem extends Com {
    render() {
        let item = this.props.item;
        return (
            <PressTextColor
                nativeRef={[{
                    ref: this.refs.title,
                    touchColor: Colors.text_light_grey
                }]}
                onPress={() => {
                    this.props.onClick({
                        id: 13,
                        url: item.destinationUrl,
                        code: item.contentCode,
                        codeValue: item.codeValue
                    });
                }}
            >
                <View style={styles.rowstyle}>
                    <View style={styles.outImgStyle}>
                        {item.firstImgUrl ? (
                            <Image
                                style={styles.outImgStyle}
                                source={{uri: item.firstImgUrl}}>
                            </Image>
                        ) : null}
                    </View>
                    <View style={styles.textViewStyle}>
                        <Text
                            allowFontScaling={false}
                            ref="title" numberOfLines={2} style={styles.text1}>{item.title}</Text>
                        <Text
                            allowFontScaling={false}
                            style={styles.watchNumber}>阅读 {item.watchNumber}</Text>
                    </View>
                </View>
            </PressTextColor>
        );
    }
}

const styles = StyleSheet.create({
    rowstyle: {
        paddingRight: ScreenUtils.scaleSize(30),
        paddingVertical: ScreenUtils.scaleSize(20),
        flexDirection: 'row',
        width: ScreenUtils.screenW,
        //marginBottom: ScreenUtils.scaleSize(1),
        backgroundColor: '#fff',
        borderBottomColor: '#ededed',
        borderBottomWidth: ScreenUtils.scaleSize(1),
        alignItems: 'center',
    },
    outImgStyle: {
        width: ScreenUtils.scaleSize(172),
        height: ScreenUtils.scaleSize(116),
        marginRight: ScreenUtils.scaleSize(20),
    },
    textViewStyle: {
        width: ScreenUtils.scaleSize(488),
        paddingRight: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(116),
    },
    text1: {
        color: '#333',
        fontSize: ScreenUtils.setSpText(28),
    },
    watchNumber: {
        color: '#999',
        fontSize: ScreenUtils.setSpText(24),
        position: 'absolute',
        bottom: 0
    },
})
