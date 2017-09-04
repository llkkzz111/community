/**
 * Created by Zhang.xinchun on 2017/5/10.
 * 购物车的商品组件
 */
import React, {
    PropTypes
} from 'react';

import {
    Text,
    View,
    Image,
    StyleSheet,
    TouchableOpacity
} from 'react-native';
import InputNumberText from './InputNumberText'
//常量定义
import * as Constants from '../../app/constants/Constants'
import Immutable from 'immutable'
//自适应
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
/**
 * 商品信息组件
 */
export class ShoppingRender extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            data: this.props.dataSource,
            shopCount: this.props.dataSource.item_qty,
            refresh: true,
        }
    }

    // shouldComponentUpdate(nextProps, nextState) {
    //     return (
    //     (this.props.cartType !== nextProps.cartType)
    //     || !(Immutable.is(this.props.dataSource, nextProps.dataSource)));
    // }

    componentWillReceiveProps(nextProps) {
        this.setState({
            data: nextProps.dataSource,
            shopCount: nextProps.dataSource.item_qty,//商品件数数量
            cartType: nextProps.cartType,//编辑或者完成
        })
    }

    //去预约
    onAppointmentClick(itemCode) {
        //去预约埋点
        DataAnalyticsModule.trackEvent2("AP1706C001B036001A001004", "");
        this.props.onShoppingClick(itemCode);
    }

    //渲染商品可选状态
    renderShopSelect(type, itemStatus) {
        let imgSource = require('../Img/cart/unselected.png');
        //商品是否选择
        if (this.state.data.check_cart_yn === Constants.Selected) {
            imgSource = require('../Img/cart/selected.png');
        } else {
            imgSource = require('../Img/cart/unselected.png');
        }
        if (type) {
            //缺货,无效,可预约状态不可选择商品
            // 1:缺货 2:无效 4:可预约 3库存紧张
            if (itemStatus !== 1 && itemStatus !== 2 && itemStatus !== 4) {
                return (
                    <TouchableOpacity
                        activeOpacity={1} style={styles.selectLayout}
                        onPress={() => {
                            this.props.onSelected({
                                cart_seq: this.state.data.cart_seq,
                                check_cart_yn: this.state.data.check_cart_yn,
                            });
                        }}>
                        <Image source={imgSource} style={styles.titleSellced} resizeMode={'contain'}/>
                    </TouchableOpacity>);
            } else {
                return (<View style={styles.selectLayout}/>);
            }
        } else {
            return (
                <TouchableOpacity
                    activeOpacity={1} style={styles.selectLayout}
                    onPress={() => {
                        // this.props.onSelected({
                        //     cart_seq: this.state.data.cart_seq,
                        //     check_cart_yn: this.state.data.check_cart_yn,
                        // });
                        this.state.data.check_cart_yn = this.state.data.check_cart_yn === Constants.Selected ? Constants.UnSelected : Constants.Selected;
                        if (this.state.data.check_cart_yn === Constants.Selected) {
                            this.props.onSubmitEditing({
                                qty: this.state.shopCount,
                                unit_code: this.state.data.unit_code,
                                cart_seq: this.state.data.cart_seq,
                                gift_item_code: this.state.data.gift_item_code,
                                gift_unit_code: this.state.data.gift_unit_code,
                                gift_cart_seq: this.state.data.gift_cart_seq,
                                item_code: this.state.data.item_code,
                            });
                        } else {
                            this.props.cancelChange(this.state.data.cart_seq.toString());
                        }
                        this.setState({
                            refresh: !this.state.refresh,
                        });
                    }}>
                    <Image source={imgSource} style={styles.titleSellced} resizeMode={'contain'}/>
                </TouchableOpacity>);
        }
    }

    localSelectChange() {
        this.state.data.check_cart_yn = Constants.Selected;
        this.setState({
            refresh: !this.state.refresh,
        });
    }

    //渲染商品提示区
    renderWarningBlock(itemStatus) {
        //缺货,无效,可预约 显示提示文字
        if (itemStatus === 1 || itemStatus === 2 || itemStatus === 4) {
            return (<Text style={[styles.outOfStock, {backgroundColor: "#333333"}]} allowFontScaling={false}> </Text>);
        } else if (itemStatus === 3) {
            return (<Text style={styles.outOfStock} allowFontScaling={false}> </Text>);
        }
    }

    //渲染商品提示文字
    renderWarningText(itemStatus) {
        if (itemStatus === 1) {
            return (
                <View style={styles.inventory}>
                    <Text style={styles.backTextWhite} allowFontScaling={false}>失效</Text>
                </View>);
        } else if (itemStatus === 2 || itemStatus === 4) {
            return (
                <View style={styles.inventory}>
                    <Text style={styles.backTextWhite} allowFontScaling={false}>暂时缺货</Text>
                </View>);
        } else if (itemStatus === 3) {
            return (
                <View style={styles.inventory}>
                    <Text style={styles.backTextWhite} allowFontScaling={false}>库存紧张</Text>
                </View>);
        }
    }

    //渲染商品标题区
    renderShopTitle(itemStatus) {

        if (itemStatus === 1) {
            return (
                <Text style={[styles.fontWeight, {color: '#999999'}]}
                      numberOfLines={2} allowFontScaling={false}>{this.state.data.item_name}</Text>);
        } else {
            return (
                <Text style={[styles.fontWeight, {color: '#333333'}]}
                      numberOfLines={2} allowFontScaling={false}>{this.state.data.item_name}</Text>);
        }
    }

    //渲染商品规格区
    renderShopColorSize(type, itemStatus) {
        let cs_name = "";
        if (this.state.data.color_name === "无"
            && this.state.data.size_name === "无") {
            cs_name = "颜色/种类:无"
        } else {
            cs_name = this.state.data.cs_name;
        }
        if (type) {
            if (itemStatus === 1) {
                return (
                    <View style={[styles.commercialSpecificationLayout, {backgroundColor: 'white'}]}>
                        <Text style={[styles.colorStyle, {color: '#999999'}]}
                              numberOfLines={1} allowFontScaling={false}>{cs_name}</Text>
                    </View>);
            } else {
                return (
                    <View style={[styles.commercialSpecificationLayout, {backgroundColor: 'white'}]}>
                        <Text style={[styles.colorStyle, {color: '#666666'}]}
                              numberOfLines={1} allowFontScaling={false}>{cs_name}</Text>
                    </View>);
            }
        } else {

            if (itemStatus === 1) {
                return (
                    <View style={[styles.commercialSpecificationLayout, {backgroundColor: 'white'}]}>
                        <Text style={styles.colorStyle} numberOfLines={1} allowFontScaling={false}>{cs_name}</Text>
                    </View>);
            } else {
                return (
                    <TouchableOpacity
                        activeOpacity={1} style={[styles.commercialSpecificationLayout]}
                        onPress={() => this.props.onCommercialSpecification({
                                qty: this.state.shopCount,
                                cs_code: this.state.data.cs_code,
                                color_name: this.state.data.color_name,
                                color_code: this.state.data.color_code,
                                size_name: this.state.data.size_name,
                                size_code: this.state.data.size_code,
                                price: this.state.data.final_sale_price,
                                cart_seq: this.state.data.cart_seq,
                                item_code: this.state.data.item_code,
                                uri: this.state.data.itemimgurl,
                                gift_arr: this.state.data.giftcartItemInfos,
                                giftItem_yn: this.state.data.giftItem_yn,
                            }
                        )}>
                        <Text style={styles.colorStyle} numberOfLines={1} allowFontScaling={false}>{cs_name}</Text>
                        <Image style={styles.commercialSpecificationImgStyle}
                               source={require('../Img/cart/Icon_right_grey_@3x.png')}/>
                    </TouchableOpacity>);
            }
        }
    }

    //渲染完成状态商品价格区
    renderFShopPrice(itemStatus) {
        let reduContent = "";
        let tempRedu = "比加入时降"
        if (this.state.data.event_end_title !== null
            && this.state.data.event_end_title !== undefined
            && this.state.data.old_item_price !== null
            && this.state.data.old_item_price !== undefined) {
            reduContent = this.state.data.event_end_title + this.state.data.old_item_price
        } else if (this.state.data.old_item_price !== null
            && this.state.data.old_item_price !== undefined) {
            reduContent = tempRedu + parseFloat(this.state.data.old_item_price) - parseFloat(this.state.data.final_sale_price) + "元";
        } else if (this.state.data.redu_title !== null
            && this.state.data.redu_title !== undefined
            && this.state.data.redu_title !== "") {
            reduContent = this.state.data.redu_title;
        }
        let finalSalePrice = this.state.data.final_sale_price.replace(/\.0+/, '');
        if (itemStatus === 1) {
            return null;
        } else {
            return (
                <View>
                    <View style={styles.ocjOriginalPriceLayout}>
                        {reduContent !== "" &&
                        <Text style={styles.originalPriceStyle} allowFontScaling={false}>{reduContent}</Text>
                        }
                    </View>
                    <View style={styles.ocjShoppingPriceLayout}>
                        <Text style={styles.shoppingPriceStyle}
                              allowFontScaling={false}>¥{String(finalSalePrice)}</Text>
                        {this.checkNum(this.state.data.integral) &&
                        <View style={{
                            borderColor: '#FF8400',
                            marginLeft: ScreenUtils.scaleSize(20),
                            height: ScreenUtils.scaleSize(30),
                            width: ScreenUtils.scaleSize(30),
                            borderWidth: 1,
                            justifyContent: 'center',
                            backgroundColor: '#FF8400',
                            borderRadius: 2,
                            alignItems: 'center'
                        }}>
                            <Text style={{color: '#FEFEFE', fontSize: ScreenUtils.setSpText(22)}}
                                  allowFontScaling={false}>积</Text>
                        </View>
                        }
                        {this.checkNum(this.state.data.integral) &&
                        <Text style={styles.shoppingCreditStyle}
                              allowFontScaling={false}>{this.state.data.integral}</Text>
                        }
                    </View>
                    {/*渲染跨境综合税*/}
                    {this.renderTax()}
                </View>);
        }
    }

    checkNum(num) {
        if (num) {
            if (num.indexOf('.') !== -1) {
                return (parseInt(num.split('.')[0]) > 0 || parseInt(num.split('.')[1]) > 0);
            } else {
                return parseInt(num) > 0;
            }
        } else {
            return false;
        }
    }

    //渲染编辑状态商品价格区
    renderEShopPrice(itemStatus) {
        let reduContent = "";
        let tempRedu = "比加入时降"
        if (this.state.data.event_end_title !== null
            && this.state.data.event_end_title !== undefined
            && this.state.data.old_item_price !== null
            && this.state.data.old_item_price !== undefined) {
            reduContent = this.state.data.event_end_title + this.state.data.old_item_price
        } else if (this.state.data.old_item_price !== null
            && this.state.data.old_item_price !== undefined) {
            reduContent = tempRedu + parseFloat(this.state.data.old_item_price) - parseFloat(this.state.data.final_sale_price) + "元";
        } else if (this.state.data.redu_title !== null
            && this.state.data.redu_title !== undefined
            && this.state.data.redu_title !== "") {
            reduContent = this.state.data.redu_title;
        }
        if (itemStatus === 2) {
            return (
                <View>
                    <View style={styles.ocjOriginalPriceLayout}>
                        {reduContent !== "" &&
                        <Text style={styles.originalPriceStyle} allowFontScaling={false}>{reduContent}</Text>}
                    </View>
                    <View style={styles.ocjShoppingPriceLayout}>
                        <Text style={styles.shoppingPriceStyle}
                              allowFontScaling={false}>¥{this.state.data.final_sale_price}</Text>
                        {this.checkNum(this.state.data.integral) &&
                        <View style={{
                            borderColor: '#FF8400',
                            marginLeft: ScreenUtils.scaleSize(20),
                            height: ScreenUtils.scaleSize(30),
                            width: ScreenUtils.scaleSize(30),
                            borderWidth: 1,
                            justifyContent: 'center',
                            backgroundColor: '#FF8400',
                            borderRadius: 2,
                            alignItems: 'center'
                        }}>
                            <Text style={{color: '#FEFEFE', fontSize: ScreenUtils.setSpText(22)}}
                                  allowFontScaling={false}>积</Text>
                        </View>}
                        {this.checkNum(this.state.data.integral) &&
                        <Text style={styles.shoppingCreditStyle}
                              allowFontScaling={false}>{this.state.data.integral}</Text>}
                    </View>
                    {/*渲染跨境综合税*/}
                    {this.renderTax()}
                </View>);
        }
    }

    //渲染跨境综合税
    renderTax() {
        let itemTax = 0;
        if (this.state.data.item_tax) {
            itemTax = this.state.data.item_tax;
            if (!this.checkNum(itemTax)) {
                return;
            }
        } else {
            return;
        }
        //是否是跨境通(全球购)
        //if (this.state.data.kjt_yn === "1") {
        return (
            <View style={styles.crossTaxLayout}>
                <Text style={styles.shoppingCrossTaxStyle} allowFontScaling={false}>跨境综合税：</Text>
                <Text style={styles.shoppingCrossTax} allowFontScaling={false}>¥{String(itemTax)}</Text>
                <TouchableOpacity activeOpacity={1} onPress={() => this.props.clickTaxIcon()}>
                    <Image source={require('../Img/cart/askIcon.png')}
                           style={styles.shoppingWenHaoIconStyle}/>
                </TouchableOpacity>
            </View>);
        //}
    }

    //完成渲染商品数量区
    renderFShopCount(itemStatus) {
        if (itemStatus === 1 || itemStatus === 2) {//失效  缺货
            return null;
        } else if (itemStatus === 4) {//可预约
            return (
                <TouchableOpacity
                    activeOpacity={1} style={styles.inputNumberLayout2}
                    onPress={() => this.onAppointmentClick(this.state.data.item_code)}>
                    <Text
                        style={[styles.appointmentStyle, {color: '#E5290D'}]}
                        allowFontScaling={false}>去预约</Text>
                </TouchableOpacity>);
        } else {
            return (
                <View style={styles.NumberLayout}>
                    <Text style={styles.appointmentStyle}
                          allowFontScaling={false}>x {String(this.state.data.item_qty)}</Text>
                </View>);
        }
    }

    //编辑状态数量区
    renderEShopCount(itemStatus) {
        if (itemStatus === 1 || itemStatus === 2) {//失效 缺货
            return null;
        } else if (itemStatus === 4) {//可预约
            return (
                <TouchableOpacity
                    activeOpacity={1} style={styles.inputNumberLayout2}
                    onPress={() => this.onAppointmentClick(this.state.data.item_code)}>
                    <Text
                        style={[styles.appointmentStyle, {color: '#E5290D'}]}
                        allowFontScaling={false}>去预约</Text>
                </TouchableOpacity>);
        } else {
            return (
                <View style={[styles.inputNumberLayout, {flex: 1}]}>
                    <InputNumberText
                        ref={(c) => this.inputNumber = c}
                        maxLength={this.props.maxLength}
                        value={this.state.shopCount}
                        onAdd={(text) => {
                            this.setState({shopCount: text});
                            this.props.onAdd({
                                qty: text,
                                unit_code: this.state.data.unit_code,
                                cart_seq: this.state.data.cart_seq,
                                gift_item_code: this.state.data.gift_item_code,
                                gift_unit_code: this.state.data.gift_unit_code,
                                gift_cart_seq: this.state.data.gift_cart_seq,
                                item_code: this.state.data.item_code,
                            });
                            this.localSelectChange();
                        }}
                        onPlus={(text) => {
                            this.setState({shopCount: text});
                            this.props.onPlus({
                                qty: text,
                                unit_code: this.state.data.unit_code,
                                cart_seq: this.state.data.cart_seq,
                                gift_item_code: this.state.data.gift_item_code,
                                gift_unit_code: this.state.data.gift_unit_code,
                                gift_cart_seq: this.state.data.gift_cart_seq,
                                item_code: this.state.data.item_code,
                            });
                            this.localSelectChange();
                        }}
                        onChange={(text) => {
                            this.setState({shopCount: text})
                            this.props.onSubmitEditing({
                                qty: text,
                                unit_code: this.state.data.unit_code,
                                cart_seq: this.state.data.cart_seq,
                                gift_item_code: this.state.data.gift_item_code,
                                gift_unit_code: this.state.data.gift_unit_code,
                                gift_cart_seq: this.state.data.gift_cart_seq,
                                item_code: this.state.data.item_code,
                            });
                            this.localSelectChange();
                        }}
                        onSubmitEditing={(text) => {
                            this.setState({shopCount: text});
                            this.props.onSubmitEditing({
                                qty: text,
                                unit_code: this.state.data.unit_code,
                                cart_seq: this.state.data.cart_seq,
                                gift_item_code: this.state.data.gift_item_code,
                                gift_unit_code: this.state.data.gift_unit_code,
                                gift_cart_seq: this.state.data.gift_cart_seq,
                                item_code: this.state.data.item_code,
                            });
                            this.localSelectChange();
                        }}
                        onBlur={(text) => {
                            this.setState({shopCount: text});
                            this.props.onBlur({
                                qty: text,
                                unit_code: this.state.data.unit_code,
                                cart_seq: this.state.data.cart_seq,
                                gift_item_code: this.state.data.gift_item_code,
                                gift_unit_code: this.state.data.gift_unit_code,
                                gift_cart_seq: this.state.data.gift_cart_seq,
                                item_code: this.state.data.item_code,
                            });
                            this.localSelectChange();
                        }}
                        width={ScreenUtils.scaleSize(ScreenUtils.scaleSize(50))}
                        inputWidth={ScreenUtils.scaleSize(80)}/>
                </View>);
        }
    }

    render() {
        return (
            <View style={[styles.standaloneRowFront, styles.cartListStyle]}>
                {/*渲染商品可选状态*/}
                {this.renderShopSelect(this.props.cartType, this.state.data.item_status)}
                <TouchableOpacity
                    style={styles.imageLayout} activeOpacity={1}
                    onPress={() => this.props.onShoppingClick(this.state.data.item_code)}>
                    {this.state.data.item_kdp_yn === Constants.Selected &&
                    <Text style={[styles.strideAcrossLayout, styles.backTextWhite]} allowFontScaling={false}>跨</Text>}
                    <Image source={{uri: this.state.data.itemimgurl}} style={styles.imageSize}/>
                    {/*商品库存状态*/}
                    {this.renderWarningBlock(this.state.data.item_status)}
                    {this.renderWarningText(this.state.data.item_status)}
                </TouchableOpacity>
                <TouchableOpacity
                    style={styles.merchandiseLayout} activeOpacity={1}
                    onPress={() => this.props.onShoppingClick(this.state.data.item_code)}>
                    <View style={styles.shopContentStyle}>
                        {/*渲染商品标题*/}
                        {this.renderShopTitle(this.state.data.item_status)}
                        {/*渲染商品规格*/}
                        {this.renderShopColorSize(this.props.cartType, this.state.data.item_status)}
                    </View>
                    {this.props.cartType &&
                    <View style={[styles.merchandiseCredit, {marginTop: ScreenUtils.scaleSize(42)}]}>
                        {/*渲染商品价格*/}
                        {this.renderFShopPrice(this.state.data.item_status)}
                        {/*渲染商品数量区*/}
                        {this.renderFShopCount(this.state.data.item_status)}
                    </View>}
                    {!this.props.cartType &&
                    <View style={[styles.merchandiseCredit, {marginTop: ScreenUtils.scaleSize(62)}]}>
                        {/*渲染商品价格*/}
                        {this.renderEShopPrice(this.state.data.item_status)}
                        {/*渲染商品数量区*/}
                        {this.renderEShopCount(this.state.data.item_status)}
                    </View>}
                </TouchableOpacity>
            </View>
        )
    }
}

