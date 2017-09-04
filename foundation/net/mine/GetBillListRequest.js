/**
 * Created by dongfanggouwu-xiong on 2017/6/9.
 * 获取发票列表
 */
import BaseRequest from '../BaseRequest';
export default class GetBillListRequest extends BaseRequest{
    requestUrl(){
        return '/api/orders/invoices/get_invoicelist';
    }
}