/**
 * Created by wangwenliang on 2017/6/11.
 *
 * 领取抵用券
 *
 */

import BaseRequest from '../BaseRequest';
export default  class GetVoucherRequest extends BaseRequest {//post
    requestUrl() {
        return "/api/finances/coupons/drawcoupon";
    }
}