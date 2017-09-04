/**
 * Created by dhy on 2017/5/11.
 * DiscountCoupon 商品折扣券列表
 *
 */
import React from 'react'
import {
    View,
    Text,
    StyleSheet,
    Dimensions,
    Modal,
    Image,
    ScrollView,
    FlatList,
    TouchableOpacity
} from 'react-native'
//自适应
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
var {width} = Dimensions.get('window');
class CartDiscountCoupon extends React.PureComponent {
    constructor(props) {
        super(props);
    }

    renderSatisfy(satisfyArr, satisfyPrice) {
        if (satisfyPrice === undefined
            //|| satisfyPrice === 0
            || satisfyArr === null
            || satisfyArr === undefined
            || satisfyArr.length <= 0) {
            return null;
        }
        return (
            <FlatList
                data={satisfyArr}
                renderItem={({item}) => {
                    return (<View>
                        <View style={styles.marginViewTop}>
                            <Text style={styles.btnText} allowFontScaling={false}>已满足</Text>
                        </View>
                        <View style={[styles.listContainer, {flex: 1,flexDirection:'row'}]}>
                            <View style={styles.leftView}>
                                <Image source={require("../../foundation/Img/cart/icon_CouponLeft_@3x.png")} style={{
                                    width:ScreenUtils.scaleSize(180),
                                    height:ScreenUtils.scaleSize(194),
                                    position:'absolute',
                                    bottom:0,
                                    left:0,
                                }}/>
                                <View style={styles.priceView}>
                                    {item.dc_gb === "10" ?
                                    <Text style={styles.leftLog2} allowFontScaling={false}>¥<Text style={styles.leftLog} allowFontScaling={false}>{String(item.coupon_amt)}</Text></Text>:null}
                                    {item.dc_gb === "20" ? <Text style={styles.leftLog} allowFontScaling={false}>{String(item.dc_rate)}<Text style={styles.leftLog2} allowFontScaling={false}>折</Text></Text>:null}
                                </View>
                                {
                                    item.min_order_amt ?
                                        <Text style={styles.leftText} numberOfLines={1} allowFontScaling={false}>满{item.min_order_amt}元可用</Text>
                                        :
                                        null
                                }
                            </View>

                            <View style={[styles.rightView]}>
                                <Image source={require("../../foundation/Img/cart/icon_CouponRight_@3x.png")} style={{
                                    height:ScreenUtils.scaleSize(194),
                                    width:ScreenUtils.scaleSize(500),
                                    position:'absolute',
                                    left:0,
                                    bottom:0,
                                    resizeMode:'stretch',

                                }}/>
                                <Text style={styles.shopText} numberOfLines={1} allowFontScaling={false}>{item.dccoupon_name}</Text>
                                <Text style={styles.couponText} numberOfLines={1} allowFontScaling={false}>{item.coupon_note}</Text>
                                <Text style={styles.dateText} allowFontScaling={false}>有效期至{item.dc_endDate}</Text>
                            </View>
                            <View style={{position: 'absolute', right: 20, bottom: 0}}>
                                <Image source={require('../Img/cart/Iconcoupon.png')} style={{height: 60, width: 60}}/>
                            </View>
                        </View>
                    </View>)
            }}
        />)
    }

    renderNoSatisfy(noSatisfyArr, noSatisfyPrice, totalPrice) {
        if (noSatisfyPrice === undefined
            || noSatisfyPrice === 0
            || noSatisfyArr === null
            || noSatisfyArr === undefined
            || noSatisfyArr.length <= 0) {
            return null;
        }
        return (<FlatList
            data={noSatisfyArr}
            renderItem={({item}) => {
                let disparity="¥"+(parseFloat(item.min_order_amt) - parseFloat(totalPrice));
                return (<View>
                    <View style={styles.marginViewTop}>
                        <Text style={styles.btnText} allowFontScaling={false}>还差<Text allowFontScaling={false}>{disparity}</Text></Text>
                    </View>
                    <View style={[styles.listContainer, {flex: 1,flexDirection:'row'}]}>
                        <View style={styles.leftView}>
                            <Image source={require("../../foundation/Img/cart/icon_CouponLeft_@3x.png")} style={{
                                width:ScreenUtils.scaleSize(180),
                                height:ScreenUtils.scaleSize(194),
                                position:'absolute',
                                bottom:0,
                                left:0,
                            }}/>
                            <View style={styles.priceView}>
                                {item.dc_gb === "10" &&
                                <Text style={styles.leftLog2} allowFontScaling={false}>¥<Text style={styles.leftLog} allowFontScaling={false}>{String(item.dc_amt)}</Text></Text>}
                                {item.dc_gb === "20" && <Text style={styles.leftLog} allowFontScaling={false}>{String(item.dc_rate)}<Text style={styles.leftLog2} allowFontScaling={false}>折</Text></Text>}
                            </View>
                            <Text style={styles.leftText} numberOfLines={1} allowFontScaling={false}>满{item.min_order_amt}元可用</Text>
                        </View>

                        <View style={[styles.rightView]}>
                            <Image source={require("../../foundation/Img/cart/icon_CouponRight_@3x.png")} style={{
                                width:ScreenUtils.scaleSize(500),
                                height:ScreenUtils.scaleSize(194),
                                position:'absolute',
                                bottom:0,
                                resizeMode:'stretch'
                            }}/>
                            <Text style={styles.shopText} numberOfLines={1} allowFontScaling={false}>{item.dccoupon_name}</Text>
                            <Text style={styles.couponText} numberOfLines={1} allowFontScaling={false}>{item.dccoupon_content}</Text>
                            <Text style={styles.dateText} allowFontScaling={false}>有效期至{item.dc_endDate}</Text>
                        </View>
                        {item.isGet && <View style={{position: 'absolute', right: 5, top: 35}}>
                            <Image source={require('../Img/cart/Iconcoupon.png')} style={{height: 60, width: 60}}/>
                        </View>}

                    </View>
                </View>)
            }}/>)
    }

