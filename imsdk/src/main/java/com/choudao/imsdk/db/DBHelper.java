package com.choudao.imsdk.db;

import android.content.ContentValues;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteStatement;
import android.text.TextUtils;

import com.choudao.imsdk.IMApplication;
import com.choudao.imsdk.db.bean.Contact;
import com.choudao.imsdk.db.bean.GroupInfo;
import com.choudao.imsdk.db.bean.GroupMember;
import com.choudao.imsdk.db.bean.JsonEntity;
import com.choudao.imsdk.db.bean.Message;
import com.choudao.imsdk.db.bean.MobileUserInfo;
import com.choudao.imsdk.db.bean.SessionConfig;
import com.choudao.imsdk.db.bean.SessionInfo;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.db.dao.ContactDao;
import com.choudao.imsdk.db.dao.DaoMaster;
import com.choudao.imsdk.db.dao.DaoSession;
import com.choudao.imsdk.db.dao.GroupInfoDao;
import com.choudao.imsdk.db.dao.GroupMemberDao;
import com.choudao.imsdk.db.dao.JsonEntityDao;
import com.choudao.imsdk.db.dao.MessageDao;
import com.choudao.imsdk.db.dao.MobileUserInfoDao;
import com.choudao.imsdk.db.dao.SessionConfigDao;
import com.choudao.imsdk.db.dao.SessionInfoDao;
import com.choudao.imsdk.db.dao.UserInfoDao;
import com.choudao.imsdk.dto.constants.SessionType;
import com.choudao.imsdk.imutils.TransformUtils;
import com.choudao.imsdk.utils.Logger;
import com.choudao.imsdk.utils.SharedPreferencesUtils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import de.greenrobot.dao.query.DeleteQuery;
import de.greenrobot.dao.query.Query;
import de.greenrobot.dao.query.QueryBuilder;

/**
 * Created by dufeng on 16/5/4.<br/>
 * Description: DBHelper
 */
public class DBHelper {
    private static DBHelper instance;
    private final String TAG = "===DBHelper===";
    private DaoMaster.OpenHelper helper;
    private SQLiteDatabase db;
    private final Object lock = new Object();

//    private PrivateMessageDao getMessageDao();
//    private UserInfoDao getUserInfoDao();
//    private SessionInfoDao getSessionInfoDao();
//
//    private JsonEntityDao getJsonEntityDao();

    private long loginUserId = -1;

    private DBHelper() {

    }

    public synchronized static DBHelper getInstance() {
        if (instance == null) {
            //初始化单例对象
            instance = new DBHelper();

            enableQueryBuilderLog(Logger.isDebug);
        }
        return instance;
    }

    /**
     * ===============================手机上的用户信息 END=======================================
     */


    public static void enableQueryBuilderLog(boolean flag) {
        QueryBuilder.LOG_SQL = flag;
        QueryBuilder.LOG_VALUES = flag;
    }

    public void init(long userId) {
        if (loginUserId != userId) {

            loginUserId = userId;
            //初始化daoMaster
            String DB_NAME = "choudaoim_" + userId + ".db";
            helper = new DaoMaster.UpgradeHelper(IMApplication.context, DB_NAME, null);
            db = helper.getReadableDatabase();
        }
    }

    private SQLiteDatabase getSQLiteDatabase() {
        synchronized (lock) {
            if (db == null) {

                if (IMApplication.userId == -1) {
                    init(SharedPreferencesUtils.getUserId());
                } else {
                    init(IMApplication.userId);
                }
                synchronized (lock) {
                    lock.notify();
                }

            }
        }
        return db;
    }

    private DaoSession getDaoSession() {
        DaoMaster daoMaster = new DaoMaster(getSQLiteDatabase());
        return daoMaster.newSession();
    }

    private MessageDao getMessageDao() {
        return getDaoSession().getMessageDao();
    }

    private UserInfoDao getUserInfoDao() {
        return getDaoSession().getUserInfoDao();
    }

    private GroupMemberDao getGroupMemberDao() {
        return getDaoSession().getGroupMemberDao();
    }


    private GroupInfoDao getGroupInfoDao() {
        return getDaoSession().getGroupInfoDao();
    }

    private MobileUserInfoDao getMobileUserInfoDao() {
        return getDaoSession().getMobileUserInfoDao();
    }

    private ContactDao getContactDao() {
        return getDaoSession().getContactDao();
    }

    private SessionInfoDao getSessionInfoDao() {
        return getDaoSession().getSessionInfoDao();
    }

    private SessionConfigDao getSessionConfigDao() {
        return getDaoSession().getSessionConfigDao();
    }

    private JsonEntityDao getJsonEntityDao() {
        return getDaoSession().getJsonEntityDao();
    }

    public void close() {
        if (helper != null) {
            helper.close();
            helper = null;
            loginUserId = -1;
        }
    }


    /**===============================消息 START=======================================*/
    /**
     * 插入一个talk，如果有替换掉
     *
     * @param message
     * @return
     */
    public long saveMessage(Message message) {
        Logger.i(TAG, " -> saveMessage:" + message.getChatId() + "-" + message.getSessionType() + "-" + message.getMsgId());
        return getMessageDao().insertOrReplace(message);
    }

