/**
 * Created by Zhang.xc on 2017/6/27.
 */

//数据拷贝
export const deepCopy = (obj) => {
    let newObj = {};
    if (obj === null || obj === "") {
        return obj;
    }
    if (typeof obj !== "object") {
        return obj;
    }
    if (Array.isArray(obj)) {
        newObj = [];
    }
    for (let attr in obj) {
        newObj[attr] = deepCopy(obj[attr]);
    }
    return newObj;
}

//去除数组重复
export const norepeat = (arr) => {
    return [...new Set(arr)];
}
//是否是空
export const isEmpty = (obj) => {
    let chkResult = true;
    if (obj !== null && obj !== undefined) {
        if (Array.isArray(obj) && obj.length > 0) {
            chkResult = false;
        } else if (String(obj).length > 0) {
            chkResult = false;
        }
    }
    return chkResult;
}
//errCode是否为空
export const chkErrCodeEmpty = (errCode) => {
    let chkResult = false;
    if (errCode !== null && errCode !== undefined && String(errCode).length > 3) {
        chkResult = true;
    }
    return chkResult;
}