package com.choudao.equity;

import android.content.Intent;
import android.database.Cursor;
import android.os.Build;
import android.os.Bundle;
import android.provider.ContactsContract.CommonDataKinds.Email;
import android.provider.ContactsContract.CommonDataKinds.Phone;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.choudao.equity.adapter.MobileContactsAdapter;
import com.choudao.equity.adapter.OnRecyclerViewListener;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.entity.ContactInfo;
import com.choudao.equity.entity.ContactsItem;
import com.choudao.equity.utils.PackageUtils;
import com.choudao.equity.utils.PermissionUtils;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.DividerItemDecoration;
import com.choudao.equity.view.LetterSideBar;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.MobileUserInfo;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.request.AddFriendRequest;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.dto.request.DeleteFriendRequest;
import com.choudao.imsdk.dto.request.GetFriendConfirmationRequest;
import com.choudao.imsdk.dto.response.GetFriendConfirmationResponse;
import com.choudao.imsdk.imutils.IMMessageDispatcher;
import com.choudao.imsdk.imutils.SendMessageQueue;
import com.choudao.imsdk.imutils.callback.IReceiver;
import com.choudao.imsdk.utils.Pinyin4jUtil;
import com.tonicartos.superslim.LayoutManager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import retrofit2.Call;

import static com.choudao.equity.dialog.BaseDialogFragment.DIALOG_BACK_DISMISS;

/**
 * Created by dufeng on 16/9/26.<br/>
 * Description: MobileContactsActivity
 */

public class MobileContactsActivity extends BaseActivity implements View.OnClickListener, OnRecyclerViewListener, IReceiver {
    boolean isFirst;
    Map<String, ContactInfo> map = new HashMap<>();
    private Cursor cursor = null;
    private RecyclerView rvContent = null;
    private MobileContactsAdapter contactsAdapter;
    private BaseDialogFragment dialog = BaseDialogFragment.newInstance(DIALOG_BACK_DISMISS);
    private List<ContactsItem<MobileUserInfo>> contactsList = new ArrayList<>();
    private UserInfo info;
    private Map<String, List<MobileUserInfo>> mapUserInfosList = null;
    private EditText etSearch;
    private LinearLayout llContent, llEmpty, llNoPermission;
    private TextView btnPermission, tvSearchEmpty;
    private Call<Map<String, MobileUserInfo>> repos = null;

