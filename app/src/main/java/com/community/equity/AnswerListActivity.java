package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.provider.Settings;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.community.equity.adapter.ProfileAnswersAdapter;
import com.community.equity.api.MyCallBack;
import com.community.equity.base.BaseActivity;
import com.community.equity.base.BaseApiResponse;
import com.community.equity.entity.AnswerEntity;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;
import retrofit2.Call;


public class AnswerListActivity extends BaseActivity {

    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.tv_top_tip) TextView tvTopTip;
    @BindView(R.id.lv_answers) ListView lvAnswers;
    @BindView(R.id.rotate_header_list_view_frame) PtrClassicFrameLayout mPtrFrame;
    private int userId;
    private ProfileAnswersAdapter adapter;
    private List<AnswerEntity> listAnswer = new ArrayList<>();
    private int currentPage = 1;
    private String userName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_answer_list_layout);
        ButterKnife.bind(this);
        setSubContentView(lvAnswers,tvTopTip);
        showLoadView();
        initView();
        adapter = new ProfileAnswersAdapter(mContext, listAnswer);
        lvAnswers.setAdapter(adapter);
        initData(1);
    }

    private void initView() {
        userName = getIntent().getStringExtra(IntentKeys.KEY_USER_NAME);
        userId = getIntent().getIntExtra(IntentKeys.KEY_USER_ID, -1);

        tvTopTip.setVisibility(View.GONE);
        if (userId > 0) {
            topView.setTitle(R.string.text_answers_title);
        } else {
            topView.setTitle(R.string.text_my_answers);
        }
        topView.setLeftImage();
        initPtr();
    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setPtrHandler(new PtrDefaultHandler2() {
            @Override
            public void onLoadMoreBegin(PtrFrameLayout frame) {
                initData(currentPage + 1);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, lvAnswers, footer);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, lvAnswers, header);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                initData(1);
            }

        });
    }


    private void initData(int page) {
        Map<String, Object> params = new IdentityHashMap<>();
        if (userId > 0) {
            params.put("user_id", userId);
        }
        params.put("page", page);

        Call<BaseApiResponse<List<AnswerEntity>>> call = service.getUserAnswers(params);
        call.enqueue(new MyCallBack<List<AnswerEntity>>() {
            @Override
            public void onSuccess(BaseApiResponse<List<AnswerEntity>> response) {
                showView(response);
            }

            @Override
            public void onFailure(final int code, String msg) {
                mPtrFrame.refreshComplete();
                tvTopTip.setVisibility(View.GONE);
                mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
                if (code == 99) {
                    msg = "请检查当前网络状态\n 点击跳转设置界面";
                }
                showErrorView(msg).findViewById(R.id.error_message).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (code == 99) {
                            Intent intent = new Intent(Settings.ACTION_SETTINGS);
                            startActivity(intent);
                        }
                    }
                });
            }
        });

    }

    private void showView(BaseApiResponse<List<AnswerEntity>> answerListEntity) {
        currentPage = answerListEntity.getCurrent_page();
        tvTopTip.setText("共回答了" + answerListEntity.getTotal() + "个问题");
        if (currentPage == 1) {
            listAnswer.clear();
        }
        listAnswer.addAll(answerListEntity.getDataSource());

        if (listAnswer.size() == 0) {
            String emptyTip = "暂时没有回答问题";
            if (userId > 0) {
                emptyTip = userName + emptyTip;
            }
            showEmptyView(emptyTip);
            if (userId > 0) {
                mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
            } else {
                mPtrFrame.setMode(PtrFrameLayout.Mode.NONE);
            }
            tvTopTip.setVisibility(View.GONE);
        } else {
            adapter.notifyDataSetChanged();
            tvTopTip.setVisibility(View.VISIBLE);
            if (listAnswer.size() >= answerListEntity.getTotal()) {
                mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
            } else {
                mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);

            }
            showContentView();
        }
        mPtrFrame.refreshComplete();
    }

    @OnClick(R.id.iv_left)
    public void onClick(View v) {
        finish();
    }

    @OnItemClick(R.id.lv_answers)
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        AnswerEntity question = listAnswer.get(position);
        Intent intent = new Intent();
        intent.putExtra(IntentKeys.KEY_QUESTION_ID, question.getQuestion_id());
        intent.setClass(mContext, QuestionDetailsActivity.class);
        startActivity(intent);
    }
}
