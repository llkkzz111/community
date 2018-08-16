package com.community.equity.utils;

import android.app.NotificationManager;
import android.os.AsyncTask;
import android.support.annotation.NonNull;
import android.support.v4.app.NotificationCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.community.equity.R;
import com.community.equity.base.BaseActivity;
import com.community.equity.dialog.BaseDialogFragment;
import com.community.equity.entity.UpdateEntity;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Serializable;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Locale;

/**
 * Created by liuzhao on 16/7/29.
 */

public class VersionUpdate {
    private UpdateEntity updateEntity;
    private BaseDialogFragment dialog;
    private BaseActivity mContext;
    private TextView btnCancle, btnConfirm;
    private TextView tvUpdateTip;

    public VersionUpdate(BaseActivity mContext, UpdateEntity updateEntity) {
        this.updateEntity = updateEntity;
        this.mContext = mContext;
    }

    public void invoke() {
        String localVers = Utils.getVersion(mContext);
        String latestVers = updateEntity.getLatest();
        //判断是否忽略当前版本更新
        if (!latestVers.equals(PreferencesUtils.getIsIngoreVersion())) {
            //判断是否需要更新
            if (Utils.needUpdate(localVers, latestVers)) {
                if (updateEntity.getMustUpdate()) {
                    dialog = BaseDialogFragment.newInstance(BaseDialogFragment.DIALOG_UNDISMISS);
                } else {
                    dialog = new BaseDialogFragment();
                }
                dialog.addView(getView());
                dialog.show(mContext.getSupportFragmentManager(), "update");
            }
        }
    }

