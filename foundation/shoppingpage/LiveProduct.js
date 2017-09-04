/**
 * Created by Administrator on 2017/5/12.
 */

import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image
} from 'react-native';
import InputNumberText from  './InputNumberText';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';

export default class LiveProduct extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            liveProductData: this.props.liveProductData
        }
    }

    render() {
        let {liveProductData, liveType} = this.props;

        return (
            <View style={styles.footPointGoods}>
                <View style={styles.imgStyle}>
                    <Image source={{uri: liveProductData.productImgSrc}}
                           style={liveType === '2' ? styles.videoImgStyle : styles.productImgStyle}/>
                </View>
                <View style={styles.goodsInfor}>
                    {
                        liveType === '2' ?
                            <View style={styles.productNameViewStyle}>
                                <Text style={styles.productNameTextStyle} allowFontScaling={false}>
                                    节目名称／商品名称 {liveProductData.productName}
                                </Text>
                            </View>
                            :
                            <View style={styles.productNameViewStyle}>
                                <Text style={styles.productNameTextStyle} allowFontScaling={false}>
                                    {
                                        liveProductData.productType === '' ?
                                            liveProductData.productName
                                            :
                                            "【" + liveProductData.productType + "】" + liveProductData.productName
                                    }
                                </Text>
                            </View>
                    }
                    {
                        liveType === '2' ?
                            <View style={styles.videoMakerViewStyle}>
                                <Text style={styles.videoMaker} allowFontScaling={false}>{liveProductData.videoMaker}</Text>
                            </View>
                            :
                            <View style={styles.priceViewStyle}>
                                <Text style={styles.priceTextStyle} allowFontScaling={false}>￥ {liveProductData.productPrice}</Text>
                                {
                                    liveProductData.originPrice === '' ?
                                        <Text style={styles.originPriceTextStyle} allowFontScaling={false}/>
                                        :
                                        <Text style={styles.originPriceTextStyle} allowFontScaling={false}>￥ {liveProductData.originPrice}</Text>
                                }
                            </View>
                    }
                    {
                        liveType === '2' ?
                            <View style={styles.videoTimeViewStyle}>
                                <Text style={styles.videoDateStyle} allowFontScaling={false}>{liveProductData.videoDate} </Text>
                                <Text style={styles.videoTimeStyle} allowFontScaling={false}>{liveProductData.videoTime} 开播</Text>
                            </View>
                            :
                            <View style={styles.alreadyBuyViewStyle}>
                                <View>
                                    <Text style={styles.alreadyBuyTextStyle} allowFontScaling={false}>{liveProductData.broughtCount} 人已购买</Text>
                                </View>
                                <View style={styles.cartViewStyle}>
                                    <InputNumberText
                                        maxLength={this.props.maxLength}
                                        value={1}
                                        onAdd={(text) => {
                                            this.props.onAdd && this.props.onAdd(text);
                                        }}
                                        onPlus={(text) => {
                                            this.props.onPlus && this.props.onPlus(text);
                                        }}
                                        onChange={(text) => {
                                            this.props.onChange && this.props.onChange(text);
                                        }}
                                        onBlur={(text) => {
                                            this.props.onBlur && this.props.onBlur(text);
                                        }}
                                    />
                                    <Image source={require('../Img/me/cart.png')} style={styles.toCartImgStyle}/>
                                </View>
                            </View>
                    }
                </View>
            </View>
        )
    }
}

LiveProduct.propTypes = {};

LiveProduct.defaultProps = {};


const styles = StyleSheet.create({
    HistoryStyle: {
        backgroundColor: "#FFFFFF",
    },
    promotionGoodsList: {
        marginBottom: 5
    },
    footPointGoods: {
        //flex:1,
        padding: 10,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'flex-start',
        //marginBottom:10,
        backgroundColor: Colors.background_white,
        borderColor: Colors.line_grey,
        borderTopWidth: 1
    },
    productImgStyle: {
        height: 120,
        width: 120,
    },
    videoImgStyle: {
        height: 100,
        width: 140,
    },
    imgStyle: {
        borderColor: Colors.line_grey,
        borderWidth: 1
    },
    goodsInfor: {
        flex: 1,
        //height:120,
        paddingLeft: 5
    },
    productNameViewStyle: {
        height: 30
    },
    productNameTextStyle: {
        flexWrap: "wrap",
        color: Colors.text_black,
        fontSize: Fonts.standard_normal_font(),
    },
    priceViewStyle: {
        flexDirection: 'row',
        marginTop: 20,
        marginBottom: 25,
    },
    priceTextStyle: {
        color: Colors.main_color,
        marginRight: 10,
        fontSize: Fonts.page_title_font(),
    },
    originPriceTextStyle: {
        textDecorationLine: "line-through",
        marginRight: 10,
        fontSize: Fonts.secondary_font(),
        paddingTop: 5
    },
    videoMakerViewStyle: {
        marginTop: 30,
        marginBottom: 10,
    },
    videoMaker: {
        fontSize: Fonts.secondary_font(),
        color: Colors.text_dark_grey
    },
    videoTimeViewStyle: {
        flexDirection: 'row'
    },
    videoDateStyle: {
        fontSize: Fonts.secondary_font(),
        color: Colors.text_light_grey
    },
    videoTimeStyle: {
        fontSize: Fonts.secondary_font(),
        color: Colors.line_type,
        marginLeft: 10,
    },
    alreadyBuyViewStyle: {
        //flex:1,
        flexDirection: 'row',
        alignItems: 'flex-start',
        justifyContent: 'space-between'

    },
    alreadyBuyTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: Fonts.standard_normal_font(),
    },
    cartViewStyle: {
        //flex:1,
        alignItems: 'flex-start',
        flexDirection: 'row'
    },
    toCartImgStyle: {
        height: 25,
        width: 25,
        marginLeft: 5
    }
});