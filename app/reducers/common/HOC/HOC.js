/**
* @file 创建高阶组件reducer
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import { combineReducers } from 'redux';
import PressStorage from '../PressStorage';
/**
* @description
* 混合多个OC组件
**/
export default combineReducers({
    ...PressStorage
});
