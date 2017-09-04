package com.ocj.oms.mobile.ui.personal.order.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.EventResultsItem;
import com.ocj.oms.mobile.ui.adapter.CutEventAdapter;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by xiao on 2017/6/12.
 * 支付成功页面弹出活动窗口
 */

public class CutEventDialog extends Dialog {

    @BindView(R.id.rv) RecyclerView rv;
    private Activity context;
    private CutEventAdapter mAdapter;
    private List<EventResultsItem> list;
    private OnEventClickListener listener;

    public CutEventDialog(@NonNull Context context, List<EventResultsItem> list, OnEventClickListener listener) {
        super(context, R.style.MyDialog);
        this.context = (Activity) context;
        this.list = list;
        this.listener = listener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        init();
    }


    private void init() {
        final View view = LayoutInflater.from(context).inflate(R.layout.dialog_cut_event_layout, null, false);
        setContentView(view);
        ButterKnife.bind(this);

        mAdapter = new CutEventAdapter(context, list);
        mAdapter.setListener(new CutEventAdapter.OnItemClickListener() {
            @Override
            public void click(int position, String url) {
                listener.itemClick(position, url);
            }
        });
        rv.setLayoutManager(new LinearLayoutManager(context));
        rv.setAdapter(mAdapter);

        Window dialogWindow = getWindow();
        WindowManager m = context.getWindowManager();
        Display d = m.getDefaultDisplay(); // 获取屏幕宽、高用
        WindowManager.LayoutParams p = dialogWindow.getAttributes(); // 获取对话框当前的参数值
        if (list.size() > 1) {
            p.height = (int) (d.getHeight() * 0.6); // 高度设置为屏幕的0.6
        } else {
            p.height = (int) (d.getHeight() * 0.4);
        }
        this.setCancelable(true);
        this.setCanceledOnTouchOutside(true);
    }

    public interface OnEventClickListener {
        void itemClick(int position, String url);
    }

}
