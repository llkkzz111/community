package com.choudao.equity.popup;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;

import com.choudao.equity.QuestionAddActivity;
import com.choudao.equity.R;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liuzhao on 16/3/23.
 */
public class QuestionPopupWindow extends BasePopupWindow {

    public QuestionPopupWindow(Context mContext) {
        super(mContext);
    }

    @Override
    public View getPopupWindow() {
        View view = LayoutInflater.from(mContext).inflate(R.layout.popup_question_layout, null);
        ButterKnife.bind(this, view);
        return view;
    }

    @OnClick({R.id.tv_add_question, R.id.tv_add_opinion, R.id.tv_share_cancle})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_add_opinion:
                break;
            case R.id.tv_add_question:
                Intent intent = new Intent();
                intent.setClass(mContext, QuestionAddActivity.class);
                mContext.startActivity(intent);
                break;
            case R.id.tv_share_cancle:
                break;
        }
        mPopupWindow.dismiss();
    }

}
