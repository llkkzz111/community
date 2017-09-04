/**
 * Created by YASIN on 2017/6/10.
 * 填写订单抵用券
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    DeviceEventEmitter,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import OrderTaxChoose from './OrderTaxChoose'
import OrderSingleCoupon from  './OrderSingleCoupon'
import {DataAnalyticsModule} from '../../config/AndroidModules';
export default class CouponList extends React.Component {
    static propTypes = {
        ...View.propTypes.style,
        orders: PropTypes.array,
    }
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            showDialog: false,
            message: '',
            isExchangeCouponUse: undefined
        };
        this.changeMessage('constructor');
    }

    componentWillMount() {
        DeviceEventEmitter.addListener('REFRESH_COUPON_MESSAGE', () => this.changeMessage())
    }

    componentWillUnmount() {
        DeviceEventEmitter.removeListener('REFRESH_COUPON_MESSAGE')
    }

    render() {
        const {message, isExchangeCouponUse} = this.state;
        //单商品还是多商品
        return (
            <View>
                <View style={[styles.container, this.props.style]}>
                    <Text
                        allowFontScaling={false}
                        style={styles.titleTextStyle}>使用抵用券</Text>
                    <View style={styles.descContainer}>
                        <View style={{flex: 1, alignItems: 'flex-end'}}>
                            <Text
                                allowFontScaling={false}
                                style={styles.descTextStyle} numberOfLines={1}>{this.state.message}</Text>
                        </View>
                        {
                            message === '暂无可用抵用券' && isExchangeCouponUse !== true ?
                                null
                                :
                                <TouchableOpacity style={styles.updateContainer} activeOpacity={1}
                                                  onPress={this._onUpdateClick.bind(this)}>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.updateDescStyle}>修改</Text>
                                    <Image
                                        style={styles.updateIconStyle}
                                        source={require('../../../foundation/Img/home/store/icon_view_more_.png')}
                                    />
                                </TouchableOpacity>
                        }
                    </View>
                </View>

                {/*判断是否是单商品，如果是单商品就显示CouponSingleModal，优惠券dialog*/}

                <OrderSingleCoupon data={this.props.orders}
                                   ref='OrderSingleCoupon'/>
                <OrderTaxChoose
                    ref='OrderTaxChoose'
                    data={this.props.orders}/>
            </View>
        );
    }

    /**
     * 点击
     * @private
     */
    _onUpdateClick() {
        //判断单商品跟多商品
        let isSingle = ( this.props.orders.length === 1 && this.props.orders[0].carts &&
        this.props.orders[0].carts.length == 1);
        let data = this.props.orders;
        let canUseCoupon = false;
        let couponList = [];
        let coupon_no_list = {}
        let isExchangeCouponUse = false;
        for (let index in data) {
            let tempData = data[index];
            if (tempData.isExchangeCouponUse && tempData.isExchangeCouponUse === 'YES') {
                isExchangeCouponUse = true
            }
            if (tempData.isCouponUsable === 'YES') {
                canUseCoupon = true;
            }
            if (tempData.isCouponUsable === 'YES' && tempData.couponList &&
                tempData.couponList.length > 0 && data[index].couponIndex &&
                Number(data[index].couponIndex) >= 0) {
                let couponNumber = data[index].couponList[Number(data[index].couponIndex)].coupon_no
                coupon_no_list[couponNumber] = couponNumber
                couponList.push(couponNumber)
            }
        }
        if (!isSingle) {
            if (canUseCoupon || isExchangeCouponUse) {
                if (canUseCoupon) {
                    DataAnalyticsModule.trackEvent3("AP1706C016D003001C003001", "", coupon_no_list);
                }
                this.refs.OrderTaxChoose.show();
            }
        } else {
            if (canUseCoupon || isExchangeCouponUse) {
                if (canUseCoupon && data && data[0] && Number(data[0].couponIndex) &&
                    data[0].couponList[Number(data[0].couponIndex)]) {
                    DataAnalyticsModule.trackEvent3("AP1706C016D003001C003001", "",
                        {'couponid': data[0].couponList[Number(data[0].couponIndex)].coupon_no});
                }
                this.refs.OrderSingleCoupon.show();
            }
        }
    }

    changeMessage(type) {
        let data = this.props.orders;
        let title = undefined
        let isExchangeCouponUse = undefined
        for (let index in data) {
            let tempData = data[index];
            if (tempData.isExchangeCouponUse && tempData.isExchangeCouponUse === 'YES') {
                isExchangeCouponUse = true
            }
            if (tempData.isCouponUsable === 'YES' && tempData.couponList && tempData.couponList.length > 0) {
                if (Number(tempData.couponIndex)) {
                    if (Number(tempData.couponIndex) >= 0) {
                        title = tempData.couponList[Number(tempData.couponIndex)].coupon_note
                    } else {
                        title = '暂未使用抵用券'
                    }
                } else {
                    title = tempData.couponList[0].coupon_note
                }
            }
        }
        if (!title) {
            title = '暂无可用抵用券';
        }
        if (type) {
            this.state.isExchangeCouponUse = isExchangeCouponUse
            this.state.message = title
        } else {
            this.setState({
                message: title,
                isExchangeCouponUse: isExchangeCouponUse
            })
        }
    }

    /**
     * 单商品提交优惠券信息
     * @private
     */
    _onSingleConfirm() {
        if (this.props.orders && this.props.orders.length > 0) {
            //是否使用抵用券
            let order = this.props.orders[0];
            let isUseConpon = order.isUseConpon;
            let message = '';
            if (isUseConpon) {
                if (order.couponList) {
                    order.couponList.forEach((coupon, index) => {
                        //该抵用券被选中
                        if (coupon.selected === '1') {
                            message = coupon.coupon_note;
                            return;
                        }
                    });
                }
            }
            this.setState({
                message: message
            });
        }
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        padding: ScreenUtils.scaleSize(30),
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.background_grey,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    titleTextStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28),
    },
    descContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        flex: 1,
        marginLeft: ScreenUtils.scaleSize(10)
    },
    descTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
    },
    updateContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        marginLeft: ScreenUtils.scaleSize(30)
    },
    updateDescStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
        marginRight: ScreenUtils.scaleSize(5)
    },
    updateIconStyle: {
        width: ScreenUtils.scaleSize(18),
        height: ScreenUtils.scaleSize(26)
    },
});