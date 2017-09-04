package com.ocj.oms.mobile.ui.global.widget;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.Nullable;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.AppCompatButton;
import android.support.v7.widget.AppCompatImageButton;
import android.support.v7.widget.AppCompatTextView;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.ui.global.Contact;
import com.ocj.oms.mobile.ui.global.GlobalFragment1;
import com.ocj.oms.mobile.ui.global.GlobalFragment2;
import com.ocj.oms.mobile.ui.global.GlobalFragmentAdapter;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by liu on 2017/6/15.
 */

public class GlobalTabCatLayout extends LinearLayout {

    private AppCompatImageButton screenbackBtn;
    private TabLayout tabLayout;
    private ViewPager viewpager;
    private AppCompatButton confirmBtn;
    private ArrayList<String> list = new ArrayList<>();
    private GlobalFragment1 fragment1;
    private GlobalFragment2 fragment2;
    private GlobalFragmentAdapter mAdapter;
    private AppCompatTextView tvSlideTitle;

    private ArrayList<Contact> mList = new ArrayList<>();
    private ArrayList<Contact> mSelectList = new ArrayList<>();

    private OnSelectListener onSelectListener;
    private static final String TAB_LIST = "0";
    private static final String TAB_SORT = "1";
    private String current_tab = "0";

    private int show_type;
    public static final int SHOW_TYPE_BRAND = 0;
    public static final int SHOW_TYPE_AREA = 1;

    private AppCompatButton tagButton;

    public GlobalTabCatLayout(Context context) {
        super(context);
        init(context);
    }

