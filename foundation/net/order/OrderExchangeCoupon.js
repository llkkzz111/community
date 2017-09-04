/**
 * Created by jzz on 2017/6/19.
 * 兑换抵用券
 */

import BaseRequest from '../BaseRequest';

export default class OrderExchangeCouponRequest extends BaseRequest {
    requestUrl() {
        return '/api/orders/orders/exchangeExtranalConpon';
    }
}