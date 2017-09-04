/**
 * Created by wangwenliang on 2017/8/8.
 * 商品详情顶部 图片viewpager
 */

'use strict';
import {
    StyleSheet,
    View,
    Text,
    Image,
    TouchableOpacity,
    Platform,
    ScrollView
} from 'react-native';
import {
    routeConfig,
    RouteManager,
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Colors,
} from '../../../config/UtilComponent';
import Carousel from '../../../../foundation/common/loop_carousel/Carousel';
import ViewPager from 'react-native-viewpager';
import Swiper from 'react-native-swiper';

const paddingBothSide = ScreenUtils.scaleSize(30);
const ViewPagerHeight = ScreenUtils.scaleSize(692);

/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;

//商品详情主页
export default class GoodsDetailTopViewPager extends Com {
    constructor(props) {
        super(props);

        this.state = {
            topPage: 0,
        };
    }


    /**
     * 渲染banner
     * @private
     */
    _renderBanner(allDatas) {

        if (allDatas && allDatas.goodsShow && allDatas.goodsShow.length > 0 && allDatas.goodsShow[1].itemImages) {

            if (allDatas.goodsShow[1].itemImages.lastIndexOf('a') == -1) {
                allDatas.goodsShow[1].itemImages.push('a');
            }
            let itemImages = allDatas.goodsShow[1].itemImages;

            return (
                <View style={{width: ScreenUtils.screenW, height: ViewPagerHeight}}>

                    <Swiper
                        ref="_swiper"
                        showsPagination={false}
                        loop={false}
                        onIndexChanged={
                            (pageNum) => {
                                if (pageNum == itemImages.length - 1) {
                                    this.props.scrollDetails()
                                    this.refs._swiper.scrollBy(0, false);
                                }
                                this.setState({
                                    topPage: pageNum
                                });
                            }}
                    >
                        {itemImages.map((item, index) => {
                            if (index === itemImages.length - 1) {
                                return (
                                    <View style={{
                                        alignItems: 'center', flexDirection: 'row',
                                        width: ScreenUtils.screenW, height: ViewPagerHeight,
                                        paddingLeft: ScreenUtils.scaleSize(30),
                                    }}>

                                        <Image source={require('../../../../foundation/Img/goodsdetail/Artboard.png')}
                                               style={{
                                                   width: ScreenUtils.scaleSize(30),
                                                   height: ScreenUtils.scaleSize(30),
                                                   marginRight: ScreenUtils.scaleSize(15),
                                               }}/>
                                        <Text style={{
                                            width: ScreenUtils.scaleSize(30),
                                            color: '#333', fontSize: ScreenUtils.setSpText(24)
                                        }}>继续滑动查看图文详情</Text>

                                    </View>)
                            } else {
                                return (
                                    <Image
                                        style={{width: ScreenUtils.screenW, height: ViewPagerHeight}}
                                        source={{uri: (item.imageL && item.imageL.length > 0) ? item.imageL : ''}}
                                    />

                                );
                            }
                        })
                        }
                    </Swiper>


                </View>
            )
                ;
        }
        return null;
    }


    render() {

        let allDatas = this.props.allDatas;

        return (
            <View style={{height: ViewPagerHeight, backgroundColor: Colors.background_grey}}>
                {/*4 渲染banner*/}
                {this._renderBanner(allDatas)}

                {/*5 顶部商品货号*/}
                <View style={styles.numView}>
                    <Text allowFontScaling={false}
                          style={styles.num}>货号：{allDatas.goodsDetail.newitem_code + ''} </Text>
                </View>

                {/*6 banner滑动指示器*/}
                {(allDatas.goodsShow[1].itemImages != null && allDatas.goodsShow[1].itemImages.length > 0 && this.state.topPage !== allDatas.goodsShow[1].itemImages.length - 1) ?
                    <View style={styles.bannerView}>
                        <Text allowFontScaling={false}
                              style={styles.bannerText}>{(this.state.topPage + 1) + ""}/{allDatas.goodsShow.length > 1 && allDatas.goodsShow[1].itemImages != null && (allDatas.goodsShow[1].itemImages.length - 1 + '')}</Text>
                    </View> : null
                }

                {/*7 播放视频图标*/}

                {(allDatas.goodsShow[0].item_video_url && allDatas.goodsShow[0].item_video_url.length > 0) ?
                    <TouchableOpacity
                        style={styles.videoView}
                        onPress={() => {
                            //点击播放视频 埋点 文档中没有埋点id
                            // DataAnalyticsModule.trackEvent3("", "", {
                            // type: "视频",
                            // itemcode: allDatas.goodsDetail.item_code
                            // });

                            RouteManager.routeJump({
                                page: routeConfig.PlayVideo,
                                param: {
                                    item_video_url: allDatas.goodsShow[0].item_video_url
                                },
                                fromRNPage: routeConfig.GoodsDetailMain,
                            })
                        }}
                    >
                        <Image
                            source={require('../../../../foundation/Img/goodsdetail/play.png')}
                            style={styles.videoImage}
                        />
                    </TouchableOpacity> : null
                }

            </View>
        )
    }


}

const styles = StyleSheet.create({
    numView: {
        position: 'absolute',
        top: ViewPagerHeight - 45,
        left: paddingBothSide,
        paddingTop: 6,
        paddingBottom: 6,
        paddingLeft: paddingBothSide,
        paddingRight: paddingBothSide,
        backgroundColor: 'rgba(0,0,0,0.5)',
        borderRadius: 3,
    },
    num: {
        fontSize: ScreenUtils.setSpText(24),
        color: 'white',
        textAlign: 'center'
    },
    bannerView: {
        position: 'absolute',
        top: ViewPagerHeight - 50,
        left: ScreenUtils.screenW - paddingBothSide - 40,
        height: ScreenUtils.scaleSize(70),
        width: ScreenUtils.scaleSize(70),
        backgroundColor: 'rgba(0,0,0,0.5)',
        borderRadius: ScreenUtils.scaleSize(35),
        justifyContent: 'center',
        alignItems: 'center'
    },
    bannerText: {
        fontSize: ScreenUtils.setSpText(24),
        color: 'white',
        textAlign: 'center',
        includeFontPadding: false,
        textAlignVertical: 'center',
        // backgroundColor:'red'
    },
    videoView: {
        position: 'absolute',
        top: ViewPagerHeight - 50 - ScreenUtils.scaleSize(90),
        left: ScreenUtils.screenW - paddingBothSide - 40,
        height: ScreenUtils.scaleSize(70),
        width: ScreenUtils.scaleSize(70),
        justifyContent: 'center',
        alignItems: 'center'
    },
    videoImage: {
        width: ScreenUtils.scaleSize(70),
        height: ScreenUtils.scaleSize(70),
        resizeMode: 'stretch'
    }

});

