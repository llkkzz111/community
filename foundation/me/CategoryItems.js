/**
 * Created by dhy on 2017/5/7.
 */
/**
 * Created by Administrator on 2017/5/7.
 * CategoryItems 个人中心 item 入口列表 组件
 */
'use strict';
import React, {
    Component,
    PropTypes
} from 'react';
import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    Platform,
    TouchableOpacity,
    TouchableWithoutFeedback,
    ScrollView,
    DeviceEventEmitter
} from 'react-native';
import * as ScreenUtils from '../utils/ScreenUtil';
import Cell from '../common/CommonCell';
const {width} = Dimensions.get('window');
import {Actions} from 'react-native-router-flux';
import * as routeConfig from '../../app/config/routeConfig'
import RnConnect from '../../app/config/rnConnect';
import KeFuRequest from '../../foundation/net/GoodsDetails/KeFuRequest'
import * as NativeRouter from'../../app/config/NativeRouter';
import * as RouteManager from '../../app/config/PlatformRouteManager';
//埋点
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
let codeValue = 'AP1706C019';
let pageVersionName = 'V1';

//主标题
const Titles = ['订单中心', '我的钱包', ''];
//订单中心的数据  kind == 0
const TiketTitles = ['待支付', '待发货', '配送中', '退款/售后', '预约中'];
//'积分','抵用券','礼包','预付款','鸥点'的数据   kind == 1
const ActivityTitles = ['积分', '抵用券', '礼包', '预付款', '鸥点'];
const ActivityTips = ['1分=1元', '淘券享优惠', '礼品卡充值', '账户余额', '可兑换券'];
//'收藏','礼券兑换','发票管理','东东客服',''的数据   kind == 2
const PersonTitles = ['收藏', '礼券兑换', '发票管理', '东东客服', ''];

class ItemOne extends Component {
    //换成item index 对应的数据参数
    getIndex(index) {
        if (index === 3) {
            index = 5;
        } else if (index === 4) {
            index = 6;
        } else {
            index++;
        }
        return index;
    }

    render() {
        return (
            <TouchableOpacity
                activeOpacity={1}
                onPress={() => {
                    switch (this.props.index){
                        case 0:
                            DataAnalyticsModule.trackEvent3('AP1706C019C002001C002001', "", {'pID': codeValue, 'vID': pageVersionName});
                            break;
                        case 1:
                            DataAnalyticsModule.trackEvent3('AP1706C019C002001C002002', "", {'pID': codeValue, 'vID': pageVersionName});
                            break;
                        case 2:
                            DataAnalyticsModule.trackEvent3('AP1706C019C002001C002003', "", {'pID': codeValue, 'vID': pageVersionName});
                            break;
                        case 3:
                            DataAnalyticsModule.trackEvent3('AP1706C019C002001C002004', "", {'pID': codeValue, 'vID': pageVersionName});
                            break;
                        case 4:
                            DataAnalyticsModule.trackEvent3('AP1706C019C002001C002005', "", {'pID': codeValue, 'vID': pageVersionName});
                            break;
                        default :
                            break;
                    }
                    Actions.OrderCenter({'pageId':this.getIndex(this.props.index),'actState':this.props.type});
                }}
                style={styles.imgBack}>
                {this.props.topNum !== '' && this.props.topNum.toString() !== '0' ?
                    <View style={styles.viewTip}>
                        <Text allowFontScaling={false} style={styles.textTip}>{this.props.topNum.toString()}</Text>
                    </View>
                    : <View/>
                }
                <View style={styles.view}>
                    <Image style={styles.img} source={this.props.img}/>
                </View>
                <Text allowFontScaling={false} style={styles.textBottom}>{TiketTitles[this.props.index]}</Text>
            </TouchableOpacity>
        );
    }
}

ItemOne.propTypes = {
    action: React.PropTypes.func, //去抵用券详细
};

ItemOne.defaultProps = {
    index: 0,
    topNum: 0,
    img: require('../Img/me/icon_order2_@2x.png'),
};

