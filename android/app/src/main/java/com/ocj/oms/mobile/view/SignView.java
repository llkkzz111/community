package com.ocj.oms.mobile.view;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.App;
import com.ocj.oms.utils.DensityUtil;

/**
 * 签到控件view
 * Created by shizhang.cai on 2017/6/11.
 */

public class SignView extends View {
    private static final String TAG = SignView.class.getSimpleName();
    private Context context;
    private final int MARGIN = DensityUtil.dip2px(App.getInstance(), 40);

    private int currentPosition = 0;
    private boolean isLottery;
    private boolean isSignPacks;
    private OnItemClickListener onItemClickListener;

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {
        this.onItemClickListener = onItemClickListener;
    }

    public SignView(Context context) {
        super(context);
        this.context = context;
    }

    public SignView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
    }

    public SignView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        this.context = context;
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        drawRound(canvas);
        drawLine(canvas);
        drawText(canvas);
        drawProgress(canvas);
        drawImg(canvas);
    }

    private void drawRound(Canvas canvas) {
        //圆圈画笔
        Paint roundPath = new Paint();
        roundPath.setAntiAlias(true);
        roundPath.setColor(getContext().getResources().getColor(R.color.white));
        roundPath.setStrokeWidth(2);
        int roundy = getHeight() / 2;
        Log.i(TAG, "roundy:" + roundy);
        canvas.drawCircle(MARGIN, roundy, DensityUtil.dip2px(context, 4), roundPath);
        canvas.drawCircle(getWidth() - MARGIN, roundy, DensityUtil.dip2px(context, 4), roundPath);
        if (currentPosition < 15) {
            canvas.drawCircle((getWidth() - MARGIN * 2) / 19 * 14 + MARGIN, roundy, DensityUtil.dip2px(context, 4), roundPath);
        }
    }

    private void drawLine(Canvas canvas) {
        //圆圈画笔
        Paint linePaint = new Paint();
        int roundy = getHeight() / 2;
        linePaint.setColor(getContext().getResources().getColor(R.color.white));
        linePaint.setStrokeWidth(DensityUtil.dip2px(context, 4));
        canvas.drawLine(MARGIN, roundy, getWidth() - MARGIN, roundy, linePaint);
    }

    private void drawImg(Canvas canvas) {
        //圆圈画笔
        Paint paint = new Paint();
        paint.setAntiAlias(true);
        Bitmap nodeImg = BitmapFactory.decodeResource(getResources(), R.drawable.icon_node_select);
        Bitmap rightImg = BitmapFactory.decodeResource(getResources(), R.drawable.icon_right);
        Bitmap rightYellowImg = BitmapFactory.decodeResource(getResources(), R.drawable.icon_right_yellow);
        Bitmap rewardImg = BitmapFactory.decodeResource(getResources(), R.drawable.icon_reward_yellow);
        Bitmap rewardWhiteImg = BitmapFactory.decodeResource(getResources(), R.drawable.icon_reward_white);
        int roundy = getHeight() / 2;
        int nodeHeight = nodeImg.getHeight();
        if (currentPosition < 15) {
            canvas.drawBitmap(rightImg, getWidth() - MARGIN - rightImg.getWidth() / 2, roundy - rightImg.getHeight() - DensityUtil.dip2px(context, 10), paint);
            canvas.drawBitmap(rewardWhiteImg, (getWidth() - MARGIN * 2) / 19 * 14 + MARGIN - rewardWhiteImg.getWidth() / 2, roundy - rewardWhiteImg.getHeight() - DensityUtil.dip2px(context, 10), paint);
        } else if (currentPosition < 20) {
            if (!isLottery) {
                canvas.drawBitmap(rewardImg, (getWidth() - MARGIN * 2) / 19 * 14 + MARGIN - rewardImg.getWidth() / 2, roundy - rewardImg.getHeight() - nodeImg.getHeight() / 2, paint);
            }
            canvas.drawBitmap(nodeImg, (getWidth() - MARGIN * 2) / 19 * 14 + MARGIN - nodeImg.getWidth() / 2, roundy - nodeHeight / 2, paint);
            canvas.drawBitmap(rightImg, getWidth() - MARGIN - rightImg.getWidth() / 2, roundy - rightImg.getHeight() - DensityUtil.dip2px(context, 10), paint);
        } else if (currentPosition >= 20) {
            canvas.drawBitmap(nodeImg, (getWidth() - MARGIN * 2) / 19 * 14 + MARGIN - nodeImg.getWidth() / 2, roundy - nodeHeight / 2, paint);
            if (!isLottery) {
                canvas.drawBitmap(rewardImg, (getWidth() - MARGIN * 2) / 19 * 14 + MARGIN - rewardImg.getWidth() / 2, roundy - rewardImg.getHeight() - nodeImg.getHeight() / 2, paint);
            }
            canvas.drawBitmap(nodeImg, getWidth() - MARGIN - nodeImg.getWidth() / 2, roundy - nodeHeight / 2, paint);
            if (!isSignPacks) {
                canvas.drawBitmap(rightYellowImg, getWidth() - MARGIN - rightYellowImg.getWidth() / 2, roundy - rightYellowImg.getHeight() - DensityUtil.dip2px(context, 10), paint);
            }
        }
    }

    private void drawText(Canvas canvas) {
        //圆圈画笔
        Paint textPaint = new Paint();
        textPaint.setAntiAlias(true);
        textPaint.setStrokeWidth(4);
        textPaint.setTextSize(DensityUtil.sp2px(context, 12));
        textPaint.setColor(getContext().getResources().getColor(R.color.white));
        canvas.drawText("第1天", MARGIN - getTextWidth(textPaint, "第1天") / 2, getHeight() / 2 + getFontHeight(DensityUtil.sp2px(context, 12)) + DensityUtil.dip2px(context, 5), textPaint);
        canvas.drawText("第20天", getWidth() - MARGIN - getTextWidth(textPaint, "第20天") / 2, getHeight() / 2 + getFontHeight(DensityUtil.sp2px(context, 12)) + DensityUtil.dip2px(context, 5), textPaint);
        canvas.drawText("第15天", (getWidth() - MARGIN * 2) / 19 * 14 + MARGIN - getTextWidth(textPaint, "第15天") / 2, getHeight() / 2 + getFontHeight(DensityUtil.sp2px(context, 12)) + DensityUtil.dip2px(context, 5), textPaint);
    }

    private void drawProgress(Canvas canvas) {
        if (currentPosition <= 0) {
            return;
        }
        Paint roundPath = new Paint();
        roundPath.setAntiAlias(true);
        roundPath.setColor(getContext().getResources().getColor(R.color.sign_yellow));
        roundPath.setStrokeWidth(2);
        int roundy = getHeight() / 2;
        Log.i(TAG, "roundy:" + roundy);
        canvas.drawCircle(MARGIN, roundy, DensityUtil.dip2px(context, 2), roundPath);
        roundPath.setStrokeWidth(DensityUtil.dip2px(context, 2));
        canvas.drawLine(MARGIN + DensityUtil.dip2px(context, 2), roundy, (getWidth() - MARGIN * 2) / 19 * (currentPosition - 1) + MARGIN, roundy, roundPath);
        if (currentPosition == 20) {
            roundPath.setStrokeWidth(2);
            canvas.drawCircle(getWidth() - MARGIN, roundy, DensityUtil.dip2px(context, 2), roundPath);
        }
    }


    public void setCurrentPosition(int position) {
        if (position < 0) {
            return;
        }
        if (position > 20) {
            position = 20;
        }
        currentPosition = position;
        invalidate();
    }

    public void setCurrentPosition(int position, boolean isLottery, boolean isSignPacks) {
        if (position < 0) {
            return;
        }
        if (position > 20) {
            position = 20;
        }
        this.isLottery = isLottery;
        this.isSignPacks = isSignPacks;
        currentPosition = position;
        invalidate();
    }

    public void setLottery(boolean lottery) {
        isLottery = lottery;
        invalidate();
    }

    public void setSignPacks(boolean signPacks) {
        isSignPacks = signPacks;
        invalidate();
    }

    /**
     * 计算文字宽度
     *
     * @param paint
     * @param str
     * @return
     */
    private int getTextWidth(Paint paint, String str) {
        int iRet = 0;
        if (str != null && str.length() > 0) {
            int len = str.length();
            float[] widths = new float[len];
            paint.getTextWidths(str, widths);
            for (int j = 0; j < len; j++) {
                iRet += (int) Math.ceil(widths[j]);
            }
        }
        return iRet;
    }

    /**
     * 计算字体高度
     *
     * @param fontSize
     * @return
     */
    public int getFontHeight(float fontSize) {
        Paint paint = new Paint();
        paint.setTextSize(fontSize);
        Paint.FontMetrics fm = paint.getFontMetrics();
        return (int) Math.ceil(fm.descent - fm.ascent);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            float x = event.getX();
            if (x >= (getWidth() - MARGIN * 2) / 19 * 14 + MARGIN - DensityUtil.dip2px(context, 15) &&
                    x < (getWidth() - MARGIN * 2) / 19 * 14 + MARGIN + DensityUtil.dip2px(context, 15)) {
                if (onItemClickListener != null) {
                    onItemClickListener.onFifteenClick();
                }
            } else if (x >= getWidth() - MARGIN - DensityUtil.dip2px(context, 15) &&
                    x < getWidth() - MARGIN + DensityUtil.dip2px(context, 15)) {
                if (onItemClickListener != null) {
                    onItemClickListener.onTwentyClick();
                }
            }
        }
        return super.onTouchEvent(event);
    }

    public interface OnItemClickListener {
        void onFifteenClick();

        void onTwentyClick();
    }
}
