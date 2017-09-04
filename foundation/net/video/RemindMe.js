/**
 * Created by 卓原 on 2017/6/8.
 * 提醒我通知订阅
 */
import BaseRequest from '../BaseRequest';
export default class RemindMe extends BaseRequest {
    requestUrl() {
        return '/cms/pages/videoMessage/insert';
    }

}