/**
 * Created by 路卫国 on 2017/5/31.
 * 获取消息列表
 */
import BaseRequest from '../BaseRequest';
export default class UserMessagesRequest extends BaseRequest{
    requestUrl(){
        return '/api/interactions/messages/list';
    }
}