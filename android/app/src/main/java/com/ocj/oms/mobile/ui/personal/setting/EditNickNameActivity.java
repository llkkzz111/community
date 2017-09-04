package com.ocj.oms.mobile.ui.personal.setting;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.view.ClearEditText;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * Created by yy on 2017/5/24.
 * <p>
 * 修改昵称
 */

public class EditNickNameActivity extends BaseActivity {

    @BindView(R.id.et_nickname) ClearEditText etNickName;

    @BindView(R.id.btn_next_step) Button btnConfirm;

    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_edit_nickname_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C057);
        btnConfirm.setEnabled(false);
        btnConfirm.setBackground(unClickBg);
    }


    @OnTextChanged(value = R.id.et_nickname, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onTextchange(CharSequence text) {
        String nickName = etNickName.getText().toString().trim();
        if (TextUtils.isEmpty(nickName)) {
            btnConfirm.setEnabled(false);
            btnConfirm.setBackground(unClickBg);
        } else {
            btnConfirm.setEnabled(true);
            btnConfirm.setBackground(normalBg);
        }
    }


    @OnClick(R.id.btn_back)
    public void onClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C057D003001C003001);
        finish();
    }

    @OnClick({R.id.btn_next_step})
    public void onBtnClick(View view) {

        String nickName = etNickName.getText().toString().trim();

        if (TextUtils.isEmpty(nickName)) {
            ToastUtils.showLongToast("请输入您的昵称");
            return;
        }
        HashMap<String, String> params = new HashMap<String, String>();
        params.put(ParamKeys.CUST_NAME, nickName);

        new AccountMode(mContext).changeName(params, new ApiResultObserver<Result<String>>(mContext) {
            @Override
            public void onError(ApiException e) {

                ToastUtils.showLongToast(e.getMessage());
            }


            @Override
            public void onSuccess(Result<String> apiResult) {
                OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C057F008001O008001);
                Intent intent = new Intent();
                intent.setAction(IntentKeys.FRESH_PROFILE);
                sendBroadcast(intent);
                finish();
            }

            @Override
            public void onComplete() {

            }
        });


    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C057);
    }
}
