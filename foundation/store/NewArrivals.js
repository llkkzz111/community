/**
 * Created by MASTERMIAO on 2017/6/18.
 * 商城新品上架组件
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

export default class NewArrivals extends React.PureComponent {
    constructor() {
        super();
        this.state = {
            newArrivalData: [{}, {}, {}],
            selectedFilterIndex: 0,
            filter: 'comprehensive',
            pageNum: 1,
            pageSize: 2, // TODO ???
            totalPage: -1
        }
        this._onRefresh = this._onRefresh.bind(this);
        this._renderItem = this._renderItem.bind(this);
        this._loadMore = this._loadMore.bind(this);
        this._filter = this._filter.bind(this);
        this._doPostMore = this._doPostMore.bind(this);
    }

    render() {
        return (
            <View style={styles.bgView}>
                <View style={styles.filterLineStyle}>
                    {['综合', '销量', '新品', '价格'].map((it, index) => {
                        return (
                            <TouchableOpacity key={index} activeOpacity={1} style={styles.filterBgStyle} onPress={() => {this._selectedIndex(index)}}>
                                <Text allowFontScaling={false} style={this.state.selectedFilterIndex == index ? styles.filterStyleOn : styles.filterStyle}>{it}</Text>
                            </TouchableOpacity>
                        )
                    })}
                </View>
                <FlatList
                    style={styles.flatList}
                    data={this.state.newArrivalData}
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

    _onRefresh() {
        // console.log('正在刷新数据......')
    }

    _renderItem(item, sectionId, rowId) {
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
                gifts={false}
            />
        );
    }

    _selectedIndex(index) {
        this.setState({selectedFilterIndex: index});
        this._filter();
    }

    _filter() {

    }

    _loadMore() {
        // console.log('加载更多数据')
        if ((this.state.totalPage == -1 && this.state.newArrivalData.length >= this.state.pageSize)//第一次加载的时候，并且第一次数据>=pagesize
            || (this.state.totalPage > this.state.pageNum)//总页数大于当前页数
        ) {
            this.state.pageNum++;
            this._doPostMore();
        }
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

NewArrivals.propTypes = {

}