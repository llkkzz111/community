package com.ocj.oms.mobile.base;


import com.ocj.oms.basekit.presenter.IPresenter;
import com.ocj.oms.basekit.view.BaseView;

/**
 * Created by liuzhao on 2017/4/13.
 */

public interface BaseContract {
    interface View<M> extends BaseView<M> {
    }

    interface Presenter<V extends BaseView> extends IPresenter<V> {

    }

}
