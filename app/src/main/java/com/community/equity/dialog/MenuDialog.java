package com.community.equity.dialog;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.DialogFragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.community.equity.R;
import com.community.equity.adapter.MenuListAdapter;

import java.util.List;

/**
 * Created by dufeng on 16/12/2.<br/>
 * Description: MessageLongClickDialog
 */

public abstract class MenuDialog extends DialogFragment {

    private Context context;
    private RecyclerView rvContent;
    private MenuListAdapter menuListAdapter;


    public MenuDialog(Context context) {
        this.context = context;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(STYLE_NO_TITLE, R.style.dialog);
//        setCancelable(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.dialog_menu, container);
        rvContent = (RecyclerView) view.findViewById(R.id.rv_dialog_menu);
        rvContent.setLayoutManager(new LinearLayoutManager(context));
        menuListAdapter = new MenuListAdapter(getOnMenuClickListener());
        rvContent.setAdapter(menuListAdapter);
        menuListAdapter.setData(createMenuItemList());
        return view;
    }

    public abstract MenuListAdapter.OnMenuClickListener getOnMenuClickListener();

    public abstract List<MenuItem> createMenuItemList();


    public static class MenuItem {
        private String name;
        private int index;

        public MenuItem(String name, int index) {
            this.name = name;
            this.index = index;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public int getIndex() {
            return index;
        }

        public void setIndex(int index) {
            this.index = index;
        }
    }
}