    /**
     * 存储消息及其相关的session
     *
     * @param message
     * @param sessionInfo
     */
    public void saveMessage(Message message, SessionInfo sessionInfo) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            long row1 = saveMessage(message);
            long row2 = saveSession(sessionInfo);
            if (row1 == -1 || row2 == -1) {
                throw new SQLiteException("saveMessage err");
            }
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    /**
     * 存储消息集合及其相关的session
     * 这里的session不需要count，count由消息插入条数决定
     *
     * @param messageList
     * @param recordSessionInfo
     */
    public void saveMessageList(List<Message> messageList, SessionInfo recordSessionInfo) {
        if (messageList.size() <= 0) {
            return;
        }
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            int msgCount = saveMessageList(messageList);
            recordSessionInfo.setCount(msgCount);
            saveSession(recordSessionInfo);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    public int saveMessageList(Collection<Message> messageList) {
        int msgCount = 0;
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            for (Message message : messageList) {
                try {
                    long rowId = getMessageDao().insert(message);
                    if (rowId != -1) {
                        msgCount++;
                    }
                } catch (SQLiteException e) {
                    Logger.i(TAG, "saveMessageList - insert fail : " + e.getMessage());
                }
            }
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
        return msgCount;
    }

    public void clearChat(long chatId, int sessionType) {
        DeleteQuery<Message> bd = getMessageDao().queryBuilder()
                .where(MessageDao.Properties.ChatId.eq(chatId),
                        MessageDao.Properties.ShowSessionType.eq(sessionType))
                .buildDelete();

        bd.executeDeleteWithoutDetachingEntities();
    }

    /**
     * 查询满足params条件的列表
     * ex: begin_date_time >= ? AND end_date_time <= ?
     *
     * @param where  sql语句
     * @param params 条件
     * @return
     */
    public List<Message> queryPrivateMsgList(String where, String... params) {
        return getMessageDao().queryRaw(where, params);
    }

    public void deleteUniquePrivateMsg(long userId, int sessionType, long msgId) {
        DeleteQuery<Message> bd = getMessageDao().queryBuilder()
                .where(MessageDao.Properties.ChatId.eq(userId),
                        MessageDao.Properties.MsgId.eq(msgId),
                        MessageDao.Properties.SessionType.eq(sessionType)).buildDelete();
        bd.executeDeleteWithoutDetachingEntities();
    }

    /**
     * 查询与指定的消息
     *
     * @param userId
     * @param msgId
     * @return
     */
    public Message queryUniquePrivateMsg(long userId, int sessionType, long msgId) {
        return getMessageDao().queryBuilder().where(MessageDao.Properties.ChatId.eq(userId),
                MessageDao.Properties.SessionType.eq(sessionType),
                MessageDao.Properties.MsgId.eq(msgId)).unique();
    }

    /**
     * 查询与指定用户的对话列表
     *
     * @param userId 用户id
     * @param index  起始位置
     * @param count  条数
     * @return
     */
    public List<Message> loadMoreMessage(long userId, int sessionType, int index, int count) {
//        Object[] sessionTypeArray = new Object[]{sessionType};
//        if(sessionType == SessionType.GROUP_CHAT.code){
//            sessionTypeArray = new Object[]{SessionType.GROUP_CHAT.code,
//                    SessionType.GROUP_MEMBER_CHANGE_LOG.code,
//                    SessionType.GROUP_INFO_CHANGE_LOG.code,
//                    SessionType.PERSONAL_GROUP_NOTICE.code};
//        }
        QueryBuilder<Message> mqBuilder = getMessageDao().queryBuilder();
        mqBuilder.where(MessageDao.Properties.ChatId.eq(userId),
                MessageDao.Properties.ShowSessionType.eq(sessionType),
                MessageDao.Properties.Content.isNotNull()
        )
                .orderAsc(MessageDao.Properties.Timestamp)
                .offset(index)
                .limit(count);
        return mqBuilder.list();
    }

    public long queryMessageCount(long userId, int sessionType) {
//        Object[] sessionTypeArray = new Object[]{sessionType};
//        if (sessionType == SessionType.GROUP_CHAT.code) {
//            sessionTypeArray = new Object[]{SessionType.GROUP_CHAT.code,
//                    SessionType.GROUP_MEMBER_CHANGE_LOG.code,
//                    SessionType.GROUP_INFO_CHANGE_LOG.code,
//                    SessionType.PERSONAL_GROUP_NOTICE.code};
//        }
        return getMessageDao().queryBuilder().where(
                MessageDao.Properties.ChatId.eq(userId),
                MessageDao.Properties.ShowSessionType.eq(sessionType),
                MessageDao.Properties.Content.isNotNull()
        ).count();
    }

    /**===============================消息 END=======================================*/

    /**===============================会话列表 START=======================================*/

    /**
     * 载入session 表中的所有数据
     *
     * @return
     */
    public List<SessionInfo> loadAllSession() {
        List<SessionInfo> result = getSessionInfoDao().queryBuilder()
                .orderDesc(SessionInfoDao.Properties.LastTime)
                .list();
        return result;
    }

    /**
     * 载入session 表中的用于展示的数据（私聊、群聊）
     *
     * @return
     */
    public List<SessionInfo> loadShowSession() {
        List<SessionInfo> result = getSessionInfoDao().queryBuilder()
                .whereOr(SessionInfoDao.Properties.SessionType.eq(SessionType.PRIVATE_CHAT.code),
                        SessionInfoDao.Properties.SessionType.eq(SessionType.GROUP_CHAT.code))
                .orderDesc(SessionInfoDao.Properties.LastTime)
                .list();
        return result;
    }

    /**
     * 载入session 表中的用于记录好友请求的数据
     *
     * @return
     */
    public List<SessionInfo> loadNewFriendSession() {
        List<SessionInfo> result = getSessionInfoDao().queryBuilder()
                .where(SessionInfoDao.Properties.SessionType.eq(SessionType.FRIEND_REQUEST.code))
                .orderDesc(SessionInfoDao.Properties.LastTime)
                .list();
        return result;
    }

    public SessionInfo queryUniqueSession(long targetId, int sessionType) {
        return getSessionInfoDao().queryBuilder().where(SessionInfoDao.Properties.TargetId.eq(targetId),
                SessionInfoDao.Properties.SessionType.eq(sessionType)).unique();
    }

    /**
     * 保存session，如果不存在就插入，如果存在就更新
     *
     * @param sessionInfo 这里session里的count指的是添加的count
     * @return
     */
    public long saveSession(SessionInfo sessionInfo) {
        Logger.i(TAG, " -> saveSession:" + sessionInfo.getTargetId() + "-" + sessionInfo.getSessionType() + "-" + sessionInfo.getLastMessageId());
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            //如果置顶的先改变置顶时间
            updateSessionConfigTopTime(sessionInfo.getTargetId(), sessionInfo.getSessionType());
            long rowId;
            try {
                rowId = getSessionInfoDao().insert(sessionInfo);
            } catch (SQLiteException e) {
                ContentValues cv = new ContentValues();
                cv.put(SessionInfoDao.Properties.LastMessage.columnName, sessionInfo.getLastMessage());
                cv.put(SessionInfoDao.Properties.LastMessageId.columnName, sessionInfo.getLastMessageId());
                cv.put(SessionInfoDao.Properties.LastTime.columnName, sessionInfo.getLastTime());
                rowId = getSQLiteDatabase().update(
                        SessionInfoDao.TABLENAME,
                        cv,
                        SessionInfoDao.Properties.TargetId.columnName + "=? AND "
                                + SessionInfoDao.Properties.SessionType.columnName + "=? AND "
                                + SessionInfoDao.Properties.LastTime.columnName + "<=?",
                        new String[]{String.valueOf(sessionInfo.getTargetId()),
                                String.valueOf(sessionInfo.getSessionType()),
                                String.valueOf(sessionInfo.getLastTime())
                        });
                if (rowId != -1) {
                    rowId = addSessionCount(sessionInfo.getTargetId(), sessionInfo.getSessionType(), sessionInfo.getCount());
                }
            }
            db.setTransactionSuccessful();
            Logger.i(TAG, " -> saveSession: rowId=" + rowId);
            return rowId;
        } finally {
            db.endTransaction();
        }

    }


//    public void updateSession(SessionInfo sessionInfo) {
//        //如果置顶的先改变置顶时间
//        SQLiteDatabase db = getSQLiteDatabase();
//        db.beginTransaction();
//        try {
//            ContentValues cv = new ContentValues();
//            cv.put(SessionConfigDao.Properties.TopTime.columnName, System.currentTimeMillis());
//            db.update(
//                    SessionConfigDao.TABLENAME,
//                    cv,
//                    SessionConfigDao.Properties.TargetId.columnName + "=? AND "
//                            + SessionConfigDao.Properties.TargetType.columnName + "=? AND "
//                            + SessionConfigDao.Properties.SessionType.columnName + "=? AND "
//                            + SessionConfigDao.Properties.IsTop.columnName + "=?",
//                    new String[]{String.valueOf(sessionInfo.getTargetId()),
//                            String.valueOf(sessionInfo.getTargetType()),
//                            String.valueOf(sessionInfo.getSessionType()),
//                            String.valueOf(1)});
//
//
//            String sql = "UPDATE SESSION_INFO SET COUNT=COUNT+" + sessionInfo.getCount() +
//                    ",LAST_MESSAGE='" + sessionInfo.getLastMessage() +
//                    "',LAST_MESSAGE_ID=" + sessionInfo.getLastMessageId() +
//                    ",LAST_TIME=" + sessionInfo.getLastTime() +
//                    " WHERE TARGET_ID=" + sessionInfo.getTargetId() +
//                    " AND TARGET_TYPE=" + sessionInfo.getTargetType() +
//                    " AND SESSION_TYPE=" + sessionInfo.getSessionType() +
//                    " AND LAST_TIME<" + sessionInfo.getLastTime();
//            Logger.e(TAG, "updateSession -> " + sql);
//            SQLiteStatement statement = db.compileStatement(sql);
//            int rowId;
//            try {
//                rowId = statement.executeUpdateDelete();
//            } finally {
//                statement.close();
//            }
//            //
//            if (rowId == 0) {
//                saveSession(sessionInfo);
//            }
//
//            db.setTransactionSuccessful();
//        } finally {
//            db.endTransaction();
//        }
//
//    }

