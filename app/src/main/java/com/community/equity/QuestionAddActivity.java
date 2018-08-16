package com.community.equity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;
import android.widget.Toast;

import com.community.equity.api.BaseCallBack;
import com.community.equity.base.BaseActivity;
import com.community.equity.base.BaseApiResponse;
import com.community.equity.selector.PhotoSelectorActivity;
import com.community.equity.selector.model.PhotoModel;
import com.community.equity.utils.BitmapUtils;
import com.community.equity.utils.CollectionUtil;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.DialogFractory;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.CDWebView;
import com.community.equity.view.TopView;
import com.qiniu.android.common.Zone;
import com.qiniu.android.http.ResponseInfo;
import com.qiniu.android.storage.Configuration;
import com.qiniu.android.storage.UpCompletionHandler;
import com.qiniu.android.storage.UpProgressHandler;
import com.qiniu.android.storage.UploadManager;
import com.qiniu.android.storage.UploadOptions;

import org.json.JSONObject;

import java.io.File;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnFocusChange;
import butterknife.OnTextChanged;
import retrofit2.Call;

/**
 * Created by liuzhao on 16/4/13.
 */
public class QuestionAddActivity extends BaseActivity {
    @BindView(R.id.et_question_title)
    EditText etTitle;

    @BindView(R.id.webview)
    CDWebView webView;
    @BindView(R.id.topview)
    TopView topView;

    private String JSGetContent = "javascript:communityJSBridge.getContent()";

    private DialogFractory dialog = new DialogFractory(this);

    private UploadOptions uploadOptions;
    /**
     * 上传图片是否取消
     */
    private int maxLength = ConstantUtils.QUESTION_CONTENT_MAX_LENGTH; //webviewContent长度
    private int titleLength = ConstantUtils.QUESTION_TITLE_MAX_LENGTH;//title长度
    private int webContentLength = 0;//webview已经输入的长度

