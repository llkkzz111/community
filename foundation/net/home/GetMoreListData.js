/**
 * Created by 卓原 on 2017/5/31.
 * 首页加载更多
 */
import BaseRequest from '../BaseRequest';
export default class GetMoreListData extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/nextPageV1';
    }

}