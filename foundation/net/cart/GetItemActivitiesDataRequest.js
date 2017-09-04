/**
 * Created by Zhangxc on 2017/5/26.
 * //根据商品获取相关的活动促销(赠品列表获取)
 */
import BaseRequest from '../BaseRequest';
export default class GetCartDataRequest extends BaseRequest{
    requestUrl(){
        return "/api/events/activitys/get_item_events/";
    }
}