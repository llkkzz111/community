package com.choudao.equity;

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
import android.widget.TextView;
import android.widget.Toast;

import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.base.BaseApiResponse;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.entity.AnswerEntity;
import com.choudao.equity.selector.PhotoSelectorActivity;
import com.choudao.equity.selector.model.PhotoModel;
import com.choudao.equity.utils.BitmapUtils;
import com.choudao.equity.utils.CollectionUtil;
import com.choudao.equity.utils.ConstantUtils;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.CDWebView;
import com.choudao.equity.view.TopView;
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
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import retrofit2.Call;

/**
 * Created by liuzhao on 16/4/13.
 */
public class AnswerAddActivity extends BaseActivity {

    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.webview) CDWebView webView;
    @BindView(R.id.iv_right) TextView tvRight;
    private boolean isFinish = false;
    private boolean isAdd = false;
    private BaseDialogFragment dialog = BaseDialogFragment.newInstance();
    private boolean isShowLoading = false;
    private String QiNiuToken;
    private int questionId;
    private int type = -1;
    private AnswerEntity answer;

    private String JSGetContent = "javascript:ChoudaoJSBridge.getContent()";
    private String JSSetPlaceholder = "javascript:ChoudaoJSBridge.setPlaceholder('填写答案内容')";

    private UploadOptions uploadOptions;
    /**
     * 上传图片是否取消
     */
    private volatile boolean isCancelled = false;

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
    private int maxLength = ConstantUtils.ANSWER_CONTENT_MAX_LENGTH;
    private String msg = "";

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        questionId = getIntent().getIntExtra(IntentKeys.KEY_QUESTION_ID, -1);
        if (getIntent().hasExtra(IntentKeys.KEY_ANSWER_ENTITY)) {
            type = 1;
            answer = (AnswerEntity) getIntent().getSerializableExtra(IntentKeys.KEY_ANSWER_ENTITY);
        } else {
            type = 0;
        }
        setContentView(R.layout.activity_answer_add_layout);
        ButterKnife.bind(this);
        webView.loadUrl(ConstantUtils.BASE_EDIT_URL);
        initTopView();
        initWebViewClient();
        initQiNiuToken(false);
    }

    /**
     * 初始化
     */
    private void initTopView() {
        if (type == 0) {
            topView.setTitle(R.string.text_add_answer);
        } else if (type == 1) {
            topView.setTitle(R.string.text_update_answer);
        }
        topView.setLeftImage();
        topView.setRightText(R.string.text_send);
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

                if (!isFinish)
                    Utils.showInput(webView);
                if (type == 1) {
                    webView.loadUrl("javascript:ChoudaoJSBridge.setContent('" + answer.getContent() + "')");
                } else if (type == 0) {
                    webView.loadUrl(JSSetPlaceholder);
                }
                webView.loadUrl("javascript:ChoudaoJSBridge.setContentSize(" + maxLength + ")");
            }
        });
        webView.addJavascriptInterface(this, "ChoudaoAndroidBridge");
    }

    /**
     * 添加图片或者链接
     *
     * @param url
     * @return
     */
    private boolean addLinkOrImage(String url) {
        if (url.endsWith("insert-link") && !isAdd) {
            isAdd = true;
            Intent intent = new Intent();
            intent.setClass(mContext, LinkAddActivity.class);
            startActivityForResult(intent, ConstantUtils.ADD_LINK_REQUEST_CODE);
            return true;
        }
        if (url.endsWith("insert-image") && !isAdd) {
            isAdd = true;
            isCancelled = false;
            if (TextUtils.isEmpty(QiNiuToken)) {
                initQiNiuToken(true);
            } else {
                startPhotoSelector();
            }
            return true;
        }
        return false;
    }

    /**
     * 获取七牛token
     *
     * @param isJump
     */
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

    /**
     * 打开图片选择
     */
    private void startPhotoSelector() {
        Intent intent = new Intent(mContext, PhotoSelectorActivity.class);
        intent.putExtra(IntentKeys.KEY_MAX, 1);
        startActivityForResult(intent, ConstantUtils.ADD_IMAGE_REQUEST_CODE);
    }

    //获取输入框内容
    @JavascriptInterface
    public void getContent(final String content) {
        //注入JS的方法之后必须重新启动一个线程来处理UI操作
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (!TextUtils.isEmpty(content)) {
                    addOrUpdateAnswer(content);
                } else {
                    if (type == 0) {
                        Toast.makeText(mContext, "请输入回答内容", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(mContext, "请输入修改内容", Toast.LENGTH_SHORT).show();
                    }
                }
            }
        });
    }

    @OnClick({R.id.iv_left, R.id.iv_right})
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_right:
                tvRight.setEnabled(false);
                webView.loadUrl(JSGetContent);
                Utils.hideInput(v);
                break;
            case R.id.iv_left:
                isFinish = true;
                finish();
                break;
        }
        Utils.hideInput(v);
    }


    private void addOrUpdateAnswer(String content) {
        Call<AnswerEntity> call = null;

        if (type == 0) {
            call = service.addAnswers(questionId, content);
            msg = "回答添加成功";
        } else {
            call = service.updateAnswer(questionId, answer.getId(), content);
            msg = "回答修改成功";
        }
        call.enqueue(new BaseCallBack<AnswerEntity>() {
            @Override
            protected void onSuccess(AnswerEntity body) {
                if (body != null) {
                    Intent intent = new Intent();
                    intent.putExtra(IntentKeys.KEY_ANSWER_ENTITY, body);
                    setResult(Activity.RESULT_OK, intent);
                    Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
                    finish();
                }
            }

            @Override
            protected void onFailure(int code, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                Toast.makeText(getBaseContext(), String.format(sInfoFormat, msg, String.valueOf(code)), Toast.LENGTH_SHORT).show();
            }
        });
    }

    //获取输入框内容
    @JavascriptInterface
    public void getContentSize(final int content) {
        //注入JS的方法之后必须重新启动一个线程来处理UI操作
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                checkInputTextLength(content, maxLength);
            }
        });
    }

    /**
     * 检查输入回答长度并提示
     *
     * @param contentLength
     * @param length
     */
    private void checkInputTextLength(int contentLength, int length) {
        if (contentLength > length) {
            setRightDisable(contentLength, length);
        } else {
            setRightEnabled();
        }
    }

    private void setRightEnabled() {
        if (topView.getTitleView().getText().toString().startsWith(getString(R.string.text_has_over))) {
            if (type == 0) {
                topView.setTitle(R.string.text_add_answer);
            } else if (type == 1) {
                topView.setTitle(R.string.text_update_answer);
            }
            topView.getRightView().setEnabled(true);
            topView.getTitleView().setTextColor(getResources().getColor(R.color.text_default_color));
            topView.getRightView().setTextColor(getResources().getColor(R.color.tab_check_color));
        }
    }

    private void setRightDisable(int contentLength, int length) {
        if (!topView.getTitleView().getText().toString().startsWith(getString(R.string.text_has_over))) {
            topView.getRightView().setEnabled(false);
            topView.getTitleView().setTextColor(getResources().getColor(R.color.text_title_warning_text_color));
            topView.getRightView().setTextColor(getResources().getColor(R.color.grey));
        }
        topView.setTitle(String.format(
                getString(R.string.text_has_over_text_size),
                (contentLength - length)));

    }


    @Override
    protected void onResume() {
        super.onResume();
        isAdd = false;
        isFinish = false;
        if (isShowLoading) {
            dialog.addProgress();
            dialog.show(getSupportFragmentManager(), "loading");
        }
    }


    @Override
    protected void onPause() {
        super.onPause();
        isFinish = true;
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
                        webView.loadUrl("javascript:ChoudaoJSBridge.insertLink({title:'" + title + "',href:'" + link + "'})");
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
                String key = "choudao_" + System.currentTimeMillis();
                uploadOptions = new UploadOptions(null, null, false, progressHandler, cancellationSignal);
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
                .connectTimeout(5) // 链接超时。默认 10秒
                .responseTimeout(10) // 服务器响应超时。默认 60秒
                .zone(Zone.zone0) // 设置区域，指定不同区域的上传域名、备用域名、备用IP。默认 Zone.zone0
                .build();
    }

    private void cancell() {
        isCancelled = true;
    }

    private void upLoadDismissDialog(String key, double percent) {
        if (percent == 1) {
            dialog.dismissAllowingStateLoss();
            isShowLoading = false;
            webView.loadUrl("javascript:ChoudaoJSBridge.insertImage('" + key + "')");
            handler.sendEmptyMessage(0);
        }
    }

}