class ItemTwo extends Component {
    push(index) {
        switch (index) {
            case 0:
                //RnConnect.pushs({page:routeConfig.MePageocj_Score});
                RouteManager.routeJump({
                    page: routeConfig.Score
                });
                break;
            case 1:
                //RnConnect.pushs({page:routeConfig.MePageocj_Coupon});
                RouteManager.routeJump({
                    page: routeConfig.Coupon
                });
                break;
            case 2:
                //RnConnect.pushs({page:routeConfig.MePageocj_Reward});
                RouteManager.routeJump({
                    page: routeConfig.Reward
                });
                break;
            case 3:
                //RnConnect.pushs({page:routeConfig.MePageocj_Prebargain});
                RouteManager.routeJump({
                    page: routeConfig.Prebargain
                });
                break;
            case 4:
                //  RnConnect.pushs({page:routeConfig.MePageocj_Europe},(event)=>{
                //      DeviceEventEmitter.emit('refreshOrderCenter');
                //      NativeRouter.nativeRouter(event)
                //  });
                RouteManager.routeJump({
                    page: routeConfig.Europe
                }, (event) => {
                    DeviceEventEmitter.emit('refreshOrderCenter');
                    NativeRouter.nativeRouter(event)
                });
                break;
            default:
                break;
        }
    }

    render() {
        return (
            <TouchableOpacity
                activeOpacity={1}
                onPress={() => {
                    this.push(this.props.index);
                }}
                style={styles.imgBack}>
                <Text allowFontScaling={false} style={styles.textTop}>{this.props.topNum.toString()}</Text>
                <Text allowFontScaling={false} style={styles.textMid}>{ActivityTitles[this.props.index]}</Text>
                <Text allowFontScaling={false} style={styles.textGray}>{ActivityTips[this.props.index]}</Text>
            </TouchableOpacity>
        );
    }
}

ItemTwo.defaultProps = {
    index: 0,
    topNum: 0,
    img: require('../Img/me/icon_order2_@2x.png'),
};
// BillListPage  FavoritePage
class ItemThree extends Component {
    render() {
        return (
            <View>
                <View style={styles.view}>
                    <Image style={styles.img} source={this.props.img}/>
                </View>
                <Text allowFontScaling={false} style={styles.textBottom}>{PersonTitles[this.props.index]}</Text>
            </View>
        );
    }
}

ItemThree.defaultProps = {
    index: 0,
    img: require('../Img/me/icon_order2_@2x.png'),
};

