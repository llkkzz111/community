/**
 * @author Xiang
 *
 * 分类频道页
 */
import React from 'react'
import {
    StyleSheet,
    View,
    Text,
    Image,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    FlatList,
    StatusBar,
    Platform,
    NetInfo,
} from 'react-native';
import Toast, {DURATION} from 'react-native-easy-toast';
import * as routeConfig from '../../config/routeConfig';
import NetErro from '../../components/error/NetErro';
import RnConnect from '../../config/rnConnect';
const {width} = Dimensions.get('window');
import Fonts from '../../config/fonts';
import Colors from '../../config/colors';
import Swiper from 'react-native-swiper';

import  ScrollTabList from '../../../foundation/classification/ScrollTabList'
import {Actions} from "react-native-router-flux";
import ClassificationChannelRequest from '../../../foundation/net/classification/ClassificationChannelRequest';
import * as ScreenUtil from "../../../foundation/utils/ScreenUtil";
let requestBody = {
    id: 'AP1706A005',
    lgroup: '',
};
//let defaultUrl = 'http://img5.duitang.com/uploads/item/201409/18/20140918044028_ejynt.png';
//第一行数据标记
let isBrandRow1 = true;
let isPromotionRow1 = true;
//第三屏列表位置
let position = 0;
import {getStatusHeight}from '../../../foundation/common/NavigationBar';
import {DataAnalyticsModule} from '../../config/AndroidModules';
//import routeByUrl from '../../../app/components/homepage/RoutePageByUrl';
import * as RouteManager from '../../../app/config/PlatformRouteManager';
var key = 0;
//埋点参数
let codeValue = '';
let pageVersionName = '';
export default class ClassificationChannel extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            dataSource: [],
            showBackTop: false,
            noNet: false,
        };
        this.renderSwiper = this.renderSwiper.bind(this);
        this.renderHotProduct = this.renderHotProduct.bind(this);
        this.renderVideoProduct = this.renderVideoProduct.bind(this);
        this.renderProductTag = this.renderProductTag.bind(this);
        this.renderPromotionRow1 = this.renderPromotionRow1.bind(this);
        this.renderPromotionRow2 = this.renderPromotionRow2.bind(this);
        this.loadPage = this.loadPage.bind(this);
        this.renderNetStatus = this.renderNetStatus.bind(this);
    }

    loadPage(item) {
        //埋点
        DataAnalyticsModule.trackEvent3(item.codeValue, "", {
            'pID': codeValue,
            'vID': pageVersionName
        });
        //目标地址类型 1商品 2站内页面 3手动输入 4无 5数据刷新 6h5页面
        switch (item.destinationUrlType) {
            case 1:
                item.destinationUrl && Actions.GoodsDetailMain({itemcode: item.destinationUrl});
                break;
            case 2:
                break;
            case 3:
            case 6:
                if (item.destinationUrl && item.destinationUrl.indexOf('http') != -1) {
                    //Actions.VipPromotion({value: item.destinationUrl});
                    //routeByUrl(item.destinationUrl);
                    RouteManager.routeJump({
                        page: routeConfig.WebView,
                        param: {
                            url: item.destinationUrl,
                            fromPage: routeConfig.ClassificationChannel,
                        },
                        fromPage: routeConfig.ClassificationChannel,
                    })

                }
                break;
        }
    }

    componentWillMount() {
        NetInfo.isConnected.fetch().done((isConnected) => {
            if (isConnected) {
                //有网络
                setTimeout(() => {
                    this.requestChannelData();
                }, 300);
            } else {
                //无网络
                this.setState({
                    noNet: true,
                });
            }
        });
    }

    //频道页首屏数据请求
    requestChannelData() {
        requestBody.id = this.props.destinationUrl;
        requestBody.lgroup = this.props.lgroup;
        new ClassificationChannelRequest(requestBody, 'GET').showLoadingView().setShowMessage(true).start(
            (jsonResponse) => {
                if (jsonResponse.code === 200) {
                    try {
                        if (jsonResponse.data) {
                            this.setState({
                                dataSource: jsonResponse.data.packageList ? jsonResponse.data.packageList : [],
                            });
                            codeValue = jsonResponse.data.codeValue;
                            pageVersionName = jsonResponse.data.pageVersionName;
                            //埋点
                            DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                        } else {
                            this.refs.toast.show(jsonResponse.message, DURATION.LENGTH_LONG);
                        }
                    } catch (e) {
                        //this.refs.toast.show('e:'+e, DURATION.LENGTH_LONG);
                    }
                } else {
                    this.refs.toast.show(jsonResponse.message, DURATION.LENGTH_LONG);
                }
            },
            (e) => {
                // this.refs.toast.show('e:'+e, DURATION.LENGTH_LONG);
                this.setState({
                    noNet: true,
                });
            }
        );
    }

    componentWillUnmount() {
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }

    //scrollView的滚动事件
    _onScroll(e) {
        let contentOffsetY = e.nativeEvent.contentOffset.y
        if (contentOffsetY >= ScreenUtil.screenH) {
            this.setState({
                showBackTop: true
            })
        } else {
            this.setState({
                showBackTop: false
            })
        }
    }

    render() {
        return (
            <View style={{flex: 1, ...Platform.select({ios: {marginTop: -22}})}}>
                {this._renderStatus()}
                <View style={[styles.searchRow, {paddingTop: getStatusHeight()}]}>

                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => {
                            Actions.pop();
                        }} style={styles.headerTouchArea}>
                        <Image source={require('../../../foundation/Img/searchpage/Icon_back_@3x.png')}
                               style={styles.searchRowBackIcon}/>
                    </TouchableOpacity>
                    <Text
                        allowFontScaling={false}
                        style={styles.pageTitleText}>{this.props.title ? this.props.title : ''}</Text>
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => {
                            Actions.MessageFromClassificationChannel({fromPage: 'ClassificationChannel'});
                        }} style={styles.headerTouchArea}>
                        <Image
                            source={ require('../../../foundation/Img/searchpage/Icon_message_@3x.png')}
                            style={styles.listMessageIcon}/>
                    </TouchableOpacity>
                </View>
                <View style={{height: ScreenUtil.scaleSize(1), backgroundColor: Colors.line_grey}}/>
                {   this.state.noNet ? this.renderNetStatus() :
                    this.state.dataSource.length > 0 ?
                        <ScrollView
                            scrollEventThrottle={20}
                            onScroll={(e) => this._onScroll(e)}
                            ref="ScrollView"
                            style={{flex: 1,}}>
                            <View style={{flex: 1, backgroundColor: Colors.line_grey,}}>
                                {
                                    this.state.dataSource.map((item, index) => {
                                        if (!item) {
                                            return;
                                        }
                                        switch (item.packageId) {
                                            case '2':
                                                //头部轮播图
                                                return this.renderSwiper(item.componentList ? item.componentList : []);
                                            case '3':
                                                //商品分组（二级分类锚点到底部第三屏）
                                                if (item.componentList) {
                                                    let groupList;
                                                    if (item.componentList.length > 9) {
                                                        groupList = item.componentList.slice(0, 10)
                                                    } else {
                                                        groupList = item.componentList;
                                                    }
                                                    return <ProductGroup
                                                        pressed={(index) => {
                                                            this.refs.ScrollView && this.refs.ScrollView.scrollTo(position);
                                                            this.refs.ScrollTabList && this.refs.ScrollTabList.selectTabTitlePosition(index);
                                                        }}
                                                        list={groupList}/>;
                                                }
                                            case '10':
                                                //图片广告
                                                let list = item.componentList ? item.componentList[0] : null;
                                                let imgUrl;
                                                if (list) {
                                                    imgUrl = list.firstImgUrl ? list.firstImgUrl : '';
                                                } else {
                                                    imgUrl = ''
                                                }
                                                return imgUrl ?
                                                    <TouchableOpacity
                                                        activeOpacity={1}
                                                        style={styles.imgBlockList}
                                                        onPress={() => {
                                                            this.loadPage(item.componentList[0]);
                                                        }}>
                                                        <Image style={styles.imgBlock}
                                                               source={{uri: imgUrl}}/>
                                                    </TouchableOpacity>
                                                    : null;
                                            case '12':
                                                //标签
                                                return this.renderProductTag(item.componentList ? item.componentList : []);
                                            case '14':
                                                //品牌推荐
                                                if (isBrandRow1) {
                                                    isBrandRow1 = !isBrandRow1;
                                                    return this.renderBrandRow1(item.componentList ? item.componentList : []);
                                                } else {
                                                    isBrandRow1 = !isBrandRow1;
                                                    return this.renderBrandRow2(item.componentList ? item.componentList : []);
                                                }
                                            case '17':
                                                //视频精选
                                                return this.renderVideoProduct(item.componentList[0].componentList ? item.componentList[0].componentList : []);
                                            case '73':
                                                //七天热卖商品
                                                return this.renderHotProduct(item.componentList[0].componentList ? item.componentList[0].componentList : []);
                                            case'78':
                                                //大牌教你做大师
                                                if (isPromotionRow1) {
                                                    isPromotionRow1 = !isPromotionRow1;
                                                    return this.renderPromotionRow1(item.componentList ? item.componentList : []);
                                                } else {
                                                    isPromotionRow1 = !isPromotionRow1;
                                                    return this.renderPromotionRow2(item.componentList ? item.componentList : []);
                                                }
                                                break;
                                            case '79':
                                                //底部第三屏商品列表
                                                if (item.componentList) {
                                                    if (item.componentList[0]) {
                                                        return item.componentList[0].componentList ?
                                                            <View
                                                                style={{flex: 1}}
                                                                onLayout={(event) => {
                                                                    position = event.nativeEvent.layout.y;
                                                                }}
                                                            >
                                                                <ScrollTabList
                                                                    ref="ScrollTabList"
                                                                    scrollToPageTop={() => {
                                                                        this.refs.ScrollView && this.refs.ScrollView.scrollTo(position);
                                                                    }}
                                                                    firstClassData={item.componentList[0].componentList}
                                                                    secondClassData={item.componentList[1] ? item.componentList[1].componentList : []}
                                                                    productData={item.componentList[2] ? item.componentList[2].componentList : []}
                                                                    productListId={item.componentList[2] ? item.componentList[2].id : ''}
                                                                />
                                                            </View> :
                                                            null;
                                                    }
                                                }
                                                return;
                                        }
                                    })
                                }
                            </View>
                        </ScrollView> : null
                }
                {
                    this.state.showBackTop && this.state.dataSource && this.state.dataSource.length > 0 ?
                        <TouchableOpacity ref='backTopView'
                                          style={styles.backTopView}
                                          activeOpacity={1}
                                          onPress={() => {
                                              this.refs.ScrollView && this.refs.ScrollView.scrollTo(0)
                                          }}>
                            <Image style={styles.backTopImg}
                                   source={require('../../../foundation/Img/channel/classification_channel_icon_back_top.png')}>
                            </Image>
                        </TouchableOpacity>
                        :
                        null
                }

                <Toast ref="toast"/>
            </View>
        )
    }

    _renderStatus() {
        return (
            <StatusBar
                key={++key}
                translucent={true}
                barStyle={'dark-content'}
                backgroundColor={'transparent'}
            />
        );
    }

    //网络提示
    renderNetStatus() {
        return (
            <NetErro
                style={{flex: 1}}
                icon={require('../../../foundation/Img/searchpage/img_noNetWork_2x.png')}
                title={'您的网络好像很傲娇'}
                confirmText={'刷新试试'}
                onButtonClick={() => {
                    //根据不同的页面做不同的请求
                    NetInfo.isConnected.fetch().done((isConnected) => {
                        if (isConnected) {
                            this.setState({
                                noNet: false,
                            });
                            this.requestChannelData();
                        }
                    });
                }}
            />
        );
    }

    //头部轮播图
    renderSwiper(list) {
        if (!list) {
            return;
        }
        const swiperH = ScreenUtil.scaleSize(300);
        return (
            <Swiper
                height={ swiperH }
                width={width}
                paginationStyle={styles.paginationStyle}
                style={styles.swiper}
                autoplay={true}
                showsButtons={false}
                showsPagination={true}
                autoplayTimeout={5}
                dot={<View style={styles.dotStyle}/>}
                activeDot={<View style={styles.dotActiveStyle}/>}
            >
                {
                    list.map((item, i) => {
                        return (
                            <TouchableOpacity activeOpacity={1} onPress={() => {
                                this.loadPage(item);
                            }}>
                                <Image source={{uri: item.firstImgUrl ? item.firstImgUrl : ''}}
                                       style={styles.swiperItem}/>
                            </TouchableOpacity>
                        )
                    })
                }
            </Swiper>)
    }

    //七天热卖商品
    renderHotProduct(list) {
        if (!list || list.length <= 0) {
            return;
        }
        return (
            <View style={styles.block}>
                <View style={styles.blockTitle}>
                    <Image style={styles.blockTitleImg}
                           source={require('../../../foundation/Img/channel/Icon_seven_@3x.png')}/>
                    <Text
                        allowFontScaling={false}
                        style={styles.blockTitleText}>七天热卖商品</Text>
                </View>
                <View style={styles.divideLine}/>
                <FlatList
                    data={list}
                    horizontal={true}
                    getItemLayout={(data, index) => (
                        {length: ScreenUtil.scaleSize(361), offset: ScreenUtil.scaleSize(361) * index, index}
                    )}
                    showsHorizontalScrollIndicator={false}
                    renderItem={({item}) => {
                        return (
                            <TouchableOpacity activeOpacity={1} style={styles.hotItem} onPress={() => {
                                this.loadPage(item);
                            }}>
                                <Image style={styles.hotItemImg}
                                       source={{uri: item.firstImgUrl ? item.firstImgUrl : ''}}/>
                                <Text
                                    allowFontScaling={false}
                                    numberOfLines={2} style={styles.hotItemText}>{item.title}</Text>
                                <View style={styles.hotItemPrice}>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.itemPrice0}>￥</Text>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.itemPrice1}>{parseInt(item.salePrice.split('.')[1]) > 0 ? item.salePrice : item.salePrice.split('.')[0]}</Text>
                                </View>
                            </TouchableOpacity>
                        )
                    }}
                />
            </View>
        )
    }

    //视频精选
    renderVideoProduct(list) {
        if (!list || list.length === 0) {
            return;
        }
        return (
            <View style={styles.block}>
                <View style={styles.blockTitle}>
                    <Image style={styles.blockTitleImg}
                           source={require('../../../foundation/Img/channel/Icon_video_@3x.png')}/>
                    <Text
                        allowFontScaling={false}
                        style={styles.blockTitleText}>视频精选</Text>
                    <TouchableOpacity activeOpacity={1} style={styles.seeAllRow} onPress={() => {

                        Actions.Home_VideoList();
                    }}>
                        <Text
                            allowFontScaling={false}
                            style={styles.seeAllText}>查看全部</Text>
                        <Image style={styles.seeAllImg}
                               source={require('../../../foundation/Img/dialog/Icon_right_hui_@3x.png')}/>
                    </TouchableOpacity>
                </View>
                <ScrollView horizontal={true} showsHorizontalScrollIndicator={false}>
                    {
                        list.map((item, index) => {
                            return (
                                <TouchableOpacity
                                    activeOpacity={1}
                                    style={styles.videoItem}
                                    onPress={() => {
                                        // RnConnect.pushs({
                                        //     page: routeConfig.Homeocj_Video,
                                        //     param: {id: item.contentCode ? item.contentCode : ''}
                                        // }, (event) => {
                                        //     Actions.pop();
                                        //     NativeRouter.nativeRouter(event);
                                        // });
                                        RouteManager.routeJump({
                                            page: routeConfig.Video,
                                            param: {id: item.contentCode ? item.contentCode : ''}
                                        })
                                    }}>
                                    <Image style={styles.videoImg}
                                           source={{uri: item.firstImgUrl ? item.firstImgUrl : ''}}/>
                                    <Image style={styles.videoImgPlay}
                                           source={require('../../../foundation/Img/channel/Icon_btn_play_@3x.png')}/>
                                    <Text
                                        allowFontScaling={false}
                                        numberOfLines={2}
                                        style={styles.videoText}>{item.title}</Text>
                                </TouchableOpacity>
                            )
                        })
                    }

                </ScrollView>
            </View>
        )
    }

    //品牌推荐
    renderBrandRow1(data1) {
        if (!data1) {
            return;
        }
        return (
            <View style={styles.greyBlock}>
                <View style={styles.brandFlatList}>
                    {
                        data1.map((item, index) => {
                            if (!item.firstImgUrl) {
                                return;
                            }
                            return (
                                <TouchableOpacity
                                    activeOpacity={1}
                                    onPress={() => {
                                        this.loadPage(item);
                                    }}
                                    style={styles.brandItem}>
                                    <Text
                                        allowFontScaling={false}
                                        numberOfLines={1}
                                        style={styles.brandItemTitle}>{item.title}</Text>
                                    <Text
                                        allowFontScaling={false}
                                        numberOfLines={1}
                                        style={styles.brandItemText}>{item.subtitle}</Text>
                                    <View style={styles.brandImgRow}>
                                        <Image style={styles.brandImg}
                                               source={{uri: item.firstImgUrl ? item.firstImgUrl : ''}}/>
                                    </View>
                                </TouchableOpacity>)
                        })
                    }
                </View>
            </View>
        )
    }

    renderBrandRow2(data2) {
        if (!data2) {
            return;
        }
        return (
            <View style={[styles.greyBlock, {marginTop: 0}]}>
                <View style={styles.brandFlatList}>
                    {
                        data2.map((item, index) => {
                            if (!item.firstImgUrl) {
                                return;
                            }
                            return (
                                <TouchableOpacity style={styles.brandItem} activeOpacity={1}
                                                  onPress={() => {
                                                      this.loadPage(item);
                                                  }}
                                >
                                    <Text
                                        allowFontScaling={false}
                                        numberOfLines={1}
                                        style={styles.brandItemTitle}>{item.title}</Text>
                                    <Text
                                        allowFontScaling={false}
                                        numberOfLines={1}
                                        style={styles.brandItemText}>{item.subtitle}</Text>
                                    <View style={styles.brandImgContainer}>
                                        <Image style={styles.brandSingleImg}
                                               source={{uri: item.firstImgUrl ? item.firstImgUrl : ''}}/>
                                    </View>
                                </TouchableOpacity>
                            )
                        })
                    }
                </View>
            </View>
        );
    }

    //标签
    renderProductTag(list) {
        if (!list) {
            return;
        }
        return (
            <View style={[styles.greyBlock, {paddingLeft: 16, paddingRight: 16, paddingBottom: 12}]}>
                <View style={styles.tagRow}>
                    {
                        list.map((item, index) => {
                            if (!item.title) {
                                return;
                            }
                            return (
                                <TouchableOpacity style={styles.tagImg} activeOpacity={1} onPress={() => {
                                    item.lgroup && Actions.ClassificationProductFromChannel({itemCode: item.lgroup});
                                }}>

                                    {/*<Image style={styles.tagImg}
                                     source={require('../../../foundation/Img/channel/Icon_tagbg_@3x.png')}>*/}
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.tagText}
                                        numberOfLines={1}># {item.title.length > 5 ? item.title.substring(0, 5) : item.title}</Text>
                                    {/*</Image>*/}

                                </TouchableOpacity>
                            )
                        })
                    }
                </View>
            </View>
        )
    }

    //大牌教你做大师
    renderPromotionRow1(list) {
        if (!list) {
            return;
        }
        return (
            <View style={styles.greyBlock}>
                <View style={styles.blockTitle}>
                    <Text
                        allowFontScaling={false}
                        style={styles.blockTitleText}>• 大牌教你做大师 •</Text>
                </View>
                <View style={{flexDirection: 'row', marginTop: 1}}>
                    {
                        list.map((item, index) => {
                            let icon = '';
                            if (item.isNew === 1) {
                                icon = require('../../../foundation/Img/channel/tag_xin_@3x.png');
                            } else if (item.isNew === 2) {
                                icon = require('../../../foundation/Img/channel/tag_cu_@3x.png');
                            }
                            return (
                                <TouchableOpacity
                                    activeOpacity={1}
                                    onPress={() => {
                                        this.loadPage(item);
                                    }}
                                    style={[styles.promotionItem, {width: width / 3}]}>
                                    <Image style={styles.promotionImg}
                                           source={{uri: item.firstImgUrl ? item.firstImgUrl : ''}}/>
                                    <Image style={styles.promotionTypeImg}
                                           source={icon}/>
                                </TouchableOpacity>
                            )
                        })
                    }
                </View>
            </View>
        )
    }

    renderPromotionRow2(list) {
        if (!list) {
            return;
        }
        return (
            <View style={{flexDirection: 'row'}}>
                {
                    list.map((item, index) => {
                        let icon = '';
                        if (item.isNew === 1) {
                            icon = require('../../../foundation/Img/channel/tag_xin_@3x.png');
                        } else if (item.isNew === 2) {
                            icon = require('../../../foundation/Img/channel/tag_cu_@3x.png');
                        }
                        return (
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {
                                    this.loadPage(item);
                                }}
                                style={[styles.promotionItem, {width: width / 3}]}>
                                <Image style={styles.promotionImg}
                                       source={{uri: item.firstImgUrl ? item.firstImgUrl : ''}}/>
                                <Image style={styles.promotionTypeImg}
                                       source={icon}/>
                            </TouchableOpacity>
                        )
                    })
                }
            </View>
        )
    }
}

