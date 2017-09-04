package com.ocj.oms.mobile.ui.video.holder;

import android.graphics.Color;
import android.os.Handler;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.bean.items.PackageListBean;
import com.ocj.oms.mobile.third.Constants;
import com.ocj.oms.mobile.ui.adapter.ItemsAdapter;
import com.ocj.oms.mobile.ui.adapter.SpacesItemDecoration;
import com.ocj.oms.mobile.ui.video.listener.ItemClickListener;
import com.ocj.oms.mobile.view.FixGridLayout;
import com.ocj.oms.mobile.view.LinearLineWrapLayout;
import com.ocj.oms.utils.UIManager;
import com.ocj.oms.utils.convert.NumberUtil;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import butterknife.BindColor;
import butterknife.BindString;
import butterknife.BindView;

/**
 * Created by liu on 2017/5/23.
 */

public class VHolder extends BaseHolder<PackageListBean> {
    private int type;
    private PackageListBean packageBean;
    @BindView(R.id.fix_gridlayout) FixGridLayout label;
    @BindView(R.id.recycle_baking) RecyclerView bakingList;
    @BindView(R.id.ll_video_title) LinearLayout llVideoTitle;
    @BindView(R.id.ll_video_time) LinearLayout llVideoTime;
    @BindView(R.id.tv_video_time) TextView tvVideoTime;
    @BindView(R.id.tv_video_title) TextView tvVideoTitle;
    @BindView(R.id.tv_video_descrip) TextView tvVideoDes;


    private ItemsAdapter adapter;
    private ItemClickListener itemClickListener;

    @BindString(R.string.count_down_time) String countTime;

    public VHolder(View itemView, int mType) {
        super(itemView);
        this.type = mType;
    }

    public VHolder(View itemView, int mType, ItemClickListener itemClickListener) {
        super(itemView);
        this.type = mType;
        this.itemClickListener = itemClickListener;
    }

    @Override
    public void onBind(int position, PackageListBean iItem) {
        this.packageBean = iItem;

        if (packageBean.getPackageId().equals("36")) {
            if (packageBean.getComponentList().size() >= 1) {
                CmsItemsBean itemsBean = packageBean.getComponentList().get(0);

                //视频描述，标签
                tvVideoTitle.setText(itemsBean.getTitle()/* + ":" + itemsBean.getDescription()*/);
                if (!TextUtils.isEmpty(itemsBean.getDescription())) {
                    tvVideoDes.setVisibility(View.VISIBLE);
                    tvVideoDes.setText(itemsBean.getDescription());
                } else {
                    tvVideoDes.setVisibility(View.GONE);
                }

                if (itemsBean.getLabelName() != null && itemsBean.getLabelName().size() > 0) {
                    for (String lable : itemsBean.getLabelName()) {
                        addItemView(label, lable);
                    }
                }
                leftlong = NumberUtil.convertTolong(itemsBean.getPlayDateLong(), -1L);
                if (leftlong == -1L) {
                    tvVideoTime.setText("暂无数据");
                } else {
                    handler.post(timmer);
                }

                //处理游戏
                if (type != Constants.VIDEO_TO_PLAY) {
                    llVideoTime.setVisibility(View.GONE);
                }

                bakingList.setVisibility(View.VISIBLE);
                List<CmsItemsBean> itemsList = itemsBean.getComponentList();
                bakingList.setLayoutManager(new LinearLayoutManager(bakingList.getContext()));
                bakingList.addItemDecoration(new SpacesItemDecoration(itemView.getContext(), LinearLayoutManager.HORIZONTAL));
                adapter = new ItemsAdapter(bakingList.getContext(), type, itemClickListener);
                adapter.setData(itemsList);
                bakingList.setAdapter(adapter);
            } else {
                llVideoTitle.setVisibility(View.GONE);
                llVideoTime.setVisibility(View.GONE);
                tvVideoDes.setVisibility(View.GONE);

            }
        }
    }


    Handler handler = new Handler();
    long leftlong = 0;

    Runnable timmer = new Runnable() {
        @Override
        public void run() {
            if (leftlong - System.currentTimeMillis() <= 0) {
                // ToastUtils.showLongToast("直播已经开始了");
                return;
            }
            String time = longToDate(leftlong - System.currentTimeMillis());
            tvVideoTime.setText(stleDate(time));
            handler.postDelayed(this, 1000);
        }
    };


    @BindColor(R.color.backgrou_vocher_end) int saleColor;
    @BindColor(R.color.text_black_333333) int hintColor;


    /**
     * 把时间格式转换成spannStr
     *
     * @return
     */

    private SpannableStringBuilder stleDate(String dateTx) {

        String[] str1 = dateTx.split(" ");
        String[] str2 = str1[1].split(":");

        SpannableStringBuilder builder = new SpannableStringBuilder(str1[0] + " 天 " + str2[0] + " 时 " + str2[1] + " 分 " + str2[2] + " 秒");
        ForegroundColorSpan startSpan = new ForegroundColorSpan(saleColor);
        ForegroundColorSpan endSpan = new ForegroundColorSpan(hintColor);
        builder.setSpan(startSpan, 0, 2, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        builder.setSpan(endSpan, 2, 4, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

        ForegroundColorSpan startSpan1 = new ForegroundColorSpan(saleColor);
        ForegroundColorSpan endSpan1 = new ForegroundColorSpan(hintColor);
        builder.setSpan(startSpan1, 5, 7, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        builder.setSpan(endSpan1, 7, 9, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);


        ForegroundColorSpan startSpan2 = new ForegroundColorSpan(saleColor);
        ForegroundColorSpan endSpan2 = new ForegroundColorSpan(hintColor);
        builder.setSpan(startSpan2, 10, 12, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        builder.setSpan(endSpan2, 12, 14, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);

        ForegroundColorSpan startSpan3 = new ForegroundColorSpan(saleColor);
        ForegroundColorSpan endSpan3 = new ForegroundColorSpan(hintColor);
        builder.setSpan(startSpan3, 15, 17, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        builder.setSpan(endSpan3, 17, 19, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);


        return builder;
    }

    private void addItemView(LinearLineWrapLayout viewGroup, String text) {
        final View v = LayoutInflater.from(UIManager.getInstance().getBaseContext()).inflate(R.layout.textview_layout, null);
        TextView tvItem = (TextView) v.findViewById(R.id.textview);
        tvItem.setTextColor(Color.parseColor("#40000000"));
        tvItem.setText(text);
        viewGroup.addView(v);
    }

    public static String longToDate(long lo) {
        Date date = new Date(lo);
        SimpleDateFormat sd = new SimpleDateFormat("dd HH:mm:ss");
        return sd.format(date);
    }

}