let time1 = 1;
export default class CategoryItems extends Component {
    constructor(props) {
        super(props);
        this.state = {
            orderData: this.props.orderData,
            walletiters: this.props.walletiters,
            walletquan: this.props.walletquan,
            walletgift: this.props.walletgift,
            walletMoney: this.props.walletMoney,
            walletOu: this.props.walletOu,
            returnsNum: this.props.returnsNum,

            soonexpiringsaveamt: this.props.soonexpiringsaveamt,

            showMaskView: false,

        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            orderData: nextProps.orderData,
            walletiters: nextProps.walletiters,
            walletquan: nextProps.walletquan,
            walletgift: nextProps.walletgift,
            walletMoney: nextProps.walletMoney,
            walletOu: nextProps.walletOu,
            returnsNum: nextProps.returnsNum,
            soonexpiringsaveamt: nextProps.soonexpiringsaveamt
        });
    }


    componentWillMount() {
        DeviceEventEmitter.addListener("ROLLING_MSG", () => this.startRolling());
    }

    startRolling() {
        // 调用的方法
        if (this.props.kind === 1) {
            // console.log(this.props.kind)
            if (this.interval) {
                clearInterval(this.interval);
            }
            if (this.props.walletiters.length) {
                this.interval = setInterval(() => this.rolling(), 2500);
            }
        }
    }

    componentWillUnmount() {
        DeviceEventEmitter.removeListener("ROLLING_MSG");
        // 组件销毁的时候 移除定时器
        if (this.interval) {
            clearInterval(this.interval);
        }
    }

    rolling() {
        let self = this;
        let len = (this.props.soonexpiringsaveamt && this.props.soonexpiringsaveamt.length);
        if (time1 % len !== 0) {
            this.setState({
                showMaskView: false
            })
        }
        if (this && this.refs && this.refs.scrollView) {
            this.refs.scrollView.scrollTo({x: 0, y: time1 % len * 30, animated: true})
        } else {
            return
        }
        time1 += 1;
        if (time1 % len === 0) {
            setTimeout(() => {
                self.setState({
                    showMaskView: true
                });
                if (self && self.refs && self.refs.scrollView) {
                    self.refs.scrollView.scrollTo({x: 0, y: 0, animated: false});
                }
                time1 += 1;
            }, 500);
        }
    }

    getImg(index) {
        let kind = this.props.kind;
        let img; //图片路径
        switch (index) {
            case 0:
                if (kind === 0) {
                    img = require('../Img/me/icon_order1_@2x.png');
                } else {
                    img = require('../Img/me/icon_tool1_@2x.png');
                }
                break;
            case 1:
                if (kind === 0) {
                    img = require('../Img/me/icon_order2_@2x.png');
                } else {
                    img = require('../Img/me/icon_tool2_@2x.png');
                }
                break;
            case 2:
                if (kind === 0) {
                    img = require('../Img/me/icon_order3_@2x.png');
                } else {
                    img = require('../Img/me/icon_tool3_@2x.png');
                }
                break;
            case 3:
                if (kind === 0) {
                    img = require('../Img/me/icon_order4_@2x.png');
                } else {
                    img = require('../Img/me/icon_tool4_@2x.png');
                }
                break;
            case 4:
                if (kind === 0) {
                    img = require('../Img/me/icon_order5_@2x.png');
                }
                break;
            default:
                break;
        }
        return img;
    }

    render() {
        let rollingMsg = this.props.soonexpiringsaveamt;
        let kind = this.props.kind;
        const {showMaskView} = this.state;
        return (
            <View style={styles.containers}>
                {kind === 0 ?
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => {
                            DataAnalyticsModule.trackEvent3('AP1706C019D010001C010001', "", {'pID': codeValue, 'vID': pageVersionName});
                            Actions.OrderCenter({'pageId':0,'actState':'all', 'androidFirstLoad':true});
                        }}>
                        <Cell leftText={Titles[kind]} leftIconName={'arrow_right.png'} rightText={'全部'}/>
                    </TouchableOpacity> : <View/>}
                {kind === 1 ?
                    <View style={styles.titleView}>
                        <Text allowFontScaling={false} style={styles.titleText}>{Titles[kind]}</Text>
                        <View style={styles.activityBg}>
                            {
                                rollingMsg && rollingMsg.length > 1 ?
                                    <View style={styles.msgView}>
                                        <ScrollView ref='scrollView'
                                                    scrollEnabled={false}
                                                    showsVerticalScrollIndicator={false} style={styles.msgScrollView}>
                                            {
                                                rollingMsg.map(function (item, index) {
                                                    return (
                                                        <TouchableWithoutFeedback key={index}>
                                                            <View style={styles.announcement}>
                                                                <Text allowFontScaling={false}
                                                                      style={styles.textStyle}>{rollingMsg[index]}</Text>
                                                            </View>
                                                        </TouchableWithoutFeedback>
                                                    );
                                                })
                                            }
                                        </ScrollView>
                                        {
                                            showMaskView && rollingMsg && rollingMsg.length > 0 ?
                                                <View style={[styles.announcement, styles.absoluteView]}>
                                                    <Text allowFontScaling={false}
                                                          style={styles.textStyle}>{rollingMsg[0]}</Text>
                                                </View>
                                                :
                                                <View />
                                        }
                                    </View>
                                    :
                                    <View/>
                            }
                            {
                                rollingMsg && rollingMsg.length === 1 ?
                                    <View style={styles.announcement2} key={rollingMsg[0]}>
                                        <Text allowFontScaling={false} style={styles.textStyle}>

                                        </Text>
                                    </View>
                                    :
                                    <View/>
                            }
                        </View>
                    </View> : <View/>}
                {kind === 0 ?
                    <View style={styles.itemList}>
                        <ItemOne topNum={this.state.orderData ? this.state.orderData.nPayOrderCnt : ''} type="nopay"
                                 img={this.getImg(0)} index={0}/>
                        <ItemOne topNum={this.state.orderData ? this.state.orderData.nDeliverOrderCnt : ''}
                                 type="payover" img={this.getImg(1)} index={1}/>
                        <ItemOne topNum={this.state.orderData ? this.state.orderData.deliveringOrderCnt : ''}
                                 type="peisong" img={this.getImg(2)} index={2}/>
                        <ItemOne topNum={this.state.returnsNum ? this.state.returnsNum : ''} type="return"
                                 img={this.getImg(3)} index={3}/>
                        <ItemOne topNum={this.state.orderData ? this.state.orderData.preOrderCnt : ''} type="preorder"
                                 img={this.getImg(4)} index={4}/>
                    </View> : <View/>}
                {kind === 1 ?
                    <View style={styles.itemList}>
                        <ItemTwo topNum={this.state.walletiters ? this.state.walletiters : '0'} img={this.getImg(0)}
                                 index={0}/>
                        <ItemTwo topNum={this.state.walletquan ? this.state.walletquan : '0'} img={this.getImg(1)}
                                 index={1}/>
                        <ItemTwo topNum={this.state.walletgift ? this.state.walletgift : '0'} img={this.getImg(2)}
                                 index={2}/>
                        <ItemTwo topNum={this.state.walletMoney ? this.state.walletMoney : '0'} img={this.getImg(3)}
                                 index={3}/>
                        <ItemTwo topNum={this.state.walletOu ? this.state.walletOu : '0'} img={this.getImg(4)}
                                 index={4}/>
                    </View> : <View/>}
                {kind === 2 ?
                    <View style={styles.itemList}>
                        <TouchableOpacity
                            activeOpacity={1}
                            style={styles.imgBack}
                            onPress={() => {
                                DataAnalyticsModule.trackEvent3('AP1706C019C002002C002001', "", {'pID': codeValue, 'vID': pageVersionName});
                                Actions.FavoritePage();
                            }}
                        >
                            <ItemThree img={this.getImg(0)} index={0}/>
                        </TouchableOpacity>
                        <TouchableOpacity
                            activeOpacity={1}
                            style={styles.imgBack}
                            onPress={() =>{
                                DataAnalyticsModule.trackEvent3('AP1706C019C002002C002002', "", {'pID': codeValue, 'vID': pageVersionName});
                                //RnConnect.pushs({page:routeConfig.MePageocj_ChangeGift});
                                RouteManager.routeJump({
                                    page: routeConfig.ChangeGift
                                })
                            }}
                        >
                            <ItemThree img={this.getImg(1)} index={1}/>
                        </TouchableOpacity>
                        <TouchableOpacity
                            activeOpacity={1}
                            style={styles.imgBack}
                            onPress={() => {
                                DataAnalyticsModule.trackEvent3('AP1706C019C002002C002003', "", {'pID': codeValue, 'vID': pageVersionName});
                                Actions.BillListPage();
                            }}
                        >
                            <ItemThree img={this.getImg(2)} index={2}/>
                        </TouchableOpacity>
                        <TouchableOpacity
                            activeOpacity={1}
                            style={styles.imgBack}
                            onPress={this.goService}
                        >
                            <ItemThree img={this.getImg(3)} index={3}/>
                        </TouchableOpacity>
                    </View> : <View/>}
            </View>
        );
    }

    // 跳转到H5东东客服
    goService = () => {
        DataAnalyticsModule.trackEvent3('AP1706C019C002002C002004', "", {'pID': codeValue, 'vID': pageVersionName});
        // Actions.orderDetail({_data:dataItem});
        if (this.kefuR) {
            this.kefuR.setCancled(true)
        }
        this.kefuR = new KeFuRequest({
            order_no: "",
            item_code: "",
            imsource: "",
            last_sale_price: "",
        }, "GET");
        this.kefuR.showLoadingView(true).start((response) => {
            if (response.code != null && response.code === 200 && response.data != null && response.data.url) {
                // console.log("##### kefu:" + response.data.url);
                Actions.VipPromotionGoodsDetail({value: response.data.url});
            } else {
            }
        }, (err) => {
            // alert("网络异常");
            // console.log(JSON.stringify(err));
        });
    }
}

