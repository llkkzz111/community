/*
 * Copyright (C) 2015 Bilibili <jungly.ik@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.bilibili.socialize.share.selector;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.support.v4.app.FragmentActivity;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;

import com.bilibili.socialize.share.R;


/**
 * @author Jungly
 * @email jungly.ik@gmail.com
 * @since 2016/1/4.
 */
public class PopFullScreenSharePlatformSelector extends BaseSharePlatformSelector implements View.OnClickListener {

    protected PopupWindow mShareWindow;
    protected View mAnchorView;
    protected RelativeLayout mContainerView;

    private GridView grid;
    private View viewTitle;
    private LinearLayout mShareView;
    private Animation enterAnimation;

    public PopFullScreenSharePlatformSelector(FragmentActivity context, View anchorView, OnShareSelectorDismissListener dismissListener, AdapterView.OnItemClickListener itemClickListener) {
        super(context, dismissListener, itemClickListener);
        mAnchorView = anchorView;
    }

    @Override
    public void show() {
        createShareWindowIfNeed();
        if (!mShareWindow.isShowing()) {
            mShareWindow.showAtLocation(mAnchorView, Gravity.BOTTOM, 0, 0);
        }
        showEnterAnimation();
    }

    private void showEnterAnimation() {
        if (enterAnimation == null)
            enterAnimation = AnimationUtils.loadAnimation(getContext(), R.anim.socialize_shareboard_animation_in);
        mShareView.setAnimation(enterAnimation);

        enterAnimation.start();
    }

    @Override
    public void dismiss() {
        if (mShareWindow != null) {
            mShareWindow.dismiss();
        }
    }

    @Override
    public void release() {
        dismiss();
        super.release();
        mAnchorView = null;
        mShareWindow = null;
        grid = null;
        enterAnimation = null;
    }

    private int dridId = 1123;

    private void createShareWindowIfNeed() {
        if (mShareWindow != null)
            return;

        Context context = getContext();

        mShareView = new LinearLayout(getContext());
        RelativeLayout.LayoutParams shareParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT);
        shareParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
        mShareView.setOrientation(LinearLayout.VERTICAL);
        mShareView.setLayoutParams(shareParams);

        viewTitle = LayoutInflater.from(getContext()).inflate(R.layout.layout_share_content_title, null);
        LinearLayout.LayoutParams viewParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        viewTitle.setLayoutParams(viewParams);
        viewTitle.findViewById(R.id.iv_share_close).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
                if (outSideClickListener != null) {
                    outSideClickListener.outSideClick();
                }
            }
        });
        mShareView.addView(viewTitle);

        grid = createShareGridView(context, getItemClickListener());
        LinearLayout.LayoutParams gridParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        grid.setPadding(50, 40, 50, 70);
        grid.setLayoutParams(gridParams);
        mShareView.addView(grid);

        mContainerView = new RelativeLayout(getContext());
        mContainerView.setBackgroundColor(getContext().getResources().getColor(R.color.bili_socialize_black_trans));
        RelativeLayout.LayoutParams containerParams = new RelativeLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);
        mContainerView.setLayoutParams(containerParams);
        mContainerView.addView(mShareView);

        mContainerView.setOnClickListener(this);

        mShareWindow = new PopupWindow(mContainerView, WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT, false);
        grid.setBackgroundDrawable(new ColorDrawable(Color.WHITE));
        mShareWindow.setOutsideTouchable(true);
        mShareWindow.setAnimationStyle(-1);
        mShareWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                if (getDismissListener() != null)
                    getDismissListener().onDismiss();
            }
        });

    }

    @Override
    public void onClick(View v) {
        if (v == mContainerView) {
            dismiss();
            if (outSideClickListener != null) {
                outSideClickListener.outSideClick();
            }
        }
    }
}
