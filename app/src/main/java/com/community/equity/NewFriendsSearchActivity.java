package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.community.equity.api.BaseCallBack;
import com.community.equity.api.ServiceGenerator;
import com.community.equity.api.service.ApiService;
import com.community.equity.base.BaseActivity;
import com.community.equity.entity.SearchUserEntity;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.imsdk.utils.Logger;

import java.util.HashMap;
import java.util.Map;

import retrofit2.Call;

/**
 * Created by dufeng on 16/9/5.<br/>
 * Description: NewFriendsSearchActivity
 */
public class NewFriendsSearchActivity extends BaseActivity implements View.OnClickListener {
    private static final String TAG = "===NewFriendsSearchActivity===";

    private ImageView ivBack;
    private EditText etSearch;
    private LinearLayout llSearch;
    private TextView tvSearch, tvNoResult;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_newfriend_shearch);

        initView();
    }

    private void initView() {
        ivBack = (ImageView) findViewById(R.id.iv_newfriend_search_back);
        etSearch = (EditText) findViewById(R.id.et_newfriend_search);
        llSearch = (LinearLayout) findViewById(R.id.ll_newfriend_search);
        tvNoResult = (TextView) findViewById(R.id.tv_newfriend_search_no_result);
        tvSearch = (TextView) findViewById(R.id.tv_newfriend_search);

        ivBack.setOnClickListener(this);
        llSearch.setOnClickListener(this);

        etSearch.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEARCH) {
                    searchContact();
                }
                return true;
            }
        });
        etSearch.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {
            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (TextUtils.isEmpty(charSequence)) {
                    llSearch.setVisibility(View.GONE);
                    tvNoResult.setVisibility(View.GONE);
                } else {
                    llSearch.setVisibility(View.VISIBLE);
                    tvSearch.setText(charSequence);
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    /**
     * 搜索用户
     */
    private void searchContact() {
        String strSearch = tvSearch.getText().toString();
        etSearch.setText("");
        llSearch.setVisibility(View.GONE);

        ApiService service = ServiceGenerator.createService(ApiService.class);
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", strSearch);
        Call<SearchUserEntity> call = service.searchUser(params);
        call.enqueue(new BaseCallBack<SearchUserEntity>() {

            @Override
            protected void onSuccess(SearchUserEntity body) {
                if (body != null && body.getId() != null) {
                    Intent intent = new Intent(NewFriendsSearchActivity.this, PersonalProfileActivity.class);
                    intent.putExtra(IntentKeys.KEY_USER_ID, body.getId());
                    intent.putExtra(IntentKeys.KEY_USER_NAME, body.getName());
                    startActivity(intent);
                    finishActivity();
                } else {
                    tvNoResult.setVisibility(View.VISIBLE);
                }
            }

            @Override
            protected void onFailure(int errCode, String msg) {
                Logger.e(TAG, errCode + msg);
                tvNoResult.setVisibility(View.VISIBLE);
            }
        });

//        本地搜索
//        long userId = DBHelper.getInstance().searchNewFriend(strSearch);
//        if (userId == -1) {
//            tvNoResult.setVisibility(View.VISIBLE);
//        } else {
//            Intent intent = new Intent(this, PersonalProfileActivity.class);
//            intent.putExtra(IntentKeys.KEY_USER_ID, userId);
//            startActivity(intent);
//            finishActivity();
//        }
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.ll_newfriend_search:
                searchContact();
                break;
            case R.id.iv_newfriend_search_back:
                finishActivity();
                break;
        }
    }


    private void finishActivity() {
        Utils.hideInput(etSearch);
        finish();
    }

    @Override
    public void onBackPressed() {
        finishActivity();
        super.onBackPressed();
    }
}
