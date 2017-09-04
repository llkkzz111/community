package com.ocj.oms.mobile.third.pay.union;

import android.content.Intent;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.base.BaseActivity;
import com.unionpay.UPPayAssistEx;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by liu on 2017/5/9.
 */

public class UnionPayActivity extends BaseActivity {
    private String mMode = "01";
    private String tn;

    @Override
    protected int getLayoutId() {
        return -1;
    }

    @Override
    protected void initEventAndData() {
        tn = getIntent().getStringExtra("tn");
        UPPayAssistEx.startPay(mContext, null, null, tn, "00");
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        /*************************************************
         * 步骤3：处理银联手机支付控件返回的支付结果
         ************************************************/
        if (data == null) {
            return;
        }

        String msg = "";
        /*
         * 支付控件返回字符串:success、fail、cancel 分别代表支付成功，支付失败，支付取消
         */
        String str = data.getExtras().getString("pay_result");
        if (str.equalsIgnoreCase("success")) {
            // 支付成功后，extra中如果存在result_data，取出校验
            // result_data结构见c）result_data参数说明
            if (data.hasExtra("result_data")) {
                String result = data.getExtras().getString("result_data");
                try {
                    JSONObject resultJson = new JSONObject(result);
                    String sign = resultJson.getString("sign");
                    String dataOrg = resultJson.getString("data");
                    // 验签证书同后台验签证书
                    // 此处的verify，商户需送去商户后台做验签
                    boolean ret = verify(dataOrg, sign, mMode);
                    if (ret) {
                        // 验证通过后，显示支付结果
                        msg = "支付成功！";
                        Intent intent = new Intent();
                        intent.setAction("com.ocj.oms.pay");
                        sendBroadcast(intent);
                    } else {
                        // 验证不通过后的处理
                        // 建议通过商户后台查询支付结果
                        msg = "支付失败！";
                    }
                } catch (JSONException e) {
                }
            } else {
                // 未收到签名信息
                // 建议通过商户后台查询支付结果
                msg = "支付成功！";
                Intent intent = new Intent();
                intent.setAction("com.ocj.oms.pay");
                sendBroadcast(intent);

            }
        } else if (str.equalsIgnoreCase("fail")) {
            msg = "支付失败！";
        } else if (str.equalsIgnoreCase("cancel")) {
            msg = "用户取消了支付";
        }

        ToastUtils.showShortToast(msg);
        finish();
    }

    private boolean verify(String msg, String sign64, String mode) {
        // 此处的verify，商户需送去商户后台做验签
        return true;

    }


}
