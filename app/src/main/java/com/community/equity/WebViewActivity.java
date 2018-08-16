package com.community.equity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.webkit.DownloadListener;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.community.equity.base.BaseActivity;
import com.community.equity.popup.SharePopupWindow;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.CDWebChromeClient;
import com.community.equity.view.CDWebView;
import com.community.equity.view.CDWebViewClient;
import com.community.equity.view.bottomsheet.BottomSheetLayout;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

/**
 * Created by Han on 2016/3/9.
 */
public class WebViewActivity extends BaseActivity implements View.OnClickListener {
    public static final int INPUT_FILE_REQUEST_CODE = 1;
    private CDWebView webView;
    private String baseUrl = "";
    private ImageView ivBack;
    private TextView tvTitle;
    private View layout = null;
    private RelativeLayout rlWebParent;
    private ProgressBar mProgressBar;
    private PtrClassicFrameLayout mPtrFrame;
    private ImageView ivShare;
    private IWXAPI WXapi = null;
    private BottomSheetLayout bottomSheetLayout;
    private SharePopupWindow mPopupWindow;
    private String mCameraPhotoPath;
    private ValueCallback<Uri[]> mFilePathCallbacks;
    private ValueCallback<Uri> mFilePathCallback;

    private int holderRes;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_webview_layout);
        baseUrl = getIntent().getStringExtra(IntentKeys.KEY_URL);
        Uri uri = Uri.parse(baseUrl);
        String encodedPath = uri.getEncodedPath();
        if (encodedPath.equals("/topic/pages")) {
            holderRes = R.drawable.img_news_loading;
        } else if (encodedPath.equals("/pitches/search")) {
            holderRes = R.drawable.img_deal_loading;
        } else {
            if (uri.getHost().equals("www.community.com")) {
                holderRes = 0;
            } else {
                holderRes = -1;
            }
        }

        WXapi = WXAPIFactory.createWXAPI(this, ConstantUtils.WEIXIN_APPID, false);
        initView();
        initListener();
        initWebView();
        initPtr();
        mPopupWindow = new SharePopupWindow(this);
        webView.loadUrl(baseUrl);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        baseUrl = intent.getStringExtra(IntentKeys.KEY_URL);
        webView.loadUrl(baseUrl);
    }

    /**
     * 初始化View
     */
    private void initView() {
        bottomSheetLayout = (BottomSheetLayout) findViewById(R.id.bottomsheet);
        ivShare = (ImageView) findViewById(R.id.iv_share);
        webView = (CDWebView) findViewById(R.id.webview);
        ivBack = (ImageView) findViewById(R.id.iv_back);
        tvTitle = (TextView) findViewById(R.id.tv_title);
        mProgressBar = (ProgressBar) findViewById(R.id.progress_bar);
        mPtrFrame = (PtrClassicFrameLayout) findViewById(R.id.rotate_header_web_view_frame);
        rlWebParent = (RelativeLayout) findViewById(R.id.rl_webview_parent);
        layout = LayoutInflater.from(mContext).inflate(R.layout.webview_loading_layout, null);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);
        layout.setLayoutParams(layoutParams);

        if (holderRes >= 0) {
            if (holderRes > 0) {
                LinearLayout llLoadingMain = (LinearLayout) layout.findViewById(R.id.ll_loading_main);
                llLoadingMain.removeAllViews();
                llLoadingMain.setBackgroundResource(holderRes);
            }
            rlWebParent.addView(layout);
        }
    }

    /**
     * 初始化 Listener
     */
    private void initListener() {
        ivBack.setOnClickListener(this);
        ivShare.setOnClickListener(this);
    }

    /**
     * 初始化WebView相关
     */
    private void initWebView() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            if (0 != (getApplicationInfo().flags &= ApplicationInfo.FLAG_DEBUGGABLE)) {
                WebView.setWebContentsDebuggingEnabled(true);
            }
        }
        webView.setDownloadListener(new DownloadListener() {

            @Override
            public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimetype, long contentLength) {
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                startActivity(intent);
            }
        });
        webView.setVerticalScrollBarEnabled(false);
        webView.setWebViewClient(new CDWebViewClient(this) {
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                Uri uri = Uri.parse(url);
                if (uri.getScheme().equals("community")) {
                    Intent intent = new Intent();
                    intent.setAction("com.community.equity.action");
                    intent.setData(uri);
                    startActivity(intent);
                    return true;
                }
                return false;
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                ivShare.setVisibility(View.GONE);
                setTitle(view);
            }


            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                setTitle(view);
                mPtrFrame.refreshComplete();
                //只有本地安装微信，才会将调用js
                if (WXapi.isWXAppInstalled()) {
                    webView.loadUrl("javascript:communityJSBridge.getWechatShareInfo()");
                }

            }
        });
        //将接口注入到JS中
        webView.addJavascriptInterface(this, "communityAndroidBridge");
        webView.setWebChromeClient(new CustomChromeClient(mProgressBar));
    }

    private void setTitle(WebView view) {
        String title = view.getTitle();
        tvTitle.setText(title);
    }

    @JavascriptInterface
    public void getWechatShareInfo(final String shareInfo) {
        if (TextUtils.isEmpty(shareInfo)) {
            ivShare.setVisibility(View.GONE);
            return;
        }
        //注入JS的方法之后必须重新启动一个线程来处理UI操作
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                if (mPopupWindow != null) {
                    mPopupWindow.setShareInfo(shareInfo, ivShare);
                }
            }
        });

    }

    /**
     * 初始化下拉刷新控件
     */
    private void initPtr() {
        mPtrFrame.setLastUpdateTimeRelateObject(getBaseContext());
        mPtrFrame.setPtrHandler(new PtrHandler() {
            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, webView, header);
            }

            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                updateData();
            }

        });
    }

    /**
     * 更新数据
     */
    private void updateData() {
        if (baseUrl.equals(ConstantUtils.URL_ME)) {
            webView.loadUrl(ConstantUtils.URL_ME);
        } else {
            webView.loadUrl(webView.getUrl());
        }
    }


    private void openChooseImage() {
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            // Create the File where the photo should go
            File photoFile = null;
            try {
                photoFile = createImageFile();
                takePictureIntent.putExtra(IntentKeys.KEY_PHOTO_PATH, mCameraPhotoPath);
            } catch (IOException ex) {
                // Error occurred while creating the File
                Log.e("community", "Unable to create Image File", ex);
            }

            // Continue only if the File was successfully created
            if (photoFile != null) {
                mCameraPhotoPath = "file:" + photoFile.getAbsolutePath();
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT,
                        Uri.fromFile(photoFile));
            } else {
                takePictureIntent = null;
            }
        }

        Intent contentSelectionIntent = new Intent(Intent.ACTION_GET_CONTENT);
        contentSelectionIntent.addCategory(Intent.CATEGORY_OPENABLE);
        contentSelectionIntent.setType("image/*");

        Intent[] intentArray;
        if (takePictureIntent != null) {
            intentArray = new Intent[0];
        } else {
            intentArray = new Intent[0];
        }

        Intent chooserIntent = new Intent(Intent.ACTION_CHOOSER);
        chooserIntent.putExtra(Intent.EXTRA_INTENT, contentSelectionIntent);
        chooserIntent.putExtra(Intent.EXTRA_TITLE, "头像选择");
        chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, intentArray);


        startActivityForResult(chooserIntent, INPUT_FILE_REQUEST_CODE);
    }

    /**
     * More info this method can be found at
     * http://developer.android.com/training/camera/photobasics.html
     *
     * @return
     * @throws IOException
     */
    private File createImageFile() throws IOException {
        // Create an image file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
        File storageDir = Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES);
        File imageFile = File.createTempFile(
                imageFileName,  /* prefix */
                ".jpg",         /* suffix */
                storageDir      /* directory */
        );
        return imageFile;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.iv_back:
                Utils.hideInput(webView);
                if (webView == null) {
                    return;
                }
                if (webView.canGoBack()) {
                    webViewGoBack();
                    return;
                } else {
                    finish();
                }
                break;
            case R.id.iv_share:

                mPopupWindow.setBottomSheetLayout(bottomSheetLayout);
                mPopupWindow.popShow(webView);
                break;

        }

    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        switch (keyCode) {
            case KeyEvent.KEYCODE_BACK:
                if (webView == null) {
                    return false;
                }
                if (webView.canGoBack()) {
                    webViewGoBack();
                    return true;
                }

                break;
            default:
                break;
        }
        return super.onKeyDown(keyCode, event);
    }

    private void webViewGoBack() {
        if (!webView.copyBackForwardList().getCurrentItem().getUrl().equals(webView.copyBackForwardList().getCurrentItem().getOriginalUrl())) {
            webView.goBack();
        }
        webView.goBack();
    }


    //最后在OnActivityResult中接受返回的结果
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode != INPUT_FILE_REQUEST_CODE || mFilePathCallback == null && mFilePathCallbacks == null) {
            super.onActivityResult(requestCode, resultCode, data);
            return;
        }

        Uri[] results = null;
        Uri result = null;

        // Check that the response is a good one
        if (resultCode == Activity.RESULT_OK) {
            if (data == null) {
                // If there is not data, then we may have taken a photo
                if (mCameraPhotoPath != null) {
                    results = new Uri[]{Uri.parse(mCameraPhotoPath)};
                    result = Uri.parse(mCameraPhotoPath);
                }
            } else {
                String dataString = data.getDataString();
                if (dataString != null) {
                    results = new Uri[]{Uri.parse(dataString)};
                    result = Uri.parse(dataString);
                }
            }
        }
        if (mFilePathCallback != null) {
            mFilePathCallback.onReceiveValue(result);
            mFilePathCallback = null;
        }
        if (mFilePathCallbacks != null) {
            mFilePathCallbacks.onReceiveValue(results);
            mFilePathCallbacks = null;

        }
        return;
    }


    /**
     * 自定义WebChromeClient
     */
    private class CustomChromeClient extends CDWebChromeClient {

        public CustomChromeClient(ProgressBar mProgressBar) {
            super(mProgressBar);
        }

        @Override
        public void onReceivedTitle(WebView view, String title) {
            super.onReceivedTitle(view, title);
            setTitle(view);
        }

        public void openFileChooser(ValueCallback<Uri> uploadMsg) {
            if (mFilePathCallback != null) {
                mFilePathCallback.onReceiveValue(null);
            }
            mFilePathCallback = uploadMsg;

            openChooseImage();

        }

        @SuppressWarnings("unused")
        public void openFileChooser(ValueCallback<Uri> uploadMsg, String acceptType) {
            openFileChooser(uploadMsg);
        }

        //For Android 4.1
        @SuppressWarnings("unused")
        public void openFileChooser(ValueCallback<Uri> uploadMsg, String acceptType, String capture) {
            openFileChooser(uploadMsg);
        }

        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
        @Override
        public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams) {
            if (mFilePathCallbacks != null) {
                mFilePathCallbacks.onReceiveValue(null);
            }
            mFilePathCallbacks = filePathCallback;

            openChooseImage();
            return true;
        }

        @Override
        public void onProgressChanged(WebView view, int newProgress) {
            super.onProgressChanged(view, newProgress);
            if (newProgress >= 80) {
                if (rlWebParent.getChildCount() > 1 && layout != null)
                    rlWebParent.removeView(layout);
            }
        }
    }
}
