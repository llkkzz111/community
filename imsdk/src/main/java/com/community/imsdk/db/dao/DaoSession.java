package com.community.imsdk.db.dao;

import android.database.sqlite.SQLiteDatabase;

import java.util.Map;

import de.greenrobot.dao.AbstractDao;
import de.greenrobot.dao.AbstractDaoSession;
import de.greenrobot.dao.identityscope.IdentityScopeType;
import de.greenrobot.dao.internal.DaoConfig;

import com.community.imsdk.db.bean.Message;
import com.community.imsdk.db.bean.SessionInfo;
import com.community.imsdk.db.bean.SessionConfig;
import com.community.imsdk.db.bean.Contact;
import com.community.imsdk.db.bean.UserInfo;
import com.community.imsdk.db.bean.MobileUserInfo;
import com.community.imsdk.db.bean.GroupInfo;
import com.community.imsdk.db.bean.GroupMember;
import com.community.imsdk.db.bean.JsonEntity;

import com.community.imsdk.db.dao.MessageDao;
import com.community.imsdk.db.dao.SessionInfoDao;
import com.community.imsdk.db.dao.SessionConfigDao;
import com.community.imsdk.db.dao.ContactDao;
import com.community.imsdk.db.dao.UserInfoDao;
import com.community.imsdk.db.dao.MobileUserInfoDao;
import com.community.imsdk.db.dao.GroupInfoDao;
import com.community.imsdk.db.dao.GroupMemberDao;
import com.community.imsdk.db.dao.JsonEntityDao;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.

/**
 * {@inheritDoc}
 * 
 * @see de.greenrobot.dao.AbstractDaoSession
 */
public class DaoSession extends AbstractDaoSession {

    private final DaoConfig messageDaoConfig;
    private final DaoConfig sessionInfoDaoConfig;
    private final DaoConfig sessionConfigDaoConfig;
    private final DaoConfig contactDaoConfig;
    private final DaoConfig userInfoDaoConfig;
    private final DaoConfig mobileUserInfoDaoConfig;
    private final DaoConfig groupInfoDaoConfig;
    private final DaoConfig groupMemberDaoConfig;
    private final DaoConfig jsonEntityDaoConfig;

    private final MessageDao messageDao;
    private final SessionInfoDao sessionInfoDao;
    private final SessionConfigDao sessionConfigDao;
    private final ContactDao contactDao;
    private final UserInfoDao userInfoDao;
    private final MobileUserInfoDao mobileUserInfoDao;
    private final GroupInfoDao groupInfoDao;
    private final GroupMemberDao groupMemberDao;
    private final JsonEntityDao jsonEntityDao;

    public DaoSession(SQLiteDatabase db, IdentityScopeType type, Map<Class<? extends AbstractDao<?, ?>>, DaoConfig>
            daoConfigMap) {
        super(db);

        messageDaoConfig = daoConfigMap.get(MessageDao.class).clone();
        messageDaoConfig.initIdentityScope(type);

        sessionInfoDaoConfig = daoConfigMap.get(SessionInfoDao.class).clone();
        sessionInfoDaoConfig.initIdentityScope(type);

        sessionConfigDaoConfig = daoConfigMap.get(SessionConfigDao.class).clone();
        sessionConfigDaoConfig.initIdentityScope(type);

        contactDaoConfig = daoConfigMap.get(ContactDao.class).clone();
        contactDaoConfig.initIdentityScope(type);

        userInfoDaoConfig = daoConfigMap.get(UserInfoDao.class).clone();
        userInfoDaoConfig.initIdentityScope(type);

        mobileUserInfoDaoConfig = daoConfigMap.get(MobileUserInfoDao.class).clone();
        mobileUserInfoDaoConfig.initIdentityScope(type);

        groupInfoDaoConfig = daoConfigMap.get(GroupInfoDao.class).clone();
        groupInfoDaoConfig.initIdentityScope(type);

        groupMemberDaoConfig = daoConfigMap.get(GroupMemberDao.class).clone();
        groupMemberDaoConfig.initIdentityScope(type);

        jsonEntityDaoConfig = daoConfigMap.get(JsonEntityDao.class).clone();
        jsonEntityDaoConfig.initIdentityScope(type);

        messageDao = new MessageDao(messageDaoConfig, this);
        sessionInfoDao = new SessionInfoDao(sessionInfoDaoConfig, this);
        sessionConfigDao = new SessionConfigDao(sessionConfigDaoConfig, this);
        contactDao = new ContactDao(contactDaoConfig, this);
        userInfoDao = new UserInfoDao(userInfoDaoConfig, this);
        mobileUserInfoDao = new MobileUserInfoDao(mobileUserInfoDaoConfig, this);
        groupInfoDao = new GroupInfoDao(groupInfoDaoConfig, this);
        groupMemberDao = new GroupMemberDao(groupMemberDaoConfig, this);
        jsonEntityDao = new JsonEntityDao(jsonEntityDaoConfig, this);

        registerDao(Message.class, messageDao);
        registerDao(SessionInfo.class, sessionInfoDao);
        registerDao(SessionConfig.class, sessionConfigDao);
        registerDao(Contact.class, contactDao);
        registerDao(UserInfo.class, userInfoDao);
        registerDao(MobileUserInfo.class, mobileUserInfoDao);
        registerDao(GroupInfo.class, groupInfoDao);
        registerDao(GroupMember.class, groupMemberDao);
        registerDao(JsonEntity.class, jsonEntityDao);
    }
    
    public void clear() {
        messageDaoConfig.getIdentityScope().clear();
        sessionInfoDaoConfig.getIdentityScope().clear();
        sessionConfigDaoConfig.getIdentityScope().clear();
        contactDaoConfig.getIdentityScope().clear();
        userInfoDaoConfig.getIdentityScope().clear();
        mobileUserInfoDaoConfig.getIdentityScope().clear();
        groupInfoDaoConfig.getIdentityScope().clear();
        groupMemberDaoConfig.getIdentityScope().clear();
        jsonEntityDaoConfig.getIdentityScope().clear();
    }

    public MessageDao getMessageDao() {
        return messageDao;
    }

    public SessionInfoDao getSessionInfoDao() {
        return sessionInfoDao;
    }

    public SessionConfigDao getSessionConfigDao() {
        return sessionConfigDao;
    }

    public ContactDao getContactDao() {
        return contactDao;
    }

    public UserInfoDao getUserInfoDao() {
        return userInfoDao;
    }

    public MobileUserInfoDao getMobileUserInfoDao() {
        return mobileUserInfoDao;
    }

    public GroupInfoDao getGroupInfoDao() {
        return groupInfoDao;
    }

    public GroupMemberDao getGroupMemberDao() {
        return groupMemberDao;
    }

    public JsonEntityDao getJsonEntityDao() {
        return jsonEntityDao;
    }

}
