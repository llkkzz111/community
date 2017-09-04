import React from 'react';
import {
    AppRegistry,
    NetInfo
} from 'react-native';
import AppConst, {DEBUG_MODE} from './app/constants/AppConstant.js';
import Main from './app/index'
import * as LocalStorage from './foundation/LocalStorage';
import {AndroidRouterModule}from './app/config/AndroidModules'
import Global from './app/config/global';
class OCJ_RN_APP extends React.Component {
    componentWillMount() {
        //初始化缓存
        LocalStorage.init();
        AndroidRouterModule.getToken((token, type) => {
            Global.token = token;
            Global.testToken = token;
            Global.tokenType = type;
            // console.log('---> token from native:  ' + token);
            // console.log('---> type:  ' + type);
        });
        AndroidRouterModule.setBaseUrlToNative(DEBUG_MODE, AppConst.BASE_URL, AppConst.H5_BASE_URL);
        //监听网络状态
        NetInfo.fetch().done((reach) => {
        });
        function handleFirstConnectivityChange(reach) {
            NetInfo.removeEventListener(
                'change',
                handleFirstConnectivityChange
            );
        }

        NetInfo.addEventListener(
            'change',
            handleFirstConnectivityChange
        );
    }

    render() {
        return (
            <Main />
        );
    }
}

AppRegistry.registerComponent('OCJ_RN_APP', () => OCJ_RN_APP);
console.disableYellowBox = true;
