/**
 * Created by YASIN on 2017/5/26.
 * // 获取个人中心首页 -- 用户信息及评价
 */
import BaseRequest from '../BaseRequest';
export default class UserInfoRequest extends BaseRequest{
    requestUrl(){
        return '/api/members/members/personal_evaluation';
    }
}