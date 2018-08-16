package com.community.equity;

import org.junit.Test;

import java.net.URISyntaxException;

import static com.community.imsdk.utils.Pinyin4jUtil.getPinyinJianPin;
import static com.community.imsdk.utils.Pinyin4jUtil.getPinyinToUpperCase;

/**
 * To work on unit tests, switch the Test Artifact in the Build Variants view.
 */
public class ExampleUnitTest {
    private long time;
    private long ti;

    @Test
    public void addition_isCorrect() throws Exception {

        try {

            String url = "community://login_success#access_token=141c91c5fb0dd34c3c9a21ed57fb19a4d3d6f5c83b14080244f439b8067f1dd6&token_type=bearer";
            for (int i = 0; i < 1000000; i++) {
                loginSuccess(url);
            }
            time = System.currentTimeMillis();

            String str = "曾志伟";
//            System.out.println("小写输出：" + getPinyinToLowerCase(str).toUpperCase());
            System.out.println("大写输出：" + getPinyinToUpperCase(str));
//            System.out.println("首字母大写输出：" + getPinyinFirstToUpperCase(str));
            System.out.println("简拼输出：" + getPinyinJianPin(str).toUpperCase());
            ti = time - System.currentTimeMillis();
            System.out.println("-------------" + ti);

        }catch (Exception e){
            e.printStackTrace();
        }


    }


    private String strTokenType = "token_type=";
    private String strAccessToken = "access_token=";
    private String strReturnTo = "return_to=";


    public void testUri(String url) throws URISyntaxException {
        java.net.URI uri = new java.net.URI(url);
        android.net.Uri androidUri = android.net.Uri.parse("?" + uri.getRawFragment());
        androidUri.getQueryParameter("access_token");
        androidUri.getQueryParameter("token_type");
        androidUri.getQueryParameter("return_to");
    }

    /**
     * 登陆成功之后的相关状态的保存
     *
     * @param url
     */
    private void loginSuccess(String url) {

        int index = url.indexOf(strAccessToken);
        String accessToken = url.substring(url.indexOf(strAccessToken) + strAccessToken.length(), url.indexOf("&token_type"));
        String returnTo = "";
        String tokenType = "";
        if (index > 0) {
            if (url.indexOf("&return_to") > 0) {
                tokenType = url.substring(url.indexOf(strTokenType) + strTokenType.length(), url.indexOf("&return_to"));
                returnTo = url.substring(url.indexOf(strReturnTo) + strReturnTo.length());
            } else {
                tokenType = url.substring(url.indexOf(strTokenType) + strTokenType.length());
            }
        }
        //从消息以及我的界面进入返回MainActivity
    }


}