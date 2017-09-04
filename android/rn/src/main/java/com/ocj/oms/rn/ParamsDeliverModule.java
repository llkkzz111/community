package com.ocj.oms.rn;

import android.app.Activity;
import android.content.Intent;
import android.text.TextUtils;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;

import static android.app.Activity.RESULT_OK;

/**
 * @author Xiang
 *
 */

public class ParamsDeliverModule extends ReactContextBaseJavaModule {
    public static final int REQUEST_ACCESS_TOKEN = 10;
    public static final String ACCESS_TOKEN = "access_token";
    private Promise promise;

    public ParamsDeliverModule(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addActivityEventListener(activityEventListener);
    }

    @Override
    public String getName() {
        return "ParamsDeliverModule";
    }

    private ActivityEventListener activityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
            super.onActivityResult(activity, requestCode, resultCode, data);
            if (resultCode == RESULT_OK) {
//                if (requestCode == REQUEST_ACCESS_TOKEN) {
                    String accessToken = data.getStringExtra(ACCESS_TOKEN);
                    promise.resolve(accessToken);
//                }
            }
            promise = null;
        }
    };

}
