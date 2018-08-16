package com.community.equity.popup;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;

import com.community.equity.R;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liuzhao on 16/7/22.
 */

public class ReportChatPopupWindow extends BasePopupWindow {

    public ReportChatPopupWindow(Context mContext) {
        super(mContext);
    }

    @Override
    public View getPopupWindow() {
        View view = LayoutInflater.from(mContext).inflate(R.layout.popup_report_chat_layout, null);
        ButterKnife.bind(this, view);
        return view;
    }

    @OnClick(R.id.tv_cancle)
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_cancle:
                break;
        }
        mPopupWindow.dismiss();
    }
}
