/**
 * Created by Administrator on 2017/5/13.
 */
'use strict';

import React, {
    Component,
    PropTypes
} from 'react';

import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    Alert,
    Modal,
    FlatList,
    Platform,
    Dimensions,
    DeviceEventEmitter
} from 'react-native';
import GetBillDetailRequest from '../../foundation/net/mine/GetBillDetailRequest'
import {AndroidRouterModule}from '../../app/config/AndroidModules'
import {Actions} from 'react-native-router-flux';
import * as routeConfig from '../../app/config/routeConfig'
import RnConnect from '../../app/config/rnConnect';
import * as RouteManager from '../../app/config/PlatformRouteManager';
import CancelOtherOrder from '../../foundation/net/mine/CancelOtherOrder';
import CancelSubscribeOrder from '../../foundation/net/mine/CancelSubscribeOrder';
let {width} = Dimensions.get('window');
let alertMessage = '订单取消后将无法恢复，确定取消订单吗？'
let alertReson = '请选择取消订单的原因！'
export default class OderDetailFooter extends Component {
    constructor(props) {
        super(props);
        this.state = {
            modal: false,
            code: '',
            selectTab: 0,
        };
    }

    //取消订单成功后tiao
    componentWillUnmount() {
        // let dataMessage = this.state.Datas;
        // if (dataMessage === 200){
        //     Actions.OrderCenter();
        // }
    }

    render() {
        let {orderStatus} = this.props;
        // const {item} = {order_no:this.props.orderStatus.time.order_no,arrTorderitemlist:[{order_g_seq:this.props.orderStatus.time.items[0].order_g_seq}]};
        return (
            (orderStatus.type === '待支付') || (orderStatus.type === '未支付') ?
                <View style={styles.buttonStyleView}>
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => this.setState({
                            modal: true
                        })}
                    >
                        <Modal
                            animationType={'slide'}
                            transparent={true}
                            onRequestClose={() => console.log('onRequestClose...')}
                            visible={this.state.modal}
                        >
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => this.setState({
                                    modal: false
                                })}
                                style={{flex: 1}}
                            >
                                <View style={{
                                    flex: 1,
                                    backgroundColor: 'grey',
                                    opacity: 0.5,
                                    alignItems: 'center'
                                }}/>
                                <View style={{
                                    flex: 1,
                                    position: 'absolute',
                                    bottom: 0,
                                    width: width,
                                    backgroundColor: '#FFF',
                                    opacity: 1,
                                }}>
                                    <Text allowFontScaling={false} style={{
                                        textAlign: 'center',
                                        width: width,
                                        height: 50,
                                        marginTop: 20,
                                        fontSize: 18
                                    }}>请选择原因</Text>
                                    <View
                                        style={{backgroundColor: '#DDDDDD', width: width, height: 1, marginTop: -20}}/>
                                    <View>
                                        <FlatList
                                            data={[{key: '184', value: '现在不想购买'}, {key: '162', value: '等待时间过长'}, {
                                                key: '108',
                                                value: '支付不成功'
                                            },
                                                {key: '111', value: '更换或添加新商品'}, {key: '135', value: '分期付款审核未通过'}, {
                                                    key: '199',
                                                    value: '配送地址变更'
                                                }]}
                                            renderItem={({item}) => <TouchableOpacity
                                                activeOpacity={1}
                                                onPress={() => this.reasonBut(item.key)}>
                                                <View style={{flexDirection: 'row'}}>
                                                    <Text allowFontScaling={false}
                                                          style={styles.textCon}>{item.value}</Text>
                                                    <Image
                                                        style={{width: 20, height: 20, marginTop: 7, marginRight: 10}}
                                                        source={this.state.selectTab === item.key ? require('../Img/cart/selected.png') : require(
                                                            '../Img/cart/unselected.png')}/>
                                                </View>
                                            </TouchableOpacity>
                                            }
                                        />
                                    </View>
                                    {this.state.selectTab === 0 ?
                                        <TouchableOpacity
                                            activeOpacity={1}
                                            // onPress={this.cancelOrder}
                                            onPress={() => Alert.alert(
                                                '提示',
                                                alertReson,
                                                [
                                                    {text: '确定'},
                                                ]
                                            )}
                                        >
                                            <Image style={styles.btnImage}
                                                   source={require('../Img/home/globalshopping/icon_statusbg_@3x.png')}
                                                   resizeMode={'cover'}>
                                                <Text allowFontScaling={false} style={[styles.btnText, {
                                                    backgroundColor: 'transparent',
                                                    color: '#ffffff'
                                                }]}>确定</Text>
                                            </Image>
                                        </TouchableOpacity> :
                                        <TouchableOpacity
                                            activeOpacity={1}
                                            // onPress={this.cancelOrder}
                                            onPress={() => Alert.alert(
                                                '提示',
                                                alertMessage,
                                                [
                                                    {text: '取消'},
                                                    {text: '确定', onPress: () => this.cancelOrder()},
                                                ]
                                            )}
                                        >
                                            <Image style={styles.btnImage}
                                                   source={require('../Img/home/globalshopping/icon_statusbg_@3x.png')}
                                                   resizeMode={'cover'}>
                                                <Text allowFontScaling={false} style={[styles.btnText, {
                                                    backgroundColor: 'transparent',
                                                    color: '#ffffff'
                                                }]}>确定</Text>
                                            </Image>
                                        </TouchableOpacity>
                                    }
                                </View>
                            </TouchableOpacity>

