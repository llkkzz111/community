package com.ocj.oms.mobile.ui.personal.order;

import android.graphics.Bitmap;
import android.os.Environment;
import android.support.annotation.IdRes;
import android.support.v7.widget.LinearLayoutManager;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.ToastUtils;
import com.google.gson.Gson;
import com.lzy.imagepicker.bean.ImageItem;
import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.common.net.HttpParameterBuilder;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.ItemReturnBody;
import com.ocj.oms.mobile.bean.ItemsReturnParamBean;
import com.ocj.oms.mobile.bean.OrderDetailBean;
import com.ocj.oms.mobile.bean.REPictureBean;
import com.ocj.oms.mobile.bean.ReasonBean;
import com.ocj.oms.mobile.bean.ReasonListBean;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.bean.RetExJson;
import com.ocj.oms.mobile.bean.RetExPictureBean;
import com.ocj.oms.mobile.bean.items.ColorsSizeBean;
import com.ocj.oms.mobile.bean.items.SpecItemBean;
import com.ocj.oms.mobile.dialog.SelectSpecDialog;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.pickimg.AbsPickImgActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.view.FixHeightRecycleView;
import com.ocj.oms.view.FixedGridView;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import butterknife.BindView;
import butterknife.OnClick;
import id.zelory.compressor.Compressor;
import okhttp3.RequestBody;

import static com.ocj.oms.mobile.R.id.rb_transfer_payment;
import static com.ocj.oms.mobile.R.id.rg_good;

/**
 * Created by liu on 2017/6/6.
 * 退换货页面
 */
@Route(path = RouterModule.AROUTER_PATH_RETEXGOODS)
public class RetExGoodsActivity extends AbsPickImgActivity implements ReasonAdapter.OnItemClickListener {

    private static final String TYPE_RETURN_GOODS = "1";
    private static final String TYPE_EXCHANGE_GOODS = "2";
    private static final int TEXT_NUM_MAX = 200;

    public static final int DELEATE_IMG = 1;

    @BindView(R.id.tv_title) TextView tvTitle;
    @BindView(R.id.iv_title_back) ImageView iv_title_back;
    @BindView(R.id.tv_goods_type) TextView tvGoodsType;
    @BindView(R.id.tv_goods_choose) TextView tvGoodsChoose;
    @BindView(R.id.tv_des) TextView tvDes;
    @BindView(R.id.iv_indicator) ImageView ivIndicator;
    @BindView(R.id.ll_choose_reason) LinearLayout llChooseReason;
    @BindView(R.id.rv_reasons) FixHeightRecycleView rvReasons;
    @BindView(R.id.tv_nums) TextView tvNums;
    @BindView(R.id.edt_reason) EditText edtReason;

    @BindView(R.id.ll_good_attr) LinearLayout llGoodAttr;
    @BindView(R.id.ll_goods_item) LinearLayout llGoodsItem;
    @BindView(R.id.rg_used) RadioGroup rgUsed;
    @BindView(rg_good) RadioGroup rgGood;
    @BindView(R.id.cb_missing_main) CheckBox cbMissingMain;
    @BindView(R.id.cb_outside_package) CheckBox cbOutsidePackage;
    @BindView(rb_transfer_payment) RadioButton rbTransferPayment;
    @BindView(R.id.rb_original_payment_method_returned) RadioButton rbOriginalPaymentMethodReturned;
    @BindView(R.id.gv_image) FixedGridView gvImage;
    @BindView(R.id.btn_submit) Button btnSubmit;

    @BindView(R.id.layout_good_item) View layoutGoodItem;
    @BindView(R.id.ll_goods_not_ok_container) View llGoodsNotOkContainer;
    @BindView(R.id.ll_return_cash_container) View llReturnCashContainer;

    //item
    @BindView(R.id.iv_good_item) ImageView ivGoodItem;
    @BindView(R.id.tv_goods_title) TextView tvGoodsTitle;
    @BindView(R.id.tv_goods_attr) TextView tvGoodsAttr;
    @BindView(R.id.tv_items_num) TextView tvItemsNum;

