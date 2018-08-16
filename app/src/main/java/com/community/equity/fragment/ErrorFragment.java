package com.community.equity.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.community.equity.R;
import com.community.equity.base.BaseFragment;

/**
 * Created by liuzhao on 16/6/28.
 */

public class ErrorFragment extends BaseFragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_error_layout, null);
    }

}
