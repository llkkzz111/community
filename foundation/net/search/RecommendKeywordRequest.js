/**
 * Created by Xiang on 2017/6/3.
 * 请求热门推荐
 */
import BaseRequest from '../../../foundation/net/BaseRequest';
export default class RecommendKeywordRequest extends BaseRequest {
    requestUrl() {
        return '/api/items/hot_word_recommend';
    }
}