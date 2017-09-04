/**
 * Created by lu weiguo on 2017/6月4号.
 * 今日团购页面导航栏组件
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
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
import TimeLimitItem from './TimeLimitItem';

export default class NewProductItem extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
    }

    componentWillReceiveProps(nextPros) {
        this.setState({
            dataSource:nextPros.dataSource
        });
    }
    render(){
        let dataSource = this.props.dataSource?this.props.dataSource:"";
        let distance = (Number(this.props.dataSource.endDateLong) - Number(this.props.dataSource.curruntDateLong)) / 1000;//毫秒转秒
        return (
            <View style={styles.NewProductStyle}>
                <TouchableOpacity
                    activeOpacity={1}
                    style={styles.NewProductItem}
                    onPress={()=>{
                        DataAnalyticsModule.trackEvent3(dataSource.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                        this._newGoodsLink(dataSource.contentCode);
                    }}
                >
                    <View style={styles.NewProductBox}>
                        <Image
                            source={{uri:dataSource.firstImgUrl?dataSource.firstImgUrl:""}}
                            style={styles.NewProductItemImg}
                        />
                        {this._renderDiscount()}
                        <View style={styles.bottomLayer}></View>
                        <TimeLimitItem distance={distance}/>
                    </View>
                    <Text style={styles.NewProductName} numberOfLines={2} allowFontScaling={false}>
                        {dataSource?dataSource.title:""}
                    </Text>
                    <View style={styles.todayPriceBox}>
                        <View style={styles.todayPrice}>
                            <Text style={[styles.redColor,styles.priceSymbol]} allowFontScaling={false}>￥</Text>
                            <Text style={[styles.redColor,styles.currentPrice]} allowFontScaling={false}>{dataSource?dataSource.salePrice:""}</Text>
                            {this._renderIntegra()}
                        </View>
                        {this._renderGifts()}
                    </View>
                    <View style={styles.inventoryBox}>
                        <Text style={styles.inventoryNum} allowFontScaling={false}>{Number(dataSource.salesVolume)>0?dataSource.salesVolume + '人已购买':''}</Text>
                        {this._renderInventory(dataSource.isInStock)}
                    </View>
                </TouchableOpacity>
            </View>

        )
    }


    _newGoodsLink(item){
        Actions.GoodsDetailMain({'itemcode': item});
    }

    /**
     * 是否库存紧张
     */
    _renderInventory(isInStock){
        if( isInStock === 1 ){
            return(
                <Text style={styles.inventoryInfo} allowFontScaling={false}>库存紧张</Text>
            )
        }
    }

    /**
     * 是否有赠品
     */
    _renderGifts(){
        let dataSource = this.props.dataSource?this.props.dataSource:"";
        if(dataSource && dataSource.gifts && dataSource.gifts.length > 0){
            return(
                <Image
                    style={styles.donation}
                    source={require('../Img/groupbuy/Icon_gifts1_@3x.png')}
                />
            )
        }else{
            return  (<View/>);
        }
    }

    /**
     * 是否有积分
     */
        _renderIntegra(){
        let dataSource = this.props.dataSource?this.props.dataSource:"";
        if(dataSource && Number(dataSource.integral) !== 0 && dataSource.integral !== null){
            return(
                <View style={{flexDirection:"row"}}>
                    <Image
                        style={styles.accumulateIcon}
                        source={require('../Img/groupbuy/Icon_integral_@3x.png')}
                    />
                    <Text style={styles.accumulateNum} allowFontScaling={false}>{dataSource?dataSource.integral:""}</Text>
                </View>
            )
        }else{
            return  (<View/>);
        }
    }

    /**
     *  是否有折扣
     */
        _renderDiscount(){
        let dataSource = this.props.dataSource?this.props.dataSource:"";
        if(dataSource && dataSource.discount !== "0" && dataSource.discount !== 0 && dataSource.discount !== null){
            return(
                <View style={styles.discountStyle}>
                    <Text style={styles.discountNum} allowFontScaling={false}>
                        {dataSource?dataSource.discount:""}
                        <Text style={styles.discountNUmStyle} allowFontScaling={false}>折</Text>
                    </Text>
                </View>
            )
        }else{
            return (<View/>);
        }
    }
}


