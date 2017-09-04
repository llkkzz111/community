/**
 * Created by wangwenliang on 2017/6/7.
 * 获取抵用券信息
 */
import BaseRequest from '../BaseRequest';
let itemCode;
export default  class VoucherRequest extends BaseRequest {

    setItemCode(code) {
        itemCode = code;
    }

    requestUrl() {
        return "/api/events/activitys/get_item_coupons/" + itemCode;
    }

}