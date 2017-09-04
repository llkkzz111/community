/**
 * Created by MASTERMIAO on 2017/6/19.
 * 领取抵用券请求
 */
'use strict';

import BaseRequest from '../../BaseRequest';

export default class ReceiveCouponRequest extends BaseRequest {
    requestUrl() {
        return '/api/finances/coupons/drawcoupon';
    }

    handleResponse(responseJson, successCallBack, failCallback) {
        super.handleResponse(responseJson, (responseJson) => {
            let response = {
                code: '',
                message: ''
            }
            if (responseJson && responseJson.data) {
                response.code = responseJson.code;
                response.message = responseJson.data.result
            }
            successCallBack(response);
        }, failCallback);
    }
}
