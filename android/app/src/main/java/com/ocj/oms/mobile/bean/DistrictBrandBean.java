package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by liu on 2017/7/21.
 */

public class DistrictBrandBean {

    public List<RegionBean> regionlist;
    public List<PropertyBean> globalbrandinfo;

    public class RegionBean {
        public String region_name;//": "美国",
        public String region_code;//": "0001"

        public String getRegion_name() {
            return region_name;
        }

        public void setRegion_name(String region_name) {
            this.region_name = region_name;
        }

        public String getRegion_code() {
            return region_code;
        }

        public void setRegion_code(String region_code) {
            this.region_code = region_code;
        }
    }

    public class PropertyBean {
        public String propertyName;//": "美国",
        public List<String> propertyValue;//": "0001"

        public String getPropertyName() {
            return propertyName;
        }

        public void setPropertyName(String propertyName) {
            this.propertyName = propertyName;
        }

        public List<String> getPropertyValue() {
            return propertyValue;
        }

        public void setPropertyValue(List<String> propertyValue) {
            this.propertyValue = propertyValue;
        }
    }

    public List<RegionBean> getRegionlist() {
        return regionlist;
    }

    public void setRegionlist(List<RegionBean> regionlist) {
        this.regionlist = regionlist;
    }

    public List<PropertyBean> getGlobalbrandinfo() {
        return globalbrandinfo;
    }

    public void setGlobalbrandinfo(List<PropertyBean> globalbrandinfo) {
        this.globalbrandinfo = globalbrandinfo;
    }
}
