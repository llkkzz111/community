/**
 * Created by 卓原 on 2017/5/31.
 *
 */
import React, {Component, PureComponent} from 'react';
import {
    Text,
    View,
    StyleSheet,
    Image,
    Platform
} from 'react-native';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import Colors from '../../../config/colors';
import PressTextColor from 'FOUNDATION/pressTextColor';

const Com = __DEV__ ? Component : PureComponent;

export default class YouLikeItem extends Com {
    render() {
        let item = this.props.item;
        let gifts = item.gifts;
        return (
            <PressTextColor nativeRef={[{
                ref: this.refs.titleText,
                touchColor: Colors.text_light_grey
            }]}
                            onPress={() => this.props.onClick({
                                contentCode: item.contentCode,
                                codeValue: item.codeValue
                            })}
            >
                <View>
                    {item ? <View style={styles.outView}>
                        {item.firstImgUrl ?
                            <Image
                                style={styles.imgStyle}
                                source={{uri: item.firstImgUrl}}
                            /> : null}

                        <View
                            style={styles.itemDescLast}>
                            <View style={{flex: 1}}>
                                <View style={{flexDirection: 'row'}}>
                                    <Text
                                        allowFontScaling={false}
                                        ref="titleText" numberOfLines={2}
                                        style={styles.titleTextStyle}>

                                        {this._renderFlagImg(item)}
                                        {item.title}</Text>
                                </View>
                                {gifts && gifts[0] ?
                                    <View style={{
                                        flexDirection: 'row',
                                        alignItems: 'center',
                                        marginTop: ScreenUtils.scaleSize(10)
                                    }}>
                                        <Image style={{
                                            resizeMode: 'cover',
                                            height: ScreenUtils.scaleSize(30),
                                            width: ScreenUtils.scaleSize(56),
                                            marginRight: ScreenUtils.scaleSize(10)
                                        }}
                                               source={require('../../../../foundation/Img/home/Icon_gifts1_.png')}/>
                                        <Text
                                            allowFontScaling={false}
                                            numberOfLines={1}
                                            style={{
                                                width: ScreenUtils.scaleSize(284),
                                                color: '#999',
                                                fontSize: ScreenUtils.setSpText(24),
                                                includeFontPadding: false
                                            }}>{gifts[0]}</Text>
                                    </View> : null}

                            </View>
                            <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                <View
                                    style={{
                                        flex: 1, flexDirection: 'row',
                                        alignItems: 'center'
                                    }}>
                                    <Text
                                        allowFontScaling={false}
                                        style={{
                                            color: '#E5290D',
                                            fontSize: ScreenUtils.setSpText(26)
                                        }}>¥ <Text
                                        allowFontScaling={false}
                                        style={{
                                            color: '#E5290D',
                                            fontSize: ScreenUtils.setSpText(36)
                                        }}>{item.salePrice}</Text></Text>
                                    {item.integral && item.integral > 0 ? <View style={{
                                        borderRadius: ScreenUtils.scaleSize(4),
                                        backgroundColor: '#ff8400',
                                        padding: ScreenUtils.scaleSize(4),
                                        marginRight: ScreenUtils.scaleSize(10),
                                        marginLeft: ScreenUtils.scaleSize(20)
                                    }}>
                                        <Text
                                            allowFontScaling={false}
                                            style={{
                                                fontSize: ScreenUtils.setSpText(22),
                                                includeFontPadding: false,
                                                color: '#fff'
                                            }}>积</Text></View> : null}
                                    <Text
                                        allowFontScaling={false}
                                        style={{
                                            color: '#FA6923',
                                            fontSize: ScreenUtils.setSpText(26),
                                            display: Number(item.integral) === 0 ? "none" : "flex"
                                        }}>{item.integral}</Text>
                                </View>
                                {item.inStock === '库存紧张' ?
                                    <Text
                                        allowFontScaling={false}
                                        style={{
                                            color: '#ED1C41',
                                            fontSize: ScreenUtils.setSpText(22),
                                        }}>库存紧张</Text> : null}
                            </View>
                        </View>
                    </View> : null}
                </View>
            </PressTextColor>
        )
    }

