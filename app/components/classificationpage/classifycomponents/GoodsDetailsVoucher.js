/**
 * Created by wangwenliang on 2017/5/17.
 * 商品详情中的抵用券
 */

import {
    View,
    Text,
    StyleSheet,
    Image,
    Dimensions,
    Modal,
    FlatList,
    TouchableOpacity,
} from 'react-native';

import {
    routeConfig,
    RouteManager,
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Fonts,
} from '../../../config/UtilComponent';

const {width, height} = Dimensions.get('window');
import GetVoucherRequest from '../../../../foundation/net/GoodsDetails/GetVoucherRequest';
import VoucherRequest from '../../../../foundation/net/GoodsDetails/VoucherRequest';
import ToastShow from '../../../../foundation/common/ToastShow';

let key=0;

/**
* @description
* 根据开发环境选择是否要不可变数据结构
* @const {class}
*/
const Com = __DEV__ ? Component : PureComponent;

class VoucherItem extends Com {
    constructor(props) {
        super(props);
        this.state = {
            datas: this.props.datas,
            // index: this.props.index,
            refresh: true,
            get:false,
            canClick:true,
        }
    }

    componentWillUnmount() {
        this.timer && clearTimeout(this.timer);
    }

    getVoucherRequest(couponNum){
        if (this.getVoucherR) {
            this.getVoucherR.setCancled(true)
        }
        let req = {
            coupon_no:couponNum+"",
        };
        this.getVoucherR = new GetVoucherRequest(req, "POST");
        this.getVoucherR.setShowMessage(true).start((response) => {

            this.timer = setTimeout(()=>{
                this.state.canClick=true;
            },3000);

            // console.log('aaaaaaaaaaa voucher:'+JSON.stringify(response));
            if (response.code != null && response.code === 200 && response.message=="succeed" &&response.data != null && response.data.result!=null) {
                //领取抵用券成功
                this.props.refreshDatas();
            }else {
                this._toLoginByErrCode(response);
            }
        }, (err) => {
            this.timer = setTimeout(()=>{
                this.state.canClick=true;
            },3000);
            this._toLoginByErrCode(err);
        });
    }

    //根据错误返回值来判断是否登录
    _toLoginByErrCode(err) {
        let login = (err && err.code && (err.code === 4010 || err.code === 4011 || err.code === 4012 || err.code === 4013 || err.code === 4014 || err.code === 1070800501)) ? true : false;
        if (login) {
            this._toLogin();
        } else {
            err && err.message && ToastShow.toast(err.message);
        }
    }

    //登录
    _toLogin() {
        RouteManager.routeJump({
            page: routeConfig.Login,
            fromRNPage:routeConfig.GoodsDetailMain,
        },(event)=>{
            if (event.tokenType==="self"){
                this.props.close(false);
                this.props.refreshGoodsDetailData();
            }
        })
    }


    getDate(t){
        let d=new Date(t);
        let year=d.getFullYear();
        let day=d.getDate();
        let month=d.getMonth();
        return year+"年"+month+"月"+day+"日";
    }

