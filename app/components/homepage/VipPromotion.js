/**
 * Created by Xiang on 2017/6/15.
 */
import React from 'react';
import * as routeConfig from "../../../app/config/routeConfig";
import Global from "../../../app/config/global";
import RNConnect from '../../../app/config/rnConnect';
import {Actions} from 'react-native-router-flux';
import * as NativeRouter from'../../config/NativeRouter';
import * as RouteManager from '../../../app/config/PlatformRouteManager';
/**
 * 会员特价H5页面
 */
export default class HeaderTabItem extends React.PureComponent {

    render() {
        // if (Platform.OS === 'ios') {
        //     RNConnect.pushs({
        //         page: routeConfig.iOSocj_WebView,
        //         param: {url: this.props.value ? this.props.value : '',fromPage:this.props.fromPage?this.props.fromPage:''}
        //     }, (event) => {
        //         NativeRouter.nativeRouter(event);
        //     });
        // } else {
        //     RNConnect.pushs({
        //         page: routeConfig.Androidocj_WebView,
        //         param: {url: this.props.value ? this.props.value : '',fromPage:this.props.fromPage?this.props.fromPage:''}
        //     }, (event) => {
        //         NativeRouter.nativeRouter(event);
        //     });
        // }
        RouteManager.routeJump({
            page: routeConfig.WebView,
            param: {
                url: this.props.value ? this.props.value : '',
                fromPage: this.props.fromPage ? this.props.fromPage : ''
            }
        })
        Actions.pop();
        return null;
    }
}