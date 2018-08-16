package com.community.equity.popup;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import com.community.equity.R;
import com.community.equity.entity.ShareWechatInfo;
import com.community.equity.share.ShareToWeiXin;
import com.community.equity.utils.Utils;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liuzhao on 16/5/3.
 */
public class InviteAnswerPopupWindow extends BasePopupWindow {

    private ShareToWeiXin shareWeChat;
    private ShareWechatInfo weChatInfo;

    public InviteAnswerPopupWindow(Context mContext) {
        super(mContext);
        shareWeChat = new ShareToWeiXin();
        shareWeChat.RegisterApp();
    }

    @Override
    public View getPopupWindow() {
        View view = LayoutInflater.from(mContext).inflate(R.layout.popup_invite_answer_layout, null);
        ButterKnife.bind(this, view);
        return view;
    }

    public void setShareWeChatInfo(ShareWechatInfo weChatInfo) {
        this.weChatInfo = weChatInfo;
    }

    @OnClick({R.id.tv_invite_inside, R.id.tv_invite_wechat, R.id.tv_invite_copy, R.id.tv_invite_cancle})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_invite_inside:
                break;
            case R.id.tv_invite_wechat:
                shareWeChat.sendMessage(SendMessageToWX.Req.WXSceneSession, weChatInfo);
                break;
            case R.id.tv_invite_copy:
                copyPath();
                break;
            case R.id.tv_invite_cancle:
                break;
        }
        mPopupWindow.dismiss();
    }

    private void copyPath() {
        Utils.copyText(mContext, weChatInfo.getLink());
        Toast.makeText(mContext, mContext.getString(R.string.text_copy_success), Toast.LENGTH_SHORT).show();
    }
}
