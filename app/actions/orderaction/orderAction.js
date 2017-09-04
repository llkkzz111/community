/**
 * Created by Administrator on 2017/5/11.
 */
'use strict';

import * as actionTypes from '../actionTypes'
import Encry from '../../../foundation/common/NetworkInterface';
import showLoadingDialog from '../../../app/actions/dialogaction/DialogUtils'


export const fetchDataCreate = (type, data) => {
    return {
        type: type,
        payload: {
            data
        }
    }
};

// TODO 打开订单抵用券列表函数定义
export const openVoucherFunction = (data) => {

    return (dispatch) => {
        // alert('rewre')
        dispatch(fetchDataCreate(actionTypes.FetchDataAction), {
            type: actionTypes.ORDER_VOUNCHER_OPEN,
            result:''   ,
            success: true
        });
    }
}

// TODO 关闭订单抵用券列表函数定义
export const closeVoucherFunction = () => {
   return (dispatch, getState) => {
        dispatch(fetchDataCreate(actionTypes.FetchDataAction), {
            type: actionTypes.ORDER_VOUNCHER_CLOSE,
            result: 'test2',
            success: true
        });
   }
}



