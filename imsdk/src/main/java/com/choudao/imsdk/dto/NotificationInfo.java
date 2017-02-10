package com.choudao.imsdk.dto;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by dufeng on 16/6/7.<br/>
 * Description: NotificationInfo
 */
public class NotificationInfo implements Serializable {
    public static final String PRIVATE_MSG = "PRIVATE_MSG";
    public static final String GROUP_MSG = "GROUP_MSG";
    public static final String NO_CONTENT_MSG = "NO_CONTENT_MSG";

    public String imgUrl;
    public String title;
    public String content;
    public String type;
    public Map<String, Object> data = new HashMap<>();
}
