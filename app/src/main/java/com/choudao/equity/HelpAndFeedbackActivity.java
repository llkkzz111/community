package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.TopView;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class HelpAndFeedbackActivity extends BaseActivity {
    @BindView(R.id.topview)
    TopView topView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_help_and_feedback_layout);
        ButterKnife.bind(this);
        topView.setLeftImage();
        topView.setTitle(R.string.text_help_feedback);
    }


    @OnClick({R.id.ll_shengfu_pay_help, R.id.ll_bank_help, R.id.ll_term_help, R.id.ll_qa_help, R.id.iv_left})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ll_shengfu_pay_help:
                startNewActivity(ConstantUtils.HTTPS_CHOUDAO_HELP_SHENGFU_PAY);
                break;
            case R.id.ll_term_help:
                startNewActivity(ConstantUtils.HTTPS_CHOUDAO_HELP_TERM);
                break;
            case R.id.ll_qa_help:
                startNewActivity(ConstantUtils.HTTPS_CHOUDAO_HELP_QA);
                break;
            case R.id.ll_bank_help:
                startNewActivity(ConstantUtils.HTTPS_CHOUDAO_HELP_BANK);
                break;
            case R.id.iv_left:
                finish();
                break;
        }
    }

    private void startNewActivity(String url) {
        Intent intent = new Intent(mContext, WebViewActivity.class);
        intent.putExtra(IntentKeys.KEY_URL, url);
        intent.putExtra(IntentKeys.KEY_FROM_LOADING, false);
        startActivity(intent);
    }

}
