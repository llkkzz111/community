/**
 * Created by MASTERMIAO on 2017/6/20.
 * 截取url参数的工具类
 */
'use strict';

/**
 *
 * @param params
 * @returns {*}
 */
export function getParam(params): number {
    let str, p;
    let reg = new RegExp(".jhtml$");
    if (params.toString().match(reg) === '.jhtml' || params.toString().match(reg) === ".jhtml") {
        return;
    } else if (params.toString().match(reg) === null) {
        let ff = params.split("/");
        let value = ff[ff.length - 1];
        if (value.indexOf('?') > -1) {
            p = value.indexOf('?');
            str = value.substring(0, p);
            return str;
        } else if (value.indexOf('?') == -1) {
            return value;
        }
    }
}
