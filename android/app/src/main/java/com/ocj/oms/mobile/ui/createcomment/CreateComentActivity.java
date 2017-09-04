package com.ocj.oms.mobile.ui.createcomment;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.alibaba.android.arouter.facade.annotation.Route;
import com.blankj.utilcode.utils.LogUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.google.gson.Gson;
import com.lzy.imagepicker.bean.ImageItem;
import com.ocj.oms.common.net.HttpParameterBuilder;
import com.ocj.oms.common.net.callback.ApiResultObserver;
import com.ocj.oms.common.net.exception.ApiException;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.CommentBean;
import com.ocj.oms.mobile.bean.CommentListBean;
import com.ocj.oms.mobile.bean.DataBean;
import com.ocj.oms.mobile.bean.ItemsBeanX;
import com.ocj.oms.mobile.bean.REPictureBeanNew;
import com.ocj.oms.mobile.bean.Result;
import com.ocj.oms.mobile.http.service.items.ItemsMode;
import com.ocj.oms.mobile.ui.adapter.CommentsAdapter;
import com.ocj.oms.mobile.ui.pickimg.AbsPickImgActivity;
import com.ocj.oms.mobile.ui.rn.RouterModule;
import com.ocj.oms.utils.OCJPreferencesUtils;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;

import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;
import id.zelory.compressor.Compressor;
import okhttp3.RequestBody;

@Route(path = RouterModule.AROUTER_PATH_COMMENT)
public class CreateComentActivity extends AbsPickImgActivity implements IcommentAdpterBack {
    @BindView(R.id.iv_back) ImageView ivBack;
    @BindView(R.id.tv_title) TextView tvTitle;
    @BindView(R.id.iv_publish) TextView ivEdit;
    @BindView(R.id.re_title) RelativeLayout reTitle;
    @BindView(R.id.lv_comment) ListView lvComment;
    private CommentsAdapter adapter;
    public HashMap<Integer, String> comments = new HashMap<>();//存储评论内容集合

