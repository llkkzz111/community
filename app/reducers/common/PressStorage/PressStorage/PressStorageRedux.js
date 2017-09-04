/**
* @file 访问记忆Redux
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import { createSelector } from "reselect";
import createReducer from 'REDUX_CREATOR';

/**
* @description
* 组件状态 storageState: store => 组件name => 用户name => 记录code
* @const {Object}
**/
const pressStorageState: Object = {};

/**
* @description
* 数据选择器
* @const {Function}
**/

export const getPressStorage = (state ,namespace, username, itemKey) => {
    const item = state.Common.HOC;
    return !item.PressTextColor[namespace] ||
        !item.PressTextColor[namespace][username] ||
        !item.PressTextColor[namespace][username][itemKey] ? false : true;
};

/**
* @description
* actionType
* @const {Symbol}
**/
export const [
    PRESS_STORAGE_ADD_STORE
] = [
    'PRESS_STORAGE_ADD_STORE'
];

/**
* @description
* reducer
* @exports
**/
export default createReducer(pressStorageState, {
    // 修改store, 增加用户昵称
    [PRESS_STORAGE_ADD_STORE]: (state, action) => {
        if(action.data.namespace && action.data.username) {
            return state.update(action.data.namespace, d => {
                d ? null : d = {};
                d[action.data.username] = {...d[action.data.username], ...{
                    [action.data.selectCode]: true
                }};
                return d;
            }).toJS();
        } else {
            return state.toJS();
        }
    }
});
