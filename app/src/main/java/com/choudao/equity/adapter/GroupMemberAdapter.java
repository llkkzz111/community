package com.choudao.equity.adapter;

import android.app.Activity;
import android.graphics.drawable.Drawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.util.Util;
import com.choudao.equity.R;
import com.choudao.equity.utils.CropSquareTransformation;
import com.choudao.imsdk.db.bean.GroupInfo;
import com.choudao.imsdk.db.bean.UserInfo;

import java.util.List;

/**
 * Created by liuzhao on 16/5/5.
 */
public class GroupMemberAdapter extends BaseAdapter {
    private List<UserInfo> listUsers;
    private Activity mActivity;
    private GroupInfo groupInfo;

    public GroupMemberAdapter(Activity mActivity, List<UserInfo> listUsers) {
        this.mActivity = mActivity;
        this.listUsers = listUsers;
    }

    public void setGroupInfo(GroupInfo groupInfo) {
        this.groupInfo = groupInfo;
    }

    @Override
    public int getCount() {
        return listUsers.size();
    }

    @Override
    public Object getItem(int position) {
        return listUsers.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        final UserInfo info = listUsers.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mActivity).inflate(R.layout.item_group_member_layout, null);
            holder.ivHead = (ImageView) convertView.findViewById(R.id.iv_group_member_head);
            holder.tvName = (TextView) convertView.findViewById(R.id.tv_group_member_name);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tvName.setText(info.showName());


        if (groupInfo != null && groupInfo.getHolder() == info.getUserId()) {
            Drawable drawable = mActivity.getResources().getDrawable(R.drawable.icon_group_owner);
            holder.tvName.setCompoundDrawablesWithIntrinsicBounds(drawable, null, null, null);
            holder.tvName.setCompoundDrawablePadding(15);
        } else {
            holder.tvName.setCompoundDrawablesWithIntrinsicBounds(null, null, null, null);
        }


        if (!TextUtils.isEmpty(info.getHeadImgUrl())) {
            if (Util.isOnMainThread())
                Glide.with(mActivity).load(info.getHeadImgUrl()).centerCrop().placeholder(R.drawable.icon_account_no_pic).diskCacheStrategy(DiskCacheStrategy.SOURCE).bitmapTransform(new CropSquareTransformation(mActivity))
                        .into(holder.ivHead);
        } else {
            if (info.getState().equals("add")) {
                holder.ivHead.setBackgroundResource(R.drawable.selector_add_user);
            } else if (info.getState().equals("del")) {
                holder.ivHead.setBackgroundResource(R.drawable.selector_del_user);
            }
        }
        return convertView;
    }


    class ViewHolder {
        TextView tvName;
        ImageView ivHead;
    }
}
