package com.community.equity.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.community.equity.CommunityActivity;
import com.community.equity.R;
import com.community.equity.WebViewActivity;
import com.community.equity.base.BaseFragment;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.CropSquareTransformation;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class FoundFragment extends BaseFragment implements View.OnClickListener {
    @BindView(R.id.topview)
    TopView topView;
    @BindView(R.id.iv_trading_center)
    ImageView ivTradingCenter;
    @BindView(R.id.iv_community)
    ImageView ivCommunity;
    @BindView(R.id.iv_vc_information)
    ImageView ivVCInformation;


    private View view = null;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_found_layout, container, false);
        ButterKnife.bind(this, view);
        initView();
        return view;
    }

    private void initView() {
        topView.setTitle("发现");
        Glide.with(getActivity()).load(R.drawable.img_communitys).centerCrop().dontAnimate().bitmapTransform(new CropSquareTransformation(getActivity())).into(ivCommunity);
        Glide.with(getActivity()).load(R.drawable.img_trading_center).centerCrop().dontAnimate().bitmapTransform(new CropSquareTransformation(getActivity())).into(ivTradingCenter);
        Glide.with(getActivity()).load(R.drawable.img_vc_information).centerCrop().dontAnimate().bitmapTransform(new CropSquareTransformation(getActivity())).into(ivVCInformation);
    }

    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @OnClick({R.id.ll_community, R.id.ll_trading_center, R.id.ll_vc_information})
    public void onClick(View v) {
        Intent intent = new Intent();
        switch (v.getId()) {
            case R.id.ll_community:
                intent.setClass(getActivity(), CommunityActivity.class);
                startActivity(intent);
                break;
            case R.id.ll_trading_center:
                intent.setClass(getActivity(), WebViewActivity.class);
                intent.putExtra(IntentKeys.KEY_URL, ConstantUtils.HTTPS_community_TRADING_CENTER);
                startActivity(intent);
                break;
            case R.id.ll_vc_information:
                intent.setClass(getActivity(), WebViewActivity.class);
                intent.putExtra(IntentKeys.KEY_URL, ConstantUtils.HTTPS_community_VC_INFORMATIONS);
                startActivity(intent);
                break;
        }
    }
}
