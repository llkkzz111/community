/**
 * Created by YASIN on 2017/5/26.
 * 获取个人中心首页 -- 用户行为浏览记录
 */
import BaseRequest from '../BaseRequest';
export default class UserFootRequest extends BaseRequest{
    requestUrl(){
        return '/api/members/userfootprints/get';
    }
}