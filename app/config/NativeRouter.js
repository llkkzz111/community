/**
 * Created by jiajiewang on 2017/6/28.
 */
import * as routeConfig from './routeConfig';
import {Actions} from 'react-native-router-flux';

export function nativeRouter(obj) {
    //原生传来的参数
    switch (obj.beforepage) {
        case routeConfig.Globalocj_GoodsDetailMain:
            Actions.GoodsDetailMain(obj);
            break;
        //原生去消息中心
        case routeConfig.Globalocj_MessageListPage:
            Actions.MessageFromGlobalOcj(obj);
            break;
        case routeConfig.Globalocj_GoodsWebView:
            if (obj.url !== undefined) {
                Actions.VipPromotion({value: obj.url, isScan: obj.isScan});
            }
            break;
        //支付去订单中心
        case routeConfig.Paymentocj_OrderCenter:
            Actions.Indexocj_Tab({type: 'reset'});
            //跳转订单中心
            Actions.OrderCenter(obj);
            break;
        //支付页面去首页
        case routeConfig.Paymentocj_Home:
            Actions.Indexocj_Tab({type: 'reset'});
            Actions.JumpTo({hideNavBar: true});
            break;
        case routeConfig.Indexocj_GoodsDetailMain:
            Actions.Indexocj_Tab({type: 'reset'});
            Actions.GoodsDetailMainFromHome(obj);
            break;
        //安卓h5页去商品详情
        case routeConfig.AndroidWebViewocj_GoodsDetailMain:
            Actions.GoodsDetailMain(obj);
            break;
        //视频播放到购物车
        case routeConfig.Videoocj_cartFrmRoot:
            Actions.cartFromGoodsDetail(obj);
            break;
        //视频播放到商品详情
        case routeConfig.Vedioocj_GoodsDetailMain:
            Actions.GoodsDetailMain(obj);
            break;
        //ios h5去商品详情
        case routeConfig.iOSWebViewocj_GoodsDetailMain:
            Actions.GoodsDetailMainFromHome(obj);
            break;
        //回到webView
        case routeConfig.returnocj_WebView:
            Actions.VipPromotion(obj);
            break;
        //iOSWebView去购物车
        case routeConfig.iOSocj_CartPage:
            Actions.cartFromStoreDetail(obj);
            break;
        case routeConfig.VIPocj_GoodsDetailMain:
            Actions.GoodsDetailMain(obj);
            break;
        default:
            break;
    }
}