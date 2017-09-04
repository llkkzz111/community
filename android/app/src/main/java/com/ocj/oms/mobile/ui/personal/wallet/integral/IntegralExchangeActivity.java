package com.ocj.oms.mobile.ui.personal.wallet.integral;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.http.service.wallet.WalletMode;
import com.ocj.oms.mobile.ui.rn.RouterModule;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * Created by yy on 2017/5/13.
 * 积分详情-礼券兑换
 */
@Route(path = RouterModule.AROUTER_PATH_CHANGEGIFT)
public class IntegralExchangeActivity extends BaseActivity {
    @BindView(R.id.et_gift_no) EditText etNo;
    @BindView(R.id.et_gift_pwd) EditText etPwd;
    @BindView(R.id.btn_commit) Button btnCommit;
    @BindDrawable(R.drawable.radius_shape_select) Drawable unClickBg;
    @BindDrawable(R.drawable.radius_selector_btn_register) Drawable normalBg;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_voucher_exchange_layout;
    }

    @Override
    protected void initEventAndData() {
        btnCommit.setEnabled(false);
        btnCommit.setBackground(unClickBg);
    }

    @OnTextChanged(value = R.id.et_gift_no, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onNoTextChanged(CharSequence text) {
        checkImput();
    }

    @OnTextChanged(value = R.id.et_gift_pwd, callback = OnTextChanged.Callback.AFTER_TEXT_CHANGED)
    void onPwdTextChanged(CharSequence text) {
        checkImput();
    }

    /**
     * 检查输入框输入内容
     */
    private void checkImput() {
        String no = etNo.getText().toString();
        String pwd = etPwd.getText().toString();
        if (TextUtils.isEmpty(no) || TextUtils.isEmpty(pwd)) {
            btnCommit.setEnabled(false);
            btnCommit.setBackground(unClickBg);
        } else {
            btnCommit.setEnabled(true);
            btnCommit.setBackground(normalBg);
        }
    }


    @OnClick({R.id.btn_close, R.id.btn_commit})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_close:
                finish();
                break;
            case R.id.btn_commit:
                vouchersExchange();
                break;
        }


    }

    private void vouchersExchange() {
        String no = etNo.getText().toString();
        String pwd = etPwd.getText().toString();
        Map<String, String> params = new HashMap<>();
        params.put(ParamKeys.GIFT_NO, no);
        params.put(ParamKeys.GIFT_PASSWORD, pwd);
        new WalletMode(mContext).voucherExchange(params, new ApiResultObserver<Object>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }

            @Override
            public void onSuccess(Object apiResult) {
                ToastUtils.showShortToast("兑换成功");
                clearIuput();
                Intent intent = new Intent();
                intent.setAction(IntentKeys.REFRESH_SCORE);//通知刷新积分
                mContext.sendBroadcast(intent);
                finish();
            }

            @Override
            public void onComplete() {

            }
        });
    }

    /**
     * 兑换成功后清楚输入
     */
    private void clearIuput() {
        etNo.setText("");
        etPwd.setText("");
    }
}




