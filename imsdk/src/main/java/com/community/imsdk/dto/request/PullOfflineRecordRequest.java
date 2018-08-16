package com.community.imsdk.dto.request;

/**
 * Created by dufeng on 16/4/29.<br/>
 * Description: FSMsgRequest
 */
public class PullOfflineRecordRequest extends BaseRequest {

    private long index;
    private int count;

    public PullOfflineRecordRequest() {
    }

    public PullOfflineRecordRequest(long index, int count) {
        this.index = index;
        this.count = count;
    }

    public long getIndex() {
        return index;
    }

    public void setIndex(long index) {
        this.index = index;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