class ProductGroup extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            collapse: true,
        }
    }

    render() {
        return (
            <View style={styles.productGroup}>
                <FlatList
                    style={styles.groupFlatList}
                    getItemLayout={(data, index) => (
                        {
                            length: ScreenUtil.scaleSize(125) + 10,
                            offset: (ScreenUtil.scaleSize(125) + 10) * index,
                            index
                        }
                    )}
                    numColumns={5}
                    data={this.props.list}
                    renderItem={({item, index}) => {
                        if (item.firstImgUrl)
                            return (
                                <TouchableOpacity style={styles.groupItem}
                                                  activeOpacity={1}
                                                  onPress={() => {
                                                      this.props.pressed(index);
                                                  }}>
                                    {
                                        index === 9 ?
                                            <View style={{
                                                justifyContent: 'center',
                                                alignItems: 'center',
                                            }}>
                                                <Image
                                                    source={require('../../../foundation/Img/channel/icon_more_3x.png')}
                                                    style={styles.groupItemImg}/>
                                                <Text
                                                    allowFontScaling={false}
                                                    style={styles.groupItemText} numberOfLines={1}>更多分类</Text>
                                            </View> :
                                            <View style={{
                                                justifyContent: 'center',
                                                alignItems: 'center',
                                            }}>
                                                <Image source={{uri: item.firstImgUrl ? item.firstImgUrl : ''}}
                                                       style={styles.groupItemImg}/>
                                                <Text
                                                    allowFontScaling={false}
                                                    style={styles.groupItemText} numberOfLines={1}>{item.title}</Text>
                                            </View>
                                    }
                                </TouchableOpacity>
                            )
                    }}
                />
            </View>
        )
    }
}
const styles = StyleSheet.create({
    imgBlockList: {
        height: ScreenUtil.scaleSize(260),
        backgroundColor: Colors.background_white,
    },
    imgBlock: {
        marginLeft: ScreenUtil.scaleSize(20),
        marginRight: ScreenUtil.scaleSize(20),
        marginBottom: ScreenUtil.scaleSize(20),
        height: ScreenUtil.scaleSize(240),
        backgroundColor: Colors.background_white,
        borderRadius: ScreenUtil.scaleSize(110)
    },
    //titleBar
    searchRow: {
        backgroundColor: Colors.background_white,
        marginTop: ScreenUtil.scaleSize(1),
        flexDirection: 'row',
        alignItems: 'center',
        paddingVertical: ScreenUtil.scaleSize(20),
        paddingRight: ScreenUtil.scaleSize(20),
        paddingLeft: ScreenUtil.scaleSize(5)
    },
    pageTitleText: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        textAlign: 'center',
        fontSize: Fonts.page_title_font(),
        color: Colors.text_black,
    },
    headerTouchArea: {
        width: 30,
        height: 30,
        alignItems: "center",
        justifyContent: "center"
    },
    searchRowBackIcon: {
        height: ScreenUtil.scaleSize(24),
        width: ScreenUtil.scaleSize(16),
        resizeMode: 'contain',
    },
    titleSearchIcon: {
        width: 20,
        height: 20,
        resizeMode: 'contain',
    },
    listMessageIcon: {
        resizeMode: 'contain',
        width: ScreenUtil.scaleSize(44),
        height: ScreenUtil.scaleSize(41),
    },
    //block
    block: {
        backgroundColor: Colors.background_white,
        marginTop: 10,
    },
    greyBlock: {
        backgroundColor: Colors.background_grey,
        marginTop: 10,
    },
    blockTitle: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.background_white,
        height: ScreenUtil.scaleSize(85),
    },
    blockTitleImg: {
        height: ScreenUtil.scaleSize(44),
        width: ScreenUtil.scaleSize(42),
    },
    blockTitleText: {
        fontSize: ScreenUtil.setSpText(32),
        color: Colors.text_black,
        marginLeft: ScreenUtil.scaleSize(10),
    },
    //swiper
    swiper: {
        backgroundColor: Colors.background_white,
    },
    swiperItem: {
        width: width,
        resizeMode: 'stretch',
        backgroundColor: Colors.background_white,
        height: ScreenUtil.scaleSize(300),
    },
    paginationStyle: {
        bottom: ScreenUtil.scaleSize(20),
    },
    dotStyle: {
        backgroundColor: 'rgba(255,255,255,0.6)',
        width: ScreenUtil.scaleSize(10),
        height: ScreenUtil.scaleSize(10),
        borderRadius: ScreenUtil.scaleSize(5),
        marginHorizontal: ScreenUtil.scaleSize(7),
        marginTop: ScreenUtil.scaleSize(70),
    },
    dotActiveStyle: {
        backgroundColor: '#FF5C4F',
        width: ScreenUtil.scaleSize(10),
        height: ScreenUtil.scaleSize(10),
        borderRadius: ScreenUtil.scaleSize(5),
        marginHorizontal: ScreenUtil.scaleSize(7),
        marginTop: ScreenUtil.scaleSize(70),
    },
    //productGroup
    productGroup: {
        flex: 1,
        flexDirection: 'row',
        marginTop: 10,
    },
    groupFlatList: {
        // padding: 16,
        backgroundColor: Colors.background_white,
    },
    groupItem: {
        marginVertical: ScreenUtil.scaleSize(10),
        backgroundColor: Colors.background_white,
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    groupItemImg: {
        height: ScreenUtil.scaleSize(90),
        width: ScreenUtil.scaleSize(90),
    },
    groupItemText: {
        marginTop: 10,
        fontSize: Fonts.secondary_font(),
        color: Colors.text_black,
    },
    //hotProduct
    hotItem: {
        justifyContent: 'center',
        alignItems: 'center',
        width: ScreenUtil.scaleSize(180) + ScreenUtil.scaleSize(20) * 2,
        padding: ScreenUtil.scaleSize(20),
    },
    hotItemImg: {
        height: ScreenUtil.scaleSize(180),
        width: ScreenUtil.scaleSize(180),
        resizeMode: 'contain',
    },
    hotItemText: {
        marginTop: ScreenUtil.scaleSize(10),
        fontSize: Fonts.secondary_font(),
        color: Colors.text_black,
    },
    hotItemPrice: {
        marginTop: ScreenUtil.scaleSize(10),
        flexDirection: 'row',
        alignSelf: 'flex-start',
        alignItems: 'flex-end'
    },
    itemPrice0: {
        fontSize: ScreenUtil.setSpText(24),
        color: Colors.main_color,
    },
    itemPrice1: {
        fontSize: ScreenUtil.setSpText(30),
        color: Colors.main_color,
    },
    itemPriceDelete: {
        color: Colors.text_light_grey,
        textDecorationLine: 'line-through',
        marginLeft: 5,
    },
    //videos
    videoItem: {
        padding: 5,
        width: ScreenUtil.scaleSize(315),
    },
    videoImg: {
        height: ScreenUtil.scaleSize(315),
        resizeMode: 'cover',
    },
    videoImgPlay: {
        position: 'absolute',
        width: ScreenUtil.scaleSize(80),
        height: ScreenUtil.scaleSize(80),
        resizeMode: 'contain',
        left: ScreenUtil.scaleSize(315 - 80) / 2,
        top: ScreenUtil.scaleSize(315 - 70) / 2,
    },
    videoText: {
        color: Colors.text_black,
        fontSize: ScreenUtil.setSpText(28),
        marginTop: 10,
        marginBottom: 10,
    },
    seeAllRow: {
        position: 'absolute',
        right: 0,
        padding: 10,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
    },
    seeAllText: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtil.setSpText(26),
    },
    seeAllImg: {
        width: 15,
        height: 15,
        marginLeft: ScreenUtil.scaleSize(5),
        resizeMode: 'contain'
    },
    //brandProduct
    brandFlatList: {
        flexDirection: 'row',
        marginTop: ScreenUtil.scaleSize(1),
    },
    brandItem: {
        padding: 10,
        justifyContent: 'center',
        flex: 1,
        backgroundColor: Colors.background_white,
        marginRight: ScreenUtil.scaleSize(1),
        height: ScreenUtil.scaleSize(242)
    },
    brandItemTitle: {
        color: Colors.text_black,
        fontSize: ScreenUtil.setSpText(28),
        height: ScreenUtil.scaleSize(40),
        lineHeight: 16,
        marginTop: ScreenUtil.scaleSize(10),
        marginBottom: ScreenUtil.scaleSize(4),
    },
    brandItemText: {
        fontSize: ScreenUtil.setSpText(26),
        color: Colors.text_dark_grey,
        height: ScreenUtil.scaleSize(37),
        lineHeight: 14,
    },

    brandImgRow: {
        flexDirection: 'row',
        marginTop: ScreenUtil.scaleSize(6),
        height: ScreenUtil.scaleSize(138),
    },
    brandImg: {
        flex: 1,
        resizeMode: 'contain',
        height: ScreenUtil.scaleSize(138),
    },
    brandImgContainer: {
        marginTop: ScreenUtil.scaleSize(6),
        justifyContent: 'center',
        alignItems: 'center',
        height: ScreenUtil.scaleSize(138)
    },
    brandSingleImg: {
        resizeMode: 'contain',
        height: 80,
        width: 70,
        height: ScreenUtil.scaleSize(138)
    },
    //tag
    tagRow: {
        flexDirection: 'row',
        justifyContent: 'center',
        flexWrap: 'wrap',
    },
    tagImg: {
        width: 'auto',
        maxWidth: ScreenUtil.scaleSize(300),
        marginRight: ScreenUtil.scaleSize(20),
        marginTop: ScreenUtil.scaleSize(30),
        // paddingLeft: ScreenUtil.scaleSize(40),
        // paddingRight: ScreenUtil.scaleSize(20),
        paddingHorizontal: ScreenUtil.scaleSize(10),
        paddingVertical: ScreenUtil.scaleSize(10),
        resizeMode: 'cover',
        justifyContent: 'center',
        backgroundColor: '#FFFFFF',
        borderWidth: StyleSheet.hairlineWidth,
        borderColor: '#DDDDDD'
    },
    tagText: {
        color: Colors.text_dark_grey,
        marginLeft: ScreenUtil.scaleSize(5),
        fontSize: ScreenUtil.setSpText(24),
        backgroundColor: '#fff'
    },
    //promotion
    promotionItem: {
        backgroundColor: Colors.background_white,
        paddingTop: 10,
        paddingBottom: 10,
        marginRight: ScreenUtil.scaleSize(1),
        marginBottom: ScreenUtil.scaleSize(1),
        justifyContent: 'center',
        alignItems: 'center',
    },
    promotionBrandRow: {
        flexDirection: 'row',
    },
    promotionBrandContainer: {
        flex: 1,
    },
    promotionBrandImg: {
        width: 60,
        height: 20,
        marginTop: 10,
        resizeMode: 'contain',
    },
    promotionTypeImg: {
        width: 30,
        height: 30,
        position: 'absolute',
        top: 0,
        right: 10,
        resizeMode: 'contain',
    },
    promotionImg: {
        width: 110,
        height: 80,
        resizeMode: 'contain',
    },
    //divide
    divideLine: {
        height: ScreenUtil.scaleSize(1),
        backgroundColor: Colors.line_grey,
    },
    backTopView: {
        position: 'absolute',
        top: ScreenUtil.screenH - ScreenUtil.scaleSize(120),
        left: ScreenUtil.screenW - ScreenUtil.scaleSize(120),
        width: ScreenUtil.scaleSize(80),
        height: ScreenUtil.scaleSize(80),
    },
    backTopImg: {
        width: ScreenUtil.scaleSize(80),
        height: ScreenUtil.scaleSize(80),
    },
})
