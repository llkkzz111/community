/**
 * Created by MASTERMIAO on 2017/6/18.
 * 商城全部宝贝组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    TouchableOpacity,
    StyleSheet,
    Dimensions,
    FlatList
} from 'react-native';

const { width, height } = Dimensions.get('window');

import Colors from '../../app/config/colors';

import Fonts from '../../app/config/fonts';

import * as ScreenUtils from '../utils/ScreenUtil';

import Immutable from 'immutable';

import Toast, {DURATION} from 'react-native-easy-toast';

import GoodRecommondItem from '../../app/components/homepage/store/GoodRecommondItem';

export default class AllBaby extends React.PureComponent {
    constructor() {
        super();
        this.state = {
            babyData: [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}],
            selectedFilterIndex: 0,
            filter: 'comprehensive',
            pageNum: 1,
            pageSize: 2,
            totalPage: -1
        }
        this._renderItem = this._renderItem.bind(this);
        this._onRefresh = this._onRefresh.bind(this);
        this._filter = this._filter.bind(this);
        this._selectedIndex = this._selectedIndex.bind(this);
        this._loadMore = this._loadMore.bind(this);
        this._doPostMore = this._doPostMore.bind(this);
    }

    render() {
        return (
            <View style={styles.bgView}>
                <View style={styles.filterLineStyle}>
                    {['综合', '销量', '新品', '价格'].map((it, index) => {
                        return (
                            <TouchableOpacity activeOpacity={1} key={index} style={styles.filterBgStyle} onPress={() => {this._selectedIndex(index)}}>
                                <Text allowFontScaling={false} style={this.state.selectedFilterIndex == index ? styles.filterStyleOn : styles.filterStyle}>{it}</Text>
                            </TouchableOpacity>
                        )
                    })}
                </View>
                <FlatList
                    style={styles.flatList}
                    data={this.state.babyData}
                    renderItem={this._renderItem}
                    extraData={this.state}
                    onRefresh={this._onRefresh}
                    refreshing={false}
                    numColumns={2}
                    overScrollMode={'never'}
                    showsHorizontalScrollIndicator={false}
                    horizontal={false}
                    onEndReachedThreshold={0.1}
                    onEndReached={this._loadMore}
                    />
                <Toast ref="toast" position='center' />
            </View>
        );
    }

    _renderItem(item, setionId, rowId) {
        let object = Immutable.fromJS(item);
        return (
            <GoodRecommondItem
                key={rowId}
                isStore={true}
                title={'马克库班 2017 夏季新款 劲爆来袭'}
                icon={{uri: 'http://cdnimg.ocj.com.cn/item_images/item/15/17/1967/15171967L.jpg'}}
                price={602}
                oldPrice={699}
                sellCount={'主播推荐'}
                sellDesc={'库存紧张'}
                integral={300}
                gifts={true}
                />
        );
    }

    _onRefresh() {
        // console.log('正在刷新数据......')
    }

    _selectedIndex(index) {
        this.setState({selectedFilterIndex: index});
        this._filter();
    }

    _filter() {

    }

    _loadMore() {
        // console.log('加载更多数据')

    }

    _doPostMore() {

    }
}

const styles = StyleSheet.create({
    bgView: {
        flexDirection: 'column'
    },
    filterLineStyle: {
        flexDirection: 'row',
        width: width,
        height: ScreenUtils.scaleSize(72),
        backgroundColor: 'white'
    },
    filterStyleOn: {
        color: Colors.text_orange,
        fontSize: Fonts.secondary_font()
    },
    filterStyle: {
        color: Colors.text_dark_grey,
        fontSize: Fonts.secondary_font()
    },
    filterBgStyle: {
        alignItems: 'center',
        justifyContent: 'center',
        width: width / 4,
        height: ScreenUtils.scaleSize(72)
    },
    flatList: {
        height: height - ScreenUtils.scaleSize(432)
    }
});

AllBaby.propTypes = {

}