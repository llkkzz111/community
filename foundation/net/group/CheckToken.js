/**
 * Created by dhy on 2017/6/1.
 * 校验token
 * http://10.22.218.170:8080/cms/pages/relation/page?id=301
 */

import BaseRequest from '../BaseRequest';
export default class CheckToken extends BaseRequest{
    requestUrl(){
        return '/api/members/checking/token';
    }

}