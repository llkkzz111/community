/**
 * Created by wangwenliang on 2017/6/12.
 * get请求
 * 商品详情中的 配送时效
 */
import BaseRequest from '../BaseRequest';
export default  class SendGoodsTime extends BaseRequest {
    requestUrl() {
        return "/api/orders/stock/getappointmentstock";
    }
}


