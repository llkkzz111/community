package com.choudao.equity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.design.widget.AppBarLayout;
import android.support.v7.widget.Toolbar;
import android.text.Layout;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.choudao.equity.adapter.LevelsAdapter;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.entity.ProfileEntity;
import com.choudao.equity.entity.UserEntity;
import com.choudao.equity.popup.SharePopupWindow;
import com.choudao.equity.selector.PhotoPreviewActivity;
import com.choudao.equity.selector.model.PhotoModel;
import com.choudao.equity.utils.ActivityStack;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.MyGridView;
import com.choudao.equity.view.NetworkTool;
import com.choudao.equity.view.StretchyTextView;
import com.choudao.equity.view.bottomsheet.BottomSheetLayout;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.constants.ResponseCode;
import com.choudao.imsdk.dto.constants.UserType;
import com.choudao.imsdk.dto.request.AcceptFriendRequest;
import com.choudao.imsdk.dto.request.AddFriendRequest;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.dto.request.GetFriendConfirmationRequest;
import com.choudao.imsdk.dto.response.BaseResponse;
import com.choudao.imsdk.dto.response.GetFriendConfirmationResponse;
import com.choudao.imsdk.imutils.IMMessageDispatcher;
import com.choudao.imsdk.imutils.SendMessageQueue;
import com.choudao.imsdk.imutils.callback.IReceiver;
import com.choudao.imsdk.utils.Logger;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemClick;
import retrofit2.Call;

/**
 * Created by liuzhao on 16/4/27.
 */
public class PersonalProfileActivity extends BaseActivity implements View.OnClickListener, IReceiver {
    @BindView(R.id.tv_title) TextView tvTitle;
    @BindView(R.id.iv_head) ImageView ivHead;
    @BindView(R.id.tv_profile_title) TextView tvProfileTitle;
    @BindView(R.id.tv_profile_address) TextView tvAddress;
    @BindView(R.id.tv_nick_name) TextView tvNickName;
    @BindView(R.id.tv_remark) TextView tvRemark;
    @BindView(R.id.tv_id) TextView tvId;
    @BindView(R.id.tv_profile_desc) TextView tvDesc;
    @BindView(R.id.ll_desc) LinearLayout llDesc;
    @BindView(R.id.ll_remark_des) LinearLayout llRemarkDes;
    @BindView(R.id.tv_answer_count_no) TextView tvAnswerCountNo;
    @BindView(R.id.ll_answer_counts) LinearLayout llAnswers;
    @BindView(R.id.tv_question_count_no) TextView tvQuestionCountNo;
    @BindView(R.id.ll_questions_count) LinearLayout llQuestionsCount;
    @BindView(R.id.btn_apply) TextView btnApply;
    @BindView(R.id.gv_levels) MyGridView gvLevels;

    @BindView(R.id.bottomsheet) BottomSheetLayout bottomSheetLayout;
    @BindView(R.id.abl_profile) AppBarLayout ablProfile;
    @BindView(R.id.toolbar) Toolbar mToolbar;
    @BindView(R.id.stv_abstract) StretchyTextView stvAsbstract;

    @BindDrawable(R.drawable.icon_svg_man) Drawable man;
    @BindDrawable(R.drawable.icon_svg_woman) Drawable woman;

