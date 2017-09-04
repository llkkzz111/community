/**
 * Created by MASTERMIAO on 2017/5/20.
 * TV团购列表条目组件
 */
'use strict';

import React, {
    PureComponent,
    Component
} from 'react'
import {Actions} from 'react-native-router-flux'
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
} from 'react-native'
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import * as ScreenUtils from '../utils/ScreenUtil';
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
// import {Video} from 'react-native-media-kit';

class TimerHeader extends Component {
    constructor(props) {
        super(props);
        this.state = {
            times: ['00', '00', '00', '00', '00', '00',],
        };
    }

    componentDidMount() {
        let data = this.props.data;
        let distance = (Number(data.endDateLong) - Number(data.curruntDateLong)) / 1000;//毫秒转秒
        this.timeStart(distance);
    }

    timeStart(distance) {
        if (distance > 0) {
            this.interval = setInterval(() => {
                if (distance <= 0) {
                    clearInterval(this.interval);
                }//时间到
                this.setState({
                    times: this.getRemainingimeDistance(distance),//获取时间数组
                });
                distance--;
            }, 1000);
        }
    }

//1497235419
getRemainingimeDistance(distance) {
    let timestamp = distance * 1000;
    if (timestamp < 0) {
        return ["0", "0", "0", "0", "0", "0"];
    }
    let date = new Date();
    date.setTime(timestamp);
    let str = date.format('yyyy-MM-dd-hh-mm-ss');
    let strs = str.split('-');
    strs.splice(0, 1, String(Number(strs[0]) - 1970));//年
    strs.splice(1, 1, String(Number(strs[1]) - 1));

    if(Number(strs[3])-8<0){
        strs.splice(2, 1, (Number(strs[2]) - 2) < 10 ? '0' + (Number(strs[2]) - 2) : String(Number(strs[2]) - 2));
        strs.splice(3, 1, (Number(strs[3])-8+24) < 10 ? '0' + (Number(strs[3])-8+24) : String(Number(strs[3])-8+24));
    }else {
        strs.splice(2, 1, (Number(strs[2]) - 1) < 10 ? '0' + (Number(strs[2]) - 1) : String(Number(strs[2])-1));
        strs.splice(3, 1, (Number(strs[3])-8) < 10 ? '0' + (Number(strs[3])-8) : String(Number(strs[3])-8));
    }
    strs.splice(4, 1, Number(strs[4]) < 10 ? '0' + Number(strs[4]) : String(Number(strs[4])));
    strs.splice(5, 1, Number(strs[5]) < 10 ? '0' + Number(strs[5]) : String(Number(strs[5])));
    return strs;//["0", "0", "2", "7", "33", "30"]0年0月2日 7时33分30秒
}
    componentWillUnmount() {
        clearInterval(this.interval);//移除计时器
    }

    render() {
        return (
            <View style={styles.countDownStyle}>
                <Text style={styles.lastStyle} allowFontScaling={false} >剩余</Text>
                <Text style={styles.timeNumStyle} allowFontScaling={false}>{this.state.times[2]}</Text>
                <Text style={styles.timeUnitStyle} allowFontScaling={false}>天</Text>
                <Text style={styles.timeNumStyle} allowFontScaling={false}>{this.state.times[3]}</Text>
                <Text style={styles.timeUnitStyle} allowFontScaling={false}>时</Text>
                <Text style={styles.timeNumStyle} allowFontScaling={false}>{this.state.times[4]}</Text>
                <Text style={styles.timeUnitStyle} allowFontScaling={false}>分</Text>
                <Text style={styles.timeNumStyle} allowFontScaling={false}>{this.state.times[5]}</Text>
                <Text style={styles.timeUnitStyle} allowFontScaling={false}>秒</Text>
            </View>
        );
    }
}
TimerHeader.propTypes = {
    action: React.PropTypes.func,
};
TimerHeader.defaultProps = {
    data: {
        firstImgUrl: '',//大图
        videoPlayBackUrl: '',//视频播放地址
        curruntDateLong: '',
        playDateLong: '',
    }
};

export default class TVGroupListItem extends PureComponent {

    constructor(props) {
        super(props);
        this.state = {
            muted: true,
            controls: true,
        };
    }

