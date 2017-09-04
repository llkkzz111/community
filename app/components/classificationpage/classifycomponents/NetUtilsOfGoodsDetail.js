/**
 * Created by wangwenliang on 2017/8/15.
 * 提取商品详情中用到的网络请求方法
 */
import SizeColorRequest from '../../../../foundation/net/GoodsDetails/SizeColorRequest';



/**
 * 商品详情中
 * @param method 请求类型 get请求
 * @param body  请求参数
 * @param successCallBack 成功回调
 * @param failCallBack 失败回调
 */
export function getGoodsSizeColorRequest(method:String,body:Object,successCallBack,failCallBack) {

    if (this.gscReq) {
        this.gscReq.setCancled(true);
    }
    this.gscReq = new SizeColorRequest(body,method);
    this.gscReq.start((response) => {
        if (response.code && response.code === 200 && response.message && response.message === "succeed") {//成功
            if (response.data){
                successCallBack(response.data);
            }

        } else {//异常
            failCallBack(response);
        }
    },(err) => {//错误
        failCallBack(err);
    });
}