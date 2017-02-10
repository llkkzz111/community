package com.choudao.imsdk.dto.response;

import java.io.Serializable;

/**
 * Created by dufeng on 16/5/3.<br/>
 * Description: BaseResponse
 */
public class BaseResponse implements Serializable {
    private String code;
    private String desc;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }
}