const styles = StyleSheet.create({

    NewProductStyle:{
        backgroundColor:Colors.text_white,
        borderTopColor:Colors.background_grey,
        borderTopWidth:1,
        flexDirection:"row",
        flexWrap:'wrap',

    },
    NewProductItem:{
        width:deviceWidth/2,
        padding:ScreenUtils.scaleSize(10),
        borderRightWidth:1,
        borderRightColor:Colors.background_grey,
    },
    NewProductBox:{
        flex:1,
        width:ScreenUtils.scaleSize(355),
        height:ScreenUtils.scaleSize(355),
    },
    NewProductItemImg:{
        width:ScreenUtils.scaleSize(355),
        height:ScreenUtils.scaleSize(355),
    },
    NewProductName:{
        fontSize:ScreenUtils.setSpText(26),
        color:Colors.text_black,
        paddingTop:ScreenUtils.scaleSize(5),
        paddingBottom:ScreenUtils.scaleSize(5),
        height:ScreenUtils.scaleSize(80)

    },
    discountStyle:{
        width:ScreenUtils.scaleSize(70),
        height:ScreenUtils.scaleSize(70),
        backgroundColor:Colors.main_color,
        justifyContent:"center",
        alignItems:"center",
        position:"absolute",
        top:0,
    },
    discountNum:{
        fontSize:ScreenUtils.setSpText(26),
        color:Colors.text_white,
    },
    discountNUmStyle:{
        fontSize:ScreenUtils.setSpText(20),
        color:Colors.text_white,
    },
    bottomLayer:{
        width:ScreenUtils.scaleSize(355),
        height:ScreenUtils.scaleSize(40),
        backgroundColor:Colors.main_color,
        opacity:0.6,
        justifyContent:"center",
        position:"absolute",
        bottom:0,
        zIndex:10
    },
    remainingTime:{
        height:ScreenUtils.scaleSize(40),
        flexDirection:"row",
        position:"absolute",
        bottom:0,
        alignItems:"center",
        zIndex:20,
        justifyContent:"center",
        left:0,
        right:0
    },
    countdown:{
        color:Colors.text_white,
        fontSize:ScreenUtils.setSpText(20),
        backgroundColor:"transparent",
    },


    donation:{
        width:ScreenUtils.scaleSize(44),
        height:ScreenUtils.scaleSize(30),
    },
    accumulateIcon:{
        width:ScreenUtils.scaleSize(30),
        height:ScreenUtils.scaleSize(30),
        marginLeft:ScreenUtils.scaleSize(10)
    },
    todayPriceBox:{
        justifyContent:"space-between",
        flexDirection:"row",
        alignItems:"center",
    },
    todayPrice:{
        flexDirection:"row",
        alignItems:"center",
        marginLeft:ScreenUtils.scaleSize(6)
    },
    redColor:{
        color:Colors.main_color
    },
    priceSymbol:{
        //    alignSelf:"flex-end"
        alignSelf:"center",
    },
    currentPrice:{
        fontSize:ScreenUtils.scaleSize(36),
        marginLeft:ScreenUtils.scaleSize(0)
    },
    accumulateNum:{
        marginLeft:ScreenUtils.scaleSize(6)
    },
    inventoryBox:{
        flexDirection:"row",
        justifyContent:"space-between",
        marginTop:ScreenUtils.scaleSize(5)
    },
    inventoryNum:{
        fontSize:ScreenUtils.setSpText(22),
        color:Colors.text_dark_grey
    },
    inventoryInfo:{
        fontSize:ScreenUtils.setSpText(22),
        color:Colors.magenta
    }

})