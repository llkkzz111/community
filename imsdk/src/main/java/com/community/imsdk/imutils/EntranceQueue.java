package com.community.imsdk.imutils;

import com.community.imsdk.utils.Logger;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

/**
 * Created by dufeng on 16/8/4.<br/>
 * Description: 一个控制任务开关的队列
 */
public class EntranceQueue {

    private Runnable task;

    public EntranceQueue(Runnable task) {
        this.task = task;
    }

    private static final String TAG = "===EntranceQueue===";
    private final int DEFAULT_COUNT = 200;

    private final Object lock = new Object();

    private BlockingQueue<Integer> mQueue = new ArrayBlockingQueue<Integer>(DEFAULT_COUNT);

    private Thread entranceThread = new Thread() {
        @Override
        public void run() {
            for (; ; ) {
                try {
                    mQueue.take();
                    if (task != null) {
                        task.run();
                    }
                    synchronized (lock) {
                        lock.wait();
                    }
                } catch (Exception ex) {
                    Logger.e(TAG, "init -> " + ex.getMessage());
                }
            }
        }
    };

    public void addTask() {
        if (mQueue.size() < DEFAULT_COUNT) {
            mQueue.add(0);
        }
    }

    public void notifyTask() {
        synchronized (lock) {
            lock.notify();
        }
    }

    public void init() {
        if (entranceThread.getState() == Thread.State.NEW) {
            entranceThread.start();
        }
    }
}
