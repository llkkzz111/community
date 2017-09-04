/**
 * Created by dhy on 2017/6/1.
 * 品牌团
 */

import BaseRequest from '../BaseRequest';
export default class BrandGroupRequest extends BaseRequest{
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