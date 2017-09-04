/**
 * Created by xiang on 2017/6/3.
 * 请求搜索列表
 */
import BaseRequest from '../../../foundation/net/BaseRequest';
export default class SearchProductListRequest extends BaseRequest {
    requestUrl() {
        return '/api/search/search_center';
    }
}