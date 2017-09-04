package com.ocj.oms.mobile.bean;


/**
 * Created by pactera on 2017/4/20.
 * <p>
 * 生成地区的实体
 */

public class AreaBean {

    private String area_lgroup;
    private String area_mgroup;
    private String area_sgroup;

    private String lgroup_name;
    private String mgroup_name;
    private String sgroup_name;
    private String selectId;

    public String getSelectId() {
        return selectId;
    }

    public void setSelectId(String selectId) {
        this.selectId = selectId;
    }

    public String getSelectName() {
        return selectName;
    }

    public void setSelectName(String selectName) {
        this.selectName = selectName;
    }

    private String selectName;

    public AreaBean() {
    }

    public AreaBean(String AREA_LGROUP, String AREA_MGROUP, String AREA_SGROUP, String LGROUP_NAME, String MGROUP_NAME, String SGROUP_NAME) {
        this.area_lgroup = AREA_LGROUP;
        this.area_mgroup = AREA_MGROUP;
        this.area_sgroup = AREA_SGROUP;
        this.lgroup_name = LGROUP_NAME;
        this.mgroup_name = MGROUP_NAME;
        this.sgroup_name = SGROUP_NAME;
    }

    public AreaBean(String id, String areaName) {
        this.selectId = id;
        this.selectName = areaName;
    }


    public String getAREA_LGROUP() {
        return area_lgroup;
    }

    public void setAREA_LGROUP(String AREA_LGROUP) {
        this.area_lgroup = AREA_LGROUP;
    }

    public String getAREA_MGROUP() {
        return area_mgroup;
    }

    public void setAREA_MGROUP(String AREA_MGROUP) {
        this.area_mgroup = AREA_MGROUP;
    }

    public String getAREA_SGROUP() {
        return area_sgroup;
    }

    public void setAREA_SGROUP(String AREA_SGROUP) {
        this.area_sgroup = AREA_SGROUP;
    }

    public String getLGROUP_NAME() {
        return lgroup_name;
    }

    public void setLGROUP_NAME(String LGROUP_NAME) {
        this.lgroup_name = LGROUP_NAME;
    }

    public String getMGROUP_NAME() {
        return mgroup_name;
    }

    public void setMGROUP_NAME(String MGROUP_NAME) {
        this.mgroup_name = MGROUP_NAME;
    }

    public String getSGROUP_NAME() {
        return sgroup_name;
    }

    public void setSGROUP_NAME(String SGROUP_NAME) {
        this.sgroup_name = SGROUP_NAME;
    }


}
