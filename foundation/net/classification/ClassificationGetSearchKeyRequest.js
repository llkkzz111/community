/**
 * Created by Administrator on 2017/6/30.
 * 分类搜索提示
 */
import BaseRequest from '../BaseRequest';
export default class ClassificationGetSearchKeyRequest extends BaseRequest {
    requestUrl() {
        return '/api/items/getDefaultValue';
    }
}