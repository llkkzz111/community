/**
 * Created by XiongMeng on 2017/2/17.
 */
import {handleActions} from 'redux-actions'
import {Actions} from 'react-native-router-flux'
import * as actionTypes from '../../actions/actionTypes'
import {Alert} from 'react-native'

const userState = {

    // giftPickUpDialogDatas:{ //赠品相关数据，输入与输出
    //     giftData:[],
    //     // show:false,//显示与否
    // },
    // giftshow:false,
    // categoryShow:false,
    categoryDialog:{ //规格选择，输入与输出
        // giftList:[
        //     {
        //         select:false,
        //         text: "还有赠品未选择，请选择赠品",
        //         nextAction: "领取赠品",
        //         gift_item_codes:"",//赠品编号
        //         gift_unit_codes:"",//赠品规格编号
        //     }
        // ],
        // show:false,//显示与否
        // goodsNum:"1",
        // requestCart:false,
        throught:false,
        makeGiftCodes:{
            ics:"",
            ucs:"",
            giftPromoNo:"",
        },
        // refreshCartNum:0,
    },
}

export default handleActions({

    //商品详情中所有的网络请求
    [actionTypes.FetchDataAction]:(state,action)=>{
        const {payload:{
            data
        }} = action

        switch (data.type)
        {

            default:
            {
                return{
                    ...state
                }
            }
        }

    },
    //促销
    // [actionTypes.PROMOTIONDIALOG]:(state,action)=>{
    //     return{
    //         ...state,
    //         promotionDialogShow:action.show,
    //     }
    // },
    //选择赠品
    // [actionTypes.GIFTPICKUPDIALOG]:(state,action)=>{
    //     Object.assign(state.giftPickUpDialogDatas,action.data);
    //     // console.log("aaaaaaaaa reducer gift:"+JSON.stringify(action.data));
    //     return state;
    // },
    //选择规格
    [actionTypes.CATEGORYDIALOG]:(state,action)=>{
        Object.assign(state.categoryDialog,action.data);
        // console.log("aaaaaaaaaa reducer category:"+JSON.stringify(action.data));
        return state;
    },

    // 规格显示
    // [actionTypes.CATEGORYSHOW]:(state,action)=>{
    //     return{
    //         ...state,
    //         categoryShow:action.show,
    //     }
    // },

    // 赠品显示
    // [actionTypes.GIFTSHOW]:(state,action)=>{
    //     return{
    //         ...state,
    //         giftshow:action.show,
    //     }
    // },


},userState)


