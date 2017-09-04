/**
 * @file 创建reducer和store构造
 * @author 魏毅
 * @version 0.0.2
 * @license 东方购物 2017
 * @see {@link weiyi@ocj.com.cn}
 * @TODO
 * 需要全部重构，store结构不符合性能和项目架构
 * 1)增加同步和异步store
 * 2)增加store持久化
 * 3)增加依赖注入store功能
 */
"use strict";
import {combineReducers} from 'redux';
// 获取store
import store from 'APP/createStore';
import routes from './Routes';
import reducer from './Reducer';
import ActivityReducer from './cartreducer/ActivityReducer';
import DialogReducer from './dialogreducer/DialogReducer';
import ClassificationPageReducer from './classificationpagereducer/ClassificationPageReducer';
// 导入外部  个人中心首页 Reducer
import MePageReducer from './mepagereducer/MePageReducer';
// 获取公共组件reducer
import Common from './common';

/**
* @description
* 同步的reducer
* @const {Object}
**/
const syncReducers: Object = {
    /**
    * @description
    * 老版本的reducer
    **/
    routes,
    reducer,
    ActivityReducer,
    DialogReducer,
    ClassificationPageReducer,
    MePageReducer,
    /**
    * @description
    * 新版本的reducer
    **/
    Common
};

/**
* @description
* 异步的reducer
* @const {Object}
**/
const asyncReducers: Object = {};

/**
* @function
* reducer构造器
* @return {Object} - 组装后的reducer
**/
const createRootReducer: Object = () =>
   combineReducers({
       ...syncReducers,
       ...asyncReducers
   });

/**
* @description
* 按需加载时，立即注入对应的 Reducer
* @param  {string} key - 需要在State后注入的索引
* @param  {function} reducer - 需要注入的reducer
* @param  {boolean} force - 强制增加，即使是之前存在store也去重新创建
* @return {void}
*/
export const injectReducer: void = (key: string, reducer: Object, force: boolean | null) => {
    if (!asyncReducers[key] || force) {
        asyncReducers[key] = reducer.default ? reducer.default : reducer;
        store.replaceReducer(createRootReducer()); // 替换当前的 rootReducer
    }
};

/**
* @description
* 按需加载时，销毁对应的 Reducer
* @param  {string} key - 需要在State后注入的索引
* @return {void}
*/
export const deleteReducer: void = (key: string) => {
    if (asyncReducers[key]) {
        delete asyncReducers[key];
        store.replaceReducer(createRootReducer()); // 替换当前的 rootReducer
    }
};

/**
* @exports
* 返回一个初始Reducer
**/
export default createRootReducer();
