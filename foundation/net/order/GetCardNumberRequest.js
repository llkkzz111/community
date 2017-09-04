/**
 * Created by zjz on 2017/8/16.
 * 添加意向订单
 */
import BaseRequest from '../BaseRequest';

export default class GetCardNumberRequest extends BaseRequest {
    requestUrl() {
        return '/api/orders/orders/addPrivateCardDetail';
    }
}