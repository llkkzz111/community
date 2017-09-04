/**
 * Created by lume on 2017/6/5.
 */
/**
 * 今日团购页面 滚动列表组件
 *
 *
 */
'use strict';

import React, {
    PureComponent,
    PropTypes
} from 'react'

import {
    View,
    Text,
    Image,
    Dimensions,
    TouchableOpacity,
    ScrollView,
    StyleSheet,
    FlatList
} from 'react-native'
let deviceWidth = Dimensions.get('window').width;
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';

// 引入外部组件 商品标题
import ScrollViewHeader from './ScrollViewHeader';
// 引入外部组件 商品 Item
import ScrollViewItem from './ScrollViewItem';

export default class ScrollViewGoods extends PureComponent {

    constructor(props) {
        super(props);
    }

    render(){
        return (
            <View style={styles.ScrollViewBox}>
                {this._isPopularsData(this.props.popularGoods.length)}
                <ScrollViewItem
                    codeValue={this.props.codeValue}
                    pageVersionName={this.props.pageVersionName}
                    dataSource={this.props.popularGoods} />
            </View>
        )
    }

    _isPopularsData(index){
        if(index){
            return(
                <ScrollViewHeader
                    title="人气推荐"
                    listTitle="人气排行榜"
                    flag={0}
                    id={this.props.id}
                    singleProductitions={this.props.singleProductitions}
                />
            )
        }
    }

}

const styles = StyleSheet.create({
    ScrollViewBox:{
        marginTop:ScreenUtils.scaleSize(20),
        marginBottom:ScreenUtils.scaleSize(20),
    }
})