    /**
     * 这里session在做更新操作时，count是做+=的
     *
     * @param targetId
     * @param sessionType
     * @param addCount
     * @return
     */
    public int addSessionCount(long targetId, int sessionType, int addCount) {
        String sql = "UPDATE SESSION_INFO SET COUNT=COUNT+" + addCount +
                " WHERE TARGET_ID=" + targetId +
                " AND SESSION_TYPE=" + sessionType;
        Logger.i(TAG, "saveSession -> " + sql);
        SQLiteStatement statement = db.compileStatement(sql);
        try {
            return statement.executeUpdateDelete();
        } finally {
            statement.close();
        }
    }

    public int updateSessionCount(long targetId, int sessionType, int count) {
        ContentValues cv = new ContentValues();
        cv.put(SessionInfoDao.Properties.Count.columnName, count);
        return getSQLiteDatabase().update(
                SessionInfoDao.TABLENAME,
                cv,
                SessionInfoDao.Properties.TargetId.columnName + "=? AND "
                        + SessionInfoDao.Properties.SessionType.columnName + "=?",
                new String[]{String.valueOf(targetId), String.valueOf(sessionType)});
    }

    public int clearSessionText(long userId, int sessionType) {
        ContentValues cv = new ContentValues();
        cv.put(SessionInfoDao.Properties.LastMessage.columnName, "");
        return getSQLiteDatabase().update(
                SessionInfoDao.TABLENAME,
                cv,
                SessionInfoDao.Properties.TargetId.columnName + "=? AND " + SessionInfoDao.Properties.SessionType.columnName + "=?",
                new String[]{String.valueOf(userId), String.valueOf(sessionType)});
    }

