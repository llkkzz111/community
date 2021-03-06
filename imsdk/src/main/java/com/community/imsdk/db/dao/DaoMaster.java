package com.community.imsdk.db.dao;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteStatement;
import android.util.Log;

import com.community.imsdk.utils.Logger;
import com.community.imsdk.utils.SharedPreferencesUtils;

import de.greenrobot.dao.AbstractDaoMaster;
import de.greenrobot.dao.identityscope.IdentityScopeType;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.

/**
 * Master of DAO (schema version 6): knows all DAOs.
 */
public class DaoMaster extends AbstractDaoMaster {
    public static final String TAG = "===DaoMaster===";
    public static final int SCHEMA_VERSION = 6;

    /** Creates underlying database table using DAOs. */
    public static void createAllTables(SQLiteDatabase db, boolean ifNotExists) {
        MessageDao.createTable(db, ifNotExists);
        SessionInfoDao.createTable(db, ifNotExists);
        SessionConfigDao.createTable(db, ifNotExists);
        ContactDao.createTable(db, ifNotExists);
        UserInfoDao.createTable(db, ifNotExists);
        MobileUserInfoDao.createTable(db, ifNotExists);
        GroupInfoDao.createTable(db, ifNotExists);
        GroupMemberDao.createTable(db, ifNotExists);
        JsonEntityDao.createTable(db, ifNotExists);
    }

    /** Drops underlying database table using DAOs. */
    public static void dropAllTables(SQLiteDatabase db, boolean ifExists) {
        MessageDao.dropTable(db, ifExists);
        SessionInfoDao.dropTable(db, ifExists);
        SessionConfigDao.dropTable(db, ifExists);
        ContactDao.dropTable(db, ifExists);
        UserInfoDao.dropTable(db, ifExists);
        MobileUserInfoDao.dropTable(db, ifExists);
        GroupInfoDao.dropTable(db, ifExists);
        GroupMemberDao.dropTable(db, ifExists);
        JsonEntityDao.dropTable(db, ifExists);
    }

    public static abstract class OpenHelper extends SQLiteOpenHelper {

        public OpenHelper(Context context, String name, CursorFactory factory) {
            super(context, name, factory, SCHEMA_VERSION);
        }

        @Override
        public void onCreate(SQLiteDatabase db) {
            Log.i("greenDAO", "Creating tables for schema version " + SCHEMA_VERSION);
            createAllTables(db, false);
        }
    }

    /** WARNING: Drops all table on Upgrade! Use only during development. */
    public static class UpgradeHelper extends OpenHelper {
        public UpgradeHelper(Context context, String name, CursorFactory factory) {
            super(context, name, factory);
        }

        @Override
        public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
            Logger.e(TAG, "Upgrading schema from version " + oldVersion + " to " + newVersion + " by dropping all tables");
            SharedPreferencesUtils.setContactsVersion(-1);
            if (oldVersion < 5) {
                if (newVersion - oldVersion > 2) {
                    dropAllTables(db, true);
                    onCreate(db);
                } else {
                    MigrationHelper.getInstance().migrate(db,
                            JsonEntityDao.class,
                            UserInfoDao.class,
                            PrivateMessageDao.class,
                            SessionInfoDao.class);
                }
            }

            switch (oldVersion) {
                case 5:
                    db.execSQL("ALTER TABLE PRIVATE_MESSAGE RENAME TO MESSAGE");
                    MigrationHelper.getInstance().migrate(db,
                            UserInfoDao.class,
                            MessageDao.class,
                            SessionConfigDao.class,
                            SessionInfoDao.class);
                    execUpdateSQL(db, "UPDATE MESSAGE SET SHOW_SESSION_TYPE=SESSION_TYPE WHERE SHOW_SESSION_TYPE IS NULL");
                    execUpdateSQL(db, "UPDATE MESSAGE SET SHOW_TYPE=CONTENT_TYPE WHERE SHOW_TYPE IS NULL");
            }

        }
    }

    public DaoMaster(SQLiteDatabase db) {
        super(db, SCHEMA_VERSION);
        registerDaoClass(MessageDao.class);
        registerDaoClass(SessionInfoDao.class);
        registerDaoClass(SessionConfigDao.class);
        registerDaoClass(ContactDao.class);
        registerDaoClass(UserInfoDao.class);
        registerDaoClass(MobileUserInfoDao.class);
        registerDaoClass(GroupInfoDao.class);
        registerDaoClass(GroupMemberDao.class);
        registerDaoClass(JsonEntityDao.class);
    }

    public DaoSession newSession() {
        return new DaoSession(db, IdentityScopeType.Session, daoConfigMap);
    }

    public DaoSession newSession(IdentityScopeType type) {
        return new DaoSession(db, type, daoConfigMap);
    }

    public static int execUpdateSQL(SQLiteDatabase db, String sql) {
        SQLiteStatement statement = db.compileStatement(sql);
        try {
            return statement.executeUpdateDelete();
        } finally {
            statement.close();
        }
    }

}
