package com.community.imsdk.dto.response;

import java.util.List;

/**
 * Created by dufeng on 16/7/19.<br/>
 * Description: PullSessionConfigResponse
 */
public class PullSessionConfigResponse extends BaseResponse {
    private List<ConfigBean> configs;

    public List<ConfigBean> getConfigs() {
        return configs;
    }

    public void setConfigs(List<ConfigBean> configs) {
        this.configs = configs;
    }

    public static class ConfigBean {
        private long id;
        private long targetId;
        private int sessionType;
        private boolean mute;
        private boolean top;

        public long getId() {
            return id;
        }

        public void setId(long id) {
            this.id = id;
        }

        public long getTargetId() {
            return targetId;
        }

        public void setTargetId(long targetId) {
            this.targetId = targetId;
        }

        public int getSessionType() {
            return sessionType;
        }

        public void setSessionType(int sessionType) {
            this.sessionType = sessionType;
        }

        public boolean isMute() {
            return mute;
        }

        public void setMute(boolean mute) {
            this.mute = mute;
        }

        public boolean isTop() {
            return top;
        }

        public void setTop(boolean top) {
            this.top = top;
        }
    }

    public long showMinId() {
        if (configs.size() == 0) {
            return 0;
        }
        long id = configs.get(configs.size() - 1).id;
        for (ConfigBean configRequest : configs) {
            if (configRequest.id < id) {
                id = configRequest.id;
            }
        }
        return id;
    }
}
