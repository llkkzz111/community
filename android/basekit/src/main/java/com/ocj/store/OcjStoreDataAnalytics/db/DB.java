package com.ocj.store.OcjStoreDataAnalytics.db;


import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.text.TextUtils;

public class DB {
    private static final String DATABASE_NAME = "OcjTrackData.db";
    private static final int DATABASE_VERSION = 1;

    public static final String TAB_TRACK_DATA = "tab_track_data";

    public static boolean mCreateDb = false;

    private Context mContext;
    private DatabaseHelper mOpenHelper = null;
    private SQLiteDatabase mDb = null;

    public DB(Context context) {
        mContext = context;
        if (mOpenHelper == null)
            mOpenHelper = new DatabaseHelper(mContext);
        mDb = mOpenHelper.getWritableDatabase();
    }

    private static class DatabaseHelper extends SQLiteOpenHelper {
        DatabaseHelper(Context context) {
            super(context, DATABASE_NAME, null, DATABASE_VERSION);
        }

        @Override
        public void onCreate(SQLiteDatabase db) {
            try {
                db.execSQL("CREATE TABLE " + TAB_TRACK_DATA + " ("
                        + DbConfig._ID + " INTEGER PRIMARY KEY,"
                        + DbConfig.TYPE + " INTEGER,"
                        + DbConfig.SYNCED + " TEXT,"
                        + DbConfig.LOG_TIME + " LONG,"
                        + DbConfig.SYNC_TIME + " LONG,"
                        + DbConfig.EVENT_ID + " TEXT,"
                        + DbConfig.LABEL + " TEXT,"
                        + DbConfig.PARAMETERS + " BLOB,"
                        + DbConfig.PAGE_NAME + " TEXT,"
                        + DbConfig.START_TIME + " LONG,"
                        + DbConfig.END_TIME + " LONG);");
                mCreateDb = true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
            onCreate(db);
        }
    }

    public Cursor query(String tableName, String[] projection, String selection, String[] selectionArgs, String sortOrder) {
        if (tableName.length() == 0 || projection.length == 0)
            return null;
        String orderBy = "";
        if (TextUtils.isEmpty(sortOrder)) {
            orderBy = null;
        } else {
            orderBy = sortOrder;
        }
        Cursor c = null;
        try {
            c = mDb.query(tableName, projection, selection, selectionArgs, null, null, orderBy);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }

    public long insert(String tabName, ContentValues values) {
        long rowId = -1;
        if (tabName.length() > 0)
            rowId = mDb.insert(tabName, "", values);

        return rowId;
    }

    public int update(String tableName, ContentValues values, String where, String[] whereArgs) {
        int count = mDb.update(tableName, values, where, whereArgs);
        return count;
    }

    public int delete(int type, String where, String[] whereArgs) {
        int count = 0;
        String tabName = "";
        switch (type) {
            case DbConfig.TAB_TYPE.TYPE_TRACK_DATA:
                tabName = TAB_TRACK_DATA;
                break;
        }
        if (tabName.length() > 0) {
            try {
                count = mDb.delete(tabName, where, whereArgs);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return count;
    }

    public int deleteValue(String tabName, String where, String[] whereArgs) {
        int count = 0;
        try {
            count = mDb.delete(tabName, where, whereArgs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public void deleteAll(String tableName) {
        mDb.delete(tableName, null, null);
    }

    public void close() {
        mDb.close();
        mOpenHelper = null;
    }

}