    @NonNull
    private View getView() {
        View view = LayoutInflater.from(mContext).inflate(R.layout.dialog_update_layout, null);
        final ImageView ivBanner = (ImageView) view.findViewById(R.id.iv_banner);
        setViewHeight(ivBanner);
        LinearLayout llIngore = (LinearLayout) view.findViewById(R.id.ll_ingore);
        TextView tvIngore = (TextView) view.findViewById(R.id.tv_ingore);
        TextView tvUpdate = (TextView) view.findViewById(R.id.tv_update_now);
        TextView tvTitle = (TextView) view.findViewById(R.id.tv_update_title);
        TextView tvDetail = (TextView) view.findViewById(R.id.tv_update_detail);
        tvTitle.setText(updateEntity.getTitle());
        tvDetail.setText(updateEntity.getChanges());
        if (updateEntity.getMustUpdate()) {
            llIngore.setVisibility(View.GONE);
        }
        tvIngore.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PreferencesUtils.setIsingoreVersion(updateEntity.getLatest());
                dialog.dismissAllowingStateLoss();
            }
        });

        tvUpdate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String downloadUrl = updateEntity.getDownload_url();
                if (!TextUtils.isEmpty(downloadUrl)) {
                    String fileName = "community_" + updateEntity.getLatest() + ".apk";
                    String filePath = FileUtils.getSavePath(mContext, "/community/apks/") + "/" + fileName;
                    if ((new File(filePath)).exists()) {
                        PackageUtils.upDateApk(mContext, filePath);
                        return;
                    }
//                    if (updateEntity.getMustUpdate()) {
//                        Toast.makeText(mContext, "开始下载...", Toast.LENGTH_SHORT).show();
//                        Intent intent = new Intent(mContext, NotificationDownloadService.class);
//                        intent.putExtra("id", 1);
//                        intent.putExtra(IntentKeys.KEY_FILE_PATH, filePath);
//                        intent.putExtra(IntentKeys.KEY_DOWNLOAD_URL, downloadUrl);
//                        mContext.startService(intent);
//                    } else {
                    showDownloadDialog(filePath, downloadUrl);
//                    }
                }
            }
        });
        return view;
    }

    private void showDownloadDialog(final String filePath, String url) {
        dialog.dismissAllowingStateLoss();
        if (updateEntity.getMustUpdate()) {
            dialog = BaseDialogFragment.newInstance(BaseDialogFragment.DIALOG_UNDISMISS);
        } else {
            dialog = new BaseDialogFragment();
        }
        View view = LayoutInflater.from(mContext).inflate(R.layout.dialog_downloading_layout, null);
        ProgressBar progressBar = (ProgressBar) view.findViewById(R.id.progress_bar);
        tvUpdateTip = (TextView) view.findViewById(R.id.tv_update_tip);
        tvUpdateTip.setText(mContext.getString(R.string.text_update_version_download_tip) + " 0%");
        btnCancle = (TextView) view.findViewById(R.id.btn_cancle);
        btnConfirm = (TextView) view.findViewById(R.id.btn_confirm);
        btnCancle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (updateEntity.getMustUpdate()) {
                    ActivityStack.getInstance().finishAllActivityUntilCls(false);
                } else {
                    dialog.dismissAllowingStateLoss();
                }

            }
        });
        btnConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PackageUtils.upDateApk(filePath);
            }
        });

        btnConfirm.setEnabled(false);
        dialog.addView(view).show(mContext.getSupportFragmentManager(), "downloading");


        new ProgressAsyncTask(url, filePath, progressBar)
                .execute();
    }


    /**
     * 设置View高度
     *
     * @param view
     */
    private void setViewHeight(final View view) {
        final ViewTreeObserver vto = view.getViewTreeObserver();
        vto.addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
            public boolean onPreDraw() {
                view.getViewTreeObserver().removeOnPreDrawListener(this);
                int width = view.getMeasuredWidth();
                int height = width * 568 / 1094;

                ViewGroup.LayoutParams layoutParams = view.getLayoutParams();
                layoutParams.height = height;
                layoutParams.width = width;
                view.setLayoutParams(layoutParams);
                return true;
            }
        });
    }

    class ProgressAsyncTask extends AsyncTask<Object, Integer, Object> {

        public static final String NOTIFICATION_DOWNLOAD_ERROR = "下载出错";
        public static final String NOTIFICATION_DOWNLOADING = "正在下载  ";
        public static final String NOTIFICATION_DOWNLOAD_DONE = "下载完成";
        public static final String NOTIFICATION_UNKOWN_ERROR = "下载出错,未知错误";
        public static final String NOTIFICATION_DOWENLOAD_SPEED_UNITS = " KB/S";
        public static final String NOTIFICATION_DOWENLOAD_FILESIZE_UNITS = " MB";

        public static final int NOTIFICATION_STATUS_FLAG_ERROR = -1;
        public static final int NOTIFICATION_STATUS_FLAG_NORMAL = 1;
        public static final int NOTIFICATION_STATUS_FLAG_DONE = 2;
        public static final int NOTIFICATION_STATUS_FLAG_UNKOWN_ERROR = 3;
        /**
         * 更新间隔
         */
        private static final long UPDATE_INTERVAL = 400;
        private boolean isDownloadError = false;
        /**
         * 文件的下载地址
         */
        private String fileUrl;
        /**
         * 文件保存的路径
         */
        private String fileSavePath;

        private NotificationManager nm;
        private NotificationCompat.Builder mBuilder;
        private int fileSize;
        private String fileSizeM;
        // 通知栏标识
        private int notifyId;
        private ProgressBar progressBar;
        private File saveFile = null;

        /**
         * @param fileUrl
         * @param fileSavePath
         * @param nm
         * @param mBuilder
         * @param notifyId
         */
        public ProgressAsyncTask(String fileUrl, String fileSavePath,
                                 NotificationManager nm,
                                 NotificationCompat.Builder mBuilder, int notifyId) {
            this.fileUrl = fileUrl;
            this.fileSavePath = fileSavePath;
            this.nm = nm;
            this.mBuilder = mBuilder;
            this.notifyId = notifyId;
        }

        /**
         * @param fileUrl
         * @param fileSavePath
         * @param progressBar
         */
        public ProgressAsyncTask(String fileUrl, String fileSavePath,
                                 ProgressBar progressBar) {
            this.fileUrl = fileUrl;
            this.fileSavePath = fileSavePath;
            this.progressBar = progressBar;
        }

        @Override
        protected Object doInBackground(Object... params) {
            BufferedInputStream bis = null;
            FileOutputStream fos = null;

            try {
                final URL url = new URL(fileUrl);
                HttpURLConnection urlConnection = (HttpURLConnection) url
                        .openConnection();
                urlConnection.connect();
                fileSize = urlConnection.getContentLength();
                fileSizeM = String.format(Locale.CHINA, "%.2f",
                        (float) fileSize / 1024 / 1024);
                bis = new BufferedInputStream(urlConnection.getInputStream());
                saveFile = new File(fileSavePath);
                fos = new FileOutputStream(saveFile);
                downloadFile(bis, fos);
                if (mBuilder != null) {
                    // 下载进度完成
                    mBuilder.setContentText(getBuildNotificationContent(0,
                            100 + "", fileSizeM + "", NOTIFICATION_STATUS_FLAG_DONE));
                    mBuilder.setProgress(fileSize, fileSize, false);
                    nm.notify(notifyId, mBuilder.build());
                }
                return true;
            } catch (MalformedURLException e) {
                e.printStackTrace();
                notifyHighVersionNotification(0, NOTIFICATION_STATUS_FLAG_ERROR);
                isDownloadError = true;
            } catch (IOException e) {
                e.printStackTrace();
                // 需要处理出错情况,没有网络不能显示通知的问题，
                // 下载错误
                notifyHighVersionNotification(0, NOTIFICATION_STATUS_FLAG_ERROR);
                isDownloadError = true;
            } catch (Exception e) {
                e.printStackTrace();
                // 未知错误
                notifyHighVersionNotification(0, NOTIFICATION_STATUS_FLAG_UNKOWN_ERROR);
                isDownloadError = true;
            } finally {
                try {
                    if (bis != null)
                        bis.close();
                    if (fos != null)
                        fos.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return false;
        }

        /**
         * 文件下载
         *
         * @param in  输入流
         * @param out 输出流
         * @throws IOException
         */
        public void downloadFile(InputStream in, OutputStream out) throws IOException {
            int len = 0;
            byte[] buffer = new byte[1024 * 2];
            int current = 0;
            int bytesInThreshold = 0;
            long updateDelta = 0;
            long updateStart = System.currentTimeMillis();
            while ((len = in.read(buffer)) != -1) {
                out.write(buffer, 0, len);
                out.flush();
                current += len;
                bytesInThreshold += len;
                // 因为Notification状态栏不能更新太过于频繁
                // 该算法有待优化
                // if (percent % 5 == 0) {
                // if (percent > random.nextInt(10)) {
                if (updateDelta > UPDATE_INTERVAL) {
                    int percent = (current * 100) / fileSize;
                    long downloadSpeed = bytesInThreshold / updateDelta;
                    updateProgress(current, percent, downloadSpeed);
                    // reset data
                    updateStart = System.currentTimeMillis();
                    bytesInThreshold = 0;
                }
                updateDelta = System.currentTimeMillis() - updateStart;
            }
        }

        /**
         * 更新进度
         *
         * @param current
         * @param percent
         * @param downloadSpeed
         */
        private void updateProgress(int current, final int percent, long downloadSpeed) {
            if (mBuilder != null) {
                mBuilder.setContentText(getBuildNotificationContent(downloadSpeed,
                        percent, fileSizeM, NOTIFICATION_STATUS_FLAG_NORMAL));
                mBuilder.setProgress(fileSize, current, false);
                nm.notify(notifyId, mBuilder.build());
            } else if (progressBar != null) {
                progressBar.setProgress(percent);
                mContext.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        tvUpdateTip.setText(mContext.getString(R.string.text_update_version_download_tip) + percent + "%");
                    }
                });

            }
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            notifyHighVersionNotification(100, NOTIFICATION_STATUS_FLAG_NORMAL);

        }

        @Override
        protected void onPostExecute(Object result) {
            super.onPostExecute(result);
            if (!isDownloadError) {
                progressBar.setProgress(100);
                tvUpdateTip.setText("下载完成,请点击确认安装。");
                btnConfirm.setEnabled(true);
                if (saveFile.exists()) {
                    PackageUtils.upDateApk(fileSavePath);
                }
            }
            // 可以在此做一些下载的操作
        }

        @Override
        protected void onProgressUpdate(Integer... values) {
            super.onProgressUpdate(values);
        }

        /**
         * 获取通知栏内容
         *
         * @param speed    下载速度
         * @param percent  完成率
         * @param fileSize 文件大小
         * @param type     -1 is wrong;1 is normal ;2 is done; the other digit is unkown
         *                 error
         * @return
         */
        public String getBuildNotificationContent(Serializable speed,
                                                  Serializable percent, String fileSize, int type) {
            StringBuilder builder = new StringBuilder();
            switch (type) {
                case NOTIFICATION_STATUS_FLAG_ERROR:// 下载出错
                    builder.append(NOTIFICATION_DOWNLOAD_ERROR);
                    break;
                case NOTIFICATION_STATUS_FLAG_NORMAL:// 正常
                    builder.append(NOTIFICATION_DOWNLOADING).append(speed)
                            .append(NOTIFICATION_DOWENLOAD_SPEED_UNITS);
                    builder.append("            ").append(percent).append("%")
                            .append("  ").append(fileSize)
                            .append(NOTIFICATION_DOWENLOAD_FILESIZE_UNITS);
                    break;
                case NOTIFICATION_STATUS_FLAG_DONE:// 完成
                    builder.append(NOTIFICATION_DOWNLOAD_DONE);
                    break;
                case NOTIFICATION_STATUS_FLAG_UNKOWN_ERROR:
                    builder.append(NOTIFICATION_UNKOWN_ERROR);
                    break;
            }
            return builder.toString();
        }

        /**
         * 显示高版本的Notification
         *
         * @param fileSize 文件大小
         * @param type     -1 is wrong;1 is normal ;2 is done; the other digit is unkown
         *                 error
         * @return
         */
        private void notifyHighVersionNotification(int fileSize, int type) {
            if (mBuilder != null) {
                mBuilder.setContentText(getBuildNotificationContent(0, 0,
                        TextUtils.isEmpty(fileSizeM) ? "0" : fileSizeM, type));
                mBuilder.setProgress(fileSize, 0, false);
                nm.notify(notifyId, mBuilder.build());
            }
        }
    }
}