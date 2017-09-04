package com.ocj.oms.mobile.ui.video;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.ItemEventBean;

import java.util.ArrayList;


/**
 * 赠品选择弹框
 */

public class GiftSelectSpecDialog extends Dialog {

    private Activity mActivity;
    private ArrayList<ItemEventBean.EventMapItem> mLists;
    private ItemEventBean.EventMapItem select;

    private ImageView iv_close;
    private TextView tv_select;
    private RecyclerView recyclerview;
    private Button btn_enter;

    private GiftAdapter mAdapter;
    private OnEnterClickListener onEnterClickListener;

    public GiftSelectSpecDialog(@NonNull Context context) {
        super(context);
    }

    public GiftSelectSpecDialog(Activity mActivity, ArrayList<ItemEventBean.EventMapItem> mLists, ItemEventBean.EventMapItem select) {
        //设置全屏样式
        super(mActivity, R.style.Dialog_Fullscreen);
        this.mLists = mLists;
        this.select = select;
        this.mActivity = mActivity;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        View view = getLayoutInflater().inflate(R.layout.dialog_video_deatil_gift_select, null);
        setContentView(view);

        iv_close = (ImageView) view.findViewById(R.id.iv_close);
        tv_select = (TextView) view.findViewById(R.id.tv_select);
        recyclerview = (RecyclerView) view.findViewById(R.id.recyclerview);
        btn_enter = (Button) view.findViewById(R.id.btn_enter);

        iv_close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });

        btn_enter.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (select == null) {
                    ToastUtils.showShortToast("请选择赠品");
                    return;
                }
                onEnterClickListener.onEnterClick(mLists, select);
            }
        });
        if (select != null) {

        }
        recyclerview.setLayoutManager(new LinearLayoutManager(mActivity));
        mAdapter = new GiftAdapter();
        mAdapter.setData(mLists);
        mAdapter.setOnItemClickListener(new GiftAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(int position) {
                for (int i = 0; i < mLists.size(); i++) {
                    if (position == i) {
                        mLists.get(i).checked = true;
                        select = mLists.get(i);
                        tv_select.setText("已选赠品：" + select.gift_item_name);
                    } else {
                        mLists.get(i).checked = false;
                    }
                }
                mAdapter.notifyDataSetChanged();
            }
        });
        recyclerview.setAdapter(mAdapter);

        Window window = getWindow();
        window.getDecorView().setPadding(0, 0, 0, 0);
        window.setWindowAnimations(R.style.main_menu_animstyle);
        WindowManager.LayoutParams wl = window.getAttributes();
        wl.x = 0;
        wl.y = mActivity.getWindowManager().getDefaultDisplay().getHeight();

        wl.width = ViewGroup.LayoutParams.MATCH_PARENT;
        wl.height = ViewGroup.LayoutParams.WRAP_CONTENT;

        onWindowAttributesChanged(wl);
        setCanceledOnTouchOutside(true);
    }

    public ItemEventBean.EventMapItem getSelect() {
        return select;
    }

    public void setOnEnterClickListener(OnEnterClickListener onEnterClickListener) {
        this.onEnterClickListener = onEnterClickListener;
    }

    public interface OnEnterClickListener {
        void onEnterClick(ArrayList<ItemEventBean.EventMapItem> list, ItemEventBean.EventMapItem select);
    }

}
