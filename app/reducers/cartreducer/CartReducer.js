/**
 * Created by Zhang.xinchun on 2017/5/10.
 * 购物车的Reducer
 */
import {handleActions} from 'redux-actions'
import * as actionTypes from '../../actions/actionTypes'

const userState = {
    showDiscountCoupon: false,
    type: true,//true:完成状态,false:编辑状态
    ctType: true,//true:空购物车 false:列表购物车
    showDialog: false,
    showGiftDialog: false,//赠品Dialog false:隐藏 true: 显示
}

export default handleActions({
    [actionTypes.FetchDataAction]: (state, action) => {
        const {
            payload: {
                data
            }
        } = action

        switch (data.type) {
            //购物车列表展示
            case actionTypes.GETCART: {
                // console.log("==== cart reducer=>" + data)
                return {
                    ...state,
                    ctType: false,
                    type: true,
                }
            }
            //空购物车
            case actionTypes.GETNCART: {
                // console.log("==== cart reducer=>" + data)
                return {
                    ...state,
                    ctType: true,
                    type: true,
                }
            }
            //加入购物车
            case actionTypes.ADDCART: {
                return {
                    ...state,

                }

            }
            //加入收藏夹
            case actionTypes.ADDFAVORITE: {
                return {
                    ...state,
                }

            }
            //更新购物车
            case actionTypes.UPDATECART: {
                return {
                    ...state,
                }

            }
            //删除购物车
            case actionTypes.DELETECART: {
                return {
                    ...state,
                }

            }
            //选择购物车
            case actionTypes.CHECKCART: {
                return {
                    ...state,
                }

            }
            //购物车总数
            case actionTypes.GETCARTNUMBER: {
                return {
                    ...state,
                }

            }
            //购物车计算价格
            case actionTypes.CALCULATEPRICECOMMODITIES: {
                return {
                    ...state,
                }

            }
            //购物车编辑和完成状态切换
            case actionTypes.CHANGE_CART_TYPE: {
                return {
                    ...state,
                    type: !data.result,
                }
            }
            //购物车规格Dialgo
            case actionTypes.COMMERCIAL_SPECIFICATION: {
                return {
                    ...state,
                }
            }
            //关闭赠品列表
            case actionTypes.CLOSE_DIALOG: {
                return {
                    ...state,
                }
            }
            //赠品详细列表
            case actionTypes.OPEN_GIFT_DIALOG: {
                return {
                    ...state,
                }

            }
            default: {
                return {
                    ...state
                }
            }
        }
    },
}, userState)

