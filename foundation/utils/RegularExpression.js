/**
* @file 正则表达式
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
import { is } from 'immutable';
/*
* @classdesc
* 正则表达式类
**/
class RegularExpression {
    constructor() {
        /*
        * @description
        * 判断浏览器URL地址正则表达式
        * @public
        **/
        this.urlRex = /^(http|https):\/\/\w*\.[\w_-]*\.[\w\/]*(\.[\w\/]*)?([\?#](\/)?[\w_-]*)?([\?#](\/)?[\?#\w_-]*)?/;
    }
    /*
    * @description
    * 判断是否相同
    * @params
    * args {any} - 需要判断的变量
    * @public
    * @return {boolean}
    **/
    equal(...args): Boolean {
        return is(...args);
    }
    /*
    * @description
    * 判断是否为字符串
    * @params
    * d {string} - 需要判断的变量
    * @public
    * @return {boolean}
    **/
    isString(d): Boolean {
        return this.equal(Object.prototype.toString.call(d).toLowerCase(), "[object string]");
    }
    /*
    * @description
    * 判断浏览器URL地址
    * @params
    * d {string} - 需要判断的变量
    * @public
    * @return {boolean}
    **/
    isURL(d): Boolean {
        return this.isString(d)
            ? this.urlRex.test(d) : false;
    }
    /*
    * @description
    * 判断是否为商品详情URL地址
    * @params
    * d {string} - 需要判断的变量
    * @public
    * @return {Promise}
    **/
    isDetailUrl(d): Promise {
        return new Promise((resolve, reject): any => {
            if(this.isURL(d)) {
                const detailUrl: Array = d.split('/detail/')[1];
                const params: Array = detailUrl ? detailUrl.split('?') : [];
                const itemcode: Number | null = params[0] ? Number(params[0]) : null;
                d.startsWith("http://m.ocj.com.cn/detail/") && (itemcode || itemcode === 0)
                    ? resolve({itemcode, isBone: typeof params[1] !== 'undefined' && params[1].includes('isBone')})
                    : reject({err: "not detail url", d});
            } else {
                // 不是有效地址
                reject({err: "not url", d});
            }
        });
    }
}

export default new RegularExpression;
