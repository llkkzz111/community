/**
 * Created by dongfanggouwu-xiong on 2017/6/7.
 * 获取物流详情
 */
import BaseRequest from '../BaseRequest';
export default class GetLogisticsDetail extends BaseRequest {
    requestUrl() {
        return '/api/orders/orders/orderLogistics';
    }

    handleResponse(responseJson, successCallBack, failCallBack) {
        super.handleResponse(responseJson, () => {
            let datas = {
                logistics:[],
                statusData:null,
                deliverData:null,
            };
            if (responseJson.data && responseJson.data.orderlogistics) {
                let realKey = null;
                let orderlogistics = responseJson.data.orderlogistics;
                for (let key in orderlogistics) {
                    if (realKey === null && key && key !== null) {
                        realKey = key
                        break;
                    }
                }
                if (realKey && realKey !== null) {
                    let arrays = orderlogistics[realKey];
                    if (arrays && arrays.length > 0) {
                        datas.logistics = arrays;
                    }
                }
            }
            successCallBack(datas);
        }, failCallBack);
    }
}