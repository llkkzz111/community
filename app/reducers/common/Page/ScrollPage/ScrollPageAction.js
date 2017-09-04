/**
* @file 滑动分页Action
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
import {
    PUT_TABLE_REDUX,
    ADD_TABLE_REDUX,
    CHANGE_TABLE_REDUX
} from './ScrollPageRedux';

/**
* @description
* 存入reducer
**/
const putTableReducer = (pageData) => (dispatch) =>
    dispatch({
        pageData,
        type: PUT_TABLE_REDUX
    });

/**
* @description
* 滑动增加下一页数据
**/
const addTableReducer = (addPageData) => (dispatch) =>
    dispatch({
        addPageData,
        type: ADD_TABLE_REDUX
    });

const changeTableReducer = (pageData) => (dispatch) =>
    dispatch({
        pageData,
        type: CHANGE_TABLE_REDUX
    });

export default {
    putTableReducer,
    addTableReducer,
    changeTableReducer
};
