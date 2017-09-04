/**
 * Created by dhy on 2017/6/23.
 */
/**
 * Created by 卓原 on 2017/5/22 0022.
 * 封装好的折扣商品图文组件, 有商品名(与HorizontalItem的区别) 有售价，原价，出售数量，左上角折扣
 *
 */
import React from 'react';
import {
    View,
    Text,
    Image,
    StyleSheet,
    TouchableOpacity,
    Platform,
} from 'react-native';
import * as ScreenUtil from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
import Fonts from '../../app/config/fonts';
import {Actions} from 'react-native-router-flux';
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
export default class ItemBrandDetail extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            times: ['00', '00', '00', '00', '00', '00'],
        };
    }
    componentDidMount() {
        let distance = (Number(this.props.data.disp_end_dt) - Number(this.props.data.now_dt)) / 1000;//毫秒转秒
        this.timeStart(distance);
    }

    timeStart(distance) {
        if (distance > 0) {
            this.interval = setInterval(() => {
                if (distance <= 0) {
                    clearInterval(this.interval);
                }//时间到
                this.setState({
                    times: ScreenUtil.getRemainingimeDistance(distance),//获取时间数组
                });
                distance--;
            }, 1000);
        }
    }

    componentWillUnmount(){
        clearInterval(this.interval);
    }
    render() {
        let item = this.props.data;
        return (

            <TouchableOpacity activeOpacity={1} style={styles.container} onPress={() => {
                DataAnalyticsModule.trackEvent('AP1707C071B009001D008001');
                Actions.GoodsDetailMain({itemcode:item.item_code});
            }}>
                <Image source={{uri:item.contentImage !== null ? item.contentImage:''}}
                       style={styles.imagesize}>
                    {
                        this.state.hasDiscount ? <View style={styles.discountView}>
                            <Text style={styles.discount} allowFontScaling={false}>{item.co_dc !== null ? item.co_dc:''}折</Text>
                        </View> : null
                    }
                    {(Number(item.disp_end_dt) - Number(item.now_dt))?
                        <View style={styles.remainingTime}>
                            <Image
                                source={require('../Img/groupbuy/icon_time_@3x.png')}
                                style={{
                                    width:ScreenUtil.scaleSize(20),
                                    height:ScreenUtil.scaleSize(20),
                                    marginRight:ScreenUtil.scaleSize(5)
                                }}
                            />
                            <Text style={styles.countdown} allowFontScaling={false}>剩余
                                {this.state.times[2]+'天'}
                                {this.state.times[3]+'时'}
                                {this.state.times[4]+'分'}
                                {this.state.times[5]+'秒'}
                            </Text>
                        </View>:null}
                </Image>
                <View style={styles.padd}>
                    <Text numberOfLines={2} style={styles.title} allowFontScaling={false}>{item.item_name}</Text>
                    <View style={styles.horiza}>
                        <Text style={styles.pricelog} allowFontScaling={false}>¥</Text>
                        <Text style={styles.price} allowFontScaling={false}>{item.last_sale_price !== null ? item.last_sale_price:''}</Text>
                        {item.save_amt ?<Image style={[styles.giftImgStyle,{marginLeft:ScreenUtil.scaleSize(5),marginBottom:ScreenUtil.scaleSize(5)}]}
                                               source={require('../Img/searchpage/Icon_accumulate_.png')}/>:null}
                        {item.save_amt ?<Text style={styles.originalPrice} allowFontScaling={false}>{item.save_amt !== null ? item.save_amt:''}</Text>:null}
                        <View style={styles.atend}>
                            {item.gifts?
                                <Image style={styles.giftImgStyle} source={require('../Img/home/Icon_gifts1_.png')}/>
                                :null}
                            {/*<Text style={styles.sellnumber}>{item.gifts}</Text>*/}
                        </View>
                    </View>
                    <View style={styles.horiza}>
                        <Text style={styles.sellnumber} allowFontScaling={false}>{(item.salesVolume&&parseFloat(item.salesVolume)!==0)?item.salesVolume+'人已购买':''}</Text>
                        <View style={styles.atend}>
                            <Text style={styles.leavenumber} allowFontScaling={false}>{Number(item.qtyState)>=0?'':item.qtyState}</Text>
                        </View>
                    </View>
                </View>
            </TouchableOpacity>

        );
    }
}

const styles = StyleSheet.create({
    remainingTime:{
        height:ScreenUtil.scaleSize(40),
        flexDirection:"row",
        position:"absolute",
        bottom:0,
        alignItems:"center",
        zIndex:20,
        justifyContent:"center",
        left:0,
        right:0,
        backgroundColor:Colors.text_orange,
        opacity:0.7,
    },
    countdown:{
        color:Colors.text_white,
        fontSize:ScreenUtil.setSpText(20),
        backgroundColor:"transparent",
    },
    container: {
        width: ScreenUtil.screenW / 2,
        backgroundColor: Colors.background_white,
        borderLeftWidth:1,
        borderLeftColor:Colors.line_grey,
        borderBottomWidth:1,
        borderBottomColor:Colors.line_grey
    },
    imagesize: {
        width: (ScreenUtil.screenW - ScreenUtil.scaleSize(46))/ 2,
        margin:ScreenUtil.scaleSize(10),
        resizeMode:'cover',
        height: (ScreenUtil.screenW - ScreenUtil.scaleSize(46))/ 2,
    },
    discountView: {
        width: ScreenUtil.scaleSize(65),
        height: ScreenUtil.scaleSize(65),
        backgroundColor: Colors.magenta,
        justifyContent: 'center',
        alignItems: 'center',
    },
    discount: {
        color: Colors.text_white,
        fontWeight: 'bold',
        fontSize: Fonts.tag_font(),
    },
    originalPrice: {
        marginLeft: ScreenUtil.scaleSize(5),
        color: Colors.hotsale_inter,
        // textDecorationLine: 'line-through',
        fontSize: Fonts.secondary_font(),
        marginHorizontal: 5,
        marginBottom:ScreenUtil.scaleSize(4),
    },
    pricelog:{
        includeFontPadding: false,
        color: Colors.main_color,
        // fontWeight: 'bold',
        textAlignVertical: 'bottom'
    },
    price: {
        includeFontPadding: false,
        color: Colors.main_color,
        // fontWeight: 'bold',
        fontSize: Fonts.page_title_font(),
        textAlignVertical: 'bottom'
    },
    sellnumber: {
        color: Colors.text_dark_grey,
        fontSize: Fonts.secondary_font(),
    },
    leavenumber:{
        color: Colors.magenta,
        fontSize: Fonts.secondary_font(),
    },
    horiza: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        bottom:ScreenUtil.scaleSize(10),
        width:(ScreenUtil.screenW - 46)/2,
    },
    atend: {
        flex: 1,
        alignItems: 'flex-end'
    },
    padd: {
        paddingLeft: ScreenUtil.scaleSize(10),
        paddingRight: ScreenUtil.scaleSize(10),
        width: (ScreenUtil.screenW - 46)/ 2,
    },
    title: {
        fontSize: ScreenUtil.setSpText(28),
        color: Colors.text_black,
        height:ScreenUtil.scaleSize(80),
    },
    jianju: {
        marginRight: ScreenUtil.scaleSize(20),
    }
});
