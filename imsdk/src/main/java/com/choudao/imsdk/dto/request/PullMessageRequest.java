package com.choudao.imsdk.dto.request;

import com.choudao.imsdk.db.bean.Message;
import com.choudao.imsdk.db.bean.SessionInfo;

/**
 * Created by dufeng on 16/4/29.<br/>
 * Description: FPRequest
 */
public class PullMessageRequest extends BaseRequest {
    private long targetId;

    private int sessionType;

    private long beginIndex;

    private long endIndex;

    private int count;

    private int pullType;

    private String source;

    //自用

    private long ackId = -1;

    private Message[] arrayAfterMessage;

    //自用

    public PullMessageRequest() {
    }

    public PullMessageRequest(long targetId, int sessionType, int pullType, long beginIndex, long endIndex, int count, Message[] arrayAfterMessage) {
        this.targetId = targetId;
        this.sessionType = sessionType;
        this.beginIndex = beginIndex;
        this.endIndex = endIndex;
        this.pullType = pullType;
        this.count = count;
        this.arrayAfterMessage = arrayAfterMessage;
    }

    public PullMessageRequest(long targetId, int sessionType, int pullType, long beginIndex, long endIndex, int count, long ackId) {
        this.targetId = targetId;
        this.sessionType = sessionType;
        this.beginIndex = beginIndex;
        this.endIndex = endIndex;
        this.pullType = pullType;
        this.count = count;
        this.ackId = ackId;
        this.source = String.valueOf(ackId);
    }

    public long getTargetId() {
        return targetId;
    }

    public void setTargetId(long targetId) {
        this.targetId = targetId;
    }

    public long getBeginIndex() {
        return beginIndex;
    }

    public void setBeginIndex(long beginIndex) {
        this.beginIndex = beginIndex;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getSessionType() {
        return sessionType;
    }

    public void setSessionType(int sessionType) {
        this.sessionType = sessionType;
    }

    public int getPullType() {
        return pullType;
    }

    public void setPullType(int pullType) {
        this.pullType = pullType;
    }

    public long getEndIndex() {
        return endIndex;
    }

    public void setEndIndex(long endIndex) {
        this.endIndex = endIndex;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    //自用
    public long loadAckId() {
        return ackId;
    }

    public Message[] loadAfterMessage(){
        return arrayAfterMessage;
    }

    //自用

}
