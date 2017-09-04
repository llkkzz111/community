/**
 * Created by wangwenliang on 2017/7/25.
 * 商品详情中的团购布局
 */

'use strict';

import {
    StyleSheet,
    View,
    Text,
    Image,
    Dimensions,
} from 'react-native';

import {
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Colors,
    Fonts,
} from '../../../config/UtilComponent';

import ShowTimeNewClass from './ShowTime';
const {width} = Dimensions.get('window');
const bottomHeight = ScreenUtils.scaleSize(50);
const paddingBothSide = ScreenUtils.scaleSize(30);

/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;


//8.3 团购布局
export default class GroupPurchase extends Com {
    render() {
        let height = ScreenUtils.scaleSize(100);
        return (
            <View style={{
                flexDirection: 'row',
                height: height
            }}>

                <Image style={{height: height, width: width * 0.6, resizeMode: 'stretch', justifyContent: 'center'}}
                       source={require('../../../../foundation/Img/goodsdetail/img_bg1_@3x.png')}>
                    <View style={{
                        paddingLeft: paddingBothSide,
                        flexDirection: 'row',
                        alignItems: 'center'
                    }}>
                        <View style={{flexDirection: 'row', alignItems: 'flex-end'}}>


                            {(this.props.allDatas.goodsDetail.last_sale_price || this.props.allDatas.goodsDetail.sale_price)?
                                <Text allowFontScaling={false} style={{
                                    color: '#E5290D',
                                    fontSize: ScreenUtils.setSpText(28),
                                    paddingBottom: ScreenUtils.scaleSize(6),
                                    paddingRight: ScreenUtils.scaleSize(6),
                                    backgroundColor: 'transparent'
                                }}>¥</Text>:null
                            }

                            {(this.props.allDatas.goodsDetail.last_sale_price || this.props.allDatas.goodsDetail.sale_price)?
                                <Text allowFontScaling={false} style={{
                                    color: '#E5290D',
                                    fontSize: ScreenUtils.setSpText(48),
                                    backgroundColor: 'transparent'
                                }}>{String(this.props.allDatas.goodsDetail.last_sale_price || this.props.allDatas.goodsDetail.sale_price)}</Text>:null
                            }


                        </View>

                        <View style={{
                            alignItems: 'center',
                            justifyContent: 'flex-start',
                            paddingLeft: ScreenUtils.scaleSize(20),

                        }}>
                            <View style={{
                                flexDirection: 'row',
                                marginBottom: ScreenUtils.scaleSize(6),
                                alignItems: 'flex-end'
                            }}>
                                <Text allowFontScaling={false} style={{
                                    color: '#999',
                                    fontSize: ScreenUtils.setSpText(28),
                                    textDecorationLine: 'line-through',
                                    backgroundColor: 'transparent'
                                }}>¥{String(this.props.allDatas.goodsDetail.cust_price)}</Text>
                                <Text allowFontScaling={false} style={{
                                    color: '#ED1C41',
                                    fontSize: ScreenUtils.setSpText(24),
                                    paddingLeft: ScreenUtils.scaleSize(18),
                                    backgroundColor: 'transparent'
                                }}>限时促销</Text>
                            </View>

                            {
                                (this.props.allDatas.goodsDetail.co_titem_cnt && this.props.allDatas.goodsDetail.co_titem_cnt != '0')?
                                    <Text allowFontScaling={false} style={{
                                        color: this.props.allDatas.goodsDetail.co_titem_cnt === '库存紧张' ? '#ED1C41' : '#333',
                                        fontSize: ScreenUtils.setSpText(28),
                                        alignSelf: 'flex-start',
                                        backgroundColor: 'transparent'
                                    }}>{this.props.allDatas.goodsDetail.co_titem_cnt + ""}</Text>:null
                            }
                        </View>
                    </View>
                </Image>


                <Image style={{height: height, width: width * 0.4, resizeMode: 'stretch'}}
                       source={require('../../../../foundation/Img/goodsdetail/img_bg2_@3x.png')}>
                    <View style={{
                        height: height,
                        justifyContent: 'center',
                        alignItems: 'center',
                        marginLeft: ScreenUtils.scaleSize(40),
                    }}>
                        <Text allowFontScaling={false}
                              style={{
                                  fontSize: ScreenUtils.setSpText(30),
                                  color: 'white',
                                  backgroundColor: 'transparent'
                              }}>距结束仅剩</Text>
                        <ShowTimeNewClass
                            refreshData={() => this.props.refreshData()}
                            allDatas={this.props.allDatas}/>
                    </View>
                </Image>


            </View>
        )
    }
}


