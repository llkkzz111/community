/**
 * Created by YASIN on 2017/6/1.
 * 商城优惠券list
 */
'use strict';

import React from 'react';

import {
    View,
    StyleSheet,
    FlatList
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import DiscountCouponItem from './DiscountCouponItem';
import {DataAnalyticsModule} from '../../../config/AndroidModules';

export default class DiscountCouponList extends React.PureComponent {
    static propTypes = {
        datas: React.PropTypes.array,
        updateCouponList: React.PropTypes.func,
        errorCallback: React.PropTypes.func
    }

    render() {
        return (
            <View style={styles.container}>
                <FlatList
                    horizontal={true}
                    data={this.props.datas}
                    renderItem={({item, index}) => {
                        let couponNo = item.destinationUrl;
                        return (
                            <DiscountCouponItem
                                key={index}
                                couponId={couponNo}
                                amount={item.title}
                                desc={item.subtitle}
                                name={item.couponTypeName}
                                isReceive={''+item.isReceive}
                                updateCouponList={() => {
                                    DataAnalyticsModule.trackEvent3(item.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                                    this.props.updateCouponList(index);
                                }}
                                errorCallback={(params) => {this.props.errorCallback(params)}}
                            />
                        )
                    }}
                    overScrollMode={'never'}
                    showsHorizontalScrollIndicator={false}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        paddingVertical: ScreenUtils.scaleSize(20),
        backgroundColor:Colors.text_white,
        paddingHorizontal:ScreenUtils.scaleSize(15)
    }
});