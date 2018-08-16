package com.community.equity.selector;

import android.content.Context;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnLongClickListener;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.community.equity.R;
import com.community.equity.selector.model.PhotoModel;
import com.community.equity.selector.utils.Util;


/**
 * @author Aizaz AZ
 */

public class PhotoItem extends LinearLayout
        implements OnCheckedChangeListener, OnLongClickListener, View.OnClickListener {

    private RelativeLayout itemLayout;
    private ImageView ivPhoto;
    private RelativeLayout cbLayout;
    private CheckBox cbPhoto;
    private onPhotoItemCheckedListener listener;
    private PhotoModel photo;
    private boolean isCheckAll;
    private onItemClickListener l;
    private int position;
    private PhotoSelectorActivity context;

    private PhotoItem(Context context) {
        super(context);
        if (context instanceof PhotoSelectorActivity) {
            this.context = (PhotoSelectorActivity) context;
        }
    }

    public PhotoItem(final Context context, onPhotoItemCheckedListener listener) {
        this(context);
        LayoutInflater.from(context).inflate(R.layout.layout_photoitem, this,
                true);
        this.listener = listener;

        setOnLongClickListener(this);
        itemLayout = (RelativeLayout) findViewById(R.id.gallery_item_layout);
        ivPhoto = (ImageView) findViewById(R.id.iv_photo_lpsi);
        cbLayout = (RelativeLayout) findViewById(R.id.cb_layout);
        cbPhoto = (CheckBox) findViewById(R.id.cb_photo_lpsi);

        cbPhoto.setOnCheckedChangeListener(this); // CheckBox选中状态改变监听器
        itemLayout.setOnClickListener(this);
        cbLayout.setOnClickListener(this);
//        ivPhoto.setOnClickListener(new OnClickListener() {
//
//            @Override
//            public void onClick(View paramView) {
//
//
//                if (PhotoItem.this.context != null && PhotoItem.this.context.selected != null && PhotoItem.this.context.selected.size() >= 9) {
//                    if(!cbPhoto.isChecked())BaseActivity.tip("最多选择9张");
//                    cbPhoto.setChecked(false);
//                    return;
//                }
//                if (photo != null && photo.getOriginalPath().equals("default")) {
//                    Util.selectPicFromCamera(context);
//                    return;
//                }
//                if (cbPhoto.isChecked()) {
//                    cbPhoto.setChecked(false);
//                } else {
//                    cbPhoto.setChecked(true);
//                }
//            }
//        });
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        if (isChecked && PhotoItem.this.context != null && PhotoItem.this.context.selected != null && PhotoItem.this.context.selected.size() >= 9) {
            cbPhoto.setChecked(false);
            return;
        }
        if (!isCheckAll) {
            listener.onCheckedChanged(photo, buttonView, isChecked); // 调用主界面回调函数
        }
        // 让图片变暗或者变亮
        if (isChecked) {
            setDrawingable();
            ivPhoto.setColorFilter(Color.GRAY, PorterDuff.Mode.MULTIPLY);
        } else {
            ivPhoto.clearColorFilter();
        }
        photo.setChecked(isChecked);
    }

    /**
     * 设置路径下的图片对应的缩略图
     */
    public void setImageDrawable(final PhotoModel photo) {
        this.photo = photo;
        if (photo.getOriginalPath().equals("default")) {
            Glide.with(getContext()).load(R.drawable.camera_icon).asBitmap().diskCacheStrategy(DiskCacheStrategy.NONE).into(ivPhoto);
            cbPhoto.setVisibility(View.INVISIBLE);
        } else {
            Glide.with(getContext()).load("file://" + photo.getOriginalPath()).asBitmap().error(R.drawable.ic_picture_loadfailed).placeholder(R.drawable.ic_pic_holder).diskCacheStrategy(DiskCacheStrategy.NONE).into(ivPhoto);
            cbPhoto.setVisibility(View.VISIBLE);
        }
    }

    public void setCheckBoxIsShow(boolean isShow) {
        if (isShow) {
            cbLayout.setVisibility(VISIBLE);
        } else {
            cbLayout.setVisibility(GONE);
        }
    }

    private void setDrawingable() {
        ivPhoto.setDrawingCacheEnabled(true);
        ivPhoto.buildDrawingCache();
    }

    @Override
    public void setSelected(boolean selected) {
        if (photo == null) {
            return;
        }
        isCheckAll = true;
        cbPhoto.setChecked(selected);
        isCheckAll = false;
    }

    public void setOnClickListener(onItemClickListener l, int position) {
        this.l = l;
        this.position = position;
    }

    @Override
    public void
    onClick(View v) {
        switch (v.getId()) {
            case R.id.gallery_item_layout: {
                if (l != null) {
                    l.onItemClick(position);
                }
            }
            break;
            case R.id.cb_layout: {
                if (PhotoItem.this.context != null && PhotoItem.this.context.selected != null && PhotoItem.this.context.selected.size() >= 9) {
                    if (!cbPhoto.isChecked()) //BaseActivity.tip("最多选择9张");
                        cbPhoto.setChecked(false);
                    return;
                }
                if (photo != null && photo.getOriginalPath().equals("default")) {
                    Util.selectPicFromCamera(context);
                    return;
                }
                if (cbPhoto.isChecked()) {
                    cbPhoto.setChecked(false);
                } else {
                    cbPhoto.setChecked(true);
                }
            }
            break;
        }

    }

    @Override
    public boolean onLongClick(View v) {
        if (l != null)
            l.onItemClick(position);
        return true;
    }

    /**
     * 图片Item选中事件监听器
     */
    public interface onPhotoItemCheckedListener {
        void onCheckedChanged(
                PhotoModel photoModel,
                CompoundButton buttonView,
                boolean isChecked
        );
    }

    /**
     * 图片点击事件
     */
    public interface onItemClickListener {
        void onItemClick(int position);
    }

}
