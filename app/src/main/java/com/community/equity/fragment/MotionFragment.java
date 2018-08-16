package com.community.equity.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;

import com.community.equity.LoginActivity;
import com.community.equity.R;
import com.community.equity.api.MyCallBack;
import com.community.equity.base.BaseApiResponse;
import com.community.equity.base.BaseFragment;
import com.community.equity.entity.MotionEntity;
import com.community.equity.fragment.adapter.MotionAdapter;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrDefaultHandler2;
import in.srain.cube.views.ptr.PtrFrameLayout;
import retrofit2.Call;


/**
 * Created by Han on 2016/3/9.
 */
public class MotionFragment extends BaseFragment {
    private List<MotionEntity> listMotion = new ArrayList<>();
    private ListView lvMonion;
    private MotionAdapter adapter;
    private PtrClassicFrameLayout mPtrFrame;
    private int userId;
    private TextView tvTopTip;
    private int mCurrentPage = 1;
    private String userName;
    private boolean isFromProfile = false;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_monion_layout, null);
        setParentView(view);
        initView(view);
        userName = getActivity().getIntent().getStringExtra(IntentKeys.KEY_USER_NAME);
        setSubContentView(lvMonion);
        showLoadView();
        adapter = new MotionAdapter(this, listMotion);
        lvMonion.setAdapter(adapter);
        initData(mCurrentPage);
        return view;
    }

    public void setUserId(int userId) {
        this.userId = userId;
        isFromProfile = true;
    }

    /**
     * 初始化view
     *
     * @param view
     */
    private void initView(View view) {
        tvTopTip = (TextView) view.findViewById(R.id.tv_top_tip);
        TopView topView = (TopView) view.findViewById(R.id.topview);
        tvTopTip.setVisibility(View.GONE);
        if (isFromProfile) {
            if (userId > 0) {
                topView.setTitle("Ta的动态");
            } else {
                topView.setTitle("我的动态");
            }
        } else {
            topView.setTitle("动态");
            topView.setRightImage();
        }
        lvMonion = (ListView) view.findViewById(R.id.lv_monion);
        mPtrFrame = (PtrClassicFrameLayout) view.findViewById(R.id.rotate_header_list_view_frame);
        if (isFromProfile) {
            topView.getLeftView().setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    getActivity().finish();
                }
            });
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
                return super.checkCanDoLoadMore(frame, lvMonion, footer);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, lvMonion, header);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                initData(1);
            }

        });
    }


    private void initData(int page) {
        Call<BaseApiResponse<List<MotionEntity>>> call;
        Map<String, Object> params = new IdentityHashMap<>();
        params.put("page", page);


        if (isFromProfile) {
            if (userId > 0) {
                params.put("user_id", userId);
            }
            call = service.getUserActivities(params);
        } else {
            call = service.getActivities(params);
        }

        call.enqueue(new MyCallBack<List<MotionEntity>>() {
            @Override
            public void onSuccess(BaseApiResponse<List<MotionEntity>> response) {
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
                        if (code == 401) {
                            startNewActivity();

                        } else if (code == 99) {
                            Intent intent = new Intent(android.provider.Settings.ACTION_SETTINGS);
                            startActivity(intent);
                        }
                    }
                });
            }
        });
    }

    private void showView(BaseApiResponse<List<MotionEntity>> motionEntity) {
        mCurrentPage = motionEntity.getCurrent_page();
        if (mCurrentPage == 1)
            listMotion.clear();
        listMotion.addAll(motionEntity.getDataSource());

        if (isFromProfile) {
            tvTopTip.setText("共" + motionEntity.getTotal() + "条动态");
            tvTopTip.setVisibility(View.VISIBLE);
        } else {
            tvTopTip.setVisibility(View.GONE);
        }


        if (listMotion.size() == 0) {
            String emptyTip = "还没有任何动态\n关注他人可获得最新动态";
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
            if (userId > 0)
                tvTopTip.setVisibility(View.VISIBLE);
            if (listMotion.size() >= motionEntity.getTotal()) {
                mPtrFrame.setMode(PtrFrameLayout.Mode.REFRESH);
            } else {
                mPtrFrame.setMode(PtrFrameLayout.Mode.BOTH);

            }
            showContentView();
        }
        mPtrFrame.refreshComplete();

    }

    private void startNewActivity() {
        Intent intent = new Intent(getActivity(), LoginActivity.class);
        startActivity(intent);

    }

}
