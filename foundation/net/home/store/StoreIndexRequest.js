/**
 * Created by YASIN on 2017/6/6.
 * 商城首页请求
 */
import BaseRequest from '../../BaseRequest';

export default class StoreIndexRequest extends BaseRequest {
    requestUrl() {
        return '/cms/pages/relation/pageV1';
    }

    getDefaultCache() {
        return true;
    }

    handleResponse(responseJson, successCallBack) {
        super.handleResponse(responseJson, (responseJson) => {
            let response = {
                codeValue: '',
                pageVersionName:'',
                banners: [],
                hotDatas: [],
                coupons: [],
                wonderfulDatas: [],
                popularDatas: [],
                recommondDatas: [],
                wonderfulRecoDatas: [],
                brandStoreArray: [],
                wonderfulStoreArray: []
            };
            if (responseJson && responseJson.data) {
                response.codeValue = responseJson.data.codeValue;
                response.pageVersionName = responseJson.data.pageVersionName;

                let data = responseJson.data;
                if (data.packageList && data.packageList.length > 0) {
                    let packageList = data.packageList;
                    packageList.forEach((component, key)=> {
                        if (component && component.packageId === '2') {//获取banner数据packageId='2'
                            let currentBanners = [];
                            if (component.componentList !== null && component.componentList !== undefined && component.componentList.length > 0) {
                                for (let i = 0; i < component.componentList.length; i++) {
                                    currentBanners.push(component.componentList[i]);
                                }
                                response.banners = currentBanners;
                            }
                        } else if (component && component.packageId === '31') {//获取热门产品数据packageId='31'
                            if (component.componentList && component.componentList.length > 0
                                && component.componentList[0] !== null && component.componentList[0] !== undefined) {
                                let hotObject = [];
                                let array = component.componentList[0].componentList;
                                for (let i = 0; i < array.length; i++) {
                                    hotObject.push(array[i]);
                                }
                                response.hotDatas = hotObject;
                            }
                        } else if (component && component.packageId === '30') {//抵用券
                            if (component.componentList !== null && component.componentList !== undefined
                                && component.componentList.length > 0 && component.componentList[0] !== null
                                && component.componentList[0] !== undefined) {
                                let couponsArray = [];
                                let array = component.componentList[0].componentList;
                                if (array !== null && array !== undefined) {
                                    for (let i = 0; i < array.length; i++) {
                                        couponsArray.push(array[i]);
                                    }
                                }
                                response.coupons = couponsArray;
                            }
                        } else if (component && component.packageId === '14') {//精彩活动
                            if (component.componentList !== null && component.componentList !== undefined)
                                response.wonderfulDatas.push.apply(response.wonderfulDatas, component.componentList);
                        } else if (component && component.packageId === '112') {// 时尚大牌 && 优品推荐
                            if (packageList[5].componentList !== null && packageList[5].componentList !== undefined && key == 5) {
                                response.popularDatas = [];
                                let pArray = [];
                                let array = packageList[5].componentList.slice(2, packageList[5].componentList.length);
                                for (let i = 0;i< array.length; i++) {
                                    let cpl = array[i].componentList;
                                    for (let k = 0; k < cpl.length; k++) {
                                        pArray.push(cpl[k]);
                                    }
                                }
                                response.popularDatas = pArray;
                                response.brandStoreArray = packageList[5].componentList[1].componentList;
                            }
                            if (packageList[6].componentList !== null && packageList[6].componentList !== undefined && key == 6) {
                                response.wonderfulRecoDatas = [];
                                let wArray = [];
                                let array = packageList[6].componentList.slice(2, packageList[6].componentList.length);
                                for (let i = 0; i < array.length; i++) {
                                    let wpl = array[i].componentList;
                                    for (let j = 0; j < wpl.length; j++) {
                                        wArray.push(wpl[j]);
                                    }
                                }
                                response.wonderfulRecoDatas = wArray;
                                response.wonderfulStoreArray = packageList[6].componentList[1].componentList;
                            }
                        } else if (component && component.packageId === '76') {//好货推荐
                            if (component.componentList[1]&&component.componentList[1].id !== null && component.componentList[1].id !== undefined)
                                response.recommondQueryId = component.componentList[1].id;
                            if (component.componentList !== null && component.componentList !== undefined) {
                                let recommondObjects = [];
                                let array = component.componentList.slice(1, component.componentList.length);
                                for (let i = 0;i < array.length; i++) {
                                    let ppl = array[i].componentList;
                                    for (let q = 0; q < ppl.length; q++) {
                                        recommondObjects.push(ppl[q]);
                                    }
                                }
                                response.recommondDatas = recommondObjects;
                            }
                        }
                    });
                }
            }
            successCallBack(response);
        });
    }
}