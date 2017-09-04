package com.ocj.oms.mobile.ui.fragment.globalbuy;

import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.StyleSpan;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by yy on 2017/6/8.
 * <p>
 * 超值推荐
 */

public class VipItemFragment extends BaseFragment {

    int mTag = -1;

    @BindView(R.id.iv_icon) ImageView icon;
    @BindView(R.id.tv_type) TextView typeTitle;

    @BindView(R.id.tv_title1) TextView title1;
    @BindView(R.id.tv_title2) TextView title2;

    @BindView(R.id.tv_botton1) TextView botton1;
    @BindView(R.id.tv_botton2) TextView botton2;

    @BindView(R.id.ll_botton) LinearLayout llbotton;

    @BindView(R.id.empty) View empty;


    public void setTag(int tag) {
        this.mTag = tag;
    }


    public static VipItemFragment newInstance() {
        return new VipItemFragment();
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_vip_item;
    }

    @Override
    protected void initEventAndData() {
        initView();

    }

    private void initView() {
        switch (mTag) {
            case 1:
                icon.setBackgroundResource(R.drawable.icon_package);
                typeTitle.setText("VIP 礼包");
                title1.setText("有效期内每月奖励");

                SpannableString ss1 = new SpannableString("200 鸥点");
//                ss3.setSpan(new ForegroundColorSpan(Color.parseColor("#F0AAD0")), 0,
//                        3, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                ss1.setSpan(new AbsoluteSizeSpan(18, true), 0, 3, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                ss1.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), 0, 3, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                title2.setText(ss1);
                break;
            case 2:
                icon.setBackgroundResource(R.drawable.icon_score);
                typeTitle.setText("双倍积分");
                title1.setText("订购商品活动双倍积分");

                SpannableString ss2 = new SpannableString("最高可以获得商品售价的" + "\n" + "7%");
                ss2.setSpan(new AbsoluteSizeSpan(18, true), ss2.length() - 2, ss2.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                ss2.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), ss2.length() - 2, ss2.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                title2.setText(ss2);
                botton1.setText("网站订购 + 1% 积分");
                botton2.setText("网站支付 + 2% 积分");
                break;

            case 3:
                icon.setBackgroundResource(R.drawable.icon_gift);
                llbotton.setVisibility(View.GONE);
                typeTitle.setText("生日礼物");
                String title = "制定商品寿星家兑换" + "\n" + "寿星家商品多选四";
                title1.setText(title);

                SpannableString ss3 = new SpannableString("生日当月1日,赠送" + "\n" + " 50元 积分");
                ss3.setSpan(new AbsoluteSizeSpan(18, true), ss3.length() - 6, ss3.length() - 2, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                ss3.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), ss3.length() - 6, ss3.length() - 2, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                title2.setText(ss3);

                break;
            case 4:
                icon.setBackgroundResource(R.drawable.icon_vip_price);
                typeTitle.setText("VIP 特价");
                title1.setText("低至");
                SpannableString ss4 = new SpannableString("8 折");
                ss4.setSpan(new AbsoluteSizeSpan(18, true), 0, 1, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                ss4.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), 0, 1, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                title2.setText(ss4);
                empty.setVisibility(View.VISIBLE);
                llbotton.setVisibility(View.GONE);
                break;
            case 5:
                icon.setBackgroundResource(R.drawable.icon_hotline);
                typeTitle.setText("专线服务");
                title1.setText("VIP 专人专线服务");
                SpannableString ss5 = new SpannableString("主动 送检 送修 服务");
                ss5.setSpan(new AbsoluteSizeSpan(18, true), 2, ss5.length() - 2, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                ss5.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), 2, ss5.length() - 2, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
                title2.setText(ss5);
                empty.setVisibility(View.VISIBLE);
                llbotton.setVisibility(View.GONE);
                break;

        }


    }

    @Override
    protected void lazyLoadData() {

    }


    @OnClick(R.id.ll_parent_item)
    public void onItemClick(View view) {
        switch (mTag) {

        }

    }


}
