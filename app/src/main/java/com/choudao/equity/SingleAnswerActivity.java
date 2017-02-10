package com.choudao.equity;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.support.annotation.Nullable;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.entity.AnswerEntity;
import com.choudao.equity.popup.SharePopupWindow;
import com.choudao.equity.utils.ActivityStack;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.CDWebView;
import com.choudao.equity.view.TopView;
import com.choudao.equity.view.bottomsheet.BottomSheetLayout;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit2.Call;


/**
 * Created by liuzhao on 16/4/21.
 */
public class SingleAnswerActivity extends BaseActivity {
    @BindView(R.id.topview)
    TopView topView;
    @BindView(R.id.tv_question_title)
    TextView tvQuestionTitle;
    @BindView(R.id.iv_user_head)
    ImageView ivHead;
    @BindView(R.id.tv_user_name)
    TextView tvName;
    @BindView(R.id.tv_user_title)
    TextView tvTitle;
    @BindView(R.id.tv_support_count)
    TextView tvSupportCount;
    @BindView(R.id.webview)
    CDWebView webview;
    @BindView(R.id.tv_comments)
    TextView tvComments;
    @BindView(R.id.ll_content)
    LinearLayout llContent;
    @BindView(R.id.bottomsheet)
    BottomSheetLayout bottomSheetLayout;

    private SharePopupWindow popupWindow;
    private AnswerEntity answer;
    private BaseDialogFragment dialogFragment;

