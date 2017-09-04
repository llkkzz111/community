/**
* @file 分流
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
import PressStorage, { select } from './PressStorage';
import PressStorageAction from './PressStorage/PressStorageAction';

export const Action = PressStorageAction;

export const selector = {
    ...select
};

/**
* @description
* 点击记忆功能reducer
* @const {Function}
**/
export default {
    ...PressStorage
};
