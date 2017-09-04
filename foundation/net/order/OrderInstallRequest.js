/**
 * Created by zjz on 2017/8/16.
 * 申请安装
 */
import BaseRequest from '../BaseRequest';

export default class OrderInstallRequest extends BaseRequest {
    requestUrl() {
        return '/api/customerservice/sr/application';
    }
}