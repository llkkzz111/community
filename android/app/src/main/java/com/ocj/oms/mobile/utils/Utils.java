package com.ocj.oms.mobile.utils;

import android.content.ClipboardManager;
import android.content.Context;
import android.widget.Toast;

/**
 * Created by ocj on 2017/8/18.
 */

public class Utils {
    /**
     * 实现文本复制功能
     *
     * @param content
     */
    public static void copy(String content, Context context) {
        // 得到剪贴板管理器
        ClipboardManager cmb = (ClipboardManager) context
                .getSystemService(Context.CLIPBOARD_SERVICE);
        cmb.setText(content.trim());
        Toast.makeText(context, "复制成功", Toast.LENGTH_SHORT).show();
    }
}
