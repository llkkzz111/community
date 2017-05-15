package com.choudao.equity;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.RemoteException;
import android.support.v4.app.FragmentTransaction;
import android.view.KeyEvent;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.alibaba.fastjson.JSON;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.base.BaseApplication;
import com.choudao.equity.base.BaseFragment;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.entity.UpdateEntity;
import com.choudao.equity.fragment.ContactsFragment;
import com.choudao.equity.fragment.ErrorFragment;
import com.choudao.equity.fragment.FoundFragment;
import com.choudao.equity.fragment.HomeFragment;
import com.choudao.equity.fragment.MeFragment;
import com.choudao.equity.fragment.SessionsFragment;
import com.choudao.equity.service.IMServiceConnector;
import com.choudao.equity.service.IMServiceConnectorAIDL;
import com.choudao.equity.utils.ActivityStack;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.PreferencesUtils;
import com.choudao.equity.utils.VersionUpdate;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.dto.MessageDTO;
import com.choudao.imsdk.dto.action.MsgAction;
import com.choudao.imsdk.dto.constants.ActionType;
import com.choudao.imsdk.dto.constants.MessageType;
import com.choudao.imsdk.dto.constants.ResponseCode;
import com.choudao.imsdk.dto.constants.SessionType;
import com.choudao.imsdk.dto.request.BaseRequest;
import com.choudao.imsdk.dto.response.BaseResponse;
import com.choudao.imsdk.imutils.IMMessageDispatcher;
import com.choudao.imsdk.imutils.callback.IReceiver;
import com.choudao.imsdk.utils.Logger;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import cn.jpush.android.api.JPushInterface;
import retrofit2.Call;


/**
 * Created by Han on 2016/3/4.
 */

public class MainActivity extends BaseActivity implements View.OnClickListener, IReceiver {
    private static final String TAG = "===MainActivity===";
    private final int UPDATE_NOREAD_MSG = 1;
    private final int SHOW_KO_DIALOG = 2;
    private final int TO_GROUP_ACTIVITY = 3;
    private LinearLayout tabHome;
    private LinearLayout tabCommunity;
    private LinearLayout tabMe;
    private LinearLayout tabMessage;
    private LinearLayout tabMotion;
    private TextView tvMsgCount, tvNewFriendCount;
    private Map<Integer, ItemTab> map = new HashMap<>();
    private BaseFragment mCurrent;
    private FragmentTransaction fragmentTransaction = null;
    private Intent intent = null;
    private boolean socketLogin = false;
@Inject BaseApplication application;
    private IMServiceConnectorAIDL connectorAIDL;
    private BaseDialogFragment dialog = null;
    private Handler handler = new Handler() {

        public void handleMessage(Message msg) {
            switch (msg.what) {
                case UPDATE_NOREAD_MSG:
                    updateNoReadMsg();
                    break;
                case SHOW_KO_DIALOG:
                    showKODialog();
                    break;
                case TO_GROUP_ACTIVITY:
                    long groupId = (long) msg.obj;
                    Intent intent = new Intent(mContext, GroupMessageActivity.class);
                    intent.putExtra(IntentKeys.KEY_TARGET_ID, groupId);
                    startActivity(intent);
                    break;
            }
        }
    };
    private IMServiceConnector imServiceConnector = new IMServiceConnector() {

        @Override
        public void onIMServiceConnected(IMServiceConnectorAIDL imServiceConnectorAIDL) {
            if (ConstantUtils.isLogin) {

                Logger.i(TAG, "loginIMServer is start");
                int userId = PreferencesUtils.getUserId();
                ConstantUtils.USER_ID = userId;
                connectorAIDL = imServiceConnectorAIDL;

                if (connectorAIDL != null) {
                    try {
                        connectorAIDL.loginIMServer(userId);
                    } catch (RemoteException e) {
                        Logger.e(TAG, "loginIMServer -> " + e.getMessage());
                    }
                }

                Logger.i(TAG, "loginIMServer -> userId:" + ConstantUtils.USER_ID);
            } else {
                Logger.e(TAG, "loginIMServer -> isLogin: false");
                Message msg1 = handler.obtainMessage();
                msg1.what = SHOW_KO_DIALOG;
                handler.sendMessage(msg1);
            }
        }

        @Override
        public void onIMServiceDisconnected() {

        }
    };

