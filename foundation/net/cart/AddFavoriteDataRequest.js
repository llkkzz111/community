/**
 * Created by Zhangxc on 2017/5/26.
 * // 购物车
 */
import BaseRequest from '../BaseRequest';
export default class GetCartDataRequest extends BaseRequest{
    //购物车中移入收藏商品接口(POST)
    requestUrl(){
        return "/api/members/favorites/transfer_favorite";
    }
}