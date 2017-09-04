package com.ocj.store.OcjStoreDataAnalytics.db;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.text.TextUtils;
import android.util.Log;

import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataCenter;
import com.ocj.store.OcjStoreDataAnalytics.base.OcjTrackData;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.StreamCorruptedException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DbModel implements DbOperator {
    private String TAG = "DbModel";
    private Context mContext;
    private DB mDb;
    private boolean mOpened = false;

    public DbModel(Context context) {
        mContext = context;
        openDatabase();
    }

    private void openDatabase() {
        try {
            int count = 0;
            while (mDb == null && count < 3) {
                try {
                    mDb = new DB(mContext);
                    mOpened = true;
                    if (DB.mCreateDb) {
                        DB.mCreateDb = false;
                        initDefaultValue();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                count++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean isOpen() {
        return mOpened;
    }

    public void close() {
        if (mDb != null)
            mDb.close();
        mOpened = false;
    }

    private void initDefaultValue() {

    }


    public void addTrackData(List<OcjTrackData> trackDataArray) {
        if (trackDataArray == null) {
            Log.i(TAG, "trackDataArray is null");
            return;
        }
        for (OcjTrackData data : trackDataArray) {
            ContentValues values = new ContentValues();
            values.put(DbConfig.TYPE, data.getSign());
            if (TextUtils.equals(data.getSign(), OcjStoreDataCenter.OcjEventType_page)) {
                values.put(DbConfig.PAGE_NAME, ((DBTrackPageData) data).getPageId());
                values.put(DbConfig.START_TIME, ((DBTrackPageData) data).getStartTime());
                values.put(DbConfig.END_TIME, ((DBTrackPageData) data).getEndTime());
            } else {
                values.put(DbConfig.PAGE_NAME, ((DBTrackEventData) data).getEventId());
                values.put(DbConfig.LOG_TIME, ((DBTrackEventData) data).getEventTime());
                values.put(DbConfig.LABEL, ((DBTrackEventData) data).getLabel());
                values.put(DbConfig.PARAMETERS, serialize(((DBTrackEventData) data).getParameters()));
            }
            long result = mDb.insert(DB.TAB_TRACK_DATA, values);

            Log.i(TAG, "addTrackData result = " + result);
        }
    }

    public List<OcjTrackData> getTrackDataToUpload() {
        List<OcjTrackData> resultList = null;
        ContentValues values = new ContentValues();
        values.put(DbConfig.SYNCED, 1);
        mDb.update(DB.TAB_TRACK_DATA, values, null, null);
        Log.i(TAG, "in getTrackDataToUpload");

        Cursor cursor = mDb.query(DB.TAB_TRACK_DATA, DbConfig.PROJECTION_TRACK_DATA, DbConfig.SYNCED + "=1", null, null);
        if (cursor != null && cursor.getCount() > 0) {
            Log.i(TAG, "getTrackDataToUpload cursor count:" + cursor.getCount());
            resultList = new ArrayList<OcjTrackData>();
            if (cursor.moveToFirst()) {
                do {
                    OcjTrackData data = null;
                    String type = cursor.getString(cursor.getColumnIndex(DbConfig.TYPE));
                    if (TextUtils.equals(type, OcjStoreDataCenter.OcjEventType_page)) {
                        data = new DBTrackPageData();
                    } else {
                        data = new DBTrackEventData();
                    }
                    data.setSign(type);

                    if (TextUtils.equals(type, OcjStoreDataCenter.OcjEventType_page)) {
                        ((DBTrackPageData) data).setPageId(cursor.getString(cursor.getColumnIndex(DbConfig.PAGE_NAME)));
                        ((DBTrackPageData) data).setStartTime(cursor.getLong(cursor.getColumnIndex(DbConfig.START_TIME)));
                        ((DBTrackPageData) data).setEndTime(cursor.getLong(cursor.getColumnIndex(DbConfig.END_TIME)));
                    } else {
                        ((DBTrackEventData) data).setEventId(cursor.getString(cursor.getColumnIndex(DbConfig.PAGE_NAME)));
                        ((DBTrackEventData) data).setEventTime(cursor.getLong(cursor.getColumnIndex(DbConfig.LOG_TIME)));
                        ((DBTrackEventData) data).setLabel(cursor.getString(cursor.getColumnIndex(DbConfig.LABEL)));
                        ((DBTrackEventData) data).setParameters(deserialize(cursor.getBlob(cursor.getColumnIndex(DbConfig.PARAMETERS))));
                    }
                    resultList.add(data);
                    Log.i(TAG, "getTrackDataToUpload item");
                } while (cursor.moveToNext());
            }
        } else {
            Log.i(TAG, "getTrackDataToUpload cursor is null");
        }
        if (cursor != null)
            cursor.close();
        return resultList;
    }


    public void clearUploadTrackData() {
        mDb.deleteValue(DB.TAB_TRACK_DATA, DbConfig.SYNCED + "=1", null);
    }

    public void resetUploadTrackData() {
        ContentValues values = new ContentValues();
        values.put(DbConfig.SYNCED, 0);
        mDb.update(DB.TAB_TRACK_DATA, values, null, null);
    }

    public static byte[] serialize(Map<String, Object> hashMap) {
        if (hashMap == null) {
            return null;
        }
        try {
            ByteArrayOutputStream mem_out = new ByteArrayOutputStream();
            ObjectOutputStream out = new ObjectOutputStream(mem_out);

            out.writeObject(hashMap);

            out.close();
            mem_out.close();

            byte[] bytes = mem_out.toByteArray();
            return bytes;
        } catch (Exception e) {
            return null;
        }
    }

    public static Map<String, Object> deserialize(byte[] bytes) {
        if (bytes == null) {
            return null;
        }
        try {
            ByteArrayInputStream mem_in = new ByteArrayInputStream(bytes);
            ObjectInputStream in = new ObjectInputStream(mem_in);

            HashMap<String, Object> hashMap = (HashMap<String, Object>) in.readObject();

            in.close();
            mem_in.close();

            return hashMap;
        } catch (StreamCorruptedException e) {
            return null;
        } catch (ClassNotFoundException e) {
            return null;
        } catch (Exception e) {
            return null;
        }
    }

}

