    renderSatifyTitle() {
        let ticketTitle = "";
        let {satisfyPrice, noSatisfyPrice} = this.props.lookTicketInfo;
        if (satisfyPrice > 0) {
            ticketTitle = "¥" + String(satisfyPrice)
            return (
                <View style={styles.titleView}>
                    <TouchableOpacity style={styles.titleClose} onPress={() => this.props.closeCartDiscountCoupon()}>
                        <Image source={require('../Img/dialog/icon_close_@3x.png')} style={styles.imgRightStyle}/>
                    </TouchableOpacity>
                    <Text style={styles.categoryName} allowFontScaling={false}>已满足使用条件，可节省<Text style={{color:'#E5290D'}} allowFontScaling={false}>{ticketTitle}</Text>哦</Text>
                </View>
            )
        }
    }

    renderNoSatifyTitle() {
        let ticketTitle = "";
        let {noSatisfyPrice} = this.props.lookTicketInfo;
        if (noSatisfyPrice > 0) {
            ticketTitle = "¥" + String(noSatisfyPrice);
            return (
                <View style={styles.titleView}>
                    <TouchableOpacity style={styles.titleClose} onPress={() => this.props.closeCartDiscountCoupon()}>
                        <Image source={require('../Img/dialog/icon_close_@3x.png')} style={styles.imgRightStyle}/>
                    </TouchableOpacity>
                    <Text style={styles.categoryName} allowFontScaling={false}>未满足使用条件，可节省<Text style={{color:'#E5290D'}}>{ticketTitle}</Text>哦</Text>
                </View>
            )
        }
    }

    renderSatisfyItem() {
        let {satisfyPrice, satisfyArr, noSatisfyPrice, noSatisfyArr, totalPrice} = this.props.lookTicketInfo;
        return (
            <View style={{marginBottom: 10, flex: 1}}>
                <ScrollView style={{maxHeight: ScreenUtils.scaleSize(950),width:width-20}}>
                    {this.renderSatifyTitle()}
                    {this.renderSatisfy(satisfyArr, satisfyPrice)}
                    {this.renderNoSatifyTitle()}
                    {this.renderNoSatisfy(noSatisfyArr, noSatisfyPrice, totalPrice)}
                </ScrollView>

            </View>
        );
    }