    public GlobalTabCatLayout(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public GlobalTabCatLayout(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    public int getShow_type() {
        return show_type;
    }

    public void setShow_type(int show_type) {
        this.show_type = show_type;
    }

    public AppCompatButton getTagButton() {
        return tagButton;
    }

    public void setTagButton(AppCompatButton tagButton) {
        this.tagButton = tagButton;
    }

    public void setOnSelectListener(OnSelectListener onSelectListener) {
        this.onSelectListener = onSelectListener;
    }

    public void setData(List<Contact> mList, List<Contact> mSelectList) {
        this.mList.clear();
        this.mSelectList.clear();
        this.mList.addAll(mList);
        this.mSelectList.addAll(mSelectList);
        fragment1.setData(this.mList, this.mSelectList);
        fragment2.setData(this.mList, this.mSelectList);
    }

    private void init(Context context) {
        LayoutInflater.from(context).inflate(R.layout.global_screen_layout1, this, true);

        tvSlideTitle = (AppCompatTextView) findViewById(R.id.tv_slide_title);
        screenbackBtn = (AppCompatImageButton) findViewById(R.id.screenbackBtn);
        screenbackBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onSelectListener != null) {
                    onSelectListener.onClose();
                }
            }
        });
        list.add("推荐地区");
        list.add("字母排序");
        tabLayout = (TabLayout) findViewById(R.id.tabLayout);
        viewpager = (ViewPager) findViewById(R.id.viewpager);
        confirmBtn = (AppCompatButton) findViewById(R.id.confirmBtn);
        final List<Fragment> fragmentList = new ArrayList<>();
        fragment1 = new GlobalFragment1();
        fragment2 = new GlobalFragment2();

        fragment1.setData(mList, mSelectList);
        fragment2.setData(mList, mSelectList);

        fragmentList.add(fragment1);
        fragmentList.add(fragment2);
        mAdapter = new GlobalFragmentAdapter(((FragmentActivity) context).getSupportFragmentManager(), list, fragmentList);
        viewpager.setAdapter(mAdapter);
        mAdapter.notifyDataSetChanged();
        TabLayout.Tab firstTab = tabLayout.newTab();
        firstTab.setTag(TAB_LIST);
        firstTab.setText(list.get(0));
        tabLayout.addTab(firstTab);

        TabLayout.Tab twoTab = tabLayout.newTab();
        twoTab.setTag(TAB_SORT);
        twoTab.setText(list.get(0));
        tabLayout.addTab(twoTab);

        tabLayout.setTabMode(TabLayout.MODE_FIXED);
        tabLayout.setupWithViewPager(viewpager);
        LinearLayout linearLayout = (LinearLayout) tabLayout.getChildAt(0);
        linearLayout.setShowDividers(LinearLayout.SHOW_DIVIDER_MIDDLE);
        linearLayout.setDividerDrawable(ContextCompat.getDrawable(context,
                R.drawable.layout_divider_vertical));
        setIndicator(context, tabLayout, 40, 40);
        tabLayout.addOnTabSelectedListener(new TabLayout.OnTabSelectedListener() {
            @Override
            public void onTabSelected(TabLayout.Tab tab) {
                String tag = tab.getPosition() + "";
                current_tab = tag;
                if (tag.equals(TAB_LIST)) {
                    fragment1.setData(mList, fragment2.getSelectList());
                } else {
                    fragment2.setData(mList, fragment1.getSelectList());
                }


            }

            @Override
            public void onTabUnselected(TabLayout.Tab tab) {

            }

            @Override
            public void onTabReselected(TabLayout.Tab tab) {

            }
        });
        confirmBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (onSelectListener != null) {
                    if (current_tab.equals(TAB_LIST)) {
                        onSelectListener.onEnterClick(getValues(fragment1.getSelectList()), getCode(fragment1.getSelectList()),show_type, tagButton);
                        onSelectListener.onBackSelectList(fragment1.getSelectList(), show_type, tagButton);
                    } else {
                        onSelectListener.onEnterClick(getValues(fragment2.getSelectList()), getCode(fragment2.getSelectList()),show_type, tagButton);
                        onSelectListener.onBackSelectList(fragment2.getSelectList(), show_type, tagButton);

                    }
                }
            }
        });
    }

    public void setSlideTitle(String title) {
        tvSlideTitle.setText(title);
    }

    public void setTabs(String first, String second) {
        TabLayout.Tab fir = tabLayout.getTabAt(0);
        fir.setText(first);

        TabLayout.Tab two = tabLayout.getTabAt(1);
        two.setText(second);
    }

    private String getValues(List<Contact> list) {
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < list.size(); i++) {
            if (i == list.size() - 1) {
                buffer.append(list.get(i).getName());
            } else {
                buffer.append(list.get(i).getName()).append(",");
            }
        }
        return buffer.toString();
    }

    private String getCode(List<Contact> list) {
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < list.size(); i++) {
            if (i == list.size() - 1) {
                buffer.append(list.get(i).getCode());
            } else {
                buffer.append(list.get(i).getCode()).append(",");
            }
        }
        return buffer.toString();
    }

    /**
     * 设置indicator 宽度
     *
     * @param context
     * @param tabs
     * @param leftDip
     * @param rightDip
     */
    public static void setIndicator(Context context, TabLayout tabs, int leftDip, int rightDip) {
        Class<?> tabLayout = tabs.getClass();
        Field tabStrip = null;
        try {
            tabStrip = tabLayout.getDeclaredField("mTabStrip");
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        }

        tabStrip.setAccessible(true);
        LinearLayout ll_tab = null;
        try {
            ll_tab = (LinearLayout) tabStrip.get(tabs);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }

        int left = (int) (getDisplayMetrics(context).density * leftDip);
        int right = (int) (getDisplayMetrics(context).density * rightDip);

        for (int i = 0; i < ll_tab.getChildCount(); i++) {
            View child = ll_tab.getChildAt(i);
            child.setPadding(0, 0, 0, 0);
            LayoutParams params = new LayoutParams(0, LayoutParams.MATCH_PARENT, 1);
            params.leftMargin = left;
            params.rightMargin = right;
            child.setLayoutParams(params);
            child.invalidate();
        }
    }

    public static DisplayMetrics getDisplayMetrics(Context context) {
        DisplayMetrics metric = new DisplayMetrics();
        ((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(metric);
        return metric;
    }

    public interface OnSelectListener {
        void onEnterClick(String condition, String code,int show_type, AppCompatButton tagButton);

        void onBackSelectList(List<Contact> conditionList, int show_type, AppCompatButton tagButton);

        void onClose();
    }

}