    private boolean isShowLoading = false;
    private String QiNiuToken;
    /**
     * 上传回调函数
     */
    private UpCompletionHandler completionHandler = new UpCompletionHandler() {
        @Override
        public void complete(String key, ResponseInfo info, JSONObject res) {
            if (!info.isOK()) {
                Toast.makeText(mContext, getString(R.string.text_network_un_smooth), Toast.LENGTH_SHORT).show();
                dialog.dismiss();
                isShowLoading = false;
            }
        }

    };
    private Handler handler = new Handler() {

        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            Utils.showInput(webView);
        }
    };
    /**
     * 七牛上传进度回调
     */
    private UpProgressHandler progressHandler = new UpProgressHandler() {
        public void progress(String key, double percent) {
            upLoadDismissDialog(key, percent);
        }
    };

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_question_add_layout);
        ButterKnife.bind(this);
        topView.setTitle(getString(R.string.text_add_question));
        topView.setLeftImage();
        topView.setRightText(R.string.text_next);
        webView.loadUrl(ConstantUtils.BASE_EDIT_URL);
        initWebViewClient();
        initQiNiuToken(false);
    }

    @OnTextChanged(value = R.id.et_question_title, callback = OnTextChanged.Callback.TEXT_CHANGED)
    void onTextChenge(CharSequence text) {
        int length = etTitle.getText().toString().length();
        checkInputTextLength(length, titleLength);
    }

    @OnFocusChange(R.id.et_question_title)
    void onFocusChange(View v, boolean hasFocus) {
        if (hasFocus) {
            int length = etTitle.getText().toString().length();

            checkInputTextLength(length, titleLength);
        } else {
            checkInputTextLength(webContentLength, maxLength);
        }
    }

    @OnClick({R.id.iv_right, R.id.iv_left})
    void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_right:
                if (TextUtils.isEmpty(etTitle.getText().toString().trim())) {
                    Toast.makeText(mContext, getString(R.string.text_add_question_title), Toast.LENGTH_SHORT).show();
                    return;
                }
                webView.loadUrl(JSGetContent);
                break;
            case R.id.iv_left:
                Utils.hideInput(topView);
                finish();
                break;
        }
    }

    private void checkInputTextLength(int contentLength, int length) {
        setRightTextColor();
        if (contentLength > length) {
            setTitleDisable(contentLength, length);
        } else {
            setTitleEnabled();
        }
    }

    /**
     * 设置发布按钮的字体颜色
     */
    private void setRightTextColor() {
        if (maxLength < webContentLength || titleLength < etTitle.getText().toString().length()) {
            topView.getRightView().setEnabled(false);
            topView.getRightView().setTextColor(getResources().getColor(R.color.grey));
        } else {
            topView.getRightView().setEnabled(true);
            topView.getRightView().setTextColor(getResources().getColor(R.color.tab_check_color));
        }
    }

    private void setTitleDisable(int contentLength, int length) {
        if (!topView.getTitleView().getText().toString().startsWith(getString(R.string.text_has_over))) {
            topView.getTitleView().setTextColor(getResources().getColor(R.color.text_title_warning_text_color));
        }
        topView.setTitle(String.format(
                getString(R.string.text_has_over_text_size),
                (contentLength - length)));
    }

    private void setTitleEnabled() {
        if (topView.getTitleView().getText().toString().startsWith(getString(R.string.text_has_over))) {
            topView.setTitle(getString(R.string.text_add_question));
            topView.getTitleView().setTextColor(getResources().getColor(R.color.text_default_color));
        }
    }

    /**
     * 初始化WebView控件
     */
    private void initWebViewClient() {
        webView.setWebViewClient(new WebViewClient() {
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                if (addLinkOrImage(url)) return;

                webView.loadUrl("javascript:communityJSBridge.setPlaceholder('请填写问题的描述信息')");
                webView.loadUrl("javascript:communityJSBridge.setContentSize(" + maxLength + ")");
            }
        });
        webView.addJavascriptInterface(this, "communityAndroidBridge");
    }

    //获取输入框内容
    @JavascriptInterface
    public void getContent(final String content) {
        //注入JS的方法之后必须重新启动一个线程来处理UI操作
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (etTitle.getText().toString().matches(".+[?？]$")) {
                    Intent intent = new Intent();
                    intent.setClass(mContext, CheckTagActivity.class);
                    intent.putExtra(IntentKeys.KEY_CONTENT, content);
                    intent.putExtra(IntentKeys.KEY_TITLE, etTitle.getText().toString());
                    startActivity(intent);
                } else {
                    Toast.makeText(mContext, "问题标题必须以问号结尾!", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    //获取输入框内容
    @JavascriptInterface
    public void getContentSize(final int contentLength) {
        //注入JS的方法之后必须重新启动一个线程来处理UI操作
        webContentLength = contentLength;
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                checkInputTextLength(contentLength, maxLength);
            }
        });
    }

    /**
     * 添加图片或者链接
     *
     * @param url
     * @return
     */
    private boolean addLinkOrImage(String url) {
        if (url.endsWith("insert-link")) {
            Intent intent = new Intent();
            intent.setClass(mContext, LinkAddActivity.class);
            startActivityForResult(intent, ConstantUtils.ADD_LINK_REQUEST_CODE);
            return true;
        }
        if (url.endsWith("insert-image")) {
            if (TextUtils.isEmpty(QiNiuToken)) {
                initQiNiuToken(true);
            } else {
                startPhotoSelector();
            }
            return true;
        }
        return false;
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

    private void startPhotoSelector() {
        Intent intent = new Intent(mContext, PhotoSelectorActivity.class);
        intent.putExtra(IntentKeys.KEY_MAX, 1);
        startActivityForResult(intent, ConstantUtils.ADD_IMAGE_REQUEST_CODE);
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (isShowLoading) {
            if (!dialog.isShow())
                dialog.showProgress(getSupportFragmentManager().beginTransaction());
        }
    }

    //最后在OnActivityResult中接受返回的结果
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case ConstantUtils.ADD_IMAGE_REQUEST_CODE:
                    upLoadImg(data);
                    break;
                case ConstantUtils.ADD_LINK_REQUEST_CODE:
                    if (data != null) {
                        String title = data.getStringExtra(IntentKeys.KEY_LINK_TITLE);
                        String link = data.getStringExtra(IntentKeys.KEY_LINK_PATH);
                        webView.loadUrl("javascript:communityJSBridge.insertLink({title:'" + title + "',href:'" + link + "'})");
                    }
                    break;
                default:
                    super.onActivityResult(requestCode, resultCode, data);
                    break;
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
        return;
    }

    private void upLoadImg(final Intent data) {
        isShowLoading = false;

        if (data != null) {
            List<PhotoModel> photos = (List<PhotoModel>) data.getExtras()
                    .getSerializable(IntentKeys.KEY_PHOTO_LIST);
            if (!CollectionUtil.isEmpty(photos)) {
                String path = photos.get(0).getOriginalPath();
                if (!TextUtils.isEmpty(path)) {
                    File f = new File(path);
                    if (f.exists()) {
                        if (!BitmapUtils.imageIsDestory(path)) {
                            isShowLoading = true;
                            uploadqiniu(path);
                        } else {
                            Toast.makeText(mContext, getString(R.string.text_img_damage), Toast.LENGTH_SHORT).show();
                        }
                    } else {
                        Toast.makeText(mContext, getString(R.string.text_img_no_existent), Toast.LENGTH_SHORT).show();
                    }
                }
            }
        }
    }

    /**
     * 将将图片上传到七牛
     *
     * @param path
     */
    private void uploadqiniu(final String path) {
        Thread thread = new Thread() {
            @Override
            public void run() {
                byte[] data = BitmapUtils.getimage(path);
                Configuration config = initQNConfig();
                UploadManager uploadManager = new UploadManager(config);
                String key = "community_" + System.currentTimeMillis();
                uploadOptions = new UploadOptions(null, null, false, progressHandler, null);
                if (!TextUtils.isEmpty(QiNiuToken)) {
                    uploadManager.put(data, key, QiNiuToken, completionHandler, uploadOptions);
                }
            }
        };
        thread.start();
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
                .connectTimeout(3) // 链接超时。默认 10秒
                .responseTimeout(10) // 服务器响应超时。默认 60秒
                .zone(Zone.zone0) // 设置区域，指定不同区域的上传域名、备用域名、备用IP。默认 Zone.zone0
                .build();
    }


    private void upLoadDismissDialog(String key, double percent) {
        if (percent == 1) {
            dialog.dismiss();
            isShowLoading = false;
            webView.loadUrl("javascript:communityJSBridge.insertImage('" + key + "')");
            handler.sendEmptyMessage(0);
        }
    }
}
