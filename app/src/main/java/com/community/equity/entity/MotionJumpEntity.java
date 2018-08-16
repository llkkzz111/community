package com.community.equity.entity;

import com.community.equity.base.BaseApiResponse;

/**
 * Created by liuzhao on 16/5/2.
 */
public class MotionJumpEntity extends BaseApiResponse {
    private int id;
    private int question_id;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuestion_id() {
        return question_id;
    }

    public void setQuestion_id(int question_id) {
        this.question_id = question_id;
    }


}
