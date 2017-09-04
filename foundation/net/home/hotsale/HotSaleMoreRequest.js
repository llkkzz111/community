/**
 * Created by YASIN on 2017/6/6.
 * 热销榜加载更多请求
 */
import BaseRequest from '../../BaseRequest';
export default class HotSaleMoreRequest extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/nextPageV1';
    }
    getDefaultCache(){
        return true;
    }

    handleResponse(responseJson, successCallBack) {
        super.handleResponse(responseJson, (responseJson)=> {
            let response = {
                datas: [],
                totalPage: 0
            };
            if (responseJson && responseJson.data) {
                let data = responseJson.data;
                //获取所有数据
                if (data.list && data.list.length > 0) {
                    response.datas.push.apply(response.datas, data.list);
                }
                //获取总页数
                if (data.total) {
                    response.totalPage = data.total;
                }
            }
            successCallBack(response);
        });
    }
}