    private MessageType[] msgTypeArray = {
            MessageType.PUSH_MESSAGE,
            MessageType.CREATE_GROUP,
            MessageType.ADD_GROUP_MEMBER,
            MessageType.REMOVE_GROUP_MEMBER,
            MessageType.PULL_MESSAGE,
            MessageType.KICK_OUT,
            MessageType.LOGIN,
            MessageType.LOCAL_LOAD_FRIEND_END,
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        IMMessageDispatcher.bindMessageTypeArray(msgTypeArray, this);
        setContentView(R.layout.activity_main);
        imServiceConnector.bindService(this);
        ((BaseApplication)getApplication()).getApplicationComponent().getContext();
        JPushInterface.clearAllNotifications(mContext);

        tvMsgCount = (TextView) findViewById(R.id.tv_activity_main_msgcount);
        tvNewFriendCount = (TextView) findViewById(R.id.tv_activity_main_newfriend_count);
        initTab();
        intent = getIntent();
        checkJpush();
        checkUpdate();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        this.intent = intent;
        checkJpush();
    }

    private void checkJpush() {
        if (intent.hasExtra(IntentKeys.KEY_JPUSH_PUSH)) {
            if (intent.getStringExtra(IntentKeys.KEY_ACTION) != null) {
                startNewActivity(intent.getStringExtra(IntentKeys.KEY_ACTION), intent.getIntExtra(IntentKeys.KEY_ACTION_TYPE, -1));
            } else {
                startNewActivity(intent.getStringExtra(IntentKeys.KEY_URL));
            }
        }
        checkTab(intent);
        if (!ConstantUtils.isLogin) {
            finish();
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (BaseApplication.userId != -1) {
            updateNoReadMsg();
        }
    }

    private void initTab() {

        map.put(R.id.tab_home, new ItemTab(R.id.tab_home, HomeFragment.class));
        map.put(R.id.tab_session, new ItemTab(R.id.tab_session, SessionsFragment.class));
        map.put(R.id.tab_contacts, new ItemTab(R.id.tab_contacts, ContactsFragment.class));
        map.put(R.id.tab_motion, new ItemTab(R.id.tab_motion, FoundFragment.class));
        map.put(R.id.tab_me, new ItemTab(R.id.tab_me, MeFragment.class));

        tabHome = map.get(R.id.tab_home).tabLayout;
        tabMe = map.get(R.id.tab_me).tabLayout;
        tabMessage = map.get(R.id.tab_contacts).tabLayout;
        tabMotion = map.get(R.id.tab_motion).tabLayout;
        tabCommunity = map.get(R.id.tab_session).tabLayout;
        tabHome.performClick();
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
    }

    private void checkUpdate() {
        Call<UpdateEntity> updateCall = service.updateVersion(BuildConfig.VERSION_NAME);
        updateCall.enqueue(new BaseCallBack<UpdateEntity>() {
            @Override
            protected void onSuccess(UpdateEntity body) {
                showUpdateDialog(body);
            }
        });
    }

    /**
     * 显示更新dialog
     *
     * @param updateEntity
     */
    private void showUpdateDialog(UpdateEntity updateEntity) {
        new VersionUpdate(this, updateEntity).invoke();
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        switch (keyCode) {
            case KeyEvent.KEYCODE_BACK:
                if (!tabHome.isSelected()) {
                    tabHome.performClick();
                    return true;
                } else {
                    finish();
                    return false;
                }
            default:
                break;
        }
        return super.onKeyDown(keyCode, event);
    }

    /**
     * 返回到桌面
     */
    private void goBackHome() {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }

    private BaseFragment clickTab(View v) {
        ItemTab tab = map.get(v.getId());
        chengeSelectState(tab.tabLayout);
        if (tab.fragment != null) {
            fragmentTransaction.show(tab.fragment);
        } else {
            tab.fragment = tab.newFragment();
            fragmentTransaction.add(R.id.main_layout, tab.fragment);
        }
        return tab.fragment;
    }

    @Override
    public void onClick(View v) {
        fragmentTransaction = getSupportFragmentManager().beginTransaction();
        if (mCurrent != null) {
            fragmentTransaction.hide(mCurrent);
        }
        mCurrent = clickTab(v);
        if (mCurrent != null) {
            fragmentTransaction.addToBackStack(null);
            if (!getSupportFragmentManager().isDestroyed()) {
                fragmentTransaction.commitAllowingStateLoss();
            }
        }
    }

    /**
     * 修改layout选中状态
     *
     * @param v 选中的layout
     */
    private void chengeSelectState(View v) {
        if (!v.isSelected()) {
            Checked(v.getId());
        }
    }

    /**
     * 打开新的Activity
     *
     * @param url 选中不同的按钮所对应的地址
     */
    private void startNewActivity(String url) {
        Intent intent = new Intent(MainActivity.this, WebViewActivity.class);
        intent.putExtra(IntentKeys.KEY_URL, url);
        startActivity(intent);
    }

    private void startNewActivity(String action, int actionType) {
        Intent intent;
        switch (ActionType.of(actionType)) {
            case MSG:
                MsgAction msgAction = JSON.parseObject(action, MsgAction.class);
                switch (SessionType.of(msgAction.getSessionType())) {
                    case PRIVATE_CHAT:
                        intent = new Intent(this, PrivateMessageActivity.class);
                        intent.putExtra(IntentKeys.KEY_TARGET_ID, msgAction.getTargetId());
                        startActivity(intent);
                        break;
                    case GROUP_CHAT:
                        intent = new Intent(this, GroupMessageActivity.class);
                        intent.putExtra(IntentKeys.KEY_TARGET_ID, msgAction.getTargetId());
                        startActivity(intent);
                        break;
                }
                break;
        }

    }

    /**
     * 切换Layout选中状态
     *
     * @param id 选中的layout的id
     */
    private void Checked(int id) {
        for (Map.Entry<Integer, ItemTab> entry : map.entrySet()) {
            LinearLayout layout = entry.getValue().tabLayout;
            if (layout.isSelected()) {
                layout.setSelected(false);
            }
            if (layout.getId() == id) {
                layout.setSelected(true);
            }
        }
    }

    public void showKODialog() {
        if (dialog == null || !dialog.isShow()) {
            ConstantUtils.isLogin = false;
            dialog = BaseDialogFragment.newInstance(BaseDialogFragment.DIALOG_UNDISMISS);
            dialog.addContent(getString(R.string.kick_out_info)).
                    addButton(2, getString(R.string.text_confirm), new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            finish();
                            PreferencesUtils.setUserId(-1);
                            if (intent == null)
                                intent = new Intent();
                            intent.setClass(mContext, LoginActivity.class);
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                            intent.putExtra(IntentKeys.KEY_URL, ConstantUtils.URL_ME);
                            intent.putExtra(IntentKeys.KEY_FROM_LOADING, true);
                            startActivity(intent);
                        }
                    });
//                show(getSupportFragmentManager(), "logout");
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            transaction.add(dialog, "login");
            transaction.commitAllowingStateLoss();

        }
    }

    public void updateNoReadMsg() {

        if (tvMsgCount != null) {

            long noReadMsgNumber = DBHelper.getInstance().getNoReadSessionNumber();
            if (noReadMsgNumber > 0) {
                tvMsgCount.setVisibility(View.VISIBLE);
                if (noReadMsgNumber > ConstantUtils.MAX_SHOW_MSG) {
                    tvMsgCount.setText(getString(R.string.more_msg_count));
                } else {
                    tvMsgCount.setText(String.valueOf(noReadMsgNumber));
                }
            } else {
                tvMsgCount.setVisibility(View.GONE);
            }

            long newFriendNumber = DBHelper.getInstance().getNewFriendNumber();
            if (newFriendNumber > 0) {
                tvNewFriendCount.setVisibility(View.VISIBLE);
                if (newFriendNumber > ConstantUtils.MAX_SHOW_MSG) {
                    tvNewFriendCount.setText(getString(R.string.more_msg_count));
                } else {
                    tvNewFriendCount.setText(String.valueOf(newFriendNumber));
                }
            } else {
                tvNewFriendCount.setVisibility(View.GONE);
            }

        }

    }

    @Override
    public void receiverMessageSuccess(MessageType messageType, BaseRequest request, Object response) {
        Message msg;
        long groupId;
        switch (messageType) {
            case PUSH_MESSAGE:
                com.choudao.imsdk.db.bean.Message message = (com.choudao.imsdk.db.bean.Message) response;
                if (!(message.getSessionType() == SessionType.PRIVATE_CHAT.code ||
                        message.getSessionType() == SessionType.GROUP_CHAT.code || message.getSessionType() == SessionType.FRIEND_REQUEST.code)) {//如果不是展示消息就不刷新
                    return;
                }
            case PULL_MESSAGE:
            case LOCAL_LOAD_FRIEND_END:
                msg = handler.obtainMessage();
                msg.what = UPDATE_NOREAD_MSG;
                handler.sendMessage(msg);
                break;
            case KICK_OUT:
                msg = handler.obtainMessage();
                msg.what = SHOW_KO_DIALOG;
                handler.sendMessage(msg);
                socketLogin = false;
                break;
            case LOGIN:
                socketLogin = true;
                JPushInterface.setAlias(mContext, ConstantUtils.getEnvironmentType(mContext) + ConstantUtils.USER_ID, null);
                break;
            case CREATE_GROUP:
            case ADD_GROUP_MEMBER:
            case REMOVE_GROUP_MEMBER:
                msg = handler.obtainMessage();
                msg.what = TO_GROUP_ACTIVITY;
                msg.obj = response;
                handler.sendMessage(msg);
                break;
        }
    }

    @Override
    public void receiverMessageFail(MessageType messageType, BaseRequest request, MessageDTO response) {
        switch (messageType) {
            case LOGIN:
                BaseResponse baseResponse = JSON.parseObject(response.getBody(), BaseResponse.class);
                if (baseResponse.getCode() != null && baseResponse.getCode().equals(ResponseCode.LOGIN_FAIL)) {
                    Message msg1 = handler.obtainMessage();
                    msg1.what = SHOW_KO_DIALOG;
                    handler.sendMessage(msg1);
                }
                break;
        }
    }

    @Override
    public void receiverMessageTimeout(MessageType messageType, BaseRequest request) {

    }

    @Override
    protected void onDestroy() {
        IMMessageDispatcher.unbindMessageTypeArray(msgTypeArray, this);
        if (connectorAIDL != null) {
            try {
                connectorAIDL.logoutIMServer();
            } catch (RemoteException e) {
                Logger.e(TAG, "logoutIMServer -> " + e.getMessage());
            }
        }
        imServiceConnector.unbindService(this);
        DBHelper.getInstance().close();
        super.onDestroy();
    }

    private void checkTab(Intent intent) {
        if (intent.getData() != null) {
            Uri androidUri = intent.getData();
            String id = androidUri.getQueryParameter("id");

            switch (androidUri.getScheme()) {
                case ConstantUtils.SCHEME_CHOUDAO:
                    switch (androidUri.getHost()) {
                        case ConstantUtils.CHOUDAO_QUESTION:
                            intent.setClass(mContext, QuestionDetailsActivity.class);
                            intent.putExtra(IntentKeys.KEY_QUESTION_ID, Integer.valueOf(id));
                            startActivity(intent);
                            break;
                        case ConstantUtils.CHOUDAO_ANSWER:
                            intent.setClass(mContext, SingleAnswerActivity.class);
                            intent.putExtra(IntentKeys.KEY_ANSWER_ID, Integer.valueOf(id));
                            intent.putExtra(IntentKeys.KEY_QUESTION_ID, Integer.valueOf(androidUri.getQueryParameter("question_id")));
                            startActivity(intent);
                            break;
                        case ConstantUtils.CHOUDAO_USER:
                            intent.setClass(mContext, PersonalProfileActivity.class);
                            intent.putExtra(IntentKeys.KEY_USER_ID, Integer.valueOf(id));
                            startActivity(intent);
                            break;
                        case ConstantUtils.CHOUDAO_PAGE:
                            switch (id) {
                                case ConstantUtils.PAGE_COMMUNITY:
                                    intent = new Intent(mContext, CommunityActivity.class);
                                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                    startActivity(intent);
                                    return;
                                case ConstantUtils.PAGE_HOME:
                                    tabHome.performClick();
                                    break;
                                case ConstantUtils.PAGE_ME:
                                    tabMe.performClick();
                                    break;
                                case ConstantUtils.PAGE_MESSAGE:
                                    tabMessage.performClick();
                                    break;
                                case ConstantUtils.PAGE_MOTION:
                                    tabMotion.performClick();
                                    break;
                                case ConstantUtils.PAGE_SESSION:
                                    tabCommunity.performClick();
                                    break;
                            }
                            break;
                    }
                    break;
                case ConstantUtils.SCHEME_HTTP:
                case ConstantUtils.SCHEME_HTTPS:
                    intent.setClass(mContext, WebViewActivity.class);
                    intent.putExtra(IntentKeys.KEY_URL, intent.getDataString());
                    startActivity(intent);
                    break;
            }
            ActivityStack.getInstance().popAllActivityUntilCls(MainActivity.class);
        }
    }

    class ItemTab {
        int resId;
        Class<? extends BaseFragment> fragmentClz;
        LinearLayout tabLayout;
        BaseFragment fragment;

        ItemTab(int resId, Class<? extends BaseFragment> fragmentClz) {
            this.resId = resId;
            this.fragmentClz = fragmentClz;
            this.tabLayout = (LinearLayout) findViewById(resId);
            this.tabLayout.setOnClickListener(MainActivity.this);
        }

        public BaseFragment newFragment() {
            try {
                return fragmentClz.newInstance();
            } catch (InstantiationException e) {
                e.printStackTrace();
                return new ErrorFragment();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
                return new ErrorFragment();
            }
        }
    }
}
