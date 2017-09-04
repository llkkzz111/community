package com.ocj.oms.mobile.bean;

import java.io.Serializable;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/10 20:23
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:地区选择城市列表
 */

public class ResultBean implements Serializable{
    /**
     * code_lgroup : null
     * code_mgroup : 970
     * code_name : 安徽
     * code_sname : null
     * code_group : null
     * remark : null
     * remark1 : null
     * remark2 : null
     * use_yn : null
     * content : null
     * insert_date : null
     * insert_id : null
     * modify_date : null
     * modify_id : null
     * code_sort : 0
     * region_cd : 2000
     * sel_region_cd : 6011
     * remark1_v : 32
     * remark2_v : 011
     * remark3_v : A
     */

    private String code_lgroup;
    private String code_mgroup;
    private String code_name;//省份
    private String code_sname;
    private String code_group;
    private String remark;
    private String remark1;
    private String remark2;
    private String use_yn;
    private String content;
    private String insert_date;
    private String insert_id;
    private String modify_date;
    private String modify_id;
    private int code_sort;
    private String region_cd;
    private String sel_region_cd;
    private String remark1_v;
    private String remark2_v;
    private String remark3_v;

    public String getCode_lgroup() {
        return code_lgroup;
    }

    public void setCode_lgroup(String code_lgroup) {
        this.code_lgroup = code_lgroup;
    }

    public String getCode_mgroup() {
        return code_mgroup;
    }

    public void setCode_mgroup(String code_mgroup) {
        this.code_mgroup = code_mgroup;
    }

    public String getCode_name() {
        return code_name;
    }

    public void setCode_name(String code_name) {
        this.code_name = code_name;
    }

    public String getCode_sname() {
        return code_sname;
    }

    public void setCode_sname(String code_sname) {
        this.code_sname = code_sname;
    }

    public String getCode_group() {
        return code_group;
    }

    public void setCode_group(String code_group) {
        this.code_group = code_group;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getRemark1() {
        return remark1;
    }

    public void setRemark1(String remark1) {
        this.remark1 = remark1;
    }

    public String getRemark2() {
        return remark2;
    }

    public void setRemark2(String remark2) {
        this.remark2 = remark2;
    }

    public String getUse_yn() {
        return use_yn;
    }

    public void setUse_yn(String use_yn) {
        this.use_yn = use_yn;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getInsert_date() {
        return insert_date;
    }

    public void setInsert_date(String insert_date) {
        this.insert_date = insert_date;
    }

    public String getInsert_id() {
        return insert_id;
    }

    public void setInsert_id(String insert_id) {
        this.insert_id = insert_id;
    }

    public String getModify_date() {
        return modify_date;
    }

    public void setModify_date(String modify_date) {
        this.modify_date = modify_date;
    }

    public String getModify_id() {
        return modify_id;
    }

    public void setModify_id(String modify_id) {
        this.modify_id = modify_id;
    }

    public int getCode_sort() {
        return code_sort;
    }

    public void setCode_sort(int code_sort) {
        this.code_sort = code_sort;
    }

    public String getRegion_cd() {
        return region_cd;
    }

    public void setRegion_cd(String region_cd) {
        this.region_cd = region_cd;
    }

    public String getSel_region_cd() {
        return sel_region_cd;
    }

    public void setSel_region_cd(String sel_region_cd) {
        this.sel_region_cd = sel_region_cd;
    }

    public String getRemark1_v() {
        return remark1_v;
    }

    public void setRemark1_v(String remark1_v) {
        this.remark1_v = remark1_v;
    }

    public String getRemark2_v() {
        return remark2_v;
    }

    public void setRemark2_v(String remark2_v) {
        this.remark2_v = remark2_v;
    }

    public String getRemark3_v() {
        return remark3_v;
    }

    public void setRemark3_v(String remark3_v) {
        this.remark3_v = remark3_v;
    }

    @Override
    public String toString() {
        return "ResultBean{" +
                "code_lgroup=" + code_lgroup +
                ", code_mgroup='" + code_mgroup + '\'' +
                ", code_name='" + code_name + '\'' +
                ", code_sname=" + code_sname +
                ", code_group=" + code_group +
                ", remark=" + remark +
                ", remark1=" + remark1 +
                ", remark2=" + remark2 +
                ", use_yn=" + use_yn +
                ", content=" + content +
                ", insert_date=" + insert_date +
                ", insert_id=" + insert_id +
                ", modify_date=" + modify_date +
                ", modify_id=" + modify_id +
                ", code_sort=" + code_sort +
                ", region_cd='" + region_cd + '\'' +
                ", sel_region_cd='" + sel_region_cd + '\'' +
                ", remark1_v='" + remark1_v + '\'' +
                ", remark2_v='" + remark2_v + '\'' +
                ", remark3_v='" + remark3_v + '\'' +
                '}';
    }
}
