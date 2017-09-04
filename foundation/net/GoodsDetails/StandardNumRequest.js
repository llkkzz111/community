/**
 * Created by wangwenliang on 2017/6/4.
 * 商品规格
 */
import BaseRequest from '../BaseRequest';
export default  class StandardNumRequest extends BaseRequest {
    requestUrl() {
        return "/api/items/items/detailInstruction";
    }
}