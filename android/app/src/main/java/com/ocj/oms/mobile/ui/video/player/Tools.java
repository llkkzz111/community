package com.ocj.oms.mobile.ui.video.player;

import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import com.ocj.oms.common.net.HeaderUtils;
import com.ocj.oms.mobile.R;
import com.ocj.oms.utils.DeviceUtils;
import com.ocj.oms.utils.system.AppUtil;

public class Tools {

	public static String getString(String orignal){

		return TextUtils.isEmpty(orignal) ? "0" : orignal;
	}

	public static String getUserAgent(Context context){
		if(context!=null){
			getDeviceId(context);
			return "OCJ_"+Constants.mSaleCode+context.getString(R.string.webview_useragent)
					+"["+Tools.getString(Constants.imeiNumber)+"#"
					+Tools.getString(Constants.macAddress)+"#"
					+Tools.getString(Build.MODEL)+"#"
					+Tools.getString(Build.VERSION.RELEASE)+"#"
					+getString(Constants.deviceId)+"]";
		}else{
			return "OCJ_"+Constants.mSaleCode+"app_log Android Mobile"
					+"["+Tools.getString(Constants.imeiNumber)+"#"
					+Tools.getString(Constants.macAddress)+"#"
					+Tools.getString(Build.MODEL)+"#"
					+Tools.getString(Build.VERSION.RELEASE)+"#"
					+getString(Constants.deviceId)+"]";
		}
	}

	public static String getDeviceId(Context context){
		if(TextUtils.isEmpty(Constants.deviceId)){
			Constants.imeiNumber= DeviceUtils.getIMEI(context);
			Constants.macAddress=DeviceUtils.getWifiMacAddr(context);
			Constants.deviceId= HeaderUtils.getDeviceId();
		}
		if(AppUtil.isDebug()){
			Log.i("Ocj","ocj deviceId is :  "+Constants.deviceId);
		}
		return Constants.deviceId;
	}
}
