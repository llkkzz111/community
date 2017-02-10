package com.choudao.equity.selector.adapter;
/**
 * @author Aizaz AZ
 */

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import com.choudao.equity.selector.AlbumItem;
import com.choudao.equity.selector.model.AlbumModel;

import java.util.ArrayList;

public class AlbumAdapter extends MBaseAdapter<AlbumModel> {

    private String checkedName;

    public AlbumAdapter(Context context, ArrayList<AlbumModel> models) {
        super(context, models);
    }

    public void setChecked(String checkName) {
        checkedName = checkName;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        AlbumItem albumItem = null;
        if (convertView == null) {
            albumItem = new AlbumItem(context);
            convertView = albumItem;
        } else
            albumItem = (AlbumItem) convertView;
        albumItem.update(models.get(position));
        return convertView;
    }

}
