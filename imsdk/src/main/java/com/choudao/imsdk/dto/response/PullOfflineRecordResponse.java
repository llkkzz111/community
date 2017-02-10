package com.choudao.imsdk.dto.response;

import java.util.List;

/**
 * Created by dufeng on 16/5/5.<br/>
 * Description: FSResponse
 */
public class PullOfflineRecordResponse extends BaseResponse {

    private List<RecordBean> records;

    public List<RecordBean> getRecords() {
        return records;
    }

    public void setRecords(List<RecordBean> records) {
        this.records = records;
    }

    public static class RecordBean {
        private long id;
        private int count;
        private long firstMsgId;
        private long lastMsgId;
        private long lastTime;
        private long targetId;
        private int sessionType;
        private String lastMsgContent;

        public long getId() {
            return id;
        }

        public void setId(long id) {
            this.id = id;
        }

        public int getCount() {
            return count;
        }

        public void setCount(int count) {
            this.count = count;
        }

        public long getLastMsgId() {
            return lastMsgId;
        }

        public void setLastMsgId(long lastMsgId) {
            this.lastMsgId = lastMsgId;
        }

        public long getLastTime() {
            return lastTime;
        }

        public void setLastTime(long lastTime) {
            this.lastTime = lastTime;
        }

        public long getTargetId() {
            return targetId;
        }

        public void setTargetId(long targetId) {
            this.targetId = targetId;
        }

        public String getLastMsgContent() {
            return lastMsgContent;
        }

        public void setLastMsgContent(String lastMsgContent) {
            this.lastMsgContent = lastMsgContent;
        }

        public int getSessionType() {
            return sessionType;
        }

        public void setSessionType(int sessionType) {
            this.sessionType = sessionType;
        }

        public long getFirstMsgId() {
            return firstMsgId;
        }

        public void setFirstMsgId(long firstMsgId) {
            this.firstMsgId = firstMsgId;
        }
    }

    public long showMinId() {
        if (records.size() == 0) {
            return 0;
        }
        long id = records.get(records.size() - 1).id;
        for (RecordBean RecordBean : records) {
            if (RecordBean.id < id) {
                id = RecordBean.id;
            }
        }
        return id;
    }

//    public long showMaxId() {
//        if (records.size() == 0) {
//            return 0;
//        }
//        long id = records.get(0).id;
//        for (RecordBean RecordBean : records) {
//            if (RecordBean.id > id) {
//                id = RecordBean.id;
//            }
//        }
//        return id;
//    }
}
