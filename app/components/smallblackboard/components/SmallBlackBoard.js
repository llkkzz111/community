/**
* @file 小黑板列表页(逻辑层组件)
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import React, { Component } from 'react';
import { Platform, BackAndroid } from 'react-native';
import { Actions } from 'react-native-router-flux';
import * as routeConfig from 'CONFIG/routeConfig';
import { DataAnalyticsModule } from 'CONFIG/AndroidModules';
import * as RouteManager from 'CONFIG/PlatformRouteManager';
import GetSmallBlackBoardData from 'FOUNDATION/net/smallblackboard/GetSmallBlackBoardData';
import GetSmallBlackBoardDataPage from 'FOUNDATION/net/smallblackboard/GetSmallBlackBoardDataPage';
import GetAdShowType from 'NET/AdFloatingLayer/GetAdShowType';
import GetAdResult from 'NET/AdFloatingLayer/GetAdResult';
import SmallBlackBoardContent from './SmallBlackBoardContent';

/**
* @classdesc
* 小黑板列表页(逻辑层组件)
**/
export class SmallBlackBoard extends Component {
    /**
    * @description
    * 写死获取全部数据的key
    * @TODO: 后台都是实习生没办法，他们不会改，以后能改就改吧
    **/
    static REQUEST_ID = 'AP1706A009';

    constructor() {
        super();
        this.index = 0;
        // 缓存tab信息
        this.cacheData = {};
        // redux增加数据
        this.addData = {};
        this.changeData = {};
        // tab数组
        this.tabList = [];
        this.state = {
            // 是否显示悬浮
            showAd: false,
            showCircle: false,
            // 当前tab数据
            tabList: []
        };
    }
    componentDidMount() {
        // 加载第一页
        this._requestUrlData(SmallBlackBoard.REQUEST_ID);
    }
    componentWillMount() {
        /**
        * @description
        * 安卓监听机械回退
        **/
        Platform.OS === 'android' ?
            BackAndroid.addEventListener('hardwareBackPress', ::this._backPress) : null;
    }
    componentWillUnmount() {
        // 页面埋点
        DataAnalyticsModule.trackPageEnd(`${this.codeValue}${this.pageVersionName}`);
        /**
        * @description
        * 移除安卓监听机械回退
        **/
        Platform.OS === 'android' ?
            BackAndroid.removeEventListener('hardwareBackPress', ::this._backPress) : null;
    }
    shouldComponentUpdate(nextProps, nextState) {
        // 逻辑层组件只会更新一次
        return this.state.tabList.length === 0
            || nextState.showAd !== this.state.showAd
            || nextState.showCircle !== this.state.showCircle;
    }
    /**
    * @description
    * 回退到首页
    **/
    _backPress() {
        if(window.currentScene === 'SmallBlackBoard') {
            Actions.Home();
            return true;
        } else {
            return false;
        }
    }
    /**
    * @description
    * 获取浮层数据
    **/
    _getAdShowTypeData() {
        new GetAdShowType({contentCode: 'AP1708A001E004001'}, 'GET').start(
            resp => resp.code === 200 && resp.data && resp.data.open_state === 'Y' ? this.setState({
                AdFloatingLayerData: resp.data,
                showCircle: true
            }) : null, err => console.warn(err.message)
        );
    }
    /**
    * @description
    * 请求数据
    **/
    _requestUrlData(destinationUrl) {
        if (this.cacheData[this.index]) {
            // 请求过的数据
            this.title = this.tabList[this.index].title;
        } else {
            const tabRequest = new GetSmallBlackBoardData({id: destinationUrl}, 'GET');
            tabRequest.showLoadingView().setShowMessage(false).start(
                response => {
                    if (response) {
                        // 存在头数据那么加载头数据
                        if(response.tabList && response.tabList.length > 0) {
                            this.tabList = response.tabList;
                            this.setState({tabList: this.tabList});
                        }
                        // 获取title
                        const title = this.tabList[this.index].title;
                        // 记录componentList id
                        response.componentList ?
                            this.tabList[this.index].componentList = response.componentList : null;
                        this._addPage(1, title, null, this.tabList[this.index].componentList);
                        // 记录请求过的tab
                        this.cacheData[this.index] = true;
                        // 获取活动浮层数据
                        this._getAdShowTypeData();
                        // 页面埋点
                        this.codeValue = response.codeValue;
                        this.pageVersionName = response.pageVersionName;
                        DataAnalyticsModule.trackPageBegin(`${this.codeValue}${this.pageVersionName}`);
                    }
                }, erro => null
            );
        }
    }
    /**
    * @description
    * 分页
    **/
    _addPage(pageNum, title, e, id = this.tabList[this.index].componentList) {
        const tabRequest = new GetSmallBlackBoardDataPage({id, pageNum, pageSize: 10}, 'GET');
        tabRequest.start(response => response ? this.addData[title](response.data.list) : null);
    }
    /**
    * @description
    * 获取当前的
    * @param index
    * @param id
    **/
    _onClickTitle(dt) {
        // 判断索引是否一致
        if(this.index === dt.i) {return;} else {this.index = dt.i;}
        if (dt.i === 0) {
            this._requestUrlData(SmallBlackBoard.REQUEST_ID);
            //埋点
            DataAnalyticsModule.trackEvent3(SmallBlackBoard.REQUEST_ID, '', {'pID': this.codeValue, 'vID': this.pageVersionName});
        } else {
            const destinationUrl = this.state.tabList[dt.i].destinationUrl !== null ? this.state.tabList[dt.i].destinationUrl : '';
            this._requestUrlData(destinationUrl);
            //埋点
            DataAnalyticsModule.trackEvent3(destinationUrl, '', {'pID': this.codeValue, 'vID': this.pageVersionName});
        }
    }
    /**
    * @description
    * 跳转到详情
    **/
    _jumpDetails({ destinationUrl, contentCode, codeValue }) {
        DataAnalyticsModule.trackEvent3(codeValue, '', {'pID': this.codeValue, 'vID': this.pageVersionName});
        Actions.SmallBlackBoardDetails({destinationUrl, contentCode});
    }
    /**
    * @description
    * 活动浮层页面获取数据
    **/
    _getAdResultData() {
        new GetAdResult({eventNo: this.state.AdFloatingLayerData.event_no, contentCode: 'AP1708A001E004001'}, 'GET').start(
            resp => resp.code === 200 && resp.data ? this.setState({
                AdFloatingLayerData: {
                    ...this.state.AdFloatingLayerData,
                    ...resp.data
                },
                showAd: true,
                showCircle: false
            }) : null, error => Number(error.code) >= 4010 && Number(error.code) <= 4014 ? RouteManager.routeJump({
                page: routeConfig.Login,
            }) : null
        );
    }
    /**
     * 关闭浮层
     * @private
     */
    _closeAdFloatingLayer() {
        this.setState({
            AdFloatingLayerData: {},
            showAd: false
        });
    }
    render() {
        return (
            <SmallBlackBoardContent
                // 传递数据
                {...this.state}
                getAdResultData={::this._getAdResultData}
                closeAdFloatingLayer={::this._closeAdFloatingLayer}
                // 传递事件
                requestUrlData={::this._requestUrlData}
                onClickTitle={::this._onClickTitle}
                jumpDetails={::this._jumpDetails}
                addPage={::this._addPage}
                // 获取木偶组件事件
                getRedux={(title, addData, changeData) => {
                    this.addData[title] = addData;
                    this.changeData[title] = changeData;
                }}
            />
        );
    }
}
