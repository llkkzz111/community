package com.ocj.store.OcjStoreDataAnalytics.db;

import android.content.Context;

public class DbFactory {

    public static DbOperator NewDbOperator(Context context) {
        return new DbModel(context);
    }
}
