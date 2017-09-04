/**
 * Created by dongfanggouwu-xiong on 2017/5/27.
 * 获取订单列表
 */
import BaseRequest from '../BaseRequest';
export default class GetOderListRequest extends BaseRequest{
    requestUrl(){
        return '/api/orders/orders/orderlist_new';
    }
}