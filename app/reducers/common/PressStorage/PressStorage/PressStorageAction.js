/**
* @file 访问记忆Action
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
import {
    PRESS_STORAGE_ADD_STORE
} from './PressStorageRedux';

/**
* @descriooption
* 存入store
**/
const addStore = data => dispatch =>
    dispatch({
        data,
        type: PRESS_STORAGE_ADD_STORE
    });

export default {
    addStore
};
