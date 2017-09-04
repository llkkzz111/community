/**
 * Created by MASTERMIAO on 2017/6/18.
 * 商城店铺网络接口定义
 */
'use strict';

import BaseRequest from '../../BaseRequest';

export default class StoreDetailRequest extends BaseRequest {
    requestUrl() {
        return '';
    }

    handleResponse(responseJson, successCallBack) {
        super.handleResponse(responseJson, (responseJson) => {




            successCallBack(responseJson);
        });
    }
}










