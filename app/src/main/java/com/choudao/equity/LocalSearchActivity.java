package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.choudao.equity.adapter.LocalSearchAdapter;
import com.choudao.equity.adapter.OnRecyclerViewListener;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.DividerItemDecoration;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.UserInfo;

import java.util.ArrayList;
import java.util.List;


/**
 * Created by dufeng on 16/9/2.<br/>
 * Description: LocalSearchActivity
 */
public class LocalSearchActivity extends BaseActivity implements View.OnClickListener, OnRecyclerViewListener {

    private static final String TAG = "===LocalSearchActivity===";

    private ImageView ivBack;
    private EditText etSearch;
    private RecyclerView rvSearch;
    private TextView tvNoResult;

    private LocalSearchAdapter searchAdapter;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_local_shearch);

        initView();
    }

    private void initView() {
        ivBack = (ImageView) findViewById(R.id.iv_local_search_back);
        etSearch = (EditText) findViewById(R.id.et_local_search);
        rvSearch = (RecyclerView) findViewById(R.id.rv_local_search);
        tvNoResult = (TextView) findViewById(R.id.tv_local_search_no_result);


        rvSearch.setLayoutManager(new LinearLayoutManager(this));
        rvSearch.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.HORIZONTAL));

        searchAdapter = new LocalSearchAdapter(this);
        rvSearch.setAdapter(searchAdapter);
        searchAdapter.setOnRecyclerViewListener(this);

        ivBack.setOnClickListener(this);
        etSearch.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_SEARCH) {
                    Utils.hideInput(etSearch);
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
                searchContact(charSequence.toString());
            }

            @Override
            public void afterTextChanged(Editable editable) {
            }
        });
    }

    private void searchContact(String strSearch) {
        if (TextUtils.isEmpty(strSearch)) {
            searchAdapter.setData(new ArrayList<UserInfo>());
            rvSearch.setVisibility(View.VISIBLE);
            tvNoResult.setVisibility(View.GONE);
        } else {
            List<UserInfo> userInfoList = DBHelper.getInstance().searchContacts(strSearch);
            if (userInfoList != null && userInfoList.size() > 0) {
                rvSearch.setVisibility(View.VISIBLE);
                tvNoResult.setVisibility(View.GONE);
            } else {
                rvSearch.setVisibility(View.GONE);
                tvNoResult.setVisibility(View.VISIBLE);
            }
            searchAdapter.setData(userInfoList);
        }
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_local_search_back:
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

    @Override
    public void onItemClick(int position, View view) {
        Intent intent = new Intent(this, PersonalProfileActivity.class);
        intent.putExtra(IntentKeys.KEY_USER_ID, searchAdapter.getUserInfoByPosition(position).getUserId());
        startActivity(intent);
    }

    @Override
    public boolean onItemLongClick(int position, View view) {
        return false;
    }
}
