/**
 * Created by dongfanggouwu-xiong on 2017/6/9.
 * 请求评价列表
 */
import BaseRequest from '../BaseRequest';
export default class GetInteractionsRequest extends BaseRequest{
    requestUrl(){
        return '/api/interactions/comments/pgetlist';
    }
}