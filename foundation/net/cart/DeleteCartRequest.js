/**
 * Created by Zhangxc on 2017/5/26.
 * //删除购物车接口(POST)
 */
import BaseRequest from '../BaseRequest';
export default class GetCartDataRequest extends BaseRequest{
    requestUrl(){
        return "/api/orders/carts/removeToCart";
    }

}