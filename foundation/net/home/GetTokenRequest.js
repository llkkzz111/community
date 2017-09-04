/**
 * Created by lume on 2017/6/4.
 * 首页检查token
 */
import BaseRequest from '../BaseRequest';
export default class TextRequest extends BaseRequest{
    requestUrl(){
        return '/api/members/loginrules/login_by_visit';
    }
}