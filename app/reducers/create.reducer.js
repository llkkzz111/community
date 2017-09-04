/**
 * @file 创建reducer
 * @author 魏毅
 * @version 0.0.1
 * @license 东方购物 2017
 * @see {@link weiyi@ocj.com.cn}
 */
"use strict";
import { List, Map } from 'immutable';

/**
* @description
* 创建reducer
* @param {Object} initState - 初始化状态
* @param {Object} handlers - reducer改变state的函数，@eg: 必须为纯函数
* @return {function} - 返回经过改造的reducer
* @example
* export default createReducer(accessState, {
*    [USER_ADD_REMEMBER]: (state, action) => {
*       return state.toJS();
*    }
* );
**/
export default (initState: Object, handlers: Object): Function => (state = initState, action: Object): Object => {
    // 获取对应action
    const handler: Function | any = handlers[action.type];
    if (handler) {
        // 判断类型增加不可变数据结构
        switch (Object.prototype.toString.call(state).toLowerCase()) {
            case `[object object]`:
                return handler(Map(state), action);
            case `[object array]`:
                return handler(List(state), action);
            default:
                return {...state};
        }
    } else {
        // 没有匹配type直接返回
        return {...state};
    }
};
