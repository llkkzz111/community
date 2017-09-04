/**
 * Created by dhy on 2017/8/14.
 */
import React, {Component, PureComponent, PropTypes} from 'react';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';//屏幕适配和时间换算工具
import Colors from '../config/colors';//颜色类
import Fonts from '../config/fonts';//字体设置类
import NavigationBar, {getStatusHeightHome, getAppHeight, getStatusHeight} from '../../foundation/common/NavigationBar';//头部导航
import {Actions} from 'react-native-router-flux';//页面跳转
import NetErro from '../components/error/NetErro';//错误弹出页面
import {DataAnalyticsModule} from '../config/AndroidModules';//埋点工具类
import Global from './global';//全局变量
import RnConnect from '../config/rnConnect';//调用原生方法或者页面
import * as routeConfig from '../config/routeConfig';//路由
import * as RouteManager from '../config/PlatformRouteManager';//原生RN路由交互
import * as Consts from '../constants/Constants';//字符串常量
import {connect} from 'react-redux';//链接redux
//导出
module.exports = {
    PropTypes,
    connect,
    Consts,
    RnConnect,
    routeConfig,
    RouteManager,
    Component,
    PureComponent,
    React,
    ScreenUtils,
    Colors,
    Fonts,
    NavigationBar,
    Actions,
    NetErro,
    DataAnalyticsModule,
    Global,
    getStatusHeightHome,
    getAppHeight,
    getStatusHeight
};