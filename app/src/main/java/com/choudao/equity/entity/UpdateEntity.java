package com.choudao.equity.entity;

import com.alibaba.fastjson.annotation.JSONField;
import com.choudao.equity.base.BaseApiResponse;

/**
 * Created by liuzhao on 16/3/25.
 */
public class UpdateEntity extends BaseApiResponse {
    private String latest;
    private String title;
    private String changes;
    @JSONField(name = "must_update")
    private Boolean must_update;
    private String download_url;

    public Boolean getMustUpdate() {
        return must_update;
    }

    public void setMust_update(Boolean must_update) {
        this.must_update = must_update;
    }

    public String getDownload_url() {
        return download_url;
    }

    public void setDownload_url(String download_url) {
        this.download_url = download_url;
    }


    public String getLatest() {
        return latest;
    }

    public void setLatest(String latest) {
        this.latest = latest;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getChanges() {
        return changes;
    }

    public void setChanges(String changes) {
        this.changes = changes;
    }
}