    private MessageType[] msgTypeArray = {
            MessageType.ADD_FRIEND,
            MessageType.GET_FRIEND_CONFIRMATION,
            MessageType.LOCAL_LOAD_FRIEND_END,
            MessageType.DELETE_FRIEND
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);
        setContentView(R.layout.activity_mobile_contacts);
        info = DBHelper.getInstance().queryMyInfo();
        isFirst = true;
        initView();
        initDBData();
    }

    private void initView() {
        TopView topView = (TopView) findViewById(R.id.topview);
        topView.setTitle("通讯录朋友");
        topView.getLeftView().setOnClickListener(this);
        tvSearchEmpty = (TextView) findViewById(R.id.tv_search_empty);
        llContent = (LinearLayout) findViewById(R.id.ll_content);
        llNoPermission = (LinearLayout) findViewById(R.id.ll_no_permission);
        llEmpty = (LinearLayout) findViewById(R.id.ll_empty);
        btnPermission = (TextView) findViewById(R.id.btn_permission);

        etSearch = (EditText) findViewById(R.id.et_mob_contacts_search);
        rvContent = (RecyclerView) findViewById(R.id.rv_activity_friends);
        rvContent.setLayoutManager(new LayoutManager(mContext));
        contactsAdapter = new MobileContactsAdapter(mContext);
        rvContent.setAdapter(contactsAdapter);
        rvContent.addItemDecoration(new DividerItemDecoration(mContext, LinearLayoutManager.HORIZONTAL));
        contactsAdapter.setOnRecyclerViewListener(this);
        btnPermission.setOnClickListener(this);
        etSearch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                etSearch.setCursorVisible(true);
            }
        });
        etSearch.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                String search = etSearch.getText().toString();
                List<MobileUserInfo> mobileUserInfoList = DBHelper.getInstance().searchMobileUserInfo(search);
                if (mobileUserInfoList != null && !TextUtils.isEmpty(search)) {
                    if (mobileUserInfoList.size() > 0) {
                        contactsList = usersToContacts(mobileUserInfoList, false);
                        contactsAdapter.setData(contactsList);
                        tvSearchEmpty.setVisibility(View.GONE);
                        rvContent.setVisibility(View.VISIBLE);
                    } else {
                        tvSearchEmpty.setVisibility(View.VISIBLE);
                        rvContent.setVisibility(View.GONE);
                    }
                } else {
                    initDBData();
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    private void initDBData() {
        if (PermissionUtils.isAllowed(this, PermissionUtils.OP_READ_CONTACTS)) {
            contactsList = usersToContacts(DBHelper.getInstance().loadAllMobileUserInfo(), false);
            contactsAdapter.setData(contactsList);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (isFirst) {
            isFirst = false;
            new Thread(new Runnable() {
                @Override
                public void run() {
                    initData();
                }
            }).start();
        }
    }

    private void initData() {
        //利用获取通讯录信息来进行申请权限
        cursor = getContentResolver().query(Phone.CONTENT_URI, null, Phone.NUMBER + " NOT NULL", null, null);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            if (PermissionUtils.isAllowed(this, PermissionUtils.OP_READ_CONTACTS)) {
                getContactsInfo();
            } else {
                isFirst = true;
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        llNoPermission.setVisibility(View.VISIBLE);
                        llContent.setVisibility(View.GONE);
                        llEmpty.setVisibility(View.GONE);
                    }
                });
            }
        } else {
            getContactsInfo();
        }
    }

    private void getContactsInfo() {
        map.clear();
        if (contactsList == null || contactsList.size() == 0) {
            dialog.addProgress();
            dialog.show(getSupportFragmentManager(), "loadingContacts");
        }
        getContactsList();
    }

    /**
     * 获取通讯录
     */
    private void getContactsList() {
        if (cursor != null && cursor.getCount() > 0) {
            while (cursor.moveToNext()) {
                ContactInfo info = new ContactInfo();
                info.setPhone(cursor.getString(cursor.getColumnIndex(Phone.NUMBER)));
                info.setName(cursor.getString(cursor.getColumnIndex(Phone.DISPLAY_NAME)));
                Cursor email = getContentResolver().query(Email.CONTENT_URI, null, Phone.NUMBER + "='" + info.getPhone() + "'", null, null);
                if (email != null && email.getCount() > 0) {
                    while (email.moveToNext()) {
                        info.setEmail(email.getString(email.getColumnIndex(Email.DATA)));
                    }
                }
                map.put(info.getPhone(), info);
            }
            getMobContacts();
        } else {
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    dialog.dismissAllowingStateLoss();
                    llNoPermission.setVisibility(View.GONE);
                    llContent.setVisibility(View.GONE);
                    llEmpty.setVisibility(View.VISIBLE);
                }
            });
        }
    }

    /**
     * 根据通讯录获取联系人列表
     */
    private void getMobContacts() {
        Map<String, Map<String, ContactInfo>> contentMap = new HashMap<>();
        contentMap.put("content", map);
        repos = service.Contacts(contentMap);
        repos.enqueue(new BaseCallBack<Map<String, MobileUserInfo>>() {
            @Override
            protected void onSuccess(Map<String, MobileUserInfo> body) {
                if (contactsList != null && contactsList.size() > 0) {
                    usersToContacts(body);
                } else {
                    contactsList = usersToContacts(body);
                    //然后弹出dialog
                    if (contactsList.size() > 0) {
                        contactsAdapter.setData(contactsList);
                        llContent.setVisibility(View.VISIBLE);
                        llEmpty.setVisibility(View.GONE);
                    } else {
                        llContent.setVisibility(View.GONE);
                        llEmpty.setVisibility(View.VISIBLE);
                    }
                    llNoPermission.setVisibility(View.GONE);
                }
            }

            @Override
            protected void onFinish() {
                if (dialog.isVisible())
                    dialog.dismissAllowingStateLoss();
            }
        });
    }

    private List<ContactsItem<MobileUserInfo>> usersToContacts(Map<String, MobileUserInfo> mobInfosMap) {
        List<MobileUserInfo> userInfos = new ArrayList<>(mobInfosMap.values());
        return usersToContacts(userInfos, true);
    }

    private List<ContactsItem<MobileUserInfo>> usersToContacts(List<MobileUserInfo> userInfos, boolean isSave) {
        //转换后的item集合
        List<ContactsItem<MobileUserInfo>> contactsItemList = new ArrayList<>();

        initLetters();
        for (MobileUserInfo userInfo : userInfos) {
            if (!userInfo.getPhone().equals(info.getPhone())) {
                userInfo.setUserId(userInfo.getId());

                if (TextUtils.isEmpty(userInfo.getNamePinYin()) || isSave) {
                    userInfo.setNamePinYin(Pinyin4jUtil.nameHanziToPinyin(userInfo.getMobName()));
                    DBHelper.getInstance().saveMobileUserInfo(userInfo);
                }

                String userHead = userInfo.getNamePinYin().substring(0, 1);
                if (mapUserInfosList.get(userHead) != null) {
                    mapUserInfosList.get(userHead).add(userInfo);
                } else {
                    mapUserInfosList.get("#").add(userInfo);
                }
            }
        }

        //记录起始点
        int sectionFirstPosition = 0;

        for (Map.Entry<String, List<MobileUserInfo>> entry : mapUserInfosList.entrySet()) {

            if (entry.getValue().size() == 0) {
            } else {
                //记录起始点
                sectionFirstPosition = contactsItemList.size();
                //添加联系人的分类栏
                contactsItemList.add(new ContactsItem<MobileUserInfo>(sectionFirstPosition, entry.getKey()));
            }

            //添加分类栏下面的联系人的信息
            for (MobileUserInfo userInfo : entry.getValue()) {
                contactsItemList.add(new ContactsItem(sectionFirstPosition, userInfo));
            }
        }
        return contactsItemList;
    }

    private void initLetters() {
        //头部字母列表
        mapUserInfosList = new LinkedHashMap<>();
        for (String strHead : LetterSideBar.letters) {
            mapUserInfosList.put(strHead, new ArrayList<MobileUserInfo>());
        }
    }


    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_left:
                Utils.hideInput(v);
                finish();
                break;
            case R.id.btn_permission:
                PackageUtils.getAppDetailSettingIntent(mContext);
                break;
        }
    }

    @Override
    public void onItemClick(int position, View view) {
        ContactsItem<MobileUserInfo> contactsItem = contactsList.get(position);
        switch (view.getId()) {
            case R.id.btn_mob_contacts_check:
                int contactRelations = DBHelper.getInstance().queryContactRelations(contactsItem.info.getUserId());

                if (contactRelations == 1) {
                    Intent intent = new Intent(mContext, PersonalProfileActivity.class);
                    intent.putExtra(IntentKeys.KEY_USER_ID, contactsItem.info.getUserId());
                    intent.putExtra(IntentKeys.KEY_USER_NAME, contactsItem.info.getName());
                    startActivity(intent);
                } else {
                    SendMessageQueue.getInstance().addSendMessage(MessageType.GET_FRIEND_CONFIRMATION,
                            new GetFriendConfirmationRequest(contactsItem.info.getUserId()));
                }

                break;
            default:
                if (contactsItem.itemType == ContactsItem.VIEW_CONTACTS_CONTENT) {
                    Intent intent = new Intent(mContext, PersonalProfileActivity.class);
                    intent.putExtra(IntentKeys.KEY_USER_ID, contactsItem.info.getUserId());
                    intent.putExtra(IntentKeys.KEY_USER_NAME, contactsItem.info.getName());
                    startActivity(intent);
                }
                break;
        }
    }

    @Override
    public boolean onItemLongClick(int position, View view) {
        return false;
    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, final BaseRequest request, Object response) {
        switch (messageType) {
            case LOCAL_LOAD_FRIEND_END:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        for (int i = 0; i < contactsList.size(); i++) {
                            if (contactsList.get(i).info != null && contactsList.get(i).info.getState() != null) {
                                if (DBHelper.getInstance().queryContactRelations(contactsList.get(i).info.getUserId()) == 1)
                                    contactsList.get(i).info.setState(null);
                            }
                        }
                        contactsAdapter.setData(contactsList);
                    }
                });
                break;
            case DELETE_FRIEND:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        DeleteFriendRequest addFriendRequest = (DeleteFriendRequest) request;
                        for (int i = 0; i < contactsList.size(); i++) {
                            if (contactsList.get(i).info != null && contactsList.get(i).info.getUserId() == addFriendRequest.getFriendUserId()) {
                                contactsList.get(i).info.setState(null);
                            }
                        }
                        contactsAdapter.setData(contactsList);
                    }
                });
                break;
            case ADD_FRIEND:
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        AddFriendRequest addFriendRequest = (AddFriendRequest) request;
                        for (int i = 0; i < contactsList.size(); i++) {
                            if (contactsList.get(i).info != null && contactsList.get(i).info.getUserId() == addFriendRequest.getFriendUserId()) {
                                contactsList.get(i).info.setState(true);
                            }
                        }
                        contactsAdapter.setData(contactsList);
                    }
                });
                break;
            case GET_FRIEND_CONFIRMATION:

                GetFriendConfirmationRequest gfcRequest = (GetFriendConfirmationRequest) request;
                GetFriendConfirmationResponse gfcResponse = (GetFriendConfirmationResponse) response;
                String name = DBHelper.getInstance().queryMyInfo().getName();
                String verificationStr = "我是" + name;
                if (gfcResponse.isStatus()) {
                    Intent intent = new Intent(this, FriendVerificationActivity.class);
                    intent.putExtra(IntentKeys.KEY_USER_ID, gfcRequest.getFriendUserId());
                    intent.putExtra(IntentKeys.KEY_VERIFICATION_MSG, verificationStr);
                    intent.putExtra(IntentKeys.KEY_USER_NAME, name);
                    startActivity(intent);
                } else {
                    SendMessageQueue.getInstance().addSendMessage(MessageType.ADD_FRIEND,
                            new AddFriendRequest(gfcRequest.getFriendUserId(), verificationStr));
                }
                break;
        }
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {

    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (repos != null)
            repos.cancel();

        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
    }
}
