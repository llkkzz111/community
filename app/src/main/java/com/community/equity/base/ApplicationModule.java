package com.community.equity.base;

import android.content.Context;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

/**
 * Created by liuz on 2017/4/12.
 */

@Module
public final class ApplicationModule {
    private final BaseApplication mContext;

    ApplicationModule(BaseApplication mContext) {
        this.mContext = mContext;
    }

    @Provides
    @Singleton
    BaseApplication provideContext() {
        return mContext;
    }
}
