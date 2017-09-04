/**
 * Created by wangwenliang on 2017/6/2.
 * 购物车总数
 */
import BaseRequest from '../BaseRequest';
export default class CartNumRequest extends BaseRequest {
    requestUrl() {
        return '/api/orders/carts/getCartsCount';
    }
}