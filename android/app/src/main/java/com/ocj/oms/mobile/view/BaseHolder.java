package com.ocj.oms.mobile.view;

import android.view.View;

import butterknife.ButterKnife;

/**
 * Created by yy on 2017/5/10.
 */

public class BaseHolder {

    public BaseHolder(View convertView) {
        ButterKnife.bind(this, convertView);
    }


}