    private int questionId;
    private int answerId;
    private String questionTitle;
    private boolean isCurrent = false;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_single_answer_layout);
        ButterKnife.bind(this);
        setSubContentView(llContent);
        showLoadView();
        questionId = getIntent().getIntExtra(IntentKeys.KEY_QUESTION_ID, -1);
        questionTitle = getIntent().getStringExtra(IntentKeys.KEY_QUESTION_TITLE);
        initView();
        initWebViewClient();
    }

    /**
     * 初始化view
     */
    private void initView() {
        webview.getSettings().setUseWideViewPort(false);
        initTopView();
    }

    /**
     * 初始化TopView
     */
    private void initTopView() {
        topView.setTitle("回答");
        topView.setLeftImage();
    }

    /**
     * 初始化WebView控件
     */
    private void initWebViewClient() {
        webview.getSettings().setUseWideViewPort(false);
        webview.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                Uri uri = Uri.parse(url);
                Intent intent = new Intent();
                intent.setData(uri);
                intent.setAction("com.choudao.equity.action");
                startActivity(intent);
                return true;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                showContentView();
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        Utils.hideInput(topView);
        getAnswer();
    }

    private void getAnswer() {
        service = ServiceGenerator.createService(ApiService.class);
        Call<AnswerEntity> call = null;
        if (getIntent().hasExtra(IntentKeys.KEY_ANSWER_ID)) {
            answerId = getIntent().getIntExtra(IntentKeys.KEY_ANSWER_ID, -1);
            call = service.getSingleAnswer(questionId, answerId);
        } else {
            call = service.getMyAnswer(questionId);
        }
        call.enqueue(new BaseCallBack<AnswerEntity>() {
            @Override
            protected void onSuccess(AnswerEntity body) {
                answer = body;
                setData();
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

    private void setData() {
        Drawable drawable = getResources().getDrawable(R.drawable.icon_like_default);
        if ("up".equals(answer.getChosen())) {
            drawable = getResources().getDrawable(R.drawable.icon_like_up);
        } else if ("down".equals(answer.getChosen())) {
            drawable = getResources().getDrawable(R.drawable.icon_like_down);
        }
        if (drawable != null)
            tvSupportCount.setCompoundDrawablesWithIntrinsicBounds(drawable, null, null, null);
        questionTitle = answer.getQuestionTitle();
        tvQuestionTitle.setText(questionTitle);
        tvSupportCount.setText(answer.getVotes_weight() + "");
        tvComments.setText(String.format(getString(R.string.text_comment_count), answer.getCommentsCount()));
        tvName.setText(answer.getUser().getName());
        tvTitle.setText(answer.getUser().getTitle());
        if (Util.isOnMainThread() && !isDestory)
            Glide.with(mContext).load(answer.getUser().getImg()).centerCrop().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext))
                    .into(ivHead);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            webview.loadDataWithBaseURL("", String.format(getString(R.string.text_answer_web_view_html), answer.getContent()), "text/html; charset=UTF-8", null, null);
        } else {
            webview.loadUrl("");
            webview.loadData(String.format(getString(R.string.text_answer_web_view_html), answer.getContent()), "text/html; charset=UTF-8", null);
        }
        topView.setRightImage(R.drawable.icon_title_function);

        isCurrent = answer.getUser().getId() == ConstantUtils.USER_ID;
        topView.getRightView().setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                popupWindow = new SharePopupWindow(mContext, answerId, isCurrent);
                popupWindow.setBottomSheetLayout(bottomSheetLayout);
                popupWindow.setLink(answer.getShare_url());
                popupWindow.setTitle(questionTitle + " " + answer.getUser().getName() + " 的回答");
                popupWindow.setDesc(answer.getSafe_content());
                popupWindow.setEditAnswerId(questionId, answer);
                popupWindow.popShow(topView);
            }
        });
        showContentView();
    }

    @OnClick({R.id.iv_user_head, R.id.tv_support_count, R.id.tv_question_title, R.id.iv_left, R.id.tv_comments})
    public void onClick(View v) {
        Intent intent = new Intent();
        switch (v.getId()) {
            case R.id.iv_user_head:
                intent.setClass(mContext, PersonalProfileActivity.class);
                intent.putExtra(IntentKeys.KEY_USER_ID, answer.getUser().getId());
                intent.putExtra(IntentKeys.KEY_USER_NAME, answer.getUser().getName());
                startActivity(intent);
                break;
            case R.id.tv_support_count:
                showDialog();
                break;
            case R.id.tv_question_title:
            case R.id.iv_left:
                if (!(ActivityStack.getInstance().activityAtLast(2) instanceof QuestionDetailsActivity)) {
                    intent.setClass(mContext, QuestionDetailsActivity.class);
                    intent.putExtra(IntentKeys.KEY_QUESTION_ID, questionId);
                    startActivity(intent);
                    animRightToLeft();
                }
                ActivityStack.getInstance().finishActivity();
                break;
            case R.id.tv_comments:
                intent.setClass(mContext, CommentsActivity.class);
                intent.putExtra(IntentKeys.KEY_ANSWER_ID, answer.getId());
                intent.putExtra(IntentKeys.KEY_QUESTION_ID, questionId);
                startActivity(intent);
                break;
        }
    }

    /**
     * 显示态度设置dialog
     */
    private void showDialog() {
        dialogFragment = BaseDialogFragment.newInstance(BaseDialogFragment.DIALOG_CANCLE_ABLE);
        View ll = LinearLayout.inflate(mContext, R.layout.dialog_answer_panel_layout, null);
        ToggleButton tgUp = (ToggleButton) ll.findViewById(R.id.tb_answer_up);
        ToggleButton tgDown = (ToggleButton) ll.findViewById(R.id.tb_answer_down);
        if ("up".equals(answer.getChosen())) {
            tgUp.setChecked(true);
        } else if ("down".equals(answer.getChosen())) {
            tgDown.setChecked(true);
        }
        tgUp.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                dialogFragment.dismissAllowingStateLoss();
                setAnswerVoteState(v);
            }
        });
        tgDown.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                dialogFragment.dismissAllowingStateLoss();
                setAnswerVoteState(v);
            }
        });
        setViewHeight(ll);
        dialogFragment.addView(ll);
        dialogFragment.show(getSupportFragmentManager(), "panel");
    }

    /**
     * 根据状态设置态度
     *
     * @param v
     */
    private void setAnswerVoteState(View v) {
        String vote = "unvote";
        switch (v.getId()) {
            case R.id.tb_answer_down:
                if (!"down".equals(answer.getChosen())) {
                    vote = "vote_down";
                }
                break;
            case R.id.tb_answer_up:
                if (!"up".equals(answer.getChosen())) {
                    vote = "vote_up";
                }
                break;

        }
        Call<AnswerEntity> call = service.setVoteAnswer(answer.getId(), vote);
        call.enqueue(new BaseCallBack<AnswerEntity>() {
            @Override
            protected void onSuccess(AnswerEntity body) {
                answer = body;
                setData();
            }

            @Override
            protected void onFailure(int code, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                Toast.makeText(getBaseContext(), String.format(sInfoFormat, msg, String.valueOf(code)), Toast.LENGTH_SHORT).show();
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        Glide.clear(ivHead);
    }

    /**
     * 设置View高度
     *
     * @param view
     */
    private void setViewHeight(final View view) {
        final ViewTreeObserver vto = view.getViewTreeObserver();
        vto.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
            public boolean onPreDraw() {
                view.getViewTreeObserver().removeOnPreDrawListener(this);
                int width = ConstantUtils.SCREEN_WIDTH * 8 / 10;

                ViewGroup.LayoutParams layoutParams = view.getLayoutParams();
                layoutParams.height = ViewGroup.LayoutParams.WRAP_CONTENT;
                layoutParams.width = width;
                view.setLayoutParams(layoutParams);
                return true;
            }
        });
    }
}
