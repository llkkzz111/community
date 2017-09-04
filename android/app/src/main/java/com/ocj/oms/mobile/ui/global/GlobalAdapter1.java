package com.ocj.oms.mobile.ui.global;

import android.content.Context;
import android.support.annotation.LayoutRes;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.View;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.ocj.oms.mobile.R;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * 选择adapter
 * Created by shizhang.cai on 2017/6/7.
 */

public class GlobalAdapter1 extends BaseQuickAdapter<Contact, BaseViewHolder> {

    private int position;

    private Context ctx;

    private List<Contact> selectList = new ArrayList<>();

    public GlobalAdapter1(Context ctx, @LayoutRes int layoutResId, @Nullable List<Contact> data) {
        super(layoutResId, data);
        this.ctx = ctx;
    }

    public void setSelectList(List<Contact> selectList) {
        this.selectList = selectList;
    }


    @Override
    protected void convert(BaseViewHolder helper, final Contact item) {
        helper.setText(R.id.titleTv, item.getName());
//        int position = helper.getAdapterPosition();
        if (checkContain(selectList, item)) {
            helper.setTextColor(R.id.titleTv, ctx.getResources().getColor(R.color.text_red_E5290D));
            helper.setVisible(R.id.selectIv, true);
        } else {
            helper.setTextColor(R.id.titleTv, ctx.getResources().getColor(R.color.text_grey_666666));
            helper.setVisible(R.id.selectIv, false);
        }
        helper.setOnClickListener(R.id.selectLayout, new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!checkContain(selectList, item)) {
                    selectList.add(item);
                } else {
                    removeItem(selectList, item);
                }
                notifyDataSetChanged();
            }
        });
    }

    private boolean checkContain(List<Contact> list, Contact item) {
        for (Contact con : list) {
            if (con.getCode().equals(item.getCode())) {
                return true;
            }
        }
        return false;
    }

    private void removeItem(List<Contact> list, Contact item) {
        Iterator<Contact> iterator = list.iterator();
        while (iterator.hasNext()) {
            Contact co = iterator.next();
            if (!TextUtils.isEmpty(co.getCode())
                    && co.getCode().equals(item.getCode())) {
                iterator.remove();
            }
        }
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public List<Contact> getSelectList() {
        return selectList;
    }
}
