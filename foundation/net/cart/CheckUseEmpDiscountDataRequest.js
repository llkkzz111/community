/**
 * Created by Zhangxc on 2017/5/26.
 * 校验是否使用员工折扣以及校验商品是否满足下单要求
 */
import BaseRequest from '../BaseRequest';
export default class GetCartDataRequest extends BaseRequest{
    requestUrl(){
        return "/api/orders/orders/checkUseEmpDiscount";
    }
}