package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.provider.Settings;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.choudao.equity.adapter.QuestionsAdapter;
import com.choudao.equity.api.MyCallBack;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.base.BaseApiResponse;
import com.choudao.equity.entity.QuestionEntity;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.TopView;

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


public class QuestionListActivity extends BaseActivity {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.tv_top_tip) TextView tvTopTip;
    @BindView(R.id.lv_question) ListView lvQuestion;
    @BindView(R.id.rotate_header_list_view_frame) PtrClassicFrameLayout mPtrFrame;
    private int userId;
    private QuestionsAdapter adapter;
    private List<QuestionEntity> listQuestion = new ArrayList<>();
    private int currentPage = 1;
    private String userName = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_question_list_layout);
        ButterKnife.bind(this);
        setSubContentView(lvQuestion, tvTopTip);
        showLoadView();
        userId = getIntent().getIntExtra(IntentKeys.KEY_USER_ID, -1);
        userName = getIntent().getStringExtra(IntentKeys.KEY_USER_NAME);
        initView();

        adapter = new QuestionsAdapter(mContext, listQuestion);
        lvQuestion.setAdapter(adapter);
        initData(currentPage);
    }


    private void initView() {
        tvTopTip.setVisibility(View.GONE);
        topView.getLeftView();
        if (userId > 0) {
            topView.setTitle(R.string.text_question_title);
        } else {
            topView.setTitle(R.string.text_my_questions);
        }
        initPtr();
    }

    @OnClick(R.id.iv_left)
    public void onClick() {
        finish();
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
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, lvQuestion, header);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, lvQuestion, footer);
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

        Call<BaseApiResponse<List<QuestionEntity>>> call = service.getUserQuestions(params);
        call.enqueue(new MyCallBack<List<QuestionEntity>>() {
            @Override
            public void onSuccess(BaseApiResponse<List<QuestionEntity>> response) {
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

    private void showView(BaseApiResponse<List<QuestionEntity>> questionListEntity) {
        currentPage = questionListEntity.getCurrent_page();
        if (currentPage == 1)
            listQuestion.clear();
        listQuestion.addAll(questionListEntity.getDataSource());
        if (listQuestion.size() == 0) {
            String emptyTip = "暂时没有提问";
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
            tvTopTip.setText("共提出了" + questionListEntity.getTotal() + "个问题");

            if (listQuestion.size() >= questionListEntity.getTotal()) {
                mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
            } else {
                mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);

            }
            showContentView();
        }
        mPtrFrame.refreshComplete();
    }

    @OnItemClick(R.id.lv_question)
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        QuestionEntity question = listQuestion.get(position);
        Intent intent = new Intent();
        intent.putExtra(IntentKeys.KEY_QUESTION_ID, question.getId());
        intent.setClass(mContext, QuestionDetailsActivity.class);
        startActivity(intent);
    }
}
