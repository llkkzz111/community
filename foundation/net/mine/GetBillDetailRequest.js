/**
 * Created by dongfanggouwu-xiong on 2017/6/25.
 * 查看发票详情
 */
import BaseRequest from '../BaseRequest';
export default class GetBillDetailRequest extends BaseRequest{
    requestUrl(){
        return '/api/orders/invoices/get_invoicedetail';
    }
}