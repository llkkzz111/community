package com.community.equity.utils;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.style.ClickableSpan;
import android.view.View;

import com.alibaba.fastjson.JSON;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by dufeng on 16/5/27.<br/>
 * Description: TextConverters
 */
public class TextConverters {


    private static SystemMsg convertSysMsg(String strMsg) {
        String pattern = "<\\s*([^<>\\|]*)\\s*\\|\\s*([a-zA-Z]*://[^<>\\|]*)\\s*/>";
        Pattern r = Pattern.compile(pattern);
        Matcher m = r.matcher(strMsg);

        int index = 0;
        StringBuilder stringBuilder = new StringBuilder();
        SystemMsg systemMsg = new SystemMsg();

        while (m.find()) {
            SystemMsg.SysMsgBean msgBean = new SystemMsg.SysMsgBean();
            msgBean.start = m.start(0);
            msgBean.end = m.end(0);
            msgBean.text = m.group(1).trim();
            msgBean.urlValue = m.group(2).trim();
            systemMsg.list.add(msgBean);

            /** 拼接字符串 */
            stringBuilder.append(strMsg.substring(index, msgBean.start))
                    .append(msgBean.text);
            index = msgBean.end;
        }
        if (index != strMsg.length() - 1) {
            stringBuilder.append(strMsg.substring(index));
        }

        if (systemMsg.list.size() == 0) {
            systemMsg.showText = strMsg;
        } else {
            systemMsg.showText = stringBuilder.toString();
        }
        return systemMsg;
    }

    public static String convertSysText(String strMsg) {
        return convertSysMsg(strMsg).showText;
    }

    public static SpannableString convertSpannableString(final Context context, String strMsg) {
        SystemMsg systemMsg = convertSysMsg(strMsg);
        SpannableString spannableString = new SpannableString(systemMsg.showText);

        //匹配字符串起始位置的偏移量
        int offset = 0;

        for (int i = 0; i < systemMsg.list.size(); i++) {
            final SystemMsg.SysMsgBean msgBean = systemMsg.list.get(i);

            int start = msgBean.start - offset;
            int end = start + msgBean.text.length();

            offset += msgBean.end - msgBean.start - msgBean.text.length();

            spannableString.setSpan(new ClickableSpan() {
                @Override
                public void onClick(View widget) {
                    Intent intent = new Intent("com.community.equity.action");
                    Uri uri = Uri.parse(msgBean.urlValue);
                    intent.setData(uri);
                    context.startActivity(intent);
                }

                @Override
                public void updateDrawState(TextPaint ds) {
                    ds.setColor(0xff00b476);
                    ds.setUnderlineText(false);
                }

            }, start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        }

        return spannableString;
    }


    public static void main(String[] args) {
//        String str = "sds<shikinami|community://user_show?id=999999&name=1123 />回答了问题<www.chouwww.community.com这个网站里有很多好玩的wwwww.community.com这个网站里有很多好玩的w.community.com这个网站里有很多好玩的dao.com这个网站里有很多好玩的|question://id:5 />lalallal";
//        String str = "l<我也不知道谁是谁|community://user/profile?id=586309 />回答了问题<啦啦啦啦啦啦啦，测试|community://question/show?id=512 />";
//        String str = "<qinju_1442307146170|community://user/profile?id=571553 />回答了问题<好1 去2 3。 4。 5 8\\n1\\n 7x|community://question/show?id=458 />";
        String str = "很抱歉，你们还不是好友关系，请先发送好友验证请求，对方验证通过后，才能聊天。<发送好友验证|community://friend/verification?id=586309 />";
        SystemMsg systemMsg = convertSysMsg(str);
        System.out.println(JSON.toJSON(systemMsg));
        System.out.println(systemMsg.showText);
    }

    public static class SystemMsg {
        public List<SysMsgBean> list = new ArrayList<>();
        public String showText;

        public static class SysMsgBean {
            public int start;
            public int end;
            public String text;
            public String urlValue;
        }

    }
}