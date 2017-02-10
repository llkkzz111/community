package com.choudao.equity.popup;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.support.v4.app.FragmentManager;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.choudao.equity.AnswerAddActivity;
import com.choudao.equity.CommentAddActivity;
import com.choudao.equity.CommentsActivity;
import com.choudao.equity.PersonalProfileActivity;
import com.choudao.equity.QuestionDetailsActivity;
import com.choudao.equity.R;
import com.choudao.equity.SingleAnswerActivity;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.base.BaseApiResponse;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.entity.AnswerEntity;
import com.choudao.equity.entity.CommentEntity;
import com.choudao.equity.entity.QuestionEntity;
import com.choudao.equity.entity.ShareWechatInfo;
import com.choudao.equity.share.ShareToWeiXin;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.NetworkTool;
import com.choudao.equity.view.ReportView;
import com.choudao.equity.view.bottomsheet.BottomSheetLayout;
import com.choudao.equity.view.bottomsheet.IntentPickerSheetView;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.request.DeleteFriendRequest;
import com.choudao.imsdk.imutils.SendMessageQueue;
import com.tencent.mm.sdk.modelmsg.SendMessageToWX;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liuzhao on 16/3/23.
 */
public class SharePopupWindow extends BasePopupWindow {
    protected BottomSheetLayout bottomSheetLayout;
    FragmentManager fragmentManager;
    @BindView(R.id.ll_popup_main) LinearLayout llMain;
    @BindView(R.id.ll_other) LinearLayout llOther;
    @BindView(R.id.ll_delete_contacts) LinearLayout llDelContacts;
    @BindView(R.id.ll_share) LinearLayout llShare;
    @BindView(R.id.ll_edit) LinearLayout llEdit;
    @BindView(R.id.ll_reports) LinearLayout llReports;
    @BindView(R.id.tv_copy_path) TextView tvCopyPath;
    private ShareWechatInfo wechatInfo;
    private int questionId;
    private AnswerEntity answer;
    private CommentEntity commentEntity;
    private QuestionEntity questionEntity;
    private int answerid = -1;
    private List<IntentPickerSheetView.ActivityInfo> activityInfoList;
    private ShareToWeiXin shareWeChat = null;



    public SharePopupWindow(Context mContext) {
        super(mContext);
        initWechatShare();
    }

    public SharePopupWindow(Context mContext, int id) {
        super(mContext, id);
        initWechatShare();
    }

    public SharePopupWindow(Context mContext, int id, boolean isCurrent) {
        super(mContext, id, isCurrent);
        initWechatShare();
    }

    private void initWechatShare() {
        shareWeChat = new ShareToWeiXin();
        shareWeChat.RegisterApp();
        wechatInfo = new ShareWechatInfo();
    }

    public void setShareInfo(String shareInfo, View v) {
        wechatInfo = JSON.parseObject(shareInfo, ShareWechatInfo.class);
        llOther.setVisibility(View.GONE);
        if (TextUtils.isEmpty(wechatInfo.getImage()) || TextUtils.isEmpty(wechatInfo.getLink()) || TextUtils.isEmpty(wechatInfo.getTitle())) {
            v.setVisibility(View.GONE);
        } else {
            v.setVisibility(View.VISIBLE);
        }
    }

    public void setTitle(String title) {
        wechatInfo.setTitle(title);
    }

    public void setLink(String link) {
        wechatInfo.setLink(link);
    }

    public void setDesc(String desc) {
        wechatInfo.setDesc(desc);
    }

    public void setBottomSheetLayout(BottomSheetLayout bottomSheetLayout) {
        this.bottomSheetLayout = bottomSheetLayout;
    }

    public void setEditAnswerId(int questionId, AnswerEntity answer) {
        this.answer = answer;
        this.questionId = questionId;
    }

    public void setEditCommentId(int answerid, CommentEntity commentEntity) {
        this.commentEntity = commentEntity;
        this.answerid = answerid;
    }

    public void setQuestionEntity(QuestionEntity entity) {
        this.questionEntity = entity;
    }

