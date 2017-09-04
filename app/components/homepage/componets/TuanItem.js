/**
 * Created by 卓原 on 2017/5/22 0022.
 * 折扣商品图文组件 左上角折扣文字，图下方有售价，原价和已售个数
 */

import React, {Component, PureComponent} from 'react';
import {
    View,
    Text,
    Image,
    StyleSheet,
    Platform
} from 'react-native';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import PressTextColor from 'FOUNDATION/pressTextColor';

// 根据开发环境选择是否要不可变数据结构
const Com = __DEV__ ? Component : PureComponent;

export default class TuanItem extends Com {

    render() {
        let item = this.props.item;
        return (
            <PressTextColor onPress={() => this.props.onClick({
                contentCode: item.contentCode,
                codeValue: item.codeValue
            })}>
                <View style={styles.container}>
                    <Image source={{uri: item.firstImgUrl ? item.firstImgUrl : '11'}}
                           resizeMode={'cover'}
                           style={styles.imagesize}
                    >
                        {
                            (item.discount && parseFloat(item.discount) !== 10 && parseFloat(item.discount) !== 0) ? (
                                <View style={styles.discountView}>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.discount}
                                    >{item.discount}折
                                    </Text>
                                </View>
                            ) : null
                        }
                    </Image>
                    <View>
                        <Text
                            allowFontScaling={false}
                            numberOfLines={2} style={styles.titleText}>{item.title}</Text>
                        <Text
                            allowFontScaling={false}
                            style={styles.price}>¥<Text allowFontScaling={false}
                                                        style={{
                                                            fontSize: ScreenUtils.setSpText(30),
                                                        }}>{item.salePrice}</Text></Text>
                    </View>

                </View>
            </PressTextColor>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        marginHorizontal: ScreenUtils.scaleSize(20),
        width: ScreenUtils.scaleSize(180),
        marginVertical: ScreenUtils.scaleSize(10),
    },
    imagesize: {
        width: ScreenUtils.scaleSize(180),
        height: ScreenUtils.scaleSize(180),
    },
    titleText: {
        color: '#333',
        fontSize: ScreenUtils.setSpText(24),
        marginVertical: ScreenUtils.scaleSize(10),
    },
    discountView: {
        backgroundColor: "#ED1C41",
        width:ScreenUtils.scaleSize(75),
    },
    discount: {
        color: 'white',
        fontWeight: 'bold',
        fontSize: ScreenUtils.setSpText(26),
        includeFontPadding: false,
        textAlign:'center',
        ...Platform.select({
            android: {
                marginTop: ScreenUtils.scaleSize(2)
            }
        })
    },
    price: {
        color: '#E5290D',
        fontSize: ScreenUtils.setSpText(24),
        textAlignVertical: 'bottom',
        //lineHeight: 16,
    },
});
