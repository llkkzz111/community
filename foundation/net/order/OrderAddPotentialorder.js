/**
 * Created by jzz on 2017/7/8.
 * 添加意向订单
 */
import BaseRequest from '../BaseRequest';

export default class OrderAddPotentialorder extends BaseRequest {
    requestUrl() {
        return '/api/orders/potentialorders/add_potentialorder';
    }
}