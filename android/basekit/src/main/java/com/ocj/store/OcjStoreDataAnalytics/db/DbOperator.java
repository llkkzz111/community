package com.ocj.store.OcjStoreDataAnalytics.db;


import com.ocj.store.OcjStoreDataAnalytics.base.OcjTrackData;

import java.util.List;

public interface DbOperator {
    public void close();

    public boolean isOpen();

    //向数据库中存入统计数据
    public void addTrackData(List<OcjTrackData> trackDataArray);

    //从数据库中获取缓存数据，此时置位synced为1
    public List<OcjTrackData> getTrackDataToUpload();

    //清除synced为1的数据，调用此方法说明已经上传成功了
    public void clearUploadTrackData();

    //充值synced为1的数据到0，说明上传数据失败了
    public void resetUploadTrackData();

}
