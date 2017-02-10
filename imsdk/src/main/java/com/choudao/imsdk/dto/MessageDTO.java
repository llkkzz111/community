package com.choudao.imsdk.dto;


import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.imutils.IMMessageManager;

/**
 * Created by dufeng on 16-4-13.
 */
public class MessageDTO {
    private int msgLength;
    private short headerLength;
    private short version;
    private short msgType;
    private short seq;
    private String body;

    public MessageDTO() {
    }

    public MessageDTO(short version, short msgType, String body) {
        this.version = version;
        this.msgType = msgType;
        this.body = body;
        seq = IMMessageManager.getSeq();
        headerLength = (short) (2 + 2 + 2);
        msgLength = headerLength + body.getBytes().length + 2;
    }

    public int getMsgLength() {
        return msgLength;
    }

    public short getHeaderLength() {
        return headerLength;
    }

    public short getVersion() {
        return version;
    }

    public short getMsgType() {
        return msgType;
    }

    public String getBody() {
        return body;
    }

    public void setMsgLength(int msgLength) {
        this.msgLength = msgLength;
    }

    public void setHeaderLength(short headerLength) {
        this.headerLength = headerLength;
    }

    public void setVersion(short version) {
        this.version = version;
    }

    public void setMsgType(short msgType) {
        this.msgType = msgType;
    }

    public void setBody(String body) {
        this.body = body;
    }


    public short getSeq() {
        return seq;
    }

    public void setSeq(short seq) {
        this.seq = seq;
    }

    public MessageType msgTypeEnum() {
        return MessageType.of(msgType);
    }
//
//    public  void setMsgTypeEnum(MessageType msgType) {
//        this.msgType = msgType.code;
//    }

    @Override
    public String toString() {
        String str = "-->" + msgLength
                + "-->" + version
                + "-->" + msgTypeEnum() + "(" + msgType + ")"
                + "-->" + seq
                + "-->" + body
                + "\n";
        return str;
    }
}
