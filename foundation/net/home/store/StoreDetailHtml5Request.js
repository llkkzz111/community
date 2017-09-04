/**
 * Created by MASTERMIAO on 2017/6/19.
 * 开启商城店铺Html5页面的网络请求
 */
'use strict';

import BaseRequest from '../../BaseRequest';

export default class StoreDetailHtml5Request extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/pageV1';
    }

    handleResponse(responseJson, successCallBack) {
        super.handleResponse(responseJson, (responseJson) => {
            let response = {
                destinationUrl: ''
            }
            if (responseJson && responseJson.data) {
                response.destinationUrl = responseJson.data.packageList[0].componentList[0].destinationUrl
            }
            successCallBack(response);
        });
    }
}








