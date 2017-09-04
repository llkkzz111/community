/**
 * Created by luo xian on 17/6/10.
 * 小黑板详情列表
 */
import BaseRequest from '../BaseRequest';
export default class GetSmallBlackBoardDetailsData extends BaseRequest{
    requestUrl(){
        return '/cms/pages/relation/pageV1';
    }

    /**
     * 处理response
     * @param responseJson
     * @param successCallBack
     */
    // handleResponse(responseJson, successCallBack) {
    //     super.handleResponse(responseJson,(responseJson)=>{
    //         let response = {
    //             textPic: [],//图文
    //             goodsList: [],//商品列表
    //         };
    //         if(responseJson && responseJson.data){
    //             let data = responseJson.data;
    //             if(data.packageList && data.packageList.length > 0){
    //                 let packageList = data.packageList ;
    //                 packageList.forEach((component,index)=>{
    //                     // 获取图文数据 packageId  = "48"
    //                     if (component && component.packageId === '48'){
    //                         response.textPic.push.apply(response.textPic,component.componentList);
    //                         // 获取数据 商品列表 packageId  = "50"
    //                     }else if(component && component.packageId === '50'){
    //                         response.goodsList.push.apply(response.goodsList,component.componentList[0].componentList);
    //                     }
    //                 })
    //             };
    //         };
    //         successCallBack(response);
    //     });
    // }
}