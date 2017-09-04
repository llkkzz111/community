/**
 * @file 创建记忆功能reducer
 * @author 魏毅
 * @version 0.0.1
 * @license 东方购物 2017
 * @see {@link weiyi@ocj.com.cn}
 */
"use strict";
import { AsyncStorage } from 'react-native';
import { bindActionCreators } from 'redux';
import { List, Map } from 'immutable';
import store from 'APP/createStore';

/**
* @description
* 创建记忆功能reducer
* @param {String} namespace - 命名空间store存入的key
* @param {Object} initState - 初始化状态(若存在storage中的state那么这个state会被覆盖)
* @param {Object} handlers - reducer改变state的函数，@eg: 必须为纯函数
* @param {any} action - 初始化时候修改传入数据
* @return {function} - 返回经过改造的reducer
* @example
* export default createStorageReducer('name', accessState, {
*    [USER_ADD_REMEMBER]: (state, action) => {
*       return state.toJS();
*    }
* );
**/
export default (namespace: String, initState: Object, handlers: Object, action: any): Function => {
    /**
    * @description
    * 修改store action type
    **/
    const CHANGE_STORE_STATE = `CHANGE_STORE_STATE_${namespace}`;
    // 初始化时候判断是否存在记忆store
    AsyncStorage.getItem(namespace).then((d: String | null) => {
        if(d && Object.prototype.toString.call(d).toLowerCase() === '[object string]') {
            let storageState = null;
            try {
                storageState = JSON.parse(d);
            } catch(e) {
                AsyncStorage.removeItem(namespace).catch(e => console.error(e));
                // 存入默认state
                AsyncStorage.setItem(namespace, JSON.stringify(initState)).catch(e => console.error(e));
            }
            // 存在的 => 修改store
            if(storageState) {
                Object.prototype.toString.call(action).toLowerCase() === "[object function]" ? storageState = action(storageState) : null;
                store.dispatch({ type: CHANGE_STORE_STATE, data: storageState });
            }
        } else {
            // 存入默认state
            AsyncStorage.setItem(namespace, JSON.stringify(initState)).catch(e => console.error(e));
        }
    }).catch(e => console.error(e));
    return (state = initState, action: Object): Object => {
        if (action.type !== CHANGE_STORE_STATE) {
            // 获取对应action
            const handler: Function | any = handlers[action.type];
            if (handler) {
                // 判断类型增加不可变数据结构
                switch (Object.prototype.toString.call(state).toLowerCase()) {
                    case `[object object]`:
                        let newObjectState = handler(Map(state), action);
                        // 持久化记忆state
                        AsyncStorage.setItem(namespace, JSON.stringify(newObjectState)).catch(e => console.error(e));
                        return newObjectState;
                    case `[object array]`:
                        let newArrayState = handler(List(state), action);
                        // 持久化记忆state
                        AsyncStorage.setItem(namespace, JSON.stringify(newArrayState)).catch(e => console.error(e));
                        return newArrayState;
                    default:
                        return { ...state };
                }
            } else {
                // 没有匹配type直接返回
                return { ...state };
            }
        } else {
            // 持久化store直接存入
            return { ...state, ...action.data };
        }
    };
};
