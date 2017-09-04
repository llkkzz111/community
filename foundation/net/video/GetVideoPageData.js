/**
 * Created by 卓原 on 2017/6/8.
 * 看直播列表
 */
import BaseRequest from '../BaseRequest';
export default class GetVideoPageData extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/pageV1';
    }


}