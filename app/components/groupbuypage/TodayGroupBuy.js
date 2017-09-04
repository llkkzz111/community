/**
 * Created by lu weiguo on 2017/6月3号.
 * 今日团购页面
 */
'use strict';
import React, {PureComponent} from 'react';
import {
    View,
    Text,
    Image,
    Dimensions,
    StyleSheet,
    TouchableOpacity,
    Platform,
    FlatList,
    ScrollView,
    DeviceEventEmitter
} from 'react-native';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
// 导航栏
import NavigationBar from '../../../foundation/common/NavigationBar';
// 头部标题
import TodayGroupTitle from '../../../foundation/groupby/TodayGroupTitle';
// 零点标题
import ZeroTitle from '../../../foundation/groupby/ZeroTitle' ;
// 筛选
import Screening from '../../../foundation/groupby/Screening';
// 图片轮播
import ImgShuffling from '../../../foundation/groupby/ImgShuffling';
// 限时抢购
import TimeLimit from '../../../foundation/groupby/TimeLimit' ;
// 零点上新品
import NewProduct from '../../../foundation/groupby/NewProduct' ;
// 人气商品
import ScrollViewGoods from '../../../foundation/groupby/ScrollViewGoods';
// 品牌管
import BrandPavilion from '../../../foundation/groupby/BrandPavilion' ;
// 请求数据
import TotayGroupRequest from '../../../foundation/net/group/totayGroup/TotayGroupRequest' ;
import RecommendRequest from '../../../foundation/net/group/totayGroup/RecommendRequest' ;
import {DataAnalyticsModule} from '../../config/AndroidModules';
// 导入外部 URL 请求
import SortingRequest from '../../../foundation/net/group/totayGroup/SortingRequest';

import ScrollableTabView, {ScrollableTabBar,DefaultTabBar} from 'react-native-scrollable-tab-view';

