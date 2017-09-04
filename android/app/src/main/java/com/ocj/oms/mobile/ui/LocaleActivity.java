package com.ocj.oms.mobile.ui;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.blankj.utilcode.utils.LogUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.common.net.mode.ApiResult;
import com.ocj.oms.common.net.subscriber.ApiObserver;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.HotCityBean;
import com.ocj.oms.mobile.bean.ResultBean;
import com.ocj.oms.mobile.http.service.account.AccountMode;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.adapter.MyContactsAdapter;
import com.ocj.oms.mobile.ui.createcomment.gvCallBack;
import com.ocj.oms.mobile.ui.global.Contact;
import com.ocj.oms.mobile.view.WaveSideBar;
import com.ocj.oms.utils.ActivityStack;
import com.ocj.oms.view.FixedGridView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import io.reactivex.annotations.NonNull;

/**
 * 创建人：yanglinchuan
 * 创建日期:2017/6/10 18:28
 * 电子邮箱:linchuan.yang@pactera.com
 * 类描述:地区设置页面
 */

public class LocaleActivity extends BaseActivity implements gvCallBack {
    @BindView(R.id.iv_back)
    ImageView ivBack;
    @BindView(R.id.tv_title)
    TextView tvTitle;
    @BindView(R.id.re_title)
    RelativeLayout reTitle;
    @BindView(R.id.gv_image)
    FixedGridView gvImage;
    @BindView(R.id.recycleview)
    RecyclerView recycleview;
    @BindView(R.id.sideBar)
    WaveSideBar sideBar;
    @BindView(R.id.ll_selected)
    LinearLayout llSelected;
    private ArrayList<Contact> contacts = new ArrayList<>();
    private List<ResultBean> list;
    private MyContactsAdapter adapter;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_locale_layout;
    }

    @Override
    protected void initEventAndData() {
        new ItemsMode(mContext).getHotCity(new ApiResultObserver<HotCityBean>(mContext) {
            @Override
            public void onSuccess(HotCityBean apiResult) {
                setData(apiResult);
            }

            @Override
            public void onError(ApiException e) {

            }
        });
    }

    /**
     * 热门城市点击回调   接口暂无此类数据内容
     *
     * @param view
     * @param position
     */
    @Override
    public void onItemClick(View view, int position) {

    }


    private void editStation(int position) {
        final ResultBean bean = list.get(position);
        String from = getIntent().getStringExtra(IntentKeys.FROM);
        if (from != null && from.equals("RNActivity")) {
            Intent intent = new Intent();
            intent.putExtra("location", bean);
            setResult(Activity.RESULT_OK, intent);
            finish();
            return;
        }
        Map<String, String> param = new HashMap<String, String>();
        param.put(ParamKeys.REGION_CD, bean.getSel_region_cd());
        param.put(ParamKeys.PROVINCE, bean.getRemark1_v());
        param.put(ParamKeys.CITY, bean.getRemark2_v());
        new AccountMode(mContext).editUserStationCode(param, new ApiObserver<ApiResult<Object>>(mContext) {
            @Override
            public void onError(ApiException e) {
                ToastUtils.showLongToast(e.getMessage());
            }

            @Override
            public void onNext(@NonNull ApiResult<Object> result) {
                if (result.getCode() == 200) {
                    Intent intent = getIntent();
                    if (intent.getStringExtra(IntentKeys.FROM).equals("RNActivity")) {
                        intent.putExtra("location", bean);
                        setResult(Activity.RESULT_OK, intent);
                    } else {
                        ToastUtils.showLongToast("修改成功");
                    }
                    finish();
                }

            }
        });
    }


    private void setData(HotCityBean apiResult) {
        list = apiResult.getResult();
        for (int i = 0; i < list.size(); i++) {
            contacts.add(new Contact(list.get(i).getRemark3_v(), list.get(i).getCode_name(), ""));
        }
        LogUtils.d("contacts:" + contacts.toString());
        recycleview.setLayoutManager(new LinearLayoutManager(mContext));
        adapter = new MyContactsAdapter(contacts, mContext);
        recycleview.setAdapter(adapter);
        //城市列表回调  ResultBean 为城市所有的数据实体
        adapter.setOnItemClickListener(new MyContactsAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                editStation(position);
//                Intent intent = new Intent();
//                intent.putExtra("location", list.get(position));
//                setResult(Activity.RESULT_OK, intent);
//                finish();
            }
        });
        sideBar.setOnSelectIndexItemListener(new WaveSideBar.OnSelectIndexItemListener() {
            @Override
            public void onSelectIndexItem(String index) {
                for (int i = 0; i < contacts.size(); i++) {
                    if (contacts.get(i).getIndex().equals(index)) {
                        ((LinearLayoutManager) recycleview.getLayoutManager()).scrollToPositionWithOffset(i, 0);
                        return;
                    }
                }
            }
        });
    }

    @OnClick(R.id.iv_back)
    void OnClick(View view) {
        if (getIntent().hasExtra(IntentKeys.FROM_SETTING)) {
            finish();
        } else {
            ToastUtils.showLongToast("请选择地区");
        }
    }

    @Override
    public void onBackPressed() {
        if (getIntent().hasExtra(IntentKeys.FROM_SETTING)) {
            finish();
        } else {
            ActivityStack.getInstance().appExit();
        }

    }
}
