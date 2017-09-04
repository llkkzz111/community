/**
 * Created by dongfanggouwu-xiong on 2017/7/5.
 * 取消预约订单
 */
import BaseRequest from '../BaseRequest';
import TimerMiXin from 'react-timer-mixin';
import {Actions} from 'react-native-router-flux';
import  {
    Alert,
    Platform,
    ToastAndroid
}from 'react-native'
export default class CancelSubscribeOrder extends BaseRequest{
    requestUrl(){
        return '/api/orders/advanceorders/cancel_advance_order';
    }
}