/**
 * Created by admin-ocj on 2017/6/3.
 * 自动补全关键词列表请求
 */
import BaseRequest from '../../../foundation/net/BaseRequest';
export default class AutoWordListRequest extends BaseRequest {
    requestUrl() {
        return '/api/items/hot_word_search';
    }
}