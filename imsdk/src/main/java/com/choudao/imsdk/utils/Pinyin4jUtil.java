package com.choudao.imsdk.utils;

import android.text.TextUtils;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.HanyuPinyinVCharType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by liuzhao on 16/8/3.
 */

public class Pinyin4jUtil {
    /***************************************************************************
     * 获取中文汉字拼音 默认输出
     *
     * @param chinese
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:54:01 AM
     */
    public static String getPinyin(String chinese) {
        return getPinyinZh_CN(makeStringByStringSet(chinese));
    }

    /***************************************************************************
     * 拼音大写输出
     *
     * @param chinese
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:58:45 AM
     */
    public static String getPinyinToUpperCase(String chinese) {
        return getPinyinZh_CN(makeStringByStringSet(chinese)).toUpperCase();
    }

    /***************************************************************************
     * 拼音小写输出
     *
     * @param chinese
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:58:45 AM
     */
    public static String getPinyinToLowerCase(String chinese) {
        return getPinyinZh_CN(makeStringByStringSet(chinese)).toLowerCase();
    }

    /***************************************************************************
     * 首字母大写输出
     *
     * @param chinese
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 10:00:54 AM
     */
    public static String getPinyinFirstToUpperCase(String chinese) {
        return getPinyin(chinese);
    }

    /***************************************************************************
     * 拼音简拼输出
     *
     * @param chinese
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 11:08:15 AM
     */
    public static String getPinyinJianPin(String chinese) {
        return getPinyinConvertJianPin(getPinyin(chinese));
    }

    /***************************************************************************
     * 字符集转换
     *
     * @param chinese 中文汉字
     * @throws BadHanyuPinyinOutputFormatCombination
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:34:11 AM
     */
    public static Set<String> makeStringByStringSet(String chinese) {
        char[] chars = chinese.toCharArray();
        if (chinese != null && !chinese.trim().equalsIgnoreCase("")) {
            char[] srcChar = chinese.toCharArray();
            String[][] temp = new String[chinese.length()][];
            for (int i = 0; i < srcChar.length; i++) {
                char c = srcChar[i];

                // 是中文或者a-z或者A-Z转换拼音
                if (String.valueOf(c).matches("[\\u4E00-\\u9FA5]+")) {

                    try {
                        temp[i] = PinyinHelper.toHanyuPinyinStringArray(
                                chars[i], getDefaultOutputFormat());

                    } catch (BadHanyuPinyinOutputFormatCombination e) {
                        e.printStackTrace();
                    }
                } else if (((int) c >= 65 && (int) c <= 90)
                        || ((int) c >= 97 && (int) c <= 122)) {
                    temp[i] = new String[]{String.valueOf(srcChar[i])};
                } else {
                    temp[i] = new String[]{""};
                }
            }
            String[] pingyinArray = exchange(temp);
            Set<String> zhongWenPinYin = new HashSet<String>();
            for (int i = 0; i < pingyinArray.length; i++) {
                zhongWenPinYin.add(pingyinArray[i]);
            }
            return zhongWenPinYin;
        }
        return null;
    }

    /***************************************************************************
     * Default Format 默认输出格式
     *
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:35:51 AM
     */
    public static HanyuPinyinOutputFormat getDefaultOutputFormat() {
        HanyuPinyinOutputFormat format = new HanyuPinyinOutputFormat();
        format.setCaseType(HanyuPinyinCaseType.LOWERCASE);// 小写
        format.setToneType(HanyuPinyinToneType.WITHOUT_TONE);// 没有音调数字
        format.setVCharType(HanyuPinyinVCharType.WITH_U_AND_COLON);// u显示
        return format;
    }

    /***************************************************************************
     * @param strJaggedArray
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:39:54 AM
     */
    public static String[] exchange(String[][] strJaggedArray) {
        String[][] temp = doExchange(strJaggedArray);
        return temp[0];
    }

    /***************************************************************************
     * @param strJaggedArray
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:39:47 AM
     */
    private static String[][] doExchange(String[][] strJaggedArray) {
        int len = strJaggedArray.length;
        if (len >= 2) {
            int len1 = strJaggedArray[0].length;
            int len2 = strJaggedArray[1].length;
            int newlen = len1 * len2;
            String[] temp = new String[newlen];
            int Index = 0;
            for (int i = 0; i < len1; i++) {
                for (int j = 0; j < len2; j++) {
                    temp[Index] = capitalize(strJaggedArray[0][i])
                            + capitalize(strJaggedArray[1][j]);
                    Index++;
                }
            }
            String[][] newArray = new String[len - 1][];
            for (int i = 2; i < len; i++) {
                newArray[i - 1] = strJaggedArray[i];
            }
            newArray[0] = temp;
            return doExchange(newArray);
        } else {
            return strJaggedArray;
        }
    }

