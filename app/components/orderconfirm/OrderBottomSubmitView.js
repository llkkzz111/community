/**
 * Created by jzz on 2017/6/10.
 *  渲染底部的提交按钮以及地址提示页
 */
import React from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
export default class OrderBottomSubmitView extends React.Component{

    render () {
        let { address, totalAmount, showBottomAdd } = this.props
        return(
            <View style={[styles.containerView,{height: showBottomAdd ? ScreenUtils.scaleSize(148): ScreenUtils.scaleSize(88)}]}>
                {
                    showBottomAdd && address && address.length > 0 ?
                        <View style={styles.addressView}>
                            <Text
                                allowFontScaling={false}
                                ellipsizeMode={'tail'}
                                  style={styles.addressTitle}
                                  numberOfLines={1}>
                                {address}
                            </Text>
                        </View>
                        :
                        <View/>
                }
                <View style={styles.submitView}>
                    <View style={styles.amount}>
                        <Text
                            allowFontScaling={false}
                            style={styles.amountTitle}>应付金额:</Text>
                        <Text
                            allowFontScaling={false}
                            style={styles.RMBIcon}>¥</Text>
                        <Text
                            allowFontScaling={false}
                            style={styles.amountPrice}>{String(totalAmount)}</Text>
                    </View>
                    <TouchableOpacity activeOpacity={1} onPress={this.props.onPress}>
                        <View style={styles.submitBtn}>
                            <Image resizeMode={'stretch'}
                                   source={require('../../../foundation/Img/order/icon_orderconfirm_topbar_.png')}
                                   style={styles.btnBgImg}/>
                            <View style={styles.bgView}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.submitTitle}> 提交订单 </Text>
                                <View style={styles.descTitle}>
                                    <Image style={styles.descImage}
                                           source={require('../../../foundation/Img/order/order_confirm_desc_img.png')}
                                    />
                                    <Text allowFontScaling={false} style={styles.descText}>我已阅读并接受东方购物退换货条款</Text>
                                </View>
                            </View>

                        </View>
                    </TouchableOpacity>
                </View>
            </View>
        );
    }
}
const styles=StyleSheet.create({
    containerView: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        height: ScreenUtils.scaleSize(148),
    },
    addressView: {
        height: ScreenUtils.scaleSize(60),
        backgroundColor: Colors.background_light_orange,
        justifyContent: 'center'
    },
    addressTitle: {
        marginLeft: ScreenUtils.scaleSize(30),
        fontSize: ScreenUtils.scaleSize(24),
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(60)
    },
    submitView: {
        flex: 1,
        flexDirection: 'row',
    },
    amount: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
    },
    amountTitle: {
        marginLeft: ScreenUtils.scaleSize(30),
    },
    RMBIcon: {
        marginLeft: ScreenUtils.scaleSize(6),
        width: ScreenUtils.scaleSize(14),
        height: ScreenUtils.scaleSize(22),
        marginTop: ScreenUtils.scaleSize(0),
        color: Colors.text_orange,
        fontSize: ScreenUtils.scaleSize(22),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    amountPrice: {
        marginLeft: ScreenUtils.scaleSize(6),
        color: Colors.text_orange,
        fontSize: ScreenUtils.scaleSize(28),
        marginLeft: ScreenUtils.scaleSize(4),
    },
    submitBtn: {
        width: ScreenUtils.scaleSize(375),
    },
    btnBgImg: {
        width: ScreenUtils.scaleSize(375),
        height: ScreenUtils.scaleSize(88),
    },
    submitTitle: {
        marginTop: ScreenUtils.scaleSize(10),
        fontSize: ScreenUtils.scaleSize(30),
        backgroundColor: 'transparent',
        color: Colors.text_white,
    },
    bgView: {
        position: 'absolute',
        alignItems: 'center',
        justifyContent: 'center',
        flex: 1,
    },
    descTitle: {
        width: ScreenUtils.scaleSize(375),
        backgroundColor: 'transparent',
        marginTop: ScreenUtils.scaleSize(6),
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row'
    },
    descImage: {
        width: ScreenUtils.scaleSize(20),
        height: ScreenUtils.scaleSize(20),
    },
    descText: {
        marginLeft: ScreenUtils.scaleSize(8),
        fontSize: ScreenUtils.scaleSize(18),
        color: Colors.text_white,
    }

});