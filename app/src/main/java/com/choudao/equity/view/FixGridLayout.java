package com.choudao.equity.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.TextView;

/**
 * Created by liuzhao on 16/4/15.
 */
public class FixGridLayout extends LinearLineWrapLayout implements View.OnClickListener {
    private OnClickKeywordListener onClickKeywordListener;
    private KeywordViewFactory keywordViewFactory;

    public FixGridLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        setAdjustChildWidthWithParent(true);
    }

    public FixGridLayout(Context context) {
        super(context);
        setAdjustChildWidthWithParent(true);
    }

    @Override
    public void onClick(View v) {
        if (v.getTag() == null) {
            throw new IllegalArgumentException("没有Tag");
        }

        if (!(v.getTag() instanceof Integer)) {
            throw new IllegalArgumentException("Tag不是Integer, 请不要占用Tag，因为" + FixGridLayout.class.getSimpleName() + "将在Tag中保存Keyword的索引");
        }

        if (onClickKeywordListener != null) {
            onClickKeywordListener.onClickKeyword((Integer) v.getTag());
        }
    }

    /**
     * 设置关键字
     *
     * @param keywords 关键字数组
     */
    public void setKeywords(String... keywords) {
        if (keywordViewFactory == null) {
            throw new IllegalStateException("你必须设置keywordViewFactory");
        }
        removeAllViews();
        TextView keywordTextView;
        for (int w = 0; w < keywords.length; w++) {
            keywordTextView = keywordViewFactory.makeKeywordView();
            if (keywordTextView == null) {
                throw new IllegalArgumentException("KeywordViewFactory.makeKeywordView()不能返回null");
            }
            keywordTextView.setText(keywords[w]);
            keywordTextView.setTag(w);
            keywordTextView.setOnClickListener(this);
            addView(keywordTextView);
        }
        startLayoutAnimation();
    }

    public void setOnClickKeywordListener(OnClickKeywordListener onClickKeywordListener) {
        this.onClickKeywordListener = onClickKeywordListener;
    }

    public void setKeywordViewFactory(KeywordViewFactory keywordViewFactory) {
        this.keywordViewFactory = keywordViewFactory;
    }

    public interface OnClickKeywordListener {
        void onClickKeyword(int position);
    }

    public interface KeywordViewFactory {
        TextView makeKeywordView();
    }

}