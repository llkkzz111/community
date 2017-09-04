/**
 * Created by Zhangxc on 2017/5/26.
 * //根据多个商品获取相关券列表接口(POST)
 */
import BaseRequest from '../BaseRequest';
export default class GetItemsCoupons extends BaseRequest {
    requestUrl() {
        return "/api/events/activitys/get_items_coupons";
    }
}