//样式定义
const styles = StyleSheet.create({
        standaloneRowFront: {
            backgroundColor: 'white'
        },
        cartListStyle: {
            flexDirection: 'row',
            paddingRight: ScreenUtils.scaleSize(30),
        },
        selectLayout: {
            width: ScreenUtils.scaleSize(84),
            justifyContent: 'center',
        },
        titleSellced: {
            height: ScreenUtils.scaleSize(34),
            width: ScreenUtils.scaleSize(34),
            marginLeft: ScreenUtils.scaleSize(30),
        },
        imageLayout: {
            marginLeft: ScreenUtils.scaleSize(20),
            height: ScreenUtils.scaleSize(195),
            width: ScreenUtils.scaleSize(180),
            borderWidth: 1,
            borderColor: '#EEEEEE',
            justifyContent: 'center',
            alignItems: 'center',
            marginTop: ScreenUtils.scaleSize(13),
        },
        strideAcrossLayout: {
            width: 20,
            height: 20,
            backgroundColor: '#ED1C41',
            justifyContent: 'center',
            alignItems: 'center',
            zIndex: 1,
            position: 'absolute',
            borderRadius: 2,
            left: -1,
            top: 0
        },
        backTextWhite: {
            color: 'white',
            fontSize: ScreenUtils.setSpText(24),
            textAlign: "center",
            backgroundColor: "rgba(0,0,0,0)"
        },
        imageSize: {
            height: ScreenUtils.scaleSize(152),
            width: ScreenUtils.scaleSize(160),
            zIndex: 0,
            position: 'absolute',
            resizeMode: 'contain'
        },
        outOfStock: {
            width: ScreenUtils.scaleSize(180),
            height: 25,
            backgroundColor: '#ED1C41',
            zIndex: 1,
            borderRadius: 2,
            opacity: 0.75,
            position: 'absolute',
            bottom: 0,
            left: 0,
        },
        inventory: {
            width: ScreenUtils.scaleSize(180),
            position: 'absolute',
            bottom: 0,
            height: 25,
            zIndex: 10,
            left: 0,
            alignItems: "center",
            justifyContent: "center"
        },

        merchandiseLayout: {
            marginLeft: ScreenUtils.scaleSize(20),
            justifyContent: 'space-between',
            flex: 1,
            backgroundColor: 'white',
            marginTop: ScreenUtils.scaleSize(10)
        },
        fontWeight: {
            marginLeft: 0,
            marginRight: 5,
            fontSize: ScreenUtils.setSpText(28),
            color: "#333333",
            alignSelf: "flex-start",
        },
        commercialSpecificationLayout: {
            height: ScreenUtils.scaleSize(40),
            justifyContent: 'space-between',
            alignItems: 'center',
            paddingRight: 5,
            flexDirection: 'row',
            backgroundColor: '#F0F0F0',
            marginBottom: ScreenUtils.scaleSize(2)
        },
        colorStyle: {
            color: "#666666",
            fontSize: ScreenUtils.setSpText(24)
        },
        commercialSpecificationImgStyle: {
            width: ScreenUtils.scaleSize(7),
            height: ScreenUtils.scaleSize(10),
            resizeMode: "contain"
        },
        merchandiseCredit: {
            flexDirection: 'row',
            flex: 1,
            justifyContent: 'space-between',
        },
        ocjOriginalPriceLayout: {
            alignSelf: 'flex-start',
            height: 18,
            backgroundColor: '#FFF1F4',
            borderRadius: 2,
            marginTop: 3,
            justifyContent: 'center'
        },
        originalPriceStyle: {
            color: '#E5290D',
            fontSize: ScreenUtils.setSpText(20),
            alignSelf: 'center',
            paddingHorizontal: 3,
        },
        ocjShoppingPriceLayout: {
            flexDirection: 'row',
            alignItems: "center",
        },
        shoppingPriceStyle: {
            color: '#E5290D',
            fontSize: ScreenUtils.setSpText(34),
        },
        shoppingCreditIconStyle: {
            width: ScreenUtils.scaleSize(56),
            height: ScreenUtils.scaleSize(30),
            marginLeft: ScreenUtils.scaleSize(7),
            resizeMode: "contain"
        },
        shoppingCreditStyle: {
            color: '#FA6923',
            marginLeft: ScreenUtils.scaleSize(5),
        },
        crossTaxLayout: {
            flexDirection: 'row',
            alignItems: "center",
        },
        shoppingCrossTaxStyle: {
            color: '#999999',
            fontSize: ScreenUtils.setSpText(22),
        },
        shoppingCrossTax: {
            color: '#999999',
            marginLeft: ScreenUtils.scaleSize(5),
            fontSize: ScreenUtils.setSpText(24)
        },
        shoppingWenHaoIconStyle: {
            width: ScreenUtils.scaleSize(27),
            height: ScreenUtils.scaleSize(27),
            marginLeft: ScreenUtils.scaleSize(8),
            resizeMode: "contain"
        },
        inputNumberLayout: {
            flexDirection: 'row',
            marginTop: ScreenUtils.scaleSize(5),
            justifyContent: 'flex-end',
        },
        inputNumberLayout2: {
            flexDirection: 'row',
            width: ScreenUtils.scaleSize(120),
            height: ScreenUtils.scaleSize(50),
            borderWidth: 1,
            borderColor: '#E5290D',
            borderRadius: 2,
            justifyContent: 'center',
            alignItems: 'center',
            marginTop: ScreenUtils.scaleSize(13),

        },
        NumberLayout: {
            justifyContent: 'center',
            marginTop: ScreenUtils.scaleSize(40),
            alignItems: 'flex-end'
        },
        appointmentStyle: {
            fontSize: ScreenUtils.setSpText(28),
            color: '#333333',
        },
        shopContentStyle: {
            height: ScreenUtils.scaleSize(60),
        }

    }
);
ShoppingRender.propTypes = {
    onShoppingClick: PropTypes.func,
    onCommercialSpecification: PropTypes.func,
    onAdd: PropTypes.func,
    onPlus: PropTypes.func,
    onSubmitEditing: PropTypes.func,
    onBlur: PropTypes.func,
    onSelected: PropTypes.func,
    clickTaxIcon: PropTypes.func,
};
ShoppingRender.defaultProps = {
    value: '1',
};
export default ShoppingRender
