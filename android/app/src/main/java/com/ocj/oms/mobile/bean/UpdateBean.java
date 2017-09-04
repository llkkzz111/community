package com.ocj.oms.mobile.bean;


import com.ocj.oms.common.net.mode.ApiResult;

/**
 * Created by liuzhao on 16/3/25.
 */
public class UpdateBean extends ApiResult {
    private String latest;
    private String title;
    private String changes;

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
