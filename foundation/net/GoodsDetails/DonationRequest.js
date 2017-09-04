/**
 * Created by wangwenliang on 2017/6/4.
 * 请求 非随箱赠品数据
 */
import BaseRequest from '../BaseRequest';
let itemCode;
export default  class DonationRequest extends BaseRequest { //get请求
    setItemCode(code) {
        itemCode = code;
    }

    requestUrl() {
        return "/api/events/activitys/get_item_events/" + itemCode;
    }

}

