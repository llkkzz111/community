package com.community.equity.fragment;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.community.equity.CheckTagActivity;
import com.community.equity.QuestionDetailsActivity;
import com.community.equity.R;
import com.community.equity.api.MyCallBack;
import com.community.equity.base.BaseApiResponse;
import com.community.equity.base.BaseFragment;
import com.community.equity.entity.QuestionEntity;
import com.community.equity.fragment.adapter.CommunityAdapter;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;

import java.util.ArrayList;
import java.util.List;

import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;
import retrofit2.Call;

/**
 * Created by Han on 2016/3/9.
 */
public class CommunityFragment extends BaseFragment implements View.OnClickListener, AdapterView.OnItemClickListener {
    private ListView lvCommunity;
    private PtrClassicFrameLayout mPtrFrame;
    private CommunityAdapter adapter;
    private List<QuestionEntity> listQuestion = new ArrayList<>();
    private LinearLayout llHot, llNew, llCreen;
    private String type = "questions/hottest.json";
    private List<LinearLayout> listLayout;
    private TextView tvCreen;
    private String tag = "";
    private View currentView;
    private View view;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_community_layout, null);
        setParentView(view);
        listLayout = new ArrayList<>();
        initView(view);
        initListener();
        initPtr();
        setSubContentView(lvCommunity);
        showLoadView();
        adapter = new CommunityAdapter(CommunityFragment.this, listQuestion);
        lvCommunity.setAdapter(adapter);
        lvCommunity.setOnItemClickListener(this);
        return view;
    }

    private void initView(View view) {
        TopView topView = (TopView) view.findViewById(R.id.topview);
        topView.setTitle("社区");
        topView.setRightImage();
        lvCommunity = (ListView) view.findViewById(R.id.lv_community);
        mPtrFrame = (PtrClassicFrameLayout) view.findViewById(R.id.rotate_header_list_view_frame);
        llHot = (LinearLayout) view.findViewById(R.id.ll_tab_hot);
        listLayout.add(llHot);
        llHot.setSelected(true);
        llNew = (LinearLayout) view.findViewById(R.id.ll_tab_new);
        llNew.setSelected(false);
        listLayout.add(llNew);
        llCreen = (LinearLayout) view.findViewById(R.id.ll_tab_creen);
        llCreen.setSelected(false);
        listLayout.add(llCreen);
        tvCreen = (TextView) view.findViewById(R.id.tv_tab_creen);

        topView.getLeftView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getActivity().finish();
            }
        });
        this.view = llHot;
        this.currentView = llHot;
    }

    private void initListener() {
        llHot.setOnClickListener(this);
        llNew.setOnClickListener(this);
        llCreen.setOnClickListener(this);
    }

    private void initData() {
        Call<BaseApiResponse<List<QuestionEntity>>> repos = service.listQuestion(type, tag);
        repos.enqueue(new MyCallBack<List<QuestionEntity>>() {

            @Override
            public void onSuccess(BaseApiResponse<List<QuestionEntity>> response) {
                refushView(response.getDataSource());
            }

            @Override
            public void onFailure(int code, String msg) {
                mPtrFrame.refreshComplete();
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                showErrorView(String.format(sInfoFormat, msg, String.valueOf(code)));
            }

            @Override
            public void onFailure(Call<BaseApiResponse<List<QuestionEntity>>> call, Throwable t) {
                super.onFailure(call, t);
                mPtrFrame.refreshComplete();
                String msg = "请检查当前网络状态\n 点击跳转设置界面";
                showErrorView(msg).findViewById(R.id.error_message).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent intent = new Intent(android.provider.Settings.ACTION_SETTINGS);
                        startActivity(intent);
                    }
                });
            }
        });

    }

    @Override
    public void onResume() {
        super.onResume();
        initData();
    }

    private void refushView(List<QuestionEntity> lists) {
        listQuestion.clear();
        listQuestion.addAll(lists);
        if (listQuestion.size() > 0) {
            lvCommunity.setSelection(0);
            adapter.notifyDataSetChanged();
            showContentView();
        } else {
            showEmptyView("暂时没有相关问题");
        }
        mPtrFrame.refreshComplete();
    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(this);
        mPtrFrame.setPtrHandler(new PtrHandler() {
            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, lvCommunity, header);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                initData();
            }

        });
    }

    @Override
    public void onClick(View v) {
        Checked(v.getId());
        switch (v.getId()) {
            case R.id.ll_tab_hot:
                type = "questions/hottest.json";
                currentView = v;
                break;
            case R.id.ll_tab_new:
                type = "questions/latest.json";
                currentView = v;
                break;
            case R.id.ll_tab_creen:
                startActivityForResult(new Intent(getActivity(), CheckTagActivity.class), Activity.RESULT_FIRST_USER);
                break;
            default:
                break;
        }
        if (v.getId() != view.getId()) {
            initData();
        }
        view = v;

    }

    /**
     * 切换Layout选中状态
     *
     * @param id 选中的layout的id
     */
    private void Checked(int id) {

        for (int i = 0; i < listLayout.size(); i++) {
            LinearLayout layout = listLayout.get(i);
            if (layout.isSelected()) {
                layout.setSelected(false);
            }
            if (layout.getId() == id) {
                layout.setSelected(true);
            }
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        switch (resultCode) {
            case Activity.RESULT_FIRST_USER:
                if (data.hasExtra(IntentKeys.KEY_TAG_ID)) {
                    tag = data.getStringExtra(IntentKeys.KEY_TAG_ID);
                    tvCreen.setText(tag);
                }

                break;
            case Activity.RESULT_CANCELED:
                break;
        }
        Checked(currentView.getId());
        initData();
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        QuestionEntity question = listQuestion.get(position);
        Intent intent = new Intent();
        intent.putExtra(IntentKeys.KEY_QUESTION_ID, question.getId());
        intent.setClass(getActivity(), QuestionDetailsActivity.class);
        startActivity(intent);
    }
}
