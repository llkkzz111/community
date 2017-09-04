package com.ocj.oms.mobile.ui.safty;

import android.content.Intent;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.AreaBean;
import com.ocj.oms.mobile.db.AreaSelectManager;
import com.ocj.oms.mobile.ui.adapter.AreaSlectAdapter;
import com.ocj.oms.mobile.ui.personal.adress.AddressEditActivity;
import com.ocj.oms.mobile.ui.personal.setting.SetDefaultAdressActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import io.reactivex.Observable;
import io.reactivex.ObservableEmitter;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;

/**
 * Created by pactera on 2017/4/21.
 * <p>
 * 地址选择三级
 */

@Route(path = RouterModule.AROUTER_PATH_SELECT_AREA)
public class SelectAreaActivity extends BaseActivity {
    @BindView(R.id.recycle_area) RecyclerView mRecyclerView;

    private AreaSlectAdapter adapter;
    private List<AreaBean> datas;
    private String privinId = "";
    private String cityId = "";
    private String selectName = "";
    private int pageTag = 1;


    @Override
    protected int getLayoutId() {
        return R.layout.activity_privinceselect;
    }

    @Override
    protected void initEventAndData() {

        if (getIntent().hasExtra(IntentKeys.PAGETAB))
            pageTag = getIntent().getIntExtra(IntentKeys.PAGETAB, 1);
        privinId = getIntent().getStringExtra(IntentKeys.PRIVIN_ID);
        cityId = getIntent().getStringExtra(IntentKeys.CITY_ID);
        selectName = getIntent().getStringExtra(IntentKeys.SELECTNAME);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(mContext));
        adapter = new AreaSlectAdapter(mContext);
        mRecyclerView.setAdapter(adapter);
        initListener();
        initSqlData();

        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C064);




    }

    /**
     * 初始化数据库data
     */
    private void initSqlData() {
        Observable.create(getSqlObserble())
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(handleObserverData());

    }


    @android.support.annotation.NonNull
    private ObservableOnSubscribe<List<AreaBean>> getSqlObserble() {
        return new ObservableOnSubscribe<List<AreaBean>>() {
            @Override
            public void subscribe(ObservableEmitter<List<AreaBean>> emitter) throws Exception {
                switch (pageTag) {
                    case 1:
                        datas = AreaSelectManager.getAreaSelecter(getApplicationContext()).getPrivinceList();//不能用mcontext  否则会引起内存泄漏
                        break;
                    case 2:
                        datas = AreaSelectManager.getAreaSelecter(getApplicationContext()).getCityList(privinId);
                        break;

                    case 3:
                        datas = AreaSelectManager.getAreaSelecter(getApplicationContext()).getAreaList(privinId, cityId);
                        break;
                    default:
                        break;
                }
                emitter.onNext(datas);
            }
        };
    }

    /**
     * rxJava 事件处理结果
     *
     * @return
     */
    @android.support.annotation.NonNull
    private Observer<List<AreaBean>> handleObserverData() {
        return new Observer<List<AreaBean>>() {
            @Override
            public void onSubscribe(Disposable d) {

            }

            @Override
            public void onNext(List<AreaBean> areaBeen) {
                if (null == datas || datas.size() == 0) {
                    ToastUtils.showLongToast("没有查询到数据!");
                    finish();
                    return;
                }
                adapter.setmDatas(datas);
            }

            @Override
            public void onError(Throwable e) {

            }

            @Override
            public void onComplete() {

            }
        };
    }


    @OnClick({R.id.iv_left_back})
    public void onLeftClick(View view) {
        finish();
    }


    private void initListener() {
        adapter.setSlectListner(new AreaSlectAdapter.OnAreaSlectListner() {
            @Override
            public void onItemClick(AreaBean bean) {
                Intent intent = getIntent();
                switch (pageTag) {
                    case 1:
                        intent.setClass(getBaseContext(), SelectAreaActivity.class);
                        intent.putExtra(IntentKeys.PRIVIN_ID, bean.getSelectId());
                        intent.putExtra(IntentKeys.SELECTNAME, bean.getSelectName());
                        intent.putExtra(IntentKeys.PAGETAB, 2);
                        startActivity(intent);
                        break;
                    case 2:
                        intent.setClass(getBaseContext(), SelectAreaActivity.class);
                        intent.putExtra(IntentKeys.PRIVIN_ID, privinId);
                        intent.putExtra(IntentKeys.CITY_ID, bean.getSelectId());
                        intent.putExtra(IntentKeys.SELECTNAME, selectName + " " + bean.getSelectName());
                        intent.putExtra(IntentKeys.PAGETAB, 3);
                        startActivity(intent);
                        break;
                    case 3:
                        if (intent.hasExtra(IntentKeys.FROM_ADDRESS)) {
                            intent.setClass(getBaseContext(), AddressEditActivity.class);
                        } else if ("RNActivity".equals(intent.getStringExtra("from"))) {
                            RouterModule.invokeAddressCallback("", "", "", "", "", "", "", selectName + " " + bean.getSelectName(), selectName + " " + bean.getSelectName(), "", privinId, cityId, bean.getSelectId());
                            return;
                        } else if (intent.hasExtra(IntentKeys.FROM_DEFAULT_ADDRESS)) {
                            intent.setClass(getBaseContext(), SetDefaultAdressActivity.class);
                        } else {
                            intent.setClass(getBaseContext(), SecurityCheckActivity.class);
                        }
                        intent.putExtra(IntentKeys.PRIVIN_ID, privinId);
                        intent.putExtra(IntentKeys.CITY_ID, cityId);
                        intent.putExtra(IntentKeys.AREA_ID, bean.getSelectId());
                        intent.putExtra(IntentKeys.SELECTNAME, selectName + " " + bean.getSelectName());
                        startActivity(intent);
                        break;
                }
            }
        });
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C064);
    }
}