    render() {
        let bgColor = '#E5290D';
        let teColorBig = 'white';
        let teColorSmall = 'white';

        if (this.state.datas.use_now=='NO' || this.state.datas.use_now==null) {
            return <View/>;
        }

        return (
            <View style={{width: ScreenUtils.screenW, flexDirection: 'row', alignItems: 'center',marginTop:ScreenUtils.scaleSize(40),}}>
                <Image source={require('../../../../foundation/Img/order/icon_left_coupon@2x.png')} style={styles.leftImg}/>
                <Image source={require('../../../../foundation/Img/order/icon_right_coupon@2x.png')} style={styles.rightImg}/>
                <View style={styles.bgg}>

                    <View style={styles.priceBg}>
                        {this.state.datas.dc_gb == '10' ?
                            <View style={{flexDirection: 'row'}}>
                                <Text allowFontScaling={false} style={{fontSize: ScreenUtils.setSpText(30), color: teColorBig, marginTop: 5}}>￥</Text>
                                <Text allowFontScaling={false} style={[styles.priceStyle, {color: teColorBig}]}>{this.state.datas.dc_amt}</Text>
                            </View> :
                            <View style={{flexDirection: 'row'}}>
                                <Text allowFontScaling={false}
                                    style={[styles.priceStyle, {color: teColorBig}]}>{String(100-this.state.datas.dc_rate)}</Text>
                                <Text allowFontScaling={false} style={{fontSize: ScreenUtils.setSpText(30), color: teColorBig, marginTop: 5}}>折</Text>
                            </View>
                        }
                        {!!this.state.datas.isGet ?
                            <Text allowFontScaling={false}
                                style={[styles.rulerStyle, {color: teColorSmall}]}>满{this.state.datas.min_order_amt+""||""}元可用</Text>
                            :
                            <Text allowFontScaling={false} style={styles.rulerStyle2} onPress={() => {

                                if (this.state.canClick){
                                    this.state.canClick=false;
                                    this.getVoucherRequest(this.state.datas.dccoupon_No);
                                }

                            }}>立即领取</Text>}
                    </View>
                    <View style={[styles.topCircleStyle, {borderColor: bgColor}]}/>
                    <View style={styles.vouncherDescBg}>
                        <Text allowFontScaling={false} style={styles.vouncherDescTitle}>{this.state.datas.dccoupon_name}</Text>
                        <Text allowFontScaling={false} style={styles.vouncherDescStyle}>{this.state.datas.dccoupon_content}</Text>
                        <Text allowFontScaling={false} style={styles.vouncherDescStyle}>{this.state.datas.dc_bdate}至{this.state.datas.dc_edate}</Text>
                    </View>
                    <View style={[styles.bottomCircleStyle, {borderColor: bgColor}]}/>

                </View>

                {!!this.state.datas.isGet &&
                <Image style={{width: ScreenUtils.scaleSize(120), height: ScreenUtils.scaleSize(120), position: 'absolute', top: ScreenUtils.scaleSize(40), left: width - ScreenUtils.scaleSize(80) - ScreenUtils.scaleSize(170)}}
                       source={require('../../../../foundation/Img/icons/icon_coupon_@2x.png')}/>}
            </View>
        )
    }
}

export default class GoodsDetailsVoucher extends Com {
    constructor(props) {
        super(props);
        this.state = {
            show: this.props.show,
            dataSource: (this.props.datas!=null && this.props.datas.length>0) ? this.props.datas : [],
            fresh:false,
        }

        this.getVoucherDatasRequest();
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.show != this.state.show){
            this.setState({show: nextProps.show});
        }
    }

    renderUseItem = (item, index) => {
        return (
            <View>
                <VoucherItem
                    datas={item}
                    index={index}
                    refreshGoodsDetailData={()=>{this.props.refreshGoodsDetailData()}}
                    close={(e)=>{this.props.close(e);}}
                    refreshDatas={()=>this.getVoucherDatasRequest()}/>
            </View>
        )
    }

    getVoucherDatasRequest() {
        if (this.voucherR) {
            this.voucherR.setCancled(true)
        }
        let req = {
            // area_lgroup: "38",
            // area_mgroup: "022",
            // area_sgroup: "028"
        };
        let itemcode = this.props.allDatas.goodsDetail.item_code;
        // console.log("######### 上个页面传过来的itemcode：" + itemcode);
        this.voucherR = new VoucherRequest(req, "GET");
        this.voucherR.setItemCode(itemcode);
        this.voucherR.start((response) => {
            if (response.code != null && response.code === 200 && response.data != null && response.data.length > 0) {
                //获取到抵用券相关信息
                // console.log("##### 抵用券请求数据：" + JSON.stringify(response));
                if (response.code === 200 && response.data != null && response.data.length > 0) {
                    this.setState({dataSource: response.data});
                }
            }
        }, (err) => {
            // alert("网络请求错误:" + JSON.stringify(err));
        });
    }

    render() {
        return (
            <Modal animationType="fade"
                   onrequestclose={() => {
                   }}
                   transparent={true}
                   style={styles.container}
                   visible={this.state.show}>
                <View style={styles.contentContainer}>
                    <Text allowFontScaling={false} style={{flex:1}} onPress={()=>{ this.props.close(false);}}/>
                    <View style={styles.showContent}>

                        <View style={styles.mainItem}>
                            <View style={styles.topTitleItem1}>
                                <Text allowFontScaling={false} style={styles.topTitleText}>可领抵用券</Text>
                                <TouchableOpacity activeOpacity={1} onPress={() => {
                                    this.props.close(false);
                                }}>
                                    <Image style={styles.topImage}
                                           source={require('../../../../foundation/Img/dialog/icon_close_@3x.png')}/>
                                </TouchableOpacity>
                            </View>

                            <FlatList
                                horizontal={false}
                                key={++key}
                                data={this.state.dataSource}
                                renderItem={({item, index}) => (this.renderUseItem(item, index))}
                                style={{width: mWidth,maxHeight:ScreenUtils.screenH*0.6}}
                            />
                        </View>
                        {/*<View style={styles.mainItem}>*/}
                            {/*<View style={styles.topTitleItem2}>*/}
                                {/*<Text style={styles.topTitleText}>即将可领抵用券</Text>*/}
                            {/*</View>*/}

                            {/*<FlatList*/}
                                {/*horizontal={false}*/}
                                {/*data={this.state.dataSource}*/}
                                {/*renderItem={({item, index}) => (this.renderUseItem(item, index))}*/}
                                {/*style={{width: mWidth}}*/}
                            {/*/>*/}
                        {/*</View>*/}
                    </View>
                </View>
            </Modal>
        );
    }
}

