package com.choudao.equity;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.choudao.equity.adapter.OnRecyclerViewListener;
import com.choudao.equity.adapter.SelectContactsAdapter;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.entity.ContactsItem;
import com.choudao.equity.entity.LetterInfo;
import com.choudao.equity.utils.CollectionUtil;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.DividerItemDecoration;
import com.choudao.equity.view.LetterSideBar;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.GroupMember;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.constants.ResponseCode;
import com.choudao.imsdk.dto.request.AddGroupMemberRequest;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.dto.request.CreateGroupRequest;
import com.choudao.imsdk.dto.request.RemoveGroupMemberRequest;
import com.choudao.imsdk.dto.response.BaseResponse;
import com.choudao.imsdk.imutils.IMMessageDispatcher;
import com.choudao.imsdk.imutils.SendMessageQueue;
import com.choudao.imsdk.imutils.callback.IReceiver;
import com.tonicartos.superslim.LayoutManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindColor;
import butterknife.BindString;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * Created by dufeng on 16/10/18.<br/>
 * Description: SelectContacts
 */

public class GroupSelectContactsActivity extends BaseActivity implements LetterSideBar.OnTouchingLetterChangedListener, IReceiver {

    public static final int SELECT_TYPE_CREATE = 1;
    public static final int SELECT_TYPE_ADD = 2;
    public static final int SELECT_TYPE_DELETE = 3;

    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.tv_search_empty) TextView tvEmpty;
    @BindView(R.id.et_select_contacts_search) EditText etSearch;
    @BindView(R.id.rv_select_contacts_friends) RecyclerView rvFriends;
    @BindView(R.id.lsb_select_contacts) LetterSideBar mLetterSideBar;
    @BindView(R.id.iv_right) TextView tvRight;
    @BindView(R.id.rl_loading) RelativeLayout rlLoading;
    @BindView(R.id.tv_loading) TextView tvLoading;


    @BindColor(R.color.profile_un_follow_bg) int selectTextColor;
    @BindColor(R.color.dialog_cancle_stroke) int unSelectTextColor;
    @BindString(R.string.text_confirm) String confirm;
    @BindString(R.string.text_cancle) String cancle;
    private int selectType;

    private SelectContactsAdapter adapter;
    private BaseDialogFragment dialog = new BaseDialogFragment();
    private long groupId;
    private List<Long> ids = new ArrayList();

    private List<ContactsItem<UserInfo>> contactsItemList;
    private Map<Long, UserInfo> mapUsers = new HashMap<>();

    private MessageType[] msgTypeArray = {
            MessageType.CREATE_GROUP,
            MessageType.ADD_GROUP_MEMBER,
            MessageType.REMOVE_GROUP_MEMBER,
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select_contacts);
        ButterKnife.bind(this);
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);
        init();
        initView();
        initData();
    }

    private void init() {
        contactsItemList = new ArrayList<>();
        groupId = getIntent().getLongExtra(IntentKeys.KEY_GROUP_ID, -1);
        selectType = getIntent().getIntExtra(IntentKeys.KEY_GROUP_SELECT_TYPE, -1);
        switch (selectType) {
            case SELECT_TYPE_CREATE:
                ids.add((long) ConstantUtils.USER_ID);
                if (getIntent().hasExtra(IntentKeys.KEY_USER_ID)) {
                    long id = getIntent().getLongExtra(IntentKeys.KEY_USER_ID, -1);
                    if (id != -1) {
                        ids.add(id);
                        mapUsers.put(id, null);
                    }
                }
                break;
            case SELECT_TYPE_ADD:
                createMemberIdArray(groupId);
                break;
        }
    }

    private void createMemberIdArray(long groupId) {
        List<GroupMember> groupMember = DBHelper.getInstance().queryGroupMembers(groupId);
        for (int i = 0; i < groupMember.size(); i++) {
            ids.add(groupMember.get(i).getUserId());
        }
    }

    /**
     * 　检查是否群成员
     *
     * @param userInfo
     * @return
     */
    private int checkMember(UserInfo userInfo) {
        for (long userId : ids) {
            if (userInfo.getUserId() == userId) {
                return SelectContactsAdapter.INHERENT_MEMBER;
            }
        }
        return SelectContactsAdapter.NON_MEMBER;
    }


    private void initView() {
        if (selectType == SELECT_TYPE_DELETE) {
            topView.setTitle("删除群成员");
        } else {
            topView.setTitle(R.string.text_select_contacts);
        }
        tvRight.setEnabled(false);
        tvRight.setTextColor(unSelectTextColor);
        topView.setLeftImage();
        topView.setRightText(confirm);

        rvFriends.setLayoutManager(new LayoutManager(this));
        rvFriends.addItemDecoration(new DividerItemDecoration(this, LinearLayoutManager.HORIZONTAL));
        if (selectType == SELECT_TYPE_DELETE) {
            mLetterSideBar.setVisibility(View.GONE);
        }

        adapter = new SelectContactsAdapter(this, contactsItemList);
        adapter.setOnRecyclerViewListener(new SelectContactListener());

        rvFriends.setAdapter(adapter);
        mLetterSideBar.setOnTouchingLetterChangedListener(this);
    }

    private void showLoading(String text) {
        if (TextUtils.isEmpty(text)) {
            tvLoading.setVisibility(View.GONE);
        }
        tvLoading.setText(text);
        rlLoading.setVisibility(View.VISIBLE);
    }

    private void dismissLoading() {
        rlLoading.setVisibility(View.GONE);
    }

    private void initData() {
        contactsItemList.clear();
        if (selectType == SELECT_TYPE_DELETE) {
            contactsItemList.addAll(usersToGroupContacts(DBHelper.getInstance().queryGroupMemberInfo(groupId, false)));
        } else {
            contactsItemList.addAll(usersToContacts(DBHelper.getInstance().queryNonSystemContactInfoList()));
        }
        adapter.notifyDataSetChanged();
        checkEmptyView("没有联系人");
    }

    private void checkEmptyView(CharSequence emptyText) {
        if (CollectionUtil.isEmpty(contactsItemList)) {
            rvFriends.setVisibility(View.GONE);
            mLetterSideBar.setVisibility(View.GONE);
            tvEmpty.setVisibility(View.VISIBLE);
            tvEmpty.setText(emptyText);


            int spec = View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED);
            tvEmpty.measure(spec, spec);
            TextPaint textPaint = tvEmpty.getPaint();
            float textPaintWidth = textPaint.measureText(emptyText.toString());
            if (textPaintWidth >= ConstantUtils.SCREEN_WIDTH - 20) {
                etSearch.setText("");
            }

        } else {
            rvFriends.setVisibility(View.VISIBLE);
            mLetterSideBar.setVisibility(View.VISIBLE);
            tvEmpty.setVisibility(View.GONE);
        }
    }

    private List<ContactsItem<UserInfo>> usersToGroupContacts(List<UserInfo> userInfos) {
        List<ContactsItem<UserInfo>> contactsItemList = new ArrayList<>();
        for (UserInfo userInfo : userInfos) {
            contactsItemList.add(new ContactsItem<UserInfo>(0, userInfo, checkMember(userInfo)));
        }
        return contactsItemList;
    }


    private List<ContactsItem<UserInfo>> usersToContacts(List<UserInfo> userInfos) {
        //转换后的item集合
        List<ContactsItem<UserInfo>> contactsItemList = new ArrayList<>();
        //头部字母列表
        List<LetterInfo> letterInfos = new ArrayList<>();
        //头字母对应用户列表的map
        Map<String, List<UserInfo>> mapUserInfosList = new LinkedHashMap<>();
        for (String strHead : LetterSideBar.letters) {
            mapUserInfosList.put(strHead, new ArrayList<UserInfo>());
        }
        for (UserInfo userInfo : userInfos) {
            String userHead = userInfo.showPinYin().substring(0, 1);
            if (mapUserInfosList.get(userHead) != null) {
                mapUserInfosList.get(userHead).add(userInfo);
            } else {
                mapUserInfosList.get("#").add(userInfo);
            }
        }

        //记录起始点
        int sectionFirstPosition = 0;

        for (Map.Entry<String, List<UserInfo>> entry : mapUserInfosList.entrySet()) {

            if (entry.getValue().size() == 0) {
                letterInfos.add(new LetterInfo(sectionFirstPosition, entry.getKey()));
            } else {
                //记录起始点
                sectionFirstPosition = contactsItemList.size();
                letterInfos.add(new LetterInfo(sectionFirstPosition, entry.getKey()));
                //添加联系人的分类栏
                contactsItemList.add(new ContactsItem(sectionFirstPosition, entry.getKey()));
            }

            //添加分类栏下面的联系人的信息
            for (UserInfo userInfo : entry.getValue()) {
                contactsItemList.add(new ContactsItem(sectionFirstPosition, userInfo, checkMember(userInfo)));
            }
        }

        mLetterSideBar.setLetterInfos(letterInfos);

        return contactsItemList;
    }

    @OnTextChanged(value = R.id.et_select_contacts_search, callback = OnTextChanged.Callback.TEXT_CHANGED)
    public void onTextChenge(CharSequence text) {
        String search = etSearch.getText().toString();

        if (TextUtils.isEmpty(search)) {
            initData();
        } else {
            contactsItemList.clear();
            if (SELECT_TYPE_DELETE == selectType) {
                contactsItemList.addAll(usersToGroupContacts(DBHelper.getInstance().searchGroupMemberInfo(groupId, search)));
            } else {
                contactsItemList.addAll(usersToGroupContacts(DBHelper.getInstance().searchNonSystemContacts(search)));
            }
            rvFriends.setLayoutManager(new LayoutManager(mContext));
            adapter.notifyDataSetChanged();
            String empty = "没有找到\"" + search + "\"相关结果";
            SpannableStringBuilder builder = new SpannableStringBuilder(empty);
            ForegroundColorSpan chengeSpan = new ForegroundColorSpan(selectTextColor);
            builder.setSpan(chengeSpan, 5, 5 + search.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
            checkEmptyView(builder);
        }
    }


    @OnClick({R.id.iv_left, R.id.et_select_contacts_search, R.id.iv_right, R.id.rl_loading})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_left:
                Utils.hideInput(v);
                finish();
                break;
            case R.id.iv_right:
                final List<Long> list = new ArrayList<>(mapUsers.keySet());

                switch (selectType) {
                    case SELECT_TYPE_CREATE:
                        if (list.size() > 1) {
//                            showLoading("正在发起群聊...");
                            dialog.addProgress("正在发起群聊...");
                            dialog.show(getSupportFragmentManager(), "create_group");
                            SendMessageQueue.getInstance().addSendMessage(MessageType.CREATE_GROUP,
                                    new CreateGroupRequest(list));
                        } else if (list.size() == 1) {
                            Intent intent = new Intent(this, PrivateMessageActivity.class);
                            intent.putExtra(IntentKeys.KEY_TARGET_ID, list.get(0).longValue());
                            startActivity(intent);
                            return;
                        }
                        break;
                    case SELECT_TYPE_ADD:
                        dialog.addProgress("正在添加联系人...");
                        dialog.show(getSupportFragmentManager(), "add_group");
//                        showLoading("正在添加联系人...");
                        SendMessageQueue.getInstance().addSendMessage(MessageType.ADD_GROUP_MEMBER,
                                new AddGroupMemberRequest(groupId, list));
                        break;
                    case SELECT_TYPE_DELETE:
                        String delUserName = "";
                        List<UserInfo> userList = new ArrayList<>(mapUsers.values());
                        for (int i = 0; i < userList.size(); i++) {
                            if (i <= 3) {
                                UserInfo userInfo = userList.get(i);
                                delUserName += userInfo.showName();
                                if (i < mapUsers.size() - 1 && i < 3) {
                                    delUserName += "、";

                                }
                            }
                        }

                        String content = "确定要删除群成员";
                        if (mapUsers.size() > 4)
                            content += (delUserName + "等" + mapUsers.size() + "位成员？");
                        else {
                            content += (delUserName + "？");
                        }
                        dialog.addContent(content)
                                .addButton(1, cancle, null)
                                .addButton(2, confirm, new View.OnClickListener() {
                                    @Override
                                    public void onClick(View v) {
                                        dialog = new BaseDialogFragment();
                                        dialog.addProgress("正在删除选定的群成员...");
                                        dialog.show(getSupportFragmentManager(), "del_group");
//                                        showLoading("正在删除选定的群成员...");
                                        SendMessageQueue.getInstance().addSendMessage(MessageType.REMOVE_GROUP_MEMBER,
                                                new RemoveGroupMemberRequest(groupId, list));
                                    }
                                }).show(getSupportFragmentManager(), "delete_group_member");
                        break;
                }
                break;
            case R.id.et_select_contacts_search:
                etSearch.setCursorVisible(true);
                break;
        }
    }

    @Override
    public void onBackPressed() {
        if (rlLoading.getVisibility() != View.VISIBLE) {
            super.onBackPressed();
        }
    }

    @Override
    protected void onDestroy() {
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
        super.onDestroy();
    }

    @Override
    public void onTouchingLetterChanged(LetterInfo info) {
        rvFriends.scrollToPosition(info.position);
    }

    @Override
    public void onTouchingLetterUp() {

    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {

    }

    @Override
    public void receiverMessageFail(final MessageType messageType, BaseRequest request, final MessageDTO response) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                //dismissLoading();
                dismissDialog();
                switch (messageType) {
                    case CREATE_GROUP:
                    case ADD_GROUP_MEMBER:
                    case REMOVE_GROUP_MEMBER:

                        BaseResponse baseResponse = JSON.parseObject(response.getBody(), BaseResponse.class);
                        switch (baseResponse.getCode()) {
                            case ResponseCode.NO_TWO_WAY_FRIEND:
                                BaseDialogFragment dialogFragment = new BaseDialogFragment();
                                dialogFragment.addContent(getString(R.string.text_no_tow_friend)).
                                        addButton(2, getString(R.string.text_confirm), null).
                                        show(getSupportFragmentManager(), "no_tow_friend");
                                break;
                            case ResponseCode.NOT_GROUP_MEMBER:
                                Toast.makeText(mContext, "非群组成员", Toast.LENGTH_SHORT).show();
                                break;
                            case ResponseCode.OPERATION_DONE_BY_OTHER:
                                Toast.makeText(mContext, "此操作已被其他人完成", Toast.LENGTH_SHORT).show();
                                break;
                        }
                        break;
                }
            }
        });
    }

    @Override
    public void receiverMessageTimeout(final MessageType messageType, BaseRequest request) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
