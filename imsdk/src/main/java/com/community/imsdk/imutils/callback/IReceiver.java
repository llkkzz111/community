package com.community.imsdk.imutils.callback;

import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.request.BaseRequest;

/**
 * Created by dufeng on 16/5/17.<br/>
 * Description: 消息类型分发用
 */
public interface IReceiver {
    void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response);

    void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response);

    void receiverMessageTimeout(MessageType messageType, BaseRequest request);
}
