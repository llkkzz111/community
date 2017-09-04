/**
 * Created by lume on 2017/6/1.
 * 删除收藏
 */

import BaseRequest from '../BaseRequest';
export default class DelectFavoriteRequest extends BaseRequest{
    requestUrl(){
        return '/api/members/favorites/delete_favorite';
    }
}