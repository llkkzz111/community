/**
 * Created by YASIN
 * example：
 * 第一步：创建
 * class LoginRequest extends BaseRequest{
 * requestUrl() {
 *      return 'api/login.action';
 *   }
 *   //是否展示后台给的message，android为toast， ios为alert
 * showMessage(){
 *      return false;
 *  }
 * }
 * 第二步：使用
 * //创建一个请求对象，参数为（请求体，请求方法）
 * LoginRequest request=new LoginRequest();
 *
 * //发送请求 带进度条showLoadingView
 * request.start((response)=>{
 * },(erro)=>{
 * }).showLoadingView();
 *
 * 中断本次请求
 * request&&request.setCancled(true);
 *
 */
import  {
    Alert,
    Platform,
    ToastAndroid,
    BackAndroid,
}from 'react-native'
import AppConst, {DEBUG_MODE} from '../../app/constants/AppConstant';
import ResponseStatus from '../../app/constants/ResponseStatus';
import * as DialogAction from '../../app/actions/dialogaction/DialogAction';
import store from '../../app/createStore';
import TimerMiXin from 'react-timer-mixin';
import Global from '../../app/config/global';
import * as Md5Utils from '../utils/Md5Utils';
import * as LocalStorage from '../LocalStorage';
import RnConnect from '../../app/config/rnConnect';
export default class BaseRequest {
    // 构造
    constructor(body, method, mode) {
        //关闭打印信息，自己想要加上但别提上去，多了调试起来不方便，且要加上__DEV__不然生产环境一堆log
        this.log = false;
        //是否终止请求 默认false
        this.isCancled = false;
        //请求失败是否打印后台message 默认false
        this.isShowMessage = false;
        if (body == null) {
            body = {};
        }
        //默认的一些参数比如Global.testToken，发布版请改为Global.token
        Object.assign(body, {
            // version: AppConst.version
            // access_token:Global.testToken //测试token

        });

        //当没有指定请求方法的时候默认post
        if (method == null) {
            method = 'POST';
        }
        if (mode == null) {
            mode = 'cors';
        }
        this.method = method;
        this.body = body;
        this.mode = mode;
        this.headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'X-access-token': Global.token,//用户token
            'X-msale-way': Global.config.X_msale_way,//设备类型
            'X-version-info': Global.config.X_version_info,//版本信息
            'X-msale-code': Global.config.X_msale_code,//设备渠道
            'X-device-id': Global.config.X_device_id,//设备编码
            'X-jiguang-id': Global.config.X_jiguang_id,//极光推送编号
            'X-net-type': Global.config.X_net_type,//网络状态
            'X-region-cd': Global.config.X_region_cd,//分站地区CODE
            'X-sel-region-cd': Global.config.X_sel_region_cd,//分公司地区CODE
            'X-substation-code': Global.config.X_substation_code,//分站编码
            //'X-cache-opt': 'refresh',//刷新缓存（调试用）
        };
        this.userCache = this.getDefaultCache();
        this.requestTime = this.getDefaultTestingTime();
        this.requestTimeout = 20;
    }

    /**
     * 请覆盖此方法
     */
    requestUrl() {
        throw ({message: 'function requestUrl must be overrided!'});
    }

    /**
     * 开启loadingdialog
     * @returns {BaseRequest}
     */
    showLoadingView() {
        this.isShowing = true;
        store.dispatch(DialogAction.showLoading(true))
        return this;
    }

    /**
     * 关闭dialog
     * @returns {BaseRequest}
     */
    dismissLoadingView() {
        this.isShowing = false;
        store.dispatch(DialogAction.showLoading(false))
        return this;
    }

    /**
     * 使用缓存(目前cms接口有缓存数据)
     */
    setUseCache(flag = true) {
        this.userCache = flag;
        return this;
    }

    /**
     * 默认不使用缓存
     * @returns {boolean}
     */
    getDefaultCache() {
        return false;
    }

    /**
     * 设置超时时间 如果不设置默认20s
     */
    timeout(timeout) {
        this.requestTimeout = typeof timeout === 'number' ? (timeout > 0 ? timeout : 20) : 20 ;
        return this;
    }

    /**
     * 开始请求
     * @param successCallBack 成功后的回调
     * @param failCallBack 失败后的回调
     * @returns {BaseRequest}
     */
    start(successCallBack, failCallBack) {
        //接口响应时间测试
        let self = this;
        if (this.requestTime) {
            this.startTime = new Date().getTime();
        }
        //监听android返回键，android
        let url = this.requestUrl();
        if (this.isShowing) {
            BackAndroid.addEventListener(url, () => {
                this.dismissLoadingView();
                BackAndroid.removeEventListener(url);
                return false;
            });
        }
        RnConnect.get_token((param) => {
            if (self.headers) {
                self.headers['X-access-token'] = param.token
            }
            ;
            self.showLog('header----------->');
            self.showLog(self.headers);
            if (!!this.userCache) {
                let url = this.getBaseUrl() + this.requestUrl();
                let str = this.toQueryString(this.body);
                if (str && str.length > 0) url += '?' + str;
                let key = Md5Utils.md5(url);
                LocalStorage.load(key, (result) => {
                    if (result) {
                        if (this.isShowing) {
                            this.dismissLoadingView();
                        }
                        if (result && !this.isCancled) {
                            self.handleResponse(result, successCallBack, failCallBack);
                        }
                    } else {
                        self._doPost(successCallBack, failCallBack);
                    }
                }, (erro) => {
                    self._doPost(successCallBack, failCallBack);
                })
            } else {
                self._doPost(successCallBack, failCallBack);
            }
        });
        return self;
    }

    /**
     * 开始请求
     * @param successCallBack 成功后的回调
     * @param failCallBack 失败后的回调
     * @returns {BaseRequest}
     */
    async _doPost(successCallBack, failCallBack) {
        try {
            let url = this.getBaseUrl() + this.requestUrl();
            if ('GET' === this.method) {
                let str = this.toQueryString(this.body);
                if (str && str.length > 0) url += '?' + str;
            }
            this.showLog('requestUrl==>' + url);
            // console.log('---> BaseRequest start url ' + url);
            // console.log('--->当前 BaseRequest header X-access-token ' + this.headers['X-access-token']);
            this.showLog(this.body);
            let response = await fetch(url, {
                headers: this.headers,
                method: this.method,
                mode: this.mode,
                body: this.method == 'GET' ? null : JSON.stringify(this.body),
                timeout: this.requestTimeout * 1000,
                credentials: 'include'
            });
            let responseJson = await response.json();
            //获取cms缓存时间
            this._getCmsCacheTime(response);
            // console.log('---> BaseRequest start body' + JSON.stringify(this.body));
            this.showLog('response==>' + responseJson);
            this.showLog(responseJson);
            if (this.isShowing) {
                this.dismissLoadingView();
            }
            if (responseJson && !this.isCancled) {
                this._saveDatasToCache(responseJson);
                this.handleResponse(responseJson, successCallBack, failCallBack);
            } else {
                if (failCallBack && !this.isCancled) failCallBack('请求失败');
            }
        } catch (erro) {
            if (this.isShowing) {
                this.dismissLoadingView();
            }
            this.showLog('erro==>');
            this.showLog(erro);
            if (failCallBack && !this.isCancled) failCallBack(erro);
        }
        return this;
    }

    /**
     * 处理response
     * @param responseJson
     * @param successCallBack
     */
    handleResponse(responseJson, successCallBack, failCallBack) {
        if (__DEV__ && this.log && this.requestTime){
            try{
                console.log('********************************************************');
                console.log('********requestUrl: ' + this.requestUrl());
                console.log('********This request consumes time: ' + (new Date().getTime() - this.startTime) + 'ms');
                console.log('********************************************************');
            } catch (e) {

            }
        }
        if (this.isShowing) {
            this.dismissLoadingView();
        }
        if (ResponseStatus.SUCCESS == responseJson.code || parseInt(responseJson.code) === ResponseStatus.SUCCESS_INT) {
            if (successCallBack) successCallBack(responseJson);
        } else if (responseJson.message && responseJson.message.length > 0 && this.isShowMessage) {
            this.alertWithStr(responseJson.message);
            if (failCallBack) failCallBack(responseJson);
        } else {
            if (failCallBack) failCallBack(responseJson);
        }
    }

    /**
     * 请求是否已取消
     * @returns {*|boolean}
     */
    isCancle() {
        return this.isCancled;
    }

    /**
     * 是否取消请求
     * @param cancle
     */
    setCancled(cancle) {
        this.isCancled = cancle;
        if (this.isShowing) {
            this.dismissLoadingView();
        }
    }

    /**
     * 请求失败后是否显示后台message
     * @param show
     * @returns {BaseRequest}
     */
    setShowMessage(show) {
        this.isShowMessage = show;
        return this;
    }

    /**
     * 用于对对象编码以便进行传输
     * @param obj 对象参数
     * @returns {string} 返回字符串
     */
    toQueryString(obj) {
        let str = '';
        if (obj) {
            let keys = [];
            for (let key in obj) {
                keys.push(key);
            }
            keys.forEach((key, index) => {
                str += key + '=' + obj[key];
                if (index !== keys.length - 1) {
                    str += '&';
                }
            });
        }
        return str;
    }

    /**
     * 打印后台message
     * @param str
     */
    alertWithStr(str) {
        TimerMiXin.setTimeout(() => {
            if (Platform.OS == 'ios') {
                Alert.alert(
                    str,
                    null,
                    [
                        {text: '确定'}
                    ]
                );
            }
            if (Platform.OS == 'android') {
                ToastAndroid.show(str, ToastAndroid.LONG);
            }
        }, 1000);
    }

    /**
     * 打印log信息
     * @param log
     */
    showLog(log) {
        if (__DEV__ && this.log) {
            console.log(log);
        }
    }

    /**
     * 返回baseurl
     */
    getBaseUrl() {
        return AppConst.BASE_URL;
    }

    /**
     * 返回用户token
     * 正式生产环境改为
     */
    getUserToken() {
        if (DEBUG_MODE) {
            return Global.testToken;
        } else {
            return Global.token;
        }
    }

    /**
     * 获取cms缓存时间单位分钟
     * @param response
     * @private
     */
    _getCmsCacheTime(response) {
        try {
            if (response && response.headers && response.headers.map) {
                let cacheTimes = response.headers.map['x-cache-ttl'];
                if (cacheTimes && cacheTimes.length > 0) {
                    let cacheTime = cacheTimes[0];
                    if (cacheTime && cacheTime.length > 0) {
                        cacheTime = parseFloat(cacheTime);
                        if (Global) {
                            Global.cmsCacheTime = cacheTime;
                        }
                    }
                }
                let currTimes = response.headers.map['x-current-time'];
                if (currTimes && currTimes.length > 0) {
                    let currTime = currTimes[0];
                    if (currTime && currTime.length > 0) {
                        this.currTime = currTime;
                    }
                }
            }
        } catch (erro) {
        }
    }

    /**
     * 存放数据到缓存中
     * @private
     */
    _saveDatasToCache(responseJson) {
        if (!!this.userCache) {
            if (ResponseStatus.SUCCESS == responseJson.code || parseInt(responseJson.code) === ResponseStatus.SUCCESS_INT) {
                let url = this.getBaseUrl() + this.requestUrl();
                let str = this.toQueryString(this.body);
                if (str && str.length > 0) url += '?' + str;
                let key = Md5Utils.md5(url);
                LocalStorage.saveCms(key, responseJson);
            }
        }
    }

    /**
     * 是否打印接口请求时间
     * @returns {boolean}
     */
    getDefaultTestingTime() {
        return false;
    }
}
