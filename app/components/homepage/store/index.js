/**
 * Created by YASIN on 2017/5/31.
 * 商城首页
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    TouchableOpacity,
    StyleSheet,
    Platform,
    Text,
    Dimensions,
    FlatList
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import * as IsEmptyUtil from '../../../../foundation/utils/IsEmptyUtil';

import NavigationBar from '../../../../foundation/common/NavigationBar';

import Swiper from 'react-native-swiper';

import Styles from './Styles';

import StoreCommonTitle from './StoreCommonTitle';

import HotGoodsList from './HotGoodsList';

import WonderfulActivityList from './WonderfulActivityList';

import DiscountCouponList from './DiscountCouponList';

import PopularBrandList from './PopularBrandList';

import Datas from './Datas';

import {Actions}from 'react-native-router-flux';

import StoreIndexRequest from '../../../../foundation/net/home/store/StoreIndexRequest';

import StoreIndexListRequest from '../../../../foundation/net/home/store/StoreIndexListRequest';
import ViewPager from '../../../../foundation/common/lzy_viewpager/ViewPager';
import GoodRecommondItem from './GoodRecommondItem';
import CheckToken from '../../../../foundation/net/group/CheckToken';
import Global from '../../../config/global';
const {width} = Dimensions.get('window');

import Toast, {DURATION} from 'react-native-easy-toast';

let key = 0;

let img = require('../../../../foundation/Img/home/store/Icon_refresh_now.png');


import {DataAnalyticsModule} from '../../../config/AndroidModules';
let codeValue = '';
let pageVersionName = '';

export default class StoreIndex extends React.Component {
    // 构造
    constructor(props) {
        super(props);
        this.tabViews = [];
        this.changeTextColor = [];
        this.changeBtnBottomBorder = [];
        // 初始状态
        this.state = {
            hotGoodDatas: [],
            recommondDatas: [],
            brandStoreArray: '',
            wonderfulStoreArray: '',
            banners: [],
            coupons: [],
            wonderfulDatas: [],
            popularDatas: [],
            wonderfulRecoDatas: [],
            selectedTabIndex: 0,
            pageNum: 1,
            pageSize: 2,
            totalPage: -1,
            isRefresh: false,
            hasMore: false,
            showMessage: false,
            showEmpty: true
        };
        this._refresh = this._refresh.bind(this);
        this._onScroll = this._onScroll.bind(this);
        this._loadMore = this._loadMore.bind(this);
        this._updateCouponList = this._updateCouponList.bind(this);
        this.errorCallback = this.errorCallback.bind(this);
    }

    render() {
        return (
            <View style={styles.container}>
                {/*头部导航栏*/}
                {this._renderNav()}
                {/*好货推荐模块*/}
                {!this.state.showEmpty ?
                    <View style={{flex: 1}}>
                        <FlatList
                            data={this.state.recommondDatas}
                            onRefresh={() => {
                                this.setState({
                                    isRefresh: true
                                }, () => {
                                    this._refresh();
                                });
                            }}
                            refreshing={this.state.isRefresh}
                            renderItem={({item, index}) => (
                                <GoodRecommondItem
                                    selfCodeValue={item.codeValue}//自己的id
                                    codeValue={codeValue}//页面id
                                    pageVersionName={pageVersionName}//页面版本
                                    key={index}
                                    isMasterRecommond={item.contentType}
                                    itemCode={(IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(item.contentCode)) ? item.contentCode : ''}
                                    isStore={false}
                                    title={item.title}
                                    icon={{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(item.firstImgUrl)) ? item.firstImgUrl : ''}}
                                    price={item.salePrice}
                                    oldPrice={item.originalPrice}
                                    sellCount={item.salesVolume}
                                    sellDesc={item.inStock}
                                    integral={item.integral}
                                    gifts={item.gifts && typeof item.gifts !== 'undefined'}
                                />
                            )}
                            numColumns={2}
                            overScrollMode={'never'}
                            showsHorizontalScrollIndicator={false}
                            onScroll={this._onScroll}
                            scrollEventThrottle={50}
                            ref={(ref) => this.scrollView = ref}
                            ListHeaderComponent={() => {
                                return (
                                    <View style={{width: ScreenUtils.screenW}}>
                                        {/*头部banner*/}
                                        {this._renderHeaderBanner()}
                                        {/*热门商品*/}
                                        {this._renderHotGoods()}
                                        {/*大家都在抢-抵用券*/}
                                        {this._renderDiscountCoupon()}
                                        {/*精彩活动*/}
                                        {this._renderWonderfulActivity()}
                                        {/*时尚大牌*/}
                                        {this._renderPopularBrand()}
                                        {/*优品推荐*/}
                                        {this._renderNiceRecommond()}
                                        {/*好货推荐*/}
                                        {this._renderGoodRecommond()}
                                    </View>
                                );
                            }}
                            ListFooterComponent={() => {
                                if (this.state.hasMore) {
                                    return (
                                        <View style={styles.footerViewBg}>
                                            <Image style={styles.footerViewImg} source={img}/>
                                        </View>
                                    )
                                } else {
                                    return null;
                                }
                            }}
                            onEndReachedThreshold={0.1}
                            onEndReached={this._loadMore}
                        />
                        {/*渲染tabview*/}
                        {this._renderTabView()}
                        {/*渲染回到顶部view*/}
                        {this._renderBackTop()}
                    </View> : null}
                <Toast ref="toast" position={'center'}/>
            </View>
        );
    }

    /**
     * 渲染导航栏
     * @private
     */
    _renderNav() {
        return (
            <NavigationBar
                title={'商城'}
                renderRight={() => {
                    return (
                        <View style={styles.navRightStyle}>
                            <TouchableOpacity onPress={() => {
                                //跳转至消息列表页面
                                Actions.MessageFromHomeStore({fromPage: 'HomeStore'});
                            }} activeOpacity={1}>
                                <View>
                                    <Image
                                        style={styles.navRightCartStyle}
                                        source={require('../../../../foundation/Img/home/store/icon_message_.png')}
                                    />
                                    {this.state.showMessage ? (
                                        <View style={styles.messageImgBg}/>
                                    ) : null}
                                </View>
                            </TouchableOpacity>
                        </View>
                    )
                }}
                navigationBarBackgroundImage={require('../../../../foundation/Img/home/store/topbarbg.png')}
                navigationStyle={{height: ScreenUtils.scaleSize(128), ...Platform.select({ios: {marginTop: -22}})}}
                titleStyle={{
                    color: Colors.text_white,
                    backgroundColor: 'transparent',
                    fontSize: ScreenUtils.scaleSize(36)
                }}
                leftButton={require('../../../../foundation/Img/home/store/icon_back_white_.png')}
            />
        );
    }

    /**
     * 渲染头部广告
     * @private
     */
    _renderHeaderBanner() {
        return (
            <View style={styles.bannerContainerStyle}>
                {(this.state.banners && this.state.banners.length > 0) ? (
                    Platform.OS === 'ios' ? (
                        <Swiper
                            key={key}
                            height={ScreenUtils.scaleSize(350)}
                            autoplay={true}
                            paginationStyle={{bottom: ScreenUtils.scaleSize(10)}}
                            dot={<View style={Styles.swiper.dot}/>}
                            activeDot={<View style={Styles.swiper.activeDot}/>}>
                            {this.state.banners.map((banner, index) => {
                                return (
                                    <TouchableOpacity
                                        key={index}
                                        activeOpacity={1}
                                        onPress={() => {
                                            DataAnalyticsModule.trackEvent3(banner.codeValue, "", {
                                                'pID': codeValue,
                                                'vID': pageVersionName
                                            });
                                            if (banner.destinationUrl && typeof banner.destinationUrl !== 'undefined') {
                                                Actions.VipPromotion({value: banner.destinationUrl});
                                            }
                                        }}>
                                        <Image
                                            style={styles.headerBannerStyle}
                                            source={{uri: banner.firstImgUrl}}
                                        />
                                    </TouchableOpacity>
                                )
                            })}
                        </Swiper>) : (
                        <ViewPager
                            style={{height: ScreenUtils.scaleSize(350)}}
                            dataSource={new ViewPager.DataSource({
                                pageHasChanged: (p1, p2) => p1 !== p2,
                            }).cloneWithPages(this.state.banners)}
                            renderPage={(banner, pageID) => {
                                return (
                                    <TouchableOpacity
                                        key={pageID}
                                        activeOpacity={1}
                                        onPress={() => {
                                            DataAnalyticsModule.trackEvent3(banner.codeValue, "", {
                                                'pID': codeValue,
                                                'vID': pageVersionName
                                            });
                                            if (banner.destinationUrl && typeof banner.destinationUrl !== 'undefined') {
                                                Actions.VipPromotion({value: banner.destinationUrl});
                                            }
                                        }}>
                                        <Image
                                            style={styles.headerBannerStyle}
                                            source={{uri: banner.firstImgUrl}}
                                        />
                                    </TouchableOpacity>
                                )
                            }}
                            isLoop={true}
                            autoPlay={true}
                        />
                    )
                ) : null}
            </View>
        );
    }

    /**
     * 渲染热门商品
     * @private
     */
    _renderHotGoods() {
        if (this.state.hotGoodDatas && this.state.hotGoodDatas.length > 0) {
            return (
                <View>
                    <StoreCommonTitle
                        style={styles.hotGoodsTitleStyle}
                        title={Datas.modules.HOT_GOODS.name}
                        icon={Datas.modules.HOT_GOODS.icon}
                    />
                    {/*热门产品listview*/}
                    <View style={styles.hotGoodsListContainer}>
                        <HotGoodsList
                            codeValue={codeValue}
                            pageVersionName={pageVersionName}
                            datas={this.state.hotGoodDatas}
                        />
                    </View>
                </View>
            );
        } else {
            return null;
        }
    }

    /**
     * 渲染大家都在抢-抵用券
     * @private
     */
    _renderDiscountCoupon() {
        if (this.state.coupons && this.state.coupons.length > 0) {
            return (
                <View>
                    <StoreCommonTitle
                        style={styles.discountCouponStyle}
                        title={'热门抵用券'}
                        icon={Datas.modules.DISCOUNT_COUPON.icon}
                    />
                    {/*抵用券listview*/}
                    <DiscountCouponList
                        codeValue={codeValue}
                        pageVersionName={pageVersionName}
                        updateCouponList={this._updateCouponList}
                        errorCallback={(params) => {
                            this.errorCallback(params)
                        }}
                        datas={this.state.coupons}
                    />
                </View>
            );
        } else {
            return null;
        }
    }

    /**
     * 渲染精彩活动
     * @private
     */
    _renderWonderfulActivity() {
        if ((this.state.wonderfulDatas && this.state.wonderfulDatas.length > 0)) {
            return (
                <View>
                    <StoreCommonTitle
                        style={styles.wonderfulActivityStyle}
                        title={Datas.modules.WONDERFUL_ACTIVITY.name}
                        icon={Datas.modules.WONDERFUL_ACTIVITY.icon}
                    />
                    {(this.state.wonderfulDatas && this.state.wonderfulDatas.length > 0) ?
                        <WonderfulActivityList
                            codeValue={codeValue}
                            pageVersionName={pageVersionName}
                            datas={this.state.wonderfulDatas}/> : null}
                </View>
            );
        } else {
            return null;
        }
    }

    /**
     * 渲染时尚大牌
     * @private
     */
    _renderPopularBrand() {
        return (
            <View onLayout={({nativeEvent: {layout: {x, y, width, height}}}) => {
                if (this.popularY && this.popularY === y) {
                    return;
                }
                this.popularY = y;
            }}>
                <StoreCommonTitle
                    style={styles.popularBrandStyle}
                    title={Datas.modules.POPULAR_BRAND.name}
                    icon={Datas.modules.POPULAR_BRAND.icon}
                />
                <PopularBrandList
                    codeValue={codeValue}
                    pageVersionName={pageVersionName}
                    datas={this.state.popularDatas}
                    headerDatas={this.state.brandStoreArray}
                />
                {this._renderMore({
                    onPress: () => {
                        Actions.HomeStoreList({selectedIndex: 0});
                    }
                })}
            </View>
        );
    }

    /**
     * 下拉刷新数据的函数
     * @private
     */
    _refresh(flag = false) {
        if (this.storeIndexRequest) this.storeIndexRequest.setCancled(true);
        let params = {
            id: 'AP1706A013'
        };
        this.storeIndexRequest = new StoreIndexRequest(params, 'GET');
        if (flag) this.storeIndexRequest.showLoadingView();
        this.storeIndexRequest.start((response) => {
            codeValue = response.codeValue;
            pageVersionName = response.pageVersionName;
            //页面埋点
            DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
            this.setState({
                selectedTabIndex: 0,
                pageNum: 1,
                pageSize: 2,
                totalPage: -1,
                isRefresh: false,
                hasMore: false,
                showEmpty: false
            });
            let state = {};
            key++;
            if (response.banners) Object.assign(state, {banners: response.banners});
            if (response.hotDatas) Object.assign(state, {hotGoodDatas: response.hotDatas});
            if (response.coupons) Object.assign(state, {coupons: response.coupons});
            if (response.wonderfulDatas) Object.assign(state, {wonderfulDatas: response.wonderfulDatas});
            if (response.brandStoreArray) Object.assign(state, {brandStoreArray: response.brandStoreArray});
            if (response.popularDatas) Object.assign(state, {popularDatas: response.popularDatas});
            if (response.wonderfulStoreArray) Object.assign(state, {wonderfulStoreArray: response.wonderfulStoreArray});
            if (response.recommondDatas) Object.assign(state, {recommondDatas: response.recommondDatas});
            if (response.recommondQueryId) state.recommondQueryId = response.recommondQueryId;
            if (response.wonderfulRecoDatas) Object.assign(state, {wonderfulRecoDatas: response.wonderfulRecoDatas});
            this.setState(state);
        }, (error) => {
            this.setState({
                selectedTabIndex: 0,
                pageNum: 1,
                pageSize: 2,
                totalPage: -1,
                isRefresh: false,
                hasMore: false,
                showEmpty: false
            });
        });
    }

    /**
     * 渲染优品推荐
     * @private
     */
    _renderNiceRecommond() {
        return (
            <View onLayout={({nativeEvent: {layout: {x, y, width, height}}}) => {
                if (this.niceY && this.niceY === y) {
                    return;
                }
                this.niceY = y;
            }}>
                <StoreCommonTitle
                    style={styles.popularBrandStyle}
                    title={Datas.modules.NICE_RECOMMOND.name}
                    icon={Datas.modules.NICE_RECOMMOND.icon}
                    onPress={() => {
                        Actions.HomeStoreList();
                    }}
                />
                <PopularBrandList
                    codeValue={codeValue}
                    pageVersionName={pageVersionName}
                    datas={this.state.wonderfulRecoDatas}
                    headerDatas={this.state.wonderfulStoreArray}
                />
                {this._renderMore({
                    onPress: () => {
                        Actions.HomeStoreList({selectedIndex: 1});
                    }
                })}
            </View>
        );
    }

    /**
     * 渲染好货推荐
     * @private
     */
    _renderGoodRecommond() {
        if (this.state.recommondDatas && this.state.recommondDatas.length > 0) {
            return (
                <View onLayout={({nativeEvent: {layout: {x, y, width, height}}}) => {
                    if (this.goodY && this.goodY === y) {
                        return;
                    }
                    this.goodY = y;
                }}>
                    <StoreCommonTitle
                        style={styles.goodRecommondStyle}
                        title={Datas.modules.GOOD_RECOMMOND.name}
                        icon={Datas.modules.GOOD_RECOMMOND.icon}
                        onPress={() => {
                            Actions.HomeStoreList();
                        }}/>
                </View>
            );
        } else {
            return null;
        }
    }

    /**
     * 渲染查看更多
     * @private
     */
    _renderMore({onPress, title = '查看更多'}) {
        return (
            <TouchableOpacity onPress={onPress} activeOpacity={1}>
                <View style={styles.moreCotnainer}>
                    <Text allowFontScaling={false} style={styles.moreTitle}>{title}</Text>
                    <Image
                        style={styles.moreIcon}
                        source={require('../../../../foundation/Img/home/store/icon_more_right_.png')}/>
                </View>
            </TouchableOpacity>
        );
    }

    /**
     * 渲染tab导航栏view
     * @private
     */
    _renderTabView() {
        return (
            <View style={styles.tabContainer} ref={(ref) => this.tabView = ref}>
                {['时尚大牌', '优品推荐', '好货推荐'].map((item, index) => {
                    let tabItemInner = this.state.selectedTabIndex === index ? [styles.tabItemInner] : [styles.tabItemInner, {borderBottomWidth: ScreenUtils.scaleSize(2)}];
                    let tabTitleStyle = this.state.selectedTabIndex === index ? [styles.tabTitleSelectedStyle] : [styles.tabTitleSelectedStyle, {color: Colors.text_dark_grey}];
                    return (
                        <View
                            style={styles.tabItemContainer}
                            key={index}
                            ref={(ref) => {
                                if (this.tabViews[index] = ref);
                            }}>
                            <View ref={(ref) => {
                                if (this.changeBtnBottomBorder[index] = ref);
                            }}
                                  style={tabItemInner}>


                                <TouchableOpacity activeOpacity={1} onPress={(event) => {
                                    if (this.state.selectedTabIndex === index) {
                                        return;
                                    }
                                    this.setState({
                                        selectedTabIndex: index
                                    }, () => {
                                        if (index === 0 && this.scrollView && this.popularY) {
                                            this._scrollToPosition(this.popularY);
                                        } else if (index === 1 && this.scrollView && this.niceY) {
                                            this._scrollToPosition(this.niceY);
                                        } else if (index === 2 && this.scrollView && this.goodY) {
                                            this._scrollToPosition(this.goodY);
                                        }
                                    });
                                }}>
                                    <Text allowFontScaling={false} ref={(ref) => {
                                        if (this.changeTextColor[index] = ref);
                                    }}
                                          style={tabTitleStyle}>{item}
                                    </Text>
                                </TouchableOpacity>
                            </View>
                        </View>
                    );
                })}
            </View>
        );
    }

    /**
     * 滑动到指定锚点
     * @private
     */
    _scrollToPosition(positionY) {
        this.scrollView.scrollToOffset({
            offset: positionY - ScreenUtils.scaleSize(60),
            animated: false
        });
    }

    /**
     * scrollview滑动的时候
     * @private
     */
    _onScroll(event) {
        let y = event.nativeEvent.contentOffset.y;
        if (this.tabView && this.popularY) {
            let offset = ScreenUtils.scaleSize(40);
            let belowLimit = this.popularY - ScreenUtils.scaleSize(80 + 20);// 0
            let progressY = (y - belowLimit) / offset;
            this.tabView.setNativeProps({
                style: {
                    opacity: progressY
                }
            });
            if (this.refs.backTopView) {
                this.refs.backTopView.setNativeProps({
                    style: {
                        opacity: progressY,
                    }
                });
            }
            if (progressY >= 0) {
                if (this.tabView && this.popularY && this.popularY - ScreenUtils.scaleSize(100) <= y && y < this.niceY - ScreenUtils.scaleSize(100)) {
                    this.changeSelectedTitleColor(Colors.main_color, Colors.text_dark_grey, Colors.text_dark_grey)
                    this.changeBtnBottomBorderWidth(ScreenUtils.scaleSize(2), 0, 0)
                    this.state.selectedTabIndex = 0;
                } else if (this.tabView && this.niceY && this.niceY - ScreenUtils.scaleSize(100) <= y && y < this.goodY - ScreenUtils.scaleSize(100)) {
                    this.changeSelectedTitleColor(Colors.text_dark_grey, Colors.main_color, Colors.text_dark_grey);
                    this.changeBtnBottomBorderWidth(0, ScreenUtils.scaleSize(2), 0)
                    this.state.selectedTabIndex = 1;
                } else if (this.tabView && this.goodY && this.goodY - ScreenUtils.scaleSize(100) <= y) {
                    this.changeSelectedTitleColor(Colors.text_dark_grey, Colors.text_dark_grey, Colors.main_color);
                    this.changeBtnBottomBorderWidth(0, 0, ScreenUtils.scaleSize(2))
                    this.state.selectedTabIndex = 2;
                } else if (this.tabView && this.popularY && y < this.popularY - ScreenUtils.scaleSize(100)) {
                    this.changeSelectedTitleColor(Colors.main_color, Colors.text_dark_grey, Colors.text_dark_grey)
                    this.changeBtnBottomBorderWidth(ScreenUtils.scaleSize(2), 0, 0)
                    this.state.selectedTabIndex = 0;
                }
            }
        }
    }

    changeBtnBottomBorderWidth(wid1, wid2, wid3) {
        this.changeBtnBottomBorder[0].setNativeProps({
            style: {
                borderBottomWidth: wid1
            }
        })
        this.changeBtnBottomBorder[1].setNativeProps({
            style: {
                borderBottomWidth: wid2
            }
        })
        this.changeBtnBottomBorder[2].setNativeProps({
            style: {
                borderBottomWidth: wid3
            }
        })
    }

    changeSelectedTitleColor(color1, color2, color3) {
        this.changeTextColor[0].setNativeProps({
            style: {
                color: color1
            }
        })
        this.changeTextColor[1].setNativeProps({
            style: {
                color: color2
            }
        })
        this.changeTextColor[2].setNativeProps({
            style: {
                color: color3
            }
        })
    }

    /**
     * list滑动到底部---加载更多
     * @private
     */
    _loadMore() {
        // console.log('加载更多' + this.state.pageNum);
        if (
            (this.state.totalPage === -1 && this.state.recommondDatas.length >= this.state.pageSize)//第一次加载的时候，并且第一次数据>=pagesize
            || (this.state.totalPage > this.state.pageNum)//总页数大于当前页数
        ) {
            this.state.pageNum++;
            this._doPostMore();
        }
    }

    /**
     * 好货推荐加载更多请求
     * @private
     */
    _doPostMore() {
        if (this.storeIndexListRequest) this.storeIndexListRequest.setCancled(true);
        let params = {
            id: this.state.recommondQueryId,
            pageNum: this.state.pageNum,
            pageSize: this.state.pageSize
        };
        this.storeIndexListRequest = new StoreIndexListRequest(params, 'GET');
        this.storeIndexListRequest.start((response) => {
            if (this.state.totalPage !== response.totalPage) this.state.totalPage = response.totalPage;
            if (response.datas.length === 0) {
                this.setState({
                    hasMore: true
                });
            } else if (response.datas.length > 0) {
                this.setState({
                    recommondDatas: this.state.recommondDatas.concat(response.datas),
                });
            }
        }, (error) => {

        });
    }

    /**
     * 渲染完毕
     */
    componentDidMount() {
        setTimeout(()=> {
            this._refresh(true);
            this._checkToken();
        }, 500);
    }

    /**
     * 将要卸载
     */
    componentWillUnmount() {
        //页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
        if (this.storeIndexRequest)this.storeIndexRequest.setCancled(true);
        if (this.checkToken)this.checkToken.setCancled(true);
    }

    /**
     * 刷新抵用券的数据
     * @private
     */
    _updateCouponList(index) {
        this.state.coupons[index].isReceive = '1';
    }

    errorCallback(params) {
        this.showMessage(params, DURATION.LENGTH_SHORT);
    }

    _checkToken() {
        if (this.checkToken) {
            this.checkToken.setCancled(true);
        }
        this.checkToken = new CheckToken({token: Global.token}, 'GET');
        this.checkToken.start(
            (response) => {
                if (response.code === 200 && response.data.isLogin) {
                    this.setState({
                        showMessage: true
                    });
                } else {
                    this.setState({
                        showMessage: false
                    });
                }
            }, (erro)=> {
                this.setState({
                    showMessage: false
                });
            });
    }

    showMessage(text, duration) {
        this.refs.toast && this.refs.toast.show(text, duration);
    }

    /**
     * 回到顶部view
     * @private
     */
    _renderBackTop() {
        return (
            <TouchableOpacity
                style={styles.backTopView}
                activeOpacity={1}
                onPress={() => {
                    if (this.scrollView) {
                        this.scrollView.scrollToOffset({
                            offset: 0,
                            animated: true,
                        });
                    }
                }}>
                <Image
                    ref='backTopView'
                    style={styles.backTopImg}
                    source={require('../../../../foundation/Img/channel/classification_channel_icon_back_top.png')}>
                </Image>
            </TouchableOpacity>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: Colors.background_grey
    },
    messageImgBg: {
        ...Platform.select({
            ios: {
                width: 4,
                height: 4,
                position: 'absolute',
                top: 2,
                right: 1,
                backgroundColor: 'white',
                borderRadius: 360
            },
            android: {
                width: 4,
                height: 4,
                position: 'absolute',
                top: 1,
                right: 1,
                backgroundColor: 'white',
                borderRadius: 360
            }
        })
    },
    navRightStyle: {
        width: ScreenUtils.scaleSize(120),
        alignItems: 'flex-end',
        paddingRight: ScreenUtils.scaleSize(20)
    },
    navRightCartStyle: {
        width: ScreenUtils.scaleSize(40),
        height: ScreenUtils.scaleSize(37),
        resizeMode: 'stretch'
    },
    navRightShareStyle: {
        width: ScreenUtils.scaleSize(36),
        height: ScreenUtils.scaleSize(36),
        marginLeft: ScreenUtils.scaleSize(15)
    },
    bannerContainerStyle: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(350)
    },
    headerBannerStyle: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(350),
        resizeMode: 'stretch'
    },
    hotGoodsTitleStyle: {
        marginBottom: ScreenUtils.scaleSize(1),
        marginTop: ScreenUtils.scaleSize(20)
    },
    hotGoodsListContainer: {
        paddingTop: ScreenUtils.scaleSize(10),
        paddingBottom: ScreenUtils.scaleSize(40),
        paddingHorizontal: ScreenUtils.scaleSize(20),
        backgroundColor: Colors.text_white
    },
    discountCouponStyle: {
        marginTop: ScreenUtils.scaleSize(20),
        marginBottom: ScreenUtils.scaleSize(1)
    },
    wonderfulActivityStyle: {
        marginTop: ScreenUtils.scaleSize(20),
        marginBottom: ScreenUtils.scaleSize(1),
        width: ScreenUtils.screenW
    },
    popularBrandStyle: {
        marginTop: ScreenUtils.scaleSize(20)
    },
    goodRecommondStyle: {
        marginTop: ScreenUtils.scaleSize(20),
        marginBottom: ScreenUtils.scaleSize(1)
    },
    moreCotnainer: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(75),
        marginTop: ScreenUtils.scaleSize(1),
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        backgroundColor: Colors.text_white
    },
    moreTitle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24)
    },
    moreIcon: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(20)
    },
    tabContainer: {
        backgroundColor: Colors.text_white,
        height: ScreenUtils.scaleSize(80),
        width: ScreenUtils.screenW,
        flexDirection: 'row',
        paddingHorizontal: ScreenUtils.scaleSize(60),
        borderBottomColor: Colors.background_grey,
        position: 'absolute',
        left: 0,
        right: 0,
        borderBottomWidth: ScreenUtils.scaleSize(4),
        opacity: 0
    },
    tabItemInner: {
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center',
        borderBottomWidth: ScreenUtils.scaleSize(2),
        borderBottomColor: Colors.main_color
    },
    tabTitleSelectedStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.setSpText(28)
    },
    tabItemContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        alignSelf: 'stretch',
        paddingBottom: ScreenUtils.scaleSize(2)
    },
    footerViewBg: {
        width: width,
        height: ScreenUtils.scaleSize(146),
        justifyContent: 'center',
        alignItems: 'center'
    },
    footerViewImg: {
        width: ScreenUtils.scaleSize(180),
        height: ScreenUtils.scaleSize(106)
    },
    backTopView: {
        position: 'absolute',
        bottom: ScreenUtils.scaleSize(140),
        left: ScreenUtils.screenW - ScreenUtils.scaleSize(120),
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
    },
    backTopImg: {
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
        opacity: 0,
    },
});