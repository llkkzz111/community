/**
 * Created by jzz on 2017/6/11.

 * 支付方式
 */

import React from 'react';
import {Actions}from 'react-native-router-flux';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableWithoutFeedback,
    DeviceEventEmitter,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import {DataAnalyticsModule} from '../../config/AndroidModules';

export default class OrderPayMethod extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            payMethod: [], // 支付方式的数组
            refresh: false
        };
        // 初始化订单
        this._resolveOrder();
    }

    componentWillMount() {
        DeviceEventEmitter.addListener('REQUEST_CHANGE_ADDRESS', () => this._resolveOrder('notify'));
        DeviceEventEmitter.addListener('FRESH_ORDERPAY', () => this.freshOrder());
    }

    componentWillUnmount() {
        DeviceEventEmitter.removeListener('FRESH_ORDERPAY');
        DeviceEventEmitter.removeListener('REQUEST_CHANGE_ADDRESS');
    }

    render() {
        let {payMethod} = this.state;
        let canUsePayStyle = '';
        let selectPatStyle = '';
        let onlineStyle = styles.noSelectBorderColor;
        let offlineStyle = styles.noSelectBorderColor;
        let onlineTextColor = styles.noSelectColor;
        let offlineTextColor = styles.noSelectColor;
        if (payMethod.length > 0) {
            canUsePayStyle = payMethod[0].canUsePayStyle;
            selectPatStyle = payMethod[0].selectPayStyle;
            onlineStyle = styles.noSelectBorderColor;
            offlineStyle = styles.noSelectBorderColor;
            onlineTextColor = styles.noSelectColor;
            offlineTextColor = styles.noSelectColor;
            if (canUsePayStyle === '0') {//在线支付可选
                onlineStyle = styles.selectBorderColor;
                offlineStyle = styles.noSelectBorderColor;
                onlineTextColor = styles.selectColor;
                offlineTextColor = styles.noSelectColor;
            } else if (canUsePayStyle === '1') {//货到
                onlineStyle = styles.noSelectBorderColor;
                offlineStyle = styles.selectBorderColor;
                onlineTextColor = styles.noSelectColor;
                offlineTextColor = styles.selectColor;
            } else {//两个都可以
                onlineStyle = styles.normalBorderColor;
                offlineStyle = styles.normalBorderColor;
                if (selectPatStyle === '0') {
                    onlineStyle = styles.selectBorderColor;
                    onlineTextColor = styles.selectColor;
                    offlineTextColor = styles.normalColor;
                } else {
                    offlineStyle = styles.selectBorderColor;
                    offlineTextColor = styles.selectColor;
                    onlineTextColor = styles.normalColor;
                }
            }
        }

        let online = ''
        let offline = ''
        for (let index in payMethod) {
            if (payMethod[index].selectPayStyle === '0') {
                online = '0'
            }
            if (payMethod[index].selectPayStyle === '1') {
                offline = '1'
            }
        }
        let payStyleString = ''
        if (online === '0' && offline === '1') {
            payStyleString = '在线支付 + 货到付款';
        }
        if (online === '0' && offline === '') {
            payStyleString = '在线支付';
        }
        if (online === '' && offline === '1') {
            payStyleString = '货到付款';
        }

        return (
            <View>
                {
                    payMethod.length <= 1
                        ?
                        <View style={styles.container}>
                            <Text
                                allowFontScaling={false}
                                style={styles.title}>支付方式</Text>
                            {
                                payMethod[0].selectPayStyle === '0' && this.props.onlinePayDown === true ?
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.cutDown}>在线支付优惠5元</Text>
                                    :
                                    null
                            }
                            {
                                canUsePayStyle !== '1' ?
                                <TouchableWithoutFeedback onPress={() => this._choosePayMethod('online', canUsePayStyle)}>
                                    <View style={[styles.descriptionBg, onlineStyle, {borderRadius: ScreenUtils.scaleSize(4)}]}>
                                        {
                                            payMethod[0].selectPayStyle === '0' ?
                                                <View style={{backgroundColor:'#FBE7EA',borderRadius: ScreenUtils.scaleSize(4), width: ScreenUtils.scaleSize(156), height: ScreenUtils.scaleSize(60),justifyContent:'center'}}>
                                                <Text
                                                    allowFontScaling={false}
                                                    style={[styles.description, onlineTextColor]}>在线支付</Text>
                                                <Image style={{
                                                    width: 15,
                                                    height: 15,
                                                    resizeMode: 'contain',
                                                    position: 'absolute',
                                                    right: 0,
                                                    bottom: 0
                                                }}
                                                    source={require('../../../foundation/Img/searchpage/Icon_label_@3x.png')}/>
                                                </View>
                                                :
                                                <Text
                                                    allowFontScaling={false}
                                                    style={[styles.description, onlineTextColor,{color: Colors.text_black}]}>在线支付</Text>
                                        }
                                    </View>
                                </TouchableWithoutFeedback>
                                    :
                                <View/>
                            }

                            {
                                canUsePayStyle !== '0' ?
                                    <TouchableWithoutFeedback onPress={() => this._choosePayMethod('offline', canUsePayStyle)}>
                                        <View style={[styles.descriptionBg, styles.marginLeft20, offlineStyle, {borderRadius: ScreenUtils.scaleSize(4)}]}>
                                            {
                                                payMethod[0].selectPayStyle === '1' ?
                                                    <View style={{backgroundColor:'#FBE7EA', borderRadius: ScreenUtils.scaleSize(4), width: ScreenUtils.scaleSize(156), height: ScreenUtils.scaleSize(60),justifyContent:'center'}}>
                                                        <Text
                                                            allowFontScaling={false}
                                                            style={[styles.description, offlineTextColor]}>货到付款</Text>
                                                        <Image style={{
                                                            width: 15,
                                                            height: 15,
                                                            resizeMode: 'contain',
                                                            position: 'absolute',
                                                            right: 0,
                                                            bottom: 0
                                                        }}
                                                               source={require('../../../foundation/Img/searchpage/Icon_label_@3x.png')}/>
                                                    </View>
                                                    :
                                                    <Text
                                                        allowFontScaling={false}
                                                        style={[styles.description, offlineTextColor,{color: Colors.text_black}]}>货到付款</Text>
                                            }
                                        </View>
                                    </TouchableWithoutFeedback>
                                    :
                                    <View/>
                            }

                        </View>
                        :
                        <TouchableWithoutFeedback onPress={() => this._chooseDistributionDate()}>
                            <View style={styles.container}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.title}>支付方式</Text>
                                <Text
                                    allowFontScaling={false}
                                    style={[styles.description]}>{payStyleString}</Text>
                                <Image style={styles.icon}
                                       source={require('../../../foundation/Img/home/store/icon_view_more_.png')}>
                                </Image>
                            </View>
                        </TouchableWithoutFeedback>
                }
            </View>
        );
    }

    freshOrder() {
        let dataArr = [];
        this.props.data.forEach((item, index) => {
            let pay = {};
            pay.canUsePayStyle = item.canUsePayStyle;
            pay.selectPayStyle = item.selectPayStyle;
            dataArr.push(pay);
        });
        this.setState({
            payMethod: dataArr
        })
    }

    /**
     * 选择支付方式 单笔订单的
     * @private
     */
    _choosePayMethod(style, canUsePayStyle) {
        if (style === 'online' && canUsePayStyle !== '1') {
            this.props.data[0].selectPayStyle = '0';
            let payStyle = this.state.payMethod;
            payStyle[0].selectPayStyle = '0';
            this.setState({
                payMethod: payStyle
            });
            DataAnalyticsModule.trackEvent2("AP1706C016F005001K001001", "");
        }
        if (style === 'offline' && canUsePayStyle !== '0') {
            this.props.data[0].selectPayStyle = '1';
            let payStyle = this.state.payMethod;
            payStyle[0].selectPayStyle = '1'
            this.setState({
                payMethod: payStyle
            })
            DataAnalyticsModule.trackEvent2("AP1706C016F005001K001002", "");
        }
    }

    /**
     * 进入选择支付方式详情页
     * @private
     */
    _chooseDistributionDate() {
        Actions.OrderPayStyle({data: this.props.data})
    }

    /**
     * 初始化订单数据 支付方式
     * onlinePay 0 在线支付
     * payOnDelivery 1 货到付款
     * all 2 都支持
     * notify  是为了防止从构造方法调用的时候setState
     * @private
     */
    _resolveOrder(notify) {
        if (this.props.data) {
            this.state.payMethod = [];
            this.props.data.forEach((item, index) => {
                let pay = {};
                let payStyle = item.payStyle;
                let canUsePayStyle = '';     // 可以用的支付方式
                let selectPayStyle = '';    // 当前选中的支付方式
                //如果是任意配送时间
                if (payStyle === 'onlinePay') {
                    canUsePayStyle = '0';
                    selectPayStyle = '0';
                } else if (payStyle === 'payOnDelivery') {
                    canUsePayStyle = '1';
                    selectPayStyle = '1';
                } else if (payStyle === 'all') {
                    canUsePayStyle = '2';
                    selectPayStyle = '0';
                }
                item.canUsePayStyle = canUsePayStyle;
                item.selectPayStyle = selectPayStyle;
                pay.canUsePayStyle = canUsePayStyle;
                pay.selectPayStyle = selectPayStyle;
                this.state.payMethod.push(pay);
            });
        }
        if (notify) {
            this.setState({
                refresh: !this.state.refresh
            })
        }
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        height: ScreenUtils.scaleSize(88),
        paddingHorizontal: ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(20),
        flexDirection: 'row',
        alignItems: 'center',
    },
    title: {
        flex: 1,
        fontSize: ScreenUtils.scaleSize(30),
        color: Colors.text_black,
    },
    descriptionBg: {
        marginLeft: ScreenUtils.scaleSize(10),
        width: ScreenUtils.scaleSize(158),
        height: ScreenUtils.scaleSize(60),
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: ScreenUtils.scaleSize(4),
       // borderWidth: ScreenUtils.scaleSize(1),
        backgroundColor:Colors.background_grey
    },
    description1: {
        marginLeft: ScreenUtils.scaleSize(10),
        width: ScreenUtils.scaleSize(158),
        height: ScreenUtils.scaleSize(40),
        alignItems: 'center',
        justifyContent: 'center',
        flex: 1
    },
    description: {
        fontSize: ScreenUtils.scaleSize(24),
        color: Colors.text_dark_grey,
        textAlign: 'center',
    },
    chooseDate: {
        marginLeft: ScreenUtils.scaleSize(6),
        fontSize: ScreenUtils.scaleSize(24),
        color: Colors.text_light_grey,
    },
    icon: {
        marginLeft: ScreenUtils.scaleSize(6),
        width: ScreenUtils.scaleSize(18),
        height: ScreenUtils.scaleSize(26),
    },
    selectColor: {
        borderColor: Colors.magenta,
    },
    selectColorText: {
        color: Colors.background_white,
        borderWidth: 0,
    },
    noSelect: {
        borderColor: Colors.text_light_grey,
    },
    normalColor: {
        color: Colors.text_light_grey,
    },
    selectColor: {
        color: Colors.magenta,
    },
    noSelectColor: {
        color: Colors.text_light_grey,
    },
    normalBorderColor: {
        borderColor: Colors.text_light_grey,
    },
    selectBorderColor: {
        borderWidth: 0,
        borderRadius: 0,
    },
    noSelectBorderColor: {
        backgroundColor: Colors.text_light_grey,
    },
    chooseImage: {
        position: 'absolute',
        width: ScreenUtils.scaleSize(156),
        height: ScreenUtils.scaleSize(40),
        left: 0,
        top: 0,
        resizeMode: 'stretch',
    },
    cutDown: {
        backgroundColor: '#FFF1F4',
        color: '#E5290D',
        fontSize: ScreenUtils.scaleSize(22),
        padding: ScreenUtils.scaleSize(6),
        borderRadius: ScreenUtils.scaleSize(6),
    }
});
