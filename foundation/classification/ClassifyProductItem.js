/**
 * Created by Administrator on 2017/6/30.
 */

//分类列表页面单个商品ITEM

import React, {Component, PureComponent} from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    Platform,
} from 'react-native';
//import {CachedImage} from "react-native-img-cache";
import {Actions} from 'react-native-router-flux';
import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';

/**
* @description
* 根据开发环境选择是否要不可变数据结构
* @const {class}
*/
const Com = __DEV__ ? Component : PureComponent;

export default class ClassifyProductItem extends Com {
    constructor(props) {
        super(props);
        this.state = {
            displayDirection: this.props.displayDirection, //排列方向
        }
    }

    _jump(itemCode) {
        Actions.GoodsDetailMain({itemcode: itemCode + ""});
    }

    /**
     * 渲染商品标记
     * @param item
     * @private
     */
    _renderFlagImg(item) {
        let img = null;
        let imgStyle = null;
        if (item.web_desc === '0') {//全球购
            img = require('../../foundation/Img/searchpage/Icon_globalbuy_tag_.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (80 / 2) * ScreenUtil.pixelRatio,
                        width: (23 / 2) * ScreenUtil.pixelRatio,
                    }
                })
            };
        } else if (item.web_desc === '1') {//主播推荐
            img = require('../../foundation/Img/searchpage/Icon_anchorrecommend_tag_.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (110 / 2) * ScreenUtil.pixelRatio,
                        width: (26 / 2) * ScreenUtil.pixelRatio,
                    },
                    ios: {
                        height: ScreenUtil.scaleSize(26),
                        width: ScreenUtil.scaleSize(110)
                    }
                })
            };
        } else if (item.web_desc === '3') {//团购
            img = require('../../foundation/Img/searchpage/Icon_groupbuy_tag2_.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (70 / 2) * ScreenUtil.pixelRatio,
                        width: (26 / 2) * ScreenUtil.pixelRatio,
                    },
                    ios: {
                        height: ScreenUtil.scaleSize(26),
                        width: ScreenUtil.scaleSize(70)
                    }
                })
            };
        }
        // } else if (item.web_desc === '2') {//商城
        //     img = require('../../foundation/Img/searchpage/tag_shangcheng@3x.png');
        //     imgStyle = {
        //         ...Platform.select({
        //             android: {
        //                 height: (72 / 2) * ScreenUtil.pixelRatio,
        //                 width: (27 / 2) * ScreenUtil.pixelRatio,
        //             },
        //             ios: {
        //                 height: ScreenUtil.scaleSize(27),
        //                 width: ScreenUtil.scaleSize(72)
        //             }
        //         })
        //     };
        // }
        if (img !== null) {
            return (
                <Image
                    source={img}
                    resizeMode={'stretch'}
                    style={imgStyle}/>
            );
        }
        return null;
    }

    render() {
        let {searchItem} = this.props;
        return (
            <TouchableOpacity activeOpacity={1}
                              onPress={() => this._jump(searchItem.item_code)}
                              style={this.state.displayDirection === 'row' ? styles.rowContainers : styles.columnContainers}>
                <Image style={this.state.displayDirection === 'row' ? styles.rowImg : styles.columnImg}
                       source={require('../Img/img_defaul_@3x.png')}/>
                {searchItem.item_image ?
                    <Image style={this.state.displayDirection === 'row' ? styles.inRowImg : styles.inColumnImg}
                           source={{uri: searchItem.item_image}}/> : null
                }
                {/*<CachedImage*/}
                {/*source={{uri: searchItem.item_image}}*/}
                {/*/>*/}
                <View
                    style={this.state.displayDirection === 'row' ? styles.rowContentsView : styles.columnContentsView}>
                    {//折扣co_dc,ThreeQTY销量
                        searchItem.web_desc === '0' ? //全球购
                            <View style={{flexDirection: 'row'}}>
                                <Text numberOfLines={2}
                                      style={this.state.displayDirection === 'row' ? styles.groupTitleRow : styles.groupTitle}
                                      allowFontScaling={false}>
                                    {this._renderFlagImg(searchItem)}
                                    {searchItem.item_name}
                                </Text>
                            </View>
                            : searchItem.web_desc === '1' ? //主播推荐
                            <View style={{flexDirection: 'row'}}>
                                <Text numberOfLines={2}
                                      style={this.state.displayDirection === 'row' ? styles.groupTitleRow : styles.groupTitle}
                                      allowFontScaling={false}>
                                    {this._renderFlagImg(searchItem)}
                                    {"   " + searchItem.item_name}</Text>
                            </View>
                            : searchItem.web_desc === '3' ? //团购
                                <View style={{flexDirection: 'row'}}>
                                    <Text numberOfLines={2}
                                          style={this.state.displayDirection === 'row' ? styles.groupTitleRow : styles.groupTitle}
                                          allowFontScaling={false}>
                                        {this._renderFlagImg(searchItem)}
                                        {"   " + searchItem.item_name}</Text>
                                </View>
                                : (searchItem.co_dc && searchItem.co_dc !== 0) ?
                                    <View style={{flexDirection: 'row'}}>
                                        <Image
                                            style={[styles.iconStyle, styles.iconTwoTextStyle, {justifyContent:'center',alignItems:'center'}]}
                                            source={require('../Img/goodsdetail/icon_discount_@3x.png')}>
                                            <Text
                                                style={{
                                                    textAlign: 'center',
                                                    fontSize: ScreenUtil.setSpText(14),
                                                    color: Colors.main_color,
                                                }} allowFontScaling={false}>{searchItem.co_dc}折</Text>
                                        </Image>
                                        <Text numberOfLines={2}
                                              style={this.state.displayDirection === 'row' ? styles.groupTitleRow : styles.groupTitle}
                                              allowFontScaling={false}>{"            " + searchItem.item_name}</Text>
                                    </View>
                                    :
                                    <Text numberOfLines={2}
                                          style={this.state.displayDirection === 'row' ? styles.groupTitleRow : styles.groupTitle}
                                          allowFontScaling={false}>{searchItem.item_name}</Text>

                    }
                    {
                        this.state.displayDirection === 'column' && searchItem.explain_Note ?// 赠品显示
                            <View style={{flexDirection: 'row'}}>
                                <Image source={require('../Img/searchpage/Icon_gifts_@2x.png')}
                                       style={styles.giftStyle}/>
                                <Text numberOfLines={1} style={styles.giftText}
                                      allowFontScaling={false}>{searchItem.explain_Note}</Text>
                            </View>
                            :
                            null
                    }

                    <View style={styles.priceView}>
                        <View style={{
                            flexDirection: 'row',
                            justifyContent: 'flex-end',
                            alignItems: 'center',
                            textAlignVertical: "bottom"
                        }}>
                            <Text style={styles.moneyStyle} allowFontScaling={false}>￥</Text>
                            <Text
                                style={styles.priceStyle}
                                allowFontScaling={false}>{searchItem.last_sale_price ? String(searchItem.last_sale_price) : String(item.sale_price)}</Text>
                            {
                                //积分显示
                                searchItem.save_amt ?
                                    <Image source={require('../Img/searchpage/Icon_accumulate_@2x.png')}
                                           style={styles.accumImg}/>
                                    :
                                    null
                            }
                            {
                                searchItem.save_amt ?
                                    <Text style={styles.saveamtStyle}
                                          allowFontScaling={false}>{String(searchItem.save_amt)}</Text>
                                    :
                                    null
                            }


                        </View>
                        {
                            this.state.displayDirection === 'row' ?
                                searchItem.explain_Note ?//赠品显示
                                    <Image source={require('../Img/searchpage/Icon_gifts_@2x.png')}
                                           style={styles.giftStyle}/>
                                    :
                                    searchItem.stock_prompt ?//库存紧张
                                        <Text style={styles.stockIsTight}
                                              allowFontScaling={false}>{searchItem.stock_prompt}</Text>
                                        :
                                        null
                                :
                                searchItem.stock_prompt ?//库存紧张
                                    <Text style={styles.stockIsTight}
                                          allowFontScaling={false}>{searchItem.stock_prompt}</Text>
                                    :
                                    null
                        }
                    </View>
                    {
                        this.state.displayDirection === 'row' ?
                            searchItem.promo_last_name && searchItem.stock_prompt ?
                                <View style={{alignItems: 'flex-end'}}>
                                    <Text style={styles.stockIsTight}
                                          allowFontScaling={false}>{searchItem.stock_prompt}</Text>
                                </View>
                                :
                                null
                            :
                            null
                    }
                </View>

            </TouchableOpacity>
        )
    }
}

