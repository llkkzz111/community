/**
 * Created by Xiang on 2017/6/9.
 *分类频道页首屏数据
 */
import BaseRequest from '../../net/BaseRequest'
export default class ClassificationChannelRequest extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/pageV1';
    }
}
