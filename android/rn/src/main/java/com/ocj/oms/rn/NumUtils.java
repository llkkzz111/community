package com.ocj.oms.rn;

import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.uimanager.FloatUtil;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by liu on 2017/6/3.
 */

public class NumUtils {
    public static String parseString(float num) {
        BigDecimal decimal = new BigDecimal(num);
        return decimal.setScale(2, BigDecimal.ROUND_HALF_UP).toString();
    }

    public static String parseString(int num) {
        BigDecimal decimal = new BigDecimal(num);
        return decimal.setScale(0, BigDecimal.ROUND_HALF_UP).toString();
    }

    public static int parseInt(String num) {
        BigDecimal decimal = new BigDecimal(num);
        return decimal.intValue();
    }


    /**
     * 把汉字转拼音
     *
     * @param chines
     * @return
     */
    public static String converterToSpell(String chines) {
        String pinyinName = "";
        char[] nameChar = chines.toCharArray();
        HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
        defaultFormat.setCaseType(HanyuPinyinCaseType.LOWERCASE);
        defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
        for (int i = 0; i < nameChar.length; i++) {
            if (nameChar[i] > 128) {
                try {
                    pinyinName += PinyinHelper.toHanyuPinyinStringArray(nameChar[i], defaultFormat)[0];
                } catch (BadHanyuPinyinOutputFormatCombination e) {
                    e.printStackTrace();
                }
            } else {
                pinyinName += nameChar[i];
            }
        }
        return pinyinName;
    }

    public static WritableArray getSortedList(List<String> list) {
        ArrayList<String> arrayList = new ArrayList<>();
        for (int i = 0; i < list.size(); i++) {
            arrayList.add(converterToSpell(list.get(i)));
        }
        Collections.sort(arrayList);
        WritableArray writableArray = new WritableNativeArray();
        for (int j = 0; j < list.size(); j++) {
            writableArray.pushString(arrayList.get(j));
        }
        return writableArray;
    }

    public static boolean checkStringIsNum(String value) {
        try {
            int num = Integer.valueOf(value);//把字符串强制转换为数字
            return true;//如果是数字，返回True
        } catch (Exception e) {
            return false;//如果抛出异常，返回False
        }
    }

    public static float getFloat(float num){
        BigDecimal decimal = new BigDecimal(num);
        return Float.valueOf(decimal.setScale(2, BigDecimal.ROUND_HALF_UP).toString());
    }
}
