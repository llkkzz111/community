package com.ocj.oms.mobile.dialog;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.lzy.imagepicker.ImagePickerProvider;
import com.ocj.oms.mobile.R;
import com.ocj.oms.utils.ActivityStack;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by liutao on 2017/6/27.
 */

public class UpdateDialog extends Dialog {
    @BindView(R.id.tv_content) TextView tvContent;
    @BindView(R.id.pb_update) ProgressBar pbUpdate;
    @BindView(R.id.tv_cancel) TextView tvCancel;
    @BindView(R.id.tv_confirm) TextView tvConfirm;

    private Context context;
    private OnButtonClickListener onButtonClickListener;
    private String apkUrl;
    private String savePath;
    private String saveFileName;
    private int progress;

    private static final int DOWNLOADING = 1;
    private static final int DOWNLOADED = 2;
    private static final int DOWNLOAD_FAILED = 3;

    private boolean cancelFlag = false;

    public void setOnButtonClickListener(OnButtonClickListener onButtonClickListener) {
        this.onButtonClickListener = onButtonClickListener;
    }

    public UpdateDialog(@NonNull Context context) {
        super(context, R.style.MyDialog);
        this.context = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        init();
    }

    public void setTipContent(String content) {
        tvContent.setText(content);
    }

    public void setApkUrl(String apkUrl) {
        this.apkUrl = apkUrl;
    }

    private void init() {
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        View view = LayoutInflater.from(context).inflate(R.layout.dialog_update_layout, null, false);
        setContentView(view);
        ButterKnife.bind(this);
    }

    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case DOWNLOADING:
                    pbUpdate.setProgress(progress);
                    break;
                case DOWNLOADED:
                    installApk(context, saveFileName);
                    ActivityStack.getInstance().appExit();
                    break;
                case DOWNLOAD_FAILED:
                    Toast.makeText(context, "网络断开，请稍候再试", Toast.LENGTH_LONG).show();
                    ActivityStack.getInstance().appExit();
                    break;
                default:
                    break;
            }
        }
    };


    public void downloadAPK() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    URL url = new URL(apkUrl);
                    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                    conn.connect();

                    int length = conn.getContentLength();
                    InputStream is = conn.getInputStream();

                    savePath = "/sdcard/Download/" + "/updateAPK/";

                    File file = new File(savePath);
                    if (!file.exists()) {
                        file.mkdir();
                    }

                    saveFileName = savePath + "apkName.apk";

                    String apkFile = saveFileName;
                    File ApkFile = new File(apkFile);
                    FileOutputStream fos = new FileOutputStream(ApkFile);

                    int count = 0;
                    byte buf[] = new byte[1024];

                    do {
                        int numread = is.read(buf);
                        count += numread;
                        progress = (int) (((float) count / length) * 100);
                        //更新进度
                        mHandler.sendEmptyMessage(DOWNLOADING);
                        if (numread <= 0) {
                            //下载完成通知安装
                            mHandler.sendEmptyMessage(DOWNLOADED);
                            break;
                        }
                        fos.write(buf, 0, numread);
                    } while (!cancelFlag); //点击取消就停止下载.

                    fos.close();
                    is.close();
                } catch (Exception e) {
                    mHandler.sendEmptyMessage(DOWNLOAD_FAILED);
                    e.printStackTrace();
                }
            }
        }).start();
    }

    private boolean installApk(Context context, String filePath) {
        File file = new File(filePath);
        if (!file.exists() || !file.isFile() || file.length() <= 0) {
            return false;
        }
        Intent i = new Intent(Intent.ACTION_VIEW);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            i.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            Uri contentUri = ImagePickerProvider.getUriForFile(context, "com.ocj.oms.mobile.fileProvider", file);
            i.setDataAndType(contentUri, "application/vnd.android.package-archive");
        } else {
            i.setDataAndType(Uri.parse("file://" + filePath), "application/vnd.android.package-archive");
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        }
        context.startActivity(i);
        return true;
    }

    @OnClick({R.id.tv_cancel, R.id.tv_confirm})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_cancel:
                if (onButtonClickListener != null) {
                    onButtonClickListener.onCancelClick();
                }
                cancelFlag = true;
                ActivityStack.getInstance().appExit();
                break;
            case R.id.tv_confirm:
                if (onButtonClickListener != null) {
                    onButtonClickListener.onConfirmClick();
                }
                tvContent.setText("正在下载");
                pbUpdate.setVisibility(View.VISIBLE);
                downloadAPK();
                break;
        }
    }

    public interface OnButtonClickListener {
        void onConfirmClick();

        void onCancelClick();
    }
}
