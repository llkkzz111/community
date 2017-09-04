/**
 * Created by luo xian on 17/6/8.
 * 小黑板列表
 */
import BaseRequest from '../BaseRequest';
export default class GetSmallBlackBoardData extends BaseRequest {
    requestUrl(){
        return '/cms/pages/relation/pageV1';
    }
    /**
     * 处理response
     * @param responseJson
     * @param successCallBack
     */
    handleResponse(responseJson, successCallBack) {
        super.handleResponse(responseJson, (responseJson)=> {
            let responseList = {
                tabList: [],//tab列表
                itemList: [],//item列表
                componentList: ''
            };
            if (responseJson && responseJson.data) {
                let data = responseJson.data;
                if (data.packageList && data.packageList.length > 0) {
                    let packageList = data.packageList;
                    packageList.forEach((component, index)=> {
                        // 获取tab列表数据 packageId  = "12"
                        if (component && component.packageId === '12') {
                            responseList.tabList.push.apply(responseList.tabList, component.componentList);
                            // 获取数据 item列表 packageId  = "21"
                        } else if (component && component.packageId === '21') {
                            // 获取tab数据id
                            responseList.componentList = `${component.componentList[0].id}`;
                            responseList.itemList.push.apply(responseList.itemList, component.componentList[0].componentList);
                        }
                    })
                    responseList.codeValue = responseJson.data.codeValue;
                    responseList.pageVersionName = responseJson.data.pageVersionName;
                };
            };
            successCallBack(responseList);
        });
    }
}
