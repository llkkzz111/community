/**
 * Created by wangwenliang on 2017/8/7.
 * 商品详情顶部的导航栏
 */

'use strict';
import {
    StyleSheet,
    View,
    Image,
    TouchableOpacity,
    Dimensions,
    Platform,
} from 'react-native';

import {
    routeConfig,
    RouteManager,
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Colors,
    Fonts,
    DataAnalyticsModule,
    getStatusHeight,
} from '../../../config/UtilComponent';

import AppConstant, {DEBUG_MODE} from '../../../constants/AppConstant';

const {width} = Dimensions.get('window');

/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;

//商品详情主页
export default class GoodsDetailTopBar extends Com {
    constructor(props) {
        super(props);

        this.state = {
            topBarShow: this.props.topBarShow,
            canBack: true,
        };

    }


    componentWillReceiveProps(nextProps) {
        if (this.state.topBarShow !== nextProps.topBarShow) {
            this.state.topBarShow = nextProps.topBarShow;
        }
    }

    componentWillUnmount() {
        //关闭当前页面的时候 清除计时器
        this.canBackTimeClick && clearTimeout(this.canBackTimeClick);
    }


    //商品详情顶部导航栏
    render() {

        let allDatas = this.props.allDatas;

        return (
            <View
                style={[styles.topBar,
                    {
                        backgroundColor: 'transparent',
                        borderBottomColor: 'transparent',
                        borderBottomWidth: StyleSheet.hairlineWidth
                    },
                    {paddingTop: getStatusHeight(), paddingBottom: ScreenUtils.scaleSize(10)},
                ]}
                ref={(ref) => {
                    this.props.titleBar(ref);
                }}
            >

                <View style={{flex: 1, marginLeft: 10}}>
                    <TouchableOpacity
                        style={this.state.topBarShow ? {
                            width: 30,
                            height: 30,
                            justifyContent: 'center',
                            alignItems: 'center'
                        } : {
                            width: 30,
                            height: 30,
                            justifyContent: 'center',
                            alignItems: 'center',
                            backgroundColor: 'rgba(0,0,0,0.5)',
                            borderRadius: 150
                        }}
                        activeOpacity={1}
                        onPress={() => {

                            //无论之前是否允许点击  手动点击后2秒后允许点击
                            this.canBackTimeClick = setTimeout(() => {
                                this.setState({canBack: true});
                            }, 1500);
                            //判断是否允许点击返回键
                            if (this.state.canBack) {
                                //埋点 点击返回商品详情界面
                                DataAnalyticsModule.trackEvent2("AP1706C032E002001C005001", "");

                                //TODO 返回处理
                                RouteManager.routeBack(this.props.beforepage);
                                this.setState({canBack: false});
                            }


                        }}>

                        <Image style={[styles.topBarImage, {
                            width: ScreenUtils.scaleSize(22),
                            height: ScreenUtils.scaleSize(28)
                        }]}
                               source={this.state.topBarShow ? require('../../../../foundation/Img/goodsdetail/Icon_BackSingle_@3x.png') : require('../../../../foundation/Img/goodsdetail/Icon_WhiteSingle_@3x.png')}
                               resizeMode={'stretch'}/>
                    </TouchableOpacity>
                </View>


                <TouchableOpacity activeOpacity={1} style={[{flex: 0, marginRight: 20}, this.state.topBarShow ? {
                    width: 30,
                    height: 30,
                    justifyContent: 'center',
                    alignItems: 'center'
                } : {
                    width: 30,
                    height: 30,
                    justifyContent: 'center',
                    alignItems: 'center',
                    backgroundColor: 'rgba(0,0,0,0.5)',
                    borderRadius: 150
                }]} onPress={() => {

                    //埋点 点击分享弹框
                    DataAnalyticsModule.trackEvent2("AP1706C032E002001C005002", "");

                    let content = {
                        title: "精选商品为您推荐：" + allDatas.goodsDetail.item_name,
                        image_url: allDatas.goodsDetail.shareImg,
                        target_url: AppConstant.H5_BASE_URL + "/detail/" + allDatas.goodsDetail.item_code,
                    }

                    if (Platform.OS === 'ios') {

                        RouteManager.routeJump({
                            page: routeConfig.Share,
                            param: {
                                title: content.title,
                                text: '',
                                image: content.image_url,
                                url: content.target_url
                            },
                            fromRNPage: routeConfig.GoodsDetailMain,
                        })


                    } else {

                        RouteManager.routeJump({
                            page: routeConfig.Share,
                            param: {
                                title: content.title,
                                content: '',
                                image_url: content.image_url,
                                target_url: content.target_url
                            },
                            fromRNPage: routeConfig.GoodsDetailMain,
                        })
                    }


                }}>
                    <Image style={styles.topBarImage}
                           source={this.state.topBarShow ? require('../../../../foundation/Img/goodsdetail/icon_share666_@3x.png') : require('../../../../foundation/Img/header/icon_share_@2x.png')}
                           resizeMode={'contain'}/>
                </TouchableOpacity>

                <TouchableOpacity activeOpacity={1} style={[{flex: 0, marginRight: 10}, this.state.topBarShow ? {
                    width: 30,
                    height: 30,
                    justifyContent: 'center',
                    alignItems: 'center'
                } : {
                    width: 30,
                    height: 30,
                    justifyContent: 'center',
                    alignItems: 'center',
                    backgroundColor: 'rgba(0,0,0,0.5)',
                    borderRadius: 150
                }]} onPress={() => {

                    //埋点 点击更多
                    DataAnalyticsModule.trackEvent2("AP1706C032E002001C005003", "");

                    this.props.showModal();

                    // this.setState({showModal: !this.state.showModal})
                }}>
                    {allDatas.store ?
                        <Image style={styles.topBarImage}
                               source={this.state.topBarShow ? require('../../../../foundation/Img/goodsdetail/icon_more666_@3x.png') : require('../../../../foundation/Img/header/icon_more_@2x.png')}
                               resizeMode={'contain'}/> : null
                    }

                </TouchableOpacity>

            </View>
        )
    }

}
const ts12 = Fonts.tag_font();
const ts14 = Fonts.standard_normal_font();
const ts16 = Fonts.page_normal_font();
const ts18 = Fonts.page_title_font();
const cb = Colors.text_black;
const cg = Colors.text_dark_grey;
const cr = Colors.main_color;
const cy = Colors.yellow;
const styles = StyleSheet.create({
    topBar: {
        flexDirection: 'row',
        position: 'absolute',
        top: 0,
        left: 0,
        // backgroundColor:'#0f0',
        width: width,
        backgroundColor: 'rgba(225,225,225, 0)',
        alignItems: 'center',
        justifyContent: 'flex-end'
    },
    topBarImage: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(36),
    },
});

