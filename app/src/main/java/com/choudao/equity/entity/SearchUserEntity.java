package com.choudao.equity.entity;

/**
 * Created by dufeng on 16/9/28.<br/>
 * Description: SearchUserEntity
 */

public class SearchUserEntity {
    private Long id;
    private String img;
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImg() {
        return img;
    }

    public void setImg(String img) {
        this.img = img;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
