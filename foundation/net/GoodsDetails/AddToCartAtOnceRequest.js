/**
 * Created by wangwenliang on 2017/6/22.
 * 普通商品立即购买
 */
import BaseRequest from '../BaseRequest';
export default  class AddToCartAtOnceRequest extends BaseRequest {//post
    requestUrl() {
        return "/api/orders/carts/addToCart";
    }
}