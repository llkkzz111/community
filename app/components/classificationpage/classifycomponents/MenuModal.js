/**
 * Created by wangwenliang on 2017/5/9.
 * 商品详情顶部的弹出菜单
 */
import React, {Component, PureComponent} from 'react';
import {
    StyleSheet,
    View,
    Text,
    Image,
    TouchableOpacity,
    Modal,
    Dimensions,
    ART,
    Platform
} from 'react-native'
import {Actions} from 'react-native-router-flux';
import KeFuRequest from '../../../../foundation/net/GoodsDetails/KeFuRequest';
import StoreDetailHtml5Request from '../../../../foundation/net/home/store/StoreDetailHtml5Request';
import Immutable from 'immutable';
import * as routeConfig from '../../../config/routeConfig';

import * as RouteConfig from '../../../config/routeConfig';
import RnConnect from '../../../config/rnConnect';
import Global from '../../../../app/config/global';

//埋点
import {DataAnalyticsModule} from '../../../config/AndroidModules';
import * as LocalStorage from '../../../../foundation/LocalStorage';
let topPalt = Platform.select({
    ios: {
        top: ScreenUtils.scaleSize(155)
    },
    android: {
        top: ScreenUtils.scaleSize(100)
    }
});

const {width, height} = Dimensions.get('window');
let mwidth = ScreenUtils.scaleSize(162);
let mheight = ScreenUtils.scaleSize(170);
const bgColor = '#2d2d2d';
// const top = ScreenUtils.scaleSize(132);
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import * as RouteManager from '../../../../app/config/PlatformRouteManager';
/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;

export default class MenuModal extends Com {
    constructor(props) {
        super(props);
        this.state = {
            isVisible: this.props.show,
        }

        if (this.props.allDatas.store.gmallYn != "N") {
            mheight = ScreenUtils.scaleSize(250);
        }

    }

    componentWillReceiveProps(nextProps) {
        this.setState({isVisible: nextProps.show});
    }

    closeModal() {
        this.setState({
            isVisible: false
        });
        this.props.closeModal(false);
    }

    //东东客服url请求
    kefuRequest() {
        if (this.kefuR) {
            this.kefuR.setCancled(true)
        }
        this.kefuR = new KeFuRequest({
            order_no: "",
            item_code: this.props.allDatas.goodsDetail.item_code || "",
            imsource: "",
            last_sale_price: this.props.allDatas.goodsDetail.last_sale_price || "",
        }, "GET");
        this.kefuR.showLoadingView(true).start((response) => {
            // alert(JSON.stringify(response));
            if (response.code != null && response.code === 200 && response.data != null && response.data.url) {

                this.closeModal();

                Actions.VipPromotionGoodsDetail({value: response.data.url});


            } else {
            }
        }, (err) => {
            // console.log(JSON.stringify(err));
        });
    }

    storeRequest(contentCode) {
        let params = {
            id: 'AP1706A045',
            contentCode: String(contentCode)
        }
        this.StoreDetailHtml5Request = new StoreDetailHtml5Request(params, 'GET');
        this.StoreDetailHtml5Request.start((response) => {
            let object = Immutable.fromJS(response);
            // this.setState({url: object.get('destinationUrl')})
            Actions.VipPromotionGoodsDetail({value: object.get('destinationUrl')});
        }, (error) => {
        });
    }

    render() {
        let {top} = topPalt;
        const path = ART.Path();
        path.moveTo(width - 10 - mwidth * 1 / 3 + 3, top);
        path.lineTo(width - 10 - mwidth * 1 / 3 + 9, top - 7);
        path.lineTo(width - 10 - mwidth * 1 / 3 + 15, top);
        path.close();
        return (
            <Modal
                transparent={true}
                visible={this.state.isVisible}
                animationType={'fade'}
                onRequestClose={() => this.closeModal()}>
                <TouchableOpacity style={styles.container} activeOpacity={1} onPress={() => this.closeModal()}>
                    <ART.Surface width={width} height={100}>
                        <ART.Shape d={path} fill={bgColor}/>
                    </ART.Surface>
                    <View style={[styles.modal, {height: mheight}]}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                this.closeModal();

                                //埋点 点击返回首页
                                DataAnalyticsModule.trackEvent2("AP1706C032B042001C003001", "");

                                RouteManager.resetToHome();
                            }}
                            style={[styles.itemView, {
                                borderColor: '#999',
                                borderBottomWidth: 1
                            }]}
                        >
                            <Image style={styles.imgStyle}
                                   resizeMode={"stretch"}
                                   source={require('../../../../foundation/Img/goodsdetail/Icon_home_line_@3x.png')}/>
                            <Text
                                allowFontScaling={false}
                                style={styles.textStyle}>首页</Text>
                        </TouchableOpacity>

                        {this.props.allDatas.store.gmallYn === "Y" &&
                        this.props.allDatas.store.gmallUrl !== null &&
                        this.props.allDatas.store.gmallUrl !== "" &&
                        this.props.allDatas.store.gmallUrl &&

                        <TouchableOpacity activeOpacity={1}
                                          onPress={() => {

                                              //埋点 点击进入店铺
                                              DataAnalyticsModule.trackEvent2("AP1706C032B042001C003002", "");

                                              this.closeModal();
                                              {/*Actions.StoreDetailsFromGoodsDetail({title:this.props.allDatas.store.gmallName, contentCode: this.props.allDatas.store.gmallSetNum});*/}
                                              {/*this.storeRequest(this.props.allDatas.store.gmallSetNum);*/}
                                              if (this.props.allDatas.store.gmallUrl) {
                                                  Actions.VipPromotionGoodsDetail({value: this.props.allDatas.store.gmallUrl});
                                              }
                                          }}
                                          style={[styles.itemView, {
                                              borderColor: '#999',
                                              borderBottomWidth: 1
                                          }]}>
                            <Image style={styles.imgStyle}
                                   resizeMode={"stretch"}
                                   source={require('../../../../foundation/Img/goodsdetail/icon_shop_white_@3x.png')}/>
                            <Text
                                allowFontScaling={false}
                                style={styles.textStyle}>店铺</Text>
                        </TouchableOpacity>
                        }

                        <TouchableOpacity activeOpacity={1} onPress={() => {


                            if (Global.token === '' || Global.tokenType === 'guest') {

                                RouteManager.routeJump({
                                    page: routeConfig.Login,
                                    fromRNPage: routeConfig.GoodsDetailMain,
                                }, (event) => {
                                    if (event.tokenType === "self") {
                                        this.closeModal();
                                        this.props.refreshGoodsDetailDatas();
                                    }
                                })
                            } else {
                                this.kefuRequest();
                            }

                            //埋点 点击联系客服
                            DataAnalyticsModule.trackEvent2("AP1706C032B042001C003003", "");
                        }}
                                          style={styles.itemView}>
                            <Image style={styles.imgStyle}
                                   resizeMode={"stretch"}
                                   source={require('../../../../foundation/Img/goodsdetail/Icon_customerservice_whiteline_@3x.png')}/>
                            <Text
                                allowFontScaling={false}
                                style={styles.textStyle}>客服</Text>
                        </TouchableOpacity>
                    </View>
                </TouchableOpacity>
            </Modal>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        width: width,
        height: height,
    },
    modal: {
        backgroundColor: bgColor,
        // opacity:0.8,
        width: mwidth,
        position: 'absolute',
        left: width - mwidth - 10,
        padding: 5,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 3,
        ...topPalt
    },
    itemView: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        flex: 1,
    },
    textStyle: {
        color: '#fff',
        fontSize: ScreenUtils.scaleSize(30),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    imgStyle: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
    }
});