    render() {
        return (
            <Modal onRequestClose={() => {
            }} animationType="fade"
                   transparent={true}
                   visible={this.props.show}>
                <View style={styles.container}>
                    <Text
                        onPress={() => {
                            this.props.closeCartDiscountCoupon()
                        }}
                        style={{flex: 1}} allowFontScaling={false}/>
                    <View style={styles.contentContainer}>
                        {this.renderSatisfyItem()}
                    </View>

                </View>
            </Modal>
        );
    }
}
CartDiscountCoupon.defaultProps = {
    index: 0,
    data: null,
};
const styles = StyleSheet.create({
    noText: {
        justifyContent: 'center',
        color: 'red',
        alignSelf: 'center',
        fontSize: 18,
    },
    no: {
        width: width,
        height: 90,
        backgroundColor: 'white',
        justifyContent: 'center',
    },
    categoryName: {
        flex: 2,
        justifyContent: 'flex-end',
        alignSelf: 'center',
        fontSize: ScreenUtils.setSpText(28),
    },
    listContainer: {
        backgroundColor: 'white',
    },
    container: {
        flex: 1,
        justifyContent: 'flex-end',
        backgroundColor: 'rgba(0,0,0,0.5)',
    },

    contentContainer: {
        flex: 1,
        flexDirection: 'column',
        backgroundColor: 'white',
        justifyContent: 'flex-end',
        paddingTop: 10,
        paddingLeft: 20,
        paddingRight: 20,
    },
    titleView: {
        flexDirection: 'row',
        height: 30,
        backgroundColor: 'white'
    },
    buttons: {
        justifyContent: 'center',
        flexDirection: 'row',
        alignItems: 'center',
    },
    titleLeft: {
        marginTop: 25,
        width: 20,
        backgroundColor: 'white',
    },
    titleImg: {
        borderRadius: 3,
        width: 100,
        height: 100,
        resizeMode: 'cover',
    },
    titleText: {
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'flex-end',
        paddingLeft: 10,
        paddingRight: 10,
        paddingTop: 10,
        marginTop: 25,
        backgroundColor: 'white',
    },
    titleClose: {
        zIndex: 4,
        position: 'absolute',
        top: 10,
        right: 10,
        width: 30,
        height: 30,
        fontSize: 24,
    },
    price: {
        color: '#ff8c00'
    },
    categoryTitle: {
        marginTop: 10,
        marginBottom: 10,
    },
    categoryItems: {
        flexDirection: 'row',
        marginBottom: 10,
    },
    categoryItemText: {
        padding: 5,
        marginLeft: 5,
        marginRight: 5,
        backgroundColor: '#666666',
        color: 'white',
        borderRadius: 8,
    },
    addCartBtn: {
        height: 50,
        flex: 1,
        color: 'white',
        flexDirection: 'row',
        textAlign: 'center',
        textAlignVertical: 'center',
        alignItems: 'center',
        backgroundColor: '#ff8c00'
    },
    purchaseBtn: {
        height: 50,
        flex: 1,
        color: 'white',
        flexDirection: 'row',
        textAlign: 'center',
        textAlignVertical: 'center',
        alignItems: 'center',
        backgroundColor: '#daa520',
    },
    divideLine: {
        backgroundColor: 'rgba(0,0,0,0.5)',
        height: 1,
    },
    btnText: {
        color: '#666666',
        fontSize: ScreenUtils.setSpText(26),
        marginRight: 20,
    },
    btnText2: {
        color: '#666666',
        fontSize: ScreenUtils.setSpText(26),
        marginRight: ScreenUtils.scaleSize(170),
    },
    categoryTip: {
        color: '#333333',
    },
    marginViewTop: {
        height: 20,
        flexDirection: 'row',
        backgroundColor: 'white',
        justifyContent: 'flex-end',
        alignItems: 'center',
        marginTop: 10,
    },
    marginView: {
        zIndex: 4,
        position: 'absolute',
        left: 0,
        backgroundColor: 'yellow',
        height: 20,
        bottom: 20,
    },
    dashLine: {
        borderColor: '#DDBABA',
        borderWidth: 1,
        borderStyle: 'dashed',
        width: 1,
        position: 'absolute',
        left: 100,
        height: 100,
        top: -10,
    },
    leftView: {
        flexDirection: 'column',
        justifyContent: 'center',
        height: ScreenUtils.scaleSize(194),
        width: ScreenUtils.scaleSize(180),
    },
    priceView: {
        flexDirection: 'row',
        justifyContent: 'center',
        backgroundColor:"rgba(0,0,0,0)"
    },
    leftNum: {
        color: 'white',
        textAlign: 'center',
        fontSize: 25,
    },
    leftLog: {
        color: 'white',
        paddingTop: 10,
        textAlign: 'center',
        fontSize:ScreenUtils.setSpText(60)
    },
    leftLog2:{
        color: 'white',
        paddingTop: 10,
        textAlign: 'center',
        fontSize:ScreenUtils.setSpText(30)
    },
    leftText: {
        color: 'white',
        textAlign: 'center',
        fontSize:ScreenUtils.setSpText(22),
        backgroundColor:'rgba(0,0,0,0)'
    },
    rightView: {
        paddingLeft:ScreenUtils.scaleSize(30),
        justifyContent:'center',
        paddingVertical:ScreenUtils.scaleSize(30),
        width:ScreenUtils.scaleSize(500),
        height:ScreenUtils.scaleSize(194),
    },
    rightText: {
        color: 'white',
        textAlign: 'left',
    },
    up: {
        position: 'absolute',
        left: 90,
        top: -10,
        zIndex: 3,
        backgroundColor: 'white',
        width: 20,
        height: 20,
        borderRadius: 10,
        borderColor: '#E5290D',
        borderWidth: 0.5,
    },
    down: {
        position: 'absolute',
        left: 90,
        bottom: -8,
        zIndex: 3,
        backgroundColor: 'white',
        width: 20,
        height: 20,
        borderRadius: 10,
        borderColor: '#E5290D',
        borderWidth: 0.5,
    },
    shopText: {
        height: 30,
        color: '#333333',
        fontSize: 18,
        backgroundColor:'rgba(0,0,0,0)'
    },
    dateText: {
        color: '#666666',
        fontSize: 13,
        backgroundColor:'rgba(0,0,0,0)'
    },
    couponText: {
        color: '#666666',
        fontSize: 13,
        backgroundColor:'rgba(0,0,0,0)'
    },
    imgRightStyle: {
        height: ScreenUtils.scaleSize(30),
        width: ScreenUtils.scaleSize(30),
    }
});

export default CartDiscountCoupon