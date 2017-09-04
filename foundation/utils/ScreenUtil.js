/**
 * @author YASIN
 * @description
 * 屏幕工具类
 * ui设计基准,iphone 6
 * width:750px
 * height:1334px
 */
import {
    PixelRatio,
    Dimensions,
}from 'react-native';
export let screenW = Dimensions.get('window').width;
export let screenH = Dimensions.get('window').height;
const fontScale = PixelRatio.getFontScale();
export let pixelRatio = PixelRatio.get();
//像素密度
export const DEFAULT_DENSITY = 2;
//px转换成dp
const w2 = 750 / DEFAULT_DENSITY;
//px转换成dp
const h2 = 1334 / DEFAULT_DENSITY;
/**
 * 设置字体的size（单位px）
 * @param size 传入设计稿上的px
 * @returns {Number} 返回实际sp
 */
export function setSpText(size:Number) {
    let scaleWidth = screenW / w2;
    let scaleHeight = screenH / h2;
    let scale = Math.min(scaleWidth, scaleHeight);
    size = Math.round((size * scale + 0.5));
    return size / DEFAULT_DENSITY;
}
/**
 * 屏幕适配,缩放size
 * @param size
 * @returns {Number}
 */
export function scaleSize(size:Number) {
    let scaleWidth = screenW / w2;
    let scaleHeight = screenH / h2;
    let scale = Math.min(scaleWidth, scaleHeight);
    size = Math.round((size * scale + 0.5));
    return size / DEFAULT_DENSITY;
}


//时间处理
Date.prototype.format = function (format) {
    let date = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S+": this.getMilliseconds()
    };
    if (/(y+)/i.test(format)) {
        format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
    }
    for (let k in date) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length === 1
                ? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
        }
    }
    return format;
};
//获取时间差 current:1497235409744 当前时间  start:1497235419744 开始时间
export function getRemainingime(current:Number, start:Number) {

    let timestamp = start - current;
    if (timestamp < 0) {
        return ["0", "0", "0", "0", "0", "0"];
    }
    let date = new Date();
    date.setTime(timestamp);
    let str = date.format('yyyy-MM-dd-hh-mm-ss');
    let strs = str.split('-');
    strs.splice(0, 1, String(Number(strs[0]) - 1970));//年
    strs.splice(1, 1, String(Number(strs[1]) - 1));
    strs.splice(2, 1, (Number(strs[2]) - 1) < 10 ? '0' + (Number(strs[2]) - 1) : String(Number(strs[2]) - 1));
    strs.splice(3, 1, (Number(strs[3]) - 8) < 10 ? '0' + (Number(strs[3]) - 8) : String(Number(strs[3]) - 8));
    strs.splice(4, 1, Number(strs[4]) < 10 ? '0' + Number(strs[4]) : String(Number(strs[4])));
    strs.splice(5, 1, Number(strs[5]) < 10 ? '0' + Number(strs[5]) : String(Number(strs[5])));
    return strs;//["0", "0", "2", "7", "33", "30"]0年0月2日 7时33分30秒
}

//1497235419
export function getRemainingimeDistance(distance:Number) {
    let timestamp = distance * 1000;
    if (timestamp < 0) {
        return ["0", "0", "0", "0", "0", "0"];
    }
    let date = new Date();
    date.setTime(timestamp);
    let str = date.format('yyyy-MM-dd-hh-mm-ss');
    let strs = str.split('-');
    strs.splice(0, 1, String(Number(strs[0]) - 1970));//年
    strs.splice(1, 1, String(Number(strs[1]) - 1));
    strs.splice(2, 1, (Number(strs[2]) - 1) < 10 ? '0' + (Number(strs[2]) - 1) : String(Number(strs[2]) - 1));
    strs.splice(3, 1, (Number(strs[3]) - 8) < 10 ? '0' + (Number(strs[3]) - 8) : String(Number(strs[3]) - 8));
    strs.splice(4, 1, Number(strs[4]) < 10 ? '0' + Number(strs[4]) : String(Number(strs[4])));
    strs.splice(5, 1, Number(strs[5]) < 10 ? '0' + Number(strs[5]) : String(Number(strs[5])));
    return strs;//["0", "0", "2", "7", "33", "30"]0年0月2日 7时33分30秒
}

