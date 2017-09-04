/**
 * Created by MASTERMIAO on 2017/5/8.
 * 订单填写页面的单商品清单信息组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    TouchableOpacity,
    ScrollView
} from 'react-native';

const { width } = Dimensions.get('window');

import OrderListGiftMenu from './OrderListGiftMenu';

export default class OrderProductListDesc extends React.PureComponent {
    constructor() {
        super();
        this.state = {
            current_product_desc: '',
            current_total: '0',
            current_price: '0',
            current_color_class: '',
            current_product_number: '0',
            current_star: '0',
            current_product_img: ''
        }
    }

    render () {
        let { isFirstBuy, itemName, count, price, img, colorClass, record, giftData } = this.props;
        return (
            <ScrollView style={styles.orderProductDescBg}
                        showsVerticalScrollIndicator={false}>
                <View style={styles.containers}>
                    <View style={styles.orderProductDescStyle}>
                        <View style={styles.imageLayout}>
                            <Image
                                source={{uri: img !== null ? img : this.state.current_product_img}}
                                style={styles.imageSize} />
                        </View>
                        <View style={styles.merchandiseLayout}>
                            <View style={styles.rightInfoStyle}>
                                <Text allowFontScaling={false} style={styles.fontWeight}>{itemName !== null ? itemName : this.state.current_product_desc}</Text>
                                <Text allowFontScaling={false} style={styles.colorStyle}>颜色分类:{colorClass !== null ? colorClass : this.state.current_color_class}</Text>
                            </View>
                            <View style={styles.merchandiseCredit}>
                                <View style={styles.preferentialActivitiesStyle}>
                                    <Text allowFontScaling={false} style={styles.shoppingPriceStyle}>¥ {String(price !== null ? price : this.state.current_price)}</Text>
                                    <Image
                                        source={require('../Img/cart/integralIcon.png')}
                                        style={styles.shoppingCreditIconStyle}/>
                                    <Text allowFontScaling={false} style={styles.shoppingCreditStyle}>{String(record !== null ? record : this.state.current_star)}</Text>
                                    {isFirstBuy !== 'no' && <TouchableOpacity activeOpacity={1} onPress={this._click} style={styles.discountBgStyle}>
                                        <Text allowFontScaling={false} style={styles.discountDescStyle}>
                                            首购优惠
                                        </Text>
                                    </TouchableOpacity>}
                                    <Image
                                        source={require('../Img/cart/askIcon.png')}
                                        style={styles.shoppingInfoIconStyle} />
                                    <View style={styles.totalStyle}>
                                        {/*<Text allowFontScaling={false} style={styles.total}>已预约</Text>*/}
                                        <Text allowFontScaling={false} style={styles.total}>
                                            {'x' + String(count !== null && count !== undefined ? count : this.state.current_product_number)}
                                        </Text>
                                    </View>
                                </View>
                            </View>
                        </View>
                    </View>
                    <View style={styles.productHeaderLayout}>
                        <OrderListGiftMenu giftData={giftData} />
                    </View>
                </View>
            </ScrollView>
        )
    }

    _click = () => {
        this.props.openMenu();
    }
}

const styles = StyleSheet.create({
    orderProductDescBg: {
        marginTop: 10,
        backgroundColor: 'white'
    },
    containers: {
        flex: 1,
        flexDirection: 'column'
    },
    greyLineStyle: {
        width: width,
        height: 1,
        backgroundColor: '#DDDDDD'
    },
    imageSize: {
        height: 100,
        width: 100,
        zIndex: 0,
        borderWidth: 1,
        borderColor: '#DDDDDD',
        borderRadius: 3
    },
    orderProductDescStyle: {
        alignItems: 'center',
        flexDirection: 'row',
        paddingTop: 10,
        paddingBottom: 5,
        paddingLeft: 10,
        paddingRight: 10
    },
    imageLayout: {
        height: 100,
        width: 100,
        borderWidth: 1,
        borderColor: '#EEEEEE',
        justifyContent: 'center',
        alignItems: 'center',
        position: 'relative',
        marginLeft: 5
    },
    merchandiseLayout: {
        marginLeft: 5,
        justifyContent: 'space-between',
        flex: 1
    },
    colorStyle:{
        color: '#666666',
        fontSize: 11
    },
    fontWeight: {
        marginLeft: 0,
        marginRight: 5,
        fontSize: 13,
        color: '#333333',
        alignSelf: 'flex-start'
    },
    rightInfoStyle: {
        alignSelf: 'flex-start'
    },
    merchandiseCredit: {
        paddingTop: 8,
        flexDirection: 'row',
        flex: 1,
        justifyContent: 'space-between',
        marginTop: 8
    },
    shoppingPriceStyle: {
        color: 'red',
        fontSize: 13
    },
    shoppingCreditIconStyle: {
        width: 28,
        height: 15,
        marginLeft: 5,
        resizeMode: 'contain'
    },
    shoppingCreditStyle: {
        color: '#FFC033',
        marginLeft: 5
    },
    shoppingInfoIconStyle: {
        width: 16,
        height: 16,
        marginLeft: 5,
        resizeMode: 'contain'
    },
    productHeaderLayout: {
        marginLeft: 10,
        marginRight: 10,
        minHeight: 30
    },
    discountBgStyle: {
        backgroundColor: '#FFF1F4',
        width: 60,
        height: 30,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 3,
        marginLeft: 5
    },
    discountDescStyle: {
        color: '#E5290D',
        fontSize: 13
    },
    totalStyle: {
        flexDirection: 'row',
        position: 'relative',
        right: -15
    },
    total: {
        fontSize: 13,
        color: 'black'
    },
    weightStyle: {
        fontSize: 12,
        color: '#AAAAAA'
    },
    preferentialActivitiesStyle: {
        flexDirection: 'row',
        alignItems: 'center'
    }
});

OrderProductListDesc.propTypes = {
    desc: React.PropTypes.string,
    number: React.PropTypes.any,
    weight: React.PropTypes.any,
    price: React.PropTypes.any,
    img: React.PropTypes.string,
    colorClass: React.PropTypes.string,
    star: React.PropTypes.number
}