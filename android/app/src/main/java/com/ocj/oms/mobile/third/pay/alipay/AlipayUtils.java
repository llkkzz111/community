package com.ocj.oms.mobile.third.pay.alipay;

import android.app.Activity;
import android.content.Intent;
import android.text.TextUtils;

import com.alipay.sdk.app.PayTask;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.IntentKeys;

import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;

/**
 * Created by liu on 2017/5/10.
 */

public class AlipayUtils {

    public static void alipayPay(final Activity mContext, final String result, final String OrderNo) {
        final PayTask payTask = new PayTask(mContext);
        Observable.just("")
                .subscribeOn(Schedulers.io())
                .map(new Function<String, PayResult>() {
                    @Override
                    public PayResult apply(String authInfo) throws Exception {

                        return new PayResult(payTask.payV2(result, true));
                    }
                })
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<PayResult>() {
                    @Override
                    public void onSubscribe(Disposable d) {
                    }

                    @Override
                    public void onNext(PayResult payResult) {

                        /**
                         * 同步返回的结果必须放置到服务端进行验证（验证的规则请看https://doc.open.alipay.com/doc2/
                         * detail.htm?spm=0.0.0.0.xdvAU6&treeId=59&articleId=103665&
                         * docType=1) 建议商户依赖异步通知
                         */
                        String resultInfo = payResult.getResult();// 同步返回需要验证的信息

                        String resultStatus = payResult.getResultStatus();
                        // 判断resultStatus 为“9000”则代表支付成功，具体状态码代表含义可参考接口文档
                        if (TextUtils.equals(resultStatus, "9000")) {
                            ToastUtils.showShortToast("支付成功");
                            Intent intent = new Intent();
                            intent.setAction("com.ocj.oms.pay");
                            intent.putExtra(IntentKeys.ORDER_NO, OrderNo);
                            mContext.sendBroadcast(intent);

                        } else {
                            ToastUtils.showShortToast(payResult.getMemo());
                        }


                    }

                    @Override
                    public void onError(Throwable e) {
                    }

                    @Override
                    public void onComplete() {
                    }
                });

    }


}
