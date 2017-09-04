/**
 * Created by xiongmeng on 2017/5/1.
 * update by wangwenliang on 2017/5/20
 */
import * as actionTypes from '../actionTypes'
export const fetchDataCreate = (type, data) => {
    return {
        type: type,
        payload: {
            data
        }
    }
};

//商品详情中的 规格颜色 中的 赠品选择：非随箱赠品选择
// export const giftPickUpDialogDatas = (status) => {
//     // console.log("aaaaaaaaa action gift:"+JSON.stringify(status));
//     return{
//         type:actionTypes.GIFTPICKUPDIALOG,
//         // show:status.show,
//         // giftData:status.giftData,
//         data:status
//     }
// }
//商品详情中的 规格颜色
export const categoryDialogDatas = (status) => {
    // console.log("aaaaaaaaaaaaa  action category:"+JSON.stringify(status));
    return{
        type:actionTypes.CATEGORYDIALOG,
        data:status
    }
}

//商品详情中规格颜色的显示
// export const categoryShow = (status) => {
//     return{
//         type:actionTypes.CATEGORYSHOW,
//         show:status,
//     }
// }

//商品详情中非随箱赠品的显示
// export const giftShow = (status) => {
//     return{
//         type:actionTypes.GIFTSHOW,
//         show:status,
//     }
// }




