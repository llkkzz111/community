/**
 * Created by wangwenliang on 2017/7/25.
 * 从商品详情主页中抽取出来的 商品详情内容
 */

'use strict';
import {
    StyleSheet,
    View,
    Text,
    Image,
    Dimensions,
    ART,
    Platform,
} from 'react-native';

import {
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Colors,
    Fonts,
} from '../../../config/UtilComponent';

//内部类
import UnGroupPurchaseNewClass from './UnGroupPurchase';
import GroupPurchaseNewClass from './GroupPurchase';
import DonationShowNewClass from './DonationShow';

const {width} = Dimensions.get('window');
const bottomHeight = ScreenUtils.scaleSize(50);
const paddingBothSide = ScreenUtils.scaleSize(30);

/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;

// 8 内部类封装商品详情内容 最上面的价格那部分区域
export default class GoodsDetail extends Com {
    // 8.1 商品名字前的主播推荐标签
    renderWebDesc() {
        if (this.props.allDatas.itemProperty == null || this.props.allDatas.goodsDetail.web_desc == null || this.props.allDatas.goodsDetail.web_desc == '') {
            return (
                <View >
                    <Text allowFontScaling={false}
                          style={[styles.mainItemT10, {flex: 1}]}>{this.props.allDatas.goodsDetail.co_dc != null && this.props.allDatas.goodsDetail.co_dc !== 0 && this.props.allDatas.goodsDetail.co_dc !== 0.0 && this.renderZheKou()} {this.props.allDatas.goodsDetail.item_name}</Text>
                </View>
            )
        }
        switch (this.props.allDatas.itemProperty) {
            case "1"://团购
                return (

                    <View >

                        <Text allowFontScaling={false}
                              style={[styles.mainItemT10, {flex: 1}]}>
                            <Image source={require('../../../../foundation/Img/searchpage/icon_groupbuying2_@3x.png')}
                                   resizeMode={'stretch'} style={
                                Platform.OS === 'android' ?
                                    {
                                        height: (76 / 2) * ScreenUtils.pixelRatio,
                                        width: (24 / 2) * ScreenUtils.pixelRatio,
                                        marginRight: ScreenUtils.scaleSize(10)
                                    } : {
                                    width: ScreenUtils.scaleSize(85),
                                    height: ScreenUtils.scaleSize(26),
                                }

                            }/>
                            {this.props.allDatas.goodsDetail.co_dc != null && this.props.allDatas.goodsDetail.co_dc !== 0 && this.props.allDatas.goodsDetail.co_dc !== 0.0 && this.renderZheKou()} {this.props.allDatas.goodsDetail.item_name}
                        </Text>
                    </View>

                )
                break;
            case "2"://全球购
                return (

                    <View >

                        <Text allowFontScaling={false}
                              style={[styles.mainItemT10, {flex: 1}]}>
                            <Image source={require('../../../../foundation/Img/searchpage/Icon_globalbuy_tag_@2x.png')}
                                   resizeMode={'stretch'} style={
                                Platform.OS === 'android' ?
                                    {
                                        height: (80 / 2) * ScreenUtils.pixelRatio,
                                        width: (23 / 2) * ScreenUtils.pixelRatio,
                                        marginRight: ScreenUtils.scaleSize(10)
                                    } : {
                                    width: ScreenUtils.scaleSize(85),
                                    height: ScreenUtils.scaleSize(26),
                                }

                            }/>
                            {this.props.allDatas.goodsDetail.co_dc != null && this.props.allDatas.goodsDetail.co_dc !== 0 && this.props.allDatas.goodsDetail.co_dc !== 0.0 && this.renderZheKou()} {this.props.allDatas.goodsDetail.item_name}
                        </Text>
                    </View>
                )
                break;
            case "3"://tv商品（主播推荐）
                return (

                    <View >
                        <Text allowFontScaling={false}
                              style={[styles.mainItemT10, {flex: 1}]}>
                            <Image
                                source={require('../../../../foundation/Img/searchpage/Icon_anchorrecommend_tag_@2x.png')}
                                resizeMode={'stretch'} style={
                                Platform.OS === 'android' ?
                                    {
                                        height: (110 / 2) * ScreenUtils.pixelRatio,
                                        width: (26 / 2) * ScreenUtils.pixelRatio,
                                        marginRight: ScreenUtils.scaleSize(10)
                                    } : {
                                    width: ScreenUtils.scaleSize(110),
                                    height: ScreenUtils.scaleSize(26),
                                }

                            }/>
                            {this.props.allDatas.goodsDetail.co_dc != null && this.props.allDatas.goodsDetail.co_dc !== 0 && this.props.allDatas.goodsDetail.co_dc !== 0.0 && this.renderZheKou()} {this.props.allDatas.goodsDetail.item_name}
                        </Text>
                    </View>
                )
                break;
            default:
                return (
                    <View >
                        <Text allowFontScaling={false}
                              style={[styles.mainItemT10, {flex: 1}]}>{this.props.allDatas.goodsDetail.co_dc != null && this.props.allDatas.goodsDetail.co_dc !== 0 && this.props.allDatas.goodsDetail.co_dc !== 0.0 && this.renderZheKou()} {this.props.allDatas.goodsDetail.item_name}</Text>
                    </View>
                )
                break
        }
    }

    //8.2 商品名字前的折扣
    renderZheKou() {
        if(this.props.allDatas&&this.props.allDatas.goodsDetail&&this.props.allDatas.goodsDetail.co_dc){
            if(parseFloat(this.props.allDatas.goodsDetail.co_dc)!==NaN){
                return (
                    <Text allowFontScaling={false} style={{
                        color: 'red',
                    }}> {this.props.allDatas.goodsDetail.co_dc + ""}折</Text>
                )
            }
        }
        return null;
    }

    render() {
        let height = 66.7;
        let widthI = width * 0.62;
        const path = ART.Path();
        path.moveTo(30, 0);
        path.lineTo(0, height / 2);
        path.lineTo(30, height);
        path.close();

        return (

            <View>
                {this.props.allDatas.itemProperty == "1" ?  //商品类型: 1.是团购，2.全球购，3.tv商品,4.商城
                    <GroupPurchaseNewClass
                        refreshData={() => this.props.refreshData()}
                        allDatas={this.props.allDatas}/>
                    :
                    <UnGroupPurchaseNewClass
                        refreshData={() => this.props.refreshData()}
                        allDatas={this.props.allDatas}
                        jifenShow={(e) => this.props.jifenShow(e)}/>
                }

                {/*商品名字和随箱赠品*/}
                <View style={[styles.mainItemStyle, {paddingBottom: 6, paddingTop: 2}]}>

                    {this.renderWebDesc()}
                    {/*<Text*/}
                    {/*style={styles.mainItemT10}>{this.props.allDatas.goodsDetail.web_desc} {this.props.allDatas.goodsDetail.item_name}</Text>*/}

                    {(this.props.allDatas.goodsDetail.giftPromomAll !== null && this.props.allDatas.goodsDetail.giftPromomAll !== "")?
                        <View style={{
                            height: 1,
                            width: width - paddingBothSide * 2,
                            backgroundColor: '#dddddd',
                            marginBottom: ScreenUtils.scaleSize(10)
                        }}/>:null
                    }
                    {(this.props.allDatas.goodsDetail.giftPromomAll !== null && this.props.allDatas.goodsDetail.giftPromomAll !== "")?
                        <DonationShowNewClass allDatas={this.props.allDatas}/>:null //赠品信息模块
                    }
                </View>
            </View>

        );
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