    public void deleteSession(long targetId, int sessionType) {
        DeleteQuery<SessionInfo> bd = getSessionInfoDao().queryBuilder()
                .where(SessionInfoDao.Properties.TargetId.eq(targetId),
                        SessionInfoDao.Properties.SessionType.eq(sessionType))
                .buildDelete();

        bd.executeDeleteWithoutDetachingEntities();
    }

    /**
     * 删除群聊会话
     */
    public void deleteGroupChat(long groupId) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            deleteSession(groupId, SessionType.GROUP_CHAT.code);
            deleteSessionConfig(groupId, SessionType.GROUP_CHAT.code);
            clearChat(groupId, SessionType.GROUP_CHAT.code);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    /**
     * 删除私聊会话
     *
     * @param userId
     */
    public void deletePrivateChat(long userId) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            deleteSession(userId, SessionType.PRIVATE_CHAT.code);
            deleteSessionConfig(userId, SessionType.PRIVATE_CHAT.code);
            clearChat(userId, SessionType.PRIVATE_CHAT.code);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    public long getNoReadSessionNumber() {
//        long count = DatabaseUtils.longForQuery(getSQLiteDatabase(), "SELECT SUM(COUNT) FROM SESSION_INFO", null);
//        long countMute = DatabaseUtils.longForQuery(getSQLiteDatabase(),
//                "SELECT SUM(SI.COUNT) FROM SESSION_INFO SI LEFT JOIN SESSION_CONFIG SC ON SI.TARGET_ID = SC.TARGET_ID" +
//                        " AND SI.TARGET_TYPE = SC.TARGET_TYPE AND SI.SESSION_TYPE = SC.SESSION_TYPE WHERE SC.IS_MUTE = 0 OR SC.IS_MUTE IS NULL",
//                null);
//        return count - countMute;
        return DatabaseUtils.longForQuery(getSQLiteDatabase(),
                "SELECT SUM(SI.COUNT) FROM SESSION_INFO SI LEFT JOIN SESSION_CONFIG SC " +
                        "ON SI.TARGET_ID = SC.TARGET_ID AND SI.SESSION_TYPE = SC.SESSION_TYPE WHERE " +
                        "(SC.IS_MUTE = 0 OR SC.IS_MUTE IS NULL) AND (SI.SESSION_TYPE = 1 OR SI.SESSION_TYPE = 2)",
                null);
    }

    public long getNewFriendNumber() {
        return getSessionInfoDao().queryBuilder().where(
                SessionInfoDao.Properties.SessionType.eq(SessionType.FRIEND_REQUEST.code),
                SessionInfoDao.Properties.Count.gt(0)
        ).count();
    }

    public int clearNewFriendNumber() {
        ContentValues cv = new ContentValues();
        cv.put(SessionInfoDao.Properties.Count.columnName, 0);
        return getSQLiteDatabase().update(
                SessionInfoDao.TABLENAME,
                cv,
                SessionInfoDao.Properties.SessionType.columnName + "=?",
                new String[]{String.valueOf(SessionType.FRIEND_REQUEST.code)});
    }

    /**
     * 删除不存在的会话
     */
    public void deleteNotExistSession() {
        //获取所有会话
        List<SessionInfo> sessionInfos = loadShowSession();
        if (sessionInfos.size() > 0) {
            //去除不存在的
            for (SessionInfo sessionInfo : sessionInfos) {
                switch (SessionType.of(sessionInfo.getSessionType())) {
                    case PRIVATE_CHAT:
                        Contact contact = queryUniqueContact(sessionInfo.getTargetId());
                        if (contact == null) {
                            deletePrivateChat(sessionInfo.getTargetId());
                        }
                        break;
                    case GROUP_CHAT:
                        break;
                }
            }
        }
    }

    /**===============================会话列表 END=======================================*/


    /**
     * ===============================会话配置 END=======================================
     */
    public long saveSessionConfig(SessionConfig sessionConfig) {
        return getSessionConfigDao().insertOrReplace(sessionConfig);
    }

    public void saveSessionConfigList(List<SessionConfig> sessionConfigList) {
        if (sessionConfigList.size() <= 0) {
            return;
        }
        getSessionConfigDao().insertOrReplaceInTx(sessionConfigList);
    }

    public SessionConfig queryUniqueSessionConfig(long targetId, int sessionType) {
        return getSessionConfigDao().queryBuilder().where(SessionConfigDao.Properties.TargetId.eq(targetId),
                SessionConfigDao.Properties.SessionType.eq(sessionType)).unique();
    }

    public void deleteSessionConfig(long targetId, int sessionType) {
        DeleteQuery<SessionConfig> bd = getSessionConfigDao().queryBuilder()
                .where(SessionConfigDao.Properties.TargetId.eq(targetId), SessionConfigDao.Properties.SessionType.eq(sessionType))
                .buildDelete();
        bd.executeDeleteWithoutDetachingEntities();
    }