    /***************************************************************************
     * 首字母大写
     *
     * @param s
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:36:18 AM
     */
    public static String capitalize(String s) {
        char ch[];
        ch = s.toCharArray();
        if (ch[0] >= 'a' && ch[0] <= 'z') {
            ch[0] = (char) (ch[0] - 32);
        }
        String newString = new String(ch);
        return newString;
    }

    /***************************************************************************
     * 字符串集合转换字符串(逗号分隔)
     *
     * @param stringSet
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:37:57 AM
     */
    public static String getPinyinZh_CN(Set<String> stringSet) {
        StringBuilder str = new StringBuilder();
        int i = 0;
        for (String s : stringSet) {
            if (i == stringSet.size() - 1) {
                str.append(s);
            } else {
                str.append(s + ",");
            }
            i++;
        }
        return str.toString();
    }

    /***************************************************************************
     * 获取每个拼音的简称
     *
     * @param chinese
     * @return
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 11:05:58 AM
     */
    public static String getPinyinConvertJianPin(String chinese) {
        String[] strArray = chinese.split(",");
        String strChar = "";
        for (String str : strArray) {
            char arr[] = str.toCharArray(); // 将字符串转化成char型数组
            for (int i = 0; i < arr.length; i++) {
                if (arr[i] >= 65 && arr[i] < 91) { // 判断是否是大写字母
                    strChar += new String(arr[i] + "");
                }
            }
            strChar += ",";
        }
        return strChar;
    }

    public static String nameHanziToPinyin(String str) {
        if (TextUtils.isEmpty(str)) {
            return "";
        }
        return convertAllPinyin(str);
    }

    private static String convertAllPinyin(String str) {

        char[] charNameArray = str.toCharArray();

        StringBuilder firstPinyinBuilder = new StringBuilder();//首字母
        StringBuilder allPinyinBuilder = new StringBuilder();//全拼音

        HanyuPinyinOutputFormat pinyinFormat = new HanyuPinyinOutputFormat();
        pinyinFormat.setCaseType(HanyuPinyinCaseType.UPPERCASE);
        pinyinFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);

        for (char charName : charNameArray) {
            if (charName > 128) {
                try {
                    // 取得当前汉字的所有全拼
                    String[] strs = PinyinHelper.toHanyuPinyinStringArray(
                            charName, pinyinFormat);
                    if (strs != null && strs.length > 0) {
                        firstPinyinBuilder.append(strs[0].charAt(0));
                        allPinyinBuilder.append(strs[0]);
                    } else {
                        firstPinyinBuilder.append(charName);
                        allPinyinBuilder.append(charName);
//                        System.out.println("BadPinYon: " + charName);
                    }
                } catch (BadHanyuPinyinOutputFormatCombination e) {
                    firstPinyinBuilder.append(charName);
                    allPinyinBuilder.append(charName);
//                    System.out.println("BadPinYon: " + charName);
                }
            } else {
                if (charName >= 97 && charName <= 122) {//小写转大写
                    charName = (char) (charName - 32);
                }
                firstPinyinBuilder.append(charName);
                allPinyinBuilder.append(charName);
            }
        }
        firstPinyinBuilder.append(",");
        return firstPinyinBuilder.toString() + allPinyinBuilder.toString();
    }


    /***************************************************************************
     * Test
     *
     * @param args
     * @Name: Pinyin4jUtil.java
     * @Description: TODO
     * @author: wang_chian@foxmail.com
     * @version: Jan 13, 2012 9:49:27 AM
     */
    public static void main(String[] args) {
        String str = "あ馬が曾志伟 lopper%*()";
//        System.out.println("小写输出：" + getPinyinToLowerCase(str));
//        System.out.println("大写输出：" + getPinyinToUpperCase(str));
//        System.out.println("首字母大写输出：" + getPinyinFirstToUpperCase(str));
//        System.out.println("简拼输出：" + getPinyinJianPin(str));


        System.out.println(convertAllPinyin(str));

    }
}
