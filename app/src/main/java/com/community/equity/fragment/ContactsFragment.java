package com.community.equity.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.community.equity.LocalSearchActivity;
import com.community.equity.NewFriendsActivity;
import com.community.equity.PersonalProfileActivity;
import com.community.equity.R;
import com.community.equity.adapter.ContactsAdapter;
import com.community.equity.adapter.OnRecyclerViewListener;
import com.community.equity.base.BaseFragment;
import com.community.equity.entity.ContactsItem;
import com.community.equity.entity.LetterInfo;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.DividerItemDecoration;
import com.community.equity.view.LetterSideBar;
import com.community.equity.view.TopView;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.Message;
import com.community.imsdk.db.bean.UserInfo;
import com.community.imsdk.dto.MessageDTO;
import com.community.imsdk.dto.constants.MessageType;
import com.community.imsdk.dto.constants.SessionType;
import com.community.imsdk.dto.request.BaseRequest;
import com.community.imsdk.imutils.IMMessageDispatcher;
import com.community.imsdk.imutils.callback.IReceiver;
import com.tonicartos.superslim.LayoutManager;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;

public class ContactsFragment extends BaseFragment implements IReceiver, OnRecyclerViewListener, LetterSideBar.OnTouchingLetterChangedListener {

    @BindView(R.id.topview)
    TopView topView;
    @BindView(R.id.rv_activity_friends)
    RecyclerView rvContent;
    @BindView(R.id.lsb_activity_friends)
    LetterSideBar mLetterSideBar;
    @BindView(R.id.tv_activity_friends_letter)
    TextView tvLetter;
    private ContactsAdapter contactsAdapter;

    private MessageType[] msgTypeArray = {
            MessageType.LOCAL_LOAD_FRIEND_END,
            MessageType.PUSH_MESSAGE,
            MessageType.PULL_MESSAGE
    };

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);
        View rootView = inflater.inflate(R.layout.fragment_contacts_layout, container, false);
        ButterKnife.bind(this, rootView);
        initView();
        return rootView;
    }

    private void initView() {
        topView.setTitle(R.string.text_my_contacts);

        contactsAdapter = new ContactsAdapter(getActivity());
        rvContent.setLayoutManager(new LayoutManager(getActivity()));
        rvContent.setAdapter(contactsAdapter);
        rvContent.addItemDecoration(new DividerItemDecoration(getActivity(), LinearLayoutManager.HORIZONTAL));
        contactsAdapter.setOnRecyclerViewListener(this);

        mLetterSideBar.setOnTouchingLetterChangedListener(this);
    }

    @Override
    public void onResume() {
        initData();
        super.onResume();
    }

    private void initData() {
        List<UserInfo> userInfos = DBHelper.getInstance().queryContactInfoList();
        long newFriendCount = DBHelper.getInstance().getNewFriendNumber();
        if (contactsAdapter != null) {
            contactsAdapter.setData(usersToContacts(userInfos), newFriendCount);
        }
    }

    private List<ContactsItem<UserInfo>> usersToContacts(List<UserInfo> userInfos) {

        //转换后的item集合
        List<ContactsItem<UserInfo>> contactsItemList = new ArrayList<>();
        //头部字母列表
        List<LetterInfo> letterInfos = new ArrayList<>();
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
        contactsItemList.add(new ContactsItem<UserInfo>(sectionFirstPosition));
        letterInfos.add(new LetterInfo(sectionFirstPosition, "↑"));

        for (Map.Entry<String, List<UserInfo>> entry : mapUserInfosList.entrySet()) {

            if (entry.getValue().size() == 0) {
                letterInfos.add(new LetterInfo(sectionFirstPosition, entry.getKey()));
            } else {
                //记录起始点
                sectionFirstPosition = contactsItemList.size();
                letterInfos.add(new LetterInfo(sectionFirstPosition, entry.getKey()));
                //添加联系人的分类栏
                contactsItemList.add(new ContactsItem<UserInfo>(sectionFirstPosition, entry.getKey()));
            }

            //添加分类栏下面的联系人的信息
            for (UserInfo userInfo : entry.getValue()) {
                contactsItemList.add(new ContactsItem<UserInfo>(sectionFirstPosition, userInfo));
            }
        }

        mLetterSideBar.setLetterInfos(letterInfos);

        return contactsItemList;
    }

    @Override
    public void onItemClick(int position, View view) {
        ContactsItem<UserInfo> contactsItem = contactsAdapter.getData().get(position);
        if (contactsItem.itemType == ContactsItem.VIEW_CONTACTS_CONTENT) {
            Intent intent = new Intent(getActivity(), PersonalProfileActivity.class);
            intent.putExtra(IntentKeys.KEY_USER_ID, contactsItem.info.getUserId());
            startActivity(intent);
        } else {
            Intent intent;
            switch (view.getId()) {
                case R.id.ll_header_contacts_search:
                    intent = new Intent(getActivity(), LocalSearchActivity.class);
                    startActivity(intent);
                    break;
                case R.id.ll_header_contacts_new_friends:
                    intent = new Intent(getActivity(), NewFriendsActivity.class);
                    startActivity(intent);
                    break;
            }
        }
    }

    @Override
    public boolean onItemLongClick(int position, View view) {
        return false;
    }

    @Override
    public void onTouchingLetterChanged(LetterInfo info) {
        rvContent.scrollToPosition(info.position);
        tvLetter.setText(info.name);
        tvLetter.setVisibility(View.VISIBLE);
    }

    @Override
    public void onTouchingLetterUp() {
        tvLetter.setVisibility(View.GONE);
    }

    @Override
    public void onDestroyView() {
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
        super.onDestroyView();
    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        switch (messageType) {
            case PUSH_MESSAGE:
                Message ppMessage = (Message) response;
                if (ppMessage.getSessionType() != SessionType.FRIEND_REQUEST.code) {
                    return;
                }
            case PULL_MESSAGE:
            case LOCAL_LOAD_FRIEND_END:
                getActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        initData();
                    }
                });
                break;
        }
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {

    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {

    }
}
