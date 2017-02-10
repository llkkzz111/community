package com.choudao.equity.selector;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.choudao.equity.R;
import com.choudao.equity.selector.model.PhotoModel;


public class PhotoPreview extends LinearLayout implements OnClickListener {

    private ProgressBar pbLoading;
    private OnClickListener l;
    private ImageView ivContent;

    public PhotoPreview(Context context) {
        super(context);
        LayoutInflater.from(context).inflate(R.layout.view_photopreview, this, true);

        pbLoading = (ProgressBar) findViewById(R.id.pb_loading_vpp);
        ivContent = (ImageView) findViewById(R.id.iv_content_vpp);
    }

    public PhotoPreview(Context context, AttributeSet attrs, int defStyle) {
        this(context);
    }

    public PhotoPreview(Context context, AttributeSet attrs) {
        this(context);
    }

    public void loadImage(PhotoModel photoModel) {
        String path = photoModel.getOriginalPath();
        if (!path.startsWith("http")) {
            path = "file://" + path;
        } else {
            path = path.substring(0, path.indexOf("?"));
        }
        loadImage(path);
    }

    private void loadImage(String path) {
        if (Util.isOnMainThread())
            Glide.with(getContext()).load(path).error(R.drawable.ic_picture_loadfailed).skipMemoryCache(false).diskCacheStrategy(DiskCacheStrategy.NONE).placeholder(R.drawable.icon_tag_loding).into(ivContent);
        pbLoading.setVisibility(GONE);
    }

    @Override
    public void setOnClickListener(OnClickListener l) {
        this.l = l;
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == R.id.iv_content_vpp && l != null) {
        }
    }
}