    @BindView(R.id.ll_remark) LinearLayout llRemark;
    @BindView(R.id.tv_beehive) TextView tvBeehive;
    @BindView(R.id.ll_beehives) LinearLayout llBeehives;
    @BindView(R.id.tv_follow_pitches_count) TextView tvFollowPitchesCount;
    @BindView(R.id.ll_follow_pitches) LinearLayout llFollowPitches;
    @BindView(R.id.tv_launched_pitches_count) TextView tvLaunchedPitchesCount;
    @BindView(R.id.ll_launched_pitches) LinearLayout llLaunchedPitches;
    @BindView(R.id.ll_levels) LinearLayout llLevels;
    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            if (stvAsbstract != null) {
                stvAsbstract.contentText.post(new Runnable() {
                    @Override
                    public void run() {
                        Layout layout = stvAsbstract.contentText.getLayout();
                        if (layout != null) {
                            int lines = layout.getLineCount();
                            if (lines > 0) {
                                if (layout.getEllipsisCount(lines - 1) > 0) {
                                    stvAsbstract.operateText.setVisibility(View.VISIBLE);
                                }
                            }
                        } else {
                            Logger.e("Layout is null");
                        }
                    }
                });
            }
        }
    };
    private boolean isChengeRemark = false;
    private int userId;
    private String userName;
    private UserInfo userInfo = null;
    private SharePopupWindow popupWindow;
    private LevelsAdapter adapter;
    /**
     * 联系人关系
     */
    private int contactRelation;
    /**
     * 好友请求ID，只有新的好友页会传
     */
    private long friendRequestId = -1;
    private List<UserEntity.LevelsBean> levelsList = new ArrayList<>();
    private BaseDialogFragment dialogFragment = new BaseDialogFragment();
    private MessageType[] msgTypeArray = {
            MessageType.DELETE_FRIEND,
            MessageType.LOCAL_LOAD_FRIEND_END,
            MessageType.GET_FRIEND_CONFIRMATION,
            MessageType.ACCEPT_FRIEND_REQUEST
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);
        setContentView(R.layout.activity_personal_profile_layout);
        //initView
        ButterKnife.bind(this);
        adapter = new LevelsAdapter(mContext, levelsList);
        gvLevels.setAdapter(adapter);
        initToolBar();
        //initData
        initUserInfo();
        //showView
        showView();//基本View
        contactRelation();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_profile_title_bar, menu);
        return super.onCreateOptionsMenu(menu);
    }

    private void initUserInfo() {
        friendRequestId = getIntent().getLongExtra(IntentKeys.FRIEND_REQUEST_ID, -1);
        userName = getIntent().getStringExtra(IntentKeys.KEY_USER_NAME);

        if (getIntent().getIntExtra(IntentKeys.KEY_USER_ID, -1) == -1) {
            userId = (int) getIntent().getLongExtra(IntentKeys.KEY_USER_ID, -1);
        } else {
            userId = getIntent().getIntExtra(IntentKeys.KEY_USER_ID, -1);
        }
        contactRelation = DBHelper.getInstance().queryContactRelations(userId);
        userInfo = DBHelper.getInstance().queryUniqueUserInfo(userId);
    }

    private void initToolBar() {
        setSupportActionBar(mToolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        mToolbar.setNavigationIcon(R.drawable.icon_back_white_bg);
        mToolbar.setOnMenuItemClickListener(new Toolbar.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                if (item.getItemId() == R.id.action_settings) {
                    showPopupWindow();
                }
                return false;
            }
        });
        mToolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        ablProfile.addOnOffsetChangedListener(new AppBarLayout.OnOffsetChangedListener() {
            @Override
            public void onOffsetChanged(AppBarLayout appBarLayout, int verticalOffset) {
                if (Math.abs(verticalOffset) >= appBarLayout.getTotalScrollRange()) {
                    tvTitle.setVisibility(View.VISIBLE);
//                } else if (verticalOffset == 0) {
//                    tvTitle.setVisibility(View.GONE);
                } else {
                    tvTitle.setVisibility(View.GONE);
                }
            }
        });
    }

    private void showPopupWindow() {
        boolean isShowDel = (contactRelation == 1 && userInfo.getUserType() == UserType.NORMAL.code);
        popupWindow = new SharePopupWindow(mContext, userId, isShowDel);
        popupWindow.setFragmentManager(getSupportFragmentManager());
        popupWindow.setBottomSheetLayout(bottomSheetLayout);
        popupWindow.setLink(userInfo.getShareUrl());
        popupWindow.setTitle(Utils.formatStr(userInfo.getName()));
        popupWindow.setDesc(userInfo.getQuestionCount() + "次提问，" + userInfo.getAnswerCount() + "次回答,\n共同思考,独立投资!");
        popupWindow.popShow(tvTitle);
    }

    private void showView() {
        tvId.setText("筹道ID: " + userId);
        if (userInfo != null) {
            tvTitle.setText(userInfo.showName());
            tvRemark.setText(userInfo.showName());
            tvNickName.setText("昵称: " + userInfo.getName());
            tvProfileTitle.setText(userInfo.getTitle());
            tvDesc.setText(Utils.formatStr(userInfo.getDesc()));
            tvFollowPitchesCount.setText("" + userInfo.getFollowPitches());
            tvBeehive.setText(userInfo.getBeehive() + "");
            tvLaunchedPitchesCount.setText("" + userInfo.getLaunchedPitches());
            tvQuestionCountNo.setText(String.valueOf(userInfo.getQuestionCount()));
            tvAnswerCountNo.setText(String.valueOf(userInfo.getAnswerCount()));
            tvAddress.setText(userInfo.getAddress());
            tvRemark.setCompoundDrawablePadding(10);
            stvAsbstract.setMaxLineCount(4);
            stvAsbstract.setContentTextSize(15);
            stvAsbstract.setBottomTextGravity(Gravity.CENTER);
            stvAsbstract.setContent((Utils.formatStrTo(userInfo.getDesc()) + "\n" + Utils.formatStrTo(userInfo.getEducation()) + "\n" + Utils.formatStrTo(userInfo.getExperience())).trim());

            if ("男".equals(userInfo.getGender())) {
                tvRemark.setCompoundDrawablesWithIntrinsicBounds(null, null, man, null);
            } else {
                tvRemark.setCompoundDrawablesWithIntrinsicBounds(null, null, woman, null);
            }
            if (Util.isOnMainThread() && !isDestory)
                Glide.with(mContext).load(userInfo.getHeadImgUrl()).centerCrop().dontAnimate().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext)).into(ivHead);
        } else {
            tvTitle.setText(userName);
            tvRemark.setText(userName);
            tvNickName.setText("昵称: " + userName);
        }


        if (userId != ConstantUtils.USER_ID) {
            if (userInfo == null || !TextUtils.isEmpty(userInfo.getTitle())) {
                tvProfileTitle.setVisibility(View.VISIBLE);
            } else {
                tvProfileTitle.setVisibility(View.GONE);
            }
            if (userInfo == null || !TextUtils.isEmpty(userInfo.getDesc()) || !TextUtils.isEmpty(userInfo.getEducation()) || !TextUtils.isEmpty(userInfo.getExperience())) {
                llDesc.setVisibility(View.VISIBLE);
            } else {
                llDesc.setVisibility(View.GONE);
            }

            if (userInfo == null || userInfo.getBeehive() == 0) {
                llBeehives.setVisibility(View.GONE);
            } else {
                llBeehives.setVisibility(View.VISIBLE);

            }
            if (userInfo == null || userInfo.getFollowPitches() == 0) {
                llFollowPitches.setVisibility(View.GONE);
            } else {
                llFollowPitches.setVisibility(View.VISIBLE);
            }

            if (userInfo == null || userInfo.getLaunchedPitches() == 0) {
                llLaunchedPitches.setVisibility(View.GONE);
            } else {
                llLaunchedPitches.setVisibility(View.VISIBLE);
            }

            if (userInfo == null || TextUtils.isEmpty(userInfo.getLevelsList())) {
                llLevels.setVisibility(View.GONE);
            } else {
                llLevels.setVisibility(View.VISIBLE);
            }

            if (userInfo == null || userInfo.getQuestionCount() > 0) {
                llQuestionsCount.setVisibility(View.VISIBLE);
            } else {
                llQuestionsCount.setVisibility(View.GONE);
            }

            if (userInfo == null || userInfo.getAnswerCount() > 0) {
                llAnswers.setVisibility(View.VISIBLE);
            } else {
                llAnswers.setVisibility(View.GONE);
            }

        }
        handler.sendEmptyMessageDelayed(0, 50);
    }

    @Override
    protected void onResume() {
        super.onResume();
        Utils.hideInput(tvNickName);
        if (isChengeRemark) {
            userInfo = DBHelper.getInstance().queryUniqueUserInfo(userId);
            showView();
            isChengeRemark = false;
        }
        initData();
    }

    private void initData() {
        service = ServiceGenerator.createService(ApiService.class);
        Map<String, Object> map = new IdentityHashMap<>();
        map.put("user_id", userId);
        Call<ProfileEntity> repos = service.getUserProfile(map);
        repos.enqueue(new BaseCallBack<ProfileEntity>() {

            @Override
            public void onSuccess(ProfileEntity userInfoEntity) {
                //不更新系统用户信息
                if (userInfo != null && userInfo.getUserType() == UserType.SYSTEM.code) {
                } else {
                    if (userInfo != null) {
                        userInfo = Utils.toUserInfo(userInfoEntity, userInfo);
                    } else {
                        userInfo = Utils.toUserInfo(userInfoEntity);
                    }
                    DBHelper.getInstance().saveUserInfo(userInfo);
                    showView();
                    levelsList.clear();
                    levelsList.addAll(userInfoEntity.getUser().getLevels());
                    levelsList.addAll(userInfoEntity.getUser().getOtherLevels());
                    adapter.notifyDataSetChanged();
                    contactRelation();
                }
                if (userInfo != null) {
                    btnApply.setBackgroundResource(R.drawable.btn_follow_bg);
                    btnApply.setTextColor(getResources().getColor(R.color.white));
                }


            }

            @Override
            protected void onFailure(int code, String msg) {
                if (userInfo == null) {
                    btnApply.setBackgroundColor(getResources().getColor(R.color.text_profile_title_color));
                    btnApply.setTextColor(getResources().getColor(R.color.white));
                }
                Toast.makeText(mContext, "获取用户信息失败，请稍后重试", Toast.LENGTH_SHORT).show();

            }

            @Override
            protected void onFinish() {
                showView();
            }
        });
    }

    private void contactRelation() {
        if (userId != ConstantUtils.USER_ID) {
            if (contactRelation == 1) {//是联系人
                if (userInfo.getUserType() == UserType.NORMAL.code) {
                    llRemarkDes.setVisibility(View.VISIBLE);
                } else {
                    llRemarkDes.setVisibility(View.GONE);
                }

                btnApply.setText(getString(R.string.text_send_message));
            } else {
                if (friendRequestId == -1) {//没有好友请求
                    btnApply.setText(getString(R.string.text_sdd_contact));
                } else {//有好友请求
                    btnApply.setText(getString(R.string.text_accept_contact));
                }
            }
        } else {
            llRemarkDes.setVisibility(View.GONE);
            btnApply.setText("编辑个人信息");
        }
    }


    @OnClick({R.id.ll_answer_counts, R.id.ll_questions_count, R.id.ll_remark, R.id.btn_apply, R.id.iv_head, R.id.ll_follow_pitches, R.id.ll_launched_pitches, R.id.ll_beehives})
    public void onClick(View v) {
        Intent intent = new Intent();
        if (userInfo != null)
            intent.putExtra(IntentKeys.KEY_USER_NAME, userInfo.getName());
        if (userId != ConstantUtils.USER_ID)
            intent.putExtra(IntentKeys.KEY_USER_ID, userId);
        switch (v.getId()) {
            case R.id.iv_back:
                finish();
                break;
            case R.id.iv_share:
                if (userInfo != null) {
                    boolean isShowDel = (contactRelation == 1 && userInfo.getUserType() == UserType.NORMAL.code);
                    popupWindow = new SharePopupWindow(mContext, userId, isShowDel);
                    popupWindow.setFragmentManager(getSupportFragmentManager());
                    popupWindow.setBottomSheetLayout(bottomSheetLayout);
                    popupWindow.setLink(userInfo.getShareUrl());
                    popupWindow.setTitle(Utils.formatStr(userInfo.getName()));
                    popupWindow.setDesc(userInfo.getQuestionCount() + "次提问，" + userInfo.getAnswerCount() + "次回答,\n共同思考,独立投资!");
                    popupWindow.popShow(tvTitle);
                } else {

                }
                break;
            case R.id.ll_answer_counts:
                intent.setClass(mContext, AnswerListActivity.class);
                startActivity(intent);
                break;
            case R.id.ll_questions_count:
                intent.setClass(mContext, QuestionListActivity.class);
                startActivity(intent);
                break;
            case R.id.ll_remark:
                isChengeRemark = true;
                intent = new Intent(mContext, PrivateMessageRemarkActivity.class);
                intent.putExtra(IntentKeys.KEY_USER_INFO, userInfo);
                startActivity(intent);
                break;
            case R.id.btn_apply:
                if (userId == ConstantUtils.USER_ID) {
                    intent.setClass(mContext, PersonalProfileEditActivity.class);
                    startActivity(intent);
                    return;
                }
                if (userInfo != null) {
                    if (contactRelation == 1) {//是联系人
                        intent = new Intent(this, PrivateMessageActivity.class);
                        intent.putExtra(IntentKeys.KEY_TARGET_ID, userInfo.getUserId());
                        intent.putExtra(IntentKeys.KEY_TARGET_TYPE, userInfo.getUserType());
                        startActivity(intent);
                        finish();
                    } else {
                        if (NetworkTool.isNetworkAvailable(mContext)) {
                            dialogFragment.addProgress().show(getSupportFragmentManager(), "loading");
                            if (friendRequestId == -1) {//没有好友请求
                                SendMessageQueue.getInstance().addSendMessage(MessageType.GET_FRIEND_CONFIRMATION,
                                        new GetFriendConfirmationRequest(userInfo.getUserId()));

                            } else {//有好友请求
                                SendMessageQueue.getInstance().addSendMessage(MessageType.ACCEPT_FRIEND_REQUEST,
                                        new AcceptFriendRequest(userInfo.getUserId(), friendRequestId));
                            }
                        } else {
                            Toast.makeText(mContext, "网络未连接，请检查网络设置", Toast.LENGTH_SHORT).show();
                        }
                    }
                }
                break;
            case R.id.iv_head:
                if (userInfo != null) {
                    ArrayList<PhotoModel> photoModels = new ArrayList<>();
                    PhotoModel photoModel = new PhotoModel(userInfo.getHeadImgUrl());
                    photoModels.add(photoModel);
                    intent = new Intent();
                    intent.putExtra("photos", photoModels);
                    intent.setClass(mContext, PhotoPreviewActivity.class);
                    startActivity(intent);
                }
                break;
            default:
                break;
        }
    }

    @OnItemClick(R.id.gv_levels)
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        UserEntity.LevelsBean level = levelsList.get(position);
        Intent intent = new Intent();
        intent.setClass(mContext, WebViewActivity.class);
        intent.putExtra(IntentKeys.KEY_URL, level.getUrl());
        startActivity(intent);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Glide.clear(ivHead);
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
    }

    @Override
    public void receiverMessageSuccess(final MessageType messageType, final BaseRequest request, final Object response) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                switch (messageType) {
                    case LOCAL_LOAD_FRIEND_END:
                        contactRelation = DBHelper.getInstance().queryContactRelations(userId);
                        contactRelation();
                        break;
                    case DELETE_FRIEND:
                        Activity last2Activity = ActivityStack.getInstance().activityAtLast(2);
                        Activity last3Activity = ActivityStack.getInstance().activityAtLast(3);
                        if (last2Activity != null && (last2Activity.getClass() == PrivateMessageDetailActivity.class ||
                                last2Activity.getClass() == PrivateMessageActivity.class)) {
                            last2Activity.finish();
                        }
                        if (last3Activity != null && last3Activity.getClass() == PrivateMessageActivity.class) {
                            last3Activity.finish();
                        }
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                Toast.makeText(mContext, "删除成功", Toast.LENGTH_SHORT).show();
                                finish();
                            }
                        });
                        break;
                    case GET_FRIEND_CONFIRMATION:
                        dialogFragment.dismissAllowingStateLoss();
                        GetFriendConfirmationRequest gfcRequest = (GetFriendConfirmationRequest) request;
                        if (gfcRequest.getFriendUserId() != userId) {
                            return;
                        }
                        GetFriendConfirmationResponse gfcResponse = (GetFriendConfirmationResponse) response;
                        String verificationStr = "我是" + DBHelper.getInstance().queryMyInfo().getName();
                        if (gfcResponse.isStatus()) {
                            Intent intent = new Intent(mContext, FriendVerificationActivity.class);
                            intent.putExtra(IntentKeys.KEY_USER_ID, userId);
                            intent.putExtra(IntentKeys.KEY_VERIFICATION_MSG, verificationStr);
                            startActivity(intent);
                        } else {
                            SendMessageQueue.getInstance().addSendMessage(MessageType.ADD_FRIEND,
                                    new AddFriendRequest(userId, verificationStr));
                        }
                        break;
                    default:
                        break;
                }
            }
        });
    }

    @Override
    public void receiverMessageFail(final MessageType messageType, BaseRequest request, final MessageDTO response) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                switch (messageType) {
                    case DELETE_FRIEND:
                        Toast.makeText(mContext, "删除好友失败", Toast.LENGTH_SHORT).show();
                        break;
                    case ACCEPT_FRIEND_REQUEST:
                        BaseResponse baseResponse = JSON.parseObject(response.getBody(), BaseResponse.class);
                        if (baseResponse.getCode().equals(ResponseCode.FRIEND_REQUEST_EXPIRED)) {
                            BaseDialogFragment dialog = new BaseDialogFragment();
                            dialog.addContent("朋友请求已过期，请主动添加对方")
                                    .addButton(1, "取消", null)
                                    .addButton(2, "添加", new View.OnClickListener() {
                                        @Override
                                        public void onClick(View v) {
                                            SendMessageQueue.getInstance().addSendMessage(MessageType.GET_FRIEND_CONFIRMATION,
                                                    new GetFriendConfirmationRequest(userInfo.getUserId()));
                                        }
                                    }).show(getSupportFragmentManager(), "dialog");
                        }
                        break;
                    case GET_FRIEND_CONFIRMATION:
                    case ADD_FRIEND:
                        dialogFragment.dismissAllowingStateLoss();
                        Toast.makeText(mContext, "添加好友失败,请稍后重试", Toast.LENGTH_SHORT).show();
                        break;
                    default:
                        break;
                }
            }
        });

    }

    @Override
    public void receiverMessageTimeout(final MessageType messageType, BaseRequest request) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                switch (messageType) {
                    case DELETE_FRIEND:
                        Toast.makeText(mContext, "删除好友失败,请稍后重试", Toast.LENGTH_SHORT).show();
                        break;
                    case GET_FRIEND_CONFIRMATION:
                    case ADD_FRIEND:
                        dialogFragment.dismissAllowingStateLoss();
                        Toast.makeText(mContext, "网络异常,请稍后重试", Toast.LENGTH_SHORT).show();
                        break;
                    default:
                        break;
                }
            }
        });
    }
}
