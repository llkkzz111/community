/**
 * Created by MASTERMIAO on 2017/5/12.
 * 订单评价页面的商品信息组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    ScrollView
} from 'react-native';

const { width } = Dimensions.get('window');

export default class OrderEvaluateProduct extends React.PureComponent {
    constructor() {
        super();
        this.state = {
            current_product_desc: '博朗（Braun）HD580家用便携大功率离子电吹风 吹风机',
            current_total: '0.00',
            current_price: '150.00',
            current_color_class: '白色',
            current_product_number: '0',
            current_product_weight: '2',
            current_star: '0',
            current_product_img: 'http://cdnimg.ocj.com.cn/item_images/item/15/08/6226/15086226L.jpg'
        }
    }

    render () {
        let { desc, number, weight, price, img, colorClass, star } = this.props
        return (
            <ScrollView style={styles.orderProductDescBg} showsVerticalScrollIndicator={false}>
                <View>
                    <View style={styles.containers}>
                        <View style={styles.orderProductDescStyle}>
                            <View style={styles.imageLayout}>
                                <Image
                                    source={{uri: img !== null ? img : this.state.current_product_img}}
                                    style={styles.imageSize} />
                            </View>
                            <View style={styles.merchandiseLayout}>
                                <View style={styles.rightInfoStyle}>
                                    <Text allowFontScaling={false} style={styles.fontWeight}>{desc !== null ? desc : this.state.current_product_desc}</Text>
                                    <Text allowFontScaling={false} style={styles.colorStyle}>颜色分类:{colorClass !== null ? colorClass : this.state.current_color_class}</Text>
                                </View>
                                <View style={styles.merchandiseCredit}>
                                    <View style={styles.preferentialActivitiesStyle}>
                                        <Text allowFontScaling={false} style={styles.shoppingPriceStyle}>¥ {String(price !== null ? price : this.state.current_price)}</Text>
                                        <Image
                                            source={require('../../Img/cart/integralIcon.png')}
                                            style={styles.shoppingCreditIconStyle}/>
                                        <Text allowFontScaling={false} style={styles.shoppingCreditStyle}>{String(star !== null ? star : this.state.current_star)}</Text>
                                        <Text allowFontScaling={false} style={{position: 'absolute', right: 0, top: 12}}>
                                            x1
                                        </Text>
                                    </View>
                                </View>
                            </View>
                        </View>
                    </View>
                </View>
            </ScrollView>
        )
    }

    _click = () => {
    }
}

const styles = StyleSheet.create({
    orderProductDescBg: {
        backgroundColor: 'white',
        marginBottom: 1
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
        height: 80,
        width: 80,
        zIndex: 0,
    },
    orderProductDescStyle: {
        alignItems: 'center',
        flexDirection: 'row',
        paddingTop: 10,
        paddingBottom: 5,
        paddingLeft: 10,
        paddingRight: 10,
    },
    imageLayout: {
        height: 100,
        width: 100,
        borderWidth: 1,
        borderColor: '#EEEEEE',
        justifyContent: 'center',
        alignItems: 'center',
        position: 'relative'
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
        fontSize: 16
    },
    shoppingCreditIconStyle: {
        width: 28,
        height: 15,
        marginLeft: 10,
        resizeMode: 'contain'
    },
    shoppingCreditStyle: {
        color: '#FFC033',
        marginLeft: 5,
        flex: 0
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
        minHeight: 40,
        marginBottom: 10
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
        flexDirection: 'column',
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
        height: 40,
        alignItems: 'center',
        flex: 3
    }
});

OrderEvaluateProduct.propTypes = {
    desc: React.PropTypes.string,
    number: React.PropTypes.any,
    weight: React.PropTypes.any,
    price: React.PropTypes.any,
    img: React.PropTypes.string,
    colorClass: React.PropTypes.string,
    star: React.PropTypes.number
}
