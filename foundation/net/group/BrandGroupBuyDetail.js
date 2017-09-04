/**
 * Created by dhy on 2017/6/1.
 * 品牌团详情
 * http://10.22.218.170:8080/cms/pages/relation/page?id=301
 */

import BaseRequest from '../BaseRequest';
export default class BrandGroupBuyDetail extends BaseRequest {
    requestUrl() {
        return '/api/items/otuan/brand/detail';
    }
}