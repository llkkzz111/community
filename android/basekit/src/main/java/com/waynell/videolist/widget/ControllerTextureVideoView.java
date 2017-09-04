package com.waynell.videolist.widget;

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.TypedArray;
import android.media.Image;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.SeekBar;
import android.widget.TextView;


import com.ocj.oms.basekit.R;

import java.util.Formatter;
import java.util.Locale;

/**
 * Created by Administrator on 2017/3/28.
 */

public class ControllerTextureVideoView extends FrameLayout {

    private static final int sDefaultTimeout = 3000;
    private Context mContext;
    private TextureVideoView videoView;
    private ViewGroup controlBar;
    private ProgressBar mProgress;
    private TextView mEndTime;
    private TextView mCurrentTime;
    private TextView mTimeInfo;
    private StringBuilder mFormatBuilder;
    private Formatter mFormatter;
    private boolean mDragging;
    private boolean mShowing;
    private static final int FADE_OUT = 1;
    private static final int SHOW_PROGRESS = 2;
    private MediaPlayerControl mPlayer;
    private onStretchListener mOnStretchListener;
    private onVideoStopListener mOnVideoStopListener;
    private ImageButton mPauseButton;
    private ImageButton mFfwdButton;
    private ImageButton mRewButton;
    private ImageButton mNextButton;
    private ImageButton mPrevButton;
    private ImageView mStretchButton;
    private ImageView backImage;
    private ImageView closeImage;

    public static final int ORIENTATION_VERTICAL=0;
    public static final int ORIENTATION_HORIZONTAL=1;
    private int video_orientation=ORIENTATION_VERTICAL;

    public ControllerTextureVideoView(Context context) {
        this(context,null);
    }

    public ControllerTextureVideoView(Context context, AttributeSet attrs) {
        this(context, attrs,0);
    }

