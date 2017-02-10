package com.choudao.equity.view;

import android.content.Context;
import android.content.Intent;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;
import android.widget.Toast;

import com.choudao.equity.CommentsActivity;
import com.choudao.equity.PersonalProfileActivity;
import com.choudao.equity.QuestionDetailsActivity;
import com.choudao.equity.R;
import com.choudao.equity.ReportAddAnotherActivity;
import com.choudao.equity.SingleAnswerActivity;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.ServiceGenerator;
import com.choudao.equity.api.service.ApiService;
import com.choudao.equity.base.BaseApiResponse;
import com.choudao.equity.utils.params.IntentKeys;

import java.util.IdentityHashMap;
import java.util.Map;

import retrofit2.Call;


/**
 * Created by liuzhao on 16/5/12.
 */
public class ReportView extends LinearLayout implements View.OnClickListener {
    private PopupWindow popupWindow;
    private int id;
    private LayoutInflater inflater;
    private Context mContext;
    private View layout;
    private TextView tvReport1, tvReport2, tvReport3, tvReport4, tvReportAnother;
    private LinearLayout llReport2;

    public ReportView(Context context) {
        super(context);
        mContext = context;
        initview(mContext, null, 0);
    }

    public ReportView(Context context, PopupWindow popupWindow) {
        super(context);
        mContext = context;
        this.popupWindow = popupWindow;
        initview(mContext, null, 0);
    }

    public ReportView(Context context, PopupWindow popupWindow, int id) {
        super(context);
        mContext = context;
        this.id = id;
        this.popupWindow = popupWindow;
        initview(mContext, null, 0);
    }

    public ReportView(Context context, AttributeSet attrs) {
        super(context, attrs);
        mContext = context;
        initview(context, attrs, 0);
    }

    public ReportView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        mContext = context;
        initview(context, attrs, defStyle);
    }

    public LayoutInflater getInflater() {
        return inflater;
    }

    private void initview(Context context, AttributeSet attrs, int defStyle) {
        mContext = context;
        inflater = LayoutInflater.from(context);
        layout = inflater.inflate(R.layout.popup_report_layout, this, true);
        initView();
    }

    private void initView() {
        tvReport1 = (TextView) layout.findViewById(R.id.tv_report_1);
        tvReport2 = (TextView) layout.findViewById(R.id.tv_report_2);
        tvReport3 = (TextView) layout.findViewById(R.id.tv_report_3);
        tvReport4 = (TextView) layout.findViewById(R.id.tv_report_4);
        llReport2 = (LinearLayout) layout.findViewById(R.id.ll_report_2);
        tvReportAnother = (TextView) layout.findViewById(R.id.tv_report_another);
        if (!(mContext instanceof PersonalProfileActivity)) {
            llReport2.setVisibility(VISIBLE);
        }
        tvReport1.setOnClickListener(this);
        tvReport2.setOnClickListener(this);
        tvReport3.setOnClickListener(this);
        tvReport4.setOnClickListener(this);
        tvReportAnother.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        String type = "";
        String content = "";
        if (mContext instanceof QuestionDetailsActivity) {
            type = "q";
        } else if (mContext instanceof SingleAnswerActivity) {
            type = "a";
        } else if (mContext instanceof CommentsActivity) {
            type = "c";
        } else if (mContext instanceof PersonalProfileActivity) {
            type = "u";
        }
        switch (v.getId()) {
            case R.id.tv_report_1:
                content = tvReport1.getText().toString();
                break;
            case R.id.tv_report_2:
                content = tvReport2.getText().toString();
                break;
            case R.id.tv_report_3:
                content = tvReport3.getText().toString();
                break;
            case R.id.tv_report_4:
                content = tvReport4.getText().toString();
                break;
            case R.id.tv_report_another:
                content = tvReportAnother.getText().toString();
                break;
        }

        if (!content.equals("其它")) {
            ApiService service = ServiceGenerator.createService(ApiService.class);

            Map<String, Object> params = new IdentityHashMap<String, Object>();
            params.put("reportable[id]", id);
            params.put("reportable[type]", type);
            params.put("reportable[content]", content);
            Call<BaseApiResponse> call = service.userReportings(params);
            call.enqueue(new BaseCallBack<BaseApiResponse>() {
                @Override
                protected void onSuccess(BaseApiResponse baseApiResponse) {
                    if (baseApiResponse.getStatus().equals("OK")) {
                        Toast.makeText(mContext, mContext.getString(R.string.text_report_success), Toast.LENGTH_SHORT).show();
                    } else if (baseApiResponse.getStatus().equals("FAIL")) {
                        Toast.makeText(mContext, baseApiResponse.getMessage(), Toast.LENGTH_SHORT).show();
                    }
                    if (popupWindow != null) {
                        popupWindow.dismiss();
                    }
                }

                @Override
                protected void onFailure(int errCode, String msg) {
                    String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                    Toast.makeText(mContext, String.format(sInfoFormat, msg, String.valueOf(errCode)), Toast.LENGTH_SHORT).show();
                }
            });
        } else {
            Intent intent = new Intent();
            intent.putExtra(IntentKeys.KEY_REPORTABLE_ID, id);
            intent.putExtra(IntentKeys.KEY_CONTENT, content);
            intent.putExtra(IntentKeys.KEY_TYPE, type);
            intent.setClass(mContext, ReportAddAnotherActivity.class);
            mContext.startActivity(intent);
            if (popupWindow != null) {
                popupWindow.dismiss();
            }
        }


    }
}
