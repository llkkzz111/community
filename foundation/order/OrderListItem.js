/**
 * Created by Administrator on 2017/5/9.
 *
 *  author: lu weiguo  .
 *
 *  title : 订单中心  组件  .
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    StyleSheet,
    Dimensions,
    TouchableOpacity,
    Image,
    Platform,
    FlatList,
} from 'react-native';
import * as NativeRouter from'../../app/config/NativeRouter';
import {Actions} from 'react-native-router-flux';
import * as routeConfig from '../../app/config/routeConfig'
import RnConnect from '../../app/config/rnConnect';
import GetBillDetailRequest from '../../foundation/net/mine/GetBillDetailRequest'
import {AndroidRouterModule}from '../../app/config/AndroidModules'
import * as RouteManager from '../../app/config/PlatformRouteManager';
let width = Dimensions.get('window').width;

export default class OrderListItem extends React.Component {
    constructor() {
        super();
        this.state = {};
        this.logistics = this.logistics.bind(this);

    }

    // render UI 组件
    render() {
        let {dataItem} = this.props;
        return (
            <View style={styles.orderBox}>
                <View style={styles.orderHead}>
                    <View style={styles.orderStatus}>
                        <Text allowFontScaling={false} style={[styles.commonStyle, styles.orderLabel]}>订单编号</Text>
                        <Text allowFontScaling={false}
                              style={[styles.commonStyle, styles.orderNumber]}>{String(dataItem.item.order_no)}</Text>
                    </View>
                    <View>
                        <Text allowFontScaling={false}
                              style={styles.orderComon}>{dataItem.item.items[0].proc_state_str}</Text>
                    </View>
                </View>
                <View style={styles.orderBottom}>
                    {this.moreGoods(dataItem.item)}
                    <View style={styles.orderPrice}>
                        <Text allowFontScaling={false} style={{color: '#666666'}}>共计
                            <Text allowFontScaling={false}
                                  style={{color: '#666666'}}>{String(dataItem.item.order_qty)}</Text>件商品
                            <Text>  </Text>
                            <Text allowFontScaling={false}
                                  style={{color: '#666666'}}>运费:{String(dataItem.item.freight ? dataItem.item.freight : '0')}</Text>
                            <Text>  </Text>
                            {(dataItem.item.items[0].proc_state_str === '订单关闭') || (dataItem.item.items[0].proc_state_str === '待支付') ||
                            (dataItem.item.items[0].proc_state_str === '取消订单') || (dataItem.item.items[0].proc_state_str === '预约取消') ||
                            (dataItem.item.items[0].proc_state_str === '取消订购') ? '待支付：' : '实付：'}
                            <Text allowFontScaling={false}
                                  style={styles.priceSnum}>¥{String(dataItem.item.sum_amt)}</Text>
                        </Text>
                    </View>
                    {this.orderType(dataItem.item)}
                </View>
            </View>
        )
    }

    moreGoods(dataItem) {
        if (dataItem.items.length > 1) {
            return (
                <TouchableOpacity
                    activeOpacity={1}
                    onPress={this.goOrderDetail}
                >
                    <View style={styles.orderImg}>
                        <View style={styles.orderImgLft}>
                            <FlatList
                                data={dataItem.items}
                                renderItem={this._renderImg}
                                horizontal={true}
                            >
                            </FlatList>
                        </View>
                        <View style={styles.orderImgRight}>
                            <Text allowFontScaling={false} style={{color: '#666666'}}>共{String(dataItem.order_qty)}件></Text>
                        </View>
                    </View>
                </TouchableOpacity>
            )
        } else {
            return (
                <TouchableOpacity
                    activeOpacity={1}
                    onPress={this.goOrderDetail}
                >
                    <View style={styles.delivery}>
                        <View style={styles.deliveryLeft}>
                            <Image style={styles.goodsImgs}
                                   source={{uri: dataItem.items[0].contentImage}}/>
                        </View>
                        <View style={styles.deliveryRight}>
                            <Text allowFontScaling={false} style={styles.deliveryTitle}
                                  numberOfLines={2}>{dataItem.items[0].item_name}</Text>
                            <Text allowFontScaling={false} style={{
                                color: '#999999',
                                fontSize: 13,
                                marginTop: 10
                            }}>颜色分类：{dataItem.items[0].dt_info}</Text>
                            <View style={styles.deliveryPrice}>
                                <View style={styles.deliveryPriceLeft}>
                                    <Text allowFontScaling={false}
                                          style={{color: '#e5290d', marginTop: 6, fontSize: 12}}>￥</Text>
                                    <Text allowFontScaling={false}
                                          style={[styles.colorRed, styles.amountPrice]}>{String(dataItem.items[0].sale_price)}</Text>
                                    {(dataItem.items[0].save_amt && parseFloat(dataItem.items[0].save_amt) !== 0) ?
                                        <Image style={{marginTop: 4, marginLeft: 5, marginRight: 5}}
                                               source={require('../Img/home/Icon_accumulate_@2x.png')}/> : null}
                                    {dataItem.items[0].proc_state_str === '待评价' ?
                                        <Text allowFontScaling={false} style={{
                                            color: '#FF8400',
                                            fontSize: 14,
                                            marginTop: 3
                                        }}>{(dataItem.items[0].save_amt && parseFloat(dataItem.items[0].save_amt) !== 0) ? String(dataItem.items[0].save_amt) : ''}</Text>
                                        :
                                        <Text allowFontScaling={false} style={{
                                            color: '#FF8400',
                                            fontSize: 14,
                                            marginTop: 3
                                        }}>{(dataItem.items[0].save_amt && parseFloat(dataItem.items[0].save_amt) !== 0) ? String(dataItem.items[0].save_amt) : ''}</Text>}
                                </View>
                                <Text allowFontScaling={false} style={{color: '#333333'}}>{'x ' + String(dataItem.order_qty)}</Text>
                            </View>
                        </View>
                    </View>
                </TouchableOpacity>
            )
        }
    }


    // 判断当前状态，根据不同的状态显示不同的按钮
    orderType(dataItem) {
        if ((dataItem.items[0].proc_state_str === '待支付') || (dataItem.items[0].proc_state_str === '未支付')) {
            return (
                <View style={styles.payBottom}>
                    <View style={styles.orderPriceLeft}>
                        {/*<Text allowFontScaling={false} style={styles.restTime}>付款剩余时间：</Text>*/}
                        {/*<Text allowFontScaling={false} style={styles.countdown}>{dataItem.remainingTime.substr(0,2)}小时*/}
                        {/*{dataItem.remainingTime.substr(3,2)}分钟*/}
                        {/*</Text>*/}
                    </View>
                    <View style={styles.orderPriceRight}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={this.immediatelyPay}
                        >
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.paymentBottom]}>立即付款</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            )
        } else if ((dataItem.items[0].proc_state_str === '待发货') || (dataItem.items[0].proc_state_str === '取消订单')
            || (dataItem.items[0].proc_state_str === '订单关闭')) {
            return
        } else if (dataItem.items[0].proc_state_str === '配送中') {
            return (
                <View style={styles.payBottom}>
                    <View><Text allowFontScaling={false}></Text></View>
                    <View style={styles.orderPriceRight}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                this.logistics(dataItem)
                            }}
                        >
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.logisticsBottom]}>查看物流</Text>
                        </TouchableOpacity>
                        {/*<TouchableOpacity onPress={this.Enter}>*/}
                        {/*<Text allowFontScaling={false} style={[styles.btnCommonStyle, styles.paymentBottom]}>确认收货</Text>*/}
                        {/*</TouchableOpacity>*/}
                    </View>
                </View>
            )
        }
        else if ((dataItem.items[0].proc_state_str === '配送完成') || (dataItem.items[0].proc_state_str === '待评价')) {
            return (
                <View style={styles.payBottom}>
                    <View><Text allowFontScaling={false}/></View>
                    <View style={styles.orderPriceRight}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                if (Platform.OS === 'ios') {
                                    Actions.BillListDetailPage({order_no: dataItem.order_no, order_g_seq: '001'});
                                } else {
                                    let self = this;
                                    //当请求之前存在的时候，取消之前请求
                                    if (this.GetBillDetailRequest) {
                                        this.GetBillDetailRequest.setCancled(true);
                                    }
                                    //创建一个请求，参数（请求参数、请求方法）
                                    this.GetBillDetailRequest = new GetBillDetailRequest({
                                        order_no: dataItem.order_no,
                                        order_g_seq: '001'
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
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.logisticsBottom]}>查看发票</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                this.logistics()
                            }}
                        >
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.logisticsBottom]}>查看物流</Text>
                        </TouchableOpacity>
                        <TouchableOpacity activeOpacity={1} onPress={this.goeValuate}>
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.paymentBottom]}>去评价</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            )
        } else if ((dataItem.items[0].proc_state_str === '已评价')) {
            return (
                <View style={styles.payBottom}>
                    <View><Text allowFontScaling={false}></Text></View>
                    <View style={styles.orderPriceRight}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                if (Platform.OS === 'ios') {
                                    Actions.BillListDetailPage({order_no: dataItem.order_no, order_g_seq: '001'});
                                } else {
                                    let self = this;
                                    //当请求之前存在的时候，取消之前请求
                                    if (this.GetBillDetailRequest) {
                                        this.GetBillDetailRequest.setCancled(true);
                                    }
                                    //创建一个请求，参数（请求参数、请求方法）
                                    this.GetBillDetailRequest = new GetBillDetailRequest({
                                        order_no: dataItem.order_no,
                                        order_g_seq: '001'
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
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.logisticsBottom]}>查看发票</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                this.logistics(dataItem)
                            }}
                        >
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.logisticsBottom]}>查看物流</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            )
        } else if ((dataItem.items[0].proc_state_str === '退货申请') || (dataItem.items[0].proc_state_str === '退货完成') || (dataItem.items[0].proc_state_str === '退货中') ||
            (dataItem.items[0].proc_state_str === '交换申请') || (dataItem.items[0].proc_state_str === '交换完成') || (dataItem.items[0].proc_state_str === '交换中')) {
            return (
                <View style={styles.payBottom}>
                    <View><Text allowFontScaling={false}></Text></View>
                    <View style={styles.orderPriceRight}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={this.goExchangeDetail}
                        >
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.logisticsBottom]}>退换详情</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={this.goExchangeDetail}
                        >
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.paymentBottom]}>查看详情</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            )
        } else if ((dataItem.items[0].proc_state_str === '预约接收') || (dataItem.items[0].proc_state_str === '预约取消')) {
            // return (
            //     <View style={styles.payBottom}>
            //         <View><Text allowFontScaling={false}></Text></View>
            //         <View style={styles.orderPriceRight}>
            //             <TouchableOpacity
            //                 onPress={this.cancelOrder}
            //             >
            //                 <Text allowFontScaling={false} style={[styles.btnCommonStyle, styles.logisticsBottom]}>取消订单</Text>
            //             </TouchableOpacity>
            //             {/*<Text allowFontScaling={false} style={[styles.btnCommonStyle, styles.paymentBottom]}>货到后发货</Text>*/}
            //         </View>
            //     </View>
            // )
        }
        else {
            return (
                <View style={styles.payBottom}>
                    <View><Text allowFontScaling={false}></Text></View>
                    <View style={styles.orderPriceRight}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={this.goOrderDetail}
                        >
                            <Text allowFontScaling={false}
                                  style={[styles.btnCommonStyle, styles.paymentBottom]}>查看详情</Text>
                        </TouchableOpacity>
                        {/*<TouchableOpacity onPress={this.goeValuate}>*/}
                        {/*<Text allowFontScaling={false} style={[styles.btnCommonStyle, styles.paymentBottom]}>去评价</Text>*/}
                        {/*</TouchableOpacity>*/}
                    </View>

                </View>
            )
        }
    }

    // 进入订单详情页面
    goOrderDetail = () => {
        let {dataItem} = this.props;
        Actions.orderDetail({_data: dataItem, orderType: this.props.orderType});
    }

    // 渲染 多商品UI
    _renderImg(item, index) {
        if (item.index < 3) {
            return (
                <Image style={styles.imgStyles}
                       source={{uri: item.item.contentImage}}/>
            )
        }
    }

    //确认收货
    Enter = () => {
        return
    };
    // 查看物流详情
    logistics = () => {
        let _data = {data: this.props.dataItem, pageID: 'logistics'}
        Actions.ViewLogistics({_data});
    };
    // 查看退换货详情
    goExchangeDetail = () => {
        let _data = {data: this.props.dataItem, pageID: 'return'}
        Actions.ExchangeDetail({_data});
    };
    // 立即支付
    immediatelyPay = () => {
        // RnConnect.pushs({
        //     page: routeConfig.MePageocj_Pay, param: {orders: [this.props.dataItem.item.order_no]}
        // }, (event) => {
        //     NativeRouter.nativeRouter(event);
        // });
        RouteManager.routeJump({
            page: routeConfig.Pay,
            param: {orders: [this.props.dataItem.item.order_no]}
        })
    };
    //去评价
    goeValuate = () => {
        //  RnConnect.pushs({
        //      page: routeConfig.OrderCenterocj_Valuate,
        //      param: {orderNo: this.props.dataItem.item.order_no, ordertype: this.props.dataItem.item.items[0].order_type}
        //  }), (event) => {
        //      Actions.pop({refresh: ({actState: 'pingjia'})})
        //      // Actions.refresh(event)
        //  };
        RouteManager.routeJump({
            page: routeConfig.Valuate,
            param: {orderNo: this.props.dataItem.item.order_no, ordertype: this.props.dataItem.item.items[0].order_type}
        }, (event) => {
            Actions.pop({refresh: ({actState: 'pingjia'})})
            // Actions.refresh(event)
        })
    }
}
const styles = StyleSheet.create({
    orderCenter: {
        flex: 1,
        backgroundColor: '#ededed'
    },
    orderBox: {
        width: width,
        backgroundColor: "#FFFFFF",
        marginTop: 10
    },
    orderHead: {
        flexDirection: "row",
        paddingRight: 15,
        paddingLeft: 15,
        height: 45,
        alignItems: "center",
        justifyContent: "space-between",
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",

    },
    orderStatus: {
        flexDirection: "row",
    },
    commonStyle: {
        fontSize: 13,
        color: "#666666"
    },
    orderNumber: {
        marginLeft: 5
    },
    orderComon: {
        color: "#df2928",
        fontSize: 14,
    },
    orderBottom: {},
    orderImg: {
        width: width,
        flexDirection: "row",
        justifyContent: "space-between",
        padding: 15,
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",
    },
    orderImgLft: {
        flexDirection: "row",
    },
    imgStyles: {
        width: 80,
        height: 80,
        marginRight: 8,
        borderRadius: 4
    },
    orderImgRight: {
        width: 80,
        alignItems: "flex-end",
        justifyContent: "center"
    },
    orderPrice: {
        padding: 15,
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",
        alignItems: "flex-end",
    },
    priceSnum: {
        color: "#151515",
    },
    payBottom: {
        flexDirection: "row",
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",
        justifyContent: "space-between",
        height: 60,
        paddingLeft: 15,
        paddingRight: 15,
        alignItems: "center"
    },
    orderPriceLeft: {},
    orderPriceRight: {
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "center"
    },
    btnCommonStyle: {
        borderRadius: 4,
        borderWidth: 0.5,
        alignSelf: "center",
        paddingRight: 10,
        paddingLeft: 10,
        paddingTop: 5,
        paddingBottom: 5,
        marginLeft: 10
    },
    logisticsBottom: {
        color: "#333333",
        borderColor: "#999999",
    },
    paymentBottom: {
        color: "#e5290d",
        borderColor: "#e5290d",
    },
    restTime: {},
    countdown: {
        color: "#e5290d"
    },
    // 待发货
    delivery: {
        width: width,
        flexDirection: "row",
        padding: 15,
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",
    },
    deliveryLeft: {
        width: 80,
        height: 80
    },
    goodsImgs: {
        width: 75,
        height: 75,
    },
    deliveryRight: {
        justifyContent: "flex-start",
        marginLeft: 10,
        flex: 1,
    },
    deliveryTitle: {
        flexWrap: 'wrap',
        flex: 1,
        color: '#333333'
    },
    deliveryPrice: {
        flexDirection: "row",
        justifyContent: "space-between"
    },
    deliveryPriceLeft: {
        flexDirection: "row"
    },
    colorRed: {
        color: "#e5290d",
    },
    amountPrice: {
        fontSize: 16,
        marginTop: 1
    },
    integration: {
        fontSize: 10,
        backgroundColor: "#ffc033",
        color: "#FFF",
        height: 14,
        alignSelf: "center",
        paddingLeft: 2,
        paddingRight: 2,
        marginLeft: 4,
        marginRight: 3,
        borderRadius: 4,
    },
    payBottomRight: {
        flexDirection: "row",
        justifyContent: "flex-end"
    }
});
