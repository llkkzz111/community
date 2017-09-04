/**
 * Created by lume on 2017/6/13.
 * 今日团头部标签列表加载更多
 */
import BaseRequest from '../../BaseRequest';
export default class RecommendRequest extends BaseRequest{
    requestUrl(){
        return "/cms/pages/relation/nextPageV1";
    }
}