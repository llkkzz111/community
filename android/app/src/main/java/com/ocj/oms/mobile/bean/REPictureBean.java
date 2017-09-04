package com.ocj.oms.mobile.bean;

import java.util.ArrayList;

/**
 * Created by liu on 2017/6/9.
 * 退换货图片上传返回数据
 */

public class REPictureBean {
    private String result;
    private ArrayList<String> CommentPictureList;

    public String getResult() {
        return result;
    }

    public void setResult(String result) {
        this.result = result;
    }

    public ArrayList<String> getCommentPictureList() {
        return CommentPictureList;
    }

    public void setCommentPictureList(ArrayList<String> commentPictureList) {
        this.CommentPictureList = commentPictureList;
    }

    @Override
    public String toString() {
        return "REPictureBean{" +
                "result='" + result + '\'' +
                ", CommentPictureList=" + CommentPictureList +
                '}';
    }
}
