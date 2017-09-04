/**
 * Created by wangwenliang on 2017/6/4.
 */
import BaseRequest from '../BaseRequest';
export default  class SingleOrderRequest extends BaseRequest { //get请求
    requestUrl() {
        return "/api/orders/orders/singleorderconfirm";
    }
}