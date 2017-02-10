package com.choudao.equity.view;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;

import com.choudao.equity.R;
import com.choudao.equity.entity.LetterInfo;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by D_Fate on 2015-09-15.<br/>
 * Description: LetterSideBar
 */
public class LetterSideBar extends View {

    OnTouchingLetterChangedListener onTouchingLetterChangedListener;
    private List<LetterInfo> letterInfos = new ArrayList<>();

    public static String[] letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"
            , "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"};


    int choose = -1;
    Paint paint = new Paint();
    boolean showBkg = false;

    public LetterSideBar(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    public LetterSideBar(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public LetterSideBar(Context context) {
        super(context);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (showBkg) {
            canvas.drawColor(Color.parseColor("#20000000"));
        }
        float textSize = getResources().getDimension(R.dimen.text_fourteen_sp);

        int height = getHeight();
        int width = getWidth();
        float singleHeight = letterInfos.size() == 0 ? 0 : height / letterInfos.size();
        for (int i = 0; i < letterInfos.size(); i++) {
            paint.setColor(getResources().getColor(R.color.text_default_color));
            paint.setTextSize(textSize);
            paint.setAntiAlias(true);
            if (i == choose) {
                paint.setColor(getResources().getColor(R.color.colorAccent));
                paint.setFakeBoldText(true);
            }
            float xPos = width / 2 - paint.measureText(letterInfos.get(i).name) / 2;
            float yPos = singleHeight * i + singleHeight ;
//            float yPos = textSize * i + textSize ;
            canvas.drawText(letterInfos.get(i).name, xPos, yPos, paint);
            paint.reset();
        }

    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent event) {
        final int action = event.getAction();
        final float y = event.getY();
        final int oldChoose = choose;
        final OnTouchingLetterChangedListener listener = onTouchingLetterChangedListener;
        final int c = (int) (y / getHeight() * letterInfos.size());

        switch (action) {
            case MotionEvent.ACTION_DOWN:
                showBkg = true;
                if (oldChoose != c && listener != null) {
                    if (c >= 0 && c < letterInfos.size()) {
                        listener.onTouchingLetterChanged(letterInfos.get(c));
                        choose = c;
                        invalidate();
                    }
                }

                break;
            case MotionEvent.ACTION_MOVE:
                if (oldChoose != c && listener != null) {
                    if (c >= 0 && c < letterInfos.size()) {
                        listener.onTouchingLetterChanged(letterInfos.get(c));
                        choose = c;
                        invalidate();
                    }
                }
                break;
            case MotionEvent.ACTION_UP:
                showBkg = false;
                choose = -1;
                listener.onTouchingLetterUp();
                invalidate();
                break;
        }
        return true;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        return super.onTouchEvent(event);
    }

    public void setOnTouchingLetterChangedListener(
            OnTouchingLetterChangedListener onTouchingLetterChangedListener) {
        this.onTouchingLetterChangedListener = onTouchingLetterChangedListener;
    }

    public void setLetterInfos(List<LetterInfo> letterInfos) {
        this.letterInfos = letterInfos;
    }

    public interface OnTouchingLetterChangedListener {
        void onTouchingLetterChanged(LetterInfo info);

        void onTouchingLetterUp();
    }


}