package com.ocj.oms.mobile.ui.sign;

import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.SignBean;
import com.ocj.oms.mobile.bean.SignPacksBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.oms.utils.OCJPreferencesUtils;

/**
 * Created by liutao on 2017/6/13.
 * 可拖动布局
 */

public class DragRelativeLayout extends RelativeLayout {

    /**
     * 拖动目标
     */
    private ImageView ivDrag;

    private TextView signRight;
    private TextView signLeft;
    private Context mContext;

    private SignDialog signDialog;
    private LotteryDialog lotteryDialog;

    private int width, height;
    private int screenWid, screenHei;

    private boolean isClickDrag = false;
    private boolean isTouchDrag = false;

    public final static int LEFT = 1;
    public final static int RIGHT = 2;

    private float startX, startY;
    private int currentPosition = 2;

    private DragImageClickListener dragImageListener;

    public void setDragImageListener(DragImageClickListener dragImageListener) {
        this.dragImageListener = dragImageListener;
    }

    public interface DragImageClickListener {
        void onClick(int currentPosition);
    }

    public DragRelativeLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        mContext = context;
    }

    public DragRelativeLayout(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        mContext = context;
    }

    public DragRelativeLayout(Context context) {
        super(context);
        mContext = context;
    }

    public void initView() {
        ivDrag = (ImageView) findViewById(R.id.iv_drag);
        LayoutParams params = (LayoutParams) ivDrag
                .getLayoutParams();
        params.setMargins(DensityUtil.getScreenW(mContext) - DensityUtil.dip2px(mContext, 51),
                (DensityUtil.getScreenH(mContext) - DensityUtil.dip2px(mContext, 113)) / 2, 0, (DensityUtil.getScreenH(mContext) - DensityUtil.dip2px(mContext, 113)) / 2);
        ivDrag.setLayoutParams(params);
        requestLayout();
        signRight = (TextView) findViewById(R.id.tv_sign_right);
        signLeft = (TextView) findViewById(R.id.tv_sign_left);
        signDialog = new SignDialog(mContext);
        lotteryDialog = new LotteryDialog(mContext);
        signDialog.setOnSignButtonClickListener(new SignDialog.OnSignButtonClickListener() {
            @Override
            public void onConfirmClick(int currentPosition) {
                if (currentPosition == 15) {
                    lotteryDialog.show();
                    signDialog.dismiss();
                } else if (currentPosition == 20) {
                    signGetPacks();
                }
            }

            @Override
            public void onCancelClick() {
                signDialog.dismiss();
                ToastUtils.showShortToast("您可前往个人中心继续\n领取查看签到礼包哟〜");
            }
        });
        signDialog.setOnKeyListener(new DialogInterface.OnKeyListener() {
            @Override
            public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
                if (keyCode == KeyEvent.KEYCODE_BACK) {
                    return true;
                }
                return false;
            }
        });
        lotteryDialog.setOnLotteryButtonClickListener(new LotteryDialog.OnLotteryButtonClickListener() {
            @Override
            public void onConfirmClick(String name, String id, String phone) {
                signGetLottery(name, id, phone);
            }

            @Override
            public void onCancelClick() {
                lotteryDialog.dismiss();
            }
        });
        signRight.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                sign();
            }
        });
        signLeft.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                sign();
            }
        });
    }

    private void signGetLottery(String name, String id, String phone) {
        new AccountMode(mContext).signGetLottery(name, phone, id, OCJPreferencesUtils.getAccessToken(), new ApiResultObserver<String>(mContext) {
            @Override
            public void onSuccess(String apiResult) {
                lotteryDialog.dismiss();
            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }
        });
    }

    private void signGetPacks() {
        new AccountMode(mContext).signGetPacks(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<SignPacksBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
            }

            @Override
            public void onNext(ApiResult<SignPacksBean> resultApiResult) {
//                ToastUtils.showShortToast(resultApiResult.getMessage());
                if (signDialog.isShowing()) {
                    signDialog.dismiss();
                }
            }
        });
    }

    private void sign() {
        new AccountMode(mContext).sign(OCJPreferencesUtils.getAccessToken(), new ApiObserver<ApiResult<SignBean>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                signRight.setVisibility(View.GONE);
                signLeft.setVisibility(View.GONE);
            }

            @Override
            public void onNext(ApiResult<SignBean> signBeanApiResult) {
//                ToastUtils.showShortToast(signBeanApiResult.getMessage());
                if (signRight.getVisibility() == View.VISIBLE || signLeft.getVisibility() == View.VISIBLE) {
                    signDialog.setCurrentPosition(signBeanApiResult.getData().getDays());
                    signDialog.show();
                }
                signRight.setVisibility(View.GONE);
                signLeft.setVisibility(View.GONE);
            }
        });
    }

    public void dragInit(View view) {
        screenWid = getWidth();
        screenHei = getHeight();
        width = view.getWidth();
        height = view.getHeight();
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {
        switch (ev.getAction()) {
            case MotionEvent.ACTION_DOWN:
                float x = ev.getX();
                float y = ev.getY();
                Rect frame = new Rect();
                dragInit(ivDrag);
                ivDrag.getHitRect(frame);
                if (frame.contains((int) (x), (int) (y))) {
                    isTouchDrag = true;
                    startX = x;
                    startY = y;
                    return true;
                }
                break;
        }
        return false;
    }

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        float x = event.getX();
        float y = event.getY();
        Rect frame = new Rect();
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                ivDrag.getHitRect(frame);
                if (frame.contains((int) (x), (int) (y))) {
                    startX = x;
                    startY = y;
                    isTouchDrag = true;
                    isClickDrag = true;
                } else {
                    if (signRight.getVisibility() == View.VISIBLE) {
                        signRight.setVisibility(View.GONE);
                    }
                    if (signLeft.getVisibility() == View.VISIBLE) {
                        signLeft.setVisibility(View.GONE);
                    }
                }
                break;
            case MotionEvent.ACTION_MOVE:
                ivDrag.getHitRect(frame);
                float distanceX = Math.abs(x - startX);
                float distanceY = Math.abs(y - startY);

                if (Math.sqrt(distanceY * distanceY + distanceX * distanceX) > 10) {
                    isClickDrag = false;
                }
                if (!isClickDrag && isTouchDrag) {
                    move(x, y);
                }
                break;
            case MotionEvent.ACTION_CANCEL:
                isClickDrag = false;
                isTouchDrag = false;
                break;
            case MotionEvent.ACTION_UP:
                if (isClickDrag) {
                    if (dragImageListener != null) {
                        dragImageListener.onClick(currentPosition);
                    }
                    if (currentPosition == DragRelativeLayout.RIGHT) {
                        if (signRight.getVisibility() == View.GONE) {
                            signRight.setVisibility(View.VISIBLE);
                        } else {
                            signRight.setVisibility(View.GONE);
                        }
                    } else if (currentPosition == DragRelativeLayout.LEFT) {
                        if (signLeft.getVisibility() == View.GONE) {
                            signLeft.setVisibility(View.VISIBLE);
                        } else {
                            signLeft.setVisibility(View.GONE);
                        }
                    }
                } else if (isTouchDrag) {
                    int minType = getDirection(x, y);
                    switch (minType) {
                        case LEFT:
                            x = 0;
                            break;
                        case RIGHT:
                            x = screenWid;
                            break;
                    }
                    move(x, y);
                }
                isClickDrag = false;
                isTouchDrag = false;
                break;
            case MotionEvent.ACTION_OUTSIDE:
                isClickDrag = false;
                isTouchDrag = false;
                break;
        }
        return true;
    }


    private int getDirection(float x, float y) {
        if (x <= (screenWid - x)) {
            ivDrag.setImageResource(R.drawable.icon_sign_left);
            currentPosition = LEFT;
            return LEFT;
        } else {
            ivDrag.setImageResource(R.drawable.icon_sign_right);
            currentPosition = RIGHT;
            return RIGHT;
        }
    }

    private void move(float x, float y) {
        if (signRight.getVisibility() == View.VISIBLE) {
            signRight.setVisibility(View.GONE);
        }
        if (signLeft.getVisibility() == View.VISIBLE) {
            signLeft.setVisibility(View.GONE);
        }
        int left = (int) (x - width / 2);
        int top = (int) (y - height / 2);

        if (left <= 0)
            left = 0;
        if (top <= 0)
            top = 0;

        if (left > screenWid - width)
            left = screenWid - width;
        if (top > screenHei - height)
            top = screenHei - height;

        LayoutParams params = (LayoutParams) ivDrag
                .getLayoutParams();
        params.setMargins(left, top, (screenWid - left - width), (screenHei
                - top - height));
        ivDrag.setLayoutParams(params);
        requestLayout();
    }
}
