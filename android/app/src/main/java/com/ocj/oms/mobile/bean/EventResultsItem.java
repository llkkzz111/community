package com.ocj.oms.mobile.bean;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by xiao on 2017/8/17.
 */

public class EventResultsItem implements Parcelable{
    public String eventName;
    public String prizeName;
    public String murl;
    public String mark;

    public EventResultsItem(String eventName, String prizeName, String murl, String text) {
        this.eventName = eventName;
        this.prizeName = prizeName;
        this.murl = murl;
        this.mark = text;
    }

    protected EventResultsItem(Parcel in) {
        eventName = in.readString();
        prizeName = in.readString();
        murl = in.readString();
        mark = in.readString();
    }

    public static final Creator<EventResultsItem> CREATOR = new Creator<EventResultsItem>() {
        @Override
        public EventResultsItem createFromParcel(Parcel in) {
            return new EventResultsItem(in);
        }

        @Override
        public EventResultsItem[] newArray(int size) {
            return new EventResultsItem[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(eventName);
        dest.writeString(prizeName);
        dest.writeString(murl);
        dest.writeString(mark);
    }
}