    /**
     * 渲染商品标记
     * @param item
     * @private
     */
    _renderFlagImg(item) {
        let img = null;
        let imgStyle = null;
        if (item.contentType === '0') {
            img = require('../../../../foundation/Img/searchpage/Icon_globalbuy_tag_.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (80 / 2) * ScreenUtils.pixelRatio,
                        width: (23 / 2) * ScreenUtils.pixelRatio,
                    }
                })
            };
        } else if (item.contentType === '1') {
            img = require('../../../../foundation/Img/searchpage/Icon_anchorrecommend_tag_.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (110 / 2) * ScreenUtils.pixelRatio,
                        width: (26 / 2) * ScreenUtils.pixelRatio,
                    },
                    ios: {
                        height: ScreenUtils.scaleSize(26),
                        width: ScreenUtils.scaleSize(110)
                    }
                })
            };
        } else if (item.contentType === '3') {
            img = require('../../../../foundation/Img/searchpage/icon_groupbuying2_@3x.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (79 / 2) * ScreenUtils.pixelRatio,
                        width: (24 / 2) * ScreenUtils.pixelRatio,
                    },
                    ios: {
                        height: ScreenUtils.scaleSize(26),
                        width: ScreenUtils.scaleSize(70)
                    }
                })
            };
        } else if (item.contentType === '2') {
            img = require('../../../../foundation/Img/searchpage/tag_shangcheng@3x.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (72 / 2) * ScreenUtils.pixelRatio,
                        width: (27 / 2) * ScreenUtils.pixelRatio,
                    },
                    ios: {
                        height: ScreenUtils.scaleSize(27),
                        width: ScreenUtils.scaleSize(72)
                    }
                })
            };
        }
        if (img) {
            return (
                <Image
                    source={img}
                    resizeMode={'stretch'}
                    style={imgStyle}/>
            );
        }
        return <Text/>;
    }
}

const styles = StyleSheet.create({
    outView: {
        flexDirection: 'row',
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(275),
        alignItems: 'center',
        marginTop: 0,
        backgroundColor: '#fff',
        paddingHorizontal: ScreenUtils.scaleSize(30)
    },
    imgStyle: {
        width: ScreenUtils.scaleSize(240),
        height: ScreenUtils.scaleSize(240),
        resizeMode: 'contain',
    },
    titleTextStyle: {
        fontSize: ScreenUtils.setSpText(28),
        color: '#333',
        width: ScreenUtils.scaleSize(430),
        includeFontPadding: false
    },
    stbtext: {
        fontSize: ScreenUtils.setSpText(24),
        color: '#666',
        marginLeft: ScreenUtils.scaleSize(5),
        width: ScreenUtils.scaleSize(284),
        height: ScreenUtils.scaleSize(33),
    },
    itemDesc: {
        paddingHorizontal: ScreenUtils.scaleSize(50),
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: '#dddddd',
        height: ScreenUtils.scaleSize(272.5),
        paddingVertical: ScreenUtils.scaleSize(30)
    },
    itemDescLast: {
        marginHorizontal: ScreenUtils.scaleSize(20),
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: '#ffffff',
        height: ScreenUtils.scaleSize(272.5),
        paddingVertical: ScreenUtils.scaleSize(30)
    },
    iconStyle: {
        ...Platform.select({
            ios: {
                width: ScreenUtils.scaleSize(110),
                height: ScreenUtils.scaleSize(26),
                marginRight: ScreenUtils.scaleSize(10)
            },
            android: {
                height: 100 * ScreenUtils.pixelRatio / 2,
                width: 26 * ScreenUtils.pixelRatio / 2,
            }
        }),
        zIndex: 11,
        resizeMode: 'contain',

    },
})
