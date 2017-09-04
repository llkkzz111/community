/**
 * Created by wawngwenliang on 2017/6/2.
 * 收藏
 */

import BaseRequest from '../BaseRequest';
export default class GoodsSaveRequest extends BaseRequest{
    requestUrl(){
        return '/api/members/favorites/add_favorite';
    }
}