    public HashMap<Integer, Map<Integer, Float>> stars = new HashMap<>();//存储评论星级
    private DataBean dataBean;
    public static final int IMG_MAX_NUM = 9;//最多提交图片张数
    private String orderNo;
    private String ordertype;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_create_coment;
    }

    @Override
    protected void initEventAndData() {

        OcjStoreDataAnalytics.trackPageBegin(mContext, ActivityID.AP1706C004);
        //{"orderNo":"20170620407561","ordertype":"ORDER"}
        Intent intent = getIntent();
        String goodsinfo = intent.getStringExtra("goodsinfo");
        //orderNo和ordertype
        try {
            JSONObject object = new JSONObject(goodsinfo);
            orderNo = object.getString("orderNo");
            ordertype = object.getString("ordertype");
        } catch (Exception e) {

        }
        getGoodsLsit();
    }

    /**
     * 获取订单列表
     */
    private void getGoodsLsit() {


//        access_token	用户票据
//        order_no	订单ID
//        order_type	订单类型 'ORDER' 订购  'PREORDER' 预约
//        c_code	公司编码默认写2000
        LogUtils.d("token:", OCJPreferencesUtils.getAccessToken());
        Map<String, String> params = new HashMap<String, String>();
        params.put("order_no", orderNo);
        params.put("order_type", ordertype);
       /* params.put("order_no", "20170615130979");
        params.put("order_type", "ORDER");*/
        params.put("c_code", "2000");
        showLoading();
        new ItemsMode(mContext).getCommentItems(params, new ApiResultObserver<DataBean>(mContext) {
            @Override
            public void onSuccess(DataBean apiResult) {
                LogUtils.d("onSuccess:" + apiResult.toString());
                dataBean = apiResult;
                adapter = new CommentsAdapter(CreateComentActivity.this, dataBean);
                lvComment.setAdapter(adapter);
                hideLoading();
            }

            @Override
            public void onError(ApiException e) {
                LogUtils.d("onError:" + e.toString());
                ToastUtils.showLongToast(e.getMessage());
                hideLoading();
            }
        });
    }


    @OnClick({R.id.iv_back, R.id.iv_publish})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_back:
                finish();
                break;
            case R.id.iv_publish:
                // upLoadImageNew();
                upLoadImage();
                //发布评论
                break;

        }
    }

    private int total = 0;

    /**
     * 上传图片
     */
    private void upLoadImage() {
        boolean comment = false;//是否有内容
        boolean star = true;//是否有评分
        boolean imgFlag = false;//是否有图片
        for (int i = 0; i < dataBean.getItems().size(); i++) {
            ItemsBeanX item = dataBean.getItems().get(i);
            if (null != item.getStars().get(0)) {
                if (item.getStars().get(0) == 0.0) {
                    star = false;
                    break;
                }
            }
            if (null != item.getStars().get(1)) {
                if (item.getStars().get(1) == 0.0) {
                    star = false;
                    break;
                }
            }
            if (null != item.getStars().get(2)) {
                if (item.getStars().get(2) == 0.0) {
                    star = false;
                    break;
                }
            }
            if (null != item.getStars().get(3)) {
                if (item.getStars().get(3) == 0.0) {
                    star = false;
                    break;
                }
            }

            if (null != item.getComment() && !TextUtils.isEmpty(item.getComment().trim())) {
                comment = true;
                break;
            }


        }
        for (int i = 0; i < dataBean.getItems().size(); i++) {
            ItemsBeanX item = dataBean.getItems().get(i);
            if (null != item.getListUri() && item.getListUri().size() > 0) {
                imgFlag = true;
            }

        }
        if (!star) {
            ToastUtils.showLongToast("评论分数不能为空");
            return;
        }
        if (!comment) {
            ToastUtils.showLongToast("评论不能为空");
            return;
        }
        if (!imgFlag) {
            setSever();
        } else {
            for (int i = 0; i < dataBean.getItems().size(); i++) {
                ArrayList<String> urilist = dataBean.getItems().get(i).getListUri();
                showLoading();
                ItemsBeanX itemsBeanX = dataBean.getItems().get(i);
                HttpParameterBuilder builder = HttpParameterBuilder.newBuilder();
                builder.addParameter("orderNo", dataBean.getOrder_no());
                builder.addParameter("orderGSeq", itemsBeanX.getOrder_g_seq());
                builder.addParameter("orderDSeq", itemsBeanX.getOrder_d_seq());
                builder.addParameter("orderWSeq", itemsBeanX.getOrder_w_seq());
                builder.addParameter("ItemCode", itemsBeanX.getItem_code());
                builder.addParameter("UnitCode", itemsBeanX.getUnit_code());
                builder.addParameter("receiverSeq", itemsBeanX.getReceiver_seq());
                for (int j = 0; j < urilist.size(); j++) {
                    File file = new File(urilist.get(j));
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
                new ItemsMode(mContext).uploadCommentPicture(builder.bulider(), new ApiResultObserver<REPictureBeanNew>(mContext) {
                    @Override
                    public void onSuccess(REPictureBeanNew apiResult) {
                        Log.i("tag", apiResult.toString());
                        if (apiResult != null && apiResult.getCommentPictureList() != null) {
                            for (int j = 0; j < dataBean.getItems().size(); j++) {
                                if (dataBean.getItems().get(j).getItem_code().equals(apiResult.getItemCode())) {
                                    dataBean.getItems().get(j).setUrllist(apiResult.getCommentPictureList());
                                }
                            }
                            total++;
                            if (total == dataBean.getItems().size()) {//上传图片完成
                                setSever();
                                LogUtils.d("上传图片完成");
                            }
                        }

                        maiDian();
                    }

                    @Override
                    public void onError(ApiException e) {
                        Log.i("tag", e.toString());
                        ToastUtils.showShortToast(e.getMessage());
                        hideLoading();
                    }

                    @Override
                    public void onComplete() {
                        super.onComplete();
                        hideLoading();
                    }
                });
            }
        }
    }

    /**
     * 埋点
     */
    private void maiDian() {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("type", ordertype);
        params.put("orderid", orderNo);
        OcjStoreDataAnalytics.trackEvent(mContext, EventId.AP1706C030F012004O006003, "", params);
    }

    private void setSever() {
        CommentListBean listbean = new CommentListBean();
        List<CommentBean> list = new ArrayList<CommentBean>();
        for (int i = 0; i < dataBean.getItems().size(); i++) {
            ItemsBeanX item = dataBean.getItems().get(i);
            CommentBean commentbean = new CommentBean();
            commentbean.setItem_code(item.getItem_code());
            commentbean.setOrder_no(dataBean.getOrder_no());
            commentbean.setEvaluate(item.getComment());
            if (null != item.getStars().get(0)) {
                commentbean.setScore1(Float.toString(item.getStars().get(0)).substring(0, 1));
            } else {
                commentbean.setScore1("5");
            }
            if (null != item.getStars().get(1)) {
                commentbean.setScore2(Float.toString(item.getStars().get(1)).substring(0, 1));
            } else {
                commentbean.setScore2("5");
            }
            if (null != item.getStars().get(2)) {
                commentbean.setScore3(Float.toString(item.getStars().get(2)).substring(0, 1));
            } else {
                commentbean.setScore3("5");
            }
            if (null != item.getStars().get(3)) {
                commentbean.setScore4(Float.toString(item.getStars().get(3)).substring(0, 1));
            } else {
                commentbean.setScore4("5");
            }

            //图片url处理
            String srcstr = "";
            if (null != item.getUrllist()) {
                for (int j = 0; j < item.getUrllist().size(); j++) {
                    if (j == 0) {
                        srcstr = item.getUrllist().get(j);
                    } else {
                        srcstr = srcstr + "," + item.getUrllist().get(j);
                    }
                }
            }
            commentbean.setSrc(srcstr);
            list.add(commentbean);
        }
        listbean.setList(list);
        Gson gson = new Gson();
        String route = gson.toJson(listbean);
        LogUtils.d("json内容:" + route);
        RequestBody body = RequestBody.create(okhttp3.MediaType.parse("application/json; charset=utf-8"), route);

        new ItemsMode(mContext).uploadComment(body, new ApiResultObserver<Result<String>>(mContext) {
            @Override
            public void onSuccess(Result<String> apiResult) {
                hideLoading();
                ToastUtils.showShortToast("评价成功");
                RouterModule.invokeCallback(new JSONObject());
//                finish();
            }

            @Override
            public void onError(ApiException e) {
                ToastUtils.showShortToast(e.getMessage());
                hideLoading();
            }
        });

    }

    /**
     * 适配器评论内容回调
     *
     * @param s
     * @param position
     */
    @Override
    public void getText(String s, int position) {
        comments.put(position, s);
        Log.d("TAG", "comments:" + comments.toString());
    }


    /**
     * 适配器星星评价回调
     *
     * @param f
     * @param positon
     * @param type
     */
    @Override
    public void getRating(Float f, int positon, int type) {
        if (null == stars.get(positon)) {//第一次星星
            HashMap<Integer, Float> map = new HashMap<>();
            map.put(type, f);
            Log.d("TAG", "if+position+type+float:" + positon + " " + type + "  " + f);
        } else {
            stars.get(positon).put(type, f);
            Log.d("TAG", "else+position+type+float:" + positon + "  " + type + "  " + f);
        }
        Log.d("TAG", "stars:" + stars.toString());
    }

    private int currentIndex;

    // adapter 照片选择的回调
    @Override
    public void getPhoto(int position) {
        currentIndex = position;
    }

//    private ArrayList<String> mImageUrls;

    //选择图片的回调
    @Override
    public void handleSelectImages(ArrayList<ImageItem> images) {
        LogUtils.d("images", images.toString());
        ArrayList<String> mImageUrls = new ArrayList<>();
        for (int i = 0; i < images.size(); i++) {
            mImageUrls.add(images.get(i).path);
        }
        LogUtils.d("currentIndex:" + currentIndex);
        if (null != dataBean.getItems().get(currentIndex).getListUri()) {
            dataBean.getItems().get(currentIndex).getListUri().addAll(mImageUrls);
        } else {
            dataBean.getItems().get(currentIndex).setListUri(mImageUrls);
        }
        adapter.notifyDataSetChanged();
        LogUtils.d("mImageUrls:" + mImageUrls.toString());
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OcjStoreDataAnalytics.trackPageEnd(mContext, ActivityID.AP1706C004);
    }
}
