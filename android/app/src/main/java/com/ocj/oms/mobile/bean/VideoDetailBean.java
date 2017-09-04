package com.ocj.oms.mobile.bean;

/**
 * Created by liutao on 2017/7/13.
 */

public class VideoDetailBean {

    /**
     * video_picpath :  http://static.statickksmg.com/image/2017/07/08/1c8c7a9ae2405de6280e0a0f88a66386.jpg
     * video_url : http://domhttp.kksmg.com/2017/07/08/ocj_450k_2425b1fbf813f6f3d8c0911b872decef.mp4|http://domhttp.kksmg.com/2017/07/08/ocj_800k_2425b1fbf813f6f3d8c0911b872decef.mp4
     */

    private String video_picpath;
    private String video_url;
    private boolean isSelect;

    public String getVideo_picpath() {
        return video_picpath;
    }

    public void setVideo_picpath(String video_picpath) {
        this.video_picpath = video_picpath;
    }

    public String getVideo_url() {
        return video_url;
    }

    public void setVideo_url(String video_url) {
        this.video_url = video_url;
    }

    public boolean isSelect() {
        return isSelect;
    }

    public void setSelect(boolean select) {
        isSelect = select;
    }
}
