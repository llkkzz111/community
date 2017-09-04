package com.ocj.oms.mobile.ui.createcomment;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/8 21:11
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:创建评论适配器回调
 */

public interface IcommentAdpterBack {
    void getText(String s, int position);
    void getRating(Float f, int positon, int type);
    void getPhoto(int position);
}
