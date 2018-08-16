package com.community.equity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.community.equity.adapter.GroupMemberDelAdapter;
import com.community.equity.base.BaseActivity;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.UserInfo;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemClick;
import butterknife.OnTextChanged;


public class GroupChatDelMemberActivity extends BaseActivity {
    @BindView(R.id.topview)
    TopView topView;
    @BindView(R.id.et_group_member_search)
    EditText etSearch;
    @BindView(R.id.ll_group_member_search)
    LinearLayout llSearch;
    @BindView(R.id.lv_members)
    ListView lvMembers;

    private GroupMemberDelAdapter adapter;
    List<UserInfo> userInfoList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group_del_member_layout);
        ButterKnife.bind(this);
        topView.setTitle("聊天成员(N)");
        topView.setLeftImage();
        topView.setRightText("完成");
        userInfoList = DBHelper.getInstance().queryContactInfoList();
        adapter = new GroupMemberDelAdapter(this, userInfoList);
        lvMembers.setAdapter(adapter);
    }

    @OnClick({R.id.ll_group_member_search, R.id.iv_left, R.id.iv_right})
    void onClick(View view) {
        switch (view.getId()) {
            case R.id.ll_group_member_search:
                etSearch.setCursorVisible(true);
                break;
            case R.id.iv_left:
                finish();
                break;
            case R.id.iv_right:
                finish();
                break;
        }
    }

    @OnTextChanged(value = R.id.et_group_member_search, callback = OnTextChanged.Callback.TEXT_CHANGED)
    void onTextChenge(CharSequence text) {
    }

    @OnItemClick(R.id.lv_members) void onItemClick(int position) {
        UserInfo info = userInfoList.get(position);
        Intent intent = new Intent(mContext, PersonalProfileActivity.class);
        intent.putExtra(IntentKeys.KEY_USER_ID, info.getUserId());
        intent.putExtra(IntentKeys.KEY_USER_NAME, info.getName());
        startActivity(intent);
    }

}
