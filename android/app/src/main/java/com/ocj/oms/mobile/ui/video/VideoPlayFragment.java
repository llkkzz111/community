package com.ocj.oms.mobile.ui.video;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.graphics.drawable.Drawable;
import android.media.MediaPlayer;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.ocj.oms.common.net.NetUtils;
import com.ocj.oms.mobile.ActivityID;
import com.ocj.oms.mobile.EventId;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.base.BaseFragment;
import com.ocj.oms.mobile.bean.items.CmsItemsBean;
import com.ocj.oms.mobile.dialog.CommonDialogFragment;
import com.ocj.oms.mobile.dialog.DialogFactory;
import com.ocj.oms.mobile.third.Constants;
import com.ocj.oms.utils.DensityUtil;
import com.ocj.store.OcjStoreDataAnalytics.OcjStoreDataAnalytics;
import com.waynell.videolist.widget.TextureVideoView;

import java.util.concurrent.TimeUnit;

import butterknife.BindDrawable;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.Unbinder;
import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.annotations.NonNull;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Consumer;

import static com.ocj.oms.mobile.third.Constants.VIDEO_PLAYING;
import static com.ocj.oms.mobile.third.Constants.VIDEO_REPLAY;
import static com.tendcloud.tenddata.ab.mContext;

/**
 * Created by liutao on 2017/7/11.
 */

public class VideoPlayFragment extends BaseFragment {

    @BindView(R.id.ttv_video)
    TextureVideoView ttvVideo;
    @BindView(R.id.iv_cover)
    ImageView ivCover;
    @BindView(R.id.iv_play)
    ImageView ivPlay;
    @BindView(R.id.iv_pause)
    ImageView ivPause;
    @BindView(R.id.iv_zoom)
    ImageView ivZoom;
    @BindView(R.id.rl_bottom)
    RelativeLayout rlBottom;
    @BindView(R.id.rl_video)
    RelativeLayout rlVideo;
    @BindView(R.id.iv_full_screen_pause)
    ImageView ivFullScreenPause;
    @BindView(R.id.iv_full_screen_back)
    ImageView ivFullScreenBack;
    @BindView(R.id.iv_full_screen_forward)
    ImageView ivFullScreenForward;
    @BindView(R.id.tv_current_position)
    TextView tvCurrentPosition;
    @BindView(R.id.tv_total_position)
    TextView tvTotalPosition;
    @BindView(R.id.sb_progress)
    SeekBar sbProgress;
    @BindView(R.id.tv_current_position2)
    TextView tvCurrentPosition2;
    @BindView(R.id.tv_total_position2)
    TextView tvTotalPosition2;
    @BindView(R.id.sb_progress2)
    SeekBar sbProgress2;
    @BindView(R.id.rl_top)
    RelativeLayout rlTop;
    @BindView(R.id.fl_progress)
    FrameLayout flProgress;
    @BindView(R.id.tv_video_state)
    TextView tvVideoState;
    @BindView(R.id.progressBar)
    ProgressBar progressBar;
    @BindView(R.id.tv_complete)
    TextView tvComplete;
    @BindView(R.id.tv_see)
    TextView tvSee;
    @BindView(R.id.tv_author)
    TextView tvAuthor;
    @BindView(R.id.tv_line)
    TextView tvLine;
    @BindView(R.id.tv_video_deta)
    TextView tvVideoDeta;
    @BindView(R.id.ll_live)
    LinearLayout llLive;
    @BindDrawable(R.drawable.shape_video_state_label_bg)
    Drawable normalDraw;
    @BindDrawable(R.drawable.shape_video_red_label_bg)
    Drawable playDraw;
    @BindDrawable(R.drawable.shape_video_normal_label_bg)
    Drawable backDraw;
    Unbinder unbinder;
    @BindView(R.id.tv_tips)
    TextView tvTips;
    @BindView(R.id.ll_no_video_path)
    RelativeLayout llNoVideoPath;
    @BindView(R.id.rl_un_live)
    RelativeLayout rlUnLive;

    private int tag;
    private boolean isPause;
    private boolean isStart;
    private Disposable mDisposable;
    /**
     * 快进时间
     */
    private final int skipTime = 5000;
    private Disposable progressDisposable;
    private CommonDialogFragment alertDialog;
    /**
     * 是否显示进度条
     */
    private boolean isShowProgress;
    /**
     * 是否全屏
     */
    private boolean isZoom;
    private int currentPosition;

