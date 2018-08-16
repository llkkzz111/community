package com.community.equity;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.Toast;

import com.community.equity.api.StringCallBack;
import com.community.equity.base.BaseActivity;
import com.community.equity.entity.Locations;
import com.community.equity.utils.ResourceUtils;
import com.community.equity.view.TopView;
import com.google.gson.Gson;

import java.util.IdentityHashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit2.Call;

/**
 * Created by liuzhao on 16/11/8.
 */

public class LocationSelestActivity extends BaseActivity {

    @BindView(R.id.topview)
    TopView topView;
    private String locations = null;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_location_select_layout);
        ButterKnife.bind(this);
        locations = ResourceUtils.geFileFromAssets(mContext, "location.txt");
        Locations loactions = new Gson().fromJson(locations, Locations.class);
        initView();
        initData();
    }


    private void initView() {
        topView.setLeftImage();
        topView.setRightText("----");
        topView.setTitle("选择地址");
    }

    private void initData() {
        Map<String, Object> map = new IdentityHashMap<>();
        Call<String> repos = service.getLocations(map);
        repos.enqueue(new StringCallBack() {

            @Override
            public void onSuccess(String response) {
                if (response == null) {
                    Toast.makeText(mContext, "数据未变更", Toast.LENGTH_SHORT).show();
                } else {

                }
            }

            @Override
            public void onFailure(int code, String response) {
            }
        });
    }

    @OnClick({R.id.iv_right, R.id.iv_left})
    public void OnClick(View v) {
        switch (v.getId()) {
            case R.id.iv_left:
                finish();
                break;
            case R.id.iv_right:
                break;
        }
    }
}
