/**
 * Created by YASIN on 2017/6/6.
 * 商城店铺优品推荐列表接口
 */
import BaseRequest from '../../BaseRequest';

export default class StoreListRequest extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/pageV1';
    }
    handleResponse(responseJson, successCallBack) {
        super.handleResponse(responseJson, (responseJson)=> {
            let response = {
                datas: [],
                dataQueryId: -1,
            };
            if (responseJson && responseJson.data) {
                let data = responseJson.data;
                let packageList = data.packageList;
                if (packageList && packageList.length > 0) {
                    let package1 = packageList[0];
                    let componentList = package1.componentList;
                    if (componentList && componentList.length > 0) {
                        let package2 = componentList[0];
                        if (package2.componentList && package2.componentList.length > 0) {
                            response.dataQueryId = package2.id;
                            response.datas.push(...package2.componentList);
                        }
                    }
                }
            }
            successCallBack(response);
        });
    }
}