    private static final String VIDEO_URL = "video_url";
    private static final String VIDEO_ITEM = "item";
    private static final String PROGRESS_VISIBILITY = "progress_visibility";
    private static final String COVER_URL = "cover_url";
    private static final String IS_ZOOM = "is_zoom";
    private CmsItemsBean item = null;

    public static VideoPlayFragment newInstance(String videoUrl, boolean visibility, String cover_Url, CmsItemsBean item) {
        VideoPlayFragment fragment = new VideoPlayFragment();
        Bundle bundle = new Bundle();
        bundle.putString(VIDEO_URL, videoUrl);
        bundle.putSerializable(VIDEO_ITEM, item);
        bundle.putString(COVER_URL, cover_Url);
        bundle.putBoolean(PROGRESS_VISIBILITY, visibility);
        fragment.setArguments(bundle);
        return fragment;
    }

    public static VideoPlayFragment newInstance(String videoUrl, boolean visibility, String cover_Url) {
        VideoPlayFragment fragment = new VideoPlayFragment();
        Bundle bundle = new Bundle();
        bundle.putString(VIDEO_URL, videoUrl);
        bundle.putString(COVER_URL, cover_Url);
        bundle.putBoolean(PROGRESS_VISIBILITY, visibility);
        fragment.setArguments(bundle);
        return fragment;
    }

    public static VideoPlayFragment newInstance(String videoUrl, boolean visibility, String cover_Url, boolean isZoom) {
        VideoPlayFragment fragment = new VideoPlayFragment();
        Bundle bundle = new Bundle();
        bundle.putString(VIDEO_URL, videoUrl);
        bundle.putString(COVER_URL, cover_Url);
        bundle.putBoolean(PROGRESS_VISIBILITY, visibility);
        bundle.putBoolean(IS_ZOOM, isZoom);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    protected int getlayoutId() {
        return R.layout.fragment_video_play_layout;
    }

    @Override
    protected void initEventAndData() {
        if (!TextUtils.isEmpty(getArguments().getString(VIDEO_URL))) {
            ttvVideo.setVideoPath(getArguments().getString(VIDEO_URL));
            tvTips.setVisibility(View.GONE);
        } else {
            tvTips.setVisibility(View.VISIBLE);
            llNoVideoPath.setVisibility(View.VISIBLE);
        }
        Glide.with(mActivity).load(getArguments().get(COVER_URL)).into(ivCover);
        isShowProgress = getArguments().getBoolean(PROGRESS_VISIBILITY, false);
        isZoom = getArguments().getBoolean(IS_ZOOM, false);
        item = (CmsItemsBean) getArguments().getSerializable(VIDEO_ITEM);
        IntentFilter filter = new IntentFilter();
        filter.addAction("android.net.conn.CONNECTIVITY_CHANGE");
        filter.addAction("android.net.wifi.WIFI_STATE_CHANGED");
        filter.addAction("android.net.wifi.STATE_CHANGE");
        mActivity.registerReceiver(mNetworkChangeListener, filter);
        ttvVideo.setOnTouchListener(onTouchListener);
        sbProgress.setOnSeekBarChangeListener(onSeekBarChangeListener);
        sbProgress2.setOnSeekBarChangeListener(onSeekBarChangeListener);
        sbProgress.setOnTouchListener(onTouchListener);
        sbProgress2.setOnTouchListener(onTouchListener);
        if (isZoom) {
            ivZoom.setVisibility(View.VISIBLE);
        }
        alertDialog = DialogFactory.showAlertDialog("是否要使用流量观看?", "否", null, "是", new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ttvVideo.start(true);
                if (ivCover.getVisibility() == View.VISIBLE) {
                    ivCover.setVisibility(View.GONE);
                }
                if (ivPlay.getVisibility() == View.VISIBLE) {
                    ivPlay.setVisibility(View.GONE);
                }
                if (!isStart) {
                    flProgress.setVisibility(View.VISIBLE);
                    if (isZoom) {
                        zoomVideo();
                    }
                }
                isStart = true;
                isPause = false;
            }
        });
        ttvVideo.setMediaPlayerCallback(new TextureVideoView.MediaPlayerCallback() {
            @Override
            public void onPrepared(MediaPlayer mediaPlayer) {
                tvTotalPosition.setText(convertTime(ttvVideo.getDuration()));
                tvTotalPosition2.setText(convertTime(ttvVideo.getDuration()));
                flProgress.setVisibility(View.GONE);
            }

            @Override
            public void onCompletion(MediaPlayer mediaPlayer) {

            }

            @Override
            public void onBufferingUpdate(MediaPlayer mediaPlayer, int i) {
                if (ttvVideo != null && isShowProgress) {
                    sbProgress.setSecondaryProgress(i);
                    sbProgress2.setSecondaryProgress(i);
                }
            }

            @Override
            public void onVideoSizeChanged(MediaPlayer mediaPlayer, int i, int i1) {

            }

            @Override
            public boolean onInfo(MediaPlayer mediaPlayer, int i, int i1) {
                return false;
            }

            @Override
            public boolean onError(MediaPlayer mediaPlayer, int i, int i1) {
                return false;
            }
        });

