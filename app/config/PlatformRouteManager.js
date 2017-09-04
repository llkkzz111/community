/**
 * Created by Xiang on 2017/7/19.
 */
import React from 'react';
import {Platform} from "react-native";
import {Actions} from 'react-native-router-flux';
import * as routeConfig from './routeConfig';
import RNConnect from './rnConnect';
import * as LocalStorage from '../../foundation/LocalStorage';
import * as NativeRouter from'./NativeRouter';
let routeArray = [];
//fromRNPage(fromPage)
//targetNativePage(page)
//--------------------
//fromNativePage(beforepage)
//targetRNPage
export function routeJump(routeObj, routeCallBack: func) {
    if (routeObj.targetNativePage || routeObj.page) {
        if (routeObj.isPush && routeObj.page === routeConfig.ViewLogistics) {
            routeObj.targetRNPage = routeConfig.ViewLogistics;
            routeObj.orderNo = routeObj.param;
            routeToRNPage(routeObj);
        } else {
            routeToNativePage(routeObj, routeCallBack);
        }
    } else {
        //TODO 读缓存确定是否要存路径
        LocalStorage.load('jumpParams',
            (result) => {
                for (let i = 0; i < result.length; i++) {
                    let {targetNativePage, fromNativePage,} = result[i];
                    if (targetNativePage || fromNativePage) {
                        routeArray.push(routeObj);
                        LocalStorage.save('jumpParams', routeArray);
                        break;
                    }
                }
                routeToRNPage(routeObj);
            },
            (e) => {
                routeToRNPage(routeObj);
            })
    }
}

export function routeBack(beforepage) {
    LocalStorage.load('jumpParams',
        (result) => {
            let {page, fromRNPage, fromPage, targetNativePage, fromNativePage, beforepage, targetRNPage, param, ...beforeparam} = result[result.length - 1];
            if (beforepage || targetNativePage) {
                targetNativePage = targetNativePage ? targetNativePage : beforepage;
                if (targetNativePage && targetNativePage !== routeConfig.Pay) {
                    routeJump({page: targetNativePage, ...beforeparam, param: param ? param : '',});
                }
            }
            Actions.pop();
            routeArray.pop();
            LocalStorage.save('jumpParams', routeArray);
        },
        (e) => {
            console.log(e);
            Actions.pop();
        });
    // switch (beforepage) {
    //     case  routeConfig.Globalocj_GoodsDetailMain:
    //     case routeConfig.VIPocj_GoodsDetailMain:
    //     case routeConfig.Vedioocj_GoodsDetailMain:
    //         resetToHome();
    //         break;
    //     case routeConfig.iOSWebViewocj_GoodsDetailMain:
    //         Actions.Indexocj_Tab({type: 'reset'});
    //         Actions.JumpTo({hideNavBar: true});
    //         Actions.pop();
    //         //routeByUrl('returnWebView');
    //         break;
    //     default :
    //         //刷新购物车
    //         Actions.pop()
    //         break;
    // }
}

// function jumpTo(jumpType) {
//     switch (jumpType) {
//         case 0:
//             //回退上个页面
//             Actions.pop();
//             break;
//         case 1:
//             //回首页
//             resetToHome();
//             break;
//         case 2:
//             //回首页+回退
//             resetToHome();
//             Actions.pop();
//             break;
//         case 3:
//             //去原生页面
//             routeToNativePage('', routeConfig.iOSocj_WebView, false, {a: 1, b: 2})
//             break;
//         case 4:
//             //回退去原生页面+关闭当前RN页
//             routeToNativePage();
//             Actions.pop();
//             break;
//         case 5:
//             //RN页面跳转
//             break;
//         case 6:
//             break;
//     }
// }

//原生页面跳转
export function routeToNativePage(routeObj, routeCallBack) {
    let {fromRNPage, fromPage, targetNativePage, page, fromNativePage, beforepage, targetRNPage, param, ...nativeParam} = routeObj;
    fromRNPage = fromRNPage ? fromRNPage : fromPage;
    targetNativePage = targetNativePage ? targetNativePage : page;
    if (targetNativePage === routeConfig.WebView) {
        targetNativePage = Platform.OS === 'ios' ? routeConfig.iOSocj_WebView : routeConfig.Androidocj_WebView;
    }
    RNConnect.pushs(
        {
            fromPage: fromRNPage,
            page: targetNativePage,
            param: param ? param : '',
            ...nativeParam,
        },
        (event) => {
            fromRNPageCallBack(event);
            //TODO 参数方法回调
            routeCallBack && routeCallBack(event);
        }
    )
}

//RN页面跳转
export function routeToRNPage(event) {
    switch (event.targetRNPage) {
        case routeConfig.GoodsDetailMain:
            Actions.GoodsDetailMain(event);
            break;
        case routeConfig.CartPage:
            Actions.cartFromGoodsDetail(event);
            break;
        case routeConfig.MessageListPage:
            Actions.MessageFromGlobalOcj(event);
            break;
        case routeConfig.OrderCenter:
            routeArray = [];
            LocalStorage.save('jumpParams', routeArray);
            Actions.Indexocj_Tab({type: 'reset'});
            Actions.OrderCenter(event);
            break;
        case routeConfig.ResetToHome:
            resetToHome();
            break;
        case routeConfig.ResetToDetail:
            routeArray = [];
            LocalStorage.save('jumpParams', routeArray);
            Actions.Indexocj_Tab({type: 'reset'});
            Actions.GoodsDetailMain(event);
            break;
        case routeConfig.ViewLogistics:
            Actions.HomeViewLogistics(event);
            break;
    }
}

//原生页面回调
export function fromRNPageCallBack(event) {
    //TODO  区分平台
    let {fromRNPage, fromPage, targetNativePage, fromNativePage, beforepage, targetRNPage, token, tokenType, ...returnParams} = event;
    //必须回带targetRNPage
    if (targetRNPage) {
        if (beforepage === routeConfig.Sweep && targetRNPage === routeConfig.iOSocj_WebView) {
            //ios扫一扫
            routeToNativePage({page: routeConfig.iOSocj_WebView, param: {url: event.url ? event.url : ''}, ...event});
        } else {
            routeToRNPage(event);
            //NativeRouter.nativeRouter(event);
            routeArray.push({
                fromRNPage,
                fromPage,
                targetNativePage,
                fromNativePage,
                beforepage,
                targetRNPage,
                ...returnParams
            });
            LocalStorage.save('jumpParams', routeArray);
        }
    }
}

//缓存RN页面
export function cacheRNPage(data) {
    LocalStorage.load('jumpParams',
        (result) => {
            for (let i = 0; i < result.length; i++) {
                let {page, fromRNPage, fromPage, targetNativePage, fromNativePage, beforepage, targetRNPage, param, ...beforeparam} = result[i];
                if (targetNativePage || fromNativePage || beforepage) {
                    routeArray.push(data);
                    LocalStorage.save('jumpParams', routeArray);
                    break;
                }
            }
        },
        (e) => {
        })
}
//清空栈回退首页
export function resetToHome() {
    routeArray = [];
    LocalStorage.save('jumpParams', routeArray);
    Actions.Indexocj_Tab({type: 'reset'});
    Actions.JumpTo({hideNavBar: true});
}