const ts12 = Fonts.tag_font();
const ts14 = Fonts.standard_normal_font();
const ts16 = Fonts.page_normal_font();
const ts18 = Fonts.page_title_font();
const cb = Colors.text_black;
const cg = Colors.text_dark_grey;
const cr = Colors.main_color;
const cy = Colors.yellow;
const styles = StyleSheet.create({
    container: {
        width: width,
        // height: height,
        flex: 1,
        backgroundColor: Colors.text_white
    },
    scrollViewStyle: {
        width: width,
        // height: height - bottomHeight,
        flex: 1,
    },
    topBar: {
        flexDirection: 'row',
        position: 'absolute',
        top: 0,
        left: 0,
        // backgroundColor:'#0f0',
        width: width,
        backgroundColor: 'rgba(225,225,225, 0)',
        alignItems: 'center',
        justifyContent: 'flex-end'
    },
    bottomBar: {
        flexDirection: 'row',
        width: width,
        height: bottomHeight,
        backgroundColor: 'white',
        alignItems: 'center',
        marginBottom: 0,
        position: 'absolute',
        bottom: 0,
    },
    topBarImage: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(36),
    },
    mainItemStyle: {
        borderBottomWidth: ScreenUtils.scaleSize(20),
        borderBottomColor: '#ededed',
        overflow: 'hidden',
        paddingTop: ScreenUtils.scaleSize(20),
        paddingLeft: paddingBothSide,
        paddingRight: paddingBothSide,
        paddingBottom: ScreenUtils.scaleSize(20),
    },
    mainItemStyle1: {
        borderBottomWidth: ScreenUtils.scaleSize(20),
        borderBottomColor: '#ededed',
        overflow: 'hidden',
        paddingTop: ScreenUtils.scaleSize(20),
        paddingLeft: paddingBothSide,
        paddingRight: paddingBothSide,
        paddingBottom: ScreenUtils.scaleSize(40),
    },
    mainI1: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingBottom: paddingBothSide,
    },
    mainItemT1: {
        fontSize: ts14,
        color: cg,
    },
    mainItemT2: {
        fontSize: ts16,
        color: cr,
    },
    mainI2: {
        flexDirection: 'row',
        alignItems: 'center',
        paddingBottom: paddingBothSide / 3,
    },
    mainI2_1: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        paddingBottom: paddingBothSide / 3,
    },
    mainItemT3: {
        // borderWidth: 0.8,
        // borderColor: cr,
        paddingTop: 1,
        paddingBottom: 1,
        paddingLeft: 4,
        paddingRight: 4,
        fontSize: ScreenUtils.setSpText(22),
        color: '#E5290D',
        borderRadius: 3,
        backgroundColor: '#FFF1F4',
        marginRight: 10,
    },
    mainItemT4: {
        fontSize: ScreenUtils.setSpText(24),
        color: cr,
    },
    mainItemT5: {
        fontSize: ScreenUtils.setSpText(40),
        color: cr,
        fontFamily: 'HelveticaNeue'
    },
    mainTtemT6: {
        fontSize: ScreenUtils.setSpText(28),
        color: cg,
        textDecorationLine: 'line-through',
        marginLeft: 6,
    },
    mainTtemT66: {
        fontSize: ScreenUtils.setSpText(28),
        color: cg,
        // textDecorationLine: 'line-through',
        marginLeft: 6,
    },
    mainItemT7: {
        backgroundColor: cy,
        color: '#fff',
        fontSize: ScreenUtils.setSpText(24),
        borderRadius: 3,
        paddingLeft: 4,
        paddingRight: 4,
        paddingTop: 2,
        marginLeft: ScreenUtils.scaleSize(40),
        paddingBottom: 2,
    },
    mainItemT8: {
        marginLeft: 5,
        fontSize: ts14,
        color: cg,
    },
    mainItemT9: {
        marginLeft: 5,
        color: '#FA6923',
        fontSize: ScreenUtils.setSpText(26),
    },
    mainItemT10: {
        fontSize: ScreenUtils.setSpText(30),
        paddingBottom: 6,
        // lineHeight: ScreenUtils.scaleSize(42),
        color: cb,
        marginBottom: ScreenUtils.scaleSize(10),
        marginTop: ScreenUtils.scaleSize(10),
    },
    mainI3: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        // marginTop: ScreenUtils.scaleSize(10),

    },
    mainItemT11: {
        fontSize: ScreenUtils.setSpText(24),
        flex: 0,
        color: '#333',
    },
    mainI3_1: {
        flex: 1,
        paddingLeft: 20,
        flexDirection: 'column'
    },
    rightArrow: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
        flex: 0,
        marginLeft: ScreenUtils.scaleSize(30),
    },
    mainItemT12: {
        fontSize: ScreenUtils.setSpText(24),
        color: '#fff',
    },
    evaluateTop: {
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: '#dddddd',
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingTop: 10,
        paddingBottom: 20,
    },
    evaluateTopT1: {
        color: '#444',
        flex: 0,
        fontSize: ScreenUtils.setSpText(28),
    },
    evaluateTopT2: {
        color: cr,
        flex: 1,
        textAlign: 'right',
        marginRight: 3,
        fontSize: ScreenUtils.setSpText(28),
    },
    evaluateTopRightStars: {
        // width: ScreenUtils.scaleSize(163),
        flex: 0,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        marginRight: 5
    },
    star: {
        width: ScreenUtils.scaleSize(20),
        height: ScreenUtils.scaleSize(20),
        marginLeft: 6,
    },
    star1: {
        width: ScreenUtils.scaleSize(26),
        height: ScreenUtils.scaleSize(26),
        marginLeft: 6,
    },
    evaluateBottom: {
        height: ScreenUtils.scaleSize(100),
        width: width - paddingBothSide,
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 10,
    },
    evaluateBottomText: {
        padding: 3,
        color: cr,
        fontSize: ScreenUtils.setSpText(28),
        borderWidth: 1,
        borderColor: cr,
        borderRadius: 3,
        textAlign: 'center'
    },
    evaItem: {
        paddingBottom: ScreenUtils.scaleSize(10),
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: '#dddddd'
    },
    evaItemTop: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: 10,
        marginBottom: 10,
    },
    evaItemTopIcon: {
        width: ScreenUtils.scaleSize(50),
        height: ScreenUtils.scaleSize(50),
        flex: 0,
        borderRadius: 15,
    },
    evaItemTopName: {
        color: '#444',
        fontSize: ScreenUtils.setSpText(26),
        marginLeft: 10,
        flex: 0,
    },
    evaItemTopIime: {
        flex: 1,
        fontSize: ScreenUtils.setSpText(26),
        color: '#666',
        textAlign: 'right',
    },
    evaContent: {
        fontSize: ScreenUtils.setSpText(26),
        color: '#444',
        lineHeight: 20,
    },
    evaStretch: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
        marginTop: 6,
        marginBottom: 6,
    },
    evaStretchT: {
        color: cg,
        fontSize: ts12,
        // lineHeight:60,
    },
    evaStretchImage: {
        width: 10,
        height: 10,
    },
    evaSV: {
        width: width - paddingBothSide * 2,
        // height:90,
    },
    evaSVImage: {
        width: ScreenUtils.scaleSize(220),
        height: ScreenUtils.scaleSize(220),
        margin: 6,
    },
    recomendTopText: {
        color: cg,
        fontSize: ts16,
        marginBottom: paddingBothSide,
    },
    recomendItemView: {
        width: 140,
        marginRight: ScreenUtils.scaleSize(40),
        marginTop: ScreenUtils.scaleSize(10),
        marginBottom: ScreenUtils.scaleSize(10),
    },
    recomendItemImage: {
        width: ScreenUtils.scaleSize(300),
        height: ScreenUtils.scaleSize(300),
        marginBottom: ScreenUtils.scaleSize(14),
    },
    recomendItemContent: {
        marginBottom: 3,
        color: '#333',
        fontSize: ScreenUtils.setSpText(24),
    },
    recomendItemViewC: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-end',
    },
    recomendItemLeft: {
        color: cr,
        fontSize: ScreenUtils.setSpText(34),
    },
    recomendItemRight: {
        color: cg,
        fontSize: ScreenUtils.setSpText(22),
    },
    tabContainer: {
        flex: 1,
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center'
    }
});