//                dismissLoading();
                dismissDialog();
                switch (messageType) {
                    case CREATE_GROUP:
                        Toast.makeText(mContext, "网络不畅，创建失败，请稍后再试", Toast.LENGTH_SHORT).show();
                        break;
                    case ADD_GROUP_MEMBER:
                        Toast.makeText(mContext, "网络不畅，添加失败，请稍后再试", Toast.LENGTH_SHORT).show();
                        break;
                    case REMOVE_GROUP_MEMBER:
                        Toast.makeText(mContext, "网络不畅，删除失败，请稍后再试", Toast.LENGTH_SHORT).show();
                        break;

                }
            }
        });
    }

    private void dismissDialog() {
        if (dialog.isShow())
            dialog.dismissAllowingStateLoss();
    }

    class SelectContactListener implements OnRecyclerViewListener {

        @Override
        public void onItemClick(int position, View view) {
            ContactsItem<UserInfo> item = contactsItemList.get(position);
            if (item.selectState != SelectContactsAdapter.INHERENT_MEMBER && selectType != SELECT_TYPE_DELETE || selectType == SELECT_TYPE_DELETE) {
                if (mapUsers.containsKey(item.info.getUserId())) {
                    mapUsers.remove(item.info.getUserId());
                } else {
                    mapUsers.put(item.info.getUserId(), item.info);
                }
                if (mapUsers.size() == 0) {
                    tvRight.setEnabled(false);
                    tvRight.setText(confirm);
                    tvRight.setTextColor(unSelectTextColor);
                } else if (mapUsers.size() > 0) {
                    tvRight.setText(confirm + "(" + mapUsers.size() + ")");
                    tvRight.setTextColor(selectTextColor);
                    tvRight.setEnabled(true);
                }
            }
            adapter.changeSelectState(position);
        }

        @Override
        public boolean onItemLongClick(int position, View view) {
            return false;
        }
    }
}
