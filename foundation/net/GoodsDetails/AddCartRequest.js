/**
 * Created by wangwenliang on 2017/6/2.
 * 加入购物车
 */
import BaseRequest from '../BaseRequest';
export default  class AddCartRequest extends BaseRequest {
    requestUrl() {
        return "/api/orders/carts/detailItemToCart";
    }
}