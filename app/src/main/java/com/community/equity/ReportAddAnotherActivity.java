package com.community.equity;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import com.community.equity.api.BaseCallBack;
import com.community.equity.base.BaseActivity;
import com.community.equity.base.BaseApiResponse;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;

import java.util.IdentityHashMap;
import java.util.Map;

import retrofit2.Call;

public class ReportAddAnotherActivity extends BaseActivity {

    private TopView topView;
    private EditText etReport;
    private int id;
    private String type;
    private String content;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_report_add_another_layout);
        id = getIntent().getIntExtra(IntentKeys.KEY_REPORTABLE_ID, -1);
        type = getIntent().getStringExtra(IntentKeys.KEY_TYPE);
        content = getIntent().getStringExtra(IntentKeys.KEY_CONTENT);
        initView();
    }

    private void initView() {
        etReport = (EditText) findViewById(R.id.et_report);
        topView = (TopView) findViewById(R.id.topview);
        topView.setRightText(R.string.text_confirm);
        topView.setTitle(R.string.text_report_content);
        topView.getLeftView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Utils.hideInput(topView);
                finish();
            }
        });
        etReport.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                int length = etReport.getText().toString().length();
                if (length > 2000) {
                    topView.getRightView().setEnabled(false);
                    topView.getRightView().setTextColor(getResources().getColor(R.color.grey));
                    topView.setTitle(String.format(
                            getString(R.string.text_has_over_text_size),
                            (length - 2000)));
                    topView.getTitleView().setTextColor(getResources().getColor(R.color.text_title_warning_text_color));
                } else {
                    topView.getTitleView().setTextColor(getResources().getColor(R.color.text_default_color));
                    topView.getRightView().setEnabled(true);
                    topView.getRightView().setTextColor(getResources().getColor(R.color.tab_check_color));
                    topView.setTitle(R.string.text_report_content);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        topView.getRightView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String mComment = etReport.getText().toString().trim();
                if (TextUtils.isEmpty(mComment)) {
                    Toast.makeText(mContext, getString(R.string.text_add_report_content), Toast.LENGTH_SHORT).show();
                    return;
                }

                Map<String, Object> params = new IdentityHashMap<String, Object>();
                params.put("reportable[id]", id);
                params.put("reportable[type]", type);
                params.put("reportable[content]", content);
                Call<BaseApiResponse> call = service.userReportings(params);
                call.enqueue(new BaseCallBack<BaseApiResponse>() {
                    @Override
                    protected void onSuccess(BaseApiResponse baseApiResponse) {
                        if (baseApiResponse.getStatus().equals("OK")) {
                            Toast.makeText(mContext, getString(R.string.text_report_success), Toast.LENGTH_SHORT).show();
                        } else if (baseApiResponse.getStatus().equals("FAIL")) {
                            Toast.makeText(mContext, baseApiResponse.getMessage(), Toast.LENGTH_SHORT).show();
                        }
                        Utils.hideInput(topView);
                        finish();
                    }

                    @Override
                    protected void onFailure(int errCode, String msg) {
                        String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                        Toast.makeText(getBaseContext(), String.format(sInfoFormat, msg, String.valueOf(errCode)), Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });
    }
}