                        </Modal>
                        < Text style={styles.buttonStyle} allowFontScaling={false}>取消订单</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                        onPress={this.immediatelyPay}
                    >
                        <Text allowFontScaling={false} style={styles.payButtonStyle}>立即付款</Text>
                    </TouchableOpacity>
                </View>
                :
                // orderStatus.type === '待评价'?
                orderStatus.type === '待评价' ?
                    <View style={styles.buttonStyleView}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                if (Platform.OS === 'ios') {
                                    Actions.BillListDetailPage({
                                        order_no: orderStatus.time.order_no,
                                        order_g_seq: orderStatus.time.items[0].order_g_seq
                                    });
                                } else {
                                    let self = this;
                                    //当请求之前存在的时候，取消之前请求
                                    if (this.GetBillDetailRequest) {
                                        this.GetBillDetailRequest.setCancled(true);
                                    }
                                    //创建一个请求，参数（请求参数、请求方法）
                                    this.GetBillDetailRequest = new GetBillDetailRequest({
                                        order_no: orderStatus.time.order_no,
                                        order_g_seq: orderStatus.time.items[0].order_g_seq
                                    }, 'GET');
                                    //显示一个进度条showLoadingView()，默认不显示
                                    //失败后显示后台message，setShowMessage(true) 默认不显示
                                    this.GetBillDetailRequest.showLoadingView().setShowMessage(true).start(
                                        (response) => {
                                            //接口请求成功
                                            // console.log(response);
                                            self.setState({
                                                BillDetailData: response.data,
                                            });
                                            if (response.data[0].rcpt_url !== undefined) {
                                                //Actions.VipPromotion({value: response.data[0].rcpt_url});
                                                AndroidRouterModule.startSystemBrowser(response.data[0].rcpt_url);
                                            }
                                        }, (erro) => {
                                            //接口请求失败
                                            // console.log(erro);
                                        });
                                }

                            }}
                        >
                            <Text allowFontScaling={false} style={styles.buttonStyle}>查看发票</Text>
                        </TouchableOpacity>

                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={this._logistics}
                        >
                            < Text style={styles.buttonStyle}>查看物流</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={this._goeValuate}
                        >
                            <Text allowFontScaling={false} style={styles.payButtonStyle}>去评价</Text>
                        </TouchableOpacity>

                    </View>
                    :
                    orderStatus.type === '已评价' ?
                        <View style={styles.buttonStyleView}>
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {
                                    if (Platform.OS === 'ios') {
                                        Actions.BillListDetailPage({
                                            order_no: orderStatus.time.order_no,
                                            order_g_seq: orderStatus.time.items[0].order_g_seq
                                        });
                                    } else {
                                        let self = this;
                                        //当请求之前存在的时候，取消之前请求
                                        if (this.GetBillDetailRequest) {
                                            this.GetBillDetailRequest.setCancled(true);
                                        }
                                        //创建一个请求，参数（请求参数、请求方法）
                                        this.GetBillDetailRequest = new GetBillDetailRequest({
                                            order_no: orderStatus.time.order_no,
                                            order_g_seq: orderStatus.time.items[0].order_g_seq
                                        }, 'GET');
                                        //显示一个进度条showLoadingView()，默认不显示
                                        //失败后显示后台message，setShowMessage(true) 默认不显示
                                        this.GetBillDetailRequest.showLoadingView().setShowMessage(true).start(
                                            (response) => {
                                                //接口请求成功
                                                // console.log(response);
                                                self.setState({
                                                    BillDetailData: response.data,
                                                });
                                                if (response.data[0].rcpt_url !== undefined) {
                                                    //Actions.VipPromotion({value: response.data[0].rcpt_url});
                                                    AndroidRouterModule.startSystemBrowser(response.data[0].rcpt_url);
                                                }
                                            }, (erro) => {
                                                //接口请求失败
                                                // console.log(erro);
                                            });
                                    }
                                }}
                            >
                                <Text allowFontScaling={false} style={styles.buttonStyle}>查看发票</Text>
                            </TouchableOpacity>

                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={this._logistics}
                            >
                                < Text style={styles.buttonStyle}>查看物流</Text>
                            </TouchableOpacity>
                        </View>
                        :
                        (orderStatus.type === '取消订单') || (orderStatus.type === '订单关闭') ||
                        (orderStatus.type === '取消订购') || (orderStatus.type === '交易关闭') ||
                        (orderStatus.type === '配送中') || (orderStatus.type === '已关闭') || (orderStatus.type === '订单取消')
                        ||(orderStatus.type === '准备配送中')||(orderStatus.type === '预约取消')|| (orderStatus.type === '配送完成') ||
                        (orderStatus.type === '退货中')||(orderStatus.type === '海关报关中')||(orderStatus.type === '安排取货')? null
                            :
                            (orderStatus.type === '预约接收') ?
                                <View style={styles.buttonStyleView}>
                                    <TouchableOpacity
                                        activeOpacity={1}
                                        onPress={() => this.setState({
                                            modal: true
                                        })}
                                    >
                                        <Modal
                                            animationType={'slide'}
                                            transparent={true}
                                            onRequestClose={() => console.log('onRequestClose...')}
                                            visible={this.state.modal}
                                        >
                                            <TouchableOpacity
                                                activeOpacity={1}
                                                onPress={() => this.setState({
                                                    modal: false
                                                })}
                                                style={{flex: 1}}
                                            >
                                                <View style={{
                                                    flex: 1,
                                                    backgroundColor: 'grey',
                                                    opacity: 0.5,
                                                    alignItems: 'center'
                                                }}/>
                                                <View style={{
                                                    flex: 1,
                                                    position: 'absolute',
                                                    bottom: 0,
                                                    width: width,
                                                    backgroundColor: '#FFF',
                                                    opacity: 1
                                                }}>
                                                    <Text allowFontScaling={false} style={{
                                                        textAlign: 'center',
                                                        width: width,
                                                        height: 50,
                                                        marginTop: 20,
                                                        fontSize: 18
                                                    }}>请选择原因</Text>
                                                    <View
                                                        style={{
                                                            backgroundColor: '#DDDDDD',
                                                            width: width,
                                                            height: 1,
                                                            marginTop: -20
                                                        }}/>
                                                    <View style={{height: 320}}>
                                                        <FlatList
                                                            data={[{key: '184', value: '现在不想购买'}, {
                                                                key: '162',
                                                                value: '等待时间过长'
                                                            }, {
                                                                key: '108',
                                                                value: '支付不成功'
                                                            },
                                                                {key: '111', value: '更换或添加新商品'}, {
                                                                    key: '135',
                                                                    value: '分期付款审核未通过'
                                                                }, {
                                                                    key: '199',
                                                                    value: '配送地址变更'
                                                                }]}
                                                            renderItem={({item}) => <TouchableOpacity
                                                                activeOpacity={1}
                                                                onPress={() => this.reasonBut(item.key)}>
                                                                <View style={{flexDirection: 'row'}}>
                                                                    <Text allowFontScaling={false}
                                                                          style={styles.textCon}>{item.value}</Text>
                                                                    <Image
                                                                        style={{
                                                                            width: 20,
                                                                            height: 20,
                                                                            marginTop: 7,
                                                                            marginRight: 10
                                                                        }}
                                                                        source={this.state.selectTab === item.key ? require('../Img/cart/selected.png') : require(
                                                                            '../Img/cart/unselected.png')}/>
                                                                </View>
                                                            </TouchableOpacity>
                                                            }
                                                        />
                                                    </View>
                                                    {this.state.selectTab === 0 ? <TouchableOpacity
                                                        activeOpacity={1}
                                                        // onPress={this.cancelOrder}
                                                        onPress={() => Alert.alert(
                                                            '提示',
                                                            alertReson,
                                                            [
                                                                {text: '确定'},
                                                            ]
                                                        )}
                                                    >
                                                        <Image style={styles.btnImage}
                                                               source={require('../Img/home/globalshopping/icon_statusbg_@3x.png')}
                                                               resizeMode={'cover'}>
                                                            <Text allowFontScaling={false} style={[styles.btnText, {
                                                                backgroundColor: 'transparent',
                                                                color: '#ffffff'
                                                            }]}>确定</Text>
                                                        </Image>
                                                    </TouchableOpacity> :
                                                        <TouchableOpacity
                                                            activeOpacity={1}
                                                            // onPress={this.cancelOrder}
                                                            onPress={() => Alert.alert(
                                                                '提示',
                                                                alertMessage,
                                                                [
                                                                    {text: '取消'},
                                                                    {
                                                                        text: '确定',
                                                                        onPress: () => this.cancelSubscribeOrder()
                                                                    },
                                                                ]
                                                            )}
                                                        >
                                                            <Image style={styles.btnImage}
                                                                   source={require('../Img/home/globalshopping/icon_statusbg_@3x.png')}
                                                                   resizeMode={'cover'}>
                                                                <Text allowFontScaling={false} style={[styles.btnText, {
                                                                    backgroundColor: 'transparent',
                                                                    color: '#ffffff'
                                                                }]}>确定</Text>
                                                            </Image>
                                                        </TouchableOpacity>}
                                                </View>
                                            </TouchableOpacity>

                                        </Modal>
                                        <Text allowFontScaling={false} style={styles.buttonStyle}>取消订单</Text>
                                    </TouchableOpacity>
                                </View>
                                :
                                (orderStatus.type === '订购完成') ?
                                    <View style={styles.buttonStyleView}>
                                        <TouchableOpacity
                                            activeOpacity={1}
                                            onPress={() => this.setState({
                                                modal: true
                                            })}
                                        >
                                            <Modal
                                                animationType={'slide'}
                                                transparent={true}
                                                onRequestClose={() => console.log('onRequestClose...')}
                                                visible={this.state.modal}
                                            >
                                                <TouchableOpacity
                                                    activeOpacity={1}
                                                    onPress={() => this.setState({
                                                        modal: false
                                                    })}
                                                    style={{flex: 1}}
                                                >
                                                    <View style={{
                                                        flex: 1,
                                                        backgroundColor: 'grey',
                                                        opacity: 0.5,
                                                        alignItems: 'center'
                                                    }}/>
                                                    <View style={{
                                                        flex: 1,
                                                        position: 'absolute',
                                                        bottom: 0,
                                                        width: width,
                                                        backgroundColor: '#FFF',
                                                        opacity: 1
                                                    }}>
                                                        <Text allowFontScaling={false} style={{
                                                            textAlign: 'center',
                                                            width: width,
                                                            height: 50,
                                                            marginTop: 20,
                                                            fontSize: 18
                                                        }}>请选择原因</Text>
                                                        <View
                                                            style={{
                                                                backgroundColor: '#DDDDDD',
                                                                width: width,
                                                                height: 1,
                                                                marginTop: -20
                                                            }}/>
                                                        <View style={{height: 320}}>
                                                            <FlatList
                                                                data={[{key: '184', value: '现在不想购买'}, {
                                                                    key: '162',
                                                                    value: '等待时间过长'
                                                                }, {
                                                                    key: '108',
                                                                    value: '支付不成功'
                                                                },
                                                                    {key: '111', value: '更换或添加新商品'}, {
                                                                        key: '135',
                                                                        value: '分期付款审核未通过'
                                                                    }, {
                                                                        key: '199',
                                                                        value: '配送地址变更'
                                                                    }]}
                                                                renderItem={({item}) => <TouchableOpacity
                                                                    activeOpacity={1}
                                                                    onPress={() => this.reasonBut(item.key)}>
                                                                    <View style={{flexDirection: 'row'}}>
                                                                        <Text allowFontScaling={false}
                                                                              style={styles.textCon}>{item.value}</Text>
                                                                        <Image
                                                                            style={{
                                                                                width: 20,
                                                                                height: 20,
                                                                                marginTop: 7,
                                                                                marginRight: 10
                                                                            }}
                                                                            source={this.state.selectTab === item.key ? require('../Img/cart/selected.png') : require(
                                                                                '../Img/cart/unselected.png')}/>
                                                                    </View>
                                                                </TouchableOpacity>
                                                                }
                                                            />
                                                        </View>
                                                        {this.state.selectTab === 0 ? <TouchableOpacity
                                                            activeOpacity={1}
                                                            // onPress={this.cancelOrder}
                                                            onPress={() => Alert.alert(
                                                                '提示',
                                                                alertReson,
                                                                [
                                                                    {text: '确定'},
                                                                ]
                                                            )}
                                                        >
                                                            <Image style={styles.btnImage}
                                                                   source={require('../Img/home/globalshopping/icon_statusbg_@3x.png')}
                                                                   resizeMode={'cover'}>
                                                                <Text allowFontScaling={false} style={[styles.btnText, {
                                                                    backgroundColor: 'transparent',
                                                                    color: '#ffffff'
                                                                }]}>确定</Text>
                                                            </Image>
                                                        </TouchableOpacity> :
                                                            <TouchableOpacity
                                                                activeOpacity={1}
                                                                // onPress={this.cancelOrder}
                                                                onPress={() => Alert.alert(
                                                                    '提示',
                                                                    alertMessage,
                                                                    [
                                                                        {text: '取消'},
                                                                        {
                                                                            text: '确定',
                                                                            onPress: () => this.cancelPayoverOrder()
                                                                        },
                                                                    ]
                                                                )}
                                                            >
                                                                <Image style={styles.btnImage}
                                                                       source={require('../Img/home/globalshopping/icon_statusbg_@3x.png')}
                                                                       resizeMode={'cover'}>
                                                                    <Text allowFontScaling={false}
                                                                          style={[styles.btnText, {
                                                                              backgroundColor: 'transparent',
                                                                              color: '#ffffff'
                                                                          }]}>确定</Text>
                                                                </Image>
                                                            </TouchableOpacity>}
                                                    </View>
                                                </TouchableOpacity>

                                            </Modal>
                                            <Text allowFontScaling={false} style={styles.buttonStyle}>取消订单</Text>
                                        </TouchableOpacity>
                                    </View>
                                    :
                                    <View style={styles.buttonStyleView}>
                                        <TouchableOpacity
                                            activeOpacity={1}
                                            onPress={() => this.setState({
                                                modal: true
                                            })}
                                        >
                                            <Modal
                                                animationType={'slide'}
                                                transparent={true}
                                                onRequestClose={() => console.log('onRequestClose...')}
                                                visible={this.state.modal}
                                            >
                                                <TouchableOpacity
                                                    activeOpacity={1}
                                                    onPress={() => this.setState({
                                                        modal: false
                                                    })}
                                                    style={{flex: 1}}
                                                >
                                                    <View style={{
                                                        flex: 1,
                                                        backgroundColor: 'grey',
                                                        opacity: 0.5,
                                                        alignItems: 'center'
                                                    }}/>
                                                    <View style={{
                                                        flex: 1,
                                                        position: 'absolute',
                                                        bottom: 0,
                                                        width: width,
                                                        backgroundColor: '#FFF',
                                                        opacity: 1
                                                    }}>
                                                        <Text allowFontScaling={false} style={{
                                                            textAlign: 'center',
                                                            width: width,
                                                            height: 50,
                                                            marginTop: 20,
                                                            fontSize: 18
                                                        }}>请选择原因</Text>
                                                        <View
                                                            style={{
                                                                backgroundColor: '#DDDDDD',
                                                                width: width,
                                                                height: 1,
                                                                marginTop: -20
                                                            }}/>
                                                        <View style={{height: 320}}>
                                                            <FlatList
                                                                data={[{key: '184', value: '现在不想购买'}, {
                                                                    key: '162',
                                                                    value: '等待时间过长'
                                                                }, {
                                                                    key: '108',
                                                                    value: '支付不成功'
                                                                },
                                                                    {key: '111', value: '更换或添加新商品'}, {
                                                                        key: '135',
                                                                        value: '分期付款审核未通过'
                                                                    }, {
                                                                        key: '199',
                                                                        value: '配送地址变更'
                                                                    }]}
                                                                renderItem={({item}) => <TouchableOpacity
                                                                    activeOpacity={1}
                                                                    onPress={() => this.reasonBut(item.key)}>
                                                                    <View style={{flexDirection: 'row'}}>
                                                                        <Text allowFontScaling={false}
                                                                              style={styles.textCon}>{item.value}</Text>
                                                                        <Image
                                                                            style={{
                                                                                width: 20,
                                                                                height: 20,
                                                                                marginTop: 7,
                                                                                marginRight: 10
                                                                            }}
                                                                            source={this.state.selectTab === item.key ? require('../Img/cart/selected.png') : require(
                                                                                '../Img/cart/unselected.png')}/>
                                                                    </View>
                                                                </TouchableOpacity>
                                                                }
                                                            />
                                                        </View>
                                                        {this.state.selectTab === 0 ? <TouchableOpacity
                                                            activeOpacity={1}
                                                            // onPress={this.cancelOrder}
                                                            onPress={() => Alert.alert(
                                                                '提示',
                                                                alertReson,
                                                                [
                                                                    {text: '确定'},
                                                                ]
                                                            )}
                                                        >
                                                            <Image style={styles.btnImage}
                                                                   source={require('../Img/home/globalshopping/icon_statusbg_@3x.png')}
                                                                   resizeMode={'cover'}>
                                                                <Text allowFontScaling={false} style={[styles.btnText, {
                                                                    backgroundColor: 'transparent',
                                                                    color: '#ffffff'
                                                                }]}>确定</Text>
                                                            </Image>
                                                        </TouchableOpacity> :
                                                            <TouchableOpacity
                                                                activeOpacity={1}
                                                                // onPress={this.cancelOrder}
                                                                onPress={() => Alert.alert(
                                                                    '提示',
                                                                    alertMessage,
                                                                    [
                                                                        {text: '取消'},
                                                                        {
                                                                            text: '确定',
                                                                            onPress: () => this.cancelOrder()
                                                                        },
                                                                    ]
                                                                )}
                                                            >
                                                                <Image style={styles.btnImage}
                                                                       source={require('../Img/home/globalshopping/icon_statusbg_@3x.png')}
                                                                       resizeMode={'cover'}>
                                                                    <Text allowFontScaling={false}
                                                                          style={[styles.btnText, {
                                                                              backgroundColor: 'transparent',
                                                                              color: '#ffffff'
                                                                          }]}>确定</Text>
                                                                </Image>
                                                            </TouchableOpacity>}
                                                    </View>
                                                </TouchableOpacity>

                                            </Modal>
                                            <Text allowFontScaling={false} style={styles.buttonStyle}>取消订单</Text>
                                        </TouchableOpacity>
                                    </View>
        );
    }

    // 取消其他订单
    cancelOrder = () => {
        this.setState({
            modal: false
        });
        let {orderStatus} = this.props;

        this.CancelOtherOrder = new CancelOtherOrder({
            order_no: orderStatus.time.order_no,
            cancel_code: this.state.selectTab
        }, 'POST');
        this.CancelOtherOrder.showLoadingView().setShowMessage(true).start(
            (response) => {
                if (response.code === '200' || response.code === 200) {
                    DeviceEventEmitter.emit('refreshOrderCenter', {orderType: this.props.orderType});
                    Actions.pop({refresh: ({actState: 'nopay'})})
                }
            }, (erro) => {
            });
    }
    // 取消订购完成的订单
    cancelPayoverOrder = () => {
        this.setState({
            modal: false
        });
        let {orderStatus} = this.props;

        this.CancelOtherOrder = new CancelOtherOrder({
            order_no: orderStatus.time.order_no,
            cancel_code: this.state.selectTab
        }, 'POST');
        this.CancelOtherOrder.showLoadingView().setShowMessage(true).start(
            (response) => {
                if (response.code === '200' || response.code === 200) {
                    DeviceEventEmitter.emit('refreshOrderCenter', {orderType: this.props.orderType});
                    Actions.pop({refresh: ({actState: 'payover'})})
                }
            }, (erro) => {
            });
    }
    //取消预约订单

    cancelSubscribeOrder = () => {
        let self = this;
        this.setState({
            modal: false
        })
        let {orderStatus} = this.props;
        this.CancelSubscribeOrder = new CancelSubscribeOrder({
            order_no: orderStatus.time.order_no,
            cancel_code: this.state.selectTab
        }, 'POST');
        this.CancelSubscribeOrder.showLoadingView().setShowMessage(true).start(
            (response) => {
                if (response.code === '200' || response.code === 200) {
                    DeviceEventEmitter.emit('refreshOrderCenter', {orderType: this.props.orderType});
                    Actions.pop({refresh: ({actState: 'preorder'})})
                }
            }, (erro) => {

            });
    }
    // 立即支付
    immediatelyPay = () => {
        // RnConnect.pushs({page: routeConfig.MePageocj_Pay, param: {orders: [this.props.orderStatus.time.order_no]}});
        RouteManager.routeJump({
            page: routeConfig.Pay,
            param: {orders: [this.props.orderStatus.time.order_no]}
        })
    }
    //查看物流
    _logistics = () => {
        let dataItem = {};
        dataItem.item = this.props.orderStatus.time;
        let _data = {data: dataItem, pageID: 'logistics'}
        // console.log(this.props.orderStatus);
        Actions.ViewLogistics({_data});
    }
    //去评价
    _goeValuate = () => {
        //  RnConnect.pushs({
        //      page: routeConfig.OrderCenterocj_Valuate,
        //      param: {orderNo: this.props.orderStatus.time.order_no, ordertype: this.props.orderStatus.Type}
        //  }, (events) => {
        //      alert(events)
        // });
        RouteManager.routeJump({
            page: routeConfig.Valuate,
            param: {orderNo: this.props.orderStatus.time.order_no, ordertype: this.props.orderStatus.Type}
        })
    }
    //选择原因
    reasonBut(i) {
        this.setState({
            selectTab: i
        })
    }
}

