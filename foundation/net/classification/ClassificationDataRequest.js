/**
 * Created by Xiang on 2017/6/5.
 * 分类列表数据
 */
import BaseRequest from '../BaseRequest';
export default class ClassificationDataRequest extends BaseRequest {
    requestUrl() {
        return '/api/items/newLeftnav';
    }
}