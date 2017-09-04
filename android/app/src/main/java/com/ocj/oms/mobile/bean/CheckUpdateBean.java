package com.ocj.oms.mobile.bean;

/**
 * Created by liutao on 2017/7/2.
 */

public class CheckUpdateBean {

    /**
     * app_ver_url : http://www.baidu.com?A=
     * is_new : true
     * app_ver_target : MARKET
     * platform : IOS
     * enabled_flag : 0
     * app_ver_tip : 我提未wh未个JJJ
     * app_ver_remark : BEIZHU
     * app_ver : 1.1.5
     * update_yn : 0
     */

    private String app_ver_url;
    private boolean is_new;
    private String app_ver_target;
    private String platform;
    private String enabled_flag;
    private String app_ver_tip;
    private String app_ver_remark;
    private String app_ver;
    private String update_yn;
    private String prompt_comment_app;

    public String getApp_ver_url() {
        return app_ver_url;
    }

    public void setApp_ver_url(String app_ver_url) {
        this.app_ver_url = app_ver_url;
    }

    public boolean isIs_new() {
        return is_new;
    }

    public void setIs_new(boolean is_new) {
        this.is_new = is_new;
    }

    public String getApp_ver_target() {
        return app_ver_target;
    }

    public void setApp_ver_target(String app_ver_target) {
        this.app_ver_target = app_ver_target;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }

    public String getEnabled_flag() {
        return enabled_flag;
    }

    public void setEnabled_flag(String enabled_flag) {
        this.enabled_flag = enabled_flag;
    }

    public String getApp_ver_tip() {
        return app_ver_tip;
    }

    public void setApp_ver_tip(String app_ver_tip) {
        this.app_ver_tip = app_ver_tip;
    }

    public String getApp_ver_remark() {
        return app_ver_remark;
    }

    public void setApp_ver_remark(String app_ver_remark) {
        this.app_ver_remark = app_ver_remark;
    }

    public String getApp_ver() {
        return app_ver;
    }

    public void setApp_ver(String app_ver) {
        this.app_ver = app_ver;
    }

    public String getUpdate_yn() {
        return update_yn;
    }

    public void setUpdate_yn(String update_yn) {
        this.update_yn = update_yn;
    }

    public String getPrompt_comment_app() {
        return prompt_comment_app;
    }

    public void setPrompt_comment_app(String prompt_comment_app) {
        this.prompt_comment_app = prompt_comment_app;
    }
}
