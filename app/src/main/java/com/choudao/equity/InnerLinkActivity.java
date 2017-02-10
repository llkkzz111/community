package com.choudao.equity;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.choudao.equity.utils.ActivityStack;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.equity.utils.params.IntentKeys;

public class InnerLinkActivity extends Activity {

    public Activity mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mContext = this;
        if (getIntent().getData() != null)
            checkTab(getIntent());
        else finish();
    }

    private void checkTab(Intent intent) {
        intent.setClass(mContext, MainActivity.class);

        if (!intent.getAction().equals("com.choudao.equity.action")) {
            if (ActivityStack.getInstance().size() >= 1) {
                //第一次打开
                if (!PreferencesUtils.getFirstVisitState()) {
                    if (ActivityStack.getInstance().topActivity() instanceof GuidedActivity) {
                        intent.setClass(mContext, GuidedActivity.class);
                    } else if (ActivityStack.getInstance().topActivity() instanceof LoginActivity) {
                        intent.setClass(mContext, LoginActivity.class);
                    } else {
                        intent.setClass(mContext, LoadingActivity.class);
                    }
                } else {
                    //是否已经登录 是
                    if (PreferencesUtils.getLoginState()) {
                        if (ActivityStack.getInstance().hasActivity(MainActivity.class)) {
                        } else {
                            if (ActivityStack.getInstance().topActivity() instanceof GuidedActivity) {
                                intent.setClass(mContext, GuidedActivity.class);
                            } else {
                                intent.setClass(mContext, LoadingActivity.class);
                            }
                        }
                    } else {
                        //当前停留在哪个Activity
                        if (ActivityStack.getInstance().topActivity() instanceof GuidedActivity) {
                            intent.setClass(mContext, GuidedActivity.class);
                        } else if (ActivityStack.getInstance().topActivity() instanceof LoginActivity) {
                            intent.setClass(mContext, LoginActivity.class);
                        } else {
                            intent.setClass(mContext, LoadingActivity.class);
                        }
                    }
                }
            } else {
                intent.setClass(mContext, LoadingActivity.class);
            }
        } else {
            Uri androidUri = intent.getData();
            String id = androidUri.getQueryParameter("id");

            switch (androidUri.getScheme()) {
                case ConstantUtils.SCHEME_CHOUDAO:
                    switch (androidUri.getHost()) {
                        case ConstantUtils.CHOUDAO_QUESTION:
                            intent.setClass(mContext, QuestionDetailsActivity.class);
                            intent.putExtra(IntentKeys.KEY_QUESTION_ID, Integer.valueOf(id));
                            break;
                        case ConstantUtils.CHOUDAO_ANSWER:
                            intent.setClass(mContext, SingleAnswerActivity.class);
                            intent.putExtra(IntentKeys.KEY_ANSWER_ID, Integer.valueOf(id));
                            intent.putExtra(IntentKeys.KEY_QUESTION_ID, Integer.valueOf(androidUri.getQueryParameter("question_id")));
                            break;
                        case ConstantUtils.CHOUDAO_USER:
                            intent.setClass(mContext, PersonalProfileActivity.class);
                            intent.putExtra(IntentKeys.KEY_USER_ID, Integer.valueOf(id));
                            intent.putExtra(IntentKeys.KEY_USER_NAME, androidUri.getQueryParameter("name"));
                            break;
                        case ConstantUtils.CHOUDAO_PAGE:
                            intent.putExtra(IntentKeys.KEY_MAIN_TAB, id);
                            intent.setClass(mContext, MainActivity.class);
                            break;
                    }
                    break;
                case ConstantUtils.SCHEME_HTTP:
                case ConstantUtils.SCHEME_HTTPS:
                    intent.setClass(mContext, WebViewActivity.class);
                    intent.putExtra(IntentKeys.KEY_URL, intent.getDataString());
                    break;
            }
        }
        startActivity(intent);
        finish();
    }

}
