/**
 * Created by xiang on 2017/8/1.
 * 价格查询接口(POST)，获取价格和抵用券数据
 */
import BaseRequest from '../BaseRequest';
export default class CalculatePriceRequest extends BaseRequest {
    // Boby里面的参数:
    //     {
    //         "cart_seqs":"10,9,8,7,6,5,4,3,2,1"
    //     }

    requestUrl() {
        return "/api/orders/prices/calculate_price";
    }
}