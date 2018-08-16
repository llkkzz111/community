package com.community.equity.entity;

/**
 * Created by dufeng on 16/7/13.<br/>
 * Description: ContactsItem
 */
public class ContactsItem<T> {

    public static final int VIEW_LIST_HEADER = 0;
    public static final int VIEW_CONTACTS_HEADER = 1;
    public static final int VIEW_CONTACTS_CONTENT = 2;
    public static final int VIEW_CONTACTS_SELECT = 3;

    public int sectionFirstPosition;

    public int itemType;

    public T info;

    public String headText;

    /**
     * 选择联系人用
     * 1:群固有的成员
     * 2:群没有的成员
     * 3:本次选择要加的成员
     */
    public int selectState;

    public ContactsItem() {
    }

    /**
     * 联系人的分类栏
     */
    public ContactsItem(int sectionFirstPosition, String headText) {
        this.sectionFirstPosition = sectionFirstPosition;
        this.itemType = VIEW_CONTACTS_HEADER;
        this.headText = headText;
    }

    /**
     * 联系人的具体内容
     */
    public ContactsItem(int sectionFirstPosition, T info) {
        this.sectionFirstPosition = sectionFirstPosition;
        this.itemType = VIEW_CONTACTS_CONTENT;
        this.info = info;
    }

    /**
     * 选择联系人的具体内容
     */
    public ContactsItem(int sectionFirstPosition, T info, int selectState) {
        this.sectionFirstPosition = sectionFirstPosition;
        this.itemType = VIEW_CONTACTS_SELECT;
        this.info = info;
        this.selectState = selectState;
    }

    /**
     * list的header
     */
    public ContactsItem(int sectionFirstPosition) {
        this.sectionFirstPosition = sectionFirstPosition;
        this.itemType = VIEW_LIST_HEADER;
    }
}
