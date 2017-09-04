/**
 * Created by Administrator on 2017/5/29.
 */
//视频主页抢购商品
import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableWithoutFeedback,
    Image,
} from 'react-native';
import * as ScreenUtil from '../utils/ScreenUtil';

import {Actions} from 'react-native-router-flux';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';

export default class RushToBuyProduct extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {}
    }


    rushToBuy(v) {
        Actions.GoodsDetailMain({'itemcode': v});
    }

    render() {
        let {rushToBuyItem} = this.props;
        return (
            <TouchableWithoutFeedback onPress={() => {
                this.rushToBuy(rushToBuyItem.contentCode)
            }}>
                <View>
                    <View style={styles.bgArrow}>
                        {this.props.keyIndex === 0 ?
                            <Image source={require('../Img/order/icon_gift_top_f4_@2x.png')} style={styles.bgArrowImg}/>
                            : null}
                    </View>
                    <View style={[styles.rushToBuyItem, {backgroundColor: '#F4F4F4'}]}>

                        <Text style={styles.itemName} numberOfLines={2}
                              allowFontScaling={false}>{rushToBuyItem.title}</Text>

                        <View style={styles.priceAndBuyView}>
                            <View style={{
                                flexDirection: 'row',
                                flex: 1,
                                alignItems: 'flex-end'
                            }}>
                                <View style={{marginBottom: ScreenUtil.scaleSize(2)}}>
                                    <Text style={styles.rushToBuy} allowFontScaling={false}>抢先价</Text>
                                </View>
                                <Text style={styles.rushToBuyPrice} allowFontScaling={false}>￥
                                    <Text style={{fontSize: ScreenUtil.setSpText(30)}}
                                          allowFontScaling={false}>{parseInt(rushToBuyItem.salePrice.split('.')[1]) > 0 ?
                                        rushToBuyItem.salePrice : rushToBuyItem.salePrice.split('.')[0]}
                                    </Text></Text>

                                {
                                    rushToBuyItem.originalPrice && Number(rushToBuyItem.originalPrice) > 0 ?
                                        <Text
                                            style={styles.originalPrice}
                                            allowFontScaling={false}>￥{rushToBuyItem.originalPrice}</Text>
                                        :
                                        null
                                }

                            </View>
                            <View style={styles.buySoonBgView}>
                                <Text style={styles.buySoon} allowFontScaling={false}>立即抢购</Text>
                            </View>
                        </View>
                    </View></View>
            </TouchableWithoutFeedback>

        )
    }


}


const styles = StyleSheet.create({
    itemName: {
        color: '#333',
        fontSize: ScreenUtil.setSpText(24),
    },
    rushToBuyItem: {
        marginHorizontal: ScreenUtil.scaleSize(20),
        paddingLeft: ScreenUtil.scaleSize(20),
        paddingRight: ScreenUtil.scaleSize(16),
        paddingVertical: ScreenUtil.scaleSize(20),
    },
    bgArrow: {
        height: ScreenUtil.scaleSize(20),
        marginBottom: ScreenUtil.scaleSize(2) * -1,
    },
    bgArrowImg: {
        marginLeft: ScreenUtil.scaleSize(110),
        width: ScreenUtil.scaleSize(30),
        height: ScreenUtil.scaleSize(20),
    },

    itemImg: {
        width: ScreenUtil.scaleSize(60),
        height: ScreenUtil.scaleSize(60),
    },
    priceAndBuyView: {
        flexDirection: 'row',
        justifyContent: 'flex-end'
    },

    rushToBuyImg: {
        backgroundColor: 'rgba(0, 0, 0, 0)',
        width: ScreenUtil.scaleSize(120),
        height: ScreenUtil.scaleSize(40),
        resizeMode: 'stretch',
    },
    rushToBuy: {
        fontSize: Fonts.secondary_font(),
        color: Colors.main_color,
        includeFontPadding: false,
    },
    rushToBuyPrice: {
        fontSize: ScreenUtil.setSpText(24),
        color: Colors.main_color,
        marginLeft: ScreenUtil.scaleSize(5),
        marginRight: ScreenUtil.scaleSize(5),
        includeFontPadding: false,
        textAlignVertical: 'bottom'
    },
    originalPrice: {
        textDecorationLine: "line-through",
        fontSize: Fonts.secondary_font(),
        color: Colors.text_light_grey,
        includeFontPadding: false,
    },
    buySoon: {
        fontSize: ScreenUtil.setSpText(22),
        color: '#fff',
        textAlignVertical: 'center',
        includeFontPadding: false,
        borderRadius: ScreenUtil.scaleSize(4),
        backgroundColor: 'transparent'
    },
    buySoonBgView: {
        marginTop: ScreenUtil.scaleSize(10),
        width: ScreenUtil.scaleSize(130),
        borderRadius: ScreenUtil.scaleSize(4),
        backgroundColor: '#F14967',
        height: ScreenUtil.scaleSize(40),
        justifyContent: 'center',
        alignItems: 'center',
    }
});
