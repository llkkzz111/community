package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.GridView;

import com.choudao.equity.adapter.GroupMemberAdapter;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.UserInfo;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemClick;
import butterknife.OnTextChanged;

/**
 * Created by liuzhao on 16/11/7.
 */
public class GroupChatAllMemberActivity extends BaseActivity {
    @BindView(R.id.topview)
    TopView topView;
    @BindView(R.id.et_group_member_search)
    EditText etMemberSearch;
    @BindView(R.id.gv_group_menber)
    GridView gvMenber;
    List<UserInfo> groupMembers = new ArrayList<>();

    private long groupId;
    private GroupMemberAdapter adapter;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group_chat_member);
        ButterKnife.bind(this);
        initView();
        initData();
    }

    private void initView() {
        topView.setTitle("群成员列表");
        topView.setLeftImage();
    }

    private void initData() {
        groupId = getIntent().getLongExtra(IntentKeys.KEY_GROUP_ID, -1);
        groupMembers.clear();
        groupMembers.addAll(DBHelper.getInstance().queryGroupMemberInfo(groupId, true));
        adapter = new GroupMemberAdapter(this, groupMembers);
        gvMenber.setAdapter(adapter);
    }


    @OnTextChanged(value = R.id.et_group_member_search, callback = OnTextChanged.Callback.TEXT_CHANGED)
    public void onTextChenge(CharSequence text) {
        String search = etMemberSearch.getText().toString();
        groupMembers.clear();
        groupMembers.addAll(DBHelper.getInstance().searchGroupMemberInfo(groupId, search));
        adapter.notifyDataSetChanged();
    }

    @OnClick({R.id.iv_left, R.id.et_group_member_search, R.id.ll_group_member_search})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_left:
                finish();
                break;
            case R.id.et_group_member_search:
                etMemberSearch.setCursorVisible(true);
                break;
        }
    }

    @OnItemClick(R.id.gv_group_menber)
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        UserInfo info = groupMembers.get(position);
        Intent intent = new Intent();
        intent.setClass(mContext, PersonalProfileActivity.class);
        intent.putExtra(IntentKeys.KEY_USER_ID, info.getUserId());
        intent.putExtra(IntentKeys.KEY_USER_NAME, info.getName());
        startActivity(intent);
    }
}
