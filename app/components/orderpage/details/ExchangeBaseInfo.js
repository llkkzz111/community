/**
 * Created by zhenzhen on 2017/7/27.
 * 退换货详情下面的物品跟退款基本信息组件
 */
'use strict';
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Text,
    FlatList,
    TouchableOpacity
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import OrderLogisticsItem from '../OrderLogisticsItem';
import {Actions}from 'react-native-router-flux';
import GoodInfo from '../GoodInfo';
export default class ExchangeBaseInfo extends Component {
    static propTypes = {
        ...View.propTypes,
        title: PropTypes.string,
        goods: PropTypes.array,
        returnReason: PropTypes.string,
        returnAmount: PropTypes.string,
        applyDate: PropTypes.string,
        returnNo: PropTypes.string,
    }

    render() {
        return (
            <View style={[styles.container, this.props.style]}>
                <View style={styles.titleContainer}>
                    <Text style={styles.titleStyle} allowFontScaling={false}>{this.props.title}</Text>
                </View>
                {/*流程模块*/}
                {(this.props.goods && this.props.goods.length > 0) ? (
                    <View
                        style={styles.goodsContainer}
                    >
                        <FlatList
                            data={this.props.goods}
                            renderItem={({item, index}) => {
                                let icon = (item.contentImage && item.contentImage.length > 0) ? item.contentImage : '';
                                let title = item.item_name;
                                let color = item.dt_info;
                                let integral = '' + item.save_amt;
                                let count = '' + item.item_qty;
                                let price = '' + item.sale_price;
                                let coupous = [];//[{item_name: '赠品1'}, {item_name: '赠品2'}, {item_name: '赠品3'}, {item_name: '赠品4'}]
                                let otherDesc = [];//['11','11'],
                                let itemCode = item.item_code;
                                return (
                                    <TouchableOpacity
                                        onPress={() => {
                                            Actions.GoodsDetailMain({itemcode: itemCode});
                                        }}
                                        activeOpacity={0.8}
                                    >
                                        <GoodInfo
                                            key={index}
                                            style={styles.itemStyle}
                                            icon={{uri: icon}}
                                            title={title}
                                            color={color}
                                            integral={integral}
                                            count={count}
                                            price={price}
                                            onlyOne={false}
                                            coupous={coupous}
                                            otherDesc={otherDesc}
                                        />
                                    </TouchableOpacity>
                                );
                            }}
                            ItemSeparatorComponent={(item) => {
                                return (
                                    <View style={styles.lineStyle}/>
                                );
                            }}
                        />
                    </View>
                ) : null}
                <View style={styles.priceContainer}>
                    {(this.props.returnReason && this.props.returnReason.length > 0) ? (
                        this._renderItemText('退款原因：', this.props.returnReason)
                    ) : null}
                    {(this.props.returnAmount && this.props.returnAmount.length > 0) ? (
                        this._renderItemText('退款金额：', this.props.returnAmount)
                    ) : null}
                    {(this.props.applyDate && this.props.applyDate.length > 0) ? (
                        this._renderItemText('申请时间：', this.props.applyDate)
                    ) : null}
                    {(this.props.returnNo && this.props.returnNo.length > 0) ? (
                        this._renderItemText('退款编号：', this.props.returnNo)
                    ) : null}
                </View>
            </View>
        )
    }

    _renderItemText(leftText, rightText) {
        return (
            <View style={styles.itemInfoContainer}>
                <Text style={styles.leftTextStyle} allowFontScaling={false}>{leftText}</Text>
                <Text style={styles.rightTextStyle} allowFontScaling={false}>{rightText}</Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        marginTop: ScreenUtils.scaleSize(20),
    },
    titleContainer: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        alignItems: 'center',
        flexDirection: 'row',
        padding: ScreenUtils.scaleSize(30),
    },
    titleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(26)
    },
    itemStyle: {
        // marginTop: ScreenUtils.scaleSize(1),
    },
    goodsContainer: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        marginTop: ScreenUtils.scaleSize(1),
    },
    lineStyle: {
        backgroundColor: Colors.background_grey,
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(60),
        height: ScreenUtils.scaleSize(1),
        marginTop: ScreenUtils.scaleSize(10),
        alignSelf: 'center'
    },
    priceContainer: {
        width: ScreenUtils.screenW,
        padding: ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(1),
        backgroundColor: Colors.text_white,
        paddingVertical: ScreenUtils.scaleSize(20)
    },
    itemInfoContainer: {
        alignSelf: 'stretch',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingVertical: ScreenUtils.scaleSize(10),
        flexDirection: 'row'
    },
    leftTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(26),
    },
    rightTextStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.scaleSize(26),
    }
});