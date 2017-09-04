/**
 * Created by Xiang  on 2017/6/12.
 * 分类频道下方栏目切换数据（热门，养生，保健）
 */
import BaseRequest from '../../net/BaseRequest'
export default class ClassificationChannelListRequest extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/nextPageV1';
    }
}
