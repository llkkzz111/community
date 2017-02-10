package com.choudao.equity.adapter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.choudao.equity.R;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.imsdk.db.bean.UserInfo;

import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by liuzhao on 16/4/15.
 */
public class GroupMemberDelAdapter extends BaseAdapter {

    private Activity mActivity;
    private List<UserInfo> listUserInfo;
    // 用来控制CheckBox的选中状况
    private HashMap<Integer, Boolean> map = new HashMap<>();

    public GroupMemberDelAdapter(Activity mActivity, List<UserInfo> listUserInfo) {
        this.mActivity = mActivity;
        this.listUserInfo = listUserInfo;
    }


    @Override
    public int getCount() {
        return listUserInfo.size();
    }

    @Override
    public Object getItem(int position) {
        return listUserInfo.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        UserInfo info = listUserInfo.get(position);
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(mActivity).inflate(R.layout.activity_group_member_del_item_layout, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        if (Util.isOnMainThread())
            Glide.with(mActivity).load(info.getHeadImgUrl()).centerCrop().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mActivity))
                    .into(holder.ivHead);
        holder.tvName.setText(info.showName());

        holder.cbCheckMember.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                map.put(position, isChecked);
            }
        });
        return convertView;
    }

    public class ViewHolder {
        @BindView(R.id.iv_group_member_head)
        ImageView ivHead;
        @BindView(R.id.tv_group_member_name)
        TextView tvName;
        @BindView(R.id.cb_check_member)
        public CheckBox cbCheckMember;

        ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }
}
