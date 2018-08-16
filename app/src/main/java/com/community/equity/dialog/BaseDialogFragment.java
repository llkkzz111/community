package com.community.equity.dialog;

import android.content.res.ColorStateList;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.community.equity.R;
import com.community.equity.utils.UIManager;


public class BaseDialogFragment extends DialogFragment {
    /**
     * 点击外围消失,按返回按钮消失
     */
    public static final int DIALOG_CANCLE_ABLE = 1;
    /**
     * 点击外围不消失，按返回按钮消失
     */
    public static final int DIALOG_BACK_DISMISS = 2;
    /**
     * 点击外围不消失，按返回按钮不消失
     */
    public static final int DIALOG_UNDISMISS = 3;
    private View mContextView;     //对话框内容的布局
    private View mFristButton;     //第一个按钮对应的View
    private View mSecondButton;    //第二个按钮对用的View
    private TextView mTextview_content; //显示对话框内容的TextView
    private int dialogStyle = DIALOG_BACK_DISMISS;

    public BaseDialogFragment() {
    }

    public static BaseDialogFragment newInstance() {
        BaseDialogFragment dialogFragment = newInstance(DIALOG_UNDISMISS);
        return dialogFragment;
    }

    public static BaseDialogFragment newInstance(int dialogStyle) {
        BaseDialogFragment dialogFragment = new BaseDialogFragment();
        Bundle bundle = new Bundle();
        bundle.putInt("dialog_style", dialogStyle);
        dialogFragment.setArguments(bundle);
        return dialogFragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle bundle = getArguments();
        if (bundle != null) {
            dialogStyle = bundle.getInt("dialog_style");
        }
        switch (dialogStyle) {
            case DIALOG_CANCLE_ABLE:
                setStyle(STYLE_NO_TITLE, R.style.dialog);
                setCancelable(true);
                break;
            case DIALOG_BACK_DISMISS:
                setStyle(STYLE_NO_TITLE, R.style.MyDialogStyle);
                setCancelable(true);
                break;
            case DIALOG_UNDISMISS:
                setStyle(STYLE_NO_TITLE, R.style.MyDialogStyle);
                setCancelable(false);
                break;
        }
    }

    /**
     * 将对应的“内容”，“底部Button”放到Dialog默认布局里
     */
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_common_dialog_layout, container);
        if (null != mContextView) {
            LinearLayout contentView = (LinearLayout) view.findViewById(R.id.layout_content);
            contentView.addView(mContextView);
        }
        LinearLayout mButtonView = (LinearLayout) view.findViewById(R.id.layout_button);
        View vLine = view.findViewById(R.id.view_line);
        LinearLayout mButtonViewFrist = (LinearLayout) view.findViewById(R.id.layout_button_frist);
        if (null != mFristButton) {
            mButtonView.setVisibility(View.VISIBLE);
            mButtonViewFrist.addView(mFristButton);
            mButtonViewFrist.setVisibility(View.VISIBLE);
        }
        LinearLayout buttonViewSecond = (LinearLayout) view.findViewById(R.id.layout_button_second);
        if (null != mSecondButton) {
            mButtonView.setVisibility(View.VISIBLE);
            buttonViewSecond.addView(mSecondButton);
            buttonViewSecond.setVisibility(View.VISIBLE);
        }

        if (mFristButton != null & mSecondButton != null) {
            vLine.setVisibility(View.VISIBLE);
        } else {
            vLine.setVisibility(View.GONE);
        }

        return view;
    }

    public BaseDialogFragment addProgress(String text) {
        mContextView = LayoutInflater.from(UIManager.getInstance().getBaseContext()).inflate(R.layout.loading_layout, null);
        ((TextView) mContextView.findViewById(R.id.tv_loading)).setText(text);
        if (TextUtils.isEmpty(text)) {
            mContextView.findViewById(R.id.tv_loading).setVisibility(View.GONE);
        }
        return this;
    }

    public BaseDialogFragment addProgress() {
        return addProgress("");
    }

    /**
     * 添加对话框的内容,保存之后返回当前BaseDialogFragment
     *
     * @param content 内容
     * @return BaseDialogFragment
     */
    public BaseDialogFragment addContent(String content) {
        mContextView = LayoutInflater.from(UIManager.getInstance().getBaseContext()).inflate(R.layout.dialog_content, null);
        mTextview_content = (TextView) mContextView.findViewById(R.id.dialog_common_tv_content);
        mTextview_content.setText(content);
        return this;
    }

    /**
     * 添加对话框ContentView，限制条件如下：
     * 1.仅允许传用于显示的、无点击事件的、无业务逻辑处理的View
     * 2.view的格式与R.layout.dialog_content一致
     * 3.使用该方法的Dialog必须有Title
     * 4.禁止同时调用addContent(String content)
     *
     * @param view
     * @return
     */
    public BaseDialogFragment addView(View view) {
        if (view != null) {
            mContextView = view;
        }
        return this;
    }

    /**
     * 添加对话框的内容,保存之后返回当前BaseDialogFragment
     *
     * @return BaseDialogFragment
     */
    public BaseDialogFragment addContent(int stringId) {
        mContextView = LayoutInflater.from(UIManager.getInstance().getBaseContext()).inflate(R.layout.dialog_content, null);
        mTextview_content = (TextView) mContextView.findViewById(R.id.dialog_common_tv_content);
        mTextview_content.setText(stringId);
        return this;
    }

    /**
     * 一个一个的添加Button
     *
     * @param whichButton     添加的具体是哪个Button
     * @param buttonName      Button要显示的内容
     * @param onClickListener
     * @return BaseDialogFragment
     */
    public BaseDialogFragment addButton(int whichButton, String buttonName, final OnClickListener onClickListener) {
        return addButton(whichButton, buttonName, null, onClickListener);
    }

    /**
     * 一个一个的添加Button
     *
     * @param whichButton     添加的具体是哪个Button
     * @param buttonName      Button要显示的内容
     * @param onClickListener
     * @return BaseDialogFragment
     */
    public BaseDialogFragment addButton(int whichButton, String buttonName, ColorStateList colorRes, final OnClickListener onClickListener) {
        switch (whichButton) {
            case 1:
                mFristButton = LayoutInflater.from(UIManager.getInstance().getBaseContext()).inflate(R.layout.dialog_frist_button, null);
                TextView frist_button = (TextView) mFristButton.findViewById(R.id.dialog_common_bt_frist);
                frist_button.setText(buttonName);
                if (colorRes != null) {
                    frist_button.setTextColor(colorRes);
                }
                frist_button.setOnClickListener(new OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dismissAllowingStateLoss();
                        if (onClickListener != null) {
                            onClickListener.onClick(v);
                        }
                    }
                });

                break;
            case 2:
                mSecondButton = LayoutInflater.from(UIManager.getInstance().getBaseContext()).inflate(R.layout.dialog_second_button, null);
                TextView second_button = (TextView) mSecondButton.findViewById(R.id.dialog_common_bt_second);
                second_button.setText(buttonName);
                if (colorRes != null) {
                    second_button.setTextColor(colorRes);
                }
                second_button.setOnClickListener(new OnClickListener() {

                    @Override
                    public void onClick(View v) {
                        dismissAllowingStateLoss();
                        if (onClickListener != null) {
                            onClickListener.onClick(v);
                        }
                    }
                });
                break;
        }
        return this;
    }

    public boolean isShow() {
        return getDialog() != null && getDialog().isShowing();
    }

}