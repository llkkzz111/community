package com.choudao.equity.utils;

import android.content.Context;
import android.content.Intent;
import android.support.v4.app.FragmentTransaction;
import android.view.View;

import com.choudao.equity.LoginActivity;
import com.choudao.equity.R;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.base.BaseFragment;
import com.choudao.equity.dialog.BaseDialogFragment;

/**
 * Created by liuzhao on 16/11/2.
 */

public class DialogFractory {
    private Context mContext;
    private FragmentTransaction transaction;
    private BaseDialogFragment dialog;
    private boolean isShow = false;

    public DialogFractory(BaseActivity mActivity) {
        this.transaction = mActivity.getSupportFragmentManager().beginTransaction();
        mContext = mActivity;
    }

    public DialogFractory(BaseFragment mFragment) {
        this.transaction = mFragment.getFragmentManager().beginTransaction();
        mContext = mFragment.getContext();
    }



    public void showKODialog(String content) {
        dialog = BaseDialogFragment.newInstance(BaseDialogFragment.DIALOG_UNDISMISS);
        dialog.addContent(content).
                addButton(2, mContext.getString(R.string.text_confirm), new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        PreferencesUtils.setUserId(-1);
                        Intent intent = new Intent(mContext, LoginActivity.class);
                        mContext.startActivity(intent);

                    }
                });
        transaction.add(dialog, "login");
        transaction.commitAllowingStateLoss();

    }

    public void showProgress(FragmentTransaction transaction) {
        isShow = true;
        dialog = BaseDialogFragment.newInstance();
        dialog.addProgress();
        transaction.add(dialog, "showProgress");
        transaction.commitNowAllowingStateLoss();
    }

    public boolean isShow() {

        return isShow;
    }

    public void dismiss() {
        if (dialog != null) {
            isShow = false;
            dialog.dismissAllowingStateLoss();
        }
    }
}
