package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.community.equity.adapter.PersonalsAdapter;
import com.community.equity.api.MyCallBack;
import com.community.equity.base.BaseActivity;
import com.community.equity.base.BaseApiResponse;
import com.community.equity.entity.UserEntity;
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

public class PersonalListActivity extends BaseActivity {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.tv_top_tip) TextView tvTopTip;
    @BindView(R.id.lv_persons) ListView lvPersons;
    @BindView(R.id.rotate_header_list_view_frame) PtrClassicFrameLayout mPtrFrame;
    private int userId = -1;
    private String personalType = "";// fans 粉丝； follow 关注
    private List<UserEntity> listUsers = new ArrayList<>();
    private PersonalsAdapter adapter;
    private int mCurrentPage = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_personal_list_layout);
        ButterKnife.bind(this);
        userId = getIntent().getIntExtra(IntentKeys.KEY_USER_ID, -1);
        personalType = getIntent().getStringExtra(IntentKeys.KEY_PERSONAL_TYPE);
        initView();
        setSubContentView(lvPersons);
        showLoadView();
        adapter = new PersonalsAdapter(mContext, listUsers);
        lvPersons.setAdapter(adapter);
        initData(mCurrentPage);

    }


    private void initView() {
        tvTopTip.setVisibility(View.GONE);
        topView.setLeftImage();
        if (personalType.equals("fans")) {
            if (userId > 0) {
                topView.setTitle(getString(R.string.text_ta_fans));
            } else {
                topView.setTitle(getString(R.string.text_my_fans));
            }
        } else if (personalType.equals("follow")) {
            if (userId > 0) {
                topView.setTitle(getString(R.string.text_ta_follow));
            } else {
                topView.setTitle(getString(R.string.text_my_follow));
            }
        }

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
                initData(mCurrentPage + 1);
            }

            @Override
            public boolean checkCanDoLoadMore(PtrFrameLayout frame, View content, View footer) {
                return super.checkCanDoLoadMore(frame, lvPersons, footer);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return checkContentCanBePulledDown(frame, lvPersons, header);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                initData(1);
            }

        });
    }


    @OnClick(R.id.iv_left)
    public void onClick() {
        finish();
    }

    private void initData(int page) {
        Call<BaseApiResponse<List<UserEntity>>> call = null;
        Map<String, Object> params = new IdentityHashMap<>();
        params.put("page", page);
        if (userId > 0) {
            params.put("user_id", userId);
        }
        if (personalType.equals("fans")) {
            call = service.getUserFollowers(params);
        } else if (personalType.equals("follow")) {
            call = service.getUserFnas(params);
        }
        call.enqueue(new MyCallBack<List<UserEntity>>() {
            @Override
            public void onSuccess(BaseApiResponse<List<UserEntity>> response) {
                showView(response);
            }

            @Override
            public void onFailure(int code, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                sInfoFormat = String.format(sInfoFormat, msg, String.valueOf(code));
                showErrorView(sInfoFormat);
                mPtrFrame.refreshComplete();
                tvTopTip.setVisibility(View.GONE);
                mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
            }
        });
    }

    private void showView(BaseApiResponse<List<UserEntity>> userListEntity) {

        mCurrentPage = userListEntity.getCurrent_page();
        if (mCurrentPage == 1)
            listUsers.clear();
        listUsers.addAll(userListEntity.getDataSource());
        if (listUsers.size() == 0) {
            if (userId > 0) {
                mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
            } else {
                mPtrFrame.setMode(PtrFrameLayout.Mode.NONE);
            }
            if (personalType.equals("fans")) {
                showEmptyView("没有被人关注");
            } else if (personalType.equals("follow")) {
                showEmptyView("没有关注人");
            }
            tvTopTip.setVisibility(View.GONE);
        } else {
            adapter.notifyDataSetChanged();
            tvTopTip.setVisibility(View.VISIBLE);
            if (personalType.equals("fans")) {
                tvTopTip.setText("被" + listUsers.size() + "人关注");
            } else if (personalType.equals("follow")) {
                tvTopTip.setText("关注了" + listUsers.size() + "人");
            }
            if (listUsers.size() == userListEntity.getTotal()) {
                mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
            } else {
                mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);

            }
            showContentView();
        }
        mPtrFrame.refreshComplete();


    }

    @OnItemClick(R.id.lv_persons)
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        Intent intent = new Intent();
        intent.setClass(mContext, PersonalProfileActivity.class);
        intent.putExtra(IntentKeys.KEY_USER_ID, listUsers.get(position).getId());
        intent.putExtra(IntentKeys.KEY_USER_NAME, listUsers.get(position).getName());
        startActivity(intent);
    }
}
