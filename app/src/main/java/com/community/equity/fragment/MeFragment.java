package com.community.equity.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.community.equity.MainActivity;
import com.community.equity.PersonalProfileActivity;
import com.community.equity.R;
import com.community.equity.SettingActivity;
import com.community.equity.WebViewActivity;
import com.community.equity.api.BaseCallBack;
import com.community.equity.base.BaseFragment;
import com.community.equity.entity.ProfileEntity;
import com.community.equity.entity.UserEntity;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.CropSquareTransformation;
import com.community.equity.utils.DialogFractory;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.UserInfo;

import java.util.IdentityHashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit2.Call;


/**
 * Created by Han on 2016/3/9.
 */
public class MeFragment extends BaseFragment implements View.OnClickListener {
    @BindView(R.id.iv_head)
    ImageView ivHead;
    @BindView(R.id.tv_investment_count)
    TextView tvInvestmentCount;
    @BindView(R.id.tv_pitches_count)
    TextView tvPitchesCount;
    @BindView(R.id.tv_call_sent_count)
    TextView tvCallSentCount;
    @BindView(R.id.tv_lead_investors_count)
    TextView tvLeadinvestorsCount;
    @BindView(R.id.tv_nick_name)
    TextView tvNickName;
    @BindView(R.id.topview)
    TopView topView;
    @BindView(R.id.sv_content)
    ScrollView svContent;

    private UserInfo userInfo;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_me_layout, null);
        setParentView(view);
        unbinder = ButterKnife.bind(this, view);
        topView.setTitle("我的");
        userInfo = DBHelper.getInstance().queryUniqueUserInfo(ConstantUtils.USER_ID);
        if (userInfo != null)
            showNameAndImg(userInfo.getName(), userInfo.getHeadImgUrl());
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        initData();
    }

    private void initData() {
        Map<String, Object> map = new IdentityHashMap<>();
        Call<ProfileEntity> repos = service.getUserProfile(map);
        repos.enqueue(new BaseCallBack<ProfileEntity>() {

            @Override
            public void onSuccess(ProfileEntity response) {
                userInfo = Utils.toUserInfo(response);
                DBHelper.getInstance().saveUserInfo(userInfo);
                showView(response.getUser());
            }

            @Override
            public void onFailure(int code, String response) {
                if (code == 401) {
                    showDialog();
                } else if (userInfo == null) {
                    Toast.makeText(getActivity(), "获取用户信息失败，请稍后重试", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private void showDialog() {
        if (getActivity() instanceof MainActivity)
            ((MainActivity) getActivity()).showKODialog();
        else
            new DialogFractory(this).showKODialog("登录状态已过期，请重新登录");
    }

    private void showView(UserEntity userInfoEntity) {
        if (userInfoEntity.getSent_lead_investors_counter() != 0)
            tvLeadinvestorsCount.setVisibility(View.VISIBLE);
        tvLeadinvestorsCount.setText(userInfoEntity.getSent_lead_investors_counter() + "");
        if (userInfoEntity.getLaunched_pitches_counter() != 0)
            tvPitchesCount.setVisibility(View.VISIBLE);
        tvPitchesCount.setText(userInfoEntity.getLaunched_pitches_counter() + "");
        if (userInfoEntity.getRequest_call_sent_counter() != 0)
            tvCallSentCount.setVisibility(View.VISIBLE);
        tvCallSentCount.setText(userInfoEntity.getRequest_call_sent_counter() + "");
        if (userInfoEntity.getInvestment_counter() != 0)
            tvInvestmentCount.setVisibility(View.VISIBLE);
        tvInvestmentCount.setText(userInfoEntity.getInvestment_counter() + "");

        showNameAndImg(userInfoEntity.getName(), userInfoEntity.getImg());
    }

    private void showNameAndImg(String name, String img) {
        tvNickName.setText(name);
        if (Util.isOnMainThread() && getActivity() != null)
            Glide.with(this).load(img).placeholder(R.drawable.icon_account_no_pic).dontAnimate().diskCacheStrategy(DiskCacheStrategy.ALL).bitmapTransform(new CropSquareTransformation(getActivity())).into(ivHead);
    }


    @OnClick({R.id.ll_user_info, R.id.ll_setting, R.id.ll_investments_pro, R.id.ll_launched_pitches, R.id.ll_lead_investors, R.id.ll_request_calls, R.id.ll_account})
    public void onClick(View v) {
        Intent intent = new Intent();
        switch (v.getId()) {
            case R.id.ll_user_info:
                intent.putExtra(IntentKeys.KEY_USER_ID, ConstantUtils.USER_ID);
                intent.setClass(getActivity(), PersonalProfileActivity.class);
                startActivity(intent);
                break;
            case R.id.ll_setting:
                intent.putExtra(IntentKeys.KEY_USER_INFO, userInfo);
                intent.setClass(getActivity(), SettingActivity.class);
                startActivity(intent);
                break;
            case R.id.ll_investments_pro:
                startNewActivity(ConstantUtils.HTTPS_community_INVESMENTS);
                break;
            case R.id.ll_launched_pitches:
                startNewActivity(ConstantUtils.HTTPS_community_LAUNCHED_PITCHES);
                break;
            case R.id.ll_lead_investors:
                startNewActivity(ConstantUtils.HTTPS_community_LEAD_INVESTORS);
                break;
            case R.id.ll_request_calls:
                startNewActivity(ConstantUtils.HTTPS_community_REQUEST_CALL);
            case R.id.ll_account:
                startNewActivity(ConstantUtils.HTTPS_community_ACCOUNT_PAY);
                break;

        }
    }

    private void startNewActivity(String url) {
        Intent intent = new Intent(getActivity(), WebViewActivity.class);
        intent.putExtra(IntentKeys.KEY_URL, url);
        startActivity(intent);

    }

    @Override
    public void onDestroyView() {
        Glide.clear(ivHead);
        super.onDestroyView();
    }

}
