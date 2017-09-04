package com.ocj.oms.mobile.ui.personal.wallet.packs;

import android.view.View;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;

import butterknife.OnClick;

public class UseInstructionActivity extends BaseActivity {

    @Override
    protected int getLayoutId() {
        return R.layout.activity_use_instruction_layout;
    }

    @Override
    protected void initEventAndData() {

    }

    @OnClick({R.id.btn_close})
    public void onClick(View view) {
        finish();

    }

}