    private void updateSessionConfigTopTime(long targetId, int sessionType) {
        ContentValues cv = new ContentValues();
        cv.put(SessionConfigDao.Properties.TopTime.columnName, System.currentTimeMillis());
        getSQLiteDatabase().update(
                SessionConfigDao.TABLENAME,
                cv,
                SessionConfigDao.Properties.TargetId.columnName + "=? AND "
                        + SessionConfigDao.Properties.SessionType.columnName + "=? AND "
                        + SessionConfigDao.Properties.IsTop.columnName + "=?",
                new String[]{String.valueOf(targetId),
                        String.valueOf(sessionType),
                        String.valueOf(1)});
    }

    /**===============================会话配置 END=======================================*/


    /**
     * ===============================联系人 START=======================================
     */

    public long saveContact(Contact contact) {
        return getContactDao().insertOrReplace(contact);
    }


    public void saveContactList(List<Contact> contacts) {
        if (contacts.size() <= 0) {
            return;
        }
        getContactDao().insertOrReplaceInTx(contacts);
    }

    /**
     * 清空联系人表
     */
    public void deleteAllContacts() {
        getContactDao().deleteAll();
    }

    public Contact queryUniqueContact(long userId) {
        return getContactDao().queryBuilder().where(ContactDao.Properties.UserId.eq(userId)).unique();
    }

