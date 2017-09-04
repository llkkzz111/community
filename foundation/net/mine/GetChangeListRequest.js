/**
 * Created by dongfanggouwu-xiong on 2017/6/9.
 * 获取退换货列表
 */
import BaseRequest from '../BaseRequest';
export default class GetChangeListRequest extends BaseRequest{
    requestUrl(){
        return '/api/customerservice/itemreturn/list';
    }
}