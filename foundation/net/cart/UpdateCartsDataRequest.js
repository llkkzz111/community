/**
 * Created by Zhangxc on 2017/5/26.
 * //更新购物车接口(POST)
 */
import BaseRequest from '../BaseRequest';
export default class GetCartDataRequest extends BaseRequest {
    // getBaseUrl() {
    //     return 'http://10.23.19.178:9102';
    // }

    requestUrl() {
        return "/api/orders/carts/updateCarts";
        //return "/api/orders/carts/updateCart";
    }
}