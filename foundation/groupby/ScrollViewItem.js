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
import {Actions} from 'react-native-router-flux';
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
import NewProduct  from './NewProductItem';
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
export default class ScrollViewItem extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
    }

    render(){
        return (
            <View style={styles.ScrollViewItem}>
                <FlatList
                    keyExtractor={this._keyExtractor}
                    horizontal={true}
                    data={this.props.dataSource}
                    renderItem={({item}) => this._scrollListItem(item)}
                    ListFooterComponent={() => this._ListFooterComponent()}
                />
            </View>
        )
    }

    _keyExtractor = (item, index) => index;

    /**
     * 渲染 U
     * @param item
     * @returns {XML}
     * @private
     */
    _scrollListItem(item){
        let img = item.firstImgUrl?item.firstImgUrl:"";
        return(
                <TouchableOpacity
                    style={styles.timeLimitList}
                    activeOpacity={1}
                    onPress={()=>{
                        DataAnalyticsModule.trackEvent3(item.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                        this._productLink(item.contentCode);
                    }}
                >
                    <Image
                        style={styles.timeLimitListImg}
                        source={{uri:img}}
                    >
                        {this._renderDiscount(item)}
                    </Image>
                    <Text style={styles.timeLimitNmae} numberOfLines={1} allowFontScaling={false}>{item.title}</Text>
                    <View style={styles.timeLimitPrice}>
                        <Text style={styles.timeLimitPriceStyle} allowFontScaling={false}>
                            <Text style={styles.redColorFont} allowFontScaling={false}>￥</Text>
                            <Text style={[styles.redColorFont,styles.timeLimitSize]} allowFontScaling={false}>{item.salePrice}</Text>
                        </Text>
                        <Text style={styles.timeLimitOldPrice} allowFontScaling={false}>￥{item.originalPrice}</Text>
                    </View>
                    <Text style={styles.timeLimitSold} allowFontScaling={false}>{item.salesVolume} 件已售</Text>
                </TouchableOpacity>
        )
    }

    /**
     *  是否有折扣
     */
    _renderDiscount(item){
        if(item && Number(item.discount)){
            return(
                <View style={styles.discountStyle}>
                    <Text style={styles.discountNum} allowFontScaling={false}>
                        {item.discount}
                    <Text style={styles.discountNumStyle} allowFontScaling={false}>折</Text>
                    </Text>
                </View>
            )
        }else{
            return (<View/>);
        }
    }

    _productLink(item){
        Actions.GoodsDetailMain({'itemcode': item});
    }


    _ListFooterComponent() {
        if (this.props.dataSource[0] && this.props.dataSource[0].groupBuyType === 4) {
            return(
                <TouchableOpacity activeOpacity={1} onPress={() => this._seeMore()}>
                    <View style={{justifyContent:'center', alignItems: 'center'}}>
                        <View style={{marginTop: 40}}>
                            <Text style={{color: '#999999'}} allowFontScaling={false}>查</Text>
                            <Text style={{color: '#999999'}} allowFontScaling={false}>看</Text>
                            <Text style={{color: '#999999'}} allowFontScaling={false}>更</Text>
                            <Text style={{color: '#999999'}} allowFontScaling={false}>多</Text>
                        </View>
                    </View>
                </TouchableOpacity>
            )
        }else {
            return (<View/>);
        }
    }
    _seeMore() {
        Actions.GroupBuyDetails({id:this.props.dataSource[0].subtitle})
    }

}




const styles = StyleSheet.create({
    ScrollViewItem:{
        backgroundColor:Colors.text_white,
        paddingLeft:ScreenUtils.scaleSize(30),
        paddingRight:ScreenUtils.scaleSize(30),
    },
    timeLimitList:{
        paddingTop:ScreenUtils.scaleSize(30),
        paddingBottom:ScreenUtils.scaleSize(30),
        width:ScreenUtils.scaleSize(180),
        marginRight:ScreenUtils.scaleSize(40),
    },
    timeLimitListImg:{
        width:ScreenUtils.scaleSize(180),
        height:ScreenUtils.scaleSize(180),
    },
    timeLimitPrice:{
      //  flex:1,
        flexDirection:"row",
        alignItems:"flex-end",
        width:ScreenUtils.scaleSize(180),
    },
    timeLimitNmae:{
        color:Colors.text_black,
        fontSize:ScreenUtils.setSpText(28),
        paddingTop:ScreenUtils.scaleSize(15),
    },
    timeLimitPriceStyle:{
        flexDirection:"row",
        paddingTop:ScreenUtils.scaleSize(12),
    },
    redColorFont:{
        color:Colors.main_color,
    },
    timeLimitSize:{
        fontSize:ScreenUtils.setSpText(30),
    },
    timeLimitOldPrice:{
        color:Colors.text_light_grey,
        fontSize:ScreenUtils.setSpText(22),
        textDecorationLine:"line-through",
        marginLeft:ScreenUtils.scaleSize(8)
    },
    timeLimitSold:{
        color:"#151515",
        fontSize:ScreenUtils.setSpText(22),
        paddingTop:ScreenUtils.scaleSize(8),
    },
    discountStyle:{
        width:ScreenUtils.scaleSize(60),
        height:ScreenUtils.scaleSize(37),
        justifyContent:"center",
        alignItems:"center",
        backgroundColor:Colors.main_color,
    },
    discountStylePrice:{
        color:Colors.text_white,
        fontSize:ScreenUtils.setSpText(20)
    },
    discountNum:{
        fontSize:ScreenUtils.setSpText(26),
        color:Colors.text_white,
    },
    discountNumStyle:{
        fontSize:ScreenUtils.setSpText(16)
    }

})