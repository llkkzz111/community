package com.ocj.oms.mobile.view;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.AttributeSet;
import android.view.View;
import android.widget.Toast;

import com.ocj.oms.mobile.third.Constants;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;


/**
 * 自定义短信验证码倒计时组件
 */
public class CallTextView extends android.support.v7.widget.AppCompatTextView implements View.OnClickListener {

    private Context mContext;
    String eventId;

    public CallTextView(Context context) {
        this(context, null, 0);
    }


    public void setTraceEvent(String id) {
        this.eventId = id;
    }


    public CallTextView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public CallTextView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.mContext = context;
        this.setOnClickListener(this);

    }


    @Override
    public void onClick(View v) {
        OcjStoreDataAnalytics.trackEvent(mContext, eventId);
        Toast.makeText(mContext, "东东帮您接通热线电话！", Toast.LENGTH_LONG).show();
        Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse("tel:" + Constants.HOT_LINE));
        mContext.startActivity(intent);
    }
}
