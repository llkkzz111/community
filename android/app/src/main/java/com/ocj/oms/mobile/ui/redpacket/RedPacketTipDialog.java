package com.ocj.oms.mobile.ui.redpacket;

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
 * Created by liutao on 2017/6/11.
 */

public class RedPacketTipDialog extends Dialog {

    @BindView(R.id.tv_content) TextView tvContent;
    private Context context;

    public RedPacketTipDialog(@NonNull Context context) {
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
        View view = LayoutInflater.from(context).inflate(R.layout.dialog_red_packet_tip_layout, null, false);
        setContentView(view);
        ButterKnife.bind(this);
    }

    @OnClick(R.id.tv_know)
    public void onClick() {
        dismiss();
    }
}
