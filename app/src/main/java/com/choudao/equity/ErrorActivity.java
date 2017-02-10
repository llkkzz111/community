package com.choudao.equity;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;

import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.view.TopView;

/**
 * Created by liuzhao on 16/8/9.
 */

public class ErrorActivity extends BaseActivity {
    TopView topView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_error_layout);
        topView = (TopView) findViewById(R.id.topview);
        topView.setTitle("错误页");
        topView.getLeftView().setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }
}
