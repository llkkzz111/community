package com.ocj.oms.mobile.ui.video.player;

import java.io.Serializable;

/**
 * Created by Administrator on 2017/6/22.
 */

public class BarrageTimeBean implements Serializable {

    private String code;
    private String end_batch_flag;
    private String batch_no;
    private String second;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getEnd_batch_flag() {
        return end_batch_flag;
    }

    public void setEnd_batch_flag(String end_batch_flag) {
        this.end_batch_flag = end_batch_flag;
    }

    public String getBatch_no() {
        return batch_no;
    }

    public void setBatch_no(String batch_no) {
        this.batch_no = batch_no;
    }

    public String getSecond() {
        return second;
    }

    public void setSecond(String second) {
        this.second = second;
    }
}
