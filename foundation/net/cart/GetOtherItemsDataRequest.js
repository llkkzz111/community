/**
 * Created by Zhangxc on 2017/5/26.
 * //购物车同品推荐接口(POST)
 */
import BaseRequest from '../BaseRequest';
export default class GetCartDataRequest extends BaseRequest{
    requestUrl(){
        return "/api/items/other-items";
    }
}