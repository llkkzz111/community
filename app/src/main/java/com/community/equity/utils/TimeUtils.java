package com.community.equity.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by dufeng on 16/5/6.<br/>
 * Description: TimeUtils
 */
public class TimeUtils {

    public static String getFormatDate(long time) {
        return formatDateByFormat(new Date(time), "yyyy-MM-dd HH:mm");
    }

    /**
     * 获得口头时间字符串，如今天，昨天等
     *
     * @return 口头时间字符串
     */
    public static String getTimeInterval(long time) {

        Calendar ca = Calendar.getInstance();
        ca.setTimeInMillis(time);
        int year = ca.get(Calendar.YEAR);
        int month = ca.get(Calendar.MONTH);
//        int week = ca.get(Calendar.WEEK_OF_MONTH);
        int day = ca.get(Calendar.DAY_OF_WEEK);
//        int hour = ca.get(Calendar.HOUR_OF_DAY);
//        int minute = ca.get(Calendar.MINUTE);

        Calendar now = Calendar.getInstance();
        long nowTime = System.currentTimeMillis();
        now.setTimeInMillis(nowTime);
        int nowYear = now.get(Calendar.YEAR);
        int nowMonth = now.get(Calendar.MONTH);
//        int nowWeek = now.get(Calendar.WEEK_OF_MONTH);
        int nowDay = now.get(Calendar.DAY_OF_WEEK);
//        int nowHour = now.get(Calendar.HOUR_OF_DAY);
//        int nowMinute = now.get(Calendar.MINUTE);


        Date date = new Date(time);

        if (year != nowYear) {
            //不同年份
            return formatDateByFormat(date, "yyyy年M月d日 HH:mm");
        } else {
            if (month != nowMonth) {
                //不同月份
                return formatDateByFormat(date, "M月d日 HH:mm");
            } else {
                if (day != nowDay) {
                    if (day + 1 == nowDay) {
                        return "昨天 " + formatDateByFormat(date, "HH:mm");
                    }
                    if (day + 2 == nowDay) {
                        return "前天 " + formatDateByFormat(date, "HH:mm");
                    }
                    //不同天
                    return formatDateByFormat(date, "M月d日 HH:mm");
                } else {
                    //同一天
//                    long timeInterval = (nowTime - time) / 1000;//间隔几秒
//                    if (timeInterval < 3600) {
//                        //一小时内
//                        long minuteInterval = timeInterval / 60;
//                        if (minuteInterval < 1) {
//                            return "刚刚";
//                        } else {
//                            return minuteInterval + "分钟前";
//                        }
//                    } else {
                    return formatDateByFormat(date, "HH:mm");
//                    }
                }
            }
        }
    }


    /**
     * 获得口头时间字符串，如今天，昨天等
     *
     * @return 口头时间字符串
     */
    public static String getSimpleTimeInterval(long time) {

        Calendar ca = Calendar.getInstance();
        ca.setTimeInMillis(time);
        int year = ca.get(Calendar.YEAR);
        int month = ca.get(Calendar.MONTH);
//        int week = ca.get(Calendar.WEEK_OF_MONTH);
        int day = ca.get(Calendar.DAY_OF_WEEK);
//        int hour = ca.get(Calendar.HOUR_OF_DAY);
//        int minute = ca.get(Calendar.MINUTE);

        Calendar now = Calendar.getInstance();
        long nowTime = System.currentTimeMillis();
        now.setTimeInMillis(nowTime);
        int nowYear = now.get(Calendar.YEAR);
        int nowMonth = now.get(Calendar.MONTH);
//        int nowWeek = now.get(Calendar.WEEK_OF_MONTH);
        int nowDay = now.get(Calendar.DAY_OF_WEEK);
//        int nowHour = now.get(Calendar.HOUR_OF_DAY);
//        int nowMinute = now.get(Calendar.MINUTE);


        Date date = new Date(time);

        if (year != nowYear) {
            //不同年份
            return formatDateByFormat(date, "y/M/d");
        } else {
            if (month != nowMonth) {
                //不同月份
                return formatDateByFormat(date, "M/d");
            } else {
                if (day != nowDay) {
                    if (day + 1 == nowDay) {
                        return "昨天";
                    }
                    if (day + 2 == nowDay) {
                        return "前天";
                    }
                    //不同天
                    return formatDateByFormat(date, "M/d");
                } else {
                    //同一天
//                    long timeInterval = (nowTime - time) / 1000;//间隔几秒
//                    if (timeInterval < 3600) {
//                        //一小时内
//                        long minuteInterval = timeInterval / 60;
//                        if (minuteInterval < 1) {
//                            return "刚刚";
//                        } else {
//                            return minuteInterval + "分钟前";
//                        }
//                    } else {
                    return formatDateByFormat(date, "HH:mm");
//                    }
                }
            }
        }
    }


