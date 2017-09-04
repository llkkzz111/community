/**
 * Created by wangwenliang on 2017/8/9.
 * 商品详情中的促销和抵用券item
 */

'use strict';
import React, {Component, PureComponent} from 'react';
import {
    StyleSheet,
    View,
    Text,
    Image,
    TouchableOpacity,
} from 'react-native';

//字体颜色统一引用
import Colors from '../../../config/colors';
import Fonts from '../../../config/fonts';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

//埋点
import {DataAnalyticsModule} from '../../../config/AndroidModules';
const paddingBothSide = ScreenUtils.scaleSize(30);

/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;

//商品详情主页
export default class SaleAndVoucherItem extends Com {
    constructor(props) {
        super(props);
        this.state = {
            voucherDatas: this.props.voucherDatas,
        };


    }




    componentWillReceiveProps(nextProps) {
        this.setState({voucherDatas:nextProps.voucherDatas});
    }



    //render促销信息
    render() {
        let allDatas = this.props.allDatas;

        let voucherName = '';
        if (this.state.voucherDatas && this.state.voucherDatas.length > 0) {
            this.state.voucherDatas.forEach((voucher, index) => {
                if (voucher.use_now === 'YES') {
                    voucherName = voucher.dccoupon_name;
                    return;
                }
            });
        }
        return (
            <View style={styles.mainItemStyle1}>

                {allDatas.promoms.length > 0 ?
                    <TouchableOpacity activeOpacity={1} style={[styles.mainI3, {
                        marginBottom: ScreenUtils.scaleSize(10),
                        alignItems: 'center'
                    }]}
                                      onPress={() => {

                                          this.props.promotionDialogShow();

                                          let eventid = (allDatas.promoms[0].promo_content !== undefined &&
                                          allDatas.promoms[0].promo_content !== null &&
                                          allDatas.promoms[0].promo_content.length > 0 &&
                                          allDatas.promoms[0].promo_content[0].pcode !== undefined &&
                                          allDatas.promoms[0].promo_content[0].pcode) ? allDatas.promoms[0].promo_content[0].pcode : "";

                                          //埋点 促销
                                          if (eventid) {
                                              DataAnalyticsModule.trackEvent3("AP1706C032F010002A001001", "", {
                                                  eventid: eventid + ""
                                              });
                                          }

                                      }}>
                        <View style={{
                            borderRadius: 3,
                            width: ScreenUtils.scaleSize(64),
                            height: ScreenUtils.scaleSize(40),
                            alignItems: 'center',
                            justifyContent: 'center',
                            backgroundColor: '#ED1C41'
                        }}>
                            <Text allowFontScaling={false} style={styles.mainItemT12}>促销</Text>
                        </View>

                        <View style={styles.mainI3_1}>
                            <Text allowFontScaling={false}
                                  numberOfLines={1}>{allDatas.promoms[0].promo_name}</Text>
                            {(allDatas.promoms !== null && allDatas.promoms.length > 1) ?
                                <Text allowFontScaling={false}
                                      numberOfLines={1}>{allDatas.promoms[1] && (allDatas.promoms[1].promo_name )}</Text> : null
                            }
                            {(allDatas.promoms !== null && allDatas.promoms.length > 2) ?
                                <Text allowFontScaling={false}
                                      numberOfLines={1}>{allDatas.promoms[2] && (allDatas.promoms[2].promo_name )}</Text> : null
                            }
                        </View>
                        <Text allowFontScaling={false} style={{
                            color: cr,
                            flex: 1,
                            textAlign: 'right',
                            paddingTop: 2,
                            fontSize: ScreenUtils.setSpText(28)
                        }}>更多促销</Text>
                        <Image style={[styles.rightArrow, {marginTop: ScreenUtils.scaleSize(6)}]} resizeMode={'contain'}
                               source={require('../../../../foundation/Img/home/store/icon_view_more_.png')}/>
                    </TouchableOpacity> : null
                }

                {voucherName.length > 0 ?
                    <TouchableOpacity activeOpacity={1}
                                      style={[styles.mainI3, {
                                          alignItems: 'center',
                                          marginTop: ScreenUtils.scaleSize(10)
                                      }]}
                                      onPress={() => {

                                          //埋点  领取
                                          DataAnalyticsModule.trackEvent3("AP1706C032F010003A001001", "", {
                                              itemcode: allDatas.goodsDetail.item_code
                                          });

                                          this.props.goodsDetailsVoucherShow();

                                      }}>
                        <Image source={require('../../../../foundation/Img/Icon_voucher_@2x.png')}
                               style={{width: ScreenUtils.scaleSize(90), height: ScreenUtils.scaleSize(40)}}/>

                        <View
                            style={{
                                flex: 1,
                                flexDirection: 'row',
                                justifyContent: 'space-between',
                                alignItems: 'center',
                            }}>
                            <Text allowFontScaling={false} style={{
                                fontSize: ScreenUtils.setSpText(30),
                                color: Colors.text_black,
                                marginLeft: 20
                            }}>{voucherName.length > 0 ? voucherName : ''}</Text>
                            <Text allowFontScaling={false} style={{
                                color: cr,
                                flex: 1,
                                textAlign: 'right',
                                marginRight: 9,
                                fontSize: ScreenUtils.setSpText(28)
                            }}>领取</Text>
                        </View>
                        <Image style={[styles.rightArrow, {marginLeft: ScreenUtils.scaleSize(4)}]}
                               resizeMode={'contain'}
                               source={require('../../../../foundation/Img/home/store/icon_view_more_.png')}/>
                    </TouchableOpacity> : null
                }
            </View>
        )
    }


}

const ts14 = Fonts.standard_normal_font();
const cg = Colors.text_dark_grey;
const cr = Colors.main_color;
const styles = StyleSheet.create({

    mainItemStyle1: {
        borderBottomWidth: ScreenUtils.scaleSize(20),
        borderBottomColor: '#ededed',
        overflow: 'hidden',
        paddingTop: ScreenUtils.scaleSize(20),
        paddingLeft: paddingBothSide,
        paddingRight: paddingBothSide,
        paddingBottom: ScreenUtils.scaleSize(40),
    },
    mainItemT1: {
        fontSize: ts14,
        color: cg,
    },
    mainI3: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        // marginTop: ScreenUtils.scaleSize(10),

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
});

