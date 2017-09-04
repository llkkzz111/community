/**
 * Created by wangwenliang on 2017/8/3.
 * 获取发票管理中所有发票的列表，之前电子发票和纸质发票分别请求，现在合并到一起；
 * get请求；
 *
 * time	one 30天 two 60天 three 90天 six 180天 halfYearAgo 半年以前		是
 *pageNum	当前页数		是
 * pageSize	每页条数		是
 *
 */

import BaseRequest from '../BaseRequest';
export default class GetAllBillListRequest extends BaseRequest{
    requestUrl(){
        return '/api/orders/invoices/get_all';
    }
}