let mWidth = width-ScreenUtils.scaleSize(60);
const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
    },
    contentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        width: width,
        height: height,
    },
    showContent: {
        // width:width,
        // height:height*0.85,
        backgroundColor: 'white'
    },
    mainItem: {
        width: width,
        // height: height * 0.85,
        padding: ScreenUtils.scaleSize(40),
        borderBottomWidth: 1,
        borderBottomColor: '#999',
    },
    topTitleItem1: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        height: ScreenUtils.scaleSize(80),
    },
    topTitleItem2: {
        height: ScreenUtils.scaleSize(80),
    },
    topTitleText: {
        fontSize: ScreenUtils.scaleSize(28),
        color: '#333',
    },
    topImage: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
    },
    bgg: {
        flexDirection: 'row',
        backgroundColor: 'transparent',
        alignItems: 'center',
        position:'absolute',
        top:0
    },
    priceBg: {
        //width: ScreenUtils.screenW,
        //height: ScreenUtils.scaleSize(194),
        backgroundColor: 'transparent',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        // marginLeft:ScreenUtils.scaleSize(20),
        // marginTop:ScreenUtils.scaleSize(40),
        width:ScreenUtils.scaleSize(180),
        height:ScreenUtils.scaleSize(194),
    },
    priceStyle: {
        color: 'white',
        fontSize: ScreenUtils.setSpText(40),
    },
    rulerStyle: {
        fontSize: Fonts.secondary_font(),
        color: 'white'
    },
    rulerStyle2: {
        fontSize: Fonts.standard_normal_font(),
        color: 'white',
        borderWidth: 1,
        borderColor: 'white',
        borderRadius: ScreenUtils.scaleSize(7),
        padding: ScreenUtils.scaleSize(7),
        textAlign: 'center',
    },
    vouncherDescBg: {
        //flex: 1,
        flexDirection: 'column',
        // paddingTop: ScreenUtils.scaleSize(60),
        paddingLeft: ScreenUtils.scaleSize(20),
        width:width-ScreenUtils.scaleSize(180)-ScreenUtils.scaleSize(70),
        justifyContent:'center'
    },
    vouncherDescTitle: {
        color: 'black',
        fontSize: ScreenUtils.setSpText(26),
        marginLeft: ScreenUtils.scaleSize(20),
        backgroundColor:'transparent'
    },
    vouncherDescStyle: {
        color: '#666666',
        fontSize: ScreenUtils.setSpText(26),
        marginLeft: ScreenUtils.scaleSize(20),
        backgroundColor:'transparent'
    },
    topCircleStyle: {
        backgroundColor: 'transparent',
    },
    bottomCircleStyle: {
        backgroundColor: 'transparent',
    },
    leftImg:{
        width:ScreenUtils.scaleSize(180),
        height:ScreenUtils.scaleSize(194),
    },
    rightImg:{
        width:width-ScreenUtils.scaleSize(180)-ScreenUtils.scaleSize(70),
        height:ScreenUtils.scaleSize(194),
        resizeMode:'stretch'
    }
});
