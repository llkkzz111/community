/**
 * Created by Administrator on 2017/5/7.
 */
/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Dimensions,
    Text,
    View,
    TouchableOpacity,
    Image
} from 'react-native';
import IonicIcons from 'react-native-vector-icons/Ionicons'
const {width, hieght} = Dimensions.get('window');


export default class ShopInfo extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (

            <View style={styles.shopInforViewStyle}>
                <View style={styles.shopContentViewStyle}>
                    <View style={styles.ShopTitleViewStyle}>
                        <View style={styles.ShopImgViewStyle}>
                            <Image source={require('../Img/cart/dianjiang.png')} width="100" height="150"></Image>
                        </View>
                        <View style={styles.shopCommentViewStyle}>
                            <Text allowFontScaling={false}>典匠官方旗舰店</Text>
                            <Text style={{paddingTop: 10}} allowFontScaling={false}>匠人手艺打造美好生活</Text>
                        </View>
                    </View>
                    <View style={styles.goToShopViewStyle}>
                        <TouchableOpacity activeOpacity={1}>
                            <View>
                                <Text style={styles.goToShopTextStyle} allowFontScaling={false}>进入店铺</Text>
                            </View>
                        </TouchableOpacity>
                    </View>
                </View>
                <View style={styles.additionalInforViewStyle}>
                    <View style={styles.additionalChildViewStyle}>
                        <Text allowFontScaling={false}>40</Text>
                        <Text allowFontScaling={false}>全部商品</Text>
                    </View>
                    <View style={styles.additionalChildViewStyle}>
                        <Text allowFontScaling={false}>2</Text>
                        <Text allowFontScaling={false}>商品上新</Text>
                    </View>
                    <View style={styles.additionalChildViewStyle}>
                        <Text allowFontScaling={false}>2039</Text>
                        <Text allowFontScaling={false}>收藏人数</Text>
                    </View>
                </View>
            </View>
        )
    }
}

const propTypes = {};

const styles = StyleSheet.create({
    shopInforViewStyle: {
        flexDirection: 'column',
        justifyContent: 'flex-start',
    },
    shopContentViewStyle: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
    },
    ShopTitleViewStyle: {
        flexDirection: 'row',
        justifyContent: 'flex-start',

    },
    ShopImgViewStyle: {
        marginLeft: 20,
    },
    shopCommentViewStyle: {
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'flex-start',
        marginLeft: 10,
    },
    goToShopViewStyle: {
        justifyContent: 'flex-start',
        width: width / 3,
        paddingLeft: 40,
    },
    goToShopTextStyle: {
        borderWidth: 0.5,
        borderColor: '#ED1C41',
        color: '#ED1C41',
        width: 80,
        height: 30,
        paddingLeft: 10,
        paddingRight: 10,
        paddingTop: 5,

    },
    additionalInforViewStyle: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        flex: 1,
        marginTop: 10,
    },
    additionalChildViewStyle: {
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        width: width / 3,
        height: 40,
        borderRightWidth: 0.8,
        borderRightColor: '#EEEEEE',
    },
});
