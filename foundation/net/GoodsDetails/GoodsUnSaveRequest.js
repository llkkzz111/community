/**
 * Created by wangwenliang on 2017/6/2.
 * 取消收藏
 */
import BaseRequest from '../BaseRequest';
export default class GoodsUnSaveRequest extends BaseRequest{
    requestUrl(){
        return '/api/members/favorites/delete_favorite';
    }
}