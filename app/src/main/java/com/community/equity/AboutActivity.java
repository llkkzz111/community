package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.community.equity.base.BaseActivity;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;
import com.mcxiaoke.packer.helper.PackerNg;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnLongClick;

public class AboutActivity extends BaseActivity {

    @BindView(R.id.topview)
    TopView topView;
    @BindView(R.id.tv_about_version)
    TextView tvVersionName;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about_layout);
        ButterKnife.bind(this);
        topView.setTitle(R.string.text_about);
        topView.setLeftImage();
        tvVersionName.setText(getString(R.string.app_name) + getString(R.string.text_version_name_middle) + Utils.getVersion(mContext));
    }

    @OnLongClick(R.id.iv_about_logo)
    public boolean onLogoLongClick() {
        Toast.makeText(mContext, (getString(R.string.app_name) + getString(R.string.text_version_name_middle) + Utils.getVersion(mContext) + "_" + PackerNg.getMarket(mContext)), Toast.LENGTH_SHORT).show();
        return false;
    }

    @OnClick({R.id.tv_agreement, R.id.iv_left})
    public void onAgreementClick(View view) {
        switch (view.getId()) {
            case R.id.iv_left:
                finish();
                break;
            case R.id.tv_agreement:
                Intent intent = new Intent(mContext, WebViewActivity.class);
                intent.putExtra(IntentKeys.KEY_URL, ConstantUtils.HTTPS_community_COMMUNITY_ITERM);
                startActivity(intent);
                break;
        }
    }
}
