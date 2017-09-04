/**
 * Created by Administrator on 2017/5/13.
 */


import React, {Component} from 'react';
import {
    StyleSheet,
    Text,
    View,
    ListView,
    TouchableOpacity,
    Image,
    Alert,
    Linking
} from 'react-native';
import {Actions} from 'react-native-router-flux';
export default class OrderGoods extends Component {
    constructor(props) {
        super(props);
        this.state = {
            dataSource: this.props.dataSource,
        }
    }

    render() {
        let {orderStatus} = this.props;
        return (
            <View style={styles.HistoryStyle}>
                <View
                    style={{flexDirection: 'row', justifyContent: 'space-between', padding: 10, alignItems: 'center'}}>
                    <Text allowFontScaling={false} style={{color: '#666666'}}>订单编号：{orderStatus.time.order_no}</Text>
                </View>
                <ListView
                    dataSource={this.props.dataSource}
                    renderRow={(orderStatus) => this.renderRow(orderStatus)}
                >
                </ListView>
            </View>

        )
    }

    renderRow(items) {
        let butttons = null;
        if ((this.props.orderStatus.type === '待评价') || (this.props.orderStatus.type === '确认收货')) {
            butttons =
                <View style={{flexDirection: 'row', justifyContent: 'flex-start', paddingLeft: 10}}>
                    <TouchableOpacity
                        // onPress={this.salesReturn}
                        activeOpacity={1}
                        onPress={() => Alert.alert(
                            '提示',
                            '您确定拨打客服电话400-889-8000吗？',
                            [
                                {text: '取消'},
                                {
                                    text: '确定',
                                    onPress: () => Linking.openURL("tel:" + "4008898000").catch(err => {
                                    })
                                },
                            ]
                        )}
                    >
                        <Text allowFontScaling={false} style={{
                            marginRight: 10,
                            marginBottom: 10,
                            padding: 5,
                            borderWidth: 1,
                            borderColor: '#666666',
                            borderRadius: 3
                        }}>申请换货</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                        // onPress={this.salesExchange}
                        activeOpacity={1}
                        onPress={() => Alert.alert(
                            '提示',
                            '您确定拨打客服电话400-889-8000吗？',
                            [
                                {text: '取消'},
                                {
                                    text: '确定',
                                    onPress: () => Linking.openURL("tel:" + "4008898000").catch(err => {
                                    })
                                },
                            ]
                        )}
                    >
                        <Text allowFontScaling={false} style={{
                            marginBottom: 10,
                            padding: 5,
                            borderWidth: 1,
                            borderColor: '#666666',
                            borderRadius: 3
                        }}>申请退货</Text>
                    </TouchableOpacity>
                </View>
        }

        let viewer = <View />;
        if (items.saveamt) {
            viewer =
                <View style={{flexDirection: 'row', justifyContent: 'space-between', flex: 1}}>
                    <View style={{flexDirection: 'row'}}>
                        <Text allowFontScaling={false} style={styles.priceTextStyle}>￥ {String(items.rsale_amt)}</Text>
                        {(items.saveamt&&parseFloat(items.saveamt)!==0)?(
                            <Image style={{marginTop: 3, marginLeft: 5, marginRight: 5}}
                               source={require('../Img/home/Icon_accumulate_@2x.png')}/>
                        ):null}
                        {(items.saveamt&&parseFloat(items.saveamt)!==0)?(<Text allowFontScaling={false} style={styles.integralValueStyle}>{String(items.saveamt)} </Text>):null}
                    </View>
                    <View>
                        <Text allowFontScaling={false} style={styles.goodsCountStyle}>X{String(items.order_qty)} </Text>
                    </View>
                </View>
        } else {
            viewer =
                <View style={{flexDirection: 'row', justifyContent: 'space-between'}}>
                    <View>
                        <Text allowFontScaling={false} style={styles.priceTextStyle}>￥ {String(items.rsale_amt)}</Text>
                    </View>
                    <View>
                        <Text allowFontScaling={false} style={styles.goodsCountStyle}>X{String(items.order_qty)} </Text>
                    </View>
                </View>

        }

        return (
            <View style={styles.allDeatailView}>
                <TouchableOpacity activeOpacity={1} onPress={() =>
                    this.goShopDetail(items)
                }>
                    <View style={styles.footPointGoods}>
                        <View style={styles.imgStyle}>
                            <Image source={{uri: items.contentLink}} style={{height: 100, width: 100}}/>
                        </View>
                        <View style={styles.productNameViewStyle}>
                            <Text allowFontScaling={false} style={styles.productNameTextStyle} numberOfLines={2}>
                                {items.item_name}
                            </Text>
                            <Text allowFontScaling={false} style={styles.colorType}>颜色分类：{items.dt_info}</Text>
                            {viewer}
                        </View>
                    </View>
                </TouchableOpacity>
                {butttons}
            </View>
        );
    }

