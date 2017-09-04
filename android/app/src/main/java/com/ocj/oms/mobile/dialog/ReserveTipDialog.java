package com.ocj.oms.mobile.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.TextView;

import com.ocj.oms.mobile.R;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/27.
 */

public class ReserveTipDialog extends Dialog {

    @BindView(R.id.tv_content) TextView tvContent;
    private Context context;
    private OnButtonClickListener onButtonClickListener;

    public void setOnButtonClickListener(OnButtonClickListener onButtonClickListener) {
        this.onButtonClickListener = onButtonClickListener;
    }

    public ReserveTipDialog(@NonNull Context context) {
        super(context, R.style.MyDialog);
        this.context = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        init();
    }

    public void setTipContent(String content) {
        tvContent.setText(content);
    }

    private void init() {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = LayoutInflater.from(context).inflate(R.layout.dialog_reserve_tip_layout, null, false);
        setContentView(view);
        ButterKnife.bind(this);
    }

    @OnClick({R.id.tv_cancel, R.id.tv_confirm})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_cancel:
                if (onButtonClickListener != null) {
                    onButtonClickListener.onCancelClick();
                }
                dismiss();
                break;
            case R.id.tv_confirm:
                if (onButtonClickListener != null) {
                    onButtonClickListener.onConfirmClick();
                }
                dismiss();
                break;
        }
    }

    public interface OnButtonClickListener {
        void onConfirmClick();

        void onCancelClick();
    }
}
