package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.os.RemoteException;
import android.view.View;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.service.IMServiceConnector;
import com.choudao.equity.service.IMServiceConnectorAIDL;
import com.choudao.equity.utils.ActivityStack;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.FileUtils;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.utils.Logger;

import java.io.File;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import cn.jpush.android.api.JPushInterface;


public class SettingActivity extends BaseActivity {
    private static final String TAG = "===SettingActivity===";
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.tv_phone) TextView tvPhones;
    @BindView(R.id.tv_cache_count) TextView tvCacheSize;

    private String CacheSize = "未知";
    private UserInfo userInfo;
    private BaseDialogFragment dialog;

    private IMServiceConnectorAIDL connectorAIDL;
    private IMServiceConnector imServiceConnector = new IMServiceConnector() {

        @Override
        public void onIMServiceConnected(IMServiceConnectorAIDL imServiceConnectorAIDL) {
            connectorAIDL = imServiceConnectorAIDL;
        }

        @Override
        public void onIMServiceDisconnected() {

        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_setting_layout);
        ButterKnife.bind(this);
        imServiceConnector.bindService(this);
        if ((new File(FileUtils.GLIDE_CACHE_PATH).exists())) {
            CacheSize = FileUtils.byteCountToDisplaySize(FileUtils.GLIDE_CACHE_PATH);
        }
        dialog = new BaseDialogFragment();
        userInfo = (UserInfo) getIntent().getSerializableExtra(IntentKeys.KEY_USER_INFO);
        initView();
    }

    private void initView() {
        topView.setLeftImage();
        topView.setTitle("设置");
        tvCacheSize.setText(CacheSize);

    }


    @Override
    protected void onResume() {
        super.onResume();
        if (userInfo != null)
            tvPhones.setText(userInfo.getPhone());
    }

    @OnClick({R.id.iv_left, R.id.ll_bind_phone, R.id.ll_message_setting, R.id.ll_privacy_setting,
            R.id.ll_clear_cache, R.id.ll_help_feedback, R.id.ll_about, R.id.ll_logout})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_left:
                finish();
                break;
            case R.id.ll_help_feedback:
                startActivity(new Intent(mContext, HelpAndFeedbackActivity.class));
                break;
            case R.id.ll_about:
                startActivity(new Intent(mContext, AboutActivity.class));
                break;
            case R.id.ll_bind_phone:
                Intent intent = new Intent();
                intent.putExtra(IntentKeys.KEY_USER_INFO, userInfo);
                intent.setClass(mContext, BindPhoneNoActivity.class);
                startActivity(intent);
                break;
            case R.id.ll_clear_cache:
                clearMemery();
                break;
            case R.id.ll_logout:
                showLogoutDialog();
                break;
            case R.id.ll_message_setting:
                startActivity(new Intent(mContext, SettingMessageActivity.class));
                break;
            case R.id.ll_privacy_setting:
                startActivity(new Intent(mContext, SettingPrivacyActivity.class));
                break;
        }
    }

    private void showLogoutDialog() {
        dialog.addContent(getString(R.string.text_logout_content)).
                addButton(1, getString(R.string.text_quit), new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        PreferencesUtils.setLoginState(false);
                        PreferencesUtils.setUserId(-1);
                        PreferencesUtils.setAccessToken("");
                        ConstantUtils.isLogin = false;
                        CookieSyncManager.createInstance(getApplicationContext());

                        CookieManager.getInstance().removeAllCookie();

                        if (connectorAIDL != null) {
                            try {
                                connectorAIDL.logoutIMServer();
                            } catch (RemoteException e) {
                                Logger.e(TAG, "logoutIMServer -> " + e.getMessage());
                            }
                        }
                        JPushInterface.setAlias(getBaseContext(), "", null);
                        startNewActivity(ConstantUtils.URL_ME);
                        ActivityStack.getInstance().finishAllActivityUntilCls(false);
                    }
                }).
                addButton(2, getString(R.string.text_cancel), null).
                show(getSupportFragmentManager(), "logout");
    }

    private void startNewActivity(String url) {
        Intent intent = new Intent(mContext, LoginActivity.class);
        intent.putExtra(IntentKeys.KEY_URL, url);
        intent.putExtra(IntentKeys.KEY_FROM_LOADING, true);
        startActivity(intent);
        finish();
    }

    /**
     * 清除缓存
     */
    private void clearMemery() {
        Glide.get(mContext).clearMemory();
        Thread thread = new Thread() {
            @Override
            public void run() {
                super.run();
                Glide.get(mContext).clearDiskCache();
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if ((new File(FileUtils.GLIDE_CACHE_PATH).exists())) {
                            CacheSize = FileUtils.byteCountToDisplaySize(FileUtils.GLIDE_CACHE_PATH);
                            if (CacheSize.equals("0 B")) {
                                Toast.makeText(mContext, "清除成功", Toast.LENGTH_SHORT).show();
                            }
                        }
                        tvCacheSize.setText(CacheSize);
                    }
                });
            }
        };
        thread.start();
    }

    @Override
    protected void onDestroy() {
        imServiceConnector.unbindService(this);
        super.onDestroy();
    }
}