    render() {
        let data = this.props.data;
        // console.log('data.firstImgUrl === ' + data.firstImgUrl);
        return (
            <View style={styles.containers}>
                <TimerHeader key={'TimerHeader'} data={data}/>
                <TouchableOpacity activeOpacity={1} style={styles.imageBg} onPress={() => {
                    DataAnalyticsModule.trackEvent3(data.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                    Actions.GoodsDetailMain({itemcode: data.destinationUrl});
                    // if (this.props.fromPage && this.props.fromPage === 'Home') {
                    //     Actions.pop()
                    // }
                    // RnConnect.pushs({
                    //     page: routeConfig.Homeocj_Video,
                    //     param: {id: data.id}
                    // }, (event) => {
                    //     NativeRouter.nativeRouter(event)
                    // });

                }}>
                    {/*<Video*/}
                    {/*style={{width: ScreenUtils.screenW,*/}
                    {/*height: ScreenUtils.scaleSize(420),*/}
                    {/*backgroundColor: 'black'}}*/}
                    {/*autoplay={true}*/}
                    {/*preload='none'*/}
                    {/*loop={true}*/}
                    {/*controls={this.state.controls}*/}
                    {/*poster={data.firstImgUrl}*/}
                    {/*muted={this.state.muted}*/}
                    {/*src={data.videoPlayBackUrl}*/}
                    {/*/>*/}
                    <Image
                        resizeMode={'contain'}
                        style={{
                            width: ScreenUtils.screenW,
                            height: ScreenUtils.scaleSize(420),
                        }}
                        source={{uri: data.firstImgUrl}}/>
                    <View style={styles.discountBg}>
                        <Text style={styles.discountStyle} allowFontScaling={false}>{data.discount ? data.discount : ''}折</Text>
                    </View>
                </TouchableOpacity>

                <View style={styles.containerStyle}>
                    <View style={styles.rowStyle}>
                        <Text style={styles.pricelog} allowFontScaling={false}>¥</Text>
                        <Text style={styles.price} allowFontScaling={false}>{data.salePrice !== null ? data.salePrice : ''}</Text>
                        <Text style={styles.originalPrice} allowFontScaling={false}>￥{data.originalPrice ? data.originalPrice : ''}</Text>
                        {Number(data.integral) ?<Image style={[styles.amtimg, {
                            marginLeft: ScreenUtils.scaleSize(5),
                            marginBottom: ScreenUtils.scaleSize(5)
                        }]} source={require('../Img/searchpage/Icon_accumulate_@2x.png')}/>:null}
                        {Number(data.integral) ?<Text allowFontScaling={false} style={styles.amt}>{Number(data.integral) ? String(data.integral) : '0'}</Text>:null}
                        <TouchableOpacity activeOpacity={1} style={styles.buyNowBg} onPress={() => {
                            DataAnalyticsModule.trackEvent3(data.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                            Actions.GoodsDetailMain({itemcode: data.destinationUrl});
                        }}>
                            <Text style={styles.panicBuy} allowFontScaling={false}>立即抢购</Text>
                        </TouchableOpacity>
                    </View>
                    <View style={styles.rowStyle}>
                        <Text style={styles.buyNumber} allowFontScaling={false}>{String(data.salesVolume ? data.salesVolume : '0')}人已购买</Text>
                    </View>
                    <TouchableOpacity activeOpacity={1} style={{marginBottom: ScreenUtils.scaleSize(10)}} onpress={() => {
                        Actions.GoodsDetailMain({itemcode: data.destinationUrl});
                    }}>
                        {data.description ?
                            <View style={styles.rowStyle}>
                                <Text style={styles.colorTt} allowFontScaling={false}>{data.description ? data.description : ''}</Text>
                            </View>
                            : null}
                        <View style={styles.rowStyle}>
                            <Text style={styles.fontWeight} numberOfLines={2} allowFontScaling={false}>{data.title ? data.title : '没有title'}</Text>
                        </View>
                    </TouchableOpacity>
                    {data.gifts ?
                        <View style={styles.rowStyle}>
                            <Image style={styles.giftImgStyle} source={require('../Img/home/Icon_gifts1_@3x.png')}/>
                            <Text numberOfLines={1} style={styles.fontgits} allowFontScaling={false}>{data.gifts ? data.gifts : ''}</Text>
                        </View>
                        : <View/>}
                </View>
            </View>
        )
    }
}
/*      {
 "id":"6278074731627282432",
 "title":"德国进口可爱儿童",
 "componentId":null,
 "codeId":"404",
 "destinationUrl":null,
 "isComponents":0,
 "shortNumber":0,
 "codeValue":"AP1706A015B17001D12001",
 "destinationUrlType":null,
 "contentCode":"15102398",
 "componentList":null,
 "groupBuyType":1,
 "salesVolume":"90",
 "originalPrice":"344",
 "salePrice":"244",
 "discount":"4.5",
 "integral":"0",
 "remainingTime":null,
 "inStock":"100",
 "gifts":"超级赠品 XXXXXXXXXXXXXXXXX",
 "groupBuyTime":null,
 "subtitle":"副标题",
 "videoPlayBackUrl":"视频播放地址",
 "firstImgUrl":"http://10.22.218.170:8080/cms/cms/151/05/2017/2017060105.jpg"
 }*/
TVGroupListItem.propTypes = {};
TVGroupListItem.defaultProps = {
    data: {
        destinationUrl: '',//商品code
        firstImgUrl: '',//大图
        originalPrice: '',//初始价
        salePrice: '',//卖出价
        description: '',//商品描述
        id: '',//商品ID
        title: '',//商品名
        gifts: '',//赠品
        discount: '',//折扣
        salesVolume: '',
        videoPlayBackUrl: '',//视频播放地址
        curruntDateLong: '',
        playDateLong: '',
        integral: '0',
    }

};


const styles = StyleSheet.create({
    amt: {
        color: Colors.hotsale_inter,
        fontSize: Fonts.secondary_font(),
        marginHorizontal: 5
    },
    price: {
        includeFontPadding: false,
        color: Colors.main_color,
        // fontWeight: 'bold',
        fontSize: Fonts.page_title_font()+1,
        textAlignVertical: 'bottom',
        marginBottom: ScreenUtils.scaleSize(6),
    },
    pricelog: {
        fontSize:Fonts.secondary_font(),
        includeFontPadding: false,
        color: Colors.main_color,
        // fontWeight: 'bold',
        textAlignVertical: 'bottom'
    },
    containers: {
        backgroundColor: Colors.background_white,
        marginBottom: ScreenUtils.scaleSize(20),
        paddingBottom: ScreenUtils.scaleSize(20),
        flexDirection: 'column',
    },
    lastTime: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(80),
        flexDirection: 'row',
        alignItems: 'center'
    },
    bg: {
        borderRadius: ScreenUtils.scaleSize(6),
        borderColor: '#F64537',
        alignItems: 'center',
        justifyContent: 'center',
        width: ScreenUtils.scaleSize(60),
        height: ScreenUtils.scaleSize(40),
        marginLeft: ScreenUtils.scaleSize(20)
    },
    timer: {
        color: '#F64537',
        fontSize: Fonts.secondary_font()
    },
    tt: {
        fontSize: Fonts.secondary_font(),
        color: 'black',
        marginLeft: ScreenUtils.scaleSize(20)
    },
    imageBg: {
        borderColor: Colors.line_grey,
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(420),
        // resizeMode: 'cover',
    },

    pbg: {
        padding: ScreenUtils.scaleSize(10),
        alignItems: 'center',
        flexDirection: 'row',
        marginTop: ScreenUtils.scaleSize(10)
    },
    orderProductDescStyle: {
        alignItems: 'center',
        flexDirection: 'row',
        padding: ScreenUtils.scaleSize(20),
    },
    imageLayout: {
        height: ScreenUtils.scaleSize(100),
        width: ScreenUtils.scaleSize(100),
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: '#EEEEEE',
        justifyContent: 'center',
        alignItems: 'center',
        position: 'relative',
        marginLeft: ScreenUtils.scaleSize(10)
    },
    imageSize: {
        height: ScreenUtils.scaleSize(200),
        width: ScreenUtils.scaleSize(200),
        zIndex: 0,
        borderColor: '#DDDDDD',
        borderWidth: ScreenUtils.scaleSize(1)
    },
    merchandiseLayout: {
        marginLeft: ScreenUtils.scaleSize(10),
        justifyContent: 'space-between',
        flex: 1
    },
    colorStyle: {
        color: '#666666',
        fontSize: Fonts.secondary_font()
    },
    fontWeight: {
        marginTop:ScreenUtils.scaleSize(10),
        fontSize: Fonts.standard_normal_font(),
        color: Colors.text_black,
        alignSelf: 'flex-start',
        marginBottom:ScreenUtils.scaleSize(10),
    },
    fontgits: {
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(80),
        fontSize: Fonts.secondary_font(),
        color: Colors.text_dark_grey,
        marginLeft: ScreenUtils.scaleSize(10),
    },
    rightInfoStyle: {
        alignSelf: 'flex-start'
    },
    rightInfoStyle2: {
        alignSelf: 'flex-start',
        marginTop: ScreenUtils.scaleSize(20)
    },
    merchandiseCredit: {
        flexDirection: 'row',
        flex: 1,
        justifyContent: 'space-between',
        marginTop: ScreenUtils.scaleSize(20)
    },
    shoppingPriceStyle: {
        color: 'red',
        fontSize: ScreenUtils.setSpText(26)
    },
    shoppingPriceStyle2: {
        fontSize: Fonts.secondary_font(),
        textDecorationLine: 'line-through'
    },
    shoppingCreditIconStyle: {
        width: ScreenUtils.scaleSize(60),
        height: ScreenUtils.scaleSize(30),
        marginLeft: ScreenUtils.scaleSize(10),
        resizeMode: 'contain'
    },
    shoppingCreditStyle: {
        color: '#FFC033',
        marginLeft: ScreenUtils.scaleSize(10)
    },
    shoppingInfoIconStyle: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
        marginLeft: ScreenUtils.scaleSize(10),
        resizeMode: 'contain'
    },
    productHeaderLayout: {
        marginLeft: ScreenUtils.scaleSize(20),
        marginRight: ScreenUtils.scaleSize(20),
        minHeight: ScreenUtils.scaleSize(40),
    },
    discountBgStyle: {
        backgroundColor: '#FFF1F4',
        width: ScreenUtils.scaleSize(120),
        height: ScreenUtils.scaleSize(60),
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 3
    },
    discountDescStyle: {
        color: '#E5290D',
        fontSize: 13
    },
    totalStyle: {
        flexDirection: 'row',
        position: 'relative',
    },
    total: {
        fontSize: 13,
        color: 'black'
    },
    weightStyle: {
        fontSize: Fonts.page_title_font(),
        color: '#AAAAAA'
    },
    preferentialActivitiesStyle: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    discountStyle: {
        fontSize: ScreenUtils.setSpText(26),
        color: 'white',
        fontWeight: 'bold',
    },
    discountBg: {
        width: ScreenUtils.scaleSize(75),
        height: ScreenUtils.scaleSize(75),
        position: 'absolute',
        top: 0,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#ED1C41'
    },
    colorTt: {
        marginTop:ScreenUtils.scaleSize(10),
        fontSize: ScreenUtils.setSpText(24),
        height:ScreenUtils.scaleSize(30),

        color: '#F14967',
    },
    buyNowBg: {
        width: ScreenUtils.scaleSize(160),
        height: ScreenUtils.scaleSize(50),
        backgroundColor: '#F14967',
        borderRadius: ScreenUtils.scaleSize(6),
        alignItems: 'center',
        justifyContent: 'center',
        position: 'absolute',
        right: ScreenUtils.scaleSize(10),
    },
    panicBuy: {
        fontSize: 13,
        color: 'white',
    },
    backgroundVideo: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(400),
        maxHeight: ScreenUtils.scaleSize(400)
    },
    backgroundVideo2: {
        position: 'absolute',
        top: 0,
        left: 0,
        bottom: 0,
        right: 0,
    },
    videoControll: {
        width: ScreenUtils.scaleSize(40),
        height: ScreenUtils.scaleSize(40)
    },
    videoControllBg: {
        position: 'absolute',
        alignSelf: 'center',
    },

