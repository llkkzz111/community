package com.community.equity.selector;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.community.equity.R;
import com.community.equity.selector.model.AlbumModel;


/**
 * @author Aizaz AZ
 */
public class AlbumItem extends LinearLayout {

    private ImageView ivAlbum, ivIndex;
    private TextView tvName, tvCount;
    private Context mContent;

    public AlbumItem(Context context) {
        this(context, null);
        this.mContent = context;
    }

    public AlbumItem(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.mContent = context;
        LayoutInflater.from(context).inflate(R.layout.layout_album, this, true);

        ivAlbum = (ImageView) findViewById(R.id.iv_album_la);
        ivIndex = (ImageView) findViewById(R.id.iv_index_la);
        tvName = (TextView) findViewById(R.id.tv_name_la);
        tvCount = (TextView) findViewById(R.id.tv_count_la);
    }

    public AlbumItem(Context context, AttributeSet attrs, int defStyle) {
        this(context, attrs);
    }


    public void setAlbumImage(String path) {
        Glide.with(mContent).load("file://" + path).into(ivAlbum);
    }

    public void update(AlbumModel album) {
        setAlbumImage(album.getRecent());
        setName(album.getName());
        setCount(album.getCount());
        isCheck(album.isCheck());
    }

    public void setName(CharSequence title) {
        tvName.setText(title);
    }

    public void setCount(int count) {
        tvCount.setText(count + "张");
    }

    public void isCheck(boolean isCheck) {
        if (isCheck)
            ivIndex.setVisibility(View.VISIBLE);
        else
            ivIndex.setVisibility(View.GONE);
    }

}
