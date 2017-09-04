/**
 * Created by wangwenliang on 2017/6/2.
 * 跳转到H5东东客服
 */
import BaseRequest from '../BaseRequest';
export default class KeFuRequest extends BaseRequest{
    requestUrl(){
        return '/api/customerservice/getPopIccUrl';
    }
}