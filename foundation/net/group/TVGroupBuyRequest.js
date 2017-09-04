/**
 * Created by dhy on 2017/6/1.
 * TV团列表页
 */
import BaseRequest from '../BaseRequest';
export default class TVGroupBuyMore extends BaseRequest{
    requestUrl(){
        return '/cms/pages/relation/pageV1';
    }
    getDefaultCache() {
        return true;
    }
    // getDefaultTestingTime() {
    //     return true;
    // }
}