    /**
     * 删除联系人
     */
    public void deleteContacts(long userId) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            DeleteQuery<Contact> bd = getContactDao().queryBuilder()
                    .where(ContactDao.Properties.UserId.eq(userId))
                    .buildDelete();
            bd.executeDeleteWithoutDetachingEntities();
            updateRemark(userId, "", "");
            deletePrivateChat(userId);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    /**
     * 更换联系人信息
     *
     * @param contactList
     */
    public void replaceUserList(List<Contact> contactList) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            //清空联系人表
            DBHelper.getInstance().deleteAllContacts();
            //保存联系人
            DBHelper.getInstance().saveContactList(contactList);
            //删除不存在的会话
            DBHelper.getInstance().deleteNotExistSession();
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }


    /**
     * 查询与此人的关系
     *
     * @param userId
     * @return 1:通讯录联系人 2:给我发过好友请求的人 3:陌生人
     */
    public int queryContactRelations(long userId) {
        Contact contact = queryUniqueContact(userId);
        if (contact != null) {
            return 1;
        } else {
            return 3;
//            SessionInfo sessionInfo = queryUniqueSession(userId, SessionType.FRIEND_REQUEST.code);
//            if (sessionInfo != null) {
//                return 2;
//            }
        }
//        return 3;
    }

    /**===============================联系人 END=======================================*/


    /**===============================用户信息 START=======================================*/

    /**
     * 插入一个user，如果有替换掉
     *
     * @param userInfo
     * @return
     */

    public long saveUserInfo(UserInfo userInfo) {
        return getUserInfoDao().insertOrReplace(userInfo);
    }


    public void saveUserInfoList(List<UserInfo> userInfos) {
        if (userInfos.size() <= 0) {
            return;
        }
        getUserInfoDao().insertOrReplaceInTx(userInfos);
    }


    /**
     * 根据名字查询联系人
     */
    public UserInfo queryContactByName(String name) {

        return getUserInfoDao().queryBuilder().where(
                UserInfoDao.Properties.Name.eq(name)
        ).unique();
    }

    /**
     * 查询所有联系人的信息
     */
    public List<UserInfo> queryContactInfoList() {
        Query<UserInfo> infoQuery = getUserInfoDao()
                .queryRawCreateListArgs(" JOIN CONTACT C ON T.USER_ID = C.USER_ID", new ArrayList<Object>());

        return infoQuery.list();
    }

    /**
     * 查询所有非系统用户的联系人的信息
     */
    public List<UserInfo> queryNonSystemContactInfoList() {
        Query<UserInfo> infoQuery = getUserInfoDao()
                .queryRawCreateListArgs(" JOIN " + getContactDao().getTablename() + " C ON T.USER_ID = C.USER_ID WHERE T.USER_TYPE = 1", new ArrayList<Object>());

        return infoQuery.list();
    }


    /**
     * 搜索非系统用户的联系人
     *
     * @param str 关键字
     * @return 符合的联系人列表
     */
    public List<UserInfo> searchNonSystemContacts(String str) {
        str = str.replace(",", "").toUpperCase();
        if (str.length() == 0) {
            return null;
        }
        String likeStr = "%" + str + "%";
        List<Object> args = new ArrayList<>();
        args.add(likeStr);
        args.add(likeStr);
        args.add(likeStr);
        args.add(likeStr);
        args.add(str);

        Query<UserInfo> infoQuery = getUserInfoDao()
                .queryRawCreateListArgs(" JOIN CONTACT C ON T.USER_ID = C.USER_ID " +
                                "WHERE  T.USER_TYPE = 1 AND (T.NAME LIKE ? OR T.NAME_PIN_YIN LIKE ? OR T.REMARK LIKE ? OR T.REMARK_PIN_YIN LIKE ? OR T.USER_ID=?)",
                        args);
        return infoQuery.list();
    }


    /**
     * 查询群成员的用户信息
     *
     * @param groupId  群id
     * @param haveSelf 是否包含自己
     * @return
     */
    public List<UserInfo> queryGroupMemberInfo(long groupId, boolean haveSelf) {
        Query<UserInfo> infoQuery;
        List<Object> selectionArg = new ArrayList<>();
        selectionArg.add(groupId);
        if (haveSelf) {
            infoQuery = getUserInfoDao()
                    .queryRawCreateListArgs(" JOIN " + getGroupMemberDao().getTablename() + " GM ON GM.USER_ID = T.USER_ID WHERE GM.GROUP_ID = ? ORDER BY GM._ID ASC", selectionArg);
        } else {
            selectionArg.add(IMApplication.userId);
            infoQuery = getUserInfoDao()
                    .queryRawCreateListArgs(" JOIN " + getGroupMemberDao().getTablename() + " GM ON GM.USER_ID = T.USER_ID WHERE GM.GROUP_ID = ? AND T.USER_ID != ? ORDER BY GM._ID ASC", selectionArg);
        }
        return infoQuery.list();
    }

    /**
     * 查询群成员的用户信息
     *
     * @param groupId 群id
     * @return
     */
    public List<UserInfo> searchGroupMemberInfo(long groupId, String str) {
        str = str.replace(",", "").toUpperCase();
        Query<UserInfo> infoQuery;
        String likeStr = "%" + str + "%";
        List<Object> selectionArg = new ArrayList<>();

        selectionArg.add(groupId);
        selectionArg.add(IMApplication.userId);
        selectionArg.add(likeStr);
        selectionArg.add(likeStr);
        selectionArg.add(likeStr);
        selectionArg.add(likeStr);
        infoQuery = getUserInfoDao()
                .queryRawCreateListArgs(" JOIN " + getGroupMemberDao().getTablename() + " GM ON GM.USER_ID = T.USER_ID WHERE GM.GROUP_ID = ? AND T.USER_ID != ? AND (T.NAME LIKE ? OR T.NAME_PIN_YIN LIKE ? OR T.REMARK LIKE ? OR T.REMARK_PIN_YIN LIKE ? )", selectionArg);


        return infoQuery.list();
    }

    public List<UserInfo> query9GroupMemberInfo(long groupId) {
        Query<UserInfo> infoQuery;
        List<Object> selectionArg = new ArrayList<>();
        selectionArg.add(groupId);
        infoQuery = getUserInfoDao()
                .queryRawCreateListArgs(" JOIN " + getGroupMemberDao().getTablename() + " GM ON GM.USER_ID = T.USER_ID WHERE GM.GROUP_ID = ? ORDER BY GM._ID ASC LIMIT 9", selectionArg);

        return infoQuery.list();
    }

    public List<UserInfo> queryGroupMembers(long groupId, int count) {
        Query<UserInfo> infoQuery;
        List<Object> selectionArg = new ArrayList<>();
        selectionArg.add(groupId);
        selectionArg.add(count);
        infoQuery = getUserInfoDao()
                .queryRawCreateListArgs(" JOIN " + getGroupMemberDao().getTablename() + " GM ON GM.USER_ID = T.USER_ID WHERE GM.GROUP_ID = ? ORDER BY GM._ID ASC LIMIT ?", selectionArg);

        return infoQuery.list();
    }


    /**
     * 搜索联系人
     *
     * @param str 关键字
     * @return 符合的联系人列表
     */
    public List<UserInfo> searchContacts(String str) {
        str = str.replace(",", "").toUpperCase();
        if (str.length() == 0) {
            return null;
        }
        String likeStr = "%" + str + "%";

//        getUserInfoDao().queryBuilder().whereOr(
//                UserInfoDao.Properties.Name.like(likeStr),
//                UserInfoDao.Properties.NamePinYin.like(likeStr),
//                UserInfoDao.Properties.Remark.like(likeStr),
//                UserInfoDao.Properties.RemarkPinYin.like(likeStr),
//                UserInfoDao.Properties.UserId.eq(str)
//        ).list();

        List<Object> args = new ArrayList<>();
        args.add(likeStr);
        args.add(likeStr);
        args.add(likeStr);
        args.add(likeStr);
        args.add(str);

        Query<UserInfo> infoQuery = getUserInfoDao()
                .queryRawCreateListArgs(" JOIN CONTACT C ON T.USER_ID = C.USER_ID " +
                                "WHERE (T.NAME LIKE ? OR T.NAME_PIN_YIN LIKE ? OR T.REMARK LIKE ? OR T.REMARK_PIN_YIN LIKE ? OR T.USER_ID=?)",
                        args);
        return infoQuery.list();
    }

    /**
     * 搜索新的好友
     *
     * @param strSearch 关键字
     * @return 用户id,-1表示没有结果
     */
    public long searchNewFriend(String strSearch) {
        UserInfo userInfo = getUserInfoDao().queryBuilder().whereOr(
                UserInfoDao.Properties.UserId.eq(strSearch),
                UserInfoDao.Properties.Name.eq(strSearch),
                UserInfoDao.Properties.Phone.eq(strSearch)
        ).unique();

        if (userInfo == null) {
            return -1;
        } else {
            return userInfo.getUserId();
        }
    }


    public int updateRemark(long userId, String remark, String remarkPinYin) {
        ContentValues cv = new ContentValues();
        cv.put(UserInfoDao.Properties.Remark.columnName, remark);
        cv.put(UserInfoDao.Properties.RemarkPinYin.columnName, remarkPinYin);
        return getSQLiteDatabase().update(
                UserInfoDao.TABLENAME,
                cv,
                UserInfoDao.Properties.UserId.columnName + "=?",
                new String[]{String.valueOf(userId)});
    }

//    public void updateUserConfig(long targetId, int targetType, boolean mute, boolean top) {
//        ContentValues cv = new ContentValues();
//        cv.put(UserInfoDao.Properties.IsMute.columnName, mute);
//        cv.put(UserInfoDao.Properties.IsTop.columnName, top);
//        getSQLiteDatabase().update(
//                UserInfoDao.TABLENAME,
//                cv,
//                UserInfoDao.Properties.UserId.columnName + "=? AND " + UserInfoDao.Properties.UserType.columnName + "=?",
//                new String[]{String.valueOf(targetId), String.valueOf(targetType)});
//    }

