/**
 * Created by dhy on 2017/5/24.
 */
import {NativeModules, Platform} from "react-native";
//路由配置
import * as routeConfig from "../config/routeConfig";
//全局变量
import Global from "./global";
//iOS 初始化
if (Platform.OS === 'ios') {
    let MethodManager = NativeModules.MethodManager;
    MethodManager.pushToPage({page: "init"}, (error, events) => {
        // console.log(events);
    });
}
//安卓的NativeModules
import {AndroidRouterModule} from "./AndroidModules";

export default class RNconnect {
    //调用签到
    static showSign() {
        if (Platform.OS === 'ios') {
            let MethodManager = NativeModules.MethodManager;
            MethodManager.showSigns((error, events) => {
            });
        } else if (Platform.OS === 'android') {
            AndroidRouterModule.showSuspension(true);
        }
    }
    //隐藏签到
    static hideSign() {
        if (Platform.OS === 'ios') {
            let MethodManager = NativeModules.MethodManager;
            MethodManager.hideSigns((error, events) => {
            });
        } else if (Platform.OS === 'android') {
            AndroidRouterModule.showSuspension(false);
        }
    }
    //主动获取字体型号  目前没有使用
    static get_Font() {
        if (Platform.OS === 'ios') {
            let MethodManager = NativeModules.MethodManager;
            MethodManager.getFont((error, events) => {
                Global.type = (events === '2' ? 2 : 0);
                // console.log('FontType-------->' + Global.type);
            });
        }
    }

    //noinspection JSAnnotator  主动刷新token 属性含义见BaseRequest.js解释
    static get_token(callback: func) {
        if (Platform.OS === 'ios') {
            let MethodManager = NativeModules.MethodManager;
            MethodManager.getToken((error, events) => {
                Global.token = events.token;
                Global.testToken = events.token;
                Global.tokenType = events.tokenType;
                Global.config.userId = events.UserId;
                Global.config.X_msale_way = events['X-msale-way'];
                Global.config.X_version_info = events['X-version-info'];
                Global.config.X_msale_code = events['X-msale-code'];
                Global.config.X_device_id = events['X-device-id'];
                Global.config.X_jiguang_id = events['X-jiguang-id'];
                Global.config.X_net_type = events['X-net-type'];
                Global.config.X_region_cd = events['X-region-cd'];
                Global.config.X_sel_region_cd = events['X-sel-region-cd'];
                Global.config.X_substation_code = events['X-substation-code'];
                // console.log('X-jiguang-id-------->' + events['X-jiguang-id']);
                callback && callback(events);
            });
        } else {
            AndroidRouterModule.getToken((returnStr) => {
                let returnParams = JSON.parse(returnStr);
                Global.token = returnParams.token;
                Global.testToken = returnParams.token;
                Global.tokenType = returnParams.tokenType;
                Global.config.X_msale_way = returnParams.X_msale_way;
                Global.config.X_version_info = returnParams.X_version_info;
                Global.config.X_msale_code = returnParams.X_msale_code;
                Global.config.X_device_id = returnParams.X_device_id;
                Global.config.X_jiguang_id = returnParams.X_jiguang_id;
                Global.config.X_net_type = returnParams.X_net_type;
                Global.config.X_region_cd = returnParams.X_region_cd;
                Global.config.X_sel_region_cd = returnParams.X_sel_region_cd;
                Global.config.X_substation_code = returnParams.X_substation_code;
                Global.config.userId = returnParams.UserId;
                callback && callback(returnParams);
                // console.log('token-------->' + token);
                // console.log('tokenType-------->' + type);
            })
        }
        return Global.token;
    }

    /*   pushs
     data:{
     page: ,//传入页面的key  必传参数
     openType: 'present',上下弹出  'push' ,左右推  为空不传默认是push
     param:{//传入页面的参数
     },
     }
     callback:function  回调函数把原生数据回传到页面  可不实现
     简单示例: RnConnect.pushs({page:routeConfig.MePageocj_Score});
     完整示例：RnConnect.pushs({page:routeConfig.MePageocj_Score,param:{key:'123456789'}},(events) => { alert(events)});

     */
    //noinspection JSAnnotator
    static pushs(data, callback: func) {
        if (!data.page) {//判断必要参数是否存在
            return;
        } else if (!data.openType) {
            data.openType = 'push';//设置默认推出方式
        } //page不能为空
        if (Platform.OS === 'ios') {
            let MethodManager = NativeModules.MethodManager;
            // getToken:获取token的方法 MethodManager.getToken((error, events) => {})；
            // getFont:获取token的方法 MethodManager.getFont((error, events) => {})；
            switch (data.page) {
                //有token跳转登录  token过期了
                case routeConfig.Login://登录
                    data.openType = 'present';
                    MethodManager.pushToPage(data, (error, events) => {
                        Global.token = events.token;
                        Global.testToken = events.token;
                        Global.tokenType = events.tokenType;
                        callback && callback(events); //把token回传到页面
                        // console.log('登录之后block回调 tokenType === ' + events.tokenType);
                        // console.log('登录之后block回调 token === ' + events.token);
                    });
                    break;
                case routeConfig.Setting://设置
                    MethodManager.pushToPage(data, (error, events) => {
                        // console.log('MePageocj_Setting === ' + events);
                    });
                    break;
                case routeConfig.SelectAddress://收货地址
                    MethodManager.pushToPage(data, (error, events) => {
                        Global.receiveAddress = events;
                        callback && callback(JSON.parse(events)); //把地址回传到页面
                        // console.log('MePageocj_ManageAddress === ' + events);
                    });
                    break;
                case routeConfig.Exchange://换货
                    MethodManager.pushToPage(data, (error, events) => {
                        callback && callback(events);
                        // console.log('OrderDetailocj_Exchange === ' + events);
                    });
                    break;
                case routeConfig.Return://退货
                    MethodManager.pushToPage(data, (error, events) => {
                        callback && callback(events);
                        // console.log('OrderDetailocj_Return === ' + events);
                    });
                    break;
                case routeConfig.Valuate://评价
                    MethodManager.pushToPage(data, (error, events) => {
                        callback && callback(events);
                        // console.log('OrderDetailocj_Return === ' + events);
                    });
                    break;
                case routeConfig.SelectArea://选择配送地区
                    MethodManager.pushToPage(data, (error, events) => {
                        callback && callback(events);
                        // console.log('GoodsDetailMainocj_SelectArea === ' + events);
                    });
                    break;
                case routeConfig.PlayVideo://播放视频
                    MethodManager.pushToPage(data, (error, events) => {
                        callback && callback(events);
                    });
                    break;
                default://默认没有特殊要求的页面都是传参走回调
                    MethodManager.pushToPage(data, (error, events) => {
                        callback && callback(events);
                        // console.log('default === ' + events);
                    });
                    break;
            }
        } else {
            //android原生跳转处理
            startAndroidPage(JSON.stringify(data), callback);
        }
    }
}
async function startAndroidPage(data, callback) {
    try {
        let jsonParams = await AndroidRouterModule.startAndroidActivity(data);
        let jsonObj = JSON.parse(jsonParams);
        if (jsonObj.token !== undefined) {
            Global.token = jsonObj.token;
            Global.testToken = jsonObj.token;
            Global.tokenType = jsonObj.tokenType;
        }
        callback && callback(jsonObj);
        // console.log(jsonParams);
        // console.log('token--------> ' + Global.token);
        // console.log('testToken-------->' + Global.testToken);
        // console.log('tokenType-------->' + Global.tokenType);
    } catch (e) {
        // console.error(e);
    }
}
