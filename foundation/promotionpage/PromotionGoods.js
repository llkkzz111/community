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


export default class PromotionGoods extends Component {
    constructor(props) {
        super(props);
        this.state = {
            dataSource: this.props.dataSource,
        }
    }

    render() {
        return (
            <ListView
                dataSource={this.state.dataSource}
                //contentContainerStyle={styles.promotionGoodsList}
                renderRow={(data) => this.renderRow(data)}
            >
            </ListView>
        )
    }

    renderRow(data){
        return (
            <View style={styles.footPointGoods}>
                <View style={styles.imgStyle}>
                    <Image source={{uri:data.productImgSrc}} style={styles.productImgStyle}></Image>
                </View>
                <View style={styles.goodsInfor}>
                    <View style={styles.productNameViewStyle}>
                        <Text allowFontScaling={false} style={styles.productNameTextStyle}>
                            {data.productName}
                        </Text>
                    </View>
                    <View style={styles.specialPiceView}>
                        <Text allowFontScaling={false} style={styles.specialPiceText}>手机专享价</Text>
                    </View>
                    <View style={styles.priceViewStyle}>
                        <Text allowFontScaling={false} style={styles.priceTextStyle}>￥ {data.prductPrice}</Text>
                        <View style={{ flexDirection: 'row'}}>
                            <Text allowFontScaling={false} style={styles.integralStyle}>积分</Text>
                            <Text allowFontScaling={false} style={styles.integralValueStyle}>{data.integral} </Text>
                        </View>
                    </View>
                    <View style={styles.alreadyBuyViewStyle}>
                        <Text allowFontScaling={false} style={styles.alreadyBuyTextStyle}>{data.broughtCount}件已售</Text>
                        <View style={styles.cartViewStyle}>
                            <Image source={require('../Img/me/cart.png')}  style={styles.toCartImgStyle}></Image>
                        </View>
                    </View>
                </View>
            </View>
        );

    }
}

PromotionGoods.propTypes = {

};

PromotionGoods.defaultProps = {

};



const styles = StyleSheet.create({
    HistoryStyle:{
        backgroundColor:"#FFFFFF",
    },
    promotionGoodsList:{
        marginBottom:5
    },
    footPointGoods:{
        padding:10,
        flexDirection:'row',
        justifyContent:'flex-start',
        alignItems:'flex-start',
        marginBottom:10,
        backgroundColor:"#FFFFFF",
    },
    productImgStyle:{
        height: 120,
        width: 120,
    },
    imgStyle:{
        borderColor:"#DDDDDD",
        borderWidth:1
    },
    goodsInfor:{
        flex:1,
        flexDirection:'column',
        justifyContent:'space-between',
        alignItems:'flex-start',
        marginLeft:5,
    },
    productNameViewStyle:{
        height:30
    },
    specialPiceView:{
        marginTop:10,
        backgroundColor:'pink',

    },
    specialPiceText:{
        color:'#E5290D',
        paddingLeft:5,
        paddingRight:5,
    },
    productNameTextStyle:{
        flexWrap:"wrap",
        color:'#333333',
    },
    priceViewStyle:{
        flex:1,
        flexDirection:'row',
        marginTop:10
    },
    priceTextStyle:{
        color: '#E5290D',
        marginRight:10,
        fontSize:16
    },
    unPriceTextStyle:{
        textDecorationLine:"line-through",
        marginRight:10,
    },
    integralStyle:{
        backgroundColor:'#FFC033',
        color:'#FEFEFE',
        marginRight:5,
        paddingLeft:3,
        paddingRight:3,
    },
    integralValueStyle:{
        color:'#FFC033',
        fontSize:14,
    },
    alreadyBuyViewStyle:{
        flex:1,
        flexDirection:'row',
        alignItems:'flex-end',

    },
    alreadyBuyTextStyle:{
        color:'#666666',
    },
    cartViewStyle:{
        flex:1,
        alignItems:'flex-end',
    },
    toCartImgStyle:{
        height: 30,
        width: 30
    }
});
