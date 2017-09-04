/**
 * Created by xian on 2017/5/25.
 * 品牌团购详情页面 codeValue
 */
'use strict';
import {
    View,
    Text,
    StyleSheet,
    Platform,
    Image,
    FlatList,
    TouchableOpacity,
} from 'react-native';

import {
    React,
    NetErro,
    ScreenUtils,
    Colors,
    Fonts,
    NavigationBar,
    Actions,
    DataAnalyticsModule,
} from '../../config/UtilComponent';

//商品item组件
import ItemBrandDetail from '../../../foundation/common/ItemBrandDetail';
//品牌详情接口
import BrandGroupBuyDetail from '../../../foundation/net/group/BrandGroupBuyDetail.js';

//埋点相关
let codeValue = 'AP1707C071';
let pageVersionName = 'V1';
export default class GroupBuyDetails extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            title:'品牌团详情',
            brandHead:{},
            brandList:[],
            errStatus: false,
        };
    }
    componentDidMount() {
        this._getBrandGroupBuyDetail();
    }

    componentWillUnmount() {
        //页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }
    render() {
        //异常
        if (this.state.errStatus) {
            return (
                <View style={{flex: 1}}>
                    {this._randerNav()}
                    <NetErro
                        style={{flex: 1}}
                        title={'您的网络好像很傲娇'}
                        confirmText={'刷新试试'}
                        onButtonClick={() => {
                            //拉取数据
                            this._getBrandGroupBuyDetail();
                        }}
                    />
                </View>
            );
        }
       return (
            <View style={{flex:1}}>
                {this._randerNav()}
                {this.state.brandHead?
                <FlatList
                    style={styless.moduleViewStyle}
                    horizontal={false}
                    numColumns ={2}
                    data={this.state.brandList}
                    renderItem={({item},index) => <ItemBrandDetail
                        key={index}
                        data={item}
                        codeValue={codeValue}
                        pageVersionName={pageVersionName}
                    />}
                    ListHeaderComponent={() => this._renderHeader(this.state.brandHead)}
                /> : null}
            </View>
        )
    }
    /**
     * 获取品牌详情
     * @private
     */
    _getBrandGroupBuyDetail() {
        if (this.BrandGroupBuyDetail) {
            this.BrandGroupBuyDetail.setCancled(true);
        }
        this.BrandGroupBuyDetail = new BrandGroupBuyDetail({seq_shop_num: this.props.id}, 'GET');
        this.BrandGroupBuyDetail.showLoadingView().start(
            (response) => {
                // console.log('BrandGroupBuyDetail-----' + response.code);
                if (response.code === 200 && response.data && response.data.displayContentList) {
                    this.setState({
                        errStatus:false,
                        //品牌标题
                        title: response.data.nameContentList[0].conts_title_nm,
                        //明星品牌
                        brandHead: response.data.displayContentList?response.data.displayContentList[0]:[],
                        //商品列表
                        brandList: response.data.displayContentList?response.data.displayContentList.slice(1,response.data.displayContentList.length-1):[],
                    });
                    //页面埋点
                    DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                } else {
                    this.setState({
                        errStatus: true,
                    });
                }
            }, (erro) => {
                this.setState({
                    errStatus: true,
                });
            });
    }
    /**
     * 渲染导航栏
     * @private
     */
    _randerNav() {
        return (
            <NavigationBar
                title={this.state.title}
                titleStyle={{fontSize:Fonts.page_title_font(), fontWeight:'bold',color:Colors.text_dark_grey}}
                barStyle={'dark-content'}
                navigationStyle={{borderBottomWidth:ScreenUtils.scaleSize(1),borderColor:Colors.line_grey,height: ScreenUtils.scaleSize(128), ...Platform.select({ios: {marginTop: -22}})}}
                onLeftPress={() => {
                    DataAnalyticsModule.trackEvent('AP1706C071D003001C003001');
                    Actions.pop();
                }}
            />
        )
    }
    /**
     * 渲染品牌详情头部
     * @private
     */
    _renderHeader(item) {
        return (
        <TouchableOpacity activeOpacity={1}
                          style={styless.container}
                          onPress={() => {
                              DataAnalyticsModule.trackEvent('AP1707C071D013001D024001');
                              Actions.GoodsDetailMain({itemcode:item.item_code});
        }}>

                    <Image source={{uri:item.contentImage !== null ? item.contentImage:'http://image1.ocj.com.cn/item_images/item/15/17/8773/15178773P.jpg'}}
                           style={styless.imagesize} resizeMode={'cover'}>
                        <Text allowFontScaling={false} style={styless.discount}>品牌明星</Text>
                    </Image>

                <View style={styless.padd}>
                    <Text allowFontScaling={false} numberOfLines={2} style={styless.title}>{item.item_name}</Text>
                    <Text allowFontScaling={false} numberOfLines={3} style={styless.title2}>{item.alt_desc}</Text>
                    <View style={styless.text}>
                    <View style={styless.horiza}>
                        <Text allowFontScaling={false} style={styless.pricelog}>¥</Text>
                        <Text allowFontScaling={false} style={styless.price}>{item.last_sale_price !== null ? item.last_sale_price:''}</Text>
                        {item.save_amt ? <Image style={[styless.giftImgStyle,{marginLeft:ScreenUtils.scaleSize(5),marginBottom:ScreenUtils.scaleSize(5)}]}
                                                source={require('../../../foundation/Img/searchpage/Icon_accumulate_.png')}/>:null}
                        {item.save_amt ? <Text allowFontScaling={false} style={styless.originalPrice}>{item.save_amt}</Text>:null}
                    </View>
                    <View style={styless.horiza2}>
                        <Text allowFontScaling={false} style={styless.sellnumber}>{(item.salesVolume&&parseFloat(item.salesVolume)!==0)?item.salesVolume+'人已购买':''}</Text>
                        <View style={styless.atend}>
                            <Text allowFontScaling={false} style={styless.leavenumber}>{Number(item.qtyState)>=0?'':item.qtyState}</Text>
                        </View>
                    </View>
                    </View>
                </View>
        </TouchableOpacity>
        );
    }
}