//    public UserInfo queryUniqueUserInfo(long userId, int userType) {
//        return getUserInfoDao().queryBuilder().where(UserInfoDao.Properties.UserId.eq(userId),
//                UserInfoDao.Properties.UserType.eq(userType)).unique();
//    }

    /**
     * 载入user表中除我之外的所有数据
     *
     * @return
     */
    @Deprecated
    public List<UserInfo> loadAllUsers(long userId) {
        List<UserInfo> result = getUserInfoDao().queryBuilder()
                .where(UserInfoDao.Properties.UserId.notEq(userId))
                .orderAsc(UserInfoDao.Properties.Name)
                .list();
        return result;
    }

    public UserInfo queryUniqueUserInfo(long userId) {
        return getUserInfoDao().queryBuilder().where(UserInfoDao.Properties.UserId.eq(userId)).unique();
    }

    public UserInfo queryMyInfo() {
        return queryUniqueUserInfo(loginUserId);
    }

    /**
     * ===============================用户信息 END=======================================
     */

    /**
     * ===============================群信息 START=======================================
     */


    public void levaeGroup(long groupId) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            DeleteQuery<GroupInfo> bd = getGroupInfoDao().queryBuilder()
                    .where(GroupInfoDao.Properties.GroupId.eq(groupId))
                    .buildDelete();
            bd.executeDeleteWithoutDetachingEntities();
            deleteGroupChat(groupId);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    /**
     * @param groupInfo
     */
    public void saveGroupInfo(GroupInfo groupInfo) {
        getGroupInfoDao().insertOrReplace(groupInfo);
    }

    public GroupInfo queryUniqueGroupInfo(long groupId) {
        return getGroupInfoDao().queryBuilder().where(GroupInfoDao.Properties.GroupId.eq(groupId)).unique();
    }

    public int updateGroupLocalName(long groupId) {
        String localName = TransformUtils.createGroupLocalName(groupId);
        ContentValues cv = new ContentValues();
        cv.put(GroupInfoDao.Properties.LocalName.columnName, localName);
        return getSQLiteDatabase().update(
                GroupInfoDao.TABLENAME,
                cv,
                GroupInfoDao.Properties.GroupId.columnName + "=?",
                new String[]{String.valueOf(groupId)});
    }

    public int updateGroupShowNotice(long groupId, boolean isShow) {
        ContentValues cv = new ContentValues();
        cv.put(GroupInfoDao.Properties.IsNewNotice.columnName, isShow);
        return getSQLiteDatabase().update(
                GroupInfoDao.TABLENAME,
                cv,
                GroupInfoDao.Properties.GroupId.columnName + "=?",
                new String[]{String.valueOf(groupId)});
    }

    public int updateGroupName(long groupId, String name, int infoVersion) {
        return updateGroupInfo(groupId, name, infoVersion, "NAME");
    }

    public int updateGroupNotice(long groupId, String notice, int infoVersion) {
        return updateGroupInfo(groupId, notice, infoVersion, "NOTICE");
    }

    public int updateGroupHolder(long groupId, String holder, int infoVersion) {
        return updateGroupInfo(groupId, holder, infoVersion, "HOLDER");
    }

    private int updateGroupInfo(long groupId, String data, int infoVersion, String type) {
        int rowCount;
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            String changeStr = "";
            switch (type) {
                case "NAME":
                    changeStr = ",NAME='" + data + "'";
                    break;
                case "NOTICE":
                    changeStr = ",NOTICE='" + data + (TextUtils.isEmpty(data) ? "',IS_NEW_NOTICE=0" : "',IS_NEW_NOTICE=1");
                    break;
                case "HOLDER":
                    changeStr = ",HOLDER='" + data + "'";
                    break;
            }
            String sql = "UPDATE GROUP_INFO SET INFO_VERSION=" + infoVersion +
                    changeStr +

                    " WHERE GROUP_ID=" + groupId +
                    " AND INFO_VERSION=" + (infoVersion - 1);
            SQLiteStatement statement = db.compileStatement(sql);
            try {
                rowCount = statement.executeUpdateDelete();
            } finally {
                statement.close();
            }

            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
        return rowCount;
    }

    /**
     * @param groupId
     * @param memberVersion
     * @param addCount      有正负
     * @return
     */
    public int updateGroupMemberCount(long groupId, int memberVersion, int addCount) {
        int rowCount;
        String localName = TransformUtils.createGroupLocalName(groupId);
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            String sql = "UPDATE GROUP_INFO SET MEMBER_VERSION=" + memberVersion +
                    ",LOCAL_NAME='" + localName +
                    "',MEMBER_COUNT=MEMBER_COUNT+" + addCount +

                    " WHERE GROUP_ID=" + groupId +
                    " AND MEMBER_VERSION=" + (memberVersion - 1);
//            Logger.e(TAG, "updateGroupMemberCount -> " + sql);
            SQLiteStatement statement = db.compileStatement(sql);
            try {
                rowCount = statement.executeUpdateDelete();
            } finally {
                statement.close();
            }

            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
        return rowCount;
//        ContentValues cv = new ContentValues();
//        cv.put(GroupInfoDao.Properties.MemberVersion.columnName, version);
//        cv.put(GroupInfoDao.Properties.MemberCount.columnName, addCount);
//        return getSQLiteDatabase().update(
//                GroupInfoDao.TABLENAME,
//                cv,
//                GroupInfoDao.Properties.GroupId.columnName + "=?",
//                new String[]{String.valueOf(groupId)});
    }

    public int setGroupInfoKickOut(long groupId, boolean isKickOut) {
        ContentValues cv = new ContentValues();
        cv.put(GroupInfoDao.Properties.IsKickOut.columnName, isKickOut);
        cv.put(GroupInfoDao.Properties.IsNewNotice.columnName, false);
        return getSQLiteDatabase().update(
                GroupInfoDao.TABLENAME,
                cv,
                GroupInfoDao.Properties.GroupId.columnName + "=?",
                new String[]{String.valueOf(groupId)});
    }

    /**
     * ===============================群信息 END=======================================
     */

    /**
     * ===============================群成员 START=======================================
     */

    public long queryGroupMemberCount(long groupId) {
        return getGroupMemberDao().queryBuilder().where(GroupMemberDao.Properties.GroupId.eq(groupId)).count();
    }

    public List<GroupMember> queryGroupMembers(long groupId) {
        return getGroupMemberDao().queryBuilder().where(GroupMemberDao.Properties.GroupId.eq(groupId)).list();
    }

    public void clearGroupMembers(long groupId) {
        DeleteQuery<GroupMember> bd = getGroupMemberDao().queryBuilder()
                .where(GroupMemberDao.Properties.GroupId.eq(groupId))
                .buildDelete();

        bd.executeDeleteWithoutDetachingEntities();
    }

    /**
     * @param groupId
     * @return 影响的行数
     */
    public int insertGroupMembers(long groupId, List<Long> userIds) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        int msgCount = 0;
        try {
            for (long userId : userIds) {
                try {
                    getGroupMemberDao().insert(new GroupMember(groupId, userId));
                    msgCount++;
                } catch (SQLiteException e) {
                    Logger.e(TAG, "insertGroupMembers - insert fail : " + e.getMessage());
                }
            }
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
        return msgCount;
    }

    public int savePullGroupMembers(long groupId, List<Long> memberIds, int version) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        int rowId = 0;
        try {
            clearGroupMembers(groupId);
            int addCount = insertGroupMembers(groupId, memberIds);
            rowId = updateGroupMemberCount(groupId, version, addCount);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
        return rowId;
    }

    public void replaceGroupInfo(GroupInfo groupInfo, List<Long> memberIds) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            clearGroupMembers(groupInfo.getGroupId());
            insertGroupMembers(groupInfo.getGroupId(), memberIds);
            groupInfo.setLocalName(TransformUtils.createGroupLocalName(groupInfo.getGroupId()));
            saveGroupInfo(groupInfo);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    public void addGroupMembers(long groupId, List<Long> addUserIdList) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            for (long userId : addUserIdList) {
                try {
                    getGroupMemberDao().insertOrReplace(new GroupMember(groupId, userId));
                } catch (SQLiteException e) {
                    Logger.e(TAG, "addGroupMembers - insert fail : " + e.getMessage());
                }
            }
            updateGroupLocalName(groupId);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    public void deleteGroupMembers(long groupId, List<Long> addUserIdList) {
        SQLiteDatabase db = getSQLiteDatabase();
        db.beginTransaction();
        try {
            DeleteQuery<GroupMember> bd;
            for (long userId : addUserIdList) {
                bd = getGroupMemberDao().queryBuilder()
                        .where(GroupMemberDao.Properties.GroupId.eq(groupId),
                                GroupMemberDao.Properties.UserId.eq(userId))
                        .buildDelete();

                bd.executeDeleteWithoutDetachingEntities();
            }
            updateGroupLocalName(groupId);
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    /**
     * ===============================群成员 END=======================================
     */

    /**
     * ===============================手机上的用户信息 START=======================================
     */

    /**
     * 插入一个user，如果有替换掉
     */

    public long saveMobileUserInfo(MobileUserInfo userInfo) {
        return getMobileUserInfoDao().insertOrReplace(userInfo);
    }


    public void saveMobileUserInfoList(List<MobileUserInfo> userInfos) {
        if (userInfos.size() <= 0) {
            return;
        }
        getMobileUserInfoDao().insertOrReplaceInTx(userInfos);
    }

    public MobileUserInfo queryUniqueMobileUserInfo(long userId) {
        return getMobileUserInfoDao().queryBuilder().where(MobileUserInfoDao.Properties.UserId.eq(userId)).unique();
    }

    public List<MobileUserInfo> loadAllMobileUserInfo() {
        List<MobileUserInfo> result = getMobileUserInfoDao().queryBuilder()
                .list();
        return result;
    }

    public List<MobileUserInfo> searchMobileUserInfo(String strSearch) {
        strSearch = strSearch.replace(",", "").toUpperCase();
        if (strSearch.length() == 0) {
            return null;
        }
        String likeStr = "%" + strSearch + "%";

        List<MobileUserInfo> result = getMobileUserInfoDao().queryBuilder().whereOr(
                MobileUserInfoDao.Properties.Phone.eq(strSearch),
                MobileUserInfoDao.Properties.UserId.eq(strSearch),
                MobileUserInfoDao.Properties.Name.like(likeStr),
                MobileUserInfoDao.Properties.MobName.like(likeStr),
                MobileUserInfoDao.Properties.NamePinYin.like(likeStr)
        ).list();

        return result;
    }
    /**
     * ===============================手机上的用户信息 END=======================================
     */


    /**
     * 根据类型查询对应json
     *
     * @param type
     * @return
     */
    public JsonEntity queryJsonByType(String type) {
        return getJsonEntityDao().queryBuilder().where(JsonEntityDao.Properties.Json_type.eq(type)).unique();
    }

    /**
     * 设置json
     *
     * @param jsonEntity
     */
    public void saveCacheJson(JsonEntity jsonEntity) {
        getJsonEntityDao().insertOrReplace(jsonEntity);
    }

}
