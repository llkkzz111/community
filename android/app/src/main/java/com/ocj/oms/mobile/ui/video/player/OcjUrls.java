package com.ocj.oms.mobile.ui.video.player;

public class OcjUrls {

    private static final String TEST4SERVERADDRESS = "http://rm.ocj.com.cn";
    private static final String SERVERADDRESS = "http://m.ocj.com.cn";


    public static final String serverAddress = Constants.isDebug ? TEST4SERVERADDRESS : SERVERADDRESS;

    public static final String CHECKBARRAGETIME = serverAddress + "/restApi/checkTimes";//返回红包雨活动进行状态、倒计时等信息
    public static final String BARRAGERULEURL = serverAddress + "/eventbarragevideo/intf_rule?event_no=";//红包活动规则
    public static final String BARRAGEPRODUCTSURL = serverAddress + "/eventbarragevideo/intf_pdt?shop_no=";//红包推广商品链接
    public static final String BARRAGEURL = serverAddress + "/eventbarragevideo/intf_game?shop_no=%s&event_no=%s";//红包活动抽奖地址

    public static final String CHECKBARRAGEUSEABLE=serverAddress+"/eventbarragevideo/intf_check";//检查是否可以参加直播红包
    public static final String BARRAGEBASICINFOURL=serverAddress+"/eventbarragevideo/intf_main?shop_no=";//获取弹幕直播页面的基础信息

}
