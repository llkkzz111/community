/**
 * Created by xiongmeng on 2017/5/1.
 */

import * as actionTypes from './actionTypes'

export const fetchDataCreate = (type,data) =>{
    return{
        type:type,
        payload:{
            data
        }
    }
};

//dialog显示关闭
export const showLoading = ()=>{
    return (dispatch, getState) => {
        dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
            type: actionTypes.DIALOG_LOADING,
            result: 'test',
            success: true
        }))
    }
};
