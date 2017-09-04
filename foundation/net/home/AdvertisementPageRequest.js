/**
 * Created by wangwenliang on 2017/7/26.
 * 首页广告页网络请求
 */
import BaseRequest from '../BaseRequest';
export default class AdvertisementPageRequest extends BaseRequest {
    getDefaultCache(){
        return true;
    }
    requestUrl() {
        return '/cms/pages/relation/pageV1';
    }
}