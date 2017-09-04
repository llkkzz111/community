/**
 * Created by jzz on 2017/8/18.
 * 获取活动浮层小图标
 */
import BaseRequest from '../BaseRequest';

export default class GetAdShowType extends BaseRequest {
    requestUrl() {
        return '/api/events/activitys/get_event_alert';
    }
}