    //点击商品去商品详情页
    goShopDetail(items) {
        Actions.GoodsDetailMainFromOrder({itemcode: items.item_code})
    }

    // 申请换货
    salesReturn = () => {
        // Actions.ApplyExchangeGoods();
        // RnConnect.pushs({
        //     page: routeConfig.OrderDetailocj_Return,
        //     param: {
        //         items: this.props.orderStatus.time.items,
        //         orderNo: this.props.orderStatus.time.order_no,
        //         retExchYn: '2'
        //     }
        // }, (events) => {
        //     alert(events)
        // });

    };
    // 申请退货
    salesExchange = () => {
        // Actions.ApplyExchangeGoods();
        // RnConnect.pushs({
        //     page: routeConfig.OrderDetailocj_Exchange,
        //     param: {
        //         items: this.props.orderStatus.time.items,
        //         orderNo: this.props.orderStatus.time.order_no,
        //         retExchYn: '1'
        //     }
        // }, (events) => {
        //     alert(events)
        // });
    }

}
// OrderGoods.propTypes = {
//     orderStatus:PropTypes.number, //订单状态
//     orderNo: PropTypes.string, //订单编号
// };
//
// OrderGoods.defaultProps = {
//     orderStatus:0,
//     orderNo: '910276289393dc9008', //订单编号
// };


const styles = StyleSheet.create({
    HistoryStyle: {
        backgroundColor: "#FFFFFF",
    },
    allDeatailView: {
        borderTopWidth: 0.5,
        borderColor: '#DDDDDD',
    },
    footPointGoods: {
        flex: 1,
        padding: 10,
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        backgroundColor: '#FFFFFF'
    },
    orderTypeTextStyle: {
        color: '#DF2928',
    },
    imgStyle: {
        borderColor: "#eeeeee",
        borderWidth: 1
    },
    goodsInfor: {
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        marginLeft: 5,
    },
    productNameViewStyle: {
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'space-around',
        marginLeft: 5,
    },
    productNameTextStyle: {
        flexWrap: "wrap",
        color: '#333333',
    },
    priceViewStyle: {
        flex: 1,
        flexDirection: 'column',
        marginTop: 15
    },
    priceTextStyle: {
        color: '#E5290D',
        marginRight: 10,
        fontSize: 18
    },
    unPriceTextStyle: {
        textDecorationLine: "line-through",
        marginRight: 10,
    },
    integralStyle: {
        backgroundColor: '#FFC033',
        color: '#FEFEFE',
        marginRight: 5,
        paddingLeft: 3,
        marginTop: 3,
        paddingRight: 3,
        height: 16,
    },
    integralValueStyle: {
        color: '#FFC033',
        marginTop: 2
    },
    alreadyBuyViewStyle: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'flex-end',

    },
    cartViewStyle: {
        flex: 1,
        alignItems: 'flex-end',
    },
    colorType: {
        color: '#999999',
        marginTop: 15,
        marginBottom: 15,
    },
});