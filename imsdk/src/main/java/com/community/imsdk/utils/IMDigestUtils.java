package com.community.imsdk.utils;

import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.digest.DigestUtils;

/**
 * Created by dufeng on 16/9/28.<br/>
 * Description: IMDigestUtils
 */

public class IMDigestUtils {

    public static String sha256Hex(String data) {
        return new String(Hex.encodeHex(DigestUtils.sha256(data)));
    }
}
