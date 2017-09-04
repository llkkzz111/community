/**
* @file redux配置
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
import {createStore, applyMiddleware, compose} from 'redux';
import ThunkMiddleware from 'redux-thunk';
// import { fetchMiddleware } from 'MIDDLEWARE';
import reducers from './reducers/IndexReducer';

/**
* @description
* devtools配置
* @see {@link https://github.com/zalmoxisus/redux-devtools-extension}
* @const {object}
**/
const devtools =
    window['devToolsExtension'] && __DEV__
     ? window['devToolsExtension']() : f => f;

/**
* @description
* 配置redux中间件
**/
const finalCreateStore = compose(
    applyMiddleware(ThunkMiddleware),
    // applyMiddleware(ThunkMiddleware, fetchMiddleware),
    devtools
)(createStore);

/**
* @exports
* store
**/
export default finalCreateStore(reducers, {});
