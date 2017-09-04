/**
 * Created by jzz on 2017/8/17.
 * 看直播 小黑板  个人中心活动浮层
 */
import BaseRequest from '../BaseRequest';

export default class AdFloatingLayerRequest extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/pageV1';
    }
}

/**
 *
 * data:[
 *  {
 *      small_picture: '',// 小图
 *      Big_picture: '', // 大图
 *      event_no: '',   // 活动编号
 *      content: '',    // 内容
 *      current_date: '',   // 当前日期
 *      end_date: '',   // 结束时间
 *      event_name: '', // 活动名称
 *      open_state: '', // 浮层显示的开关 Y N
 *  }
 * ]
 */