    countDownStyle: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(82),
        backgroundColor: Colors.background_white,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
    },
    lastStyle: {
        fontSize: Fonts.standard_title_font(),
        color: Colors.text_black
    },
    timeNumStyle: {
        fontSize: Fonts.standard_title_font(),
        color: '#F64537',
        marginLeft: ScreenUtils.scaleSize(20)
    },
    timeUnitStyle: {
        fontSize: ScreenUtils.scaleSize(26),
        color: Colors.text_black,
        marginLeft: ScreenUtils.scaleSize(20)
    },
    currentPrice: {
        color: Colors.main_color,
        fontSize: ScreenUtils.setSpText(36),
    },
    originalPrice: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(24),
        textDecorationLine: 'line-through',
        marginLeft: ScreenUtils.scaleSize(5)
    },
    integral: {
        color: Colors.hotsale_inter,
        fontSize: ScreenUtils.setSpText(22),
    },

    rowStyle: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    amtimg: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
        resizeMode:'contain',
    },
    giftImgStyle: {
        width: ScreenUtils.scaleSize(50),
        height: ScreenUtils.scaleSize(30),
        // marginTop:ScreenUtils.scaleSize(40),
    },
    buyNumber: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(24),
    },
    containerStyle: {
        marginLeft: ScreenUtils.scaleSize(28),
        marginRight: ScreenUtils.scaleSize(28),
        marginTop: ScreenUtils.scaleSize(30),
    },

});

