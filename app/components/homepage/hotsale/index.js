/**
 * Created by YASIN on 2017/5/27.1
 * 热销首页
 */
import React from 'react';
import {
    View,
    Text,
    FlatList,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
} from 'react-native';
import Colors from '../../../config/colors';
import HotTabView from './HotTabView';
import HotListView from './HotListView';
import HotVarietyDialog from './HotVarietyDialog';
import Datas from './Datas';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import {Actions} from 'react-native-router-flux';
import HotSaleClassifyRequest from '../../../../foundation/net/home/hotsale/HotSaleClassifyRequest';
import HotSaleMoreRequest from '../../../../foundation/net/home/hotsale/HotSaleMoreRequest';
import NavigationBar from '../../../../foundation/common/NavigationBar';
const ALL = 'all';
const RECOMMOND = 'AP1706A026';
const PHONE = 'AP1706A024';
const GROUP = 'AP1706A022';
const GLOB_BUY = 'AP1706A021';
import {DataAnalyticsModule} from '../../../config/AndroidModules';
let codeValue = '';
let pageVersionName = '';
export default class HotSale extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            selectedIndex: 0,
            classifyDatas: [],
            refreshing: false,
            datas: [],
            pageNum: 1,
            pageSize: 20,
            dataQueryId: -1,
            selectedClassify: ALL,
            selectedClass:ALL
        };
    }

    render() {
        let self = this;
        return (
            <View style={styles.container}>
                {self._renderHotSaleTitle()}
                <HotTabView
                    selected={this.state.selectedIndex}
                    onItemClick={(index)=> {
                        //下拉刷新标记消失
                        this.state.refreshing = false;
                        //如果分类dialog显示，就取消
                        if (self.hotVarietyDialog && self.hotVarietyDialog.isShowing()) {
                            self.hotVarietyDialog.disMissDialog(false);
                        }
                        //如果连续点击当前tab就直接return
                        if (this.state.selectedIndex === index) {
                            //连续点击当前tab是全部
                            if (self.hotVarietyDialog && index === 0) {
                                if (self.hotVarietyDialog.isShowing()) {
                                    self.hotVarietyDialog.disMissDialog(true);
                                } else {
                                    self.hotVarietyDialog.showDialog(true);
                                }
                            }
                            return;
                        }
                        //改变当前选中的tab
                        self.setState({
                            selectedIndex: index,
                            selectedClass:ALL
                        }, ()=> {
                            setTimeout(()=>{
                                //如果选中的tab是全部，就请求全部商品
                                if (index === 0)this.state.selectedClassify = ALL;
                                //解决flatlist上拉加载更多bug
                                if (this.hotListView)this.hotListView.initContentHeight();
                                //请求数据，传入当前tab
                                this._sendPost(index);
                            },100);
                        });
                    }}
                />
                {/*渲染列表*/}
                {this._renderList()}
            </View>
        );
    }

    /**
     * 渲染首页——热销title
     * @private
     */
    _renderHotSaleTitle() {
        return (
            <NavigationBar
                renderTitle={()=> {
                    return (
                        <Image
                            source={require('../../../../foundation/Img/home/hotsale/icon_hotsale_title.png')}
                            style={styles.hotSaleTitleStyle}
                        />
                    )
                }}
                barStyle={'dark-content'}
                navigationStyle={{...Platform.select({ios: {marginTop: -22}})}}
            />
        );
    }

    /**
     * 渲染列表
     * @private
     */
    _renderList() {
        let self = this;
        let datas = this.state.datas;
        return (
            <View style={styles.dataContainer}>
                <HotListView
                    ref={(ref)=>this.hotListView = ref}
                    style={{flex: 1, width: ScreenUtils.screenW}}
                    datas={datas}
                    refreshing={this.state.refreshing}
                    onLoadMore={()=> {
                        //加载更多，pagenum++
                        this.state.pageNum++;
                        this._doMorePost(this.state.selectedClassify);
                    }}
                    onRefresh={()=> {
                        //下拉刷新，下拉刷新不显示dialog
                        this.setState({
                            refreshing: true
                        }, ()=> {
                            this._sendPost(this.state.selectedIndex);
                        });
                    }}
                    onItemClick={(index)=>{
                        DataAnalyticsModule.trackEvent3(datas[index].codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
                        //跳转到物品详情页面
                        Actions.GoodsDetailMain({itemcode:datas[index].contentCode});
                    }}
                />
                {/*渲染dialog*/}
                <HotVarietyDialog
                    ref={(ref)=>self.hotVarietyDialog = ref}
                    datas={self.state.classifyDatas}
                    onItemClick={(index)=> {
                        this.setState({
                            selectedClassify: self.state.classifyDatas[index].destinationUrl,
                            selectedClass:self.state.classifyDatas[index].selectedClass
                        }, ()=> {
                            if (this.hotListView)this.hotListView.initContentHeight();
                            this._sendPost(0);
                        });
                        self.hotVarietyDialog && self.hotVarietyDialog.disMissDialog(false);
                    }}
                    selectedFlag={this.state.selectedClass}
                />
            </View>
        );
    }

    componentDidMount() {
        //第一次进入请求全部分类
        this.state.selectedClassify = ALL;
        this._sendPost(0);
    }
    componentWillUnmount() {
        //页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }
    /**
     * 发送请求,第一页数据
     * @param page 页面索引
     * @param type 类型
     * @private
     */
    _sendPost(page) {
        this._initAllRequest();
        //全部分类
        if (page === 0) {
            this._doAllPost(this.state.selectedClassify);
        } else if (page === 1) {//全部推荐
            codeValue = RECOMMOND;
            //页面埋点
            DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
            this._doAllRecommond(RECOMMOND);
        } else if(page===2){//手机专享
            codeValue = PHONE;
            //页面埋点
            DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
            this._doAllRecommond(PHONE);
        }else if(page===3){//团购
            codeValue = GROUP;
            //页面埋点
            DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
            this._doAllRecommond(GROUP);
        }else if(page===4){//全球购
            codeValue = GLOB_BUY;
            //页面埋点
            DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
            this._doAllRecommond(GLOB_BUY);
        }
    }

    /**
     * 初始化请求
     * @private
     */
    _initAllRequest() {
        this.state.pageNum = 1;
        //如果是下拉刷新操作就不清空dialog
        if (!this.state.refreshing) {
            this.setState({
                datas: [],
            });
        }
    }

    /**
     * 全部分类
     * @params type 类型
     * @private
     */
    _doAllPost(type) {
        //查询所有商品
        if (type === ALL) {
            //查询指定类型商品
            this.hotSaleClassifyRequest && this.hotSaleClassifyRequest.setCancled(true);
            let params = {
                id: 'AP1706A011'
            };
            this.hotSaleClassifyRequest = new HotSaleClassifyRequest(params, 'GET');
            if (!this.state.refreshing) {
                this.hotSaleClassifyRequest.showLoadingView();
            }
            this.hotSaleClassifyRequest.start((response)=> {
                let state = {refreshing: false};
                if (response.datas)Object.assign(state, {datas: response.datas});
                if (response.dataQueryId)state.dataQueryId = response.dataQueryId;
                if (this.state.classifyDatas && this.state.classifyDatas.length === 0) {
                    if (response.classifyDatas)Object.assign(state, {classifyDatas: response.classifyDatas});
                }
                this.setState(state);
                codeValue = response.codeValue;
                pageVersionName = response.pageVersionName;
                //页面埋点
                DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
            }, (erro)=> {
                this.setState({
                    refreshing: false
                });
            });
        } else {
            this._doMorePost(type);
        }
    }

    /**
     * 全部推荐
     * @private
     */
    _doAllRecommond(id) {
        this.hotSaleClassifyRequest && this.hotSaleClassifyRequest.setCancled(true);
        let params = {
            id: id
        };
        this.hotSaleClassifyRequest = new HotSaleClassifyRequest(params, 'GET');
        if (!this.state.refreshing) {
            this.hotSaleClassifyRequest.showLoadingView();
        }
        this.hotSaleClassifyRequest.start((response)=> {
            let state = {refreshing: false};
            if (response.datas)Object.assign(state, {datas: response.datas});
            if (response.dataQueryId)state.dataQueryId = response.dataQueryId;
            this.setState(state);
        }, (erro)=> {
            this.setState({
                refreshing: false
            });
        });
    }

    /**
     * 加载更多
     * cateConditions 分类类型
     * @private
     */
    _doMorePost(cateConditions) {
        this.hotSaleMoreRequest && this.hotSaleMoreRequest.setCancled(true);
        let params = {
            id: this.state.dataQueryId,
            pageNum: this.state.pageNum,
            pageSize: this.state.pageSize
        };
        if (cateConditions&&cateConditions!==ALL)params.cateConditions = cateConditions;
        this.hotSaleMoreRequest = new HotSaleMoreRequest(params, 'GET');
        if (this.state.pageNum === 1 && !this.state.refreshing)this.hotSaleMoreRequest.showLoadingView();
        this.hotSaleMoreRequest.start((response)=> {
            this.setState({
                refreshing: false
            });
            if (response.datas && response.datas.length >= 0) {
                this.setState({
                    datas: this.state.datas.concat(response.datas)
                });
            }
        }, (erro)=> {
            this.setState({
                refreshing: false
            });
        });
    }

}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: Colors.background_white
    },
    dataContainer: {
        flex: 1,
        alignItems: 'center',
        alignSelf: 'stretch',
    },
    hotSaleTitleStyle: {
        width: ScreenUtils.scaleSize(154),
        height: ScreenUtils.scaleSize(49),
        alignSelf: 'center',
    },
    navContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.text_white,
        justifyContent: 'space-between',
        padding: ScreenUtils.scaleSize(15),
        width: ScreenUtils.screenW
    },
    leftArrow: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(14)
    },
    leftContainer: {},
});