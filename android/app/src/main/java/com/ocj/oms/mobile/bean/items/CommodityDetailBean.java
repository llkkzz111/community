package com.ocj.oms.mobile.bean.items;

import java.io.Serializable;

/**
 * Created by liu on 2017/6/11.
 * 商品详情bean 内含颜色尺寸规格,由于返回数据过多，直截取需要的字段，可添加进去
 * http://10.22.218.162/api/items/items/appdetail/15174707?orderno=1&dmnid=1&media_channel=1&source_obj=http://localhost:9091&isPufa=1&isBone=0&access_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMDE3MDMwNTY5NjQiLCJpc3MiOiJvY2otc3RhcnNreSIsImV4cCI6MTQ5OTc2ODU3OSwiaWF0IjoxNDk3MTc2NTc5LCJkZXZpY2VpZCI6IjEyMyJ9.01i8pLMZ0QC2IZhzGrkBV-Jzsz7VGZrvVzHEloUZkfA&area_lgroup=38&area_mgroup=022&area_sgroup=028
 */

public class CommodityDetailBean implements Serializable {
    public ColorsSizeBean colorsize;
    public String source_url;
    public int min_num_controll;
    public int max_num_controll;
    public String giftPromo_no;
    public String giftPromo_seq;
    public TreceiverBean defaultTreceiver;

    public ColorsSizeBean getColorsize() {
        return colorsize;
    }

    public void setColorsize(ColorsSizeBean colorsize) {
        this.colorsize = colorsize;
    }

    public int getMin_num_controll() {
        return min_num_controll;
    }

    public void setMin_num_controll(int min_num_controll) {
        this.min_num_controll = min_num_controll;
    }

    public int getMax_num_controll() {
        return max_num_controll;
    }

    public void setMax_num_controll(int max_num_controll) {
        this.max_num_controll = max_num_controll;
    }

    public String getSource_url() {
        return source_url;
    }

    public void setSource_url(String source_url) {
        this.source_url = source_url;
    }

    public class TreceiverBean {
        public String addr_m;//: "上海市",
        public String receiverAddr;//: null,
        public String insertDate;//: null,
        public String area_lgroup;//: "10",
        public String area_mgroup;//: "001",
        public String area_sgroup;//: "003"
    }

}
