package com.community.equity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.community.equity.api.BaseCallBack;
import com.community.equity.base.BaseActivity;
import com.community.equity.base.BaseApiResponse;
import com.community.equity.dialog.BaseDialogFragment;
import com.community.equity.entity.ProfileEntity;
import com.community.equity.selector.PhotoSelectorActivity;
import com.community.equity.selector.model.PhotoModel;
import com.community.equity.utils.BitmapUtils;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.CropSquareTransformation;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;
import com.community.imsdk.db.DBHelper;
import com.community.imsdk.db.bean.UserInfo;
import com.qiniu.android.common.Zone;
import com.qiniu.android.http.ResponseInfo;
import com.qiniu.android.storage.Configuration;
import com.qiniu.android.storage.UpCancellationSignal;
import com.qiniu.android.storage.UpCompletionHandler;
import com.qiniu.android.storage.UpProgressHandler;
import com.qiniu.android.storage.UploadManager;
import com.qiniu.android.storage.UploadOptions;

import org.json.JSONObject;

import java.io.File;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit2.Call;

public class PersonalProfileEditActivity extends BaseActivity {
    @BindView(R.id.topview)
    TopView topView;
    @BindView(R.id.iv_head)
    ImageView ivHead;
    @BindView(R.id.tv_profile_nick_name)
    TextView tvNickName;
    @BindView(R.id.tv_profile_title)
    TextView tvTitle;
    @BindView(R.id.tv_desc)
    TextView tvDesc;
    @BindView(R.id.tv_address)
    TextView tvAddress;
    @BindView(R.id.tv_gender)
    TextView tvGender;
    @BindView(R.id.tv_experience)
    TextView tvExperience;
    @BindView(R.id.tv_education)
    TextView tvEducation;

    private ProfileEntity profile;
    private UserInfo userInfo;
    private String QiNiuToken = "";
    private UploadOptions uploadOptions;
    /**
     * 上传图片是否取消
     */
    private volatile boolean isCancelled = false;
    private boolean isShowLoading = false;
    private BaseDialogFragment dialog = BaseDialogFragment.newInstance();
    private boolean isChengeHeadImg = false;
    /**
     * 上传回调函数
     */
    private UpCompletionHandler completionHandler = new UpCompletionHandler() {
        @Override
        public void complete(String key, ResponseInfo info, JSONObject res) {
            if (!info.isOK()) {
                Toast.makeText(mContext, getString(R.string.text_network_un_smooth), Toast.LENGTH_SHORT).show();
                cancell();
                dialog.dismissAllowingStateLoss();
                isShowLoading = false;
            }
        }

    };
    /**
     * 取消上传，当isCancelled()返回true时，不再执行更多上传。
     */
    private UpCancellationSignal cancellationSignal = new UpCancellationSignal() {
        @Override
        public boolean isCancelled() {
            return isCancelled;
        }
    };
    /**
     * 七牛上传进度回调
     */
    private UpProgressHandler progressHandler = new UpProgressHandler() {
        public void progress(String key, double percent) {
            if (percent == 1) {
                initUpdateUserHead(key);
            }
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_personal_profile_edit_layout);
        ButterKnife.bind(this);
        topView.setLeftImage();
        initQiNiuToken(false);
        if (profile == null) {
            userInfo = DBHelper.getInstance().queryUniqueUserInfo(ConstantUtils.USER_ID);
            profile = Utils.toProfile(userInfo);
        }
        showView();
    }

