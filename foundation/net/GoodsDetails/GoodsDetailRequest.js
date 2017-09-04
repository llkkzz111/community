/**
 * Created by wangwenliang on 2017/6/4.
 * 获取商品详情
 */
import BaseRequest from '../BaseRequest';
let itemCode;
export default  class GoodsDetailRequest extends BaseRequest {
    setItemCode(code) {
        itemCode = code;
    }

    requestUrl() {
        return "/api/items/items/appdetail/" + itemCode;
    }
}