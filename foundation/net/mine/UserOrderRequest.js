/**
 * Created by lume on 2017/6/26.
 * // 获取个人中心首页 -- 物流信息
 */
import BaseRequest from '../BaseRequest';
export default class UserOrderRequest extends BaseRequest{
    requestUrl(){
        return '/api/orders/orders/recentOrdersLogistics';
    }
}