ClassifyProductItem.propTypes = {
    searchItem: React.PropTypes.object.isRequired,
    displayDirection: React.PropTypes.string.isRequired,

};

ClassifyProductItem.defaultProps = {};


const styles = StyleSheet.create({
    //一行两个
    rowContainers: {
        backgroundColor: Colors.background_white,
        padding: ScreenUtil.scaleSize(10),
        flexDirection: 'column',
        borderRightWidth: ScreenUtil.scaleSize(1),
        borderBottomWidth: ScreenUtil.scaleSize(1),
        borderRightColor: Colors.line_grey,
        borderBottomColor: Colors.line_grey,
        justifyContent: 'flex-start',
        width: ScreenUtil.screenW / 2,
    },
    //一行一个
    columnContainers: {
        backgroundColor: Colors.background_white,
        paddingRight: ScreenUtil.scaleSize(20),
        paddingLeft: ScreenUtil.scaleSize(20),
        flexDirection: 'row',
        // borderWidth: 1,
        // borderColor: Colors.line_grey,
        justifyContent: 'flex-start',
    },

    rowImg: {
        width: ScreenUtil.screenW / 2 - ScreenUtil.scaleSize(40),
        height: ScreenUtil.scaleSize(320),
    },

    columnImg: {
        width: ScreenUtil.scaleSize(240),
        height: ScreenUtil.scaleSize(240),
        marginTop: ScreenUtil.scaleSize(20),
        marginBottom: ScreenUtil.scaleSize(20),
    },
    inRowImg: {
        width: ScreenUtil.screenW / 2 - ScreenUtil.scaleSize(20),
        height: ScreenUtil.scaleSize(320),
        position: 'absolute',
        left: ScreenUtil.scaleSize(10),
        top: ScreenUtil.scaleSize(10),
    },
    inColumnImg: {
        width: ScreenUtil.scaleSize(240),
        height: ScreenUtil.scaleSize(240),
        marginTop: ScreenUtil.scaleSize(20),
        marginBottom: ScreenUtil.scaleSize(20),
        position: 'absolute',
        left: ScreenUtil.scaleSize(20),
        top: 0,
    },
    rowImgTitleBg: {
        backgroundColor: "rgba(229,41,13,0.7)",
        paddingTop: ScreenUtil.scaleSize(10),
        paddingBottom: ScreenUtil.scaleSize(10),
        flexDirection: 'row',
        justifyContent: 'center',
        width: ScreenUtil.screenW / 2 - ScreenUtil.scaleSize(40),
        height: ScreenUtil.scaleSize(46),
        position: 'absolute',
        left: ScreenUtil.scaleSize(10),
        top: ScreenUtil.scaleSize(300),
        zIndex: 10,
        resizeMode: 'cover',
        alignItems: 'center',
    },
    columnImgTitleBg: {
        width: ScreenUtil.scaleSize(240),
        height: ScreenUtil.scaleSize(36),
        backgroundColor: "rgba(229,41,13,0.7)",
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        position: 'absolute',
        left: ScreenUtil.scaleSize(30),
        bottom: ScreenUtil.scaleSize(20),
        zIndex: 10,
        resizeMode: 'cover',
    },

    groupImgBg: {
        width: ScreenUtil.scaleSize(20),
        height: ScreenUtil.scaleSize(20),
        marginRight: ScreenUtil.scaleSize(4),

    },

    pImgTitle: {
        color: Colors.text_white,
        fontSize: ScreenUtil.setSpText(20),
    },
    rowContentsView: {
        flexDirection: 'column',
        flex: 1,
        justifyContent: 'space-between',
        marginTop: 5
    },
    columnContentsView: {
        flexDirection: 'column',
        flex: 1,
        justifyContent: 'space-between',
        paddingLeft: ScreenUtil.scaleSize(30),
        borderBottomWidth: ScreenUtil.scaleSize(1),
        borderBottomColor: '#dddddd',
        height: ScreenUtil.scaleSize(275),
        paddingVertical: ScreenUtil.scaleSize(14)
    },
    groupTitle: {
        color: Colors.text_black,
        fontSize: ScreenUtil.setSpText(28),
        lineHeight: parseInt(ScreenUtil.scaleSize(44)),
    },
    groupTitleRow: {
        color: Colors.text_black,
        fontSize: ScreenUtil.setSpText(28),
        height: ScreenUtil.scaleSize(80),
        lineHeight: parseInt(ScreenUtil.scaleSize(44))
    },
    priceView: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginTop: ScreenUtil.scaleSize(10),
    },
    moneyStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(24),
        textAlignVertical: 'center',
    },
    priceStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(36),
        marginRight: ScreenUtil.setSpText(10),
        marginTop: ScreenUtil.setSpText(2) * -1,
    },
    originalPriceStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtil.setSpText(24),
        textDecorationLine: 'line-through',
        //textAlign:'center',
        textAlignVertical: 'center',
    },
    stockIsTight: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(20),
        textAlignVertical: 'bottom',
    },
    buyCountView: {
        justifyContent: 'space-between',
        flexDirection: 'row',
        height: ScreenUtil.scaleSize(40),
    },
    buyCountStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtil.setSpText(24),
    },
    iconStyle: {
        position: 'absolute',
        left: 0,
        zIndex: 11,
        borderRadius: 0,
        resizeMode: 'contain',
    },
    iconTwoTextStyle: {
        width: ScreenUtil.scaleSize(70),
        height: ScreenUtil.scaleSize(26),
        top: ScreenUtil.scaleSize(7),
    },
    iconThreeTextStyle: {
        width: ScreenUtil.scaleSize(90),
        height: ScreenUtil.scaleSize(26),
        top: ScreenUtil.scaleSize(8),
    },
    commendStyle: {
        width: ScreenUtil.scaleSize(110),
        height: ScreenUtil.scaleSize(26),
        top: ScreenUtil.scaleSize(4),
    },
    giftsIconStyle: {
        width: ScreenUtil.scaleSize(50),
        height: ScreenUtil.scaleSize(60),
    },
    giftText: {
        width: ScreenUtil.scaleSize(300),
        fontSize: ScreenUtil.setSpText(24),
        color: Colors.text_dark_grey,
        marginLeft: ScreenUtil.scaleSize(10),
    },
    giftStyle: {
        width: ScreenUtil.scaleSize(60),
        height: ScreenUtil.scaleSize(26),
        borderRadius: 5,
        marginTop: ScreenUtil.scaleSize(4),
    },
    saveamtStyle: {
        color: '#FA6923',
        fontSize: ScreenUtil.setSpText(24),
        marginTop: ScreenUtil.scaleSize(4),
        height: ScreenUtil.scaleSize(36),
        textAlignVertical: "bottom"
    },

    accumImg: {
        width: ScreenUtil.scaleSize(32),
        height: ScreenUtil.scaleSize(32),
        marginTop: ScreenUtil.scaleSize(4),
        marginRight: ScreenUtil.scaleSize(10),
    },
    integralStyle: {
        backgroundColor: '#FFC033',
        color: '#FEFEFE',
        paddingLeft: ScreenUtil.scaleSize(6),
        marginTop: ScreenUtil.scaleSize(4),
        paddingRight: ScreenUtil.scaleSize(6),
        height: ScreenUtil.scaleSize(36),
        textAlign: 'center',
        marginRight: ScreenUtil.scaleSize(10),
        textAlignVertical: 'center',
        paddingBottom: ScreenUtil.scaleSize(6),
    },
});
