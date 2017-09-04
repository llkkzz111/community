/**
 * Created by dongfanggouwu-xiong on 2017/5/9.
 */
import React, {Component} from 'react';
import {Text, TextInput, View, StyleSheet, Alert} from 'react-native';
import SHA1 from 'jssha';
import * as Consts from '../../app/constants/Constants'
import Immutable from 'immutable';
const delay = (ms) => {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            reject(new Error('请求超时!'))
        }, ms)
    })
}
const fetchWithTimeout = (timeout, ...args) => { // race并行执行多个promise，结果由最先结束的Promise决定
    return Promise.race([fetch(...args), delay(timeout)])
}
const fetchWithTimeoutWithResolveResult = (timeout, URL, args, successCallback, failCallback) => { // race并行执行多个promise，结果由最先结束的Promise决定
    if (!successCallback || !failCallback) {
        // alert('调用fetchWithTimeoutWithResolveResult方法必须传入successCallback,failCallback');
        return;
    }
    //对args添加默认值
    if (!args.method) {
        args.method = 'POST';
    }
    if (!args.headers) {
        args.headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
        };
    }
    if (!args.mode) {
        args.mode = 'cors';
    }
    Promise.race([fetch(URL, args), delay(timeout)])
        .then((response) => {
            // console.log(response);
            return NetworkInterface.ResolveStatusResult(response);
        })
        .then((result) => {
            NetworkInterface.ResolveQueryResult(result, successCallback);
            // console.log('**********'+result)
        })
        .catch((error) => {
            // console.log(error);
            NetworkInterface.ResolveErrorObject(error, failCallback);
        });
}
export default class NetworkInterface {
    constructor() {
    }

    //处理逻辑错误
    static ResolveQueryResult(result, successCallback) {
        // console.log('Result:\n' + result);
        /*try {
         //JSON.parse()方法转换的时候要求必须是双引号
         result = JSON.parse(result);
         }
         catch (ex) {
         'JsonError', {json: JSON.stringify(result)};
         throw Error(ex.message);
         }*/
        /* let resultKey=false;
         if(result.hasOwnProperty('Success'))
         {
         if(result.Success==false) {
         result.message = result.Message?result.Message:'未知exception,请联系管理员!';
         ('ExceptionError', {json: JSON.stringify(result)});
         resultKey = false;
         }
         //说明没问题
         else
         {
         resultKey = true;
         }
         }
         //返回的数据格式有问题
         else
         {
         resultKey= false;
         }
         if(resultKey==true) {
         //只需要显示Result部分
         result = result.Result+'';
         if (successCallback) {
         successCallback(JSON.parse(result));
         }
         return result;
         }
         else
         {
         throw Error(result.message);
         }*/
        if (successCallback) {
            successCallback(JSON.parse(result));
        }
        return result;
    }

    static ResolveStatusResult(response) {
        //console.log('Result:\n'+response.text().toString());
        let resultKey = false;
        if (response.status) {
            //目前暂未知2XX之外的有没有正确的状态吗
            if (response.status < 200 || response.status >= 300) {
                let message;
                switch (response.status) {
                    case 500:
                        message = '服务器错误';
                        break;
                    default:
                        message = response.statusText;
                        break;
                }
                if (message == null || message == '') {
                    message = '没有错误信息,未知错误!';
                }
                response.message = message;
                resultKey = false;
            }
            else {
                //2XX的目前都认为是正确的
                resultKey = true
            }
        }
        //没有状态码的就很奇怪了
        else {
            response.message = '没有状态码,未知错误!';
            resultKey = false;
        }
        if (resultKey == true) {
            return response.text();
        }
        else {
            throw  Error(response.message);
        }
    }

    static timeoutShort = 120000;
    static timeoutLong = 120000;
    //处理抛出的异常
    static ResolveErrorObject(error, failCallback) {
        if (failCallback) {
            failCallback(error);
        }
        // console.log("ResolveErrorObject error:", error);
        if (error.message === 'Network request failed') {
            error.message = '网络连接异常,请检查网络设置';
        }
        /*Alert.alert('提示', error.message, [
         {text: '确定'}
         ]);*/
    }