GroupBuyDetails.defaultProps = {
    id: 0,
};

const styless = StyleSheet.create({
    moduleViewStyle: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_grey,
    },
    leavenumber:{
        color: Colors.magenta,
        fontSize: Fonts.secondary_font(),
    },
    text:{
        position:'absolute',
        bottom:ScreenUtils.scaleSize(10),
        width:ScreenUtils.screenW/2-20,
    },
    container: {
        marginTop:ScreenUtils.scaleSize(20),
        marginBottom:ScreenUtils.scaleSize(20),
        height:ScreenUtils.scaleSize(280),
        width: ScreenUtils.screenW ,
        backgroundColor: Colors.background_white,
        flexDirection:'row',
    },
    imagesize: {
        flex:1,
        width: ScreenUtils.scaleSize(240),
        height: ScreenUtils.scaleSize(240),
        margin:ScreenUtils.scaleSize(20),
    },
    discountView: {
        width: ScreenUtils.scaleSize(120),
        height: ScreenUtils.scaleSize(120),
        backgroundColor: Colors.magenta,
        justifyContent: 'center',
        alignItems: 'center',
    },
    discount: {
        marginLeft: ScreenUtils.scaleSize(20),
        marginTop:Platform.OS==='ios'?0:-3,
        paddingTop:ScreenUtils.scaleSize(Platform.OS==='ios'?4:0),
        color: Colors.text_white,
        backgroundColor: Colors.magenta,
        fontWeight: 'bold',
        height:ScreenUtils.scaleSize(30),
        width:ScreenUtils.scaleSize(100),
        textAlign:'center',
        fontSize: ScreenUtils.setSpText(22),
    },
    originalPrice: {
        marginLeft: ScreenUtils.scaleSize(5),
        color: Colors.hotsale_inter,
        // textDecorationLine: 'line-through',
        fontSize: Fonts.secondary_font(),
        marginHorizontal: 5,
        marginBottom:ScreenUtils.scaleSize(4),
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
    horiza: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        justifyContent: "flex-start",
    },
    horiza2: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        justifyContent: "center",
        bottom:ScreenUtils.scaleSize(10),
        height:ScreenUtils.scaleSize(40),
        width:ScreenUtils.screenW - ScreenUtils.scaleSize(320),
    },
    atend: {
        fontSize:Fonts.tag_font(),
        flex: 1,
        alignItems: 'flex-end',
    },
    padd: {
        paddingTop:ScreenUtils.scaleSize(20),
        paddingRight:ScreenUtils.scaleSize(20),
        paddingBottom:ScreenUtils.scaleSize(20),
        // width:ScreenUtils.screenW/2-20,
    },
    title: {
        color: Colors.text_black,
        fontSize:ScreenUtils.setSpText(28),
        height:ScreenUtils.scaleSize(68),
        width:ScreenUtils.screenW - ScreenUtils.scaleSize(320),
    },
    title2: {
        marginTop:ScreenUtils.scaleSize(5),
        fontSize:ScreenUtils.setSpText(24),
        color: Colors.text_dark_grey,
        height:ScreenUtils.scaleSize(120),
        width:ScreenUtils.screenW - ScreenUtils.scaleSize(320),
    },
});