        if (item != null) {
            tag = Integer.parseInt(item.getVideoStatus());
            //观看人数 作者 播放时间
            tvSee.setText(item.getWatchNumber() + " 观看");
            if (TextUtils.isEmpty(item.getAuthor())) {
                tvLine.setVisibility(View.GONE);
                tvAuthor.setVisibility(View.GONE);
            } else
                tvAuthor.setText(item.getAuthor());
            tvVideoDeta.setText(item.getVideoDate());
            switch (tag) {
                case Constants.VIDEO_TO_PLAY:
                    tvVideoState.setText("·即将播出");
                    tvVideoState.setBackground(normalDraw);
                    break;
                case VIDEO_PLAYING:
                    tvVideoState.setText("·正在直播");
                    tvVideoState.setBackground(playDraw);
                    llLive.setVisibility(View.VISIBLE);
                    break;
                case Constants.VIDEO_REPLAY:
                    tvVideoState.setText("·精彩回放");
                    tvVideoState.setBackground(normalDraw);
                    llLive.setVisibility(View.VISIBLE);
                    tvLine.setVisibility(View.GONE);
                    tvVideoDeta.setVisibility(View.GONE);
                    break;
                default:
                    tvVideoState.setText("·精彩回放");
                    tvVideoState.setVisibility(View.GONE);
                    tvVideoState.setBackground(normalDraw);
                    llLive.setVisibility(View.VISIBLE);
                    tvLine.setVisibility(View.GONE);
                    tvVideoDeta.setVisibility(View.GONE);
                    break;

            }
            tvVideoState.setVisibility(View.VISIBLE);
            if (TextUtils.isEmpty(item.getVideoPlayBackUrl())) {
                Glide.with(mContext).load(item.getFirstImgUrl()).into(ivCover);
                llLive.setVisibility(View.GONE);
                rlBottom.setVisibility(View.GONE);
            } else {

            }
        }
    }

    @Override
    protected void lazyLoadData() {

    }

    @OnClick({R.id.iv_play, R.id.iv_pause, R.id.iv_zoom, R.id.iv_full_screen_pause, R.id.iv_full_screen_back, R.id.iv_full_screen_forward, R.id.tv_complete})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_play:
                if (NetUtils.isWiFi(mActivity)) {
                    ttvVideo.start(true);
                    flProgress.setVisibility(View.VISIBLE);
                    isStart = true;
                    ivCover.setVisibility(View.GONE);
                    updateProgress();
                    ivPlay.setVisibility(View.GONE);
                    if (tag == VIDEO_PLAYING) {
                        llLive.setVisibility(View.GONE);
                        ivZoom.setVisibility(View.VISIBLE);
                        rlBottom.setVisibility(View.VISIBLE);
                    } else if (tag == VIDEO_REPLAY) {
                        llLive.setVisibility(View.GONE);
                        rlBottom.setVisibility(View.VISIBLE);
                        ivZoom.setVisibility(View.VISIBLE);
                        rlUnLive.setVisibility(View.VISIBLE);
                    }
                    if (isZoom) {
                        zoomVideo();
                    }
                } else {
                    if (alertDialog.isAdded()) {
                        getActivity().getFragmentManager().beginTransaction().remove(alertDialog).commit();
                    }
                    if (!alertDialog.isVisible()) {
                        alertDialog.show(getActivity().getFragmentManager(), "alert");
                    }
                }

                break;
            case R.id.iv_pause:
                if (isPause) {
                    ttvVideo.start(true);
                    isPause = false;
                    ivPause.setImageResource(R.drawable.icon_pause);
                    ivFullScreenPause.setImageResource(R.drawable.icon_pause);
                } else {
                    ttvVideo.pause();
                    isPause = true;
                    ivPause.setImageResource(R.drawable.icon_detail_play);
                    ivFullScreenPause.setImageResource(R.drawable.icon_detail_play);
                }
                break;
            case R.id.iv_zoom:
                zoomVideo();
                break;
            case R.id.iv_full_screen_pause:
                if (tag != VIDEO_PLAYING) {
                    if (isPause) {
                        ttvVideo.start(true);
                        isPause = false;
                        ivPause.setImageResource(R.drawable.icon_pause);
                        ivFullScreenPause.setImageResource(R.drawable.icon_pause);
                    } else {
                        ttvVideo.pause();
                        isPause = true;
                        ivPause.setImageResource(R.drawable.icon_detail_play);
                        ivFullScreenPause.setImageResource(R.drawable.icon_detail_play);
                    }
                }
                break;
            case R.id.iv_full_screen_back:
                if (ttvVideo.getCurrentPosition() <= skipTime) {
                    ttvVideo.seekTo(0);
                } else {
                    ttvVideo.seekTo(ttvVideo.getCurrentPosition() - skipTime);
                }
                break;
            case R.id.iv_full_screen_forward:
                if (ttvVideo.getCurrentPosition() >= ttvVideo.getDuration() - skipTime) {
                    ttvVideo.seekTo(ttvVideo.getDuration());
                } else {
                    ttvVideo.seekTo(ttvVideo.getCurrentPosition() + skipTime);
                }
                break;
            case R.id.tv_complete:
                zoomVideo();
                break;
        }
    }


    /**
     * 全屏状态切换
     */
    public void zoomVideo() {
        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT) {
            FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            rlVideo.setLayoutParams(layoutParams);
            getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
            zoomOutVideo();
            getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        } else {
            FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DensityUtil.dip2px(mActivity, 200));
            rlVideo.setLayoutParams(layoutParams);
            getActivity().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
            zoomInVideo();
            getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        }
    }

    /**
     * 缩小
     */
    private void zoomInVideo() {
        setZoomOutVisibility(View.GONE);
        setZoomInVisibility(View.VISIBLE);
        ivZoom.setImageResource(R.drawable.icon_zoom_out);
    }

    /**
     * 全屏
     */
    private void zoomOutVideo() {
        setZoomOutVisibility(View.VISIBLE);
        setZoomInVisibility(View.GONE);
        ivZoom.setImageResource(R.drawable.icon_zoom_in);
        if (rlBottom.getVisibility() == View.VISIBLE) {
            rlTop.setVisibility(View.VISIBLE);
        }
    }

    private void setZoomInVisibility(int visibility) {
        ivPause.setVisibility(visibility);
        tvCurrentPosition.setVisibility(visibility);
        tvTotalPosition.setVisibility(visibility);
        sbProgress.setVisibility(visibility);
        rlTop.setVisibility(View.GONE);
    }

    private void setZoomOutVisibility(int visibility) {
        ivFullScreenPause.setVisibility(visibility);
        ivFullScreenForward.setVisibility(visibility);
        ivFullScreenBack.setVisibility(visibility);
    }

    private void showMenuView() {
        rlBottom.setVisibility(View.VISIBLE);
        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            rlTop.setVisibility(View.VISIBLE);
        }
        if (mDisposable != null) {
            mDisposable.dispose();
        }
        countDown();
    }

    /**
     * 进度条自动消失
     */
    private void countDown() {
        Observable.interval(0, 1, TimeUnit.SECONDS)
                .take(4)
                .doOnSubscribe(new Consumer<Disposable>() {
                    @Override
                    public void accept(@NonNull Disposable disposable) throws Exception {
                        mDisposable = disposable;
                    }
                })
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<Long>() {
                    @Override
                    public void onSubscribe(Disposable d) {

                    }

                    @Override
                    public void onNext(Long aLong) {
                    }

                    @Override
                    public void onError(Throwable e) {

                    }

                    @Override
                    public void onComplete() {
                        rlBottom.setVisibility(View.GONE);
                        rlTop.setVisibility(View.GONE);
                    }
                });
    }

    private void updateProgress() {
        Observable.interval(0, 1, TimeUnit.SECONDS)
                .doOnSubscribe(new Consumer<Disposable>() {
                    @Override
                    public void accept(@NonNull Disposable disposable) throws Exception {
                        progressDisposable = disposable;
                    }
                })
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<Long>() {
                    @Override
                    public void onSubscribe(Disposable d) {

                    }

                    @Override
                    public void onNext(Long aLong) {
                        if (!isPause && ttvVideo != null) {
                            try {
                                tvCurrentPosition.setText(convertTime(ttvVideo.getCurrentPosition()));
                                tvCurrentPosition2.setText(convertTime(ttvVideo.getCurrentPosition()));
                                int pos = 100 * ttvVideo.getCurrentPosition() / ttvVideo.getDuration();
                                sbProgress.setProgress(pos);
                                sbProgress2.setProgress(pos);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable e) {

                    }

                    @Override
                    public void onComplete() {

                    }
                });
    }

    private String convertTime(int time) {
        int minute;
        int seconds;
        int hour;

        seconds = time / 1000 % 60;
        minute = time / 1000 / 60 % 60;
        hour = time / 1000 / 60 / 60 % 24;
        String temp = "";
        if (hour > 0) {
            if (hour < 10) {
                temp = temp + "0" + hour + ":";
            } else {
                temp = temp + hour + ":";
            }
        }
        if (minute < 10) {
            temp = temp + "0" + minute + ":";
        } else {
            temp = temp + minute + ":";
        }
        if (seconds < 10) {
            temp = temp + "0" + seconds;
        } else {
            temp = temp + seconds;
        }
        return temp;
    }

    private SeekBar.OnSeekBarChangeListener onSeekBarChangeListener = new SeekBar.OnSeekBarChangeListener() {
        @Override
        public void onProgressChanged(SeekBar seekBar, int i, boolean b) {

        }

        @Override
        public void onStartTrackingTouch(SeekBar seekBar) {

        }

        @Override
        public void onStopTrackingTouch(SeekBar seekBar) {
            ttvVideo.seekTo(seekBar.getProgress() * ttvVideo.getDuration() / 100);
            tvCurrentPosition.setText(convertTime(seekBar.getProgress() * ttvVideo.getDuration() / 100));
            tvCurrentPosition2.setText(convertTime(seekBar.getProgress() * ttvVideo.getDuration() / 100));
        }
    };

    private View.OnTouchListener onTouchListener = new View.OnTouchListener() {
        @Override
        public boolean onTouch(View view, MotionEvent motionEvent) {
            if (isStart && isShowProgress) {
                showMenuView();
            }
            return false;
        }
    };

    /**
     * 网络监听
     */
    private BroadcastReceiver mNetworkChangeListener = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (ConnectivityManager.CONNECTIVITY_ACTION.equals(intent.getAction())) {
                ConnectivityManager manager = (ConnectivityManager) context
                        .getSystemService(Context.CONNECTIVITY_SERVICE);
                NetworkInfo activeNetwork = manager.getActiveNetworkInfo();
                if (activeNetwork != null) { // connected to the internet
                    if (activeNetwork.isConnected()) {
                        if (activeNetwork.getType() == ConnectivityManager.TYPE_WIFI) {

                        } else if (activeNetwork.getType() == ConnectivityManager.TYPE_MOBILE) {
                            if (ttvVideo.isPlaying()) {
                                ttvVideo.pause();
                                ivFullScreenPause.setImageResource(R.drawable.icon_pause);
                                isPause = true;
                            }
                            if (alertDialog.isAdded()) {
                                getActivity().getFragmentManager().beginTransaction().remove(alertDialog).commit();
                            }
                            if (!alertDialog.isVisible() && isStart) {
                                alertDialog.show(getActivity().getFragmentManager(), "alert");
                            }
                        }
                    }

                }

            }
        }
    };

    public void resetVideo(String videoUrl, String coverUrl) {
        if (isStart) {
            isStart = false;
            ttvVideo.stop();
        }
        ttvVideo.setVideoPath(videoUrl);
        Glide.with(mActivity).load(coverUrl).into(ivCover);
        ivCover.setVisibility(View.VISIBLE);
        ivPlay.setVisibility(View.VISIBLE);
    }

    @Override
    public void onPause() {
        if (isStart) {
            ttvVideo.pause();
            currentPosition = ttvVideo.getCurrentPosition();
        }
        super.onPause();
    }

    @Override
    public void onResume() {
        if (isStart) {
            ttvVideo.start(true);
            ttvVideo.seekTo(currentPosition);
        }
        super.onResume();
    }

    @Override
    public void onDestroyView() {
        try {
            if (ttvVideo != null) {
                ttvVideo.stop();
            }
        } catch (IllegalStateException e) {
            e.printStackTrace();
        }
        if (mDisposable != null) {
            mDisposable.dispose();
        }
        if (progressDisposable != null) {
            progressDisposable.dispose();
        }
        mActivity.unregisterReceiver(mNetworkChangeListener);
        super.onDestroyView();
        unbinder.unbind();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        // TODO: inflate a fragment view
        View rootView = super.onCreateView(inflater, container, savedInstanceState);
        unbinder = ButterKnife.bind(this, rootView);
        return rootView;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();


    }
}
