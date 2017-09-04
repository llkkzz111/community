/**
 * Created by YASIN on 2017/6/1.
 * 商城-热门商品listveiw
 */
'use strict';

import React from 'react';

import {
    View,
    FlatList
} from 'react-native';

import { Actions }from 'react-native-router-flux';

import HotGoodItem from './HotGoodItem';

import * as IsEmptyUtil from '../../../../foundation/utils/IsEmptyUtil';

import Toast, { DURATION } from 'react-native-easy-toast';

import {DataAnalyticsModule} from '../../../config/AndroidModules';

export default class HotGoodsList extends React.PureComponent {
    static propTypes = {
        datas: React.PropTypes.array
    };
    static defaultProps = {
        datas: []
    };

    render() {
        return (
            <View style={{flex: 1}}>
                <FlatList
                    horizontal={true}
                    data={this.props.datas}
                    renderItem={({ item, index }) => (
                            <HotGoodItem
                                key={index}
                                title={item.title}
                                icon={{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(item.firstImgUrl)) ? item.firstImgUrl : ''}}
                                price={item.salePrice}
                                onItemClick={()=> {
                                    DataAnalyticsModule.trackEvent3(item.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                                    if (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(item.contentCode)) {
                                        Actions.GoodsDetailMain({itemcode: item.contentCode});
                                    }
                                }}
                             />
                        )}
                    overScrollMode={'never'}
                    showsHorizontalScrollIndicator={false}
                />
                <Toast ref="toast" position='center' />
            </View>
        );
    }
}
