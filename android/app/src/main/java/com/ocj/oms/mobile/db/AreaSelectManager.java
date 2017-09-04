package com.ocj.oms.mobile.db;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.ocj.oms.mobile.base.AssetsDatabaseManager;
import com.ocj.oms.mobile.bean.AreaBean;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by pactera on 2017/4/21.
 */

public class AreaSelectManager {

    static AreaSelectManager instance;

    Context mContext;
    SQLiteDatabase db;

    private AreaSelectManager(Context context) {
        mContext = context;
        AssetsDatabaseManager.initManager(context);
        AssetsDatabaseManager mg = AssetsDatabaseManager.getManager();
        db = mg.getDatabase("OCJAddress.db");
    }

    /***
     * 获取地址选择器的单例
     * @param context
     * @return
     */
    public static AreaSelectManager getAreaSelecter(Context context) {
        if (instance == null) {
            instance = new AreaSelectManager(context);
        }
        return instance;
    }

    /**
     * 选择省列表
     *
     * @return
     */
    public List<AreaBean> getPrivinceList() {
        List<AreaBean> privinceList = new ArrayList<AreaBean>();
        AreaBean bean;
        Cursor cursor = null;
        try {
            cursor = db.rawQuery("select DISTINCT AREA_LGROUP, LGROUP_NAME from tdelyarea", new String[]{});
            while (cursor.moveToNext()) {
                String largeId = cursor.getString(cursor.getColumnIndex("AREA_LGROUP"));
                String largeName = cursor.getString(cursor.getColumnIndex("LGROUP_NAME"));
                bean = new AreaBean(largeId, largeName);
                privinceList.add(bean);
            }
        } catch (Exception e) {
            cursor.close();
            e.printStackTrace();
        } finally {
            cursor.close();
        }
        return privinceList;
    }


    /**
     * 选择城市列表
     *
     * @return
     */
    public List<AreaBean> getCityList(String areaId) {
        List<AreaBean> cityList = new ArrayList<AreaBean>();
        AreaBean bean;
        Cursor cursor = null;
        try {
            cursor = db.rawQuery("select DISTINCT AREA_MGROUP, MGROUP_NAME from tdelyarea " + "where AREA_LGROUP =" + areaId, new String[]{});
            while (cursor.moveToNext()) {
                String largeId = cursor.getString(cursor.getColumnIndex("AREA_MGROUP"));
                String largeName = cursor.getString(cursor.getColumnIndex("MGROUP_NAME"));
                bean = new AreaBean(largeId, largeName);
                cityList.add(bean);
            }
        } catch (Exception e) {
            cursor.close();
            e.printStackTrace();
        } finally {
            cursor.close();
        }
        return cityList;
    }

    /**
     * 选择区县列表
     *
     * @return
     */
    public List<AreaBean> getAreaList(String privinId, String cityId) {
        List<AreaBean> areaList = new ArrayList<AreaBean>();
        AreaBean bean;
        Cursor cursor = null;
        try {
            cursor = db.rawQuery("select * from tdelyarea where AREA_LGROUP = '" + privinId + "'" + "and AREA_MGROUP = '" + cityId + "'", new String[]{});
            while (cursor.moveToNext()) {
                String largeId = cursor.getString(cursor.getColumnIndex("AREA_SGROUP"));
                String largeName = cursor.getString(cursor.getColumnIndex("SGROUP_NAME"));
                bean = new AreaBean(largeId, largeName);
                areaList.add(bean);
            }
        } catch (Exception e) {
            cursor.close();
            e.printStackTrace();
        } finally {
            cursor.close();
        }
        return areaList;
    }


    /**
     * 选择区县列表
     *
     * @return
     */
    public List<String> getWhiteList() {
        AssetsDatabaseManager.initManager(mContext);
        AssetsDatabaseManager mg = AssetsDatabaseManager.getManager();
        db = mg.getDatabase("whitelist.db");
        List<String> whiteList = new ArrayList<>();
        Cursor cursor = null;
        try {
            cursor = db.rawQuery("select DISTINCT url_str from white_list", new String[]{});
            while (cursor.moveToNext()) {
                String name = cursor.getString(0);
                whiteList.add(name);
            }
        } catch (Exception e) {
            cursor.close();
            e.printStackTrace();
        } finally {
            cursor.close();
        }
        return whiteList;
    }


}
