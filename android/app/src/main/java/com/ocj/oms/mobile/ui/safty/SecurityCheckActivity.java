package com.ocj.oms.mobile.ui.safty;

import android.content.Intent;
import android.net.Uri;
import android.support.v7.widget.GridLayoutManager;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.blankj.utilcode.utils.ToastUtils;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.IntentKeys;
import com.ocj.oms.mobile.ParamKeys;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseActivity;
import com.ocj.oms.mobile.bean.ItemsBean;
import com.ocj.oms.mobile.bean.UserInfo;
import com.ocj.oms.mobile.dialog.CommonDialogFragment;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.third.Constants;
import com.ocj.oms.mobile.ui.adapter.ImgAdapter;
import com.ocj.oms.mobile.ui.register.SecurityCheckContract;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.oms.view.FixHeightRecycleView;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 电视会员首次登录-固定电话-安全验证
 */

public class SecurityCheckActivity extends BaseActivity<String, SecurityCheckContract.View, SecurityCheckContract.Presenter> implements SecurityCheckContract.View {

    @BindView(R.id.tv_address) TextView adressInfo;
    @BindView(R.id.ryv_goodlist) FixHeightRecycleView mRecyclerView;

    @BindView(R.id.et_historyname) TextView historyName;


    private final int CLUMS = 3;//列数

    private ImgAdapter adapter;

    List<ItemsBean> datas;


    String memberId = "";
    String addressId = "";
    private String custName;
    SecurityCheckPresenter presenter;
    private String hintsItem;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_security_check_layout;
    }


    @OnClick({R.id.iv_safty_back})
    public void onClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C012D003001C003001);
        finish();
    }


    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C012);
        presenter = new SecurityCheckPresenter(mContext, this);
        memberId = getIntent().getStringExtra(IntentKeys.MEMBER_ID);
        custName = getIntent().getStringExtra(IntentKeys.CUST_NAME);
        mRecyclerView.setLayoutManager(new GridLayoutManager(mContext, CLUMS));

        presenter.getImgList(memberId);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C012);
    }

    private void notifyData(int position) {
        ItemsBean bean = datas.get(position);
        bean.setCheck(!bean.isCheck());
        hintsItem = bean.getId();
        for (int i = 0; i < datas.size(); i++) {
            if (i != position) {
                datas.get(i).setCheck(false);
            }
        }
        adapter.notifyDataSetChanged();
    }

    @OnClick({R.id.tv_address})
    public void onButtonClick(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C012F010001A001001);
        startActivity(new Intent(SecurityCheckActivity.this, SelectAreaActivity.class));
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        String str = intent.getStringExtra(IntentKeys.SELECTNAME);
        str = str.replace("所有", "");
        str = str.replace("其他", "");
        if (str.length() >= 7) {
            if (str.substring(0, 3).equals(str.substring(4, 7))) {
                str = str.substring(4, str.length());
            }
        }

        String privinId = intent.getStringExtra(IntentKeys.PRIVIN_ID);
        String cityId = intent.getStringExtra(IntentKeys.CITY_ID);
        String arenId = intent.getStringExtra(IntentKeys.AREA_ID);
        addressId = privinId + "," + cityId + "," + arenId;
        adressInfo.setText(str);
    }

    @Override
    public void showList(List<ItemsBean> data) {
        hideLoading();
        datas = data;
        adapter = new ImgAdapter(this, data);
        mRecyclerView.setAdapter(adapter);
        adapter.setItemClickListner(new ImgAdapter.OnChildClickListner() {
            @Override
            public void onItemClick(int position) {
                notifyData(position);
            }
        });
    }

    /**
     * 验证通过
     */
    @Override
    public void onVerifySucced(UserInfo userInfo) {
        Intent intent = getIntent();
        intent.setClass(mContext, BindMobileActivity.class);
        intent.putExtra(IntentKeys.FROM, "RNActivity");
        intent.putExtra(IntentKeys.ACCESS_TOKEN, userInfo.getAccessToken());
        startActivity(intent);
    }


    @Override
    public void onVerifyFail(String msg) {
        hideLoading();
        DialogFactory.showAlertDialog(msg, "返回", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        }, "联系客服", new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(mContext, "东东帮您接通热线电话！", Toast.LENGTH_LONG).show();
                Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse("tel:" + Constants.HOT_LINE));
                mContext.startActivity(intent);
            }
        }).show(getFragmentManager(), "contact");

    }

    @OnClick({R.id.tv_changelist})
    public void changeList(View view) {
        Map<String, Object> parameters = new HashMap<String, Object>();
        String itemcode = "";
        for (int i = 0; i < datas.size(); i++) {
            ItemsBean itemsBean = datas.get(i);
            if (i == 1) {
                itemcode = itemsBean.getId();
            } else {
                itemcode = itemcode + "," + itemsBean.getId();
            }
        }
        parameters.put("itemcode", itemcode);
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C012F010002A001001, "", parameters);
        presenter.getImgList(memberId);
        showLoading();

    }

    @OnClick({R.id.btn_logsafe})
    public void onCommit(View view) {
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C012F008001O008001);
        String name = historyName.getText().toString();
        if (TextUtils.isEmpty(name)) {
            ToastUtils.showLongToast("请选择姓名");
            return;
        }
        if (TextUtils.isEmpty(addressId)) {
            ToastUtils.showLongToast("请选择地址");
            return;

        }
        String mobile = getIntent().getStringExtra(IntentKeys.LOGIN_ID);
        Map<String, String> param = new HashMap<String, String>();
        param.put(ParamKeys.CUST_NO, memberId);
        param.put(ParamKeys.CUST_NAME, custName);
        param.put(ParamKeys.HIST_PHONE, mobile);
        param.put(ParamKeys.HIST_RECEIVERS, name);
        param.put(ParamKeys.HIST_ADDRESS, addressId);
        param.put(ParamKeys.HIST_ITEMS, hintsItem);
        presenter.commitTvUserVerfy(param);
    }

}
