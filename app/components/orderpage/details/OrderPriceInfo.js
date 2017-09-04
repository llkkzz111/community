/**
 * Created by pactera on 2017/7/27.
 */
'use strict';
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Text,
    TouchableOpacity,
    Image,
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

export default class OrderPriceInfo extends Component {
    static propTypes = {
        payType: PropTypes.string,
        goodsSumAmt: PropTypes.string,
        beneficialPrice: PropTypes.string,
        couponPrice: PropTypes.string,
        prepaymentsAmt: PropTypes.string,
        sumPoints: PropTypes.string,
        freight: PropTypes.string,
        orderSumPrice: PropTypes.string,
        showAmtStr: PropTypes.string,
        showAmt: PropTypes.string,
        giftCard: PropTypes.string,
        globalTax: PropTypes.string,
        onTaxClick: PropTypes.func,
        onLineSub: PropTypes.string,
        noPayOnlineSub: PropTypes.string
    }
    static defaultProps = {
        payType: '',
        goodsSumAmt: '',
        beneficialPrice: '',
        couponPrice: '',
        prepaymentsAmt: '',
        sumPoints: '',
        freight: '',
        orderSumPrice: '',
        showAmtStr: '',
        showAmt: '',
        giftCard: '',
        globalTax: '',
        onTaxClick: '',
        onLineSub: '',
        noPayOnlineSub: ''
    }

    render() {
        return (
            <View style={styles.container}>
                {(this.props.payType && this.props.payType.length > 0) ? (
                    <View style={styles.payType}>
                        <Text
                            allowFontScaling={false}
                            style={styles.payTypeText}>
                            支付方式
                        </Text>
                        <Text
                            allowFontScaling={false}
                            style={styles.payTypeText}>
                            {this.props.payType}
                        </Text>
                    </View>
                ) : null}
                <View style={styles.priceDetail}>
                    {(this.props.goodsSumAmt && parseFloat(this.props.goodsSumAmt) !== 0) ?
                        this._renderItem('商品总额', this.props.goodsSumAmt)
                        : null}
                    {(this.props.beneficialPrice && parseFloat(this.props.beneficialPrice) !== 0) ?
                        this._renderItem('优惠价格', this.props.beneficialPrice, '-')
                        : null}
                    {(this.props.couponPrice && parseFloat(this.props.couponPrice) !== 0) ?
                        this._renderItem('抵用券价格', this.props.couponPrice, '-')
                        : null}
                    {(this.props.globalTax && parseFloat(this.props.globalTax) !== 0) ?
                        this._renderItem('跨境综合税', this.props.globalTax, '+', require('../../../../foundation/Img/cart/askIcon.png'), this.props.onTaxClick)
                        : null}
                    {(this.props.prepaymentsAmt && parseFloat(this.props.prepaymentsAmt) !== 0) ?
                        this._renderItem('预付款金额', this.props.prepaymentsAmt, '-')
                        : null}
                    {(this.props.onLineSub && parseFloat(this.props.onLineSub) !== 0) ?
                        this._renderItem(`在线立减${this.props.onLineSub}元`, this.props.onLineSub, '-')
                        : null}
                    {(this.props.sumPoints && parseFloat(this.props.sumPoints) !== 0) ?
                        this._renderItem('积分抵扣', this.props.sumPoints, '-')
                        : null}
                    {(this.props.giftCard && parseFloat(this.props.giftCard) !== 0) ?
                        this._renderItem('礼包', this.props.giftCard, '-')
                        : null}
                    {(this.props.freight) ?
                        this._renderItem('运费', this.props.freight)
                        : null}
                </View>
                <View style={styles.orderSumPrice}>
                    {(this.props.showAmtStr && this.props.showAmtStr.length > 0) ? (
                        <View style={{flexDirection: 'row', justifyContent: 'center', alignItems: 'center'}}>
                        <Text
                            allowFontScaling={false}
                            style={styles.priceDetailText}>
                            {this.props.showAmtStr}
                        </Text>
                        {this.props.noPayOnlineSub && parseFloat(this.props.noPayOnlineSub) !== 0?
                            <Text
                                allowFontScaling={false}
                                style={styles.cutDown}>{'在线支付优惠' + this.props.noPayOnlineSub + '元'}</Text>
                            : null}
                        </View>
                    ) : null}
                    {(this.props.showAmt && this.props.showAmt.length > 0) ? (
                        <Text
                            allowFontScaling={false}
                            style={styles.orderSumPriceText}>
                            <Text
                                allowFontScaling={false}
                                style={{fontSize: ScreenUtils.setSpText(24)}}>
                                ￥
                            </Text>
                            {this.props.showAmt}
                        </Text>
                    ) : null}
                </View>
            </View>
        );
    }

    _renderItem(type, price, flag, image, onClick) {
        return (
            <View style={styles.priceDetailView}>
                <View style={styles.tax}>
                    <Text
                        allowFontScaling={false}
                        style={styles.priceDetailText}>
                        {type}
                    </Text>
                    {(typeof image !== 'undefined') ? (
                        <TouchableOpacity activeOpacity={1} onPress={onClick}>
                            <Image source={image}
                                   style={styles.shoppingInfoIconStyle}/>
                        </TouchableOpacity>
                    ) : null}
                </View>
                <Text
                    allowFontScaling={false}
                    style={styles.priceDetailText}>
                    {flag}￥{price}
                </Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        flex: 1,
        backgroundColor: Colors.background_grey,
        marginTop: ScreenUtils.scaleSize(20),
    },
    payType: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: ScreenUtils.scaleSize(30),
        backgroundColor: Colors.background_white
    },
    payTypeText: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(26),
    },
    priceDetail: {
        marginTop: ScreenUtils.scaleSize(2),
    },
    priceDetailView: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingVertical: ScreenUtils.scaleSize(10),
        paddingHorizontal: ScreenUtils.scaleSize(30),
        backgroundColor: Colors.background_white
    },
    priceDetailText: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(26),
    },
    orderSumPrice: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        marginTop: ScreenUtils.scaleSize(2),
        paddingVertical: ScreenUtils.scaleSize(30),
        paddingHorizontal: ScreenUtils.scaleSize(30),
        backgroundColor: Colors.background_white
    },
    orderSumPriceText: {
        color: Colors.main_color,
        fontSize: ScreenUtils.setSpText(34),
    },
    tax: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    shoppingInfoIconStyle: {
        width: ScreenUtils.scaleSize(28),
        height: ScreenUtils.scaleSize(28),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    cutDown: {
        backgroundColor: '#FFF1F4',
        color: '#E5290D',
        fontSize: ScreenUtils.scaleSize(22),
        padding: ScreenUtils.scaleSize(6),
        borderRadius: ScreenUtils.scaleSize(6),
        marginLeft: ScreenUtils.scaleSize(6)
    }
});