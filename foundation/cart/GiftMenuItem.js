/**
 * Created by MASTERMIAO on 2017/5/6.
 * 购物车赠品栏的隐藏部分组件
 *
 */
'use strict';

import React, {Component} from 'react';

import {
    View,
    Text,
    Image,
    TouchableOpacity,
    StyleSheet,
    Dimensions,
    ART,
} from 'react-native';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
const {width, height} = Dimensions.get('window');
export class GiftMenuItem extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        if (Array.isArray(this.props.gifts) && this.props.gifts.length > 0) {
            return (
                <View style={styles.containers}>
                    {this.props.gifts.map((item, index) => {
                        return (
                            <View style={{
                                flexDirection: 'row',
                                justifyContent: 'flex-start',
                                alignItems: 'center'
                            }}>
                                <Text
                                    numberOfLines={1}
                                    style={{
                                        flex: 1,
                                        justifyContent: 'flex-start',
                                        fontSize: ScreenUtils.setSpText(24),
                                        color: "#666666"
                                    }}
                                    allowFontScaling={false}>{item.item_name}</Text>
                                <Text
                                    style={{
                                        fontSize: ScreenUtils.setSpText(24),
                                        color: "#666666"
                                    }}
                                    allowFontScaling={false}>x{this.props.itemQty}</Text>
                                <TouchableOpacity
                                    style={styles.actionBg}
                                    onPress={() => this.props.changeGiftItem({
                                        sitem_code: item.sitem_code,
                                    })}>
                                    <Text
                                        style={{
                                            fontSize: ScreenUtils.setSpText(18),
                                            marginRight: ScreenUtils.scaleSize(6),
                                            color: "#666666"
                                        }}>更换</Text>
                                    <Image
                                        style={styles.actionImgStyle}
                                        source={require('../Img/cart/Icon_right_grey_@3x.png')}/>
                                </TouchableOpacity>
                            </View>
                        );
                    })}
                </View>
            );
        } else {
            return null;
        }
    }
}

const styles = StyleSheet.create({
    containers: {
        backgroundColor: '#FFF1F4',
        padding: 5,
    },
    giftItemDescStyle: {
        fontSize: 12,
        color: 'black',
        marginLeft: 10,
        marginRight: 5
    },
    giftItemDescStyle2: {
        fontSize: 12,
        color: '#666666',
        marginLeft: 5,
        marginTop: 5
    },
    giftItem: {
        height: 30,
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: '#FFF1F4',
        marginRight: 10,
    },
    giftDescStyle: {
        fontSize: 12,
        color: '#666666'
    },
    giftDescStyle2: {
        fontSize: 12,
        color: '#666666',
        marginRight: 15
    },
    giftDescStyle3: {
        fontSize: 12,
        color: '#666666',
        marginLeft: 20,
        flex: 1
    },
    giftBlueBg: {
        width: 40,
        height: 25,
        borderRadius: 2.5,
        backgroundColor: '#1AD2EA',
        marginLeft: 5,
        justifyContent: 'center',
        alignItems: 'center'
    },
    giftBlueBgDesc: {
        fontSize: 12,
        color: 'white'
    },
    giftBlueBgDesc2: {
        fontSize: 12,
        color: '#666666',
        marginRight: 15
    },
    giftImg: {
        width: 95,
        height: 95,
    },
    giftImgBg: {
        justifyContent: 'center',
        alignItems: 'center',
        position: "relative",
        marginLeft: 5,
        height: 100,
        width: 100,
        borderRadius: 2,
        borderWidth: 1,
        borderColor: '#EEEEEE'
    },
    giftGoodItem: {
        flex: 1,
        height: 40,
        flexDirection: 'row',
        alignItems: 'center'
    },
    giftGoodItemDescStyle: {
        flexDirection: 'column',
        marginTop: 10,
        alignSelf: "flex-start",
        flex: 1
    },
    line: {
        flex: 1,
        height: 1,
        backgroundColor: '#EFECED',
        paddingLeft: 15,
        paddingRight: 15
    },
    actionBg: {
        alignItems: 'center',
        flexDirection: 'row',
        marginLeft: 5,
    },
    actionTitleStyle: {
        fontSize: 13,
        color: '#DF2928',
        marginRight: 3,
    },
    actionImgStyle: {
        width: 7,
        height: 10,
        resizeMode: "contain",
    }
});
export default GiftMenuItem