    @BindView(R.id.ll_package_container) View llPackageContainer;
    @BindView(R.id.ll_goods_container) View llGoodsContainer;

    @BindView(R.id.pb_reasons) ProgressBar pbReasons;
    @BindView(R.id.pb_item_detail) ProgressBar pbItemDetail;

    @BindView(R.id.ll_original_payment_method_returned) View llOriginalPayment;
    @BindView(R.id.ll_transfer_payment) View llTransferPayment;

    private ReasonAdapter mReasonAdapter;
    private ImageAdapter mImageAdapter;
    private ArrayList<ReasonBean> mListReasons = new ArrayList<>();

    private ArrayList<String> mImageUrls = new ArrayList<>();//本地图片的path地址
    private ArrayList<String> mImageUploadUrls = new ArrayList<>();//上传成功以后的返回地址

    private static final int IMG_MAX_NUM = 9;//最多提交图片张数
    private static final int IMG_COLUMNS = 4;


    private boolean isUsed = true;//是否使用过
    private boolean isGoodsOK = true;//商品是否完好

    private String retExchYn;//退换货类型

    private OrderDetailBean orderDetailBean;
    private String reasonCode;

    private SelectSpecDialog mSelectDialog;

    private ColorsSizeBean colorsSizeBean;

    private String orderNo;//","订单号
    private String orderGSeq;//",订单商品序号
    private String orderDSeq;//",赠品序号
    private String orderWSeq;//",操作序号
    private String receiverSeq;//退换货地址编码
    private String retItemCode;//回收商品编号
    private String retUnitCode;//新商品单件号

    private String retExchQty;//数量

    private String orderType;//
    private String amout;

    private String itemPicUrl;
    private String itemMoney;
    private String itemTitle;
    private String itemNum;
    private String itemSpec;

    private SpecItemBean sizeItemBean;
    private SpecItemBean colorItemBean;
    private SpecItemBean specItemBean;

    private String exchUnitCode;//新商品单件号

