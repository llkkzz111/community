/**
 * Created by 卓原 on 2017/5/31.
 * 首页数据
 */
import BaseRequest from '../BaseRequest';
export default class GetHomeData extends BaseRequest {
    getDefaultCache(){
        return false;
    }
    requestUrl() {
        return '/cms/pages/relation/pageV1';
    }
}