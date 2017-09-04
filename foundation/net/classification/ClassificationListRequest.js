/**
 * Created by Xiang on 2017/6/7.
 * 分类三级列表页
 */
import BaseRequest from '../../../foundation/net/BaseRequest';
let shopCode;
let itemCode;
export default class ClassificationListRequest extends BaseRequest {
    requestUrl() {
        // if (shopCode) {
        //     return '/api/items/items/show/' + shopCode + '/' + itemCode;
        // } else {
            return '/api/items/items/'+itemCode;
        // }
    }

    setItemCode(shop, item) {
        shopCode = shop;
        itemCode = item;
    }
}