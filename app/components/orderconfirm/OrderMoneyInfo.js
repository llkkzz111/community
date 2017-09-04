/**
 * Created by jzz on 2017/6/10.
 * 底部账单金额信息
 */

import React,{PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
    DeviceEventEmitter,
} from 'react-native';
import {Actions}from 'react-native-router-flux';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import OrderDescriptionInfo from './OrderDescriptionInfo';
import {DataAnalyticsModule} from '../../config/AndroidModules';
export default class OrderMoneyInfo extends React.Component{

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            descriptionTitle: ''
        };
    }

    static defaultProps={
        moneyInfo: ['商品总额', '优惠价格', '抵用券价格', '跨境综合税', '运费'], // 订单包含全球购商品
        notNeedMoneyInfo: ['商品总额', '优惠价格', '抵用券价格', '运费'],    // 订单不包含全球购商品
        keys: ['foodsAmount', 'discount', 'voucher', 'tax', 'freight'],
        notNeedKeys: ['foodsAmount', 'discount', 'voucher', 'freight'],
    };
    render () {
        let self = this;
        let isNeedFillInfo = this.props.isNeedFillInfo ? this.props.isNeedFillInfo : false; //是否需要跨境综合税
        let billAmount = this.props.billAmount;
        let moneyInfo;
        let keys;
        if (isNeedFillInfo) {
            moneyInfo = this.props.moneyInfo;
            keys = this.props.keys;
        } else {
            moneyInfo = this.props.notNeedMoneyInfo;
            keys = this.props.notNeedKeys;
        }
        return(
            <View style={styles.containerView}>
                <View style={styles.container1}>
                    {
                        moneyInfo.map(function (item, index) {
                            let tempData = String(Math.abs(Number(billAmount[keys[index]])));
                            if (index === 1 || index === 2) {
                                return(
                                    <View key={index} style={styles.infoCell}>
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.title}>{item}</Text>
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.amount}>- ¥ {tempData}</Text>
                                    </View>
                                )
                            } else  {
                                    if (index === 3) {
                                        if (isNeedFillInfo) {
                                            return(
                                                <View key={index} style={styles.infoCell}>
                                                    <View style={styles.tax}>
                                                        <Text
                                                            allowFontScaling={false}
                                                            style={styles.title}>{item}</Text>
                                                        <TouchableOpacity activeOpacity={1} onPress={() => self._showDeclaration('tax')}>
                                                            <Image source={require('../../../foundation/Img/cart/askIcon.png')}
                                                                   style={styles.shoppingInfoIconStyle}/>
                                                        </TouchableOpacity>
                                                    </View>
                                                    <Text
                                                        allowFontScaling={false}
                                                        style={styles.amount}>{index === 0 ? '¥' : '+ ¥' } {tempData}</Text>
                                                </View>)
                                        } else {
                                            return(
                                                <View key={index} style={styles.infoCell}>
                                                    <Text
                                                        allowFontScaling={false}
                                                        style={styles.title}>{item}</Text>
                                                    <Text
                                                        allowFontScaling={false}
                                                        style={styles.amount}>{index === 0 ? '¥' : '+ ¥' } {tempData}</Text>
                                                </View> )
                                        }
                                    } else {
                                        return(
                                            <View key={index} style={styles.infoCell}>
                                                <Text
                                                    allowFontScaling={false}
                                                    style={styles.title}>{item}</Text>
                                                <Text
                                                    allowFontScaling={false}
                                                    style={styles.amount}>{index === 0 ? '¥' : '+ ¥' } {tempData}</Text>
                                            </View> )
                                    }
                                }
                        })
                    }
                </View>
                <TouchableOpacity activeOpacity={1} onPress={() => this._showDeclaration('shoppingDescription')}>
                    <Text
                        allowFontScaling={false}
                        style={styles.declaration}>东方购物购买须知说明，点击了解退换货政策和积分优惠等更多内容</Text>
                </TouchableOpacity>
                <OrderDescriptionInfo ref='OrderDescriptionInfo'/>
            </View>
        );
    }

    _showDeclaration (style) {
        if (style === 'shoppingDescription') {
            if (this.props.isSingle === true) {
                DataAnalyticsModule.trackEvent2("AP1706C016F010004A001001", "");
            } else if (this.props.isSingle === false) {
                DataAnalyticsModule.trackEvent2("AP1706C017F010005A001001", "");
            }
            // Actions.OrderWebView({
            //     webUrl: 'http://m.ocj.com.cn/staticPage/shop/m/notice.jsp'
            // });
            Actions.VipPromotionGoodsDetail({
                value: 'http://m.ocj.com.cn/other/thh.jsp'
            });
        } else if (style === 'tax') {
            Actions.OrderWebViewHideNavBar({
                url: 'http://m.ocj.com.cn/staticPage/shop/m/tarrif_rules.jsp',
            });
        }
    }
}
const styles=StyleSheet.create({
    containerView: {
        marginTop: ScreenUtils.scaleSize(20),
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
    },
    container1:{
        width:ScreenUtils.screenW,
        padding: ScreenUtils.scaleSize(30),
    },
    infoCell: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        width:ScreenUtils.screenW - ScreenUtils.scaleSize(60),
        marginTop: ScreenUtils.scaleSize(12),

    },
    title: {
        alignItems: 'flex-start',
        fontSize: ScreenUtils.scaleSize(28),
        color:Colors.text_black,
    },
    amount: {
        alignItems: 'flex-end',
        fontSize: ScreenUtils.scaleSize(28),
        color:Colors.text_black,
    },
    declaration: {
        fontSize: ScreenUtils.scaleSize(22),
        alignSelf: 'center',
        color: Colors.text_light_grey,
        marginBottom: ScreenUtils.scaleSize(30),
        textDecorationLine: 'underline',
    },
    shoppingInfoIconStyle: {
        width: ScreenUtils.scaleSize(28),
        height: ScreenUtils.scaleSize(28),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    tax: {
        flexDirection: 'row',
        alignItems: 'center',
    }
});