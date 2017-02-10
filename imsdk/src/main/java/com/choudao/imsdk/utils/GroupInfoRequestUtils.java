package com.choudao.imsdk.utils;

import com.alibaba.fastjson.JSON;
import com.choudao.imsdk.db.bean.GroupInfo;

import java.util.Map;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * Created by dufeng on 16/11/24.<br/>
 * Description: GroupInfoRequestUtils
 */

public class GroupInfoRequestUtils {

    private static final String TAG = "===GroupInfoRequestUtils===";
    private static final Object localLock = new Object();

    private static ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(2, 4, 3, TimeUnit.SECONDS, new ArrayBlockingQueue<Runnable>(200),
            new DefaultThreadFactory("GroupInfoRequest"),new ThreadPoolExecutor.CallerRunsPolicy());

    //    private static Map<Long, Object> lockMap = new ConcurrentHashMap<>();
    private static Map<Long, GetGroupInfoAndMemberCallable> callableMap = new ConcurrentHashMap<>();
    private static Map<Long, Future<GroupInfo>> groupInfoFutureMap = new ConcurrentHashMap<>();

    private static Future<GroupInfo> getFuture(long groupId) {
        if (groupInfoFutureMap.get(groupId) == null) {
            synchronized (localLock) {
                if (groupInfoFutureMap.get(groupId) == null) {
                    callableMap.put(groupId, new GetGroupInfoAndMemberCallable(groupId));
                    groupInfoFutureMap.put(groupId, threadPoolExecutor.submit(callableMap.get(groupId)));
                }
            }
        }
        return groupInfoFutureMap.get(groupId);
    }

    private static void removeFuture(long groupId) {

        Logger.e(TAG, "removeFuture--" + groupId);
        if (groupInfoFutureMap.get(groupId) != null) {
            synchronized (localLock) {
                if (groupInfoFutureMap.get(groupId) != null) {
                    callableMap.remove(groupId);
                    groupInfoFutureMap.remove(groupId);
                    Logger.e(TAG, "removeFuture--" + groupId+" --success");

                }
            }
        }

    }


    public static void notifyLock(long groupId) {
        synchronized (localLock) {
            if (callableMap.get(groupId) == null) {
                return;
            }
            callableMap.get(groupId).notifyTask();
        }
    }

    public static GroupInfo getGroupInfo(long groupId) throws ExecutionException, InterruptedException {
        try {
            Logger.e(TAG, "groupInfoFutureMap--" + JSON.toJSONString(groupInfoFutureMap));
            return getFuture(groupId).get();
        } finally {
            removeFuture(groupId);
        }
    }

}
