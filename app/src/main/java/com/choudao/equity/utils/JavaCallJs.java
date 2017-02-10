package com.choudao.equity.utils;

import android.webkit.JavascriptInterface;
import android.widget.Toast;

/**
 * Created by Han on 2016/3/11.
 */
public class JavaCallJs {

    @JavascriptInterface
    public void getWechatShareInfo(String shareInfo) {
        Toast.makeText(UIManager.getInstance().getBaseContext(), shareInfo, Toast.LENGTH_SHORT).show();
    }
}
