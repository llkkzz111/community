package com.ocj.oms.utils;


import android.app.Activity;

import java.util.Stack;

/**
 * create by liuz
 */
public class ActivityStack {
    private static ActivityStack instance;
    //activity栈
    private Stack<Activity> activityStack = new Stack<>();

    /**
     * 单例模式
     *
     * @return 单例
     */

    public static ActivityStack getInstance() {
        if (instance == null) {
            instance = new ActivityStack();
        }
        return instance;
    }

    /**
     * 把一个activity压入栈中
     *
     * @param activity
     */
    public void remove(Activity activity) {
        if (activityStack != null && activityStack.size() > 0) {
            if (activity != null) {
                activityStack.remove(activity);
                activity.finish();
            }
        }

    }

    public Stack<Activity> getActivityStack() {
        return activityStack;
    }


    /**
     * 移除一个activity
     *
     * @param activity activity
     */
    public void add(Activity activity) {
        activityStack.add(activity);
    }

    /**
     * 获取栈顶的activity，先进后出原则
     *
     * @return 栈顶的activity
     */
    public Activity getLastActivity() {
        return activityStack.lastElement();
    }

    /**
     * 结束指定的Activity
     *
     * @param activity activity
     */
    public void finishActivity(Activity activity) {
        if (activity != null) {
            activityStack.remove(activity);
            activity.finish();
        }
    }

    /**
     * 结束指定的Activity
     */
    public void finishLastActivity() {
        activityStack.lastElement().finish();
        activityStack.remove(activityStack.lastElement());
    }


    /**
     * 结束指定类名的Activity
     *
     * @param cls 指定的Activity
     */
    public void finishActivity(Class<?> cls) {
        for (Activity activity : activityStack) {
            if (activity.getClass().equals(cls)) {
                finishActivity(activity);
            }
        }
    }


    /**
     * 结束到指定类名的Activity
     *
     * @param cls 指定的Activity
     */
    public void finishToActivity(Class<?> cls) {
        int size = activityStack.size();
        for (int i = 0; i < size; i++) {
            if (!activityStack.lastElement().getClass().equals(cls)) {
                finishActivity(getLastActivity());
            } else {
                break;
            }
        }
    }

    /**
     * 结束所有activity
     */
    public void finishAllActivity() {
        try {
            for (int i = 0; i < activityStack.size(); i++) {
                if (null != activityStack.get(i)) {
                    activityStack.get(i).finish();
                }
            }
            activityStack.clear();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 退出应用程序
     */
    public void appExit() {
        try {
            finishAllActivity();
            //退出JVM(java虚拟机),释放所占内存资源,0表示正常退出(非0的都为异常退出)
            System.exit(0);
            //从操作系统中结束掉当前程序的进程
            android.os.Process.killProcess(android.os.Process.myPid());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}