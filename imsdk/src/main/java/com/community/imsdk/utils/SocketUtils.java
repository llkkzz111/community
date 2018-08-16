package com.community.imsdk.utils;

import java.io.UnsupportedEncodingException;
import java.util.List;

/**
 * Created by dufeng on 16-4-13.
 */
public class SocketUtils {

    /**
     * short转换为字节数组
     *
     * @param shortValue
     * @return
     */
    public static byte[] short2ByteArray(short shortValue) {
        byte[] b = new byte[2];
        for (int i = 0; i < 2; i++) {
            b[i] = (byte) (shortValue >> 8 * (1 - i) & 0xFF);
        }
        return b;
    }

    /**
     * short转换为字节数组
     *
     * @param shortValue
     * @param b
     * @param begin
     * @return
     */
    public static void short2ByteArray(short shortValue, byte[] b, int begin) {
        for (int i = 0; i < 2; i++) {
            b[begin + i] = (byte) (shortValue >> 8 * (1 - i) & 0xFF);
        }
    }

    /**
     * 字节数组转换为short
     *
     * @param b
     * @return
     */
    public static short byteArray2Short(byte[] b) {
        short shortValue = 0;
        for (int i = 0; i < b.length; i++) {
            shortValue += (b[i] & 0xFF) << (8 * (1 - i));
        }
        return shortValue;
    }

    /**
     * 字节数组转换为short
     *
     * @param b
     * @param begin
     * @return
     */
    public static short byteArray2Short(byte[] b, int begin) {
        short shortValue = 0;
        for (int i = 0; i < 2; i++) {
            shortValue += (b[begin + i] & 0xFF) << (8 * (1 - i));
        }
        return shortValue;
    }


    /**
     * int转换为字节数组
     *
     * @param intValue
     * @return
     */
    public static byte[] int2ByteArray(int intValue) {
        byte[] b = new byte[4];
        for (int i = 0; i < 4; i++) {
            b[i] = (byte) (intValue >> 8 * (3 - i) & 0xFF);
        }
        return b;
    }

    /**
     * int转换为字节数组
     *
     * @param intValue
     * @param b
     * @param begin
     */
    public static void int2ByteArray(int intValue, byte[] b, int begin) {
        for (int i = 0; i < 4; i++) {
            b[begin + i] = (byte) (intValue >> 8 * (3 - i) & 0xFF);
        }
    }

    /**
     * 字节数组转换为int
     *
     * @param b
     * @return
     */
    public static int byteArray2Int(byte[] b) {

        int intValue = 0;
        for (int i = 0; i < b.length; i++) {
            intValue += (b[i] & 0xFF) << (8 * (3 - i));
        }
        return intValue;
    }

    /**
     * 字节数组转换为int
     *
     * @param b
     * @param begin
     * @return
     */
    public static int byteArray2Int(byte[] b, int begin) {

        int intValue = 0;
        for (int i = 0; i < 4; i++) {
            intValue += (b[begin + i] & 0xFF) << (8 * (3 - i));
        }
        return intValue;
    }

    /**
     * long转换为字节数组
     *
     * @param longValue
     * @return
     */
    public static byte[] long2ByteArray(long longValue) {
        byte[] b = new byte[8];
        for (int i = 0; i < 8; i++) {
            b[i] = (byte) (longValue >> 8 * (7 - i) & 0xFF);
        }
        return b;
    }

    /**
     * long转换为字节数组
     *
     * @param longValue
     * @return
     */
    public static void long2ByteArray(long longValue, byte[] b, int begin) {
        for (int i = 0; i < 8; i++) {
            b[begin + i] = (byte) (longValue >> 8 * (7 - i) & 0xFF);
        }
    }

    /**
     * 字节数组转换为long
     *
     * @param b
     * @return
     */
    public static long byteArray2Long(byte[] b) {

        long longValue = 0;
        for (int i = 0; i < b.length; i++) {
            longValue += (long) (b[i] & 0xFF) << (8 * (7 - i));
        }
        return longValue;
    }

    /**
     * 字节数组转换为long
     *
     * @param b
     * @param begin
     * @return
     */
    public static long byteArray2Long(byte[] b, int begin) {

        long longValue = 0;
        for (int i = 0; i < 8; i++) {
            longValue += (long) (b[begin + i] & 0xFF) << (8 * (7 - i));
        }
        return longValue;
    }

    /**
     * String转换为字节数组
     *
     * @param stringValue
     * @return
     */
    public static byte[] string2ByteArray(String stringValue) {
        byte[] b = new byte[0];
        try {
            b = stringValue.getBytes("UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return b;
    }

    /**
     * String转换为字节数组
     *
     * @param msgType
     * @param b
     * @param index
     */
    public static void string2ByteArray(String msgType, byte[] b, int index) {
        try {
            byte[] bytes = msgType.getBytes("UTF-8");
            System.arraycopy(bytes, 0, b, index, bytes.length);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }

    /**
     * 字节数组转换为String
     *
     * @param b
     * @return
     */
    public static String byteArray2String(byte[] b) {
        String str = "";
        try {
            str = new String(b, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return str;
    }

    /**
     * 字节数组转换为String
     *
     * @param b
     * @return
     */
    public static String byteArray2String(byte[] b, int begin, int length) {
        String str = "";
        try {
            str = new String(b, begin, length, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return str;
    }


    public static byte[] arraycopy(List<byte[]> srcArrays) {
        int len = 0;
        for (byte[] srcArray : srcArrays) {
            len += srcArray.length;
        }

        byte[] destArray = new byte[len];
        int destLen = 0;
        for (byte[] srcArray : srcArrays) {
            System.arraycopy(srcArray, 0, destArray, destLen, srcArray.length);
            destLen += srcArray.length;
        }

        return destArray;
    }

}
