/**
 * Created by MASTERMIAO on 2017/6/19.
 * 字符串\数组 非空判断工具类
 */
'use strict';

/**
 * 判断字符串是否为空、未定义
 * @param params
 * @returns {boolean}
 */
export function stringIsEmptyAndUndefinedAndNull(params): boolean {
    if (params !== null && params !== 'null' && params !== "null" && params !== undefined && params !== '' && params !== "") {
        return true;
    } else {
        return false;
    }
}

/**
 * 判断字符串是否为空、未定义(强化版本)
 * @param params
 * @returns {boolean}
 */
export function stringIsEmptyAndUndefinedAndNullExtar(params): boolean {
    if (params !== null && params !== 'null' && params !== "null" && params !== "undefined" && params !== 'undefined' && params !== undefined && params !== '' && params !== "") {
        return true;
    } else {
        return false;
    }
}

/**
 * 判断数组是否为空、未定义
 * @param params
 * @returns {boolean}
 */
export function arrayIsEmptyAndUndefinedAndNull(params): boolean {
    if (params.length > 0 && params !== null && params !== undefined) {
        return true;
    } else {
        return false
    }
}

/**
 * 判断字符串是否为空、未定义
 * @param params
 * @returns {boolean}
 */
export function stringIsEmptyAndUndefined(params): boolean {
    if (params !== null && params !== undefined) {
        return true;
    } else {
        return false;
    }
}