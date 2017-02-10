package com.choudao.equity.popup;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.BitmapDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.choudao.equity.GroupSelectContactsActivity;
import com.choudao.equity.NewFriendsSearchActivity;
import com.choudao.equity.R;
import com.choudao.equity.utils.params.IntentKeys;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liuzhao on 16/7/22.
 */

public class GroupChatPopupWindow {
    public int id;
    public Context mContext;
    public PopupWindow mPopupWindow;

    public GroupChatPopupWindow(Context mContext) {
        this.mContext = mContext;
        makePopupWindow(getPopupWindow());
    }


    private PopupWindow makePopupWindow(View v) {
        mPopupWindow = new PopupWindow(v, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, false);
        mPopupWindow.setOutsideTouchable(true);
        mPopupWindow.setFocusable(true);
        mPopupWindow.setBackgroundDrawable(new BitmapDrawable());
        //设置显示隐藏动画
        mPopupWindow.setAnimationStyle(R.style.AnimTools);

        return mPopupWindow;
    }


    public void popShow(View v) {
        if (mPopupWindow != null && !mPopupWindow.isShowing()) {
            //设置默认获取焦点
            mPopupWindow.setFocusable(true);
            //以某个控件的x和y的偏移量位置开始显示窗口
            mPopupWindow.showAsDropDown(v);
        }
    }


    public View getPopupWindow() {
        View view = LayoutInflater.from(mContext).inflate(R.layout.popup_message_add_group_layout, null);
        ButterKnife.bind(this, view);
        return view;
    }

    @OnClick({R.id.ll_add_group_chat, R.id.ll_add_new_friend})
    public void onClick(View v) {
        Intent intent = new Intent();
        switch (v.getId()) {
            case R.id.ll_add_group_chat:
                intent.setClass(mContext, GroupSelectContactsActivity.class);
                intent.putExtra(IntentKeys.KEY_GROUP_SELECT_TYPE, GroupSelectContactsActivity.SELECT_TYPE_CREATE);
                mContext.startActivity(intent);
                break;
            case R.id.ll_add_new_friend:
                intent.setClass(mContext, NewFriendsSearchActivity.class);
                mContext.startActivity(intent);
                break;
        }
        mPopupWindow.dismiss();

    }

}
