package com.choudao.equity.entity;

import com.choudao.equity.base.BaseApiResponse;

import java.io.Serializable;

/**
 * Created by liuzhao on 16/5/20.
 */
public class ShareEntity extends BaseApiResponse implements Serializable {
    private String share_url;

    public String getShare_url() {
        return share_url;
    }

    public void setShare_url(String share_url) {
        this.share_url = share_url;
    }
}
