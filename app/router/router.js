import React, {Component} from 'react';
import {StyleSheet} from 'react-native';
import {
    Modal,
    Router,
    Scene,
    Reducer
} from 'react-native-router-flux';
import Home from 'COMPONENTS/homepage/Home';
import ClassificationPage from 'COMPONENTS/classificationpage/ClassificationPage';
import GoodsDetailMain from 'COMPONENTS/classificationpage/GoodsDetailMain';
import ShoppingPage from 'COMPONENTS/shoppingpage/ShoppingPage';
import AllVideoListPage from 'COMPONENTS/shoppingpage/AllVideoListPage';
import OnLiveVideoPage from 'COMPONENTS/shoppingpage/OnLiveVideoPage';
import CartRootPage from 'COMPONENTS/cartpage/CartRootPage';
import MePage from 'COMPONENTS/mepage/MePage';
import TabIcon from 'COMPONENTS/tab/TabIcon';
import OrderConfirm from 'COMPONENTS/orderconfirm';
import GoodInfoList from 'COMPONENTS/orderconfirm/GoodInfoList';
import OrderDistributionDateDetail from 'COMPONENTS/orderconfirm/OrderDistributionDateDetail';
import HomeSearchBase from 'COMPONENTS/searchpage/HomeSearchBase';
import KeywordSearchPage from 'COMPONENTS/searchpage/KeywordSearchPage';
import ExchangeReturnDetail from 'COMPONENTS/orderpage/ExchangeReturnDetail';
import OrderCenter from 'COMPONENTS/orderpage/OrderCenter';
import OrderLogistics from 'COMPONENTS/orderpage/OrderLogistics';
import OrderPayStyle from 'COMPONENTS/orderconfirm/OrderPayStyle';
import OrderWebView from 'COMPONENTS/orderconfirm/OrderWebView';
import OrderNNavWebView from 'COMPONENTS/orderconfirm/OrderNONavBarWebView';
import SmallBlackBoard from 'COMPONENTS/smallblackboard';
import SmallBlackBoardDetails from 'COMPONENTS/smallblackboard.detail';
import GroupBuyDetails from 'COMPONENTS/groupbuypage/GroupBuyDetails';
import ClassificationChannel from 'COMPONENTS/classificationpage/ClassificationChannel';
import GoodsDetailAllEvaluatePage from 'COMPONENTS/classificationpage/GoodsDetailAllEvaluatePage';
import SingleEvaluationPage from 'COMPONENTS/classificationpage/SingleEvaluationPage';

import MessageListPage from 'FOUNDATION/me/MessageListPage';
import MessageListDetailPage from 'FOUNDATION/me/MessageListDetailPage';
import ExchangeDetail from 'FOUNDATION/order/ExchangeDetail';
//主页中的热销页面
import HotSale from 'COMPONENTS/homepage/hotsale';
//主页中的商城页面
import HomeStore from 'COMPONENTS/homepage/store';
//主页-->商城-->商家全列表页面
import HomeStoreList from 'COMPONENTS/homepage/store/StoreList';
//主页-->商城-->商家详情
import HomeStoreDetails from 'COMPONENTS/homepage/store/StoreDetails'
//主页-->商城-->商家详情(Html5)
import StoreDetailHtml5 from 'COMPONENTS/homepage/store/StoreDetailHtml5';
//商城通用的WebView
import StoreWebView from 'COMPONENTS/homepage/store/StoreWebView';
//拦截跳转的Html5
import InterceptWebView from 'FOUNDATION/common/InterceptWebView';

//主页-->全球购
import GlobalShopping from 'COMPONENTS/homepage/globalshopping';
import ClassificationProductListPage from 'COMPONENTS/classificationpage/ClassificationProductListPage';
import VipPromotion from 'COMPONENTS/homepage/VipPromotion';
import Ranking from 'COMPONENTS/groupbuypage/Ranking';
// 导入外部组件 -  订单详情
import orderDetail from 'COMPONENTS/orderpage/OrderDetail';
import Group from 'COMPONENTS/groupbuypage/Group';

// 导入外部组件 -  换货 退货
import ApplyExchangeGoods from 'COMPONENTS/orderpage/ApplyExchangeGoods';

