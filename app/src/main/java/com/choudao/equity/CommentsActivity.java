package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.choudao.equity.adapter.CommentAdapter;
import com.choudao.equity.api.MyCallBack;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.base.BaseApiResponse;
import com.choudao.equity.entity.CommentEntity;
import com.choudao.equity.popup.SharePopupWindow;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.TopView;

import java.util.ArrayList;
import java.util.List;

import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;
import retrofit2.Call;

/**
 * Created by liuz on 2016/4/24.
 */
public class CommentsActivity extends BaseActivity implements AdapterView.OnItemClickListener {
    private ListView lvComments;
    private TopView topview;
    private int answerId;
    private int questionid;
    private List<CommentEntity> listComments = new ArrayList<>();
    private CommentAdapter adapter;
    private PtrClassicFrameLayout mPtrFrame;
    private int currentPage = 1;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_comments_list_layout);
        answerId = getIntent().getIntExtra(IntentKeys.KEY_ANSWER_ID, -1);
        questionid = getIntent().getIntExtra(IntentKeys.KEY_QUESTION_ID, -1);
        initView();
        setSubContentView(lvComments);
        showLoadView();
        adapter = new CommentAdapter(mContext, listComments);
        lvComments.setAdapter(adapter);
        lvComments.setOnItemClickListener(this);
    }

    /**
     * 初始化View
     */
    private void initView() {
        lvComments = (ListView) findViewById(R.id.lv_comments);
        topview = (TopView) findViewById(R.id.topview);
        mPtrFrame = (PtrClassicFrameLayout) findViewById(R.id.rotate_header_list_view_frame);
        topview.setTitle(String.format(getString(R.string.text_comment_count), 0));
        initTopView();
        initPtr();
    }

    /**
     * 初始化topview
     */
    private void initTopView() {
        topview.getRightView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                addComment();
            }
        });
        topview.getLeftView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });


    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
        mPtrFrame.setPtrHandler(new PtrDefaultHandler2() {
            @Override
            public void onLoadMoreBegin(PtrFrameLayout frame) {
                initData(currentPage + 1);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, lvComments, header);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, lvComments, footer);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                initData(1);
            }

        });
    }

    private void addComment() {
        Intent intent = new Intent();
        intent.setClass(mContext, CommentAddActivity.class);
        intent.putExtra(IntentKeys.KEY_ANSWER_ID, answerId);
        intent.putExtra(IntentKeys.KEY_QUESTION_ID, questionid);
        startActivity(intent);
    }

    @Override
    protected void onResume() {
        super.onResume();
        initData(1);
    }

    /**
     * 获取数据
     */
    private void initData(int currentPage) {
        Call<BaseApiResponse<List<CommentEntity>>> call = service.getCommentsList(answerId);
        call.enqueue(new MyCallBack<List<CommentEntity>>() {
            @Override
            public void onSuccess(BaseApiResponse<List<CommentEntity>> response) {
                showView(response.getDataSource());
            }

            @Override
            public void onFinish() {
                mPtrFrame.refreshComplete();
            }
        });
    }

    private void showView(List<CommentEntity> commentsListEntity) {
        if (commentsListEntity.size() == 0) {
            mPtrFrame.setMode(PtrFrameLayout.Mode.NONE);
            TextView tvBtn = (TextView) showEmptyView("还没有任何评论").findViewById(R.id.empty_button);
            tvBtn.setVisibility(View.VISIBLE);
            tvBtn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    addComment();
                }
            });
            return;
        }
        showContentView();
        if (listComments != null)
            listComments.clear();
        mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
        listComments.addAll(commentsListEntity);
        topview.setTitle(String.format(getString(R.string.text_comment_count), listComments.size()));
        adapter.notifyDataSetChanged();
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        CommentEntity comment = listComments.get(position);
        boolean isCurrent = false;
        if (comment.getUser().getId() == ConstantUtils.USER_ID) {
            isCurrent = true;
        }
        SharePopupWindow popupWindow = new SharePopupWindow(mContext, comment.getId(), isCurrent);
        popupWindow.setEditCommentId(answerId, comment);
        popupWindow.setDesc(listComments.get(position).getContent());
        popupWindow.popShow(view);
    }
}
