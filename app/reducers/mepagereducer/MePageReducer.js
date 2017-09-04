/**
 * Created by lu weiguo on 2017/5/17.
 * 个人中心 reducer
 */
import {handleActions} from 'redux-actions'
import {Actions} from 'react-native-router-flux'
import * as actionTypes from '../../actions/actionTypes'
const recordState = {
    mePageFootDatas:null,
}
export default handleActions({
    [actionTypes.FetchDataAction]: (state=recordState, action) => {
        const {
            payload: {
                data
            }
        } = action
        switch (data.type) { // TODO data.action
            //  用户浏览记录
            case actionTypes.USERFOOTPRINTS: {
                if(data.success&&data.result.data.item_code&&data.result.data.item_code.length>0){
                    state.mePageFootDatas=data.result.data.item_code;
                }
                return state;
            }
            //  用户信息及最新评价
            case actionTypes.GEtUSERMESSAGE: {
                if(data.success){
                    return{
                        ...state,
                        ...data.result
                    }
                }else{
                    return{
                        ...state,
                    }
                }
            }
            //  钱包与订单信息
            case actionTypes.WALLETORDER: {
                if(data.success){
                    return{
                        ...state,
                        ...data.result
                    }
                }else{
                    return{
                        ...state,
                    }
                }
            }
            //  最新物流查询
            case actionTypes.LOGISTICS: {
                if(data.success){
                    return{
                        ...data.result
                    }
                }else{
                    return{
                        ...state,
                    }
                }
            }
            default: {
                return state;
            }



        }
    },
}, recordState)