import BillListPage from 'COMPONENTS/billpage/BillListPage';
import BillDetailPage from 'COMPONENTS/billpage/BillDetailPage';
import ElectronBillpage from 'COMPONENTS/billpage/ElectronBillPage';
// 倒入收藏夹页面
import FavoritePage from 'APP/components/mepage/FavoritePage';

import * as routeConfig from 'CONFIG/routeConfig';
import * as Consts from 'CONSTANTS/Constants';

export class RouterClass extends Component {
    shouldComponentUpdate() {
        // 路由不用更新, 不然会多次注册路由
        return false;
    }
    render() {
        const {reducerCreate, getSceneStyle, backAndroidHandler, videoTab, menu} = this.props;
        return (
            //router是最父组件包裹所有的组件
            <Router
                hideNavBar={true} createReducer={reducerCreate} getSceneStyle={getSceneStyle}
                backAndroidHandler={() => backAndroidHandler(this.props)}
                panHandlers={null}
            >
                <Scene key="modal" component={Modal}>
                    <Scene key="root">
                        <Scene key="Indexocj_Tab"
                               tabs
                               hideNavBar
                               type="replace"
                               tabBarStyle={styles.tabBarStyle}
                               tabBarSelectedItemStyle={styles.tabBarSelectedItemStyle}>
                            {/*第一屏幕显示*/}
                            <Scene
                                StoreDetails
                                key="JumpTo"
                                title={Consts.HomePage}
                                titleStyle={styles.titleStyle}
                                icon={TabIcon}>
                                {/*主页*/}
                                <Scene
                                    key="Home"
                                    clone
                                    type="reset"
                                    title="主页"
                                    hideNavBar
                                    component={Home}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*首页进关键词搜索*/}
                                <Scene
                                    key='KeywordSearchPageHome'
                                    hideTabBar
                                    hideNavBar={true}
                                    component={KeywordSearchPage}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*消息*/}
                                <Scene
                                    key='MessageFromHome'
                                    title='消息'
                                    hideTabBar
                                    hideNavBar
                                    component={MessageListPage}
                                    titleStyle={styles.titleStyle}
                                />
                                <Scene
                                    key="GoodsDetailMainFromHome"
                                    hideTabBar
                                    hideNavBar={true}
                                    titleStyle={styles.titleStyle}
                                    component={GoodsDetailMain}
                                >
                                </Scene>
                                {/*消息列表进消息详情*/}
                                <Scene
                                    key="MessageDetailFromHome"
                                    title="消息详情"
                                    hideTabBar
                                    hideNavBar
                                    titleStyle={styles.titleStyle}
                                    component={MessageListDetailPage}
                                />
                                {/*主页去视频全列表*/}
                                <Scene
                                    key="Home_VideoList"
                                    title={Consts.AllVideoListPage}
                                    hideTabBar
                                    hideNavBar={true}
                                    titleStyle={styles.titleStyle}
                                    component={AllVideoListPage}
                                />
                                {/*主页去直播*/}
                                <Scene
                                    key="Home_OnLive"
                                    title={Consts.AllVideoListPage}
                                    hideTabBar
                                    hideNavBar={true}
                                    titleStyle={styles.titleStyle}
                                    component={OnLiveVideoPage}
                                />
                                {/*主页中的热销页面*/}
                                <Scene
                                    key="HomeHotSale"
                                    title={Consts.HotSale}
                                    hideNavBar={true}
                                    hideTabBar={true}
                                    component={HotSale}
                                />
                                {/*主页中的商城*/}
                                <Scene
                                    title={Consts.HomeStore}
                                    key="HomeStore"
                                    hideNavBar={true}
                                    hideTabBar={true}
                                    component={HomeStore}
                                />
                                {/*消息*/}
                                <Scene
                                    key='MessageFromHomeStore'
                                    title='消息'
                                    hideTabBar
                                    hideNavBar
                                    component={MessageListPage}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*消息列表进消息详情*/}
                                <Scene
                                    key="MessageDetailFromHomeStore"
                                    title="消息详情"
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    hideNavBar
                                    component={MessageListDetailPage}
                                />
                                {/*商城中的商铺列表*/}
                                <Scene
                                    key="HomeStoreList"
                                    title={Consts.HomeStoreList}
                                    hideNavBar={true}
                                    hideTabBar={true}
                                    component={HomeStoreList}
                                />
                                {/*商城中的商铺下面的商铺详情*/}
                                <Scene
                                    key="HomeStoreDetails"
                                    title={Consts.HomeStoreDetails}
                                    hideNavBar={true}
                                    hideTabBar={true}
                                    component={StoreDetailHtml5}
                                />
                                <Scene
                                    key="StoreWebView"
                                    hideNavBar={true}
                                    hideTabBar={true}
                                    component={StoreWebView}
                                />
                                <Scene
                                    key="InterceptWebView"
                                    title={Consts.HomeStoreDetails}
                                    hideNavBar={true}
                                    hideTabBar={true}
                                    component={InterceptWebView}
                                />
                                <Scene
                                    key="cartFromStoreDetail"
                                    title={Consts.Cart}
                                    titleStyle={styles.titleStyle}
                                    hideNavBar={true}
                                    hideTabBar={true}
                                    component={CartRootPage}
                                />
                                {/*首页全球购页面*/}
                                <Scene
                                    key="GlobalShopping"
                                    title={Consts.GlobalShopping}
                                    hideNavBar={true}
                                    hideTabBar={true}
                                    component={GlobalShopping}
                                />
                                {/*全球购去消息*/}
                                <Scene
                                    key='MessageFromGlobalOcj'
                                    title='消息'
                                    hideTabBar
                                    hideNavBar
                                    component={MessageListPage}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*消息列表进消息详情*/}
                                <Scene
                                    key="MessageDetailFromGlobalOcj"
                                    title="消息详情"
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    hideNavBar
                                    component={MessageListDetailPage}
                                />
                                {/*分类频道页*/}
                                <Scene
                                    key='ClassificationChannel'
                                    hideTabBar
                                    hideNavBar
                                    component={ClassificationChannel}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*频道页进消息列表*/}
                                <Scene
                                    key="MessageFromClassificationChannel"
                                    title="消息"
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    hideNavBar
                                    component={MessageListPage}
                                />
                                {/*频道页消息列表进消息详情*/}
                                <Scene
                                    key="MessageDetailFromClassificationChannel"
                                    title="消息详情"
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    hideNavBar
                                    component={MessageListDetailPage}
                                />
                                {/*分类频道页进二、三级分类商品列表*/}
                                <Scene
                                    key='ClassificationProductFromChannel'
                                    title='分类商品列表'
                                    hideTabBar
                                    hideNavBar={true}
                                    component={ClassificationProductListPage}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*会员特价H5页*/}
                                <Scene
                                    key='VipPromotion'
                                    hideTabBar
                                    hideNavBar={true}
                                    component={VipPromotion}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*小黑板*/}
                                <Scene
                                    key='SmallBlackBoard'
                                    title={Consts.SmallBlackBoard}
                                    hideTabBar={true}
                                    component={SmallBlackBoard}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*小黑板详情*/}
                                <Scene
                                    key={routeConfig.SmallBlackBoardDetails}
                                    title="板书详情"
                                    hideTabBar={true}
                                    component={SmallBlackBoardDetails}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*团购*/}
                                <Scene
                                    key="Group"
                                    title={Consts.TodayGroupBuy}
                                    hideTabBar
                                    hideNavBar
                                    titleStyle={styles.titleStyle}
                                    component={Group}
                                >
                                </Scene>
                                {/*人气推荐*/}
                                <Scene
                                    key="Ranking"
                                    title="人气推荐"
                                    hideTabBar
                                    hideNavBar
                                    titleStyle={styles.titleStyle}
                                    component={Ranking}
                                >
                                </Scene>
                                {/*小黑板*/}
                                <Scene
                                    key="GroupBuyDetails"
                                    title={Consts.GroupBuyDetails}
                                    titleStyle={styles.titleStyle}
                                    component={GroupBuyDetails}
                                />
                                {/*首页进搜索结果列表*/}
                                <Scene
                                    hideTabBar
                                    hideNavBar
                                    titleStyle={styles.titleStyle}
                                    key="HomeSearchBaseFromHomeSearch"
                                    component={HomeSearchBase}
                                />
                                <Scene
                                    //消息推送进查看物流
                                    title={Consts.ViewLogistics}
                                    hideTabBar
                                    hideNavBar
                                    titleStyle={styles.titleStyle}
                                    key="HomeViewLogistics"
                                    component={OrderLogistics}
                                />
                            </Scene>
                            {/*第二屏幕显示*/}
                            <Scene
                                key={routeConfig.Indexocj_Classification}
                                title={Consts.ClassificationPage}
                                icon={TabIcon}
                                navigationBarStyle={styles.navigationBarStyle}
                                hideTabBar={false}
                                hideNavBar>
                                {/*分类导航页*/}
                                <Scene
                                    key="ClassificationPage"
                                    navigationBarStyle={{justifyContent: 'center'}}
                                    title={Consts.ClassificationPage}
                                    titleStyle={styles.titleStyle}
                                    component={ClassificationPage}
                                    hideNavBar={true}
                                    hideBackImage={true}
                                />
                                {/*分类导航进消息列表*/}
                                <Scene
                                    key="MessageFromClassification"
                                    title="消息"
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    hideNavBar
                                    component={MessageListPage}
                                />
                                {/*分类导航消息列表进消息详情*/}
                                <Scene
                                    key="MessageDetailFromClassification"
                                    title="消息详情"
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    hideNavBar
                                    component={MessageListDetailPage}
                                />
                                {/*分类导航进二、三级分类商品列表*/}
                                <Scene
                                    key='ClassificationProductListPage'
                                    title='分类商品列表'
                                    hideTabBar
                                    hideNavBar={true}
                                    component={ClassificationProductListPage}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*二、三级分类商品列表进购物车*/}
                                <Scene
                                    key="CartFromClassificationList"
                                    title={Consts.Cart}
                                    titleStyle={styles.titleStyle}
                                    hideNavBar={true}
                                    component={CartRootPage}
                                />
                                {/*分类导航进关键词搜索*/}
                                <Scene
                                    key='KeywordSearchPage'
                                    title='搜索'
                                    hideTabBar
                                    hideNavBar={true}
                                    component={KeywordSearchPage}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*关键词搜索进搜索结果列表*/}
                                <Scene
                                    key="HomeSearchBase"
                                    title={Consts.HomeSearchBase}
                                    hideTabBar
                                    hideNavBar={true}
                                    component={HomeSearchBase}
                                    renderRightButton={() => menu}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*分类页进分类频道页*/}
                                <Scene
                                    key='ChannelFromPage'
                                    hideTabBar
                                    hideNavBar
                                    component={ClassificationChannel}
                                    titleStyle={styles.titleStyle}
                                />
                            </Scene>
                            {/*第三屏幕显示*/}
                            <Scene
                                key={routeConfig.Tabocj_Shopping}
                                title={Consts.ShoppingPage}
                                icon={TabIcon}
                                navigationBarStyle={styles.navigationBarStyle}>
                                {/*看直播*/}
                                <Scene
                                    key="ShoppingPage"
                                    title={Consts.ShoppingPage}
                                    titleStyle={styles.titleStyle}
                                    hideNavBar={true}
                                    renderRightButton={() => videoTab(this.props)}
                                    component={ShoppingPage}
                                />
                                {/*视频全列表*/}
                                <Scene
                                    key="allVideoListPage"
                                    title={Consts.AllVideoListPage}
                                    hideTabBar
                                    hideNavBar={true}
                                    titleStyle={styles.titleStyle}
                                    component={AllVideoListPage}
                                />
                                {/*直播*/}
                                <Scene
                                    key="onLiveVideoPage"
                                    title={Consts.OnLiveVideoPage}
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    component={OnLiveVideoPage}
                                />
                                {/*会员特价H5页*/}
                                <Scene
                                    key='Video_VipPromotion'
                                    hideTabBar
                                    hideNavBar={true}
                                    component={VipPromotion}
                                    titleStyle={styles.titleStyle}
                                />
                            </Scene>
                            {/*第四屏幕显示*/}
                            <Scene
                                key={routeConfig.Tabocj_Cart}
                                title={Consts.Cart}
                                titleStyle={styles.titleStyle}
                                hideNavBar={true}
                                icon={TabIcon}
                                navigationBarStyle={styles.navigationBarStyle}>
                                {/*购物车*/}
                                <Scene
                                    key="cartFrmRoot"
                                    title={Consts.Cart}
                                    titleStyle={styles.titleStyle}
                                    hideNavBar={true}
                                    component={CartRootPage}
                                />
                            </Scene>
                            {/*第五屏幕显示*/}
                            <Scene
                                key={routeConfig.Tabocj_MePage}
                                title={Consts.MePage}
                                icon={TabIcon}
                                titleStyle={styles.titleStyle}
                                navigationBarStyle={styles.navigationBarStyle}>
                                {/*个人中心首页*/}
                                <Scene key="MePage"
                                       title={Consts.MePage}
                                       titleStyle={styles.titleStyle}
                                       hideBackImage
                                       hideNavBar
                                       component={MePage}
                                       navigationBarStyle={styles.navigationBarStyle}
                                />
                                {/*单个评价*/}
                                <Scene
                                    key="SingleEvaluationPage"
                                    title="单个评价"
                                    hideTabBar
                                    hideNavBar={true}
                                    titleStyle={styles.titleStyle}
                                    component={SingleEvaluationPage}
                                />
                                {/*会员特价H5页*/}
                                <Scene
                                    key='MeVipPromotion'
                                    hideTabBar
                                    hideNavBar={true}
                                    component={VipPromotion}
                                    titleStyle={styles.titleStyle}
                                />
                                {/*订单中心*/}
                                <Scene
                                    key="OrderCenter"
                                    title="订单中心"
                                    hideNavBar={true}
                                    hideTabBar={true}
                                    titleStyle={styles.titleStyle}
                                    component={OrderCenter}
                                />
                                {/*换货详情*/}
                                <Scene
                                    key="ExchangeDetail"
                                    title={Consts.ExchangeDetail}
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    component={ExchangeReturnDetail}
                                />
                                {/*退货详情*/}
                                <Scene
                                    key="ReturnDetail"
                                    title={Consts.ReturnDetail}
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    component={ExchangeDetail}
                                />
                                {/*查看物流*/}
                                <Scene
                                    key="ViewLogistics"
                                    title={Consts.ViewLogistics}
                                    hideTabBar
                                    hideNavBar
                                    titleStyle={styles.titleStyle}
                                    component={OrderLogistics}
                                />
                                {/*发票管理*/}
                                <Scene
                                    key="BillListPage"
                                    title={Consts.BillListPage}
                                    hideTabBar={true}
                                    hideNavBar={true}
                                    titleStyle={styles.titleStyle}
                                    component={BillListPage}
                                />
                                {/*查看发票*/}
                                <Scene
                                    key="BillListDetailPage"
                                    title='查看发票'
                                    hideTabBar
                                    hideNavBar
                                    titleStyle={styles.titleStyle}
                                    component={BillDetailPage}
                                />
                                {/*查看电子发票*/}
                                <Scene
                                    key="ElectronBillpage"
                                    title='电子发票'
                                    hideTabBar
                                    hideNavBar
                                    titleStyle={styles.titleStyle}
                                    component={ElectronBillpage}
                                />
                                {/*收藏*/}
                                <Scene
                                    key="FavoritePage"
                                    title={Consts.FavoritePage}
                                    hideTabBar
                                    hideNavBar={true}
                                    titleStyle={styles.titleStyle}
                                    component={FavoritePage}
                                />
                                {/*订单中心*/}
                                <Scene
                                    key="ApplyExchangeGoods"
                                    title="订单中心"
                                    hideTabBar
                                    hideNavBar={false}
                                    titleStyle={styles.titleStyle}
                                    component={ApplyExchangeGoods}
                                />
                                <Scene
                                    key="GoodsDetailMainFromOrder"
                                    hideTabBar
                                    hideNavBar={true}
                                    titleStyle={styles.titleStyle}
                                    component={GoodsDetailMain}
                                />
                                {/*订单详情*/}
                                <Scene
                                    key="orderDetail"
                                    title="订单详情"
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    hideNavBar
                                    component={orderDetail}
                                />
                                {/*消息*/}
                                <Scene
                                    key="MessageListPage"
                                    title="消息"
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    hideNavBar
                                    component={MessageListPage}
                                />
                                {/*消息详情*/}
                                <Scene
                                    key="MessageListDetailPage"
                                    title="消息详情"
                                    hideTabBar
                                    titleStyle={styles.titleStyle}
                                    hideNavBar
                                    component={MessageListDetailPage}
                                />
                            </Scene>
                        </Scene>
                        {/* 商品详情 */}
                        <Scene
                            key="GoodsDetailMain"
                            hideTabBar
                            hideNavBar={true}
                            titleStyle={styles.titleStyle}
                            component={GoodsDetailMain}>
                        </Scene>
                        <Scene
                            key="StoreDetailsFromGoodsDetail"
                            title={Consts.HomeStoreDetails}
                            hideNavBar={true}
                            hideTabBar={true}
                            component={StoreDetailHtml5}
                        />
                        {/*购物车*/}
                        <Scene
                            key="cartFromGoodsDetail"
                            title={Consts.Cart}
                            titleStyle={styles.titleStyle}
                            hideTabBar={true}
                            hideNavBar={true}
                            component={CartRootPage}
                        />
                        {/*商品详情跳转相关的 跳转商店*/}
                        <Scene
                            key='VipPromotionGoodsDetail'
                            hideTabBar
                            hideNavBar={true}
                            component={VipPromotion}
                            titleStyle={styles.titleStyle}
                        />
                        {/*全部评价*/}
                        <Scene
                            key="GoodsDetailAllEvaluatePage"
                            title="全部评价"
                            hideTabBar
                            hideNavBar={true}
                            titleStyle={styles.titleStyle}
                            component={GoodsDetailAllEvaluatePage}
                        />
                        {/*单个评价*/}
                        <Scene
                            key="SingleEvaluationPage"
                            title="单个评价"
                            hideTabBar
                            hideNavBar={true}
                            titleStyle={styles.titleStyle}
                            component={SingleEvaluationPage}
                        />
                        {/*填写订单页面*/}
                        <Scene
                            key="OrderFill"
                            title={Consts.OrderFill}
                            hideTabBar
                            hideNavBar={true}
                            titleStyle={styles.titleStyle}
                            component={OrderConfirm}
                        />
                        {/*订单填写中的商品列表*/}
                        <Scene
                            key="OrderGoodInfoList"
                            title={Consts.OrderGoodInfoList}
                            hideTabBar
                            hideNavBar={true}
                            titleStyle={styles.titleStyle}
                            component={GoodInfoList}
                        />
                        <Scene
                            key='OrderWebView'
                            hideTabBar
                            hideNavBar={false}
                            component={OrderWebView}
                            titleStyle={styles.titleStyle}
                        />
                        <Scene
                            key='OrderWebViewHideNavBar'
                            hideTabBar
                            hideNavBar={true}
                            component={OrderNNavWebView}
                            titleStyle={styles.titleStyle}
                        />
                        {/*订单填写--多订单发货日期选择*/}
                        <Scene
                            key="OrderDistributionDateDetail"
                            title={Consts.OrderDistributionDate}
                            hideTabBar
                            hideNavBar={true}
                            titleStyle={styles.titleStyle}
                            component={OrderDistributionDateDetail}
                        />
                        {/*订单填写--多订单支付方式选择*/}
                        <Scene
                            key="OrderPayStyle"
                            title={Consts.OrderPayStyle}
                            hideTabBar
                            hideNavBar={true}
                            titleStyle={styles.titleStyle}
                            component={OrderPayStyle}
                        />
                    </Scene>
                </Scene>
            </Router>
        )
    }
}

let styles = StyleSheet.create({
    tabBarStyle: {
        backgroundColor: '#FFFFFF',
        opacity: 0.8
    },
    tabBarSelectedItemStyle: {
        backgroundColor: 'transparent'
    },
    navigationBarStyle: {
        backgroundColor: '#FFFFFF'
    },
    titleStyle: {
        backgroundColor: 'transparent',
        color: '#000000',
        opacity: 0.8,
        fontSize: 18
    }
});
