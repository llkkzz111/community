/**
 * Created by 卓原 on 2017/6/6.
 *
 */
import React, {Component, PureComponent} from 'react';
import {
    Image,
    Text,
    StyleSheet,
    View,
    FlatList
} from 'react-native';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import Colors from '../../../config/colors';
import PressTextColor from 'FOUNDATION/pressTextColor';

const Com = __DEV__ ? Component : PureComponent;

export default class RectangleViews extends Com {
    constructor(props) {
        super(props);
    }

    _keyExtractor = (item, index) => index;

    render() {
        let list = this.props.list;
        return (
            <View style={styles.outViewStyle}>
                <FlatList
                    keyExtractor={this._keyExtractor}
                    showsHorizontalScrollIndicator={false}
                    data={list}
                    horizontal={true}
                    renderItem={({item}) =>
                        <PressTextColor
                            onPress={() => this.props.onClick({
                                title: item.title,
                                destinationUrl: item.destinationUrl,
                                codeValue: item.codeValue,
                            })}>
                            {list.length === 5 ?
                                <View style={[styles.rectangleView, styles.rectangleView5]}>
                                    {item.firstImgUrl ?
                                        <Image style={styles.rectangleViewImg}
                                               resizeMode={'contain'}
                                               source={{uri: item.firstImgUrl}}/> : null}
                                    <Text
                                        allowFontScaling={false}
                                        numberOfLines={1} style={styles.rectangleText}>{item.title}</Text>
                                </View>
                                :
                                <View style={[styles.rectangleView, styles.rectangleView6]}>
                                    {item.firstImgUrl ?
                                        <Image style={styles.rectangleViewImg}
                                               resizeMode={'contain'}
                                               source={{uri: item.firstImgUrl}}/> : null}
                                    <Text
                                        allowFontScaling={false}
                                        numberOfLines={1} style={styles.rectangleText}>{item.title}</Text>
                                </View>
                            }
                        </PressTextColor>
                    }
                />
            </View>
        )
    }
}

const styles = StyleSheet.create({
    outViewStyle: {
        backgroundColor: '#fff',
        paddingVertical: ScreenUtils.scaleSize(20),
        marginBottom: ScreenUtils.scaleSize(20),
    },
    rectangleView: {
        width: ScreenUtils.scaleSize(94),
        alignItems: 'center',
        marginLeft: ScreenUtils.scaleSize(30),
    },
    rectangleView5: {
        marginRight: Math.abs(ScreenUtils.screenW - ScreenUtils.scaleSize(94) * 5 - ScreenUtils.scaleSize(30) * 6) / 4,
    },
    rectangleView6: {
        marginRight: Math.abs(ScreenUtils.screenW - ScreenUtils.scaleSize(94) * 6 - ScreenUtils.scaleSize(30) * 7) / 5,
    },
    rectangleText: {
        fontSize: ScreenUtils.setSpText(26),
        color: '#444',
    },
    rectangleViewImg: {
        width: ScreenUtils.scaleSize(94),
        height: ScreenUtils.scaleSize(100),
        marginBottom: ScreenUtils.scaleSize(10),
        resizeMode: 'contain'
    },
})
