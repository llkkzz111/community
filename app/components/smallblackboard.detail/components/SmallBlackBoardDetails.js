/**
* @file 小黑板详情（逻辑层组件）
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import React, { Component } from 'react';
import { Platform } from 'react-native';
import { Actions } from 'react-native-router-flux';
import { DataAnalyticsModule } from 'CONFIG/AndroidModules';
import * as RouteManager from 'CONFIG/PlatformRouteManager';
import * as routeConfig from "CONFIG/routeConfig";
import AppConst from 'CONSTANTS/AppConstant';
import SmallBlackBoardDetailsContent from './SmallBlackBoardDetailsContent';
import GetSmallBlackBoardDetailsData from 'NET/smallblackboard/GetSmallBlackBoardDetailsData';

/**
* @classdesc
* 小黑板详情（逻辑层组件）
**/
export class SmallBlackBoardDetails extends Component {
    constructor() {
        super();
        this.state = {
            graphic: {}, //图文
            goodsList: [] //相关商品列表
        };
    }
    componentDidMount() {
        // 获取数据
        this._getNetData();
    }
    shouldComponentUpdate(nextProps, nextState) {
        // 只有没有图文详情时候才更新
        return !Object.keys(this.state.graphic).length;
    }
    componentWillUnmount() {
        // 埋点
        DataAnalyticsModule.trackPageEnd(`${this.codeValue}${this.pageVersionName}`);
    }
    // 获取数据
    _getNetData() {
        this.GetHomeDataRequest ? this.GetHomeDataRequest.setCancled(true) : null;
        this.GetHomeDataRequest = new GetSmallBlackBoardDetailsData({
            id: this.props.destinationUrl,
            contentCode: this.props.contentCode
        }, 'GET');
        this.GetHomeDataRequest.showLoadingView();
        this.GetHomeDataRequest.start(
            response => {
                if(response.data) {
                    // 埋点
                    this.codeValue = response.data.codeValue;
                    this.pageVersionName = response.data.pageVersionName;
                    // 填入数据
                    this.setState({
                        // 图文
                        graphic: response.data.packageList[0].componentList[0],
                        // 相关商品列表
                        goodsList: response.data.packageList[1].componentList[0].componentList
                    });
                    // 事务结束后加入页面埋点
                    DataAnalyticsModule.trackPageBegin(`${this.codeValue}${this.pageVersionName}`);
                };
            }, erro => {}
        );
    }
    /**
    * @description
    * 小黑板M站地址
    * @private
    **/
    _smallBlackBoardDetailsM(contentCode, id) {
        return `${AppConst.H5_BASE_URL}/app/smallblackboard.html?contentCode=${contentCode}&id=${id}&_=${Math.random()}`;
    }
    /**
    * @description
    * 分享逻辑
    * @private
    **/
    _share(graphic) {
        Platform.OS === 'ios' ? RouteManager.routeJump({
            page: routeConfig.Share,
            param: {
                title: graphic.title,
                text: graphic.title,
                image: graphic.firstImgUrl,
                url: this._smallBlackBoardDetailsM(this.props.contentCode, this.props.destinationUrl)
            },
            fromRNPage: routeConfig.SmallBlackBoardDetails
        }) : RouteManager.routeJump({
                page: routeConfig.Share,
                param: {
                title: graphic.title,
                content: graphic.title,
                image_url: graphic.firstImgUrl,
                target_url: this._smallBlackBoardDetailsM(this.props.contentCode, this.props.destinationUrl)
            },
            fromRNPage: routeConfig.SmallBlackBoardDetails
        });
    }
    /**
    * @description
    * 小黑板相关商品列表点击跳转与埋点逻辑
    * @private
    **/
    _productLink(item) {
        DataAnalyticsModule.trackEvent3(item.codeValue, "", {'pID': this.codeValue, 'vID': this.pageVersionName});
        Actions.GoodsDetailMain({itemcode: item.contentCode});
    }
    render() {
        return (
            Object.keys(this.state.graphic).length ? (
                <SmallBlackBoardDetailsContent
                    productLink={ ::this._productLink }
                    share={ ::this._share }
                    { ...this.state }
                />
            ) : null
        );
    }
}
