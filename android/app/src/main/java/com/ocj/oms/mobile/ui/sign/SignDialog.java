package com.ocj.oms.mobile.ui.sign;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v7.widget.AppCompatButton;
import android.support.v7.widget.AppCompatTextView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.LinearLayout;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.R;

import java.util.ArrayList;
import java.util.Random;
import java.util.concurrent.TimeUnit;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;

/**
 * Created by liutao on 2017/6/12.
 */

public class SignDialog extends Dialog {

    @BindView(R.id.tv1) AppCompatTextView tv1;
    @BindView(R.id.tv2) AppCompatTextView tv2;
    @BindView(R.id.tv3) AppCompatTextView tv3;
    @BindView(R.id.btn_cancel) AppCompatButton btnCancel;
    @BindView(R.id.btn_confirm) AppCompatButton btnConfirm;
    @BindView(R.id.ll_bottom) LinearLayout bottom;

    private Context context;
    private int currentPosition = 1;
    private OnSignButtonClickListener onSignButtonClickListener;
    private ArrayList<String> signStrings;

    public void setOnSignButtonClickListener(OnSignButtonClickListener onSignButtonClickListener) {
        this.onSignButtonClickListener = onSignButtonClickListener;
    }

    public SignDialog(@NonNull Context context) {
        super(context, R.style.MyDialog);
        this.context = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        init();
    }

    public void setCurrentPosition(int position) {
        currentPosition = position;
        setView();
    }

    private void init() {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = LayoutInflater.from(context).inflate(R.layout.dialog_sign_layout, null, false);
        setContentView(view);
        ButterKnife.bind(this);
        signStrings = new ArrayList<>();
        signStrings.add(getContext().getString(R.string.sign_string1));
        signStrings.add(getContext().getString(R.string.sign_string2));
        signStrings.add(getContext().getString(R.string.sign_string3));
        tv1.setText("已签到 " + currentPosition + " 天");
        if (currentPosition < 15) {
            bottom.setVisibility(View.GONE);
            tv2.setText("再签到 " + (15 - currentPosition) + " 天可领福彩礼包哦～");
            countDown();
            return;
        } else if (currentPosition == 15) {
            bottom.setVisibility(View.VISIBLE);
            tv2.setText("恭喜您可领取福彩礼包啦～");
            return;
        } else if (currentPosition < 20) {
            tv2.setText("再签到 " + (20 - currentPosition) + " 天可获得会员礼包哦～");
            bottom.setVisibility(View.GONE);
            countDown();
            return;
        } else if (currentPosition == 20) {
            bottom.setVisibility(View.VISIBLE);
            tv2.setText("恭喜您可领取会员礼包啦～");
            return;
        } else {
            int i = new Random().nextInt(3);
            tv2.setText(signStrings.get(i));
            bottom.setVisibility(View.GONE);
            countDown();
        }
    }

    private void setView() {
        if (tv1 == null) {
            return;
        }
        tv1.setText("已签到 " + currentPosition + " 天");
        if (currentPosition < 15) {
            bottom.setVisibility(View.GONE);
            tv2.setText("再签到 " + (15 - currentPosition) + " 天可领福彩礼包哦～");
            countDown();
        } else if (currentPosition == 15) {
            bottom.setVisibility(View.VISIBLE);
            tv2.setText("恭喜您可领取福彩礼包啦～");
        } else if (currentPosition < 20) {
            tv2.setText("再签到 " + (20 - currentPosition) + " 天可获得会员礼包哦～");
            countDown();
            bottom.setVisibility(View.GONE);
        } else if (currentPosition == 20) {
            tv2.setText("恭喜您可领取会员礼包啦～");
            bottom.setVisibility(View.VISIBLE);
        } else {
            int i = new Random().nextInt(3);
            tv2.setText(signStrings.get(i));
            bottom.setVisibility(View.GONE);
            countDown();
        }
    }

    private void countDown() {
        Observable.interval(0, 1, TimeUnit.SECONDS)//设置0延迟，每隔一秒发送一条数据
                .take(4)
                .map(new Function<Long, Long>() {
                    @Override
                    public Long apply(@io.reactivex.annotations.NonNull Long aLong) throws Exception {
                        return 3 - aLong;
                    }
                })
                .doOnSubscribe(new Consumer<Disposable>() {
                    @Override
                    public void accept(@io.reactivex.annotations.NonNull Disposable disposable) throws Exception {

                    }
                })
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<Long>() {
                    @Override
                    public void onSubscribe(Disposable d) {

                    }

                    @Override
                    public void onNext(Long aLong) {
                        tv3.setText(String.format("%s 秒后自动关闭…", aLong + ""));
                    }

                    @Override
                    public void onError(Throwable e) {

                    }

                    @Override
                    public void onComplete() {
                        dismiss();
                        ToastUtils.showShortToast("您可前往个人中心继续\n领取查看签到礼包哟〜");
                    }
                });
    }


    @OnClick({R.id.btn_cancel, R.id.btn_confirm})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.btn_cancel:
                if (onSignButtonClickListener != null) {
                    onSignButtonClickListener.onCancelClick();
                }
                break;
            case R.id.btn_confirm:
                if (onSignButtonClickListener != null) {
                    onSignButtonClickListener.onConfirmClick(currentPosition);
                }
                break;
        }
    }

    public interface OnSignButtonClickListener {
        void onConfirmClick(int currentPosition);

        void onCancelClick();
    }
}