//转换成日期
export function toDate(timestamp:Number, format1 = 'yyyy-MM-dd hh:mm:ss') {
    try {
        if(timestamp>10000){
            let date = new Date();
            date.setTime(timestamp);
            return date.format(format1);//2014-07-10 10:21:12
        }else{
            return '';
        }
    } catch (erro) {
        return '';
    }
    return '';
}
//转换成时间搓
export function toTimestamp(date:String) {
    let timestamp = Date.parse(date);
    return timestamp / 1000;  // 1497233827569/1000
}

//CST时间=>转换成日期yyyy-MM-dd hh:mm:ss
export function getTaskTime(strDate) {
    if (null == strDate || "" == strDate) {
        return "";
    }
    let dateStr = strDate.trim().split(" ");
    let strGMT = dateStr[0] + " " + dateStr[1] + " " + dateStr[2] + " " + dateStr[5] + " " + dateStr[3] + " GMT+0800";
    let date = new Date(Date.parse(strGMT));
    let y = date.getFullYear();
    let m = date.getMonth() + 1;
    m = m < 10 ? ('0' + m) : m;
    let d = date.getDate();
    d = d < 10 ? ('0' + d) : d;
    let h = date.getHours();
    let minute = date.getMinutes();
    minute = minute < 10 ? ('0' + minute) : minute;
    let second = date.getSeconds();
    second = second < 10 ? ('0' + second) : second;

    return y + "-" + m + "-" + d + " " + h + ":" + minute + ":" + second;
};
//1497235419
export function getRemainingimeDistance2(distance:Number) {
    let time = distance;
    let days = Math.floor(time / (24 * 3600 * 1000));
    let temp1 = time % (24 * 3600 * 1000);
    let hours = Math.floor(temp1 / (3600 * 1000));
    let temp2 = temp1 % (3600 * 1000);
    let minutes = Math.floor(temp2 / (60 * 1000));
    if (time <= 60 * 1000) {
        minutes = 1;
    }
    let temp3 = temp2 % (60 * 1000);
    let seconds = Math.round(temp3 / 1000);
    return [hours, minutes];//["0", "0", "2", "7", "33", "30"]0年0月2日 7时33分30秒
}

export default class ScreenUtil{
    static screenW = screenW;
    static screenH = screenH;
    static pixelRatio = pixelRatio;
    static DEFAULT_DENSITY = DEFAULT_DENSITY;

    static setSpText(size:Number){
        return setSpText(size);
    }
    static scaleSize(size:Number){
        return scaleSize(size);
    }
    static getRemainingimeDistance(distance:Number){
        return getRemainingimeDistance(distance);
    }
    static toDate(timestamp:Number, format1 = 'yyyy-MM-dd hh:mm:ss'){
        return toDate(timestamp,format1);
    }
    static toTimestamp(date:String){
        return toTimestamp(date);
    }
    static getTaskTime(strDate){
        return getTaskTime(strDate);
    }
    static getRemainingimeDistance2(distance:Number){
        return getRemainingimeDistance2(distance);
    }
}

//
// // 将当前时间换成时间格式字符串
// var timestamp3 = 1403058804;
// var newDate = new Date();
// newDate.setTime(timestamp3);
// // Wed Jun 18 2014
// console.log(newDate.toDateString());
// // 2014-06-18T02:33:24.000Z
// console.log(newDate.toISOString());
// // 2014-06-18T02:33:24.000Z
// console.log(newDate.toJSON());
// // 2014年6月18日
// console.log(newDate.toLocaleDateString());
// // 2014年6月18日 上午10:33:24
// console.log(newDate.toLocaleString());
// // 上午10:33:24
// console.log(newDate.toLocaleTimeString());
// // Wed Jun 18 2014 10:33:24 GMT+0800 (中国标准时间)
// console.log(newDate.toString());
// // 10:33:24 GMT+0800 (中国标准时间)
// console.log(newDate.toTimeString());
// // Wed, 18 Jun 2014 02:33:24 GMT
// console.log(newDate.toUTCString());
// // 2014-07-10 10:21:12
// console.log(newDate.format('yyyy-MM-dd h:m:s'))
