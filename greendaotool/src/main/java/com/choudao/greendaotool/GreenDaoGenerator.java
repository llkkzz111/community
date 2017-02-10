package com.choudao.greendaotool;

import de.greenrobot.daogenerator.DaoGenerator;
import de.greenrobot.daogenerator.Entity;
import de.greenrobot.daogenerator.Index;
import de.greenrobot.daogenerator.Property;
import de.greenrobot.daogenerator.Schema;

public class GreenDaoGenerator {
    public static void main(String[] args) {
        Schema schema = new Schema(6, "com.choudao.imsdk.db.bean");
        schema.setDefaultJavaPackageDao("com.choudao.imsdk.db.dao");
        schema.enableKeepSectionsByDefault();
        //schema.enableActiveEntitiesByDefault();

        addMessage(schema);
        addSessionInfo(schema);
        addSessionConfig(schema);
        addContact(schema);
        addUserInfo(schema);
        addMobileUserInfo(schema);
        addGroupInfo(schema);
        addGroupMember(schema);
        addCacheJson(schema);
        try {
            new DaoGenerator().generateAll(schema, "./imsdk/src/main/java/");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    private static void addMessage(Schema schema) {
        Entity message = schema.addEntity("Message");

        message.implementsSerializable();

        message.addIdProperty().autoincrement();
        Property chatIdPro = message.addLongProperty("chatId").notNull().getProperty();
        message.addIntProperty("chatType");
        message.addLongProperty("sendUserId");
        message.addIntProperty("sendUserType");
        message.addStringProperty("content");
        message.addIntProperty("contentType");
        Property sessionTypePro = message.addIntProperty("sessionType").notNull().getProperty();
        message.addIntProperty("sendStatus");
        Property msgIdPro = message.addLongProperty("msgId").notNull().getProperty();
        message.addLongProperty("timestamp").index();
        message.addIntProperty("showType");
        message.addIntProperty("showSessionType");
        message.addStringProperty("srcContent");

        Index index = new Index();
        index.addProperty(chatIdPro);
        index.addProperty(msgIdPro);
        index.addProperty(sessionTypePro);
        index.makeUnique();
        message.addIndex(index);

    }

    private static void addSessionInfo(Schema schema) {
        Entity session = schema.addEntity("SessionInfo");

        session.implementsSerializable();

        session.addIdProperty().autoincrement();
        Property targetIdPro = session.addLongProperty("targetId").notNull().getProperty();
        session.addIntProperty("targetType");
        Property sessionTypePro = session.addIntProperty("sessionType").notNull().getProperty();
        session.addIntProperty("count");
        session.addStringProperty("lastMessage");
        session.addLongProperty("lastMessageId");
        session.addLongProperty("lastTime").index();

        Index index = new Index();
        index.addProperty(targetIdPro);
        index.addProperty(sessionTypePro);
        index.makeUnique();
        session.addIndex(index);

    }


    private static void addSessionConfig(Schema schema) {

        Entity sessionConfigs = schema.addEntity("SessionConfig");

        sessionConfigs.implementsSerializable();

        sessionConfigs.addIdProperty().autoincrement();
        Property targetIdPro = sessionConfigs.addLongProperty("targetId").notNull().getProperty();
        sessionConfigs.addIntProperty("targetType");
        Property sessionTypePro = sessionConfigs.addIntProperty("sessionType").notNull().getProperty();

        sessionConfigs.addBooleanProperty("isTop");
        sessionConfigs.addLongProperty("topTime").notNull().index();
        sessionConfigs.addBooleanProperty("isMute");

        Index index = new Index();
        index.addProperty(targetIdPro);
        index.addProperty(sessionTypePro);
        index.makeUnique();
        sessionConfigs.addIndex(index);
    }

    private static void addContact(Schema schema) {

        Entity userInfo = schema.addEntity("Contact");

        userInfo.implementsSerializable();

        userInfo.addIdProperty().autoincrement();
        userInfo.addLongProperty("userId").notNull().unique().index();
        userInfo.addIntProperty("userType");
        userInfo.addStringProperty("remark");
        userInfo.addLongProperty("createTime").index();

    }

    private static void addUserInfo(Schema schema) {
        Entity userInfo = schema.addEntity("UserInfo");

        userInfo.implementsSerializable();

        userInfo.addIdProperty().autoincrement();
        userInfo.addLongProperty("userId").notNull().unique().index();
        userInfo.addIntProperty("userType");
        userInfo.addStringProperty("name");
        userInfo.addStringProperty("title");
        userInfo.addStringProperty("remark");
        userInfo.addStringProperty("namePinYin");
        userInfo.addStringProperty("remarkPinYin");
        userInfo.addStringProperty("headImgUrl");
        userInfo.addStringProperty("phone");
        userInfo.addStringProperty("desc");
        userInfo.addStringProperty("address");
        userInfo.addStringProperty("shareUrl");
        userInfo.addIntProperty("questionCount");
        userInfo.addIntProperty("answerCount");
        userInfo.addIntProperty("followersCount");
        userInfo.addIntProperty("followingCount");

        //舍弃部分
//        userInfo.addBooleanProperty("isTop").notNull();
//        userInfo.addLongProperty("topTime").notNull().index();
//        userInfo.addBooleanProperty("isMute").notNull();
        //舍弃部分

    }

    private static void addMobileUserInfo(Schema schema) {
        Entity mobileUserInfo = schema.addEntity("MobileUserInfo");

        mobileUserInfo.implementsSerializable();

        mobileUserInfo.addIdProperty().autoincrement();
        mobileUserInfo.addLongProperty("userId").notNull().unique().index();
        mobileUserInfo.addStringProperty("name");
        mobileUserInfo.addStringProperty("namePinYin");
        mobileUserInfo.addStringProperty("phone").notNull().index();
        mobileUserInfo.addStringProperty("headImgUrl");
        mobileUserInfo.addStringProperty("mobName");
        mobileUserInfo.addStringProperty("mobEmail");
        mobileUserInfo.addBooleanProperty("state");

    }

    private static void addGroupInfo(Schema schema) {
        Entity groupInfo = schema.addEntity("GroupInfo");

        groupInfo.implementsSerializable();

        groupInfo.addIdProperty().autoincrement();
        groupInfo.addLongProperty("groupId").notNull().unique().index();
        groupInfo.addStringProperty("name");
        groupInfo.addStringProperty("localName");
        groupInfo.addStringProperty("notice");
        groupInfo.addStringProperty("headImgUrl");
        groupInfo.addIntProperty("type");
        groupInfo.addLongProperty("holder");
        groupInfo.addIntProperty("memberCount");
        groupInfo.addIntProperty("memberVersion");
        groupInfo.addIntProperty("infoVersion");
        groupInfo.addBooleanProperty("isKickOut").notNull();
        groupInfo.addBooleanProperty("isNewNotice").notNull();

    }

    private static void addGroupMember(Schema schema) {
        Entity groupInfo = schema.addEntity("GroupMember");

        groupInfo.implementsSerializable();

        groupInfo.addIdProperty().autoincrement();
        Property groupIdPro = groupInfo.addLongProperty("groupId").notNull().getProperty();
        Property userIdPro = groupInfo.addLongProperty("userId").notNull().getProperty();
        groupInfo.addStringProperty("remark");
        groupInfo.addLongProperty("memberId");

        Index index = new Index();
        index.addProperty(groupIdPro);
        index.addProperty(userIdPro);
        index.makeUnique();
        groupInfo.addIndex(index);

    }


    private static void addCacheJson(Schema schema) {
        Entity message = schema.addEntity("JsonEntity");
        message.setTableName("json_table");
        message.implementsSerializable();

        message.addIdProperty().autoincrement();
        message.addStringProperty("json_type").unique();
        message.addStringProperty("json_info");

    }
}