CategoryItems.defaultProps = {
    index: 0,
    data: ['1', '2', '3', '4', '5'],
};

const styles = StyleSheet.create({
    activity: {
        width: width - 120,
        fontSize: 12,
        color: '#666666',
        marginTop: 10,
        textAlign: 'right'
    },
    titleView: {
        flexDirection: 'row',
        backgroundColor: 'transparent',
        borderBottomWidth: 0.5,
        borderColor: '#DDDDDD',
        alignItems: "center",
        height: ScreenUtils.scaleSize(80),
    },
    titleText: {
        width: 100,
        marginLeft: ScreenUtils.scaleSize(30),
        fontSize: 14,
        color: '#333333',
    },
    containers: {
        flexDirection: 'column',
        backgroundColor: 'white',
        // marginBottom: 10,
    },
    itemList: {
        flexDirection: 'row',
        height: 90,
        width: width,
        backgroundColor: 'white',
    },
    imgBack: {
        paddingTop: 5,
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
    },
    textBottom: {
        flex: 1,
        // marginTop: 10,
        fontSize: 14,
        textAlign: 'center',
        // alignSelf:'center',
        color: '#333333',
        // justifyContent: 'center',
        // alignItems: 'center',
    },
    view: {
        flex: 1.8,
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
    },
    viewTip: {
        position: 'absolute',
        zIndex: 2,
        width: 20,
        height: 20,
        borderRadius: 10,
        top: 10,
        left: width / 8.6,
        justifyContent: 'center',
        alignItems: 'center',
        alignSelf: 'center',
        backgroundColor: '#E5290D',
    },
    textTip: {
        color: '#FFFFFF',
        zIndex: 3,
        fontSize: 10,
    },
    textGray: {
        flex: 1,
        textAlign: 'center',
        fontSize: 12,
        color: '#999999',
    },
    textTop: {
        flex: 1,
        marginTop: 5,
        color: '#333333',
        fontSize: 14,
        textAlign: 'center',
    },
    textMid: {
        flex: 1,
        color: '#333333',
        fontSize: 14,
        textAlign: 'center',
    },
    img: {
        // top: Platform.OS==='android'?5:0,
        zIndex: 1,
        width: ScreenUtils.scaleSize(58),
        height: ScreenUtils.scaleSize(53),
        justifyContent: 'center',
        alignItems: 'center',
        alignSelf: 'center',
    },
    announcement: {
        height: 30,
        flex: 1,
        justifyContent: 'center',
        backgroundColor: 'white',
    },
    msgScrollView: {
        marginLeft: 20,
        height: 30,
        backgroundColor: 'white',
        width: ScreenUtils.screenW - 150
    },
    textStyle: {
        fontSize: 13,
        textAlign: 'right',
        color: "#666666"
    },
    activityBg: {
        position: 'absolute',
        top: 0,
        right: ScreenUtils.scaleSize(20),
    },
    announcement2: {
        height: 30,
        backgroundColor: "white",
        width: ScreenUtils.screenW - 150,
        alignItems: "flex-end",
        justifyContent: "flex-end",
    },
    absoluteView: {
        position: 'absolute',
        top: 0,
        right: 0,
        backgroundColor: 'white',
        width: ScreenUtils.screenW - 150
    },
    msgView: {
        justifyContent: 'center',
        marginTop: 5
    },

    styleIcon: {
        flex: 0,
        width: 5,
        height: 5,
        backgroundColor: '#999999',
        borderRadius: 360
    }
});
