/**
 * Created by Administrator on 2017/5/12.
 */


import React, { Component,PropTypes } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    ListView,
    TouchableOpacity,
    Image
} from 'react-native';

export default class PromotionContents extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <View style={styles.promotionContentsStyle}>
                <View style={styles.promotionContentStyle}>
                    <Text allowFontScaling={false} style={styles.categoryStyle}>【跨品类】</Text>
                    <Text allowFontScaling={false} style={styles.promotionContentTextStyle}>满1000减100，满100减1，满…</Text>
                </View>
                <Text style={styles.presentationalStyle}>查看赠品  ＞</Text>
            </View>

    )
    }


}

PromotionContents.propTypes = {

};

PromotionContents.defaultProps = {

};



const styles = StyleSheet.create({
    promotionContentsStyle:{
        backgroundColor:"#FFFFFF",
        padding:10,
        flexDirection:'row',
        justifyContent:'space-between',
        alignItems:'center',
        height:60,
        marginBottom:10
    },
    promotionContentStyle:{
        flexDirection:'row',
    },
    categoryStyle:{
        color:'#E5290D',
    },
    promotionContentTextStyle:{
        color:'#2A2A2A',
    },
    presentationalStyle:{
        color:'#DF2928',
    },



    footPointGoods:{
        padding:10,
        flexDirection:'row',
        justifyContent:'flex-start',
        alignItems:'flex-start',
        borderTopWidth:0.5,
        borderColor: '#DDDDDD',
    },
    imgStyle:{
        borderColor:"#eeeeee",
        borderWidth:1
    },
    goodsInfor:{
        flex:1,
        flexDirection:'column',
        justifyContent:'space-between',
        alignItems:'flex-start',
        marginLeft:5,
    },
    prductNameViewStyle:{

    },
    prductNameTextStyle:{
        flexWrap:"wrap",
        color:'#333333',
    },
    priceViewStyle:{
        flex:1,
        flexDirection:'row',
        marginTop:15
    },
    priceTextStyle:{
        color: '#E5290D',
        marginRight:10,
    },
    unPriceTextStyle:{
        textDecorationLine:"line-through",
        marginRight:10,
    },
    integralStyle:{
        backgroundColor:'orange',
        color:'#FEFEFE',
        marginRight:5
    },
    integralValueStyle:{
        color:'orange',
    },
    alreadyBuyViewStyle:{
        flex:1,
        flexDirection:'row',
        alignItems:'flex-end',

    },
    cartViewStyle:{
        flex:1,
        alignItems:'flex-end',
    }
});