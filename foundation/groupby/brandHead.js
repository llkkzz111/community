/**
 * Created by lume on 2017/6/10.
 *
 * 今日团购首页组件
 */

import React, {
    PureComponent,
    PropTypes
} from 'react'

import {
    View,
    Text,
    Image,
    Dimensions,
    TouchableOpacity,
    ScrollView,
    StyleSheet,
    FlatList
} from 'react-native'
import {Actions} from 'react-native-router-flux';
let deviceWidth = Dimensions.get('window').width;
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';

export default class BrandHead extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
    }

    render(){
        return (
            <View style={styles.scrollViewItemTitle}>
                <View style={styles.itemTitleCenter}>
                    <Image
                        source={{uri: this.props.brandsGoods[0].countryImgUrl}}
                        style={{
                            width:ScreenUtils.scaleSize(60),
                            height:ScreenUtils.scaleSize(60)
                        }}
                    />
                    <View style={styles.itemLeft}>
                        <Text style={styles.itemLeftName} allowFontScaling={false}>{this.props.brandsGoods[0].countryName}</Text>
                        <Text style={styles.itemLeftInfo} allowFontScaling={false}>{this.props.brandsGoods[0].countryCode}折起</Text>
                    </View>
                </View>
                <TouchableOpacity activeOpacity={1} onPress={() => {
                    Actions.Group({pageID:'BrandGroup'})
                }} style={styles.itemTitleRight}>
                    <Text style={styles.rankingStyle} allowFontScaling={false}>到品牌页逛逛</Text>
                    <Image
                        source={require('../Img/groupbuy/Icon_right_gray_@2x.png')}
                        style={{
                            width:ScreenUtils.scaleSize(16),
                            height:ScreenUtils.scaleSize(24)
                        }}
                    />
                </TouchableOpacity>
            </View>
        )
    }

    // _renderBrand =

}




const styles = StyleSheet.create({
    scrollViewItemTitle:{
        flexDirection:"row",
        height:ScreenUtils.scaleSize(105),
        alignItems:"center",
        backgroundColor:Colors.text_white,
        justifyContent:"space-between",
        borderBottomColor:"#dddddd",
        borderBottomWidth:1,
    },
    itemTitleCenter:{
        flexDirection:"row",
        alignItems:"center",
        justifyContent:"center",
        marginLeft:ScreenUtils.scaleSize(30),
    },
    itemLeft:{
        justifyContent:"flex-start",
        marginLeft:ScreenUtils.scaleSize(10)
    },
    itemLeftName:{
        color:Colors.text_black,
        fontSize:ScreenUtils.setSpText(28),
    },
    itemLeftInfo:{
        color:Colors.main_color,
        fontSize:ScreenUtils.setSpText(24),
    },
    itemTitleRight:{
        flexDirection:"row",
        position:"absolute",
        right:ScreenUtils.scaleSize(30),
    },
    popularityStyle:{
        color:Colors.text_black,
        fontSize:ScreenUtils.setSpText(32),
        marginLeft:ScreenUtils.setSpText(10)
    },
    rankingStyle:{
        fontSize:ScreenUtils.setSpText(26),
        marginRight:ScreenUtils.setSpText(10)
    }

})