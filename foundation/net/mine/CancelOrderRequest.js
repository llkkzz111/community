/**
 * Created by dongfanggouwu-xiong on 2017/6/2.
 */
import BaseRequest from '../BaseRequest';
export default class CancelOrderRequest extends BaseRequest{
    requestUrl(){
        return '/api/orders/advanceorders/cancel_advance_order';
    }
}