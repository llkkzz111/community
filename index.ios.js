/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React from 'react';
import {
    AppRegistry,
    StyleSheet,
    NetInfo
} from 'react-native';
import Global from './app/config/global';
import Main from './app/index'
// import * as Progress from 'react-native-progress'
// import codePush from "react-native-code-push";
// import Toast from 'react-native-root-toast';
import * as LocalStorage from './foundation/LocalStorage';
import RnConnect from './app/config/rnConnect';
class OCJ_RN_APP extends React.Component {

    componentWillMount() {
        //初始化缓存
        LocalStorage.init();
        RnConnect.get_token();
        RnConnect.get_Font();
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
