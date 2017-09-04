/**
 * Created by jzz on 2017/8/18.
 * 获取活动浮层结果
 */
import BaseRequest from '../BaseRequest';

export default class GetAdResult extends BaseRequest {
    requestUrl() {
        return '/api/events/activitys/add_event_return_alert_msg';
    }
}