    @Override
    public View getPopupWindow() {
        activityInfoList = new ArrayList<>();
        View view = LayoutInflater.from(mContext).inflate(R.layout.popup_share_main_layout, null);
        ButterKnife.bind(this, view);
        List<ResolveInfo> list = Utils.getShareApps(mContext);
        PackageManager packageManager = mContext.getPackageManager();
        shareCheck(list, packageManager, activityInfoList);

        if (mContext instanceof QuestionDetailsActivity) {
            llEdit.setVisibility(View.GONE);
        } else if (mContext instanceof SingleAnswerActivity) {
            if (isCurrent) {
                llEdit.setVisibility(View.VISIBLE);
            } else {
                llEdit.setVisibility(View.GONE);
            }
        } else if (mContext instanceof CommentsActivity) {
            llShare.setVisibility(View.GONE);
            tvCopyPath.setText(mContext.getString(R.string.text_copy));
            if (isCurrent) {
                llEdit.setVisibility(View.VISIBLE);
            } else {
                llEdit.setVisibility(View.GONE);
            }
        } else if (mContext instanceof PersonalProfileActivity) {
            llEdit.setVisibility(View.GONE);
            llReports.setVisibility(View.GONE);
            if (id == ConstantUtils.USER_ID) {
            } else if (isCurrent) {
                llDelContacts.setVisibility(View.VISIBLE);
                llReports.setVisibility(View.VISIBLE);
            }
        }

        return view;
    }

    private void shareCheck(List<ResolveInfo> list, PackageManager packageManager, List<IntentPickerSheetView.ActivityInfo> activityInfoList) {
        for (int i = 0; i < list.size(); i++) {
            ResolveInfo resolveInfo = list.get(i);
            ComponentName componentName = new ComponentName(resolveInfo.activityInfo.packageName, resolveInfo.activityInfo.name);
            if (TextUtils.isEmpty(resolveInfo.activityInfo.taskAffinity)) {
                continue;
            }
            if (resolveInfo.activityInfo.taskAffinity.startsWith("com.android")) {
                continue;
            }
            if (resolveInfo.activityInfo.taskAffinity.startsWith("com.tencent.mm")) {
                continue;
            }
            if (resolveInfo.activityInfo.taskAffinity.startsWith("com.baidu.netdisk")) {
                continue;
            }
            activityInfoList.add(new IntentPickerSheetView.ActivityInfo(resolveInfo, resolveInfo.loadLabel(packageManager), componentName));
        }
    }

