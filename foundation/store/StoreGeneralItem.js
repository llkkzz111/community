/**
 * Created by MASTERMIAO on 2017/6/18.
 * 商城店铺页面通用条目组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    TouchableOpacity,
    StyleSheet,
    Dimensions,
    Image
} from 'react-native';

const { width } = Dimensions.get('window');

import { Actions } from 'react-native-router-flux';

import Fonts from '../../app/config/fonts';

import Colors from '../../app/config/colors';

import * as ScreenUtils from '../utils/ScreenUtil';

export default class StoreGeneralItem extends React.PureComponent {
    render() {
        let { img, proItem, prevPrice, currentPrice, saleNumber, productId } = this.props;
        return (
            <View style={styles.rowContainers}>
                <TouchableOpacity activeOpacity={1} style={styles.columnImgBg} onPress={() => {Actions.GoodsDetailMain({itemcode: productId});}}>
                    <Image style={styles.columnImg}
                           resizeMode={'center'}
                           source={{uri: img}} />
                </TouchableOpacity>
                <View style={styles.descRow}>
                    <View style={styles.proItemBg}>
                        <Text allowFontScaling={false} style={styles.groupProductStyle}>
                            {proItem}
                        </Text>
                    </View>
                    <View style={styles.priceDescRow}>
                        <Text allowFontScaling={false} style={styles.priceStyle2}>￥</Text>
                        <Text allowFontScaling={false} style={styles.priceStyle}>{String(currentPrice)}</Text>
                        <Text allowFontScaling={false} style={styles.priceProvious}>{String(prevPrice)}</Text>
                        <Text allowFontScaling={false} style={styles.rowBuyNumberStyle}>
                            {String(saleNumber)}件已售
                        </Text>
                    </View>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    rowContainers: {
        backgroundColor: Colors.background_white,
        flexDirection: 'column',
        borderWidth: 0.3,
        borderColor: Colors.line_grey,
        justifyContent: 'flex-start',
        width: width / 2,
        height: ScreenUtils.scaleSize(561)
    },
    columnImgBg: {
        height: ScreenUtils.scaleSize(355),
        maxHeight: ScreenUtils.scaleSize(355),
        marginTop: ScreenUtils.scaleSize(30),
        marginLeft: ScreenUtils.scaleSize(10),
        marginRight: ScreenUtils.scaleSize(10),
        alignItems: 'center',
        justifyContent: 'center'
    },
    columnImg: {
        width: ScreenUtils.scaleSize(355),
        height: ScreenUtils.scaleSize(355),
        maxHeight: ScreenUtils.scaleSize(355),
        maxWidth: ScreenUtils.scaleSize(355)
    },
    proItemBg: {
        flex: 1,
        height: ScreenUtils.scaleSize(80)
    },
    groupProductStyle: {
        color: Colors.text_black,
        fontSize: Fonts.standard_normal_font()
    },
    priceStyle: {
        color: Colors.text_orange,
        fontSize: Fonts.standard_normal_font()
    },
    priceStyle2: {
        color: Colors.text_orange,
        fontSize: Fonts.tag_font()
    },
    priceProvious: {
        color: Colors.text_light_grey,
        fontSize: Fonts.tag_font(),
        textDecorationLine: 'line-through'
    },
    rowBuyNumberStyle: {
        color: Colors.text_light_grey,
        fontSize: Fonts.tag_font(),
        position: 'absolute',
        right: 0
    },
    descRow: {
        flex: 1,
        height: ScreenUtils.scaleSize(167),
        marginRight: ScreenUtils.scaleSize(10),
        marginLeft: ScreenUtils.scaleSize(10),
        marginTop: ScreenUtils.scaleSize(9)
    },
    priceDescRow: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: ScreenUtils.scaleSize(16),
        marginBottom: ScreenUtils.scaleSize(27)
    }
});

StoreGeneralItem.propTypes = {
    img: React.PropTypes.string,
    prevPrice: React.PropTypes.any,
    currentPrice: React.PropTypes.any,
    proItem: React.PropTypes.string,
    saleNumber: React.PropTypes.any,
    productId: React.PropTypes.string
}