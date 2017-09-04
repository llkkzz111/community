/**
 * Created by Zhangxc on 2017/5/26.
 * //根据商品获取颜色规格(购物车)
 */
import BaseRequest from '../BaseRequest';
export default class GetCartDataRequest extends BaseRequest{
    requestUrl(){
        return "/api/items/initcolorsize";
    }
}