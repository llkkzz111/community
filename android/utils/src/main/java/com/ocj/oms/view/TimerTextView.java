package com.ocj.oms.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.os.Handler;
import android.util.AttributeSet;

import com.ocj.oms.ui.R;


/**
 * 自定义短信验证码倒计时组件
 */
public class TimerTextView extends android.support.v7.widget.AppCompatTextView implements Runnable {

    private boolean isStart = false;// 是否启动
    private static Handler handler = new Handler();
    private static int TOTAL_SECONDS = 0;
    private int timeTotal = 30;
    private int timeSpace = 1000;


    public TimerTextView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.TextViewTimer);
        if (typedArray != null) {
            timeTotal = typedArray.getInt(R.styleable.TextViewTimer_timer_total, timeTotal);
            timeSpace = typedArray.getInt(R.styleable.TextViewTimer_timer_space, timeSpace);
            TOTAL_SECONDS = timeTotal;
            typedArray.recycle();
        }
        setTextColor(getResources().getColor(R.color.text_red_E5290D));
        setBackgroundResource(R.drawable.btn_verify_code);

    }

    public TimerTextView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public TimerTextView(Context context) {
        this(context, null, 0);
    }


    public void start() {
        if (!isStart) {
            // 开始
            handler.post(this);
            this.setText(timeTotal + " 重新发送");
        }
    }

    @Override
    public void run() {
        if (timeTotal == 0) {
            setText("获取验证码");
            setTextColor(getResources().getColor(R.color.text_red_E5290D));
            setBackgroundResource(R.drawable.btn_verify_code);
            timeTotal = TOTAL_SECONDS;
            isStart = false;
            this.setEnabled(true);
        } else {
            isStart = true;
            handler.postDelayed(this, timeSpace);
            setText(timeTotal-- + "重新发送");
            setTextColor(getResources().getColor(R.color.text_grey_666));
            setBackgroundResource(R.drawable.btn_timer_resent_code);
            this.setEnabled(false);
        }
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        handler.removeCallbacks(this);
        timeTotal = TOTAL_SECONDS;
    }

}
