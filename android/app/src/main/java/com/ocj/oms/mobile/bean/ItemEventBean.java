package com.ocj.oms.mobile.bean;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * Created by liu on 2017/6/28.
 */

public class ItemEventBean implements Serializable{

    public EventMapItem ljljMap;
    public EventMapItem jjgMap;
    public ArrayList<EventMapItem> zhgMap;
    public ArrayList<EventMapItem> zpMap;
    public ArrayList<EventMapItem> jfMap;
    public ArrayList<EventMapItem> dzMap;
    public ArrayList<EventMapItem> cgjMap;


    public static class EventMapItem implements Serializable{
        public String id;//,促销编号
        public String name;//:"2件立减",相同商品
        public String bt;//:"2017-06-01 15:25:25",
        public String et;//:"2017-09-01 15:25:25",
        public String value;//="50" //两件减多少钱
        public ArrayList<Integer> range;
        public String gift_img;
        public String gift_gb;//": "60",
        public String gift_item_code;
        public String gift_item_name;
        public String unit_code;
        public String qty;
        public boolean checked;
    }

}