    public ControllerTextureVideoView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
//        init();
    }

    @Override
    protected void onFinishInflate() {
        init();
        super.onFinishInflate();
    }

    private void init(){
        mContext=getContext();
        videoView=new TextureVideoView(mContext);
        LayoutParams videoParams = new LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT);
        removeAllViews();
        addView(videoView,videoParams);
    }

    public void addControllerView(){
        LayoutInflater inflate = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        controlBar= (ViewGroup) inflate.inflate(R.layout.media_controller, null);
        LayoutParams controlParams=new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        controlParams.gravity= Gravity.BOTTOM;
        addView(controlBar,controlParams);
        initControllerView(controlBar);
        videoView.setMediaController(this);

        //添加返回按钮
        backImage=new ImageView(mContext);
        LayoutParams backImageParams=new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        backImageParams.gravity=Gravity.TOP | Gravity.LEFT ;
        backImageParams.leftMargin=25;
        backImageParams.topMargin=25;
        backImage.setImageResource(R.drawable.ic_back);
        backImage.setVisibility(GONE);
        addView(backImage,backImageParams);
        backImage.setOnClickListener(mVideoStretchListener);

        //添加关闭按钮
        closeImage=new ImageView(mContext);
        LayoutParams closImageParams=new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        closImageParams.gravity=Gravity.TOP | Gravity.RIGHT ;
        closImageParams.rightMargin=35;
        closImageParams.topMargin=25;
        closeImage.setImageResource(R.drawable.video_close);
        closeImage.setVisibility(VISIBLE);
        addView(closeImage,closImageParams);
        closeImage.setOnClickListener(mVideoCloseListener);

    }

    private void initControllerView(ViewGroup v) {
        mPauseButton = (ImageButton) v.findViewById(R.id.pause);
        if (mPauseButton != null) {
            mPauseButton.requestFocus();
            mPauseButton.setOnClickListener(mPauseListener);
        }

        mProgress = (SeekBar) v.findViewById(R.id.mediacontroller_progress);
        if (mProgress != null) {
            if (mProgress instanceof SeekBar) {
                SeekBar seeker = (SeekBar) mProgress;
                seeker.setOnSeekBarChangeListener(mSeekListener);
            }
            mProgress.setMax(1000);
        }

        mTimeInfo = (TextView) v.findViewById(R.id.time_info);
        mEndTime = (TextView) v.findViewById(R.id.time);
        mCurrentTime = (TextView) v.findViewById(R.id.time_current);
        mFormatBuilder = new StringBuilder();
        mFormatter = new Formatter(mFormatBuilder, Locale.getDefault());
        mStretchButton=(ImageView)v.findViewById(R.id.iv_stretch);
        mStretchButton.setOnClickListener(mVideoStretchListener);

    }

    private OnClickListener mVideoStretchListener=new OnClickListener(){

        @Override
        public void onClick(View v) {
            if(mOnStretchListener!=null && video_orientation==ORIENTATION_VERTICAL){
                mOnStretchListener.onStretchClick(v);
                mStretchButton.setImageResource(R.drawable.video_nonfullscreen);
                video_orientation=ORIENTATION_HORIZONTAL;
            }else if(mOnStretchListener!=null && video_orientation==ORIENTATION_HORIZONTAL){
                mOnStretchListener.onShrinkClick(v);
                mStretchButton.setImageResource(R.drawable.video_fullscreen);
                video_orientation=ORIENTATION_VERTICAL;
            }
        }
    };

    private OnClickListener mVideoCloseListener=new OnClickListener(){

        @Override
        public void onClick(View v) {
            if(mOnVideoStopListener!=null){
                mOnVideoStopListener.onTextureVideoStop();
            }
        }
    };

    private OnClickListener mPauseListener = new OnClickListener() {
        public void onClick(View v) {
            doPauseResume();
            show(sDefaultTimeout);
        }
    };

    private SeekBar.OnSeekBarChangeListener mSeekListener = new SeekBar.OnSeekBarChangeListener() {
        public void onStartTrackingTouch(SeekBar bar) {
            show(3600000);

            mDragging = true;

            // By removing these pending progress messages we make sure
            // that a) we won't update the progress while the user adjusts
            // the seekbar and b) once the user is done dragging the thumb
            // we will post one of these messages to the queue again and
            // this ensures that there will be exactly one message queued up.
            mHandler.removeMessages(SHOW_PROGRESS);
        }

        public void onProgressChanged(SeekBar bar, int progress, boolean fromuser) {
            if (!fromuser) {
                // We're not interested in programmatically generated changes to
                // the progress bar's position.
                return;
            }

            long duration = mPlayer.getDuration();
            long newposition = (duration * progress) / 1000L;
            mPlayer.seekTo( (int) newposition);
            if (mCurrentTime != null)
                mCurrentTime.setText(stringForTime( (int) newposition));

            if(mTimeInfo!=null){
                if(mPlayer.getDuration()<=0){
                    mTimeInfo.setText(stringForTime((int)newposition));
                }else{
                    mTimeInfo.setText(stringForTime((int)newposition)+"/"+stringForTime(mPlayer.getDuration()));
                }
            }
        }

        public void onStopTrackingTouch(SeekBar bar) {
            mDragging = false;
            setProgress();
            updatePausePlay();
            show(sDefaultTimeout);

            // Ensure that progress is properly updated in the future,
            // the call to show() does not guarantee this because it is a
            // no-op if we are already showing.
            mHandler.sendEmptyMessage(SHOW_PROGRESS);
        }
    };

    private OnTouchListener mTouchListener = new OnTouchListener() {
        public boolean onTouch(View v, MotionEvent event) {
            if (event.getAction() == MotionEvent.ACTION_DOWN) {
                if (mShowing) {
                    hide();
                }
            }
            return false;
        }
    };

    public void setMediaPlayer(MediaPlayerControl player) {
        mPlayer = player;
        updatePausePlay();
    }

    public void setOnStretchListener(onStretchListener listener){
        mOnStretchListener=listener;
    }

    public void setOnVideoStopListener(onVideoStopListener listener){
        mOnVideoStopListener=listener;
    }

    public void show() {
        show(sDefaultTimeout);
    }

    private void disableUnsupportedButtons() {
        try {
            if (mPauseButton != null && !mPlayer.canPause()) {
                mPauseButton.setEnabled(false);
            }
            if (mRewButton != null && !mPlayer.canSeekBackward()) {
                mRewButton.setEnabled(false);
            }
            if (mFfwdButton != null && !mPlayer.canSeekForward()) {
                mFfwdButton.setEnabled(false);
            }
        } catch (IncompatibleClassChangeError ex) {
            // We were given an old version of the interface, that doesn't have
            // the canPause/canSeekXYZ methods. This is OK, it just means we
            // assume the media can be paused and seeked, and so we don't disable
            // the buttons.
        }
    }

    public void show(int timeout) {
        if (!mShowing) {
            setProgress();
            if (mPauseButton != null) {
                mPauseButton.requestFocus();
            }
            disableUnsupportedButtons();
            if(video_orientation==ORIENTATION_HORIZONTAL){
//                backImage.setVisibility(View.VISIBLE);
            }

            if(video_orientation==ORIENTATION_VERTICAL){
                closeImage.setVisibility(View.VISIBLE);
            }
            controlBar.setVisibility(View.VISIBLE);
            mShowing = true;
        }
        updatePausePlay();

        // cause the progress bar to be updated even if mShowing
        // was already true.  This happens, for example, if we're
        // paused with the progress bar showing the user hits play.
        mHandler.sendEmptyMessage(SHOW_PROGRESS);

        Message msg = mHandler.obtainMessage(FADE_OUT);
        if (timeout != 0) {
            mHandler.removeMessages(FADE_OUT);
            mHandler.sendMessageDelayed(msg, timeout);
        }
    }

    public boolean isShowing() {
        return mShowing;
    }

    public void hide() {
        if (mShowing) {
            mHandler.removeMessages(SHOW_PROGRESS);
            controlBar.setVisibility(View.GONE);
//            backImage.setVisibility(View.GONE);
            closeImage.setVisibility(GONE);
            mShowing = false;
        }
    }

    public void hideSeekBar(){
        mProgress.setVisibility(View.GONE);
        mTimeInfo.setVisibility(View.GONE);
    }

    public void showSeekBar(){
        mProgress.setVisibility(View.VISIBLE);
        mTimeInfo.setVisibility(View.VISIBLE);
    }

    private Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            int pos;
            switch (msg.what) {
                case FADE_OUT:
                    hide();
                    break;
                case SHOW_PROGRESS:
                    pos = setProgress();
                    if (!mDragging && mShowing && mPlayer.isPlaying()) {
                        msg = obtainMessage(SHOW_PROGRESS);
                        sendMessageDelayed(msg, 1000 - (pos % 1000));
                    }
                    break;
            }
        }
    };

    private String stringForTime(int timeMs) {
        int totalSeconds = timeMs / 1000;

        int seconds = totalSeconds % 60;
        int minutes = (totalSeconds / 60) % 60;
        int hours   = totalSeconds / 3600;

        mFormatBuilder.setLength(0);
        if (hours > 0) {
            return mFormatter.format("%d:%02d:%02d", hours, minutes, seconds).toString();
        } else {
            return mFormatter.format("%02d:%02d", minutes, seconds).toString();
        }
    }

    private int setProgress() {
        if (mPlayer == null || mDragging) {
            return 0;
        }
        int position = mPlayer.getCurrentPosition();
        int duration = mPlayer.getDuration();
        if (mProgress != null) {
            if (duration > 0) {
                // use long to avoid overflow
                long pos = 1000L * position / duration;
                mProgress.setProgress( (int) pos);
            }
            int percent = mPlayer.getBufferPercentage();
            mProgress.setSecondaryProgress(percent * 10);
        }

        if (mEndTime != null)
            mEndTime.setText(stringForTime(duration));
        if (mCurrentTime != null)
            mCurrentTime.setText(stringForTime(position));
        if(mTimeInfo!=null){
            if(mPlayer.getDuration()<=0){
                mTimeInfo.setText(stringForTime(position));
            }else{
                mTimeInfo.setText(stringForTime(position)+"/"+stringForTime(duration));
            }
        }

        return position;
    }

    /*@Override
    public boolean onTouchEvent(MotionEvent event) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                show(0); // show until hide is called
                break;
            case MotionEvent.ACTION_UP:
                show(sDefaultTimeout); // start timeout
                break;
            case MotionEvent.ACTION_CANCEL:
                hide();
                break;
            default:
                break;
        }
        return true;
    }*/

    private void updatePausePlay() {
        if (mPauseButton == null)
            return;

        if (mPlayer.isPlaying()) {
            mPauseButton.setImageResource(R.drawable.vvc_ic_media_pause);
//            mPauseButton.setContentDescription(mPauseDescription);
        } else {
            mPauseButton.setImageResource(R.drawable.vvc_ic_media_play);
//            mPauseButton.setContentDescription(mPlayDescription);
        }
    }

    private void doPauseResume() {
        if (mPlayer.isPlaying()) {
            mPlayer.pause();
        } else {
            mPlayer.start(true);
        }
        updatePausePlay();
    }

    @Override
    public void setEnabled(boolean enabled) {
        if (mPauseButton != null) {
            mPauseButton.setEnabled(enabled);
        }
        if (mFfwdButton != null) {
            mFfwdButton.setEnabled(enabled);
        }
        if (mRewButton != null) {
            mRewButton.setEnabled(enabled);
        }
        if (mNextButton != null) {
            mNextButton.setEnabled(false);
        }
        if (mPrevButton != null) {
            mPrevButton.setEnabled(false);
        }
        if (mProgress != null) {
            mProgress.setEnabled(enabled);
        }
        disableUnsupportedButtons();
        super.setEnabled(enabled);
    }

    public TextureVideoView getVideoView() {
        return videoView;
    }

    public void setVideoView(TextureVideoView videoView) {
        this.videoView = videoView;
    }

    public ViewGroup getControlBar() {
        return controlBar;
    }

    public void setControlBar(ViewGroup controlBar) {
        this.controlBar = controlBar;
    }

    @Override
    protected void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        int mCurrentOrientation = getResources().getConfiguration().orientation;
        if ( mCurrentOrientation == Configuration.ORIENTATION_PORTRAIT ){
            if(mOnStretchListener!=null){
                if(video_orientation==ORIENTATION_HORIZONTAL){
                    mOnStretchListener.onShrinkClick(null);
                    mStretchButton.setImageResource(R.drawable.video_fullscreen);
                    video_orientation=ORIENTATION_VERTICAL;
                }
//                backImage.setVisibility(GONE);
                if(isShowing()){
                    closeImage.setVisibility(View.VISIBLE);
                }
                mOnStretchListener.onScreenTurned(ORIENTATION_VERTICAL);
            }

        }else if ( mCurrentOrientation == Configuration.ORIENTATION_LANDSCAPE ) {
            if(mOnStretchListener!=null){
                if(isShowing()){
//                    backImage.setVisibility(VISIBLE);
                }
                closeImage.setVisibility(GONE);
                mOnStretchListener.onScreenTurned(ORIENTATION_HORIZONTAL);
            }
        }
    }

    public interface MediaPlayerControl {
        void    start(boolean isResume);
        void    pause();
        int     getDuration();
        int     getCurrentPosition();
        void    seekTo(int pos);
        boolean isPlaying();
        int     getBufferPercentage();
        boolean canPause();
        boolean canSeekBackward();
        boolean canSeekForward();

        /**
         * Get the audio session id for the player used by this VideoView. This can be used to
         * apply audio effects to the audio track of a video.
         * @return The audio session, or 0 if there was an error.
         */
        int     getAudioSessionId();
    }

    public interface onStretchListener{
        void onStretchClick(View view);
        void onShrinkClick(View view);
        void onScreenTurned(int orientation);
    }

    public interface onVideoStopListener{
        void onTextureVideoStop();
    }
}
