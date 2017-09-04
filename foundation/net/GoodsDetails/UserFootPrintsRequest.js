/**
 * Created by wangwenliang on 2017/6/18.
 * 用户行为记录接口
 * 记录用户商品足迹
 */
import BaseRequest from '../BaseRequest';
export default  class UserFootPrintsRequest extends BaseRequest {
    requestUrl() {
        return "/api/members/userfootprints/add";
    }
}

