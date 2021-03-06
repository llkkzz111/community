package com.community.equity.dialog;

import android.annotation.SuppressLint;
import android.content.Context;

import com.community.equity.adapter.MenuListAdapter;
import com.community.equity.utils.TextConverters;
import com.community.equity.utils.Utils;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by dufeng on 16/12/2.<br/>
 * Description: MessageMenuDialog
 */
@SuppressLint("ValidFragment")
public class MessageMenuDialog extends MenuDialog {
    private static final int COPY = 0;

    private Context context;
    private String contentStr;

    @SuppressLint("ValidFragment")
    public MessageMenuDialog(Context context, String contentStr) {
        super(context);
        this.context = context;
        this.contentStr = contentStr;
    }

    @Override
    public MenuListAdapter.OnMenuClickListener getOnMenuClickListener() {
        return new MenuListAdapter.OnMenuClickListener() {
            @Override
            public void onItemClick(int index) {
                switch (index) {
                    case COPY:
                        if (contentStr.contains("://")) {
                            contentStr = TextConverters.convertSysText(contentStr.trim());
                        }
                        Utils.copyText(context, contentStr);
                        break;
                }
                dismiss();
            }
        };
    }

    @Override
    public List<MenuItem> createMenuItemList() {
        List<MenuDialog.MenuItem> menuItemList = new ArrayList<>();
        menuItemList.add(new MenuDialog.MenuItem("复制", COPY));
        return menuItemList;
    }
}
