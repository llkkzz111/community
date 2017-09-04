package com.ocj.oms.mobile.ui.video.player;

import com.jz.jizhalivesdk.Bean.JZLiveRecord;
import com.jz.jizhalivesdk.Bean.JZLiveUser;
import com.jz.jizhalivesdk.JiZhaAPP;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by liu on 2017/7/12.
 */

public class LiveUtil {

    public static void setLiveUser(JSONObject obj) {
        JZLiveUser oneUser = new JZLiveUser();
        try {
            if (obj.has("id")) {
                oneUser.setId(obj.getInt("id"));
            }
            if (obj.has("iosEid")) {
                oneUser.setIosEid(obj.getString("iosEid"));
            } else {
                oneUser.setIosEid("");
            }
            if (obj.has("eid")) {
                oneUser.setEid(obj.getString("eid"));
            } else {
                oneUser.setEid("");
            }
            if (obj.has("name")) {
                oneUser.setName(obj.getString("name"));
            } else {
                oneUser.setName("");
            }
            if (obj.has("nickname")) {
                oneUser.setNickname(obj.getString("nickname"));
            } else {
                oneUser.setNickname("");
            }
            if (obj.has("sex")) {
                oneUser.setSex(obj.getString("sex"));
            } else {
                oneUser.setSex("");
            }
            if (obj.has("birthday")) {
                oneUser.setBirthday(obj.getString("birthday"));
            } else {
                oneUser.setBirthday("");
            }
            if (obj.has("nickname")) {
                oneUser.setNickname(obj.getString("nickname"));
            } else {
                oneUser.setNickname("");
            }
            if (obj.has("email")) {
                oneUser.setEmail(obj.getString("email"));
            } else {
                oneUser.setEmail("");
            }
            if (obj.has("signature")) {
                oneUser.setSignature(obj.getString("signature"));
            } else {
                oneUser.setSignature("");
            }
            if (obj.has("pic1")) {
                oneUser.setThumbIconUrl(obj.getString("pic1").replace("'", ""));
            } else {
                oneUser.setThumbIconUrl("");
            }
            if (obj.has("belongUnit")) {
                oneUser.setBelongUnit(obj.getString("belongUnit"));
            } else {
                oneUser.setBelongUnit("");
            }
            if (obj.has("roomNo")) {
                oneUser.setRoomNo(obj.getString("roomNo"));
            } else {
                oneUser.setRoomNo("");
            }
            if (obj.has("mobile")) {
                oneUser.setMobile(obj.getString("mobile"));
            } else {
                oneUser.setMobile("");
            }
            if (obj.has("powerLevel")) {
                oneUser.setPowerLevel(obj.getInt("powerLevel"));
            } else {
                oneUser.setPowerLevel(1);
            }
            if (obj.has("phoneNo")) {
                oneUser.setPhoneNo(obj.getString("phoneNo"));
            } else {
                oneUser.setPhoneNo("");
            }
            if (obj.has("valid"))
                oneUser.setValid(obj.getInt("valid"));
            if (obj.has("position")) {
                oneUser.setPosition(obj.getString("position"));
            } else {
                oneUser.setPosition("");
            }
            if (obj.has("score"))
                oneUser.setScore(obj.getInt("score"));
            if (obj.has("isHost"))
                oneUser.setIsHost(obj.getInt("isHost"));
            if (obj.has("pushVideoUrl")) {
                oneUser.setPushVideoUrl(obj.getString("pushVideoUrl"));
            } else {
                oneUser.setPushVideoUrl("");
            }
            if (obj.has("belongCompanyID"))
                oneUser.setBelongCompanyID(obj.getInt("belongCompanyID"));
            if (obj.has("defaultPay")) {
                oneUser.setDefaultPay(obj.getString("defaultPay"));
            } else {
                oneUser.setDefaultPay("");
            }
            if (obj.has("hostTag")) {
                oneUser.setHostTag(obj.getString("hostTag"));
            } else {
                oneUser.setHostTag("");
            }
            if (obj.has("city")) {
                oneUser.setCity(obj.getString("city"));
            } else {
                oneUser.setCity("");
            }
            if (obj.has("pic2")) {
                oneUser.setPic2(obj.getString("pic2").replace("'", ""));
            } else {
                oneUser.setPic2("");
            }
            if (obj.has("fansNum")) {
                oneUser.setFansNum(obj.getInt("fansNum"));
            }
            if (obj.has("focusNum")) {
                oneUser.setFocusNum(obj.getInt("focusNum"));
            }
            if (obj.has("sendGiftValue")) {
                oneUser.setSendGiftValue(obj.getInt("sendGiftValue"));
            }
            if (obj.has("receiveGiftValue")) {
                oneUser.setReceiveGiftValue(obj.getInt("receiveGiftValue"));
            }
            if (obj.has("publish")) {
                oneUser.setPublish(obj.getInt("publish"));
            }
            if (obj.has("myMoney")) {
                oneUser.setMyMoney(obj.getInt("myMoney"));
            }
            if (obj.has("streamStatus")) {
                oneUser.setStreamStatus(obj.getInt("streamStatus"));
            }
            if (obj.has("isFocus")) {
                oneUser.setIsFocus(obj.getInt("isFocus"));
            }
            if (obj.has("onlineNum")) {
                oneUser.setOnlineNum(obj.getInt("onlineNum"));
            }
            if (obj.has("hobby")) {
                oneUser.setHobby(obj.getString("hobby"));
            } else {
                oneUser.setHobby("");
            }
            if (obj.has("career")) {
                oneUser.setCareer(obj.getString("career"));
            } else {
                oneUser.setCareer("");
            }
            if (obj.has("videoDirection")) {
                oneUser.setVideoDirection(obj.getInt("videoDirection"));
            }
            if (obj.has("externalID")) {
                oneUser.setExternalID(obj.getString("externalID"));
            }
            if (obj.has("isTester")) {
                oneUser.setIsTester(obj.getInt("isTester"));
            }
            if (obj.has("ownTime")) {
                oneUser.setOwnTime(obj.getInt("ownTime"));
            }
            if (obj.has("timeTotal")) {
                oneUser.setTimeTotal(obj.getInt("timeTotal"));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        JZLiveUser.setUser(oneUser);
    }

    public static JZLiveRecord getJzLiveUser(JSONObject obj) {
        JZLiveRecord liveRecord = new JZLiveRecord();

        try {
            if (obj.has("id")) {
                liveRecord.setId(obj.getInt("id"));
            }
            if (obj.has("title")) {
                liveRecord.setTitle(obj.getString("title"));
            }
            if (obj.has("iconURL")) {
                liveRecord.setIconURL(obj.getString("iconURL"));
            }
            if (obj.has("stream")) {
                liveRecord.setStream(obj.getString("stream"));
            }
            if (obj.has("app")) {
                liveRecord.setApp(obj.getString("app"));
            }
            if (obj.has("videoURL")) {
                liveRecord.setVideoURL(obj.getString("videoURL"));
            }
            if (obj.has("tag")) {
                liveRecord.setTag(obj.getString("tag"));
            }
            if (obj.has("onlineNum")) {
                liveRecord.setOnlineNum(obj.getInt("onlineNum"));
            }
            if (obj.has("startTime")) {
                liveRecord.setStartTime(obj.getInt("startTime"));
            }
            if (obj.has("endTime")) {
                liveRecord.setEndTime(obj.getInt("endTime"));
            }
            if (obj.has("videoTime")) {
                liveRecord.setVideoTime(obj.getInt("videoTime"));
            }
            if (obj.has("videoDirection")) {
                liveRecord.setVideoDirection(obj.getInt("videoDirection"));
            }
            if (obj.has("pic1")) {
                liveRecord.setPic1(obj.getString("pic1"));
            }
            if (obj.has("pic2")) {
                liveRecord.setPic2(obj.getString("pic2"));
            }
            if (obj.has("hostTag")) {
                liveRecord.setHostTag(obj.getString("hostTag"));
            }
            if (obj.has("city")) {
                liveRecord.setCity(obj.getString("city"));
            }
            if (obj.has("userID")) {
                liveRecord.setUserID(obj.getInt("userID"));
            }
            if (obj.has("nickname")) {
                liveRecord.setNickname(obj.getString("nickname"));
            }
            if (obj.has("roomNo")) {
                liveRecord.setRoomNo(obj.getString("roomNo"));
            }
            if (obj.has("receiveGiftValue")) {
                liveRecord.setReceiveGiftValue(obj.getInt("receiveGiftValue"));
            }
            if (obj.has("publish")) {
                liveRecord.setPublish(obj.getInt("publish"));
            }
            if (obj.has("content")) {
                liveRecord.setContent(obj.getString("content"));
            }
            if (obj.has("pushVideoUrl")) {
                liveRecord.setPushVideoUrl(JiZhaAPP.getPushVideoUrl(obj.getString("pushVideoUrl")));
                liveRecord.setLiveH5Url(JiZhaAPP.getLiveH5Url(obj.getString("pushVideoUrl")));
            }
            if (obj.has("type")) {
                liveRecord.setType(obj.getString("type"));
            }
            if (obj.has("planStartTime")) {
                liveRecord.setPlanStartTime(obj.getInt("planStartTime"));
            }
            if (obj.has("activityType")) {
                liveRecord.setActivityType(obj.getInt("activityType"));
            }
            if (obj.has("baibanEnable")) {
                liveRecord.setBaibanEnable(obj.getInt("baibanEnable"));
            }
            if (obj.has("wenjuanEnable")) {
                liveRecord.setWenjuanEnable(obj.getInt("wenjuanEnable"));
            }
            if (obj.has("shopEnable")) {
                liveRecord.setShopEnable(obj.getInt("shopEnable"));
            }
            if (obj.has("payFee")) {
                liveRecord.setPayFee(obj.getInt("payFee"));
            }
            if (obj.has("code")) {
                liveRecord.setCode(obj.getString("code"));
            }
            if (obj.has("createTime")) {
                liveRecord.setCreateTime(obj.getInt("createTime"));
            }
            if (obj.has("love")) {
                liveRecord.setLove(obj.getInt("love"));
            }
            if (obj.has("publishDone")) {
                liveRecord.setPublishDone(obj.getInt("publishDone"));
            }
            if (obj.has("fansNum")) {
                liveRecord.setFansNum(obj.getInt("fansNum"));
            }
            if (obj.has("appointmentNum")) {
                liveRecord.setAppointmentNum(obj.getInt("appointmentNum"));
            }
            if (obj.has("activityID")) {
                liveRecord.setActivityID(obj.getInt("activityID"));
            }
            if (obj.has("isAppointment")) {
                liveRecord.setIsAppointment(obj.getInt("isAppointment"));
            }
            if (obj.has("isFocus")) {
                liveRecord.setIsFocus(obj.getInt("isFocus"));
            }
            if (obj.has("headTime")) {
                liveRecord.setHeadTime(obj.getInt("headTime"));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return liveRecord;

    }
}
