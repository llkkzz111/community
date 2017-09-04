/**
 * Created by dongfanggouwu-xiong on 2017/7/9.
 * 查看发票详情
 */
import BaseRequest from '../BaseRequest';
export default class GetElectronBill extends BaseRequest{
    requestUrl(){
        return '/api/orders/invoices/get_invoicedetail';
    }
}