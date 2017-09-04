/**
 * Created by dhy on 2017/6/1.
 * TV团预告加载更多
 */
import BaseRequest from '../BaseRequest';
export default class TVGroupBuyRequest extends BaseRequest{
    requestUrl(){
        return '/cms/pages/relation/nextPageV1';
    }
}