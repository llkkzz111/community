/**
 * Created by Xiang on 2017/6/15.
 */
import React from 'react';
import {Platform} from "react-native";
import * as routeConfig from "../../../app/config/routeConfig";
import {Actions} from 'react-native-router-flux';
import * as RouteManager from '../../../app/config/PlatformRouteManager';
/**
 * 路由到h5页面
 */
export default function routeByUrl(destinationUrl, fromPage) {
    if (destinationUrl) {
        if (destinationUrl.indexOf('http') !== -1) {
            if (destinationUrl.indexOf('/mobileappdetail/') !== -1) {
                let detailUrl = destinationUrl.split('/mobileappdetail/')[1];
                if (detailUrl.indexOf('?') !== -1) {
                    let params = detailUrl.split('?');
                    let itemCode = params[0];
                    if (params[1].indexOf('isBone') !== -1) {
                        Actions.GoodsDetailMain({itemcode: itemCode, isBone: '1'});
                    } else {
                        Actions.GoodsDetailMain({itemcode: itemCode});
                    }
                } else {
                    Actions.GoodsDetailMain({itemcode: detailUrl});
                }
                // } else if (destinationUrl.indexOf('/detail/') !== -1) {
                //     let detailUrl = destinationUrl.split('/detail/')[1];
                //     if (detailUrl.indexOf('?') !== -1) {
                //         let params = detailUrl.split('?');
                //         let itemCode = params[0];
                //         if (params[1].indexOf('isBone') !== -1) {
                //             Actions.GoodsDetailMain({itemcode: itemCode, isBone: '1'});
                //         } else {
                //             Actions.GoodsDetailMain({itemcode: itemCode});
                //         }
                //     } else {
                //         Actions.GoodsDetailMain({itemcode: detailUrl});
                //     }
            } else {
                if (Platform.OS === 'ios') {
                    jumpToNative(routeConfig.iOSocj_WebView, destinationUrl, fromPage);
                } else {
                    jumpToNative(routeConfig.Androidocj_WebView, destinationUrl, fromPage);
                }
            }
        } else if (destinationUrl === 'returnWebView') {
            if (Platform.OS === 'ios') {
                jumpToNative(routeConfig.iOSocj_WebView, '', fromPage);
            } else {
                jumpToNative(routeConfig.Androidocj_WebView, '', fromPage);
            }
        } else {
            Actions.GoodsDetailMain({itemcode: destinationUrl});
        }
    }
}

//跳转native h5
jumpToNative = (router, destinationUrl, fromPage) => {
    // RNConnect.pushs({
    //     page: router,
    //     param: {url: destinationUrl ? destinationUrl : ''}
    // }, (event) => {
    //     NativeRouter.nativeRouter(event);
    // });
    RouteManager.routeJump({
        page: router,
        param: {url: destinationUrl ? destinationUrl : ''},
        fromPage: fromPage ? fromPage : '',
    })
};


jumpToDetail = (detialUrl) => {
    if (detialUrl.indexOf('?') !== -1) {
        let params = detailUrl.split('?');
        let itemCode = params[0];
        if (params[1].indexOf('isBone') !== -1) {
            Actions.GoodsDetailMain({itemcode: itemCode, isBone: '1'});
        } else {
            Actions.GoodsDetailMain({itemcode: itemCode});
        }
    } else {
        Actions.GoodsDetailMain({itemcode: detailUrl});
    }
};