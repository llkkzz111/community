/**
 * Created by Zhangxc on 2017/5/26.
 * // 购物车 选择购物车商品接口(POST)
 */
import BaseRequest from '../BaseRequest';
export default class GetCartDataRequest extends BaseRequest{
    requestUrl(){
        return "/api/orders/carts/checkcartyn";
    }
}