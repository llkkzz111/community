package com.ocj.oms.mobile.third.login.qq;

import android.app.Activity;

import com.ocj.oms.mobile.base.App;
import com.ocj.oms.mobile.third.Constants;
import com.ocj.oms.mobile.third.login.ThirdPartyView;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * QQ业务presenter实现
 */

public class QQBusinessPresenterImpl implements QQBusinessContract.QQBusinessPresenter {
    private Activity context;
    private Tencent tencent;
    private String token;
    private String expires;
    private String openID;
    private ThirdPartyView thirdPartyView;

    public QQBusinessPresenterImpl(Activity context, ThirdPartyView thirdPartyView) {
        this.context = context;
        this.thirdPartyView = thirdPartyView;
        tencent = Tencent.createInstance(Constants.QQ_APPID, App.getInstance());
    }


    /**
     * QQ三方授权登录
     * <pre>
     * //必须设置回调
     * protected void onActivityResult(int requestCode, int resultCode, Intent data) {
     *      Tencent.onActivityResultData(requestCode,resultCode,data,iUilistener);
     * }
     * </pre>
     */
    @Override
    public IUiListener qqLogin() {
        IUiListener iUiListener = new QQLoginListener();
        tencent.login(context, Constants.QQ_SCOPE_ALL, iUiListener);
        return iUiListener;
    }


    /**
     * QQ授权登录监听
     * 返回值：
     * {"ret":0,
     * "pay_token":"D3D678728DC580FBCDE15722B72E7365",
     * "pf":"desktop_m_qq-10000144-android-2002-",
     * "query_authority_cost":448,
     * "authority_cost":-136792089,
     * "openid":"015A22DED93BD15E0E6B0DDB3E59DE2D",
     * "expires_in":7776000,
     * "pfkey":"6068ea1c4a716d4141bca0ddb3df1bb9",
     * "msg":"",
     * "access_token":"A2455F491478233529D0106D2CE6EB45",
     * "login_cost":499}
     */
    public class QQLoginListener implements IUiListener {

        @Override
        public void onComplete(Object o) {
            JSONObject jsonObject = (JSONObject) o;
            try {
                token = jsonObject.getString(com.tencent.connect.common.Constants.PARAM_ACCESS_TOKEN);
                expires = jsonObject.getString(com.tencent.connect.common.Constants.PARAM_EXPIRES_IN);
                openID = jsonObject.getString(com.tencent.connect.common.Constants.PARAM_OPEN_ID);
                if (thirdPartyView != null) {
                    thirdPartyView.qqLoginSuccess(jsonObject);
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onError(UiError uiError) {
            String codeMsg;
            switch (uiError.errorCode) {
                case 100044:
                    codeMsg = "错误的sign";
                    break;
                case 110201:
                    codeMsg = "未登录";
                    break;
                case 110401:
                    codeMsg = "请求的应用不存在";
                    break;
                case 110404:
                    codeMsg = "请求参数缺少appid";
                    break;
                case 110405:
                    codeMsg = "登录请求被限制";
                    break;
                case 110406:
                    codeMsg = "应用没有通过审核";
                    break;
                case 110407:
                    codeMsg = "应用已下架";
                    break;
                case 110500:
                    codeMsg = "获取用户授权信息失败";
                    break;
                case 110501:
                    codeMsg = "获取应用授权信息失败";
                    break;
                case 110502:
                    codeMsg = "设置用户授权失败";
                    break;
                case 110503:
                    codeMsg = "获取token失败";
                    break;
                case 110504:
                    codeMsg = "系统内部错误";
                    break;
                default:
                    codeMsg = "未知错误";
                    break;
            }
            codeMsg = "error  " + uiError.errorCode + " : " + codeMsg;
            if (thirdPartyView != null) {
                thirdPartyView.qqLoginFail(codeMsg);
            }
        }

        @Override
        public void onCancel() {
            if (thirdPartyView != null) {
                thirdPartyView.qqLoginFail("onCancel");
            }
        }
    }

}
