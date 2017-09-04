package com.ocj.oms.mobile.ui.rn;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.ocj.oms.rn.module.DataAnalyticsModule;
import com.ocj.oms.rn.ParamsDeliverModule;
import com.ocj.oms.rn.VersionAndroid;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @author Xiang
 *         <p>
 *         将原生模块添加到NativeModule
 */

public class AndroidModulePackage implements ReactPackage {
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> nativeModules = new ArrayList<>();
        nativeModules.add(new RouterModule(reactContext));
        nativeModules.add(new ParamsDeliverModule(reactContext));
        nativeModules.add(new VersionAndroid(reactContext));
        nativeModules.add(new DataAnalyticsModule(reactContext));
        return nativeModules;
    }

    @Override
    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }
}
