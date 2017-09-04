/**
* @file 滑动分页Redux
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
* 组件状态
* @const {Object}
**/
const PageState: Object = {};

/**
* @description
* 数据选择器
* @const {Function}
**/
export const scrollPage = state => state.Common.OC.ScrollPage;
// 获取表格信息
export const getScrollPage = createSelector(scrollPage, table => table);

/**
* @description
* actionType
* @const {Symbol}
**/
export const [
    PUT_TABLE_REDUX,
    ADD_TABLE_REDUX,
    DELETE_TABLE_REDUX,
    DELETE_ALL_TABLE_REDUX,
    CHANGE_TABLE_REDUX
] = [
    `PUT_TABLE_REDUX`,
    `ADD_TABLE_REDUX`,
    `DELETE_TABLE_REDUX`,
    `DELETE_ALL_TABLE_REDUX`,
    `CHANGE_TABLE_REDUX`
];

/**
* @description
* reducer
* @exports
**/
export default createReducer(PageState, {
    // 存入store
    [PUT_TABLE_REDUX]: (state, action) => {
        const {namespace, page, data} = action.pageData;
        return namespace ?
            state.set(namespace, {
                page: page || 1,
                data: data || [],
                isEnd: false,
                isFirst: true
            }).toJS() : {};
    },
    // 下一页添加数据
    [ADD_TABLE_REDUX]: (state, action) => {
        const {namespace, page, data, isEnd, isFirst} = action.addPageData;
        return namespace ?
            state.update(namespace, d => {
                return {
                    page: state.get(namespace).isFirst ? 1 : d.page + 1,
                    data: data ? d.data.concat(data) : d.data,
                    isEnd: isEnd,
                    isFirst: isFirst
                };
            }).toJS() : {};
    },
    // 删除所有store
    [DELETE_ALL_TABLE_REDUX]: (state, action) => {
        return {};
    },
    [CHANGE_TABLE_REDUX]: (state, action) => {
        const {namespace, data} = action.pageData;
        return namespace ?
        state.set(namespace, {
            ...state.get(namespace),
            ...{
                data: data || state.get(namespace).data
            }
        }).toJS() : {};
    }
});