    /**
     * 获得口头时间字符串，如今天，昨天等
     *
     * @return 口头时间字符串
     */
    public static String getCommunityTimeInterval(long time) {

        Calendar ca = Calendar.getInstance();
        ca.setTimeInMillis(time);
        int year = ca.get(Calendar.YEAR);
        int month = ca.get(Calendar.MONTH);
//        int week = ca.get(Calendar.WEEK_OF_MONTH);
        int day = ca.get(Calendar.DAY_OF_WEEK);
//        int hour = ca.get(Calendar.HOUR_OF_DAY);
//        int minute = ca.get(Calendar.MINUTE);

        Calendar now = Calendar.getInstance();
        long nowTime = System.currentTimeMillis();
        now.setTimeInMillis(nowTime);
        int nowYear = now.get(Calendar.YEAR);
        int nowMonth = now.get(Calendar.MONTH);
//        int nowWeek = now.get(Calendar.WEEK_OF_MONTH);
        int nowDay = now.get(Calendar.DAY_OF_WEEK);
//        int nowHour = now.get(Calendar.HOUR_OF_DAY);
//        int nowMinute = now.get(Calendar.MINUTE);


        Date date = new Date(time);

        if (year != nowYear) {
            //不同年份
            return formatDateByFormat(date, "yyyy年M月d日 HH:mm");
        } else {
            if (month != nowMonth) {
                //不同月份
                return formatDateByFormat(date, "M月d日 HH:mm");
            } else {
                if (day != nowDay) {
                    if (day + 1 == nowDay) {
                        return "昨天 " + formatDateByFormat(date, "HH:mm");
                    }
                    if (day + 2 == nowDay) {
                        return "前天 " + formatDateByFormat(date, "HH:mm");
                    }
                    //不同天
                    return formatDateByFormat(date, "M月d日 HH:mm");
                } else {
                    //同一天
                    long timeInterval = (nowTime - time) / 1000;//间隔几秒
                    if (timeInterval < 3600) {
                        //一小时内
                        long minuteInterval = timeInterval / 60;
                        if (minuteInterval < 1) {
                            return "刚刚";
                        } else {
                            return minuteInterval + "分钟前";
                        }
                    } else {
                        return formatDateByFormat(date, "HH:mm");
                    }
                }
            }
        }
    }


    /**
     * 以指定的格式来格式化日期
     *
     * @param date   Date 日期
     * @param format String 格式
     * @return String 日期字符串
     */
    public static String formatDateByFormat(Date date, String format) {
        String result = "";
        if (date != null) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(format);
                result = sdf.format(date);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return result;
    }


    /**
     * 日期字符串转换为日期
     *
     * @param date    日期字符串
     * @param pattern 格式
     * @return 日期
     */
    public static Date formatStringByFormat(String date, String pattern) {
        SimpleDateFormat sdf = new SimpleDateFormat(pattern);
        try {
            return sdf.parse(date);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
    }

//    public static void main(String[] args) {
//        System.out.println(getSimpleTimeInterval(1433379694000L));
//        System.out.println(getTimeInterval(1433379694000L));
//    }
}