    @OnClick({R.id.tv_share_wechat, R.id.tv_share_wechat_friends, R.id.tv_report, R.id.tv_share_more, R.id.tv_edit, R.id.tv_share_cancle, R.id.tv_copy_path, R.id.tv_delete_contacts})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.tv_share_wechat:
                shareWeChat.sendMessage(SendMessageToWX.Req.WXSceneSession, wechatInfo);
                mPopupWindow.dismiss();
                break;
            case R.id.tv_share_wechat_friends:
                shareWeChat.sendMessage(SendMessageToWX.Req.WXSceneTimeline, wechatInfo);
                mPopupWindow.dismiss();
                break;
            case R.id.tv_report:
                getReportState();
                break;
            case R.id.tv_share_more:
                shareMore();
                break;
            case R.id.tv_edit:
                JumpEdit();
                mPopupWindow.dismiss();
                break;
            case R.id.tv_share_cancle:
                mPopupWindow.dismiss();
                break;
            case R.id.tv_copy_path:
                copyPath();
                break;
            case R.id.tv_delete_contacts:
                showDialog();
                mPopupWindow.dismiss();
                break;
        }
    }

    private void copyPath() {
        if (mContext instanceof CommentsActivity) {
            Utils.copyText(mContext, wechatInfo.getDesc());
            Toast.makeText(mContext, mContext.getString(R.string.text_copy_success), Toast.LENGTH_SHORT).show();
            mPopupWindow.dismiss();
            return;
        }
        if (!TextUtils.isEmpty(wechatInfo.getLink())) {
            Utils.copyText(mContext, wechatInfo.getLink());
            Toast.makeText(mContext, mContext.getString(R.string.text_copy_success), Toast.LENGTH_SHORT).show();
            mPopupWindow.dismiss();
        }
    }

    /**
     * 跳转到编辑界面
     */
    private void JumpEdit() {
        Intent intent = new Intent();
        if (answer != null) {
            intent.setClass(mContext, AnswerAddActivity.class);
            intent.putExtra(IntentKeys.KEY_ANSWER_ENTITY, answer);
            intent.putExtra(IntentKeys.KEY_QUESTION_ID, questionId);
            mContext.startActivity(intent);
        } else {
            intent.setClass(mContext, CommentAddActivity.class);
            intent.putExtra(IntentKeys.KEY_COMMENT_ENTITY, commentEntity);
            intent.putExtra(IntentKeys.KEY_ANSWER_ID, answerid);
            mContext.startActivity(intent);
        }
    }

    private void shareMore() {
        final Intent shareIntent = new Intent(Intent.ACTION_SEND);
        shareIntent.setType("text/plain");
        String title = "筹道股权";


        String extraText = " " + wechatInfo.getLink();

        if (mContext instanceof QuestionDetailsActivity) {
            extraText = Utils.formatStr(questionEntity.getTitle()) + "  " + questionEntity.getView_count() + "人关注， " + questionEntity.getAnswersCount() + "个回答，" + questionEntity.getShare_url() + " 共同思考，独立投资。";
        } else if (mContext instanceof SingleAnswerActivity) {
            String safeAnswer = Utils.formatStr(answer.getSafe_content());

            if (safeAnswer.length() > 50) {
                safeAnswer = safeAnswer.substring(0, 50) + "…";
            }
            extraText = Utils.formatStr(answer.getQuestionTitle()) + answer.getUser().getName() + "的回答:" + safeAnswer + " " + answer.getShare_url() + " 共同思考，独立投资。";
        } else if (mContext instanceof PersonalProfileActivity) {
            extraText = Utils.formatStr(wechatInfo.getTitle() + "  的个人主页, " + wechatInfo.getDesc() + wechatInfo.getLink());
        }


        shareIntent.putExtra(Intent.EXTRA_TEXT, extraText);
        shareIntent.putExtra(Intent.EXTRA_SUBJECT, title);
        IntentPickerSheetView intentPickerSheet = new IntentPickerSheetView(mContext, "分享至", new IntentPickerSheetView.OnIntentPickedListener() {
            @Override
            public void onIntentPicked(IntentPickerSheetView.ActivityInfo activityInfo) {
                bottomSheetLayout.dismissSheet();
                if (activityInfo.resolveInfo.activityInfo.taskAffinity.indexOf("zxing") > 0) {
                    shareIntent.putExtra(Intent.EXTRA_TEXT, wechatInfo.getLink());
                }
                mContext.startActivity(activityInfo.getConcreteIntent(shareIntent));
            }
        }, activityInfoList);

        bottomSheetLayout.showWithSheetView(intentPickerSheet);
        mPopupWindow.dismiss();
    }

    public void setFragmentManager(FragmentManager fragmentManager) {
        this.fragmentManager = fragmentManager;
    }

    private void showDialog() {
        BaseDialogFragment dialogFragment = new BaseDialogFragment();
        dialogFragment.addContent(String.format(mContext.getString(R.string.text_del_user_dialog_content), wechatInfo.getTitle())).addButton(1, "取消", new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        }).addButton(2, "确定删除", mContext.getResources().getColorStateList(R.color.text_title_warning_text_color), new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (NetworkTool.isNetworkAvailable(mContext)) {
                    SendMessageQueue.getInstance().addSendMessage(MessageType.DELETE_FRIEND,
                            new DeleteFriendRequest(id));
                } else {
                    Toast.makeText(mContext, "网络未连接，无法删除该联系人，请检查网络设置", Toast.LENGTH_SHORT).show();
                }

            }
        }).show(fragmentManager, "dialog");
    }

    /**
     * 判断当前选择是否被举报过
     */
    private void getReportState() {
        String type = "";
        if (mContext instanceof QuestionDetailsActivity) {
            type = "q";
        } else if (mContext instanceof SingleAnswerActivity) {
            type = "a";
        } else if (mContext instanceof CommentsActivity) {
            type = "c";
        } else if (mContext instanceof PersonalProfileActivity) {
            type = "u";
        }
        Map<String, Object> params = new IdentityHashMap<>();
        params.put("reportable[id]", id);
        params.put("reportable[type]", type);
        ApiService service = ServiceGenerator.createService(ApiService.class);
        service.getReportState(params).enqueue(new BaseCallBack<BaseApiResponse>() {
            @Override
            protected void onSuccess(BaseApiResponse baseApiResponse) {
                if (baseApiResponse.getStatus().equals("OK")) {
                    Toast.makeText(mContext, baseApiResponse.getMessage(), Toast.LENGTH_SHORT).show();
                    mPopupWindow.dismiss();
                } else if (baseApiResponse.getStatus().equals("FAIL")) {
                    llMain.removeAllViews();
                    ReportView reportView = new ReportView(mContext, mPopupWindow, id);
                    llMain.addView(reportView);
                }
            }

            @Override
            protected void onFailure(int code, String msg) {
                String sInfoFormat = mContext.getResources().getString(R.string.error_no_refresh);
                Toast.makeText(mContext, String.format(sInfoFormat, msg, String.valueOf(code)), Toast.LENGTH_SHORT).show();
            }
        });

    }

}
