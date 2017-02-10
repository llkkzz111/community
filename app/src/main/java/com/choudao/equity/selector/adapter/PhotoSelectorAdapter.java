package com.choudao.equity.selector.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import com.choudao.equity.selector.GalleryPhotoItem;
import com.choudao.equity.selector.model.PhotoModel;

import java.util.ArrayList;

/**
 * @author Aizaz AZ
 */
public class PhotoSelectorAdapter extends MBaseAdapter<PhotoModel> {
    private GalleryPhotoItem.onPhotoItemCheckedListener listener;
    private GalleryPhotoItem.onItemClickListener mCallback;
    private int maxImage;

    private PhotoSelectorAdapter(
            Context context,
            ArrayList<PhotoModel> models
    ) {
        super(context, models);
    }

    public PhotoSelectorAdapter(
            Context context,
            ArrayList<PhotoModel> models,
            GalleryPhotoItem.onPhotoItemCheckedListener listener,
            GalleryPhotoItem.onItemClickListener mCallback
    ) {
        this(context, models);
        this.listener = listener;
        this.mCallback = mCallback;
    }

    public void setMaxImage(int maxImage) {
        this.maxImage = maxImage;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        GalleryPhotoItem item;
        if (convertView == null || !(convertView instanceof GalleryPhotoItem)) {
            item = new GalleryPhotoItem(context, listener);
            convertView = item;
        } else {
            item = (GalleryPhotoItem) convertView;
        }
        PhotoModel info = models.get(position);
        if (info == null) {
            return convertView;
        }
        if (maxImage == 1) {
            item.setCheckBoxIsShow(false);
        } else {
            item.setCheckBoxIsShow(true);
        }
        item.setImageDrawable(info);
        item.setSelected(info.isChecked());
        item.setOnClickListener(mCallback, position);
        return convertView;
    }
}
