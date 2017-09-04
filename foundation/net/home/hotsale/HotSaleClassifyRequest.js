/**
 * Created by YASIN on 2017/6/6.
 * 首页热销榜获取分类种类
 */
import BaseRequest from '../../BaseRequest';
export default class HotSaleClassifyRequest extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/pageV1';
    }
    getDefaultCache(){
        return true;
    }
    handleResponse(responseJson, successCallBack) {
        super.handleResponse(responseJson, (responseJson)=> {
            let response = {
                datas: [],
                classifyDatas: [],
                dataQueryId:-1,
            };

            if (responseJson && responseJson.data) {
                response.codeValue = responseJson.data.codeValue;
                response.pageVersionName = responseJson.data.pageVersionName;
                let data = responseJson.data;
                let packageList = data.packageList;
                if (packageList && packageList.length > 0) {
                    packageList.forEach((list, index)=> {
                        //所有分类 packageId==='88'
                        if (list.packageId === '88') {
                            if(list.componentList&&list.componentList.length>0){
                                if(list.componentList[0]&&list.componentList[0].componentList){
                                    list.componentList[0].componentList.forEach((item,index)=>{
                                        item.selectedClass='item'+index;
                                        response.classifyDatas.push(item);
                                    });
                                    response.classifyDatas.push({destinationUrl:'all',title:'全部商品',selectedClass:'all'})
                                }
                            }
                            //商品列表
                        } else if (list.packageId === '72') {
                            if (list.componentList && list.componentList.length > 0) {
                                list.componentList.forEach((list, index)=> {
                                    if(list.id)response.dataQueryId=list.id;
                                    if (list.componentList && list.componentList.length > 0) {
                                        response.datas.push.apply(response.datas, list.componentList);
                                    }
                                })
                            }
                        }
                    });
                }
            }
            successCallBack(response);
        });
    }
}
