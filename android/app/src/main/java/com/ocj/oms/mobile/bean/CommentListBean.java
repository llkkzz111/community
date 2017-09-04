package com.ocj.oms.mobile.bean;

import java.util.List;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/13 16:56
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:
 */

public class CommentListBean {
    private List<CommentBean> evaluate_list;

    public List<CommentBean> getList() {
        return evaluate_list;
    }

    public void setList(List<CommentBean> list) {
        this.evaluate_list = list;
    }

    @Override
    public String toString() {
        return "CommentListBean{" +
                "list=" + evaluate_list +
                '}';
    }
}
