/**
 * Created by jzz on 2017/7/8.
 * 更新意向订单
 */
import BaseRequest from '../BaseRequest';

export default class OrderUpdatePotentialorder extends BaseRequest {
    requestUrl() {
        return '/api/orders/potentialorders/update_potentialorder';
    }
}