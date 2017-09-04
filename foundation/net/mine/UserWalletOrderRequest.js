/**
 * Created by YASIN on 2017/5/26.
 * // 获取个人中心首页 -- 钱包与订单信息
 */
import BaseRequest from '../BaseRequest';
export default class UserWalletOrderRequest extends BaseRequest{
    requestUrl(){
        return '/api/members/members/order_wallet';
    }
}