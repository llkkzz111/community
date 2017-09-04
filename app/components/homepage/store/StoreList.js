/**
 * Created by YASIN on 2017/6/2.
 * 店铺全列表
 */
import React, {Component}from 'react';
import {
    View,
    Image,
    TouchableOpacity,
    StyleSheet,
    Platform,
    ScrollView,
    Text
}from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import NavigationBar from '../../../../foundation/common/NavigationBar';
import StoreListIndex from './StoreListIndex';
import StoreTabView from './StoreTabView';
import StoreListRequest from '../../../../foundation/net/home/store/StoreListRequest';
import StoreListMoreRequest from '../../../../foundation/net/home/store/StoreListMoreRequest';
//时尚大牌
const POPULAR_LIST = 'AP1706A043';
//优品推荐
const RECOMMOND_LIST = 'AP1706A044';

export default class StoreList extends Component {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            selectedIndex: this.props.selectedIndex,
            refreshing: false,
            datas: [],
            dataQueryId: -1,
            pageNum: 1,
            pageSize: 20
        };
    }

    render() {
        return (
            <View style={styles.container}>
                {/*渲染navigator*/}
                {this._renderNav()}
                <View style={{width: ScreenUtils.screenW, flex: 1, marginTop: ScreenUtils.scaleSize(1)}}>
                    {/*渲染条目*/}
                    {this._renderData()}
                    {/*渲染tabview*/}
                    {this._renderTabView()}
                </View>
            </View>
        )
    }

    /**
     * 渲染导航栏
     * @private
     */
    _renderNav() {
        return (
            <NavigationBar
                title={'店铺全列表'}
                navigationStyle={{...Platform.select({ios: {marginTop: -22}})}}
                barStyle={'dark-content'}
            />
        );
    }

    /**
     * 渲染头部tabview
     * @private
     */
    _renderTabView() {
        return (
            <View
                ref={(ref)=> {
                    this.tabView = ref
                }}
                style={{position: 'absolute', top: 0, right: 0, left: 0 ,borderBottomWidth:StyleSheet.hairlineWidth,borderBottomColor:'#dddddd' }}
            >
                <StoreTabView
                    onTabClick={(index)=> {
                        if (this.state.selectedIndex === index)return;
                        this.storeList && this.storeList.initContentHeight();
                        this.setState({
                            selectedIndex: index,
                            datas:[]
                        }, ()=> {
                            if (index === 0) {
                                this._doPost(POPULAR_LIST);
                            } else {
                                this._doPost(RECOMMOND_LIST);
                            }
                        });
                    }}
                    selectedIndex={this.state.selectedIndex}
                />
            </View>
        );
    }

    /**
     * 渲染数据
     *@private
     */
    _renderData() {
        return (
            <View style={{flex: 1, marginTop: ScreenUtils.scaleSize(80)}} ref={(ref)=> {
                this.storeListView = ref
            }}>
                <StoreListIndex
                    ref={(ref)=> {
                        this.storeList = ref
                    }}
                    datas={this.state.datas}
                    refreshing={this.state.refreshing}
                    onRefresh={()=> {
                        //下拉刷新，下拉刷新不显示dialog
                        this.setState({
                            refreshing: true
                        }, ()=> {
                            if (this.state.selectedIndex === 0) {
                                this._doPost(POPULAR_LIST);
                            } else {
                                this._doPost(RECOMMOND_LIST);
                            }
                        });
                    }}
                    onLoadMore={()=> {
                        //加载更多，pagenum++
                        this.state.pageNum++;
                        this._doMorePost();
                    }}
                    //onScroll={this._onScroll.bind(this)}
                />
            </View>
        );
    }

    /**
     * 吸顶效果
     * @param event
     * @private
     */
    _onScroll(event) {
        let y = event.nativeEvent.contentOffset.y;
        //offset为tabview的高度
        let offset = ScreenUtils.scaleSize(80);
        //滑动y开始
        let belowLimit = 0;
        //滑动的进度（0-1）
        let progressY = (y - belowLimit) / offset;
        this.tabView && this.tabView.setNativeProps({
            style: {
                opacity: (1 - progressY)
            }
        });
        let marginTop = offset * (1 - progressY);
        if (marginTop < 0) {
            marginTop = 0;
        } else if (marginTop > offset) {
            marginTop = offset;
        }
        this.storeListView.setNativeProps({
            style: {
                marginTop: marginTop
            }
        });
    }

    componentDidMount() {
        //请求时尚大牌数据
        this._doPost(POPULAR_LIST);
    }

    /**
     * 请求数据 第一页数据
     * @param id
     * @private
     */
    _doPost(id) {
        this.storeListRequest && this.storeListRequest.setCancled(true);
        let params = {
            id: id
        };
        this.storeListRequest = new StoreListRequest(params, 'GET');
        if (!this.state.refreshing)this.storeListRequest.showLoadingView();
        this.storeListRequest.start((response)=> {
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
     * @private
     */
    _doMorePost() {
        this.storeListMoreRequest && this.storeListMoreRequest.setCancled(true);
        let params = {
            id: this.state.dataQueryId,
            pageNum: this.state.pageNum,
            pageSize: this.state.pageSize
        };
        this.storeListMoreRequest = new StoreListMoreRequest(params, 'GET');
        this.storeListMoreRequest.start((response)=> {
            if (response.datas && response.datas.length >= 0) {
                this.setState({
                    datas: this.state.datas.concat(response.datas)
                });
            }
        }, (erro)=> {
        });
    }
}
const styles = StyleSheet.create({
    container: {
        backgroundColor: Colors.background_grey,
        flex: 1,
        width: ScreenUtils.screenW
    },
});