import Datas from './Datas';
let codeValue = '';
let pageVersionName = '';
let pageNum = 1;
var key = 0;
export default class TodayGroupBuy extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            datas: '',
            newGoods: [],    // 所有商品集合
            index: 0,
            titles: [],       //  分类标题
            banners: [],      //  幻灯片
            bannersLinks: [],  // 幻灯片链接
            limitedTimeBuy: [], //限时抢购数据
            limitedTime: [],  // 限时抢购时间
            limitedGoods: [],  // 限时抢购商品
            zeroGoods: [],  //每日零点上新商品
            popularGoods: [],  //人气商品
            brandsGoods: [],  //品牌商品
            otherGoods: [],  // 其他分类商品
            moreDataIndex:[],  // 首页分页商品
            moreDataIndexs:[],// 累加首页分页商品
            //  拼接 url 使用的参数  精选 （点击 人气排行榜 ，查看更多折扣 ）
            //  拼接 url 使用的参数  精选 （点击 人气排行榜 ，查看更多折扣 ）
            id: "",
            // 排序 需要的 ID 编号
            idNum: "",
            emptyData: false,   // 没有数据了
            selectedIndex: 0,
            salesSortNum: -1,
            endReached: false,
            showBackTop: false,
            isScoll:true,
        };
        this.others = [1];//记忆每个标签下的数据
        this.sortNum = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];//记忆每个标签下的筛选条件
        this.pageNum = 1;
        this.pageSize = 20;
        this.destinationUrl = "";
        this.destinationUrlType = "";
        this.nextPageId = '';
        this.sortId = '';
        this._sortCallBack = this._sortCallBack.bind(this);

        this.indexId = "";
    }

    /**
     * 请求今日团购的网络数据
     */
    componentDidMount() {
        //     id:this.props.destinationUrl
        setTimeout(() => {
            this._renderTodayGroup("AP1706A008");
        }, 400)
    }

    componentWillUnmount() {
        if (codeValue) {
            DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
        }
    }

    /**
     * render 渲染组件
     * @returns {XML}
     */
    render() {
        return (
            <View style={styles.containers}>
                {this._renderTodayGroupTitle()}
                <ScrollableTabView
                    locked={this.state.isScoll}
                    renderTabBar={() => <ScrollableTabBar
                        style={{height: ScreenUtils.scaleSize(88)}}/>}
                    tabBarBackgroundColor={Colors.text_white}
                    tabBarUnderlineStyle={{backgroundColor: Colors.main_color, height: 2}}
                    tabBarInactiveTextColor={Colors.text_dark_grey}
                    tabBarActiveTextColor={Colors.main_color}
                    initialPage={0}
                    onChangeTab={(obj) => {
                        this.onClickTitle(obj);
                    }}
                >
                    {this.state.titles ? this.state.titles.map((item, i) => {
                        return (
                            <View style={styles.containers} key={i} tabLabel={item.title}>
                                {i === 0?this._rederComponents(i):this._renderProduct(i)}
                                {/*{this.state.index === i && i === 0 ? this._rederComponents():null}*/}
                                {/*{this.state.index === i && i !== 0 ? this._renderProduct():null}*/}
                                {i===0?this.renderbackTopView():null}
                            </View>
                        )
                    }) : null}
                </ScrollableTabView>

            </View>
        )
    }

    /**
     *  渲染backTopView
     */
    renderbackTopView(){
        return (
            this.state.showBackTop ?
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
        )
    }

    /**
     *  获取当前的
     * @param index
     * @param id
     */
    onClickTitle(obj) {
        let dt = {
            index:obj.i,
            destinationUrl:this.state.titles[obj.i]?this.state.titles[obj.i].destinationUrl:"",
            destinationUrlType:this.state.titles[obj.i]?this.state.titles[obj.i].destinationUrlType:"",
        };
        if (obj.i === 0) {
            this.state.showBackTop = dt.index === this.state.index ? this.state.showBackTop : false;
            this.state.index = dt.index;
            this.state.otherGoods = [];
            // setTimeout(() => {
            //     this._renderTodayGroup("AP1706A008")
            // }, 200);
            this.setState({
                isScoll: Platform.OS==='ios'?false:true,
            })
        } else {
            this.state.showBackTop = dt.index === this.state.index ? this.state.showBackTop : false;
            this.state.otherGoods = [];
            this.state.showBackTop = 0;
            this.state.emptyData = false;
            this.state.salesSortNum = -1;
            this.state.selectedIndex = 0;
            this.setState({
                selectedIndex:this.sortNum[dt.index],//记忆每个标签下的筛选条件
                index:dt.index,
                isScoll:false,
            },() => {
                setTimeout(() => {
                    // this.requestUrlData(dt,!Boolean(this.others[this.state.index]));////已加载完页面刷新用这个
                    if(!this.others[dt.index]){
                        this.requestUrlData(dt);//已加载完页面不刷新用这个
                    }
                }, 200);
            });

        }

    }

    /**
     * 处理respons
     * @param responseJson
     * @param successCallBack
     */
    requestUrlData(dt,showLoading=true) {
        this.pageNum = 1;
        this.destinationUrl = dt.destinationUrl;
        this.destinationUrlType = dt.destinationUrlType;

        if (this.totayGroupRequest) this.totayGroupRequest.setCancled(true);
        this.totayGroupRequest = new TotayGroupRequest({id: this.destinationUrl, pageNum: pageNum}, 'GET');
        if(showLoading){
            this.totayGroupRequest.showLoadingView();
        }
        if (this.destinationUrlType === 2) {
            this.totayGroupRequest.setShowMessage(false).start(
                (response) => {
                    if( this.totayGroupRequest.currTime !== "" ){
                        let currTime = this.totayGroupRequest.currTime ;
                        this.currTime=currTime;
                    }
                    if (this.pageNum == 1) key++;
                    if (response.data &&
                        response.data.packageList &&
                        response.data.packageList[0] &&
                        response.data.packageList[0].componentList &&
                        response.data.packageList[0].componentList[0] &&
                        response.data.packageList[0].componentList[0].componentList) {
                        let list = response.data.packageList[0].componentList[0].componentList;
                        list.forEach((item,index)=>{
                            if( item.curruntDateLong ){
                                item.curruntDateLong = this.currTime;
                            }
                        })
                        this.nextPageId = list[0].id;
                        this.others[this.state.index] = list;
                        this.setState({
                            otherGoods: list,
                            showBackTop: false,
                            endReached:false,
                        })
                    }else {
                        this.setState({
                            endReached:false,
                        });
                    }
                }, (erro) => {
                    this.setState({
                        endReached:false,
                    });
                }
            );
        }
    }

    /**
     * 今日团购首页分页 下拉更多数据
     * @private
     */
    _homeNextPage(){
        if (this.sortingRequest) this.sortingRequest.setCancled(true);
        let pageNum = ++this.pageNum;
        this.sortingRequest = new SortingRequest({
            id: this.indexId,
            pageNum:pageNum,
            singleProductitions:1,
        }, 'GET');
        this.sortingRequest.showLoadingView().setShowMessage(false).start(
            (response) => {
                let dataSource = response.data.list;
                let dataSource1 = [];
                if (dataSource !== null && dataSource.length > 0) {
                    if (this.pageNum > 1) {
                        dataSource1.push(...this.state.moreDataIndex, ...dataSource)
                    } else {
                        dataSource1 = dataSource;
                    }
                    this.setState({
                        moreDataIndex: dataSource1,
                        emptyData: true,
                        endReached:false,
                    });
                } else {
                    if (this.pageNum > 1) this.pageNum--;
                    this.setState({
                        emptyData: true,
                        endReached:false,
                    });
                }
            }, (erro) => {
                if (this.pageNum > 1) this.pageNum--;
                this.setState({
                    endReached:false,
                });
            }
        );
    }




    /**
     *  tab 下拉更多数据
     * @param destinationUrlType
     * @param destinationUrl
     * @param pageNum
     */
    _nextPage() {
        if (this.sortingRequest) this.sortingRequest.setCancled(true);
        this.sortingRequest = new SortingRequest({
            id: this.nextPageId,
            pageNum: this.pageNum,
            pageSize: this.pageSize,
            salesSort: this.sortId,
        }, 'GET');
        this.sortingRequest.showLoadingView().setShowMessage(false).start(
            (response) => {
                if (this.pageNum === 1) key++;
                let dataSource = response.data.list;
                let dataSource1 = [];
                if (dataSource !== null && dataSource.length > 0) {
                    if (this.pageNum > 1) {
                        dataSource1.push(...this.state.otherGoods, ...dataSource)
                    } else {
                        dataSource1 = dataSource;
                    }
                    this.others[this.state.index] = dataSource1;
                    this.setState({
                        otherGoods: dataSource1,
                        endReached:false,
                    });
                } else {
                    if (this.pageNum > 1) this.pageNum--;
                    this.setState({
                        emptyData: true,
                        endReached:false,
                    });
                }
            }, (erro) => {
                if (this.pageNum > 1) this.pageNum--;
                this.setState({
                    endReached:false,
                });
            }
        );
    }

    /**
     *点击第二排排序
     * @private
     */
    _sortCallBack(selectedIndex, salesSortNum, sortId) {
        this.state.selectedIndex = selectedIndex;
        this.state.salesSortNum = salesSortNum;
        this.sortId = sortId;
        this.pageNum = 1;
        this.state.emptyData = false;
        this.state.otherGoods = [];
        this.sortNum[this.state.index] = selectedIndex;
        this._nextPage();
    }

    /**
     * 点击其他分类 渲染UI 组件
     */
    _renderProduct(index) {
        if(index!==this.state.index) return;//最多只显示前后一个分类标签的内容
        return (
            <View style={{flex: 1}}>
                <Screening
                    ref={(ref) => this.screening = ref}
                    idNum={this.state.idNum}
                    sortCallBack={this._sortCallBack}
                    titleData={Datas.titleData}
                    selectedIndex={this.state.selectedIndex}
                    salesSortNum={this.state.salesSortNum}
                />

                <NewProduct
                    key={index}
                    canShowBackTopBtn={true}
                    codeValue={codeValue}
                    pageVersionName={pageVersionName}
                    dataSource={this.others[index]}
                    noGoodsTip={this.state.emptyData}
                    onEndReached={() => {
                        if (this.state.emptyData || this.state.endReached) {
                            return;
                        }
                        this.state.endReached = true;
                        this.pageNum++;
                        this._nextPage();
                    }}
                />
            </View>
        )
    }

    /**
     * 点击精选 渲染 UI 组件
     */
    _rederComponents(index) {
        if(index>this.state.index) return;//最多只显示后一个分类标签的内容
        this.state.moreDataIndexs = this.state.zeroGoods.slice(16, this.state.zeroGoods.length).concat(this.state.moreDataIndex);
        return (
            <ScrollView
                style={{flex:1}}
                ref="ScrollView"
                onScroll={(e)=>{this.onScrollView(e)}}
                scrollEventThrottle={30}
                onEndReached={() => {
                    if (this.state.emptyData || this.state.endReached) {
                        return;
                    }
                    this.state.endReached = true;

                    this._homeNextPage();
                }}
            >
                <ImgShuffling
                    codeValue={codeValue}
                    pageVersionName={pageVersionName}
                    dataSource={this.state.banners}
                    bannersLinks={this.state.bannersLinks}
                />
                {this.state.limitedTime && this.state.limitedTime.length ?
                    <TimeLimit
                        codeValue={codeValue}
                        pageVersionName={pageVersionName}
                        limitedTimeBuy={this.state.limitedTimeBuy}
                        limitedTime={this.state.limitedTime}
                        limitedGoods={this.state.limitedGoods}
                    /> : null}
                <ZeroTitle />
                {this.state.zeroGoods && this.state.zeroGoods.length > 8 ?
                    <NewProduct
                        codeValue={codeValue}
                        pageVersionName={pageVersionName}
                        dataSource={this.state.zeroGoods.slice(0, 8)}
                    /> : null}
                {this.state.popularGoods ?
                    <ScrollViewGoods
                        codeValue={codeValue}
                        pageVersionName={pageVersionName}
                        popularGoods={this.state.popularGoods}
                        id={this.state.id}
                        singleProductitions={2}
                    /> : null}
                {this.state.zeroGoods && this.state.zeroGoods.length >= 16 ?
                    <NewProduct
                        codeValue={codeValue}
                        pageVersionName={pageVersionName}
                        dataSource={this.state.zeroGoods.slice(8, 16)}
                    /> : null}
                {this.state.brandsGoods && this.state.brandsGoods.length ?
                    <BrandPavilion
                        codeValue={codeValue}
                        pageVersionName={pageVersionName}
                        brandsGoods={this.state.brandsGoods}
                        singleProductitions={4}
                    /> : null}
                {this.state.zeroGoods && this.state.zeroGoods.length > 16 ?
                    <NewProduct
                        codeValue={codeValue}
                        pageVersionName={pageVersionName}
                        dataSource={this.state.moreDataIndexs}
                    /> : null}
            </ScrollView>
        )
    }

    /**
     * 渲染 今日团购顶部 title 导航
     * @private
     */
    _renderTodayGroupTitle() {
        return (
            <NavigationBar
                leftButton={require('../../../foundation/Img/icons/Icon_back_white_@2x.png')}
                navigationBarBackgroundImage={require('../../../foundation/Img/groupbuy/Icon_brand_bg_@2x.png')}
                renderTitle={() => {
                    return (
                        <Image
                            source={require('../../../foundation/Img/groupbuy/Icon_title_.png')}
                            style={{width: ScreenUtils.scaleSize(186), height: ScreenUtils.scaleSize(42)}}
                        />
                    )
                }}
                barStyle={'light-content'}
                navigationStyle={{
                    ...Platform.select({ios: {marginTop: -22}}),
                    height: ScreenUtils.scaleSize(128)
                }}
            />
        );
    }


    /**
     *
     */
    onScrollView(e){
        let y = e.nativeEvent.contentOffset.y;
        if (y > ScreenUtils.screenH) {
            this.setState({
                showBackTop: true,
            })
        } else {
            this.setState({
                showBackTop: false,
            })
        }


        //     let y = event.nativeEvent.contentOffset.y;
        let navBarHeight = ScreenUtils.scaleSize(128);
        let progress = y / navBarHeight;
        if (progress > 1) {
            progress = 1;
        }
        if (progress < 0) {
            progress = 0;
        }
        if (this.topBar) {
            this.topBar.setNativeProps({
                style: {
                    opacity: progress
                }
            });
        }
        let height = e.nativeEvent.layoutMeasurement.height;
        let contentHeight = e.nativeEvent.contentSize.height;
        if (contentHeight > height && (y + height >= contentHeight - 20)) {
            //如果满足上啦条件，并且上一次子内容高度=这一次子内容高度说明没有数据了～
            if (this.originContentHeight === contentHeight) {
                return;
            }
            this.originContentHeight = contentHeight;
            this._homeNextPage();
        }


    }

    /**
     * 请求数据
     * @private
     */
    _renderTodayGroup(destinationUrl) {
        this.originContentHeight = -1;
        if (this.TotayGroupRequest) {
            this.TotayGroupRequest.setCancled(true);
        }
        let goodsList = [];
        this.TotayGroupRequest = new TotayGroupRequest({id: destinationUrl}, 'GET');
        this.TotayGroupRequest.showLoadingView().setShowMessage(false).start(
            (response) => {
                if( this.TotayGroupRequest.currTime !== "" ){
                    let currTime = this.TotayGroupRequest.currTime ;
                    this.currTime=currTime;
                }
                let data = response.data;
                let limitedTimeBuy = [];
                let limitedGoods = [];
                let remainingTime = [];
                if (data.packageList && data.packageList.length > 0) {
                    let packageList = data.packageList;
                    packageList.forEach((component, index) => {
                        // 获取banner数据 packageId  = "2"
                        if (component && component.packageId === '2') {
                            this.state.banners = [];
                            this.state.bannersLinks = [];
                            let bannerIndex = component.componentList;
                            for (let i = 0; i < bannerIndex.length; i++) {
                                this.state.banners.push(bannerIndex[i]);
                                if (bannerIndex[i].destinationUrlType === 6) {
                                    this.state.bannersLinks.push(bannerIndex[i]);
                                }
                            }
                        } else if (component && component.packageId === '26') {   // packageId  = "26" 获取限时抢购数据
                            limitedTimeBuy = component.componentList;
                            if (!limitedTimeBuy.length) {  // 防止数组为空
                                return;
                            }
                            for (let i = 0; i < limitedTimeBuy.length; i++) {
                                if (limitedTimeBuy[i].componentList && limitedTimeBuy[i].componentList.length > 0) {
                                    remainingTime.push(limitedTimeBuy[i].remainingTime); //将每组商品限时抢购时间存入数组
                                    limitedGoods.push(limitedTimeBuy[i].componentList.slice(0, 3)); //将每组商品存入数组且每组只取前三个商品，slice主要为了防止后台返回每组的商品过多导致前端显示错乱
                                }
                            }
                        } else if (component && component.packageId === '27') {  // packageId  = "27" 获取零点上新商品、人气推荐商品和品牌商品数据
                            goodsList = component.componentList[0].componentList;

                            this.indexId = component.componentList[0].id;

                            let zeroGoodsTime = [];
                            goodsList.forEach(item => {
                                if( item.groupBuyType === 1 ){
                                    zeroGoodsTime.push(item);
                                }
                            });
                            zeroGoodsTime.forEach((item,index)=>{
                                if( item.curruntDateLong ){
                                    item.curruntDateLong = this.currTime;
                                }
                            });
                            this.state.id = component.componentList[0].id;
                        } else if (component && component.packageId === '12') { // packageId  = "12" 获取今天团购的分类标题数据
                            this.state.titles = [];
                            let titleIndex = component.componentList;
                            for (let i = 0; i < titleIndex.length; i++) {
                                this.state.titles.push(titleIndex[i]);
                            }
                        }
                    })
                }
                ;
                codeValue = response.data.codeValue;
                pageVersionName = response.data.pageVersionName;
                //页面埋点
                DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                this._goodsClassification(goodsList);
                if (response.data) {
                    this.setState({
                        // datas: response.data,//这个在哪用到了
                        limitedTimeBuy,
                        limitedGoods,
                        limitedTime: remainingTime,
                        showBackTop: false,
                        isScoll:Platform.OS === 'ios'?false:true,
                    })
                }
                ;
                // DeviceEventEmitter.emit('START_TIMER', '启动定时器');
            }, (erro) => {
                // console.log(erro);
            }
        );
    }

    /**
     * 遍历商品数组，获取商品分组：零点、人气、品牌
     * @param 商品数组
     */
    _goodsClassification(goods) {
        let zeroGoods = [];
        let popularGoods = [];
        let brandsGoods = [];
        goods.forEach(item => {
            switch (item.groupBuyType) { //groupBuyType,1为零点上新商品,2为人气推荐商品,3为品牌商品
                case 1: {
                    zeroGoods.push(item);
                }
                    break;
                case 2: {
                    popularGoods.push(item);
                }
                    break;
                case 4: {
                    brandsGoods.push(item);
                }
                    break;
            }
        });
        this.state.zeroGoods = zeroGoods;
        this.state.popularGoods = popularGoods;
        this.state.brandsGoods = brandsGoods;
    }
}
const styles = StyleSheet.create({
    containers: {
        backgroundColor: Colors.background_grey,
        flex: 1
    },
    backTopView: {
        position: 'absolute',
        top: ScreenUtils.screenH - ScreenUtils.scaleSize(420) ,
        left: ScreenUtils.screenW - ScreenUtils.scaleSize(120),
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
    },
    backTopImg: {
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
    },
})