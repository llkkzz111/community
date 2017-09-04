
/**
 * Created by YASIN on 2017/5/26.
 * 获取个人中心首页 -- 查询物流信息
 */
import BaseRequest from '../BaseRequest';
export default class UserMaterialFlowRequest extends BaseRequest{
    requestUrl(){
        return '/api/orders/distributions/status';
    }
}