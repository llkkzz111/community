/**
 * Created by wangwenliang on 2017/6/4.
 * 请求评价列表
 */
import BaseRequest from '../BaseRequest';
export default class EvaluateAllRequest extends BaseRequest {

    requestUrl() {
        return "/api/interactions/comments/list";
    }
}