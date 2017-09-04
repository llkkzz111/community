package com.ocj.oms.mobile.dialog;

import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.ocj.oms.mobile.R;
import com.ocj.oms.utils.OCJPreferencesUtils;

/**
 * Created by liu on 2017/4/27.
 */

public class DialogFactory {


    public static CommonDialogFragment showLeftDialog(final Context context, final String title, final String leftText, final View.OnClickListener listener) {
        final CommonDialogFragment dialogFragment = CommonDialogFragment.newInstance();
        dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
            @Override
            public void initData() {
                View view = LayoutInflater.from(context).inflate(R.layout.dialog_base_content_layout, null);
                TextView tvContent = (TextView) view.findViewById(R.id.tv_dialog_content);
                tvContent.setText(title);
                dialogFragment
                        .setContentView(view)
                        .setLineColor(R.color.text_grey_DDDDDD)
                        .setContentLineVisible(View.VISIBLE)
                        .setNegative(leftText)
                        .setNegativeListener(listener)
                        .setPositive("取消")
                        .setPositiveListener(null);
            }
        });
        return dialogFragment;
    }


    public static CommonDialogFragment showRightDialog(Context context, String title, final String leftBtnText, final String rightBtnText, final View.OnClickListener listener) {
        final CommonDialogFragment dialogFragment = CommonDialogFragment.newInstance();
        final View view = LayoutInflater.from(context).inflate(R.layout.dialog_base_content_layout, null);
        TextView tvContent = (TextView) view.findViewById(R.id.tv_dialog_content);
        tvContent.setText(title);
        if (!TextUtils.isEmpty(leftBtnText)) {
            dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                @Override
                public void initData() {
                    dialogFragment
                            .setContentView(view)
                            .setLineColor(R.color.text_grey_DDDDDD)
                            .setContentLineVisible(View.VISIBLE)
                            .setNegative(leftBtnText)
                            .setNegativeListener(null)
                            .setPositive(rightBtnText)
                            .setPositiveListener(listener);
                }
            });
        } else {
            dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
                @Override
                public void initData() {
                    dialogFragment
                            .setContentView(view)
                            .setLineColor(R.color.text_grey_DDDDDD)
                            .setContentLineVisible(View.VISIBLE)
                            .setPositive(rightBtnText)
                            .setPositiveListener(listener);
                }
            });
        }
        return dialogFragment;
    }

    /**
     * 无图标的dialog
     */
    public static CommonDialogFragment showNoIconDialog(final String content, final String leftBtnText, final String rightBtnText, final View.OnClickListener listener) {
        final CommonDialogFragment dialogFragment = CommonDialogFragment.newInstance();
        dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
            @Override
            public void initData() {
                dialogFragment
                        .setContent(content)
                        .setLineColor(R.color.text_grey_DDDDDD)
                        .setContentLineVisible(View.VISIBLE)
                        .setNegative(leftBtnText)
                        .setNegativeListener(null)
                        .setPositive(rightBtnText)
                        .setPositiveListener(listener);
            }
        });
        return dialogFragment;
    }

    public static CommonDialogFragment showDialog(Context context, final View.OnClickListener leftListener, final View.OnClickListener rightListener) {
        final CommonDialogFragment dialogFragment = CommonDialogFragment.newInstance();
        final View view = LayoutInflater.from(context).inflate(R.layout.dialog_base_title_content_layout, null);
        dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
            @Override
            public void initData() {
                dialogFragment
                        .setContentView(view)
                        .setLineColor(R.color.text_grey_DDDDDD)
                        .setContentLineVisible(View.VISIBLE)
                        .setNegative("下次再说")
                        .setNegativeListener(leftListener)
                        .setPositive("确定")
                        .setPositiveListener(rightListener);
            }
        });
        return dialogFragment;
    }

    public static CommonDialogFragment showAlertDialog(final String content, final String negativeText, final View.OnClickListener negativeListener, final String positiveText, final View.OnClickListener positiveListener) {
        final CommonDialogFragment alertDialog = CommonDialogFragment.newInstance();
        alertDialog.setInitDataListener(new CommonDialogFragment.InitDataListener() {
            @Override
            public void initData() {
                alertDialog
                        .setContent(content)
                        .setLineColor(R.color.text_grey_DDDDDD)
                        .setContentLineVisible(View.VISIBLE)
                        .setNegative(negativeText)
                        .setNegativeListener(negativeListener)
                        .setPositive(positiveText)
                        .setPositiveListener(positiveListener);
            }
        });
        return alertDialog;
    }

    public static CommonDialogFragment showCommentDialog(Context context, final OnCommentListner rightListener) {
        final CommonDialogFragment dialogFragment = CommonDialogFragment.newInstance();
        final View view = LayoutInflater.from(context).inflate(R.layout.dialog_comment_layout, null);
        TextView good = (TextView) view.findViewById(R.id.tv_feel_good);
        TextView bad = (TextView) view.findViewById(R.id.tv_feel_bad);
        TextView lookAround = (TextView) view.findViewById(R.id.tv_lookaroud);

        good.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialogFragment.dismissAllowingStateLoss();
                rightListener.onFeelGood();
            }
        });

        bad.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialogFragment.dismissAllowingStateLoss();
                rightListener.onFeelBad();
            }
        });

        lookAround.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialogFragment.dismissAllowingStateLoss();
                rightListener.onLookAround();
            }
        });

        dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
            @Override
            public void initData() {
                dialogFragment
                        .setContentView(view);
            }
        });
        return dialogFragment;
    }

    public interface OnCommentListner {

        void onFeelGood();

        void onFeelBad();

        void onLookAround();

    }


    public interface OnAdvertListner {

        void onAdvertClose();
    }


    public static CommonDialogFragment showAdvertDialog(Context context, String url, final OnAdvertListner listner) {
        final CommonDialogFragment dialogFragment = CommonDialogFragment.newInstance();
        final View view = LayoutInflater.from(context).inflate(R.layout.dialog_advert, null);
        ImageView content = (ImageView) view.findViewById(R.id.iv_advert);
        Glide.with(context).load(url).
                skipMemoryCache(true).
                diskCacheStrategy(DiskCacheStrategy.SOURCE).
                error(R.drawable.ic_picture_loadfailed).
                into(content);
        OCJPreferencesUtils.setGuideAdvertImage(url);

        ImageView close = (ImageView) view.findViewById(R.id.iv_close);
        close.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listner != null) {
                    listner.onAdvertClose();
                }
            }
        });

        dialogFragment.setInitDataListener(new CommonDialogFragment.InitDataListener() {
            @Override
            public void initData() {
                dialogFragment
                        .setContentView(view);
            }
        });
        return dialogFragment;
    }

}




