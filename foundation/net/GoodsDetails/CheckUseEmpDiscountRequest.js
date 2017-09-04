/**
 * Created by wangwenliang on 2017/6/9.
 * 判断是否是内部员工
 */
import BaseRequest from '../BaseRequest';
export default class CheckUseEmpDiscountRequest extends BaseRequest {
    requestUrl() {
        return '/api/orders/orders/checkUseEmpDiscount';
    }
}