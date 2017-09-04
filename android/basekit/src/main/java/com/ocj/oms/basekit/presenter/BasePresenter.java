package com.ocj.oms.basekit.presenter;

import com.ocj.oms.basekit.presenter.IPresenter;
import com.ocj.oms.basekit.view.BaseView;

/**
 * Created by liuzhao on 2017/4/13.
 */

public abstract class BasePresenter<V extends BaseView> implements IPresenter<V> {
    public V view;

    public void attachView(V view) {
        this.view = view;
    }

    public void detachView(boolean retainInstance) {
        view = null;
    }
}
