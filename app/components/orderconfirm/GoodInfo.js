/**
 * Created by YASIN on 2017/6/10.
 * 填写订单的每个iteminfo
 */
import React, {PropTypes} from 'react';
import Immutable from 'immutable';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    ScrollView
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import OrderDescriptionInfo from './OrderDescriptionInfo';
export default class GoodInfo extends React.Component {
    static propTypes = {
        ...View.propTypes.style,
        icon: Image.propTypes.source, //商品图片
        title: PropTypes.string, //title
        color: PropTypes.string, //颜色
        type: PropTypes.string, //规格
        integral: PropTypes.string, //积分
        count: PropTypes.string, //数量
        weight: PropTypes.string, //重量
        price: PropTypes.string, //价格
        onlyOne: PropTypes.bool, //是否是单商品,
        isFirstBuy: PropTypes.bool//是否是首购商品
    }
    static defaultProps = {
        onlyOne: false,
        isFirstBuy: false
    }

    render() {
        let desc = '';
        if (this.props.color && this.props.color.length > 0) {
            desc += '颜色分类：' + this.props.color;
        }
        if (this.props.type && this.props.type.length > 0) {
            desc += '规格型号' + this.props.type;
        }
        return (
            <View style={[styles.itemContainer, this.props.style]}>
                <Image
                    style={styles.itemIconStyle}
                    source={this.props.icon}
                />
                <View style={styles.itemRightContainer}>
                    <Text
                        allowFontScaling={false}
                        style={styles.itemTitleStyle}
                        numberOfLines={2}
                    >
                        {this.props.title}
                    </Text>
                    {/*基本信息*/}
                    <View style={styles.goodDescContainer}>
                        <View style={styles.goodDescLeft}>
                            {/*颜色*/}
                            {(desc && desc.length > 0) ? (
                                <Text
                                    allowFontScaling={false}
                                    style={styles.itemColorStyle}>{desc}</Text>
                            ) : null}
                        </View>
                        {/*单商品跟多商品数量显示判断*/}
                        <View style={styles.goodDescRight}>
                            {this.props.onlyOne ? (
                                <View>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.countTextStyle}>共{this.props.count}件</Text>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.weightTextStyle}>{this.props.weight}</Text>
                                </View>
                            ) : null}
                        </View>
                    </View>
                    <View style={styles.itemPriceContainer}>
                        <View style={styles.priceInner}>
                            <Text
                                allowFontScaling={false}
                                style={styles.priceTyle}>¥ <Text
                                allowFontScaling={false}
                                style={styles.price}>{this.props.price}</Text></Text>

                            {/*积分判断， 0显示*/}
                            {(this.props.integral && parseFloat(this.props.integral) !== 0) ? (
                                <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                    <View style={styles.integralStyle}>
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.integralTextStyle}>积</Text>
                                    </View>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.integralDescStyle}>{this.props.integral}</Text>
                                </View>
                            ) : null}
                            {/*首购优惠判断*/}
                            {this.props.isFirstBuy ? (
                                <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                    <View style={styles.itemFirstContainer}>
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.itemFirstStyle}>首购优惠</Text>
                                    </View>
                                    <TouchableOpacity activeOpacity={1} onPress={() => this.showAction('firstBuy')}>
                                        <Image
                                            source={require('../../../foundation/Img/cart/askIcon.png')}
                                            style={styles.shoppingInfoIconStyle}/>
                                    </TouchableOpacity>
                                </View>
                            ) : null}
                        </View>
                        {/*单商品跟多商品数量显示判断*/}
                        {(!!!this.props.onlyOne) ? (
                            <Text
                                allowFontScaling={false}
                                style={styles.itemGoodCount}>x{this.props.count}</Text>
                        ) : null}
                    </View>
                </View>
                <OrderDescriptionInfo ref='OrderDescriptionInfo'/>
            </View>
        );
    }

    showAction(style) {
        this.refs.OrderDescriptionInfo.show(style)
    }
}
const styles = StyleSheet.create({
    itemContainer: {
        flexDirection: 'row',
        padding: ScreenUtils.scaleSize(30),
        width: ScreenUtils.screenW
    },
    itemIconStyle: {
        width: ScreenUtils.scaleSize(180),
        height: ScreenUtils.scaleSize(180),
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.line_grey
    },
    itemRightContainer: {
        marginLeft: ScreenUtils.scaleSize(10),
        flex: 1,
        justifyContent: 'space-between',
    },
    itemTitleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28),
    },
    goodDescContainer: {
        flexDirection: 'row',
        alignItems: 'flex-start',
    },
    goodDescLeft: {
        flexDirection: 'row',
        alignItems: 'center',
        flex: 1,
    },
    goodDescRight: {
        alignItems: 'center',
    },
    itemColorStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.scaleSize(24)
    },
    itemTypeStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(10)
    },
    itemPriceContainer: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        justifyContent: 'space-between',
    },
    countTextStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(24),
    },
    weightTextStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.scaleSize(20),
        marginTop: ScreenUtils.scaleSize(5)
    },
    priceInner: {
        flexDirection: 'row',
        alignItems: 'flex-end',
    },
    priceTyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(22)
    },
    price: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(30)
    },
    integralTextStyle: {
        color: Colors.text_white,
        fontSize: ScreenUtils.scaleSize(22),
    },
    integralStyle: {
        backgroundColor: Colors.yellow,
        alignItems: 'center',
        justifyContent: 'center',
        padding: ScreenUtils.scaleSize(2),
        borderRadius: ScreenUtils.scaleSize(4),
        marginLeft: ScreenUtils.scaleSize(10),
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
    },
    integralDescStyle: {
        color: Colors.yellow,
        fontSize: ScreenUtils.scaleSize(26),
        marginLeft: ScreenUtils.scaleSize(5)
    },
    itemFirstContainer: {
        backgroundColor: '#FFF1F4',
        alignItems: 'center',
        justifyContent: 'center',
        padding: ScreenUtils.scaleSize(5),
        borderRadius: ScreenUtils.scaleSize(2),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    itemFirstStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(20),
    },
    shoppingInfoIconStyle: {
        width: ScreenUtils.scaleSize(28),
        height: ScreenUtils.scaleSize(28),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    itemGoodCount: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
    }
});