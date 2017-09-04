/**
 * Created by YASIN on 2017/5/26.
 */
import React, { PropTypes } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    Platform,
    FlatList
} from 'react-native';
import {Actions} from 'react-native-router-flux';
import * as ScreenUtils from '../utils/ScreenUtil';
// 引入提示信息
import ToastShow from '../../foundation/common/ToastShow';
// 请求加入购物车
import AddCartRequest from '../../foundation/net/GoodsDetails/AddCartRequest';

import Immutable from 'immutable'

let key = 0;
export default class FootItem extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state={
            footDatas:this.props.footDatas
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            footDatas:nextProps.footDatas
        });
    }

    shouldComponentUpdate(nextProps,nextState) {
        return !Immutable.is(this.props.footDatas,nextProps.footDatas);
    }

    render() {
        if(this.state.footDatas.length === 0 ) {
            return(
                <View style={styles.noPunStyle}>
                    <Text allowFontScaling={false} style={styles.spStyle}>您还没浏览过商品哦</Text>
                </View>
            )
        }else{
            return(
                this._renderEmpty(this.state.footDatas)
            );
        }

    }

    _renderEmpty(data){
            return(
                <FlatList
                    key={'++key'}
                    data={data}
                    renderItem={({item}) => this._footListItem(item)}
                />
            )
    }


    _footListItem(item){
        let img = item.itemImgUrl?item.itemImgUrl:"";
        return(
            <View style={{
                flexDirection:"row",
                backgroundColor: '#FFFFFF',
                paddingTop:ScreenUtils.scaleSize(30)
            }}>
                <TouchableOpacity
                    activeOpacity={1}
                    style={styles.footPointGoods}
                    onPress={()=>{this._productLink(item.itemCode)}}

                >
                    <Image
                        source={{ uri: img }}
                        style={styles.liuanImgs}
                    />

                    <View style={styles.goodsInfor}>
                        <View style={styles.prductNameViewStyle}>
                                    <View style={{flexDirection:'row',alignItems:"center"}}>
                                        <Text allowFontScaling={false} style={styles.prductNameTextStyle} numberOfLines={2}>
                                            {this._renderFlagImg(item)}
                                            {item.itemName}
                                        </Text>
                                    </View>

                            {
                                item.giftitemtitle !=="" &&
                                item.giftitemtitle !==null &&
                                item.giftitemtitle !==undefined &&
                                <View style={styles.zengStyle}>

                                    <Image
                                        style={{
                                            width:ScreenUtils.scaleSize(65),
                                            height:ScreenUtils.scaleSize(30),
                                        }}
                                        source={require("../Img/searchpage/Icon_gifts_@2x.png")}
                                    />
                                    <Text allowFontScaling={false}
                                        style={{paddingLeft:ScreenUtils.scaleSize(10), color: '#999999',fontSize:ScreenUtils.scaleSize(24),marginRight:ScreenUtils.scaleSize(60)}}
                                        numberOfLines={1}
                                    >
                                        {item.giftitemtitle}
                                    </Text>
                                </View>
                            }
                        </View>
                        <View style={styles.priceViewStyle}>

                            {/*销售价格*/}
                            {(item.itemPreferentialPrice && item.itemPreferentialPrice !== 0 && item.itemPreferentialPrice !== -1) ?
                                <Text allowFontScaling={false} style={styles.priceTextStyle}><Text
                                    style={{fontSize: ScreenUtils.setSpText(26)}}>￥</Text>{item.itemPreferentialPrice ? String(item.itemPreferentialPrice) : ''}
                                </Text>
                                :
                                null
                            }

                            {/*参考价格*/}
                            {/*<Text allowFontScaling={false} style={styles.unPriceTextStyle}>{item.itemSalePrice ? '￥' + String(item.itemSalePrice) : ''}</Text>*/}

                            {/*积分*/}
                            {
                                ( item.itemAccumulateScore && item.itemAccumulateScore !== 0 ) ?
                                    <View
                                        style={{flexDirection: 'row', justifyContent: 'center', alignItems: 'center'}}>
                                        <Image style={{marginLeft: 5, marginRight: 5}}
                                               source={require('../Img/home/Icon_accumulate_@2x.png')}/>
                                        <Text allowFontScaling={false}
                                              style={styles.integralValueStyle}>{String(item.itemAccumulateScore)} </Text>
                                    </View>
                                    :
                                    null
                            }

                            {/*库存情况*/}
                            {item.numlittle !== null && item.numlittle !== undefined && item.numlittle !== '' && item.numlittle !== 'N' && ( item.numlittle === 'Y' ?
                                <View style={{
                                    flex: 1,
                                    justifyContent: 'flex-end',
                                    flexDirection: 'row',
                                    marginBottom: ScreenUtils.scaleSize(2)
                                }}>
                                    <Text allowFontScaling={false}
                                          style={{color: '#E5290D', fontSize: ScreenUtils.setSpText(22)}}>库存紧张</Text>
                                </View>
                                :
                                <View style={{
                                    flex: 1,
                                    justifyContent: 'flex-end',
                                    flexDirection: 'row',
                                    marginBottom: ScreenUtils.scaleSize(2)
                                }}>
                                    <Text allowFontScaling={false}
                                          style={{color: '#E5290D', fontSize: ScreenUtils.setSpText(22)}}>{item.numlittle}</Text>
                                </View> )
                            }

                        </View>
                        {/*<View style={styles.alreadyBuyViewStyle}>*/}
                            {/*<Text allowFontScaling={false} style={{color:"#999999"}}>{Number(item.saleQty)>0?String(item.saleQty) + '人已购买':''}</Text>*/}
                            {/*/!*<TouchableOpacity*!/*/}
                                {/*/!*onPress={() => {this._addCart(item.itemCode)}}*!/*/}
                                {/*/!*style={styles.cartViewStyle}>*!/*/}
                                {/*/!*<Image*!/*/}
                                    {/*/!*style={{*!/*/}
                                        {/*/!*flex:1,*!/*/}
                                        {/*/!*width:ScreenUtils.scaleSize(40),*!/*/}
                                        {/*/!*height:ScreenUtils.scaleSize(50),*!/*/}
                                        {/*/!*resizeMode:"contain"*!/*/}
                                    {/*/!*}}*!/*/}
                                    {/*/!*source={require('../Img/me/btn_cart_.png')}>*!/*/}

                                {/*/!*</Image>*!/*/}
                            {/*/!*</TouchableOpacity>*!/*/}
                        {/*</View>*/}
                    </View>
                </TouchableOpacity>
            </View>
        )
    }
    /**
     * 渲染商品标记
     * @param item
     * @private
     */
    _renderFlagImg(item) {
        let img=null;
        let imgStyle=null;
        if(item.isKjt === 'Y'){
            img=require('../../foundation/Img/searchpage/Icon_globalbuy_tag_.png');
            imgStyle={
                ...Platform.select({
                    android:{
                        height: (80 / 2) * ScreenUtils.pixelRatio,
                        width: (23 / 2) * ScreenUtils.pixelRatio,
                    }
                })
            };
        }else if(item.isTv === 'Y'){
            img=require('../../foundation/Img/searchpage/Icon_anchorrecommend_tag_.png');
            imgStyle={
                ...Platform.select({
                    android:{
                        height: (110 / 2) * ScreenUtils.pixelRatio,
                        width: (26 / 2) * ScreenUtils.pixelRatio,
                    },
                    ios:{
                        height:ScreenUtils.scaleSize(26),
                        width:ScreenUtils.scaleSize(110)
                    }
                })
            };
        }else if(item.isTuan === 'Y'){
            img=require('../../foundation/Img/searchpage/Icon_groupbuy_tag2_.png');
            imgStyle={
                ...Platform.select({
                    android:{
                        height: (70 / 2) * ScreenUtils.pixelRatio,
                        width: (26 / 2) * ScreenUtils.pixelRatio,
                    },
                    ios:{
                        height:ScreenUtils.scaleSize(26),
                        width:ScreenUtils.scaleSize(70)
                    }
                })
            };
        }else if(item.isMall === 'Y'){
            img=require('../../foundation/Img/searchpage/tag_shangcheng@3x.png');
            imgStyle={
                ...Platform.select({
                    android:{
                        height: (72 / 2) * ScreenUtils.pixelRatio,
                        width: (27 / 2) * ScreenUtils.pixelRatio,
                    },
                    ios:{
                        height:ScreenUtils.scaleSize(27),
                        width:ScreenUtils.scaleSize(72)
                    }
                })
            };
        }
        if(img!==null){
            return(
                <Image
                    source={img}
                    resizeMode={'stretch'}
                    style={imgStyle}/>
            );
        }
        return null;
    }
    /**
     *
     * @param item
     * @private
     */
    _productLink(item){
        Actions.GoodsDetailMain({'itemcode': item});
    }

    /**
     * 加入购物车
     * @param item_code
     * @private
     */
    _addCart(item_code){
        this.addCartR = new AddCartRequest({
            item_code:item_code,
            qty:1,
            unit_code:"001",
            gift_item_code:"",
            gift_unit_code:"",
            giftPromo_no:"",
            giftPromo_seq:"",
            media_channel:"",
            msale_source:"",
            msale_cps:"",
            source_url:"http://ocj.com.cn",
            source_obj:"",
            timeStamp:"",
            ml_msale_gb:""
        }, "POST");
        this.addCartR.setShowMessage(true).showLoadingView(true).start(
            (response) => {
                let jsonData = response.data;
                if (response.code && response.code === 200) {
                    console.log(response.data);
                    ToastShow.toast(response.data.result.cart_msg)
                }
            }, (erro) => {
                ToastShow.toast(response.message)
            });
    }

}
const styles = StyleSheet.create({
    icon_text: {
        textAlign: 'center',
        color: '#FFFFFF',
        backgroundColor: 'rgba(0,0,0,0)',
        fontSize: ScreenUtils.setSpText(17)
    },
    footPointGoods: {
        overflow:'hidden',
        flexDirection:"row",
        justifyContent:"space-between",
        flex:1,
    },
    goodsInfor: {
        paddingLeft:ScreenUtils.scaleSize(30),
        flex:1,
        borderBottomColor:"#dddddd",
        borderBottomWidth:1,
        paddingBottom:ScreenUtils.scaleSize(30),
        paddingRight:ScreenUtils.scaleSize(30),
        justifyContent:'space-between'
    },
    prductNameTextStyle: {
        flexWrap: "wrap",
        color: '#333333',
        // lineHeight:22,
        fontSize:ScreenUtils.setSpText(28),
    },
    priceViewStyle: {
        // flex: 1,
        flexDirection: 'row',
        // marginTop: 15,
        alignItems:'flex-end',
        height:ScreenUtils.scaleSize(50),
        // backgroundColor:'#999'
        // paddingBottom:ScreenUtils.scaleSize(30),
    },
    priceTextStyle: {
        color: '#E5290D',
        marginRight: 10,
        fontSize:ScreenUtils.scaleSize(34)
    },
    unPriceTextStyle: {
        textDecorationLine: "line-through",
        marginRight: 10,
        color:"#666666"
    },
    integralStyle: {
        backgroundColor: 'orange',
        color: '#FEFEFE',
        marginRight: 5,
        width:18,
        height:18,
        textAlign:'center',
        borderRadius:4
    },
    integralValueStyle: {
        color: 'orange',
        marginBottom:ScreenUtils.scaleSize(2)
    },
    alreadyBuyViewStyle: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'flex-end'
    },
    cartViewStyle: {
        width:ScreenUtils.scaleSize(60),
        height:ScreenUtils.scaleSize(70),
        position:"absolute",
        right:0,
        bottom:10
    },


    liuanImgs:{
        width:ScreenUtils.scaleSize(238),
        height:ScreenUtils.scaleSize(240),
        resizeMode:"contain",
        marginLeft:ScreenUtils.scaleSize(30),
    },
    zengStyle:{
        flexDirection:"row",
        marginTop:ScreenUtils.scaleSize(10)
    },

    giftitemtitle:{
        paddingLeft:ScreenUtils.scaleSize(10)
    },
    prductNameViewStyle:{
        // height:ScreenUtils.scaleSize(150),
    },
    iconStyle:{
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        // width:ScreenUtils.scaleSize(35),
        // height:ScreenUtils.scaleSize(40),
        position: 'absolute',
        left: 3,
        top: ScreenUtils.scaleSize(6),
        zIndex: 11,
        borderRadius:0,
        width:ScreenUtils.scaleSize(100),
        height:ScreenUtils.scaleSize(28)
        // resizeMode: 'contain',
    },
    commendStyle:{
        width:ScreenUtils.scaleSize(130),
        // height:ScreenUtils.scaleSize(40),
        position: 'absolute',
        left: 0,
        top: ScreenUtils.scaleSize(0),
        zIndex: 11,
        borderRadius:ScreenUtils.scaleSize(0),
        resizeMode: 'contain',
    },

    noPunStyle: {
        height: 80,
        justifyContent: "center",
        alignItems: "center"
    }

});

