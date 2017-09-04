package com.ocj.oms.mobile.ui.sign;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.widget.AppCompatEditText;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;

import com.blankj.utilcode.utils.RegexUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.R;
import com.ocj.oms.utils.RegExpValidatorUtils;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/12.
 */

public class LotteryDialog extends Dialog {

    @BindView(R.id.et_name) AppCompatEditText etName;
    @BindView(R.id.et_id) AppCompatEditText etId;
    @BindView(R.id.et_phone) AppCompatEditText etPhone;

    private Context context;
    private OnLotteryButtonClickListener onLotteryButtonClickListener;

    public void setOnLotteryButtonClickListener(OnLotteryButtonClickListener onLotteryButtonClickListener) {
        this.onLotteryButtonClickListener = onLotteryButtonClickListener;
    }

    public LotteryDialog(@NonNull Context context) {
        super(context, R.style.MyDialog);
        this.context = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        init();
    }

    private void init() {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = LayoutInflater.from(context).inflate(R.layout.dialog_lottery_layout, null, false);
        setContentView(view);
        ButterKnife.bind(this);
    }

    @OnClick({R.id.btn_cancel, R.id.btn_confirm})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_cancel:
                if (onLotteryButtonClickListener != null) {
                    onLotteryButtonClickListener.onCancelClick();
                }
                break;
            case R.id.btn_confirm:
                if (onLotteryButtonClickListener != null) {
                    if (TextUtils.isEmpty(etName.getText().toString().trim()) ||
                            TextUtils.isEmpty(etId.getText().toString().trim()) ||
                            TextUtils.isEmpty(etPhone.getText().toString().trim())) {
                        ToastUtils.showShortToast("请填写完整信息");
                        return;
                    }
                    if(!RegExpValidatorUtils.isIDcard(etId.getText().toString().trim())){
                        ToastUtils.showShortToast("请输入正确的身份证号码");
                        return;
                    }
                    if(!RegexUtils.isMobileExact(etPhone.getText().toString().trim())){
                        ToastUtils.showShortToast("请输入正确的手机号码");
                        return;
                    }
                    onLotteryButtonClickListener.onConfirmClick(etName.getText().toString().trim(), etId.getText().toString().trim(), etPhone.getText().toString().trim());
                }
                break;
        }
    }

    public interface OnLotteryButtonClickListener {
        void onConfirmClick(String name, String id, String phone);

        void onCancelClick();
    }
}
