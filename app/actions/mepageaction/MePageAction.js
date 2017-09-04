/**
 * Created by lu weiguo on 2017/5/23.
 * 个人中心首页 Action
 */
import * as actionTypes from '../actionTypes'
import Encry from '../../../foundation/common/NetworkInterface';
export const fetchDataCreate = (type, data) => {
    return {
        type: type,
        payload: {
            data
        }
    }
};


// 获取个人中心首页 -- 最新物流查询
export const logistics = (data) => {
    return (dispatch, getState) => {
        Encry.logistics(data, (result) => {
            dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                type: actionTypes.WALLETORDER,
                result: {
                    ...result
                },
                success: true
            }))
        }, (error) => {
            dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                type: actionTypes.WALLETORDER,
                result: error,
                success: false
            }))
        });
    }
}




























