/**
 * Created by luo xian on 17/6/8.
 * 小黑板列表加载更多
 */
import BaseRequest from '../BaseRequest';
export default class GetSmallBlackBoardDataPage extends BaseRequest {
    requestUrl(){
        return '/cms/pages/relation/nextPageV1';
    }
}
