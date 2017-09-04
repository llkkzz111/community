/**
 * Created by YASIN on 2017/6/2.
 * 好货推荐
 */
import React, {Component,PropTypes}from 'react';
import {
    View,
    Image,
    TouchableOpacity,
    StyleSheet,
    FlatList
}from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import GoodRecommondItem from './GoodRecommondItem';
export default class GoodRecommondList extends Component{
    static propTypes={
        datas:PropTypes.array
    }
    render(){
        return(
           <View style={styles.container}>
               <FlatList
                   data={this.props.datas}
                   renderItem={({ item,index }) => (
                       <GoodRecommondItem
                           key={index}
                           title={item.title}
                           icon={{uri:item.firstImgUrl}}
                           price={item.salePrice}
                           oldPrice={item.originalPrice}
                           sellCount={item.salesVolume}
                       />
                   )}
                   numColumns={2}
                   overScrollMode={'never'}
                   showsHorizontalScrollIndicator={false}
               />
           </View>
        );
    }
}
const styles = StyleSheet.create({
    container:{
        width:ScreenUtils.screenW,
    }
});