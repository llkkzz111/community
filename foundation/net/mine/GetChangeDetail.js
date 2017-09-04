/**
 * Created by dongfanggouwu-xiong on 2017/6/7.
 * 获取退换货详情
 */
import BaseRequest from '../BaseRequest';
export default class GetChangeDetail extends BaseRequest {
    requestUrl() {
        return '/api/customerservice/itemreturn/detail';
    }

    handleResponse(responseJson, successCallBack, failCallBack) {
        super.handleResponse(responseJson, (response) => {
            let datas = {
                stepDatas: [],//步骤数据
                baseInfo: {},//基本信息
                goodsInfo: [],//物品信息
                returnFlag: '',//退换货标记
            }
            if (response && response.data) {
                let data = response.data;
                if (data.returnFlag) datas.returnFlag = data.returnFlag;
                //基本信息
                if (data.reason) datas.baseInfo.reason = data.reason;
                if (data.return_amt) datas.baseInfo.return_amt = data.return_amt;
                if (data.apply_date) datas.baseInfo.apply_date = data.apply_date;
                if (data.statusTime) datas.baseInfo.statusTime = data.statusTime;
                if (data.status) datas.baseInfo.status = data.status;
                //步骤数据
                if (data.flow && data.flow.length > 0) datas.stepDatas = data.flow;
                //物品信息
                if (data.items && data.items.length > 0) datas.goodsInfo = data.items;
            }
            successCallBack(datas);
        }, failCallBack);
    }
}