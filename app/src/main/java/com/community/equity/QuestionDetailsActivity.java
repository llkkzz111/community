package com.community.equity;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.community.equity.adapter.AnswersAdapter;
import com.community.equity.api.BaseCallBack;
import com.community.equity.api.ServiceGenerator;
import com.community.equity.api.service.ApiService;
import com.community.equity.base.BaseActivity;
import com.community.equity.entity.AnswerEntity;
import com.community.equity.entity.QuestionEntity;
import com.community.equity.entity.ShareWechatInfo;
import com.community.equity.popup.InviteAnswerPopupWindow;
import com.community.equity.popup.SharePopupWindow;
import com.community.equity.utils.CropSquareTransformation;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.CDWebView;
import com.community.equity.view.FixGridLayout;
import com.community.equity.view.LinearLineWrapLayout;
import com.community.equity.view.MyListView;
import com.community.equity.view.TopView;
import com.community.equity.view.bottomsheet.BottomSheetLayout;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemClick;
import retrofit2.Call;

/**
 * Created by liuzhao on 16/4/15.
 */
public class QuestionDetailsActivity extends BaseActivity {
    @BindView(R.id.topview)
    TopView topView;
    @BindView(R.id.iv_user_head)
    ImageView ivHead;
    @BindView(R.id.tv_user_name)
    TextView tvUserName;
    @BindView(R.id.tv_user_title)
    TextView tvUserTitle;
    @BindView(R.id.fgl_tags)
    FixGridLayout fglTags;
    @BindView(R.id.tv_question_title)
    TextView tvQuestionTitle;
    @BindView(R.id.wvQuestionDetail)
    CDWebView webView;
    @BindView(R.id.tv_follow_count)
    TextView tvFollowCount;
    @BindView(R.id.btn_follow)
    TextView btnFollow;
    @BindView(R.id.ll_no_answers)
    LinearLayout llNoAnswer;
    @BindView(R.id.lv_answers)
    MyListView lvAnswers;
    @BindView(R.id.view_bootom_line)
    View vBottomLine;
    @BindView(R.id.tv_invite_answer)
    TextView tvInviteAnswer;
    @BindView(R.id.tv_add_answer)
    TextView tvAddAnswer;
    @BindView(R.id.tv_answer_review_me)
    TextView tvReviewAnswer;
    @BindView(R.id.ll_content)
    LinearLayout llContent;
    @BindView(R.id.bottomsheet)
    BottomSheetLayout bottomSheetLayout;

    Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            showContentView();
        }
    };
    private int questionId;
    private List<AnswerEntity> listAnswer = new ArrayList<>();
    private AnswersAdapter adapter;
    private QuestionEntity entity;
    private SharePopupWindow popupWindow;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_question_details_layout);
        ButterKnife.bind(this);
        setSubContentView(llContent);
        showLoadView();
        initView();
        questionId = getIntent().getIntExtra(IntentKeys.KEY_QUESTION_ID, -1);

    }

    /**
     * 初始化View
     */
    private void initView() {
        initTopView();
        adapter = new AnswersAdapter(mContext, listAnswer);
        lvAnswers.setAdapter(adapter);
        initWebViewClient();
    }

    /**
     * 初始化TopView
     */
    private void initTopView() {
        topView.setTitle("正在加载...");
        topView.setLeftImage();
        topView.setRightImage(R.drawable.icon_title_function);
    }

    /**
     * 初始化WebView控件
     */
    private void initWebViewClient() {
        webView.getSettings().setUseWideViewPort(false);
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                Uri uri = Uri.parse(url);
                Intent intent = new Intent();
                intent.setData(uri);
                intent.setAction("com.community.equity.action");
                startActivity(intent);
                return true;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                handler.sendEmptyMessageDelayed(0, 100);
            }
        });
    }

    private void initData(final boolean isFirst) {
        service = ServiceGenerator.createService(ApiService.class);
        Call<QuestionEntity> call = service.getQuestion(questionId);
        call.enqueue(new BaseCallBack<QuestionEntity>() {
            @Override
            protected void onSuccess(QuestionEntity body) {
                entity = body;
                showView(entity, isFirst);
            }

            @Override
            protected void onFailure(int code, String msg) {
                if (code == 401) {
                    showErrorView("当前未登录,点击跳转登陆界面").findViewById(R.id.error_message).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            startNewActivity();
                        }
                    });

                } else if (code == 99) {
                    showErrorView("请检查当前网络状态\n点击跳转设置界面").findViewById(R.id.error_message).setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent intent = new Intent(Settings.ACTION_SETTINGS);
                            startActivity(intent);
                        }
                    });
                } else {
                    String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                    sInfoFormat = String.format(sInfoFormat, msg, String.valueOf(code));
                    showErrorView(sInfoFormat);
                }
            }
        });
    }

    private void startNewActivity() {
        Intent intent = new Intent(mContext, LoginActivity.class);
        startActivity(intent);

    }

    /**
     * 将数据set到对应的view中
     *
     * @param entity
     * @param isFirst
     */
    private void showView(QuestionEntity entity, boolean isFirst) {
        //第一次进入时加载非列表内容
        if (isFirst) {
            if (!TextUtils.isEmpty(entity.getContent())) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    webView.loadDataWithBaseURL("", String.format(getString(R.string.text_web_view_html), entity.getContent()), "text/html; charset=UTF-8", null, null);
                } else {
                    webView.loadUrl("");
                    webView.loadData(String.format(getString(R.string.text_web_view_html), entity.getContent()), "text/html; charset=UTF-8", null);
                }
            } else {
                showContentView();
            }
            if (fglTags.getChildCount() > 0) {
                fglTags.removeAllViews();
            }
            for (int i = 0; i < entity.getTags().size(); i++) {
                addItemView(fglTags, entity.getTags().get(i).getName());
            }
            String title = Utils.formatStr(entity.getTitle().trim());

            tvQuestionTitle.setText(title);
            tvUserName.setText(entity.getUser().getName());

            if (!TextUtils.isEmpty(entity.getUser().getTitle())) {
                if (TextUtils.isEmpty(entity.getUser().getTitle().trim())) {
                    tvUserTitle.setVisibility(View.GONE);
                } else {
                    tvUserTitle.setVisibility(View.VISIBLE);
                    tvUserTitle.setText(entity.getUser().getTitle());
                }
            } else {
                tvUserTitle.setVisibility(View.GONE);
            }

            btnFollow.setVisibility(View.VISIBLE);
            if (Util.isOnMainThread() && !isDestory)
                Glide.with(this).load(entity.getUser().getImg()).centerCrop().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext))
                        .into(ivHead);

        }
        checkFollow(entity.getFollowed());
        tvFollowCount.setText(String.format(getString(R.string.text_follow_count), entity.getFollowers_count()));
        topView.setTitle(String.format(getString(R.string.text_title_answer_count), entity.getAnswersCount()));
        if (entity.getAnswersCount() > 0) {
            listAnswer.clear();
            listAnswer.addAll(entity.getAnswers());
            showEmptyAnswer();
            adapter.notifyDataSetChanged();
        }
        if (entity.getMyAnswer() != null) {
            tvAddAnswer.setVisibility(View.GONE);
            tvReviewAnswer.setVisibility(View.VISIBLE);
        } else {
            tvReviewAnswer.setVisibility(View.GONE);
            tvAddAnswer.setVisibility(View.VISIBLE);
        }

    }


    private void addItemView(LinearLineWrapLayout viewGroup, String text) {
        final View v = LayoutInflater.from(mContext).inflate(R.layout.tag_text_layout, null);
        TextView tvItem = (TextView) v.findViewById(R.id.tv_tags);
        tvItem.setText(text);
        viewGroup.addView(v);
    }

    /**
     * 设置关注状态
     *
     * @param isFollowed
     */
    private void checkFollow(boolean isFollowed) {
        if (isFollowed) {
            btnFollow.setText(R.string.text_already_follow);
            btnFollow.setSelected(true);
        } else {
            btnFollow.setText(R.string.text_follow);
            btnFollow.setSelected(false);
        }
    }

    /**
     * 根据listAnswer的长度判断是否显示空view
     */
    private void showEmptyAnswer() {
        if (listAnswer.size() > 0) {
            llNoAnswer.setVisibility(View.GONE);
            vBottomLine.setVisibility(View.VISIBLE);
        } else {
            llNoAnswer.setVisibility(View.VISIBLE);
            vBottomLine.setVisibility(View.GONE);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        Utils.hideInput(topView);
        initData(true);
    }

    @OnClick({R.id.iv_user_head, R.id.btn_follow, R.id.tv_invite_answer, R.id.tv_add_answer, R.id.tv_answer_review_me, R.id.iv_left, R.id.iv_right})
    public void onClick(View v) {
        Intent intent = new Intent();
        switch (v.getId()) {
            case R.id.iv_user_head:
                intent.setClass(mContext, PersonalProfileActivity.class);
                intent.putExtra(IntentKeys.KEY_USER_ID, entity.getUser().getId());
                intent.putExtra(IntentKeys.KEY_USER_NAME, entity.getUser().getName());
                mContext.startActivity(intent);
                break;
            case R.id.tv_add_answer:
                intent.setClass(this, AnswerAddActivity.class);
                intent.putExtra(IntentKeys.KEY_QUESTION_ID, questionId);
                startActivityForResult(intent, 9999);
                break;
            case R.id.btn_follow:
                setToggleFollow();
                break;
            case R.id.tv_invite_answer:
                InviteAnswerPopupWindow inviteAnswer = new InviteAnswerPopupWindow(mContext);
                ShareWechatInfo wechatInfo = new ShareWechatInfo();
                wechatInfo.setLink(entity.getShare_url());
                wechatInfo.setTitle(entity.getCurrentUser().getName() + " 邀请你回答：" + entity.getTitle());
                wechatInfo.setDesc(entity.getFollowers_count() + "人已关注，\n" + entity.getAnswersCount() + "人已回答，\n" + "共同思考，独立投资！");
                inviteAnswer.setShareWeChatInfo(wechatInfo);
                inviteAnswer.popShow(topView);
                break;
            case R.id.tv_answer_review_me:
                intent.setClass(this, SingleAnswerActivity.class);
                intent.putExtra(IntentKeys.KEY_QUESTION_ID, questionId);
                intent.putExtra(IntentKeys.KEY_QUESTION_TITLE, entity.getTitle());
                startActivity(intent);
                break;
            case R.id.iv_left:
                finish();
                break;
            case R.id.iv_right:
                if (entity != null) {
                    popupWindow = new SharePopupWindow(mContext, questionId);
                    popupWindow.setBottomSheetLayout(bottomSheetLayout);
                    popupWindow.setQuestionEntity(entity);
                    popupWindow.setLink(entity.getShare_url());
                    popupWindow.setTitle(Utils.formatStr(entity.getTitle()));
                    popupWindow.setDesc(entity.getFollowers_count() + "人关注，\n" + entity.getAnswersCount() + "个回答，\n共同思考，独立投资!");
                    popupWindow.popShow(topView);
                }
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            if (data.hasExtra(IntentKeys.KEY_ANSWER_ENTITY)) {
                initData(false);
            }
        }
    }


    @OnItemClick(R.id.lv_answers)
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        AnswerEntity answer = listAnswer.get(position);
        Intent intent = new Intent();
        intent.setClass(mContext, SingleAnswerActivity.class);
        intent.putExtra(IntentKeys.KEY_QUESTION_ID, questionId);
        intent.putExtra(IntentKeys.KEY_ANSWER_ID, answer.getId());
        intent.putExtra(IntentKeys.KEY_QUESTION_TITLE, answer.getQuestionTitle());
        startActivity(intent);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Glide.clear(ivHead);
    }

    private void setToggleFollow() {
        Call<QuestionEntity> call = service.setQuestionFollow(questionId);
        call.enqueue(new BaseCallBack<QuestionEntity>() {
            @Override
            protected void onSuccess(QuestionEntity body) {
                showView(body, false);
            }

            @Override
            protected void onFailure(int code, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                Toast.makeText(getBaseContext(), String.format(sInfoFormat, msg, String.valueOf(code)), Toast.LENGTH_SHORT).show();
            }
        });
    }

}