package com.ocj.oms.mobile.ui.video;

import android.content.res.Configuration;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.VideoDetailBean;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.mobile.ui.video.adapter.VideoPictureAdapter;
import com.ocj.oms.utils.DensityUtil;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/7/11.
 */
@Route(path = RouterModule.AROUTER_PATH_VIDEO_DETAIL)
public class VideoDetailActivity extends BaseActivity {

    @BindView(R.id.rl_title) RelativeLayout rlTitle;
    @BindView(R.id.fl_content) FrameLayout flContent;
    @BindView(R.id.rv_video) RecyclerView rvVideo;
    @BindView(R.id.ll_no_video_path) LinearLayout llNoVideoPath;

    private VideoPlayFragment videoFragment;
    private VideoPictureAdapter adapter;
    private List<VideoDetailBean> data;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_video_detail_layout;
    }

    @Override
    protected void initEventAndData() {
        Type type = new TypeToken<ArrayList<VideoDetailBean>>() {
        }.getType();
        data = new Gson().fromJson(getIntent().getStringExtra("item_video_url"), type);
        if (data != null && data.size() > 0 && !TextUtils.isEmpty(data.get(0).getVideo_url())) {
            data.get(0).setSelect(true);
            adapter = new VideoPictureAdapter(mContext, data);
            adapter.setOnItemClickListener(new VideoPictureAdapter.onItemClickListener() {
                @Override
                public void onItemClick(int position) {
                    if (data.get(position).isSelect()) {
                        return;
                    }
                    for (VideoDetailBean bean : data) {
                        bean.setSelect(false);
                    }
                    data.get(position).setSelect(true);
                    videoFragment.resetVideo(data.get(position).getVideo_url(), data.get(position).getVideo_picpath());
                    adapter.notifyDataSetChanged();
                }
            });
            GridLayoutManager layoutManager = new GridLayoutManager(mContext, 3);
            rvVideo.setLayoutManager(layoutManager);
            rvVideo.setAdapter(adapter);
            videoFragment = VideoPlayFragment.newInstance(data.get(0).getVideo_url(), true, data.get(0).getVideo_picpath(), true);
            getSupportFragmentManager().beginTransaction().add(R.id.fl_content, videoFragment, "video").commit();
        } else {
            llNoVideoPath.setVisibility(View.VISIBLE);
        }
    }

    @OnClick({R.id.iv_back, R.id.iv_share})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_back:
                finish();
                break;
            case R.id.iv_share:
                break;
        }
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        if (newConfig.orientation == Configuration.ORIENTATION_PORTRAIT) {
            rlTitle.setVisibility(View.VISIBLE);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DensityUtil.dip2px(mContext, 211));
            flContent.setLayoutParams(layoutParams);
        }
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            rlTitle.setVisibility(View.GONE);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            flContent.setLayoutParams(layoutParams);
        }
    }

    @Override
    public void onBackPressed() {
        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            if (videoFragment != null) {
                videoFragment.zoomVideo();
            }
            return;
        }
        super.onBackPressed();
    }
}
