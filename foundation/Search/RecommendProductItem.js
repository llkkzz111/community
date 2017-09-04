/**
 * Created by Administrator on 2017/5/15.
 */
'use strict';
import React  from 'react';
import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    TouchableOpacity
} from 'react-native';

import {Actions} from 'react-native-router-flux';
const {width} = Dimensions.get('window');

export default class RecommendProductItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            displayDirection: this.props.displayDirection
        }
    }

    render() {

        return (
            <View style={this.state.displayDirection == 'row' ? styles.rowContainers : styles.columnContainers}>
                <TouchableOpacity activeOpacity={1} onPress={this._jump}>
                    <View>
                        <Image style={this.state.displayDirection == 'row' ? styles.rowImg : styles.columnImg}
                               source={{uri: 'http://cdnimg.ocj.com.cn/item_images/item/15/17/1967/15171967L.jpg'}}/>
                    </View>
                    <View style={this.state.displayDirection == 'row' ? styles.rowImgTitleBg : styles.columnImgTitleBg}>
                        <Image style={styles.groupImgBg} source={require('../Img/home/group_buy.png')}/>
                        <Text style={styles.pImgTitle} allowFontScaling={false}>团购中 2天12小时66分</Text>
                    </View>
                </TouchableOpacity>
                {this.state.displayDirection == 'row' ?
                    <View>
                        <View style={{flexDirection: 'row', marginTop: 10, alignItems: 'flex-start',}}>
                            <View style={{flex: 1}}>
                                <Text style={styles.groupProductStyle} allowFontScaling={false}><Text style={styles.groupTitle} allowFontScaling={false}>全球购</Text><Text>
                                    马克库班 2017 夏季新款 劲爆来袭</Text></Text>
                            </View>
                        </View>
                        <View style={{flexDirection: 'row', justifyContent: 'space-between'}}>
                            <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                <Text style={styles.priceStyle} allowFontScaling={false}>￥100</Text>
                                <Text style={styles.priceProvious} allowFontScaling={false}>￥130</Text>
                            </View>
                            <View style={styles.giftBg}>
                                <Text style={styles.giftTitleStyle} allowFontScaling={false}>赠品</Text>
                            </View>
                        </View>
                        <Text style={styles.buyNumberStyle} allowFontScaling={false}>
                            5918人已经购买
                        </Text>
                    </View>
                    :
                    <View style={{flex: 1, marginLeft: 10}}>
                        <View style={{flexDirection: 'row'}}>
                            <View style={{flex: 1}}>
                                <Text style={styles.groupProductStyle} allowFontScaling={false}><Text style={styles.groupTitle} allowFontScaling={false}>全球购</Text><Text>
                                    马克库班 2017 夏季新款 劲爆来袭</Text></Text>
                            </View>
                        </View>
                        <View style={styles.rowGiftBg}>
                            <Text style={styles.giftTitleStyle} allowFontScaling={false}>赠品</Text>
                        </View>
                        <View style={{flexDirection: 'row', alignItems: 'center', marginTop: 20}}>
                            <Text style={styles.priceStyle} allowFontScaling={false}>￥100</Text>
                            <Text style={styles.priceProvious} allowFontScaling={false}>￥130</Text>
                        </View>
                        <Text style={styles.rowBuyNumberStyle} allowFontScaling={false}>
                            5918人已经购买
                        </Text>
                    </View>
                }
            </View>
        )
    }

    _jump = () => {
        // Actions.classifyToGoodsDetailMain();
    }
}

const styles = StyleSheet.create({
    rowContainers: {
        backgroundColor: '#FFFFFF',
        padding: 10,
        flexDirection: 'column',
        borderWidth: 0.3,
        borderColor: '#DDDDDD',
        justifyContent: 'flex-start',
        width: width / 2,
    },
    columnContainers: {
        backgroundColor: '#FFFFFF',
        padding: 10,
        flexDirection: 'row',
        borderWidth: 0.3,
        borderColor: '#DDDDDD',
        justifyContent: 'flex-start',
    },
    groupImgBg: {
        width: 15,
        height: 15
    },
    rowImg: {
        width: (width - 20) / 2,
        height: 240,

    },
    columnImg: {
        width: 150,
        height: 100,
    },
    rowImgTitleBg: {
        width: (width - 20) / 2,
        height: 25,
        backgroundColor: '#De5C49',
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        position: 'absolute',
        left: 0,
        bottom: 0,
        zIndex: 10,
        resizeMode: 'cover',
    },
    columnImgTitleBg: {
        width: 150,
        height: 25,
        backgroundColor: '#De5C49',
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        position: 'absolute',
        left: 0,
        bottom: 0,
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
        color: '#E5290D',
        fontSize: 12,
        backgroundColor: '#FCE9E6',
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
    priceProvious: {
        color: '#999999',
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
    rowBuyNumberStyle: {
        color: '#999999',
        fontSize: 11,
        // marginTop: 15,
    },
    buyNumberStyle: {
        color: '#999999',
        fontSize: 11,
        marginTop: 5
    }
});

RecommendProductItem.propTypes = {
    displayDirection: React.PropTypes.string,
}
