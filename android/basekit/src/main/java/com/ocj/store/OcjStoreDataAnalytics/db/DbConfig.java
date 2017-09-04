package com.ocj.store.OcjStoreDataAnalytics.db;

import android.provider.BaseColumns;

public final class DbConfig implements BaseColumns {
    //
    public static final String TYPE = "type";
    public static final String SYNCED = "synced";
    public static final String LOG_TIME = "logTime";
    public static final String SYNC_TIME = "SyncTime";
    public static final String EVENT_ID = "eventId";
    public static final String LABEL = "label";
    public static final String PARAMETERS = "parameters";
    public static final String PAGE_NAME = "pageName";
    public static final String START_TIME = "startTime";
    public static final String END_TIME = "endTime";


    public static final String[] PROJECTION_TRACK_DATA = new String[]{
            _ID,
            TYPE,
            SYNCED,
            LOG_TIME,
            SYNC_TIME,
            EVENT_ID,
            LABEL,
            PARAMETERS,
            PAGE_NAME,
            START_TIME,
            END_TIME
    };

    public static final class TAB_TYPE {
        public static final int TYPE_TRACK_DATA = 1;
    }
}
