package com.choudao.equity.view;

import android.content.Context;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ProgressBar;

import com.choudao.equity.R;

import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

/**
 * Created by liuzhao on 16/10/21.
 */

public class CommonPtrHeader extends FrameLayout implements PtrHandler {
    private View headerView;
    private ProgressBar mProgressBar;

    public CommonPtrHeader(Context context) {
        super(context);
    }

    public CommonPtrHeader(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public CommonPtrHeader(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public CommonPtrHeader(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init();
    }

    private void init() {
        headerView = LayoutInflater.from(getContext()).inflate(R.layout.frame_ptr_header, this);
        mProgressBar = (ProgressBar) headerView.findViewById(R.id.pull_to_refresh_progress);

    }

    /**
     * Check can do refresh or not. For example the content is empty or the first child is in view.
     * <p>
     * {@link PtrDefaultHandler#checkContentCanBePulledDown}
     *
     * @param frame
     * @param content
     * @param header
     */
    @Override
    public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
        return false;
    }

    /**
     * When refresh begin
     *
     * @param frame
     */
    @Override
    public void onRefreshBegin(PtrFrameLayout frame) {

    }
}
