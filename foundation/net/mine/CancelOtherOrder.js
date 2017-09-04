/**
 * Created by dongfanggouwu-xiong on 2017/6/15.
 * 取消订单
 */
import BaseRequest from '../BaseRequest';
import TimerMiXin from 'react-timer-mixin';
import {Actions} from 'react-native-router-flux';
import  {
    Alert,
    Platform,
    ToastAndroid
}from 'react-native'
export default class CancelOrderRequest extends BaseRequest{
    requestUrl(){
        return '/api/orders/orders/cancel_order';
    }
    // /**
    //  * 重写后台打印message
    //  * @param str
    //  */
    // alertWithStr(str) {
    //     TimerMiXin.setTimeout(() => {
    //         if (Platform.OS == 'ios') {
    //             str==="订单取消失败，请重新取消"?Alert.alert(
    //                 str,
    //                 null,
    //                 [
    //                     {text: '确定',onPress: () => {
    //                         Actions.popTo("OrderCenter");
    //                     }}
    //                 ]
    //             ):null;
    //         }
    //         if (Platform.OS == 'android') {
    //             str==="订单取消成功"?
    //             ToastAndroid.show(str, ToastAndroid.LONG):null;
    //         }
    //     }, 1000);
    // }
}