package com.community.equity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.community.equity.base.BaseActivity;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liuzhao on 16/4/27.
 */
public class LinkAddActivity extends BaseActivity {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.et_link_title) EditText etLinkTitle;
    @BindView(R.id.et_link_path) EditText etLinkPath;

    private InputFilter filter = new InputFilter() {
        @Override
        public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
            char temp[] = (source.toString()).toCharArray();
            char result[] = new char[temp.length];
            for (int i = 0, j = 0; i < temp.length; i++) {
                if (temp[i] == ' ') {
                    continue;
                } else {
                    result[j++] = temp[i];
                }
            }
            return String.valueOf(result).trim();
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_link_add_layout);
        ButterKnife.bind(this);
        initView();
    }

    private void initView() {
        etLinkPath.setFilters(new InputFilter[]{filter});
        topView.setTitle(R.string.text_add_links);
        topView.setLeftImage();
    }

    @OnClick({R.id.btn_cancle, R.id.iv_left, R.id.btn_link_add})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_cancle:
            case R.id.iv_left:
                finish();
                break;
            case R.id.btn_link_add:
                String title = etLinkTitle.getText().toString().trim();
                String link = etLinkPath.getText().toString().trim();
                if (TextUtils.isEmpty(title) || TextUtils.isEmpty(link)) {
                    Toast.makeText(mContext, "请输入标题或者链接！", Toast.LENGTH_SHORT).show();
                    return;
                }
                if (!link.matches("^(http(s)?:\\/\\/)?[^.\\s!\\*'\\(\\);:@&=\\+\\$,\\/\\?#\\[\\]]*(\\.[^.\\s]*)+$")) {
                    Toast.makeText(mContext, "请输入正确的链接！", Toast.LENGTH_SHORT).show();
                    return;
                }
                Intent intent = new Intent();
                intent.putExtra(IntentKeys.KEY_LINK_TITLE, title);
                intent.putExtra(IntentKeys.KEY_LINK_PATH, link);
                setResult(Activity.RESULT_OK, intent);
                finish();
                break;
        }

    }
}
