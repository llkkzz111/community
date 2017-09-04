/**
 * Created by dongfanggouwu-xiong on 2017/6/1.
 * 获取订单详情接口
 */
import BaseRequest from '../BaseRequest';
export default class GetOderListDetailRequest extends BaseRequest{
    requestUrl(){
        return '/api/orders/orders/orderdetailnew';
    }
}