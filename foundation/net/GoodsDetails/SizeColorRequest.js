/**
 * Created by wangwenliang on 2017/8/15.
 * 商品的规格和颜色请求；
 * get请求
 *请求参数：
 * item_code:商品code；
 * IsNewSingle:是否是新版，新版Y，旧版N（下拉的方式选择颜色），在商品详情查询接口是会返回值;
 * lcode:省；
 * mcode:市
 * scode:县
 * ml_msale_gb:02是目录商品（书），03是网站商品
 *
 *
 *
 */

import BaseRequest from '../BaseRequest';
export default class SizeColorRequest extends BaseRequest{
    requestUrl(){
        return '/api/items/initcolorsize';
    }
}