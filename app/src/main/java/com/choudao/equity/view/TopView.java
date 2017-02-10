package com.choudao.equity.view;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.choudao.equity.LoginActivity;
import com.choudao.equity.R;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.entity.ProfileEntity;
import com.choudao.equity.popup.QuestionPopupWindow;

import java.util.HashMap;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by liuzhao on 16/4/12.
 */
public class TopView extends RelativeLayout implements View.OnClickListener {
    @BindView(R.id.iv_left) TextView ivLeft;
    @BindView(R.id.tv_title) TextView tvTitle;
    @BindView(R.id.iv_right) TextView ivRight;
    private LayoutInflater inflater;
    private Context mContext;
    private View layout;
    private QuestionPopupWindow popupWindow;

    public TopView(Context context) {
        super(context);
        initview(context, null, 0);
    }

    public TopView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initview(context, attrs, 0);
    }

    public TopView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initview(context, attrs, defStyle);
    }

    private void initview(Context context, AttributeSet attrs, int defStyle) {
        mContext = context;
        inflater = LayoutInflater.from(context);
        layout = inflater.inflate(R.layout.top_layout, this, true);
        ButterKnife.bind(layout);
    }

    public TextView getTitleView() {
        return tvTitle;
    }

    public void setTitle(String title) {
        tvTitle.setText(title);
    }

    public void setTitle(int strId) {
        tvTitle.setText(strId);
    }

    public void setRightText(String title) {
        ivRight.setText(title);
        ivRight.setVisibility(View.VISIBLE);
        ivRight.setCompoundDrawablesWithIntrinsicBounds(null, null, null, null);
    }

    public void setRightText(int resId) {
        ivRight.setText(resId);
        ivRight.setVisibility(View.VISIBLE);
        ivRight.setCompoundDrawablesWithIntrinsicBounds(null, null, null, null);
    }

    public void setRightText(String title, int color) {
        ivRight.setText(title);
        ivRight.setVisibility(View.VISIBLE);
        ivRight.setTextColor(color);
        ivRight.setCompoundDrawablesWithIntrinsicBounds(null, null, null, null);
    }

    public void setRightImage() {
        setRightImage(-1);
    }

    public void setRightImage(int resid) {

        ivRight.setVisibility(View.VISIBLE);
        if (resid > 0) {
            Drawable drawable = getResources().getDrawable(resid);
            ivRight.setCompoundDrawablesWithIntrinsicBounds(drawable, null, null, null);
        } else {
            ivRight.setOnClickListener(this);
        }
    }

    public TextView getRightView() {
        ivRight.setVisibility(View.VISIBLE);
        return ivRight;
    }

    public void setLeftText(String title) {
        ivLeft.setText(title);
        ivLeft.setVisibility(View.VISIBLE);
        ivLeft.setCompoundDrawablesWithIntrinsicBounds(null, null, null, null);
    }

    public void setLeftImage() {
        setLeftImage(-1);
    }

    public void setLeftImage(int resid) {
        ivLeft.setVisibility(View.VISIBLE);
        if (resid > 0) {
            Drawable drawable = getResources().getDrawable(resid);
            ivLeft.setCompoundDrawablesWithIntrinsicBounds(drawable, null, null, null);
        }
    }

    public TextView getLeftView() {
        ivLeft.setVisibility(View.VISIBLE);
        return ivLeft;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_right:
                //用来检查网络是否通畅(到服务器)
                ApiService service = ServiceGenerator.createService(ApiService.class);
                service.getUserProfile(new HashMap<String, Object>()).enqueue(new BaseCallBack<ProfileEntity>() {
                    @Override
                    protected void onSuccess(ProfileEntity body) {
                        popupWindow = new QuestionPopupWindow(mContext);
                        popupWindow.popShow(tvTitle);
                    }

                    @Override
                    protected void onFailure(int code, String msg) {
                        if (code == 401) {
                            startNewActivity();
                        } else {
                            Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
                        }
                    }
                });
                break;
            case R.id.iv_left:
                break;
        }
    }

    private void startNewActivity() {
        Intent intent = new Intent(mContext, LoginActivity.class);
        mContext.startActivity(intent);
    }
}
