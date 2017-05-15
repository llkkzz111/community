package com.choudao.equity.base;

import javax.inject.Singleton;

import dagger.Component;

/**
 * Created by liuz on 2017/4/12.
 */

@Singleton
@Component(modules = {ApplicationModule.class})
public interface ApplicationComponent {
    BaseApplication getContext();

}
