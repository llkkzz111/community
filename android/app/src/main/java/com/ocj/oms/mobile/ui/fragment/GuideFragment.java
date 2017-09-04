package com.ocj.oms.mobile.ui.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.ui.rn.RNActivity;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/7/13.
 */

public class GuideFragment extends BaseFragment {
    @BindView(R.id.iv_guide) ImageView ivGuide;
    @BindView(R.id.tv_enter) TextView tvEnter;
    private boolean isFirstShow;

    public static GuideFragment newInstance(int imageId, boolean isLast) {
        GuideFragment fragment = new GuideFragment();
        Bundle bundle = new Bundle();
        bundle.putInt("image_id", imageId);
        bundle.putBoolean("is_last", isLast);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_guide_layout;
    }

    @Override
    protected void initEventAndData() {
        Glide.with(mActivity).load(getArguments().getInt("image_id")).into(ivGuide);
        if (getArguments().getBoolean("is_last", false)) {
            ivGuide.setEnabled(true);
            tvEnter.setVisibility(View.VISIBLE);
        } else {
            ivGuide.setEnabled(false);
        }
    }

    @Override
    protected void lazyLoadData() {

    }


    @OnClick(R.id.iv_guide)
    public void onClick() {
        startActivity(new Intent(mActivity, RNActivity.class));
        getActivity().finish();
    }


}
