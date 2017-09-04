/**
 * Created by Administrator on 2017/5/15.
 */
'use strict';
import React from 'react';
import {
    View,
    Text,
    Image,
    StyleSheet,
    TouchableOpacity
} from 'react-native';
import Colors from '../../app/config/colors';
import Fonts from '../../app/config/fonts';
import {Actions} from 'react-native-router-flux';

export default class RecommendProductItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            displayDirection: this.props.displayColumn
        }
    }

    render() {
        return (
            <TouchableOpacity
                style={styles.columnContainers}
                activeOpacity={1}
                onPress={this._jump}>
                <View>
                    <Image style={styles.columnImg}
                           source={{uri: 'http://cdnimg.ocj.com.cn/item_images/item/15/17/1967/15171967L.jpg'}}/>
                </View>
                <View style={styles.columnImgTitleBg}>
                    <Image style={styles.groupImgBg} source={require('../Img/home/group_buy.png')}/>
                    <Text style={styles.pImgTitle} allowFontScaling={false}>团购中 2天12小时66分</Text>
                </View>
                <View style={{flex: 1, marginLeft: 10}}>
                    <View style={{flexDirection: 'row'}}>
                        <View style={{flex: 1}}>
                            <Text style={styles.groupProductStyle} allowFontScaling={false}>
                                {this.props.data.groupbuy_YN == '1' ?
                                    <Text style={styles.globalBuy} allowFontScaling={false}>【全球购】 </Text> : null}
                                <Text allowFontScaling={false}>{this.props.data.item_NAME}</Text>
                            </Text>
                        </View>
                    </View>
                    <View style={{flex: 1, marginTop: 10}}>
                        <View style={{flexDirection: 'row', alignItems: 'flex-end'}}>
                            <Text style={styles.priceStyle} allowFontScaling={false}>￥{this.props.data.mobile_PRICE}</Text>
                            <Text style={styles.pricePrevious} allowFontScaling={false}>￥{this.props.data.last_Sale_Price}</Text>
                        </View>
                    </View>
                    <Text style={styles.buyNumberStyle} allowFontScaling={false}>5918人已经购买</Text>
                    <View style={{height: 1, backgroundColor: Colors.line_grey, marginTop: 5,}}/>
                </View>
            </TouchableOpacity>
        )
    }

    _jump = () => {
        Actions.GoodsDetailMain({itemcode: this.props.data.item_CODE + ""});
    }
}

const styles = StyleSheet.create({
    columnContainers: {
        backgroundColor: Colors.background_white,
        padding: 10,
        flexDirection: 'row',
        justifyContent: 'flex-start',
    },
    groupImgBg: {
        width: 15,
        height: 15
    },
    columnImg: {
        width: 150,
        height: 100,
    },
    columnImgTitleBg: {
        width: 150,
        height: 25,
        backgroundColor: '#De5C49',
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        position: 'absolute',
        left: 10,
        bottom: 10,
        zIndex: 10,
        resizeMode: 'cover',
    },
    pImgTitle: {
        color: 'white',
        fontSize: 12,
        marginLeft: 5
    },
    groupBg: {
        backgroundColor: '#FCE9E6',
        width: 50,
        height: 20,
        borderRadius: 3,
        alignItems: 'center',
        justifyContent: 'center'
    },
    groupTitle: {
        color: Colors.text_black,
        fontSize: Fonts.standard_normal_font(),
        textAlign: 'center',
        textAlignVertical: 'center',
    },
    groupProductStyle: {
        color: '#333333',
        fontSize: 13,
        //fontWeight: 'bold',
    },
    rowPriceStyle: {
        color: '#E5290D',
        fontSize: 15,
        marginTop: 15
    },
    priceStyle: {
        color: '#E5290D',
        fontSize: 15
    },
    pricePrevious: {
        color: '#999999',
        marginLeft: 5,
        fontSize: 11,
        textDecorationLine: 'line-through'
    },
    rowGiftBg: {
        backgroundColor: '#E5290D',
        width: 50,
        height: 20,
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: 3,
        marginTop: 15,
    },
    giftBg: {
        backgroundColor: '#E5290D',
        width: 50,
        height: 20,
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: 3
    },
    giftTitleStyle: {
        color: 'white',
        fontSize: 12
    },
    buyNumberStyle: {
        color: '#999999',
        fontSize: Fonts.secondary_font(),
    },
    globalBuy: {
        marginRight: 10,
        color: Colors.text_black,
        fontSize: Fonts.standard_normal_font(),
    }
});

RecommendProductItem.propTypes = {
    displayDirection: React.PropTypes.string,
}
