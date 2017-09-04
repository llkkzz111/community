/**
 * Created by 路卫国 on 2017/5/31.
 * 签到接口
 */
import BaseRequest from '../BaseRequest';
export default class UserSignRequest extends BaseRequest{
    requestUrl(){
        return '/api/members/opoints/check_in';
    }
}