// OderDetailFooter.propTypes = {
//     orderStatus: PropTypes.number, //订单状态
//
// };
//
// OderDetailFooter.defaultProps = {
//     orderStatus: 1, //订单状态
// };

const styles = StyleSheet.create({
    buttonStyleView: {
        backgroundColor: '#FFFFFF',
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
        height: 50,
    },

    buttonStyle: {
        color: '#333333',
        paddingLeft: 5,
        paddingRight: 5,
        paddingTop: 3,
        paddingBottom: 3,
        borderColor: '#666666',
        borderWidth: 1,
        marginRight: 20,
        borderRadius: 4
    },
    payButtonStyle: {
        color: '#E5290D',
        paddingLeft: 5,
        paddingRight: 5,
        paddingTop: 3,
        paddingBottom: 3,
        borderColor: '#E5290D',
        borderWidth: 1,
        marginRight: 20,
        borderRadius: 3
    },
    modalViewStyle: {
        width: 300,
        height: 400
    },
    textCon: {
        flex: 1,
        height: 44,
        marginLeft: 10,
        marginTop: 10
    },
    textEnt: {
        height: 44,
        textAlign: 'center',
        color: '#FFFFFF',
        justifyContent: 'center',
        lineHeight: 30
    },
    textLine: {
        backgroundColor: '#DDDDDD',
        width: width - 20,
        height: 1,
        marginTop: -10,
        marginRight: 10,
        marginLeft: 10
    },
    btnImage: {
        height: 44,
        width: width,
        resizeMode: 'cover',
        justifyContent: 'center',
        alignItems: 'center'
    }
});