    private void initQiNiuToken(final boolean isJump) {
        Call<BaseApiResponse> call = service.getQiniuToken();
        call.enqueue(new BaseCallBack<BaseApiResponse>() {
            @Override
            protected void onSuccess(BaseApiResponse body) {
                QiNiuToken = body.getToken();
                if (isJump) {
                    startPhotoSelector();
                }
            }

            @Override
            protected void onFailure(int code, String msg) {
                if (isJump) {
                    Toast.makeText(mContext, getString(R.string.text_network_error), Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (isShowLoading) {
            dialog.addProgress();
            dialog.show(getSupportFragmentManager(), "loading");
        }
        initData();
    }

    private void initData() {
        Map<String, Object> map = new IdentityHashMap<>();
        Call<ProfileEntity> repos = service.getUserProfile(map);
        repos.enqueue(new BaseCallBack<ProfileEntity>() {

            @Override
            public void onSuccess(ProfileEntity response) {
                profile = response;
                showView();
            }

            @Override
            public void onFailure(int code, String response) {
                if (profile == null) {
                    userInfo = DBHelper.getInstance().queryUniqueUserInfo(ConstantUtils.USER_ID);
                    profile = Utils.toProfile(userInfo);
                }
                showView();
            }
        });
    }

    private void showView() {
        topView.setTitle(profile.getUser().getName());
        tvNickName.setText(profile.getUser().getName());
        tvGender.setText(profile.getGender());
        tvExperience.setText(profile.getExperience());
        tvEducation.setText(profile.getEducation());
        tvDesc.setText(profile.getDesc());
        tvAddress.setText(profile.getAddress());
        tvTitle.setText(profile.getTitle());
        if (!isChengeHeadImg)
            if (Util.isOnMainThread() && !isDestory)
                Glide.with(this).load(profile.getUser().getImg()).placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext)).into(ivHead);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        isShowLoading = false;
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case ConstantUtils.ADD_IMAGE_REQUEST_CODE:
                    if (data != null) {
                        List<PhotoModel> photos = (List<PhotoModel>) data.getExtras()
                                .getSerializable(IntentKeys.KEY_PHOTO_LIST);
                        String path = photos.get(0).getOriginalPath();
                        File f = new File(path);
                        if (f.exists() && !isDestory) {
                            Glide.with(this).load("file://" + path).placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mContext)).into(ivHead);
                            upLoadHeadImg(path);
                        } else {
                            Toast.makeText(mContext, getString(R.string.text_img_no_existent), Toast.LENGTH_SHORT).show();
                        }
                    }
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    private void upLoadHeadImg(final String path) {
        if (!TextUtils.isEmpty(path)) {
            if (!BitmapUtils.imageIsDestory(path)) {
                isShowLoading = true;
                Thread thread = new Thread() {
                    @Override
                    public void run() {
                        super.run();
                        uploadqiniu(BitmapUtils.getimage(path));
                    }
                };
                thread.start();

            } else {

                Toast.makeText(mContext, getString(R.string.text_img_damage), Toast.LENGTH_SHORT).show();
            }
        }

    }

    @OnClick({R.id.iv_left, R.id.ll_gender, R.id.ll_nick_name, R.id.ll_education, R.id.ll_address, R.id.ll_desc, R.id.ll_experience, R.id.ll_title, R.id.ll_head})
    public void onClick(View v) {
        Intent intent = new Intent();
        intent.putExtra(IntentKeys.KEY_TYPE, v.getId());
        intent.setClass(mContext, ProfileUpdateActivity.class);
        switch (v.getId()) {
            case R.id.ll_head:
                isChengeHeadImg = true;
                if (TextUtils.isEmpty(QiNiuToken)) {
                    initQiNiuToken(true);
                } else {
                    startPhotoSelector();
                }
                break;
            case R.id.ll_address:
                intent.putExtra(IntentKeys.KEY_TITLE, "城市");
                intent.putExtra(IntentKeys.KEY_CONTENT, profile.getAddress());
                intent.putExtra(IntentKeys.KEY_HINT_TEXT, tvAddress.getHint().toString());
                break;
            case R.id.ll_gender:
                intent.putExtra(IntentKeys.KEY_TITLE, "性别");
                intent.putExtra(IntentKeys.KEY_CONTENT, profile.getGender());
                intent.putExtra(IntentKeys.KEY_HINT_TEXT, tvGender.getText().toString());
                break;
            case R.id.ll_experience:
                intent.putExtra(IntentKeys.KEY_TITLE, "工作经验");
                intent.putExtra(IntentKeys.KEY_CONTENT, profile.getExperience());
                intent.putExtra(IntentKeys.KEY_HINT_TEXT, tvExperience.getHint().toString());
                break;
            case R.id.ll_education:
                intent.putExtra(IntentKeys.KEY_TITLE, "教育经历");
                intent.putExtra(IntentKeys.KEY_CONTENT, profile.getEducation());
                intent.putExtra(IntentKeys.KEY_HINT_TEXT, tvEducation.getHint().toString());
                break;
            case R.id.ll_desc:
                intent.putExtra(IntentKeys.KEY_TITLE, "个人简介");
                intent.putExtra(IntentKeys.KEY_HINT_TEXT, tvDesc.getHint().toString());
                intent.putExtra(IntentKeys.KEY_CONTENT, profile.getDesc());
                break;
            case R.id.ll_title:
                intent.putExtra(IntentKeys.KEY_TITLE, "一句话头衔");
                intent.putExtra(IntentKeys.KEY_CONTENT, profile.getTitle());
                intent.putExtra(IntentKeys.KEY_HINT_TEXT, tvTitle.getHint().toString());
                break;
            case R.id.ll_nick_name:
                intent.putExtra(IntentKeys.KEY_TITLE, "昵称");
                intent.putExtra(IntentKeys.KEY_CONTENT, profile.getUser().getName());
                intent.putExtra(IntentKeys.KEY_HINT_TEXT, tvNickName.getHint().toString());
                break;
            case R.id.iv_left:
                finish();
                return;
        }
        if (v.getId() != R.id.ll_head)
            startActivity(intent);
    }

    private void startPhotoSelector() {
        isShowLoading = true;
        Intent intent1 = new Intent(mContext, PhotoSelectorActivity.class);
        intent1.putExtra(IntentKeys.KEY_MAX, 1);
        startActivityForResult(intent1, ConstantUtils.ADD_IMAGE_REQUEST_CODE);
    }

    /**
     * 将将图片上传到七牛
     *
     * @param data
     */
    private void uploadqiniu(byte[] data) {
        Configuration config = initQNConfig();
        UploadManager uploadManager = new UploadManager(config);
        String key = "community_" + System.currentTimeMillis() + "";
        uploadOptions = new UploadOptions(null, null, false, progressHandler, cancellationSignal);
        if (!TextUtils.isEmpty(QiNiuToken)) {
            uploadManager.put(data, key, QiNiuToken, completionHandler, uploadOptions);
        }
    }

    /**
     * 初始化七牛config
     *
     * @return
     */
    private Configuration initQNConfig() {
        return new Configuration.Builder()
                .chunkSize(256 * 1024)  //分片上传时，每片的大小。 默认 256K
                .putThreshhold(512 * 1024)  // 启用分片上传阀值。默认 512K
                .connectTimeout(5) // 链接超时。默认 10秒
                .responseTimeout(10) // 服务器响应超时。默认 60秒
                .zone(Zone.zone0) // 设置区域，指定不同区域的上传域名、备用域名、备用IP。默认 Zone.zone0
                .build();
    }

    private void cancell() {
        isCancelled = true;
    }

    private void initUpdateUserHead(String key) {

        Map<String, Object> params = new IdentityHashMap<>();
        params.put("user[avatar]", key);
        Call<ProfileEntity> repos = service.userProfileUpdateHeadImg(params);
        repos.enqueue(new BaseCallBack<ProfileEntity>() {

            @Override
            public void onSuccess(ProfileEntity response) {
                if (response != null) {
                    Toast.makeText(mContext, "头像修改成功", Toast.LENGTH_SHORT).show();
                }
            }

            @Override
            public void onFailure(int code, String response) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                Toast.makeText(getBaseContext(), String.format(sInfoFormat, response, String.valueOf(code)), Toast.LENGTH_SHORT).show();
            }

            @Override
            public void onFinish() {
                isShowLoading = false;
                if (dialog != null)
                    dialog.dismissAllowingStateLoss();
            }
        });

    }


}
