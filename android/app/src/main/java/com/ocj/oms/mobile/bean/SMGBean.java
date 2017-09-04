package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * Created by shizhang.cai on 2017/6/14.
 */

public class SMGBean {
    private String success;
    /**
     * event_no : 2016030410001
     * prizeName : 75元抵用券礼包
     * price : 5860
     * type : HM
     */

    private String event_no;
    private String prizeName;
    private String price;
    private String type;
    /**
     * event_name : 摇一摇抢红包
     * win_cnt : 1
     * draw_cnt : 2
     * start_date : 2017-3-17 00:00:00
     * end_date : 2017-3-31 23:59:59
     * batch_no : ”1”
     * prizeinfos : [{"prize_id":"GS20170317000005","prize_name":"满99减5元","prize_type":"B","prize_type_name":"鸥券","prize_amt":0,"prize_cnt":0}]
     * msg_code : 10000
     * msg : 恭喜你获得满99减5元
     */

    private String event_name;
    private int win_cnt;
    private int draw_cnt;
    private String start_date;
    private String end_date;
    private String batch_no;
    private int msg_code;
    private String msg;
    private List<PrizeinfosBean> prizeinfos;


    public String getSuccess() {
        return success;
    }

    public void setSuccess(String success) {
        this.success = success;
    }

    public String getEvent_no() {
        return event_no;
    }

    public void setEvent_no(String event_no) {
        this.event_no = event_no;
    }

    public String getPrizeName() {
        return prizeName;
    }

    public void setPrizeName(String prizeName) {
        this.prizeName = prizeName;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getEvent_name() {
        return event_name;
    }

    public void setEvent_name(String event_name) {
        this.event_name = event_name;
    }

    public int getWin_cnt() {
        return win_cnt;
    }

    public void setWin_cnt(int win_cnt) {
        this.win_cnt = win_cnt;
    }

    public int getDraw_cnt() {
        return draw_cnt;
    }

    public void setDraw_cnt(int draw_cnt) {
        this.draw_cnt = draw_cnt;
    }

    public String getStart_date() {
        return start_date;
    }

    public void setStart_date(String start_date) {
        this.start_date = start_date;
    }

    public String getEnd_date() {
        return end_date;
    }

    public void setEnd_date(String end_date) {
        this.end_date = end_date;
    }

    public String getBatch_no() {
        return batch_no;
    }

    public void setBatch_no(String batch_no) {
        this.batch_no = batch_no;
    }

    public int getMsg_code() {
        return msg_code;
    }

    public void setMsg_code(int msg_code) {
        this.msg_code = msg_code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public List<PrizeinfosBean> getPrizeinfos() {
        return prizeinfos;
    }

    public void setPrizeinfos(List<PrizeinfosBean> prizeinfos) {
        this.prizeinfos = prizeinfos;
    }

    public static class PrizeinfosBean {
        /**
         * prize_id : GS20170317000005
         * prize_name : 满99减5元
         * prize_type : B
         * prize_type_name : 鸥券
         * prize_amt : 0
         * prize_cnt : 0
         */

        private String prize_id;
        private String prize_name;
        private String prize_type;
        private String prize_type_name;
        private int prize_amt;
        private int prize_cnt;

        public String getPrize_id() {
            return prize_id;
        }

        public void setPrize_id(String prize_id) {
            this.prize_id = prize_id;
        }

        public String getPrize_name() {
            return prize_name;
        }

        public void setPrize_name(String prize_name) {
            this.prize_name = prize_name;
        }

        public String getPrize_type() {
            return prize_type;
        }

        public void setPrize_type(String prize_type) {
            this.prize_type = prize_type;
        }

        public String getPrize_type_name() {
            return prize_type_name;
        }

        public void setPrize_type_name(String prize_type_name) {
            this.prize_type_name = prize_type_name;
        }

        public int getPrize_amt() {
            return prize_amt;
        }

        public void setPrize_amt(int prize_amt) {
            this.prize_amt = prize_amt;
        }

        public int getPrize_cnt() {
            return prize_cnt;
        }

        public void setPrize_cnt(int prize_cnt) {
            this.prize_cnt = prize_cnt;
        }
    }
}
