/**
 * Created by dongfanggouwu-xiong on 2017/5/17.
 */
import { handleActions } from 'redux-actions'
import { Actions } from 'react-native-router-flux'
import * as actionTypes from '../../actions/actionTypes'

const userState = {
    result: [123],
    showDiscountCoupon: false,
}

export default handleActions({
    [actionTypes.FetchDataAction]: (state, action) => {
        const { payload: {
            data
        } } = action

        switch (data.type) {
            case actionTypes.DISCOUNTCOUPON: //折扣券列表
            {
                if (data.result.success) {
                    return {
                        ...state,
                        result: data,
                        showDiscountCoupon: true
                    }
                }
                else {
                    return {
                        ...state,
                        showDiscountCoupon: true
                    }
                }
            }
            case actionTypes.DISCOUNTCOUPON_ClOSE://关闭折扣券列表
            {
                return {
                    showDiscountCoupon: false
                }
            }
            default:
            {
                return {
                    ...state
                }
            }
        }
    },
}, userState)