    /**
     * 查询购物车接口(POST)
     */
    static getCart(data, successCallback, failCallback) {
        let url = "/api/orders/carts/getToPageDetail"
        //header部信息
        let headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-access-token': data.visitor_token,
        };
        //body部信息
        let dict = {
            area_mgroup: ''
        }
        //发送请求
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            body: JSON.stringify(dict),
            headers: headers
        }, successCallback, failCallback);
    }

    /**
     * 加入购物车接口(POST)
     */
    static addCart(data, successCallback, failCallback) {
        let url = "/api/orders/carts/detailItemToCart"
        let dict = {
            access_token: data.visitor_token,
            Item_code: "4254432014",
            num: "2",
            unit_code: "001",
            source_url: "",
            Shop_no: ""
        }
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            body: JSON.stringify(dict)
        }, successCallback, failCallback);
    }


    /**
     * 获取购物总数接口(POST)
     */
    static getCartNumber(data, successCallback, failCallback) {
        let url = "/api/orders/carts/getCartsCount";
        let dict = {
            access_token: data.visitor_token
        }
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            body: JSON.stringify(dict)
        }, successCallback, failCallback);
    }

    /**
     * 根据规则计算购物车中的商品价格接口(POST)
     */
    static CalculatePriceCommodities(data, successCallback, failCallback) {
        let url = "/api/orders/prices/calculate_price"
        let dict = {
            access_token: data.visitor_token
        }
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            body: JSON.stringify(dict)
        }, successCallback, failCallback);
    }


    /**
     * 预约订单写入接口函数定义  （不包含地址、发票）TODO
     * @param data
     * @param successCallback
     * @param failCallback
     */
    static orderCreateWithoutAddressAndInvoice(data, successCallback, failCallback) {
        let url = "/api/orders/advanceorders/create_advance_order"
        let dict = {}
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            body: JSON.stringify(dict)
        }, successCallback, failCallback);
    }

    /**
     * 订单写入接口函数定义  （包含地址、发票）TODO
     * @param data
     * @param successCallback
     * @param failCallback
     */
    static orderCreateWithAddressAndInvoice(data, successCallback, failCallback) {
        let url = "/api/orders/orders/create_order"
        let dict = {}
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            body: JSON.stringify(dict)
        }, successCallback, failCallback);
    }


    /**
     * 修改收货人信息接口函数定义
     * @param data
     * @param successCallback
     * @param failCallback
     */
    static modifyConsigneeInformation(data, successCallback, failCallback) {
        // const formData = new FormData();
        // formData.append("path", "/api/orders/receivers/update_receiver");
        // formData.append("postData", JSON.stringify({
        //     access_token: "",
        //     receiver_name: "", // 收货人姓名
        //     receiver:  {
        //         id: '2563366',
        //         address_type: 'company',
        //         province: '江苏省',
        //         city: '启东市',
        //         area: 'ss区',
        //         desc: '某某街道4号',
        //         person: '张三',
        //         tel: '0512-5663236',
        //         mobile: '13666666666'
        //     }
        // }));
        let url = "/api/orders/receivers/update_receiver"
        let dict = {};
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            body: JSON.stringify(dict)
        }, successCallback, failCallback);
    }

    /**
     * 新增订单发票接口函数定义
     * @param data
     * @param successCallback
     * @param failCallback
     */
    static addInvoice(data, successCallback, failCallback) {
        // const formData = new FormData();
        // formData.append("path", "/api/orders/invoices/add_invoice");
        // formData.append("postData", JSON.stringify({
        //     access_token: "",
        //     texbill_name: "",
        //     invoice_type: "",
        //     invoice_taitou: "",
        //     phone_invoice: "",
        //     email_invoice: "",
        //     receiver_seq: ""
        // }));
        let url = "/api/orders/invoices/add_invoice";
        let dict = {};
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            body: JSON.stringify(dict)
        }, successCallback, failCallback);
    }


    /**
     * 支付策略计算接口函数定义
     * @param data
     * @param successCallback
     * @param failCallback
     */
    static paymentPolicyCalculation(data, successCallback, failCallback) {
        // const formData = new FormData();
        // formData.append("path", "/api/orders/order_getpaygate");
        // formData.append("postData", JSON.stringify({
        //     access_token: "",
        //     items: {
        //         "":　122336, "": 96666, "": 77745
        //     } // 订单号
        // }));
        let url = "/api/orders/order_getpaygate";
        let dict = {};
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            body: JSON.stringify(dict)
        }, successCallback, failCallback);
    }


    /**
     * 获取 （ 物流查询 ）
     * author lu weiguo
     * @param data
     * @param successCallback
     * @param failCallback
     */
    static logistics(data, successCallback, failCallback) {
        let url = "/api/orders/distributions/status";
        let method = "GET"
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, url + "?access_token=" + data.access_token, {
            method
        }, successCallback, failCallback);
    }


    /*
     *热词推荐接口
     */
    static hotWordSearch(data, successCallback, failCallback) {
        let url = "/api/items/hot_word_search?key_word=" + data.keyWord;
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            method: 'GET',
        }, successCallback, failCallback);
    }

    /*
     *热词推荐接口
     */
    static hotWordRecommend(data, successCallback, failCallback) {
        let url = "/api/items/hot_word_recommend";
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, Consts.ServiceAddress + url, {
            method: 'GET',
        }, successCallback, failCallback);
    }


    /*
     *搜索
     */
    static searchResult(data, successCallback, failCallback) {
        //let url = "/api/items/search/searchresult";
        //先用搜索平台接口,该接口为线上使用的接口,这里是测试服务器地址
        let url = "http://10.22.218.103:8280/hs-wbw-web/searchM?searchItem=" + data.searchItem;
        //fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong,Consts.ServiceAddress + url,{
        fetchWithTimeoutWithResolveResult(NetworkInterface.timeoutLong, url, {
            method: 'GET',
        }, successCallback, failCallback);
    }

}