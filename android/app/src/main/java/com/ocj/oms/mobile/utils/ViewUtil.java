package com.ocj.oms.mobile.utils;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.ocj.oms.mobile.R;

/**
 * Created by yy on 2017/6/21.
 * <p>
 * 空白页 util
 */


public class ViewUtil {
    OnBtnClickListner mListner;
    static Context context;
    static ViewUtil instance;

    ImageView icon;
    TextView titel, subtitle;
    TextView btn;


    private ViewUtil() {
    }

    public void setBtnListner(OnBtnClickListner listner) {
        this.mListner = listner;
    }

    public static ViewUtil getInstance(Context mctx) {
        context = mctx;
        if (instance == null) {
            instance = new ViewUtil();
        }
        return instance;
    }


    public View showEmptyView(int resId, String title, String content, boolean visible, String btnText) {
        RelativeLayout view = (RelativeLayout) LayoutInflater.from(context).inflate(R.layout.empty_layout, null);
        icon = (ImageView) view.findViewById(R.id.iv_icon);
        titel = (TextView) view.findViewById(R.id.tv_title);
        subtitle = (TextView) view.findViewById(R.id.tv_subtitle);
        btn = (TextView) view.findViewById(R.id.btn);
        icon.setBackgroundResource(resId);
        titel.setText(title);
        if (TextUtils.isEmpty(content)) {
            subtitle.setVisibility(View.GONE);
        } else {
            subtitle.setVisibility(View.VISIBLE);
            subtitle.setText(content);
        }
        if (visible) {
            btn.setVisibility(View.VISIBLE);
            btn.setText(btnText);
            btn.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (mListner != null) {
                        mListner.onBtnClick(v);
                    }
                }
            });

        } else {
            btn.setVisibility(View.GONE);
        }

        return view;
    }

    public View showErrorView(int resId, String title, String content, boolean visible, String btnText, View.OnClickListener listener) {
        RelativeLayout view = (RelativeLayout) LayoutInflater.from(context).inflate(R.layout.empty_layout, null);
        icon = (ImageView) view.findViewById(R.id.iv_icon);
        titel = (TextView) view.findViewById(R.id.tv_title);
        subtitle = (TextView) view.findViewById(R.id.tv_subtitle);
        btn = (TextView) view.findViewById(R.id.btn);
        icon.setBackgroundResource(resId);
        titel.setText(title);
        if (TextUtils.isEmpty(content)) {
            subtitle.setVisibility(View.GONE);
        } else {
            subtitle.setVisibility(View.VISIBLE);
            subtitle.setText(content);
        }
        if (visible) {
            btn.setVisibility(View.VISIBLE);
            btn.setText(btnText);
            btn.setOnClickListener(listener);
        } else {
            btn.setVisibility(View.GONE);
        }
        return view;
    }

    public interface OnBtnClickListner {
        void onBtnClick(View view);
    }

}