    private RetExJson data;
    private ArrayList<RetExJson.RetExJsonItem> mItemList;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_return_exchange_layout;
    }

    @Override
    protected void initEventAndData() {
        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C003);
        getIntentData();
        setListener();
        updateView(retExchYn);
        loadNetData();
    }


    private void getIntentData() {
        if (getIntent() != null) {
            String jsonData = getIntent().getStringExtra("data");
            data = new Gson().fromJson(jsonData, RetExJson.class);

            if (data == null) {
                finish();
                return;
            }
            if (data.retExchYn != null) {
                retExchYn = data.retExchYn;//退换货类型
            }
            if (data.orderNo != null) {
                orderNo = data.orderNo;
            }

            if (data.getItems() != null && data.getItems().size() > 0) {
                mItemList = data.getItems();
                //换货取第一个数据
                RetExJson.RetExJsonItem bean = data.getItems().get(0);
                orderGSeq = bean.order_g_seq;// ");//订单商品序号
                orderDSeq = bean.order_d_seq;// ");//赠品序号
                orderWSeq = bean.order_w_seq;// ");//操作序号
                receiverSeq = bean.receiver_seq;// ");//退换货地址编码
                retItemCode = bean.item_code;// ");//回收商品编号
                retUnitCode = bean.unit_code;// ");//回收商品单件号
                retExchQty = bean.item_qty;// ");//数量

                itemPicUrl = bean.contentLink;
                itemTitle = bean.item_name;
                itemNum = bean.item_qty;
                itemMoney = bean.rsale_amt;
                itemSpec = bean.dt_info;
                orderType = bean.orderType;//"Y"
            }

        }
    }

    private void setListener() {
        edtReason.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                int length = edtReason.getText().length();
                tvNums.setText(length + "/" + TEXT_NUM_MAX);
            }
        });

        rgUsed.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                isUsed = checkedId == R.id.rb_used;
            }
        });

        rgGood.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                //商品完好
                if (checkedId == R.id.rb_goods_ok) {
                    isGoodsOK = true;
                    llGoodsNotOkContainer.setVisibility(View.GONE);
                } else {
                    //不完好
                    isGoodsOK = false;
                    llGoodsNotOkContainer.setVisibility(View.VISIBLE);
                }
            }
        });

        llOriginalPayment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                rbOriginalPaymentMethodReturned.setChecked(true);
                rbTransferPayment.setChecked(false);
            }
        });

        llTransferPayment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                rbTransferPayment.setChecked(true);
                rbOriginalPaymentMethodReturned.setChecked(false);
            }
        });
    }

    private void loadNetData() {
        //请求原因列表数据
        new ItemsMode(mContext).getItemReturnReasons(new ApiResultObserver<ReasonListBean>(mContext) {
            @Override
            public void onSuccess(ReasonListBean apiResult) {

                if (apiResult != null && apiResult.getReason() != null) {
                    mListReasons.addAll(apiResult.getReason());
                    showReasonData(mListReasons);
                }
            }

            @Override
            public void onError(ApiException e) {

            }

            @Override
            public void onComplete() {
                super.onComplete();
                pbReasons.setVisibility(View.GONE);
            }
        });
    }

    @Override
    public void handleSelectImages(ArrayList<ImageItem> images) {
        //处理返回的图片数据
        for (int i = 0; i < images.size(); i++) {
            mImageUrls.add(images.get(i).path);
        }
        mImageAdapter.notifyDataSetChanged();
    }

    /**
     * 显示原因列表数据
     *
     * @param datas
     */
    private void showReasonData(ArrayList<ReasonBean> datas) {
        rvReasons.setLayoutManager(new LinearLayoutManager(this));
        mReasonAdapter = new ReasonAdapter();
        mReasonAdapter.setData(datas);
        mReasonAdapter.setOnItemClickListener(this);
        rvReasons.setAdapter(mReasonAdapter);
    }

    private void showItemsView(OrderDetailBean.ItemBean item) {
        LoaderFactory.getLoader().loadNet(ivGoodItem, item.getContentLink(), null);
        tvGoodsTitle.setText(item.getItem_name());
        tvGoodsAttr.setText(item.getDt_info() + "  " + item.getRsale_amt());
        tvItemsNum.setText(item.getOrder_qty());
    }

    /**
     * 上传图片
     */
    private void uploadImage() {
        if (mImageUrls.size() == 0) {
            return;
        }
        if (orderNo == null) {
            ToastUtils.showShortToast("无法获取订单号");
            return;
        }
        showLoading();
        HttpParameterBuilder builder = HttpParameterBuilder.newBuilder();
        builder.addParameter("orderNo", orderNo);
        builder.addParameter("orderGSeq", orderGSeq);
        builder.addParameter("orderDSeq", orderDSeq);
        builder.addParameter("orderWSeq", orderWSeq);
        builder.addParameter("retItemCode", retItemCode);
        builder.addParameter("retUnitCode", retUnitCode);
        builder.addParameter("receiverSeq", receiverSeq);
        for (int i = 0; i < mImageUrls.size(); i++) {
            File file = new File(mImageUrls.get(i));
            //图片压缩
            try {
                File compressFile = new Compressor(this)
                        .setMaxWidth(640)
                        .setMaxHeight(480)
                        .setQuality(75)
                        .setCompressFormat(Bitmap.CompressFormat.JPEG)
                        .setDestinationDirectoryPath(Environment.getExternalStoragePublicDirectory(
                                Environment.DIRECTORY_PICTURES).getAbsolutePath())
                        .compressToFile(file);
                builder.addParameter("files", compressFile);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        new ItemsMode(mContext).uploadREPicture(builder.bulider(), new ApiResultObserver<RetExPictureBean>(mContext) {
            @Override
            public void onSuccess(RetExPictureBean apiResult) {
                Log.i("tag", apiResult.toString());
                if (apiResult != null && apiResult.getREPictureList() != null) {
                    showToast("上传图片成功");
                    submitReturnItem(retExchYn, apiResult.getREPictureList());
                }
            }

            @Override
            public void onError(ApiException e) {
                Log.i("tag", e.toString());
                showToast(e.getMessage());
                hideLoading();
            }

            @Override
            public void onComplete() {
                super.onComplete();
                hideLoading();
            }
        });
    }

    /**
     * 提交退换货表单数据
     *
     * @param
     */
    public void submitReturnItem(String retExchYn, ArrayList<String> imgs) {

        //需要遍历theList
        ArrayList<RetExJson.RetExJsonItem> itemList = data.getItems();
        ArrayList<ItemsReturnParamBean> list = new ArrayList<>();
        for (int i = 0; i < itemList.size(); i++) {
            RetExJson.RetExJsonItem item = itemList.get(i);
            ItemsReturnParamBean bean = new ItemsReturnParamBean();

            bean.orderGSeq = item.order_g_seq;//	订单商品序号
            bean.orderDSeq = item.order_d_seq;//	赠品序号
            bean.orderWSeq = item.order_w_seq;//	操作序号
            bean.retExchQty = item.item_qty;//	退货/交换数量
            bean.retItemCode = item.item_code;//	回收商品编号
            bean.retUnitCode = item.unit_code;//	回收商品单件号

            if (retExchYn.equals(TYPE_EXCHANGE_GOODS)) {
                bean.setExchItemCode(item.item_code);//新商品编号（换货）
                bean.setExchUnitCode(exchUnitCode);//新单件编号（换货）
            }
            list.add(bean);
        }

        ItemReturnBody itemReturnBody = new ItemReturnBody();

        itemReturnBody.receiverSeq = receiverSeq;//":"0000001531",

        itemReturnBody.orderNo = orderNo;
        itemReturnBody.retExchYn = retExchYn;//退换货类型
        itemReturnBody.claimCode = reasonCode;//":"C02",
        itemReturnBody.claimDesc = edtReason.getText().toString();//":"XXXXX",
        itemReturnBody.usedYn = isUsed ? "1" : "2";//":"2",
        itemReturnBody.entiretyYn = isGoodsOK ? "1" : "2";//":"1",
        itemReturnBody.presentYn = cbMissingMain.isChecked() ? "2" : "1";//":"1",
        itemReturnBody.packageYn = cbOutsidePackage.isChecked() ? "2" : "1";//":"1",
        itemReturnBody.refundSource = rbTransferPayment.isChecked() ? "1" : "2";//":"1",

        if (imgs != null && imgs.size() > 0) {
            StringBuilder stringBuilder = new StringBuilder();
            for (int j = 0; j < imgs.size(); j++) {
                stringBuilder.append(imgs.get(j));
                if (j != imgs.size() - 1) {
                    stringBuilder.append(",");
                }
            }
            itemReturnBody.imgUrl = stringBuilder.toString();
        }else {
            itemReturnBody.imgUrl = "";//":"https://111,https://222,https://333",
        }

        itemReturnBody.setTheList(list);//设置list

        Gson gson = new Gson();
        String json = gson.toJson(itemReturnBody);
        RequestBody body = RequestBody.create(okhttp3.MediaType.parse("application/json; charset=utf-8"), json);
        new ItemsMode(mContext).submitItemReturn(body, new ApiResultObserver<Result<String>>(mContext) {
            @Override
            public void onSuccess(Result<String> apiResult) {
                showToast(apiResult.getResult());
                finish();
                Log.i("tag", apiResult.toString());
            }

            @Override
            public void onError(ApiException e) {
                Log.i("tag", e.toString());
                showToast(e.getMessage());
            }
        });
    }

    /**
     * 获取商品的规格
     */
    private void getItemsColorSizes() {
        if (retItemCode == null) {
            showToast("无法获取规格");
            return;
        }
        HashMap<String, String> params = new HashMap<>();
        params.put("item_code", retItemCode);
        params.put("IsNewSingle", "Y");
        new ItemsMode(mContext).getItemsColorSize(params, new ApiResultObserver<ColorsSizeBean>(mContext) {
            @Override
            public void onSuccess(ColorsSizeBean apiResult) {
                mSelectDialog.setColorsSizeBean(apiResult);
                mSelectDialog.setPreSizeItem(sizeItemBean);
                mSelectDialog.setPreColorItem(colorItemBean);
                mSelectDialog.setPreSpecItem(specItemBean);
                mSelectDialog.setImg_url(itemPicUrl);
                mSelectDialog.setMoney(itemMoney);
                mSelectDialog.setSpec(itemSpec);
                if (!mSelectDialog.isShowing() && !isFinishing()) {
                    mSelectDialog.show();
                }
            }

            @Override
            public void onError(ApiException e) {
                showToast(e.getMessage());
                Log.i("tag", e.getMessage());
            }
        });
    }

    /**
     * 根据是退换还是换货，显示不同的UI
     *
     * @param
     */
    private void updateView(String retExchYn) {
        //标记位 true 退货 false 换货
        boolean isReturn = retExchYn.equals(TYPE_RETURN_GOODS);

        tvNums.setText("0/" + TEXT_NUM_MAX);
        tvTitle.setText(isReturn ? "申请退货" : "申请换货");
        tvGoodsType.setText(isReturn ? "退货原因" : "换货原因");
        tvGoodsChoose.setText(isReturn ? "请选择退货原因" : "主要质量问题");
        tvDes.setText(isReturn ? "退货说明" : "换货说明");
        edtReason.setHint(isReturn ? "请举例描述您退货的原因" : "请举例描述您换货的原因");
        llGoodsItem.setVisibility(isReturn ? View.GONE : View.VISIBLE);
        llReturnCashContainer.setVisibility(isReturn ? View.VISIBLE : View.GONE);

        llGoodsNotOkContainer.setVisibility(View.GONE);

        //初始化添加图片
        mImageAdapter = new ImageAdapter(this, mImageUrls, gvImage, IMG_MAX_NUM, IMG_COLUMNS) {
            @Override
            protected void updateView() {

            }
        };
        mImageAdapter.setOnDeleteClickListener(new ImageAdapter.OnDeleteClickListener() {
            @Override
            public void delete(int position) {
                mImageUrls.remove(position);
                mImageAdapter.notifyDataSetChanged();
            }
        });
        gvImage.setAdapter(mImageAdapter);
        gvImage.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (position == mImageAdapter.getCount() - 1 && (IMG_MAX_NUM - mImageUrls.size() != 0)) {
                    showChoiceDialog(IMG_MAX_NUM - mImageUrls.size());
                } else {
//                    ToastUtils.showShortToast("跳转图片查看器");
                }
            }
        });

        mSelectDialog = new SelectSpecDialog(this);
        mSelectDialog.setItemSelectListener(new SelectSpecDialog.ItemSelectListener() {

            @Override
            public void select(SpecItemBean size, SpecItemBean color, SpecItemBean spec) {
                sizeItemBean = size;
                colorItemBean = color;
                specItemBean = spec;
            }

            @Override
            public void selectItem(String unitCode, String content) {
                exchUnitCode = unitCode;
                if (!TextUtils.isEmpty(content)) {
                    tvGoodsAttr.setText("已选" + content);
                }

            }
        });

        if (!isReturn) {
            if (itemPicUrl != null) {
                LoaderFactory.getLoader().loadNet(ivGoodItem, itemPicUrl, null);
            }
            tvGoodsTitle.setText(itemTitle);
//            StringBuilder sb = new StringBuilder();
//            if (!TextUtils.isEmpty(itemSpec)) {
//                if (itemSpec.contains(";")) {
//                    String[] str = itemSpec.split(";");
//                    for (int i = 0; i < str.length; i++) {
//                        sb.append("“");
//                        sb.append(str[i]);
//                        sb.append("”");
//                    }
//                }
//            }
            tvGoodsAttr.setText("已选" + itemSpec);
            tvItemsNum.setText(itemNum);
        }
    }

    @OnClick(R.id.ll_goods_container)
    void goodsContainerClick(View view) {
        boolean flag = cbMissingMain.isChecked();
        cbMissingMain.setChecked(!flag);
    }

    @OnClick(R.id.ll_package_container)
    void packageContainerClick(View view) {
        boolean flag = cbOutsidePackage.isChecked();
        cbOutsidePackage.setChecked(!flag);
    }

    private boolean isChooseReason;

    @OnClick(R.id.ll_choose_reason)
    public void chooseReasonClick(View view) {
        if (rvReasons.getVisibility() == View.VISIBLE) {
            rvReasons.setVisibility(View.GONE);
            ivIndicator.setBackground(getResources().getDrawable(R.drawable.icon_down));
        } else {
            rvReasons.setVisibility(View.VISIBLE);
            ivIndicator.setBackground(getResources().getDrawable(R.drawable.icon_up));
        }
        isChooseReason = !isChooseReason;
    }

    /**
     * 监听原因的列表点击事件
     *
     * @param position
     */
    @Override
    public void onItemClick(int position) {
        for (ReasonBean item : mListReasons) {
            item.setChecked(false);
        }
        mListReasons.get(position).setChecked(true);
        reasonCode = mListReasons.get(position).getCLAIMCODE();
        mReasonAdapter.notifyDataSetChanged();
        tvGoodsChoose.setText(mListReasons.get(position).getREASON());
        rvReasons.setVisibility(View.GONE);
        ivIndicator.setBackground(getResources().getDrawable(R.drawable.icon_down));
    }

    @OnClick(R.id.iv_title_back)
    void titleBack(View view) {
        finish();
    }

    /**
     * 提交申请按钮点击
     *
     * @param view
     */
    @OnClick(R.id.btn_submit)
    void submitClick(View view) {
        //1.先检查是否填写相关数据
        //2.如果有图片则上传图片，没有图片则直接提交
        if (checkStatus(retExchYn)) {
            //提交表单数据
            if (mImageUrls.size() > 0) {
                uploadImage();
            } else {
                submitReturnItem(retExchYn, null);
            }
        }
    }

    /**
     * 获取选择原因数量
     *
     * @param list
     * @return
     */
    private int getReasonsCount(ArrayList<ReasonBean> list) {
        int count = 0;
        for (ReasonBean item : list) {
            if (item.isChecked()) {
                count++;
            }
        }
        return count;
    }

    private boolean checkStatus(String type) {


        //检查是否选择原因
        if (getReasonsCount(mListReasons) == 0) {
            showToast(type.equals(TYPE_RETURN_GOODS) ? "请选择退货原因" : "请选择换货原因");
            return false;
        }

        //检查是否描述原因
        if (edtReason.getText().toString().trim().length() == 0) {
            showToast(type.equals(TYPE_RETURN_GOODS) ? "请举例描述您的退货原因" : "请举例描述您的换货原因");
            return false;
        }

        //针对退货
        if (type.equals(TYPE_RETURN_GOODS)) {


        } else {
            //针对换货
            if (TextUtils.isEmpty(exchUnitCode)) {
                showToast("请选择商品规格");
                return false;
            }
        }


        return true;
    }

    private void showToast(String values) {
        ToastUtils.showShortToast(values);
    }

    @OnClick(R.id.ll_good_attr)
    void showItemSpecDialog(View view) {
        getItemsColorSizes();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C003);
    }
}
