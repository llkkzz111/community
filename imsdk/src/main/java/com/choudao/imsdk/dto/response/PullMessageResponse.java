package com.choudao.imsdk.dto.response;

import com.choudao.imsdk.dto.push.MessagesBean;

import java.util.List;

/**
 * Created by dufeng on 16/5/5.<br/>
 * Description: FPResponse
 */
public class PullMessageResponse extends BaseResponse {


    private List<MessagesBean> messages;

    public List<MessagesBean> getMessages() {
        return messages;
    }

    public void setMessages(List<MessagesBean> messages) {
        this.messages = messages;
    }


}
