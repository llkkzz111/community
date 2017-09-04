package com.ocj.oms.mobile.dialog;

import android.app.DialogFragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.ocj.oms.mobile.R;

/**
 * Created by liutao on 2017/6/28.
 */

public class CommonDialogFragment extends DialogFragment {

    private TextView mPositive;
    private TextView mNegative;
    private TextView mTitle;
    private TextView mContent;
    private LinearLayout mTitleLayout;
    private LinearLayout mContentLayout;
    private LinearLayout mButtonLayout;
    private ImageView mTopImage;
    private View mTitleLine;
    private View mContentLine;
    private View mButtonLine;
    private View mContentView;
    private View mRootView;
    private InitDataListener initDataListener;
    private boolean isCreate = false;

    public void setInitDataListener(InitDataListener initDataListener) {
        this.initDataListener = initDataListener;
        if (isCreate) {
            initDataListener.initData();
        }
    }

    public static CommonDialogFragment newInstance() {
        return new CommonDialogFragment();
    }

    public static CommonDialogFragment newInstance(int layoutId) {
        CommonDialogFragment fragment = new CommonDialogFragment();
        Bundle bundle = new Bundle();
        bundle.putInt("layout_id", layoutId);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_TITLE, R.style.MyDialog);
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        if (getArguments() != null && getArguments().getInt("layout_id", 0) != 0) {
            mRootView = inflater.inflate(getArguments().getInt("layout_id", 0), container, false);
        } else {
            mRootView = inflater.inflate(R.layout.dialog_common_layout, container, false);
            mPositive = (TextView) mRootView.findViewById(R.id.tv_positive);
            mNegative = (TextView) mRootView.findViewById(R.id.tv_negative);
            mTitle = (TextView) mRootView.findViewById(R.id.tv_title);
            mContent = (TextView) mRootView.findViewById(R.id.tv_content);
            mTitleLayout = (LinearLayout) mRootView.findViewById(R.id.ll_title);
            mContentLayout = (LinearLayout) mRootView.findViewById(R.id.ll_content);
            mButtonLayout = (LinearLayout) mRootView.findViewById(R.id.ll_bottom);
            mTopImage = (ImageView) mRootView.findViewById(R.id.iv_top);
            mTitleLine = mRootView.findViewById(R.id.line_top);
            mContentLine = mRootView.findViewById(R.id.line_middle);
            mButtonLine = mRootView.findViewById(R.id.line_bottom);
        }
        if (initDataListener != null) {
            initDataListener.initData();
        }
        isCreate = true;

        return mRootView;
    }

    public CommonDialogFragment setPositive(String text) {
        if (!TextUtils.isEmpty(text)) {
            mPositive.setText(text);
            mButtonLayout.setVisibility(View.VISIBLE);
            mPositive.setVisibility(View.VISIBLE);
            if (mNegative.getVisibility() == View.VISIBLE) {
                mButtonLine.setVisibility(View.VISIBLE);
            }
        }
        return this;
    }

    public CommonDialogFragment setPositiveSize(float size) {
        mPositive.setTextSize(size);
        return this;
    }

    public CommonDialogFragment setPositiveClolor(int color) {
        mPositive.setTextColor(getResources().getColor(color));
        return this;
    }

    public CommonDialogFragment setNegative(String text) {
        if (!TextUtils.isEmpty(text)) {
            mNegative.setText(text);
            mNegative.setVisibility(View.VISIBLE);
            mButtonLayout.setVisibility(View.VISIBLE);
            if (mPositive.getVisibility() == View.VISIBLE) {
                mButtonLine.setVisibility(View.VISIBLE);
            }
        }
        return this;
    }

    public CommonDialogFragment setNegativeSize(float size) {
        mNegative.setTextSize(size);
        return this;
    }

    public CommonDialogFragment setNegativeClolor(int color) {
        mNegative.setTextColor(getResources().getColor(color));
        return this;
    }

    public CommonDialogFragment setTitle(String text) {
        mTitle.setText(text);
        mTitleLayout.setVisibility(View.VISIBLE);
        mTitle.setVisibility(View.VISIBLE);
        return this;
    }

    public CommonDialogFragment setTitleSize(float size) {
        mTitle.setTextSize(size);
        return this;
    }

    public CommonDialogFragment setTitleClolor(int color) {
        mTitle.setTextColor(getResources().getColor(color));
        return this;
    }

    public CommonDialogFragment setContent(String text) {
        mContent.setText(text);
        mContentLayout.setVisibility(View.VISIBLE);
        mContent.setVisibility(View.VISIBLE);
        mContentLine.setVisibility(View.VISIBLE);
        return this;
    }

    public CommonDialogFragment setContentSize(float size) {
        mContent.setTextSize(size);
        return this;
    }

    public CommonDialogFragment setContentClolor(int color) {
        mContent.setTextColor(getResources().getColor(color));
        return this;
    }

    public CommonDialogFragment setPositiveListener(final View.OnClickListener listener) {
        mPositive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismissAllowingStateLoss();
                if (listener != null) {
                    listener.onClick(view);
                }
            }
        });
        return this;
    }

    public CommonDialogFragment setNegativeListener(final View.OnClickListener listener) {
        mNegative.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dismissAllowingStateLoss();
                if (listener != null) {
                    listener.onClick(view);
                }
            }
        });
        return this;
    }

    public CommonDialogFragment setContentView(View view) {
        mContentView = view;
        mContentLayout.setVisibility(View.VISIBLE);
        mContentLayout.removeAllViews();
        mContentLayout.addView(mContentView, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT));
        return this;
    }

    public View getViewByContentViewId(int id) {
        if (mContentView != null) {
            return mContentView.findViewById(id);
        }
        return null;
    }

    public View getViewByRootViewId(int id) {
        if (mRootView != null) {
            return mRootView.findViewById(id);
        }
        return null;
    }

    public CommonDialogFragment setTopImage(int id) {
        mTopImage.setImageResource(id);
        mTitleLayout.setVisibility(View.VISIBLE);
        mTopImage.setVisibility(View.VISIBLE);
        return this;
    }

    public CommonDialogFragment setLineColor(int color) {
        mTitleLine.setBackgroundColor(getResources().getColor(color));
        mContentLine.setBackgroundColor(getResources().getColor(color));
        mButtonLine.setBackgroundColor(getResources().getColor(color));
        return this;
    }

    public CommonDialogFragment setContentLineVisible(int visible) {
        mContentLine.setVisibility(visible);
        return this;
    }

    public void dimissDialog(){
        dismiss();
    }

    public interface InitDataListener {
        void initData();
    }

    @Override
    public void onDestroyView() {
        isCreate = false;
        super.onDestroyView();
    }
}
