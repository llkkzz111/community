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

export default class UltralowDiscount extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {

        };
    }

    componentWillReceiveProps(nextPros) {
        this.setState({
            dataSource:nextPros.dataSource,
            id:nextPros.id,
            singleProductitions:nextPros.singleProductitions
        });
    }
    render(){
        // console.log(this.props.dataSource);
        return (
            <View>
                {this._isLowDiscountData(this.props.dataSource.length)}
            </View>
        )
    }


    _isLowDiscountData(index){
        if( index != 0  ){
            return(
                <View style={styles.ScrollViewBox}>
                    <ScrollViewHeader
                        id={this.state.id}
                        singleProductitions={this.state.singleProductitions}
                        title="超低折扣"
                        listTitle="查看更多"
                        flag={1}
                    />
                    <ScrollViewItem dataSource={this.state.dataSource} />
                </View>
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