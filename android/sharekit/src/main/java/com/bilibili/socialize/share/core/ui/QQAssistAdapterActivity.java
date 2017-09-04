/*
 * Copyright (C) 2015 Bilibili <jungly.ik@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.bilibili.socialize.share.core.ui;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.tencent.connect.common.AssistActivity;

/**
 * 修复分享完成后通过非正常方式返回app后界面卡死的bug。
 *
 * @author Jungly
 * @email jungly.ik@gmail.com
 * @since 2015/10/21
 */
public class QQAssistAdapterActivity extends AssistActivity {
    private static final String TAG = "BShare.qq.assistAdp";

    private boolean mIsRestartFromQQSDK;
    private boolean mHasActivityResultCalled;
    private boolean mHasOnIntentCalled;

    @Override
    protected void onCreate(Bundle bundle) {
        try {
            super.onCreate(bundle);
            if (bundle != null) {
                mIsRestartFromQQSDK = bundle.getBoolean("RESTART_FLAG");
            }
            Log.d(TAG, String.format("on create: is restart(%s)", mIsRestartFromQQSDK));
        } catch (Exception e) {
            e.printStackTrace();
            finish();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        Log.d(TAG, String.format("on resume: intentCalled(%s), actResult(%s), isFinishing(%s)"
                , mHasOnIntentCalled, mHasActivityResultCalled, isFinishing()));
        if (mHasOnIntentCalled || mHasActivityResultCalled) {
            return;
        }

        if (mIsRestartFromQQSDK && !isFinishing()) {
            Log.d(TAG, "finish manual when onResume");
            finish();
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        mHasOnIntentCalled = true;
        Log.d(TAG, "onNewIntent called");
        super.onNewIntent(intent);
    }

    @Override
    protected void onActivityResult(int i, int i1, Intent intent) {
        mHasActivityResultCalled = true;
        Log.d(TAG, "onActivityResult called");
        super.onActivityResult(i, i1, intent);
    }
}
