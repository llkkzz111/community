/**
 * Created by 路卫国 on 2017/5/31.
 * 获取收藏商品 URL 请求
 */
import BaseRequest from '../BaseRequest';
export default class UserFavoriteRequest extends BaseRequest{
    requestUrl(){
        return '/api/members/favorites/show_favorite';
    }
}