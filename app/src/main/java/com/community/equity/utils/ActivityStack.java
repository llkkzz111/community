package com.community.equity.utils;

import android.app.Activity;
import android.os.Process;

import com.community.equity.base.BaseActivity;

import java.util.Stack;

/**
 * Created by liuzhao on 16/6/7.
 */

public class ActivityStack {
    private static final String TAG = "activityStack";
    private static ActivityStack INSTANCE;
    private Stack<BaseActivity> mActivities = new Stack<BaseActivity>();

    private ActivityStack() {
    }

    public static ActivityStack getInstance() {
        if (INSTANCE == null) {
            INSTANCE = new ActivityStack();
        }
        return INSTANCE;
    }

    public void finishActivity() {
        if (!CollectionUtil.isEmpty(mActivities)) {
            Activity activity = mActivities.lastElement();
            if (activity != null) {
                activity.finish();
                activity = null;
            }
        }
    }

    public Activity topActivity() {
        return mActivities.lastElement();
    }

    public void finishActivity(Activity activity) {
        if (activity != null) {
            activity.finish();
            if (mActivities.contains(activity)) {
                mActivities.remove(activity);
            }
            activity = null;
        }
    }


    public Activity currentActivity() {
        return mActivities.lastElement();

    }

    public void pushActivity(BaseActivity activity) {
        mActivities.add(activity);
    }

    public void finishAllActivityUntilCls(boolean isForceClose) {
        //		boolean isForceClose = false;
        while (mActivities.size() > 0) {
            finishActivity(currentActivity());
        }
        if (isForceClose) {
            Process.killProcess(Process.myPid());
        }
    }

    /**
     * 用来注册成功跳转到首页
     */
    public void popAllActivityUntilCls(Class<?> clz) {
        while (mActivities.size() > 0) {
            if (currentActivity().getClass() != clz) {
                finishActivity(currentActivity());
            } else {
                break;
            }
        }
    }

    /**
     * 关闭除了clz之外的activity
     */
    public void closeAllActivityOnlyCls(Class<?> clz) {
        Stack<BaseActivity> stacks = null;
        stacks = mActivities;
        for (int i = 0; i < stacks.size(); i++) {
            if (stacks.get(i).getClass() == (clz)) {
                continue;
            } else {
                finishActivity(mActivities.get(i));
            }
            if (stacks.size() == 1) {
                break;
            }
        }
        mActivities = stacks;
    }

    public void closeActivityByClass(Class<?> clz) {
        while (mActivities.size() > 0) {
            if (currentActivity().getClass() == clz) {
                finishActivity(currentActivity());
                break;
            }
        }
    }

    public int size() {
        return mActivities.size();
    }

    public Activity activityAt(int position) {
        return position < mActivities.size() ? mActivities.elementAt(position) : null;
    }

    public Activity activityAtLast(int position) {
        return position < mActivities.size() ? mActivities.elementAt(mActivities.size() - position) : null;
    }

    public boolean hasActivity(Class<?> clz) {

        for (int i = 0; i < mActivities.size(); i++) {
            if (mActivities.get(i).getClass() == clz) {
                return true;
            }
        }
        return false;
    }
}
