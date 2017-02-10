package com.choudao.equity.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.choudao.equity.R;
import com.choudao.equity.dialog.MenuDialog.MenuItem;

import java.util.List;


/**
 * Created by dufeng on 16/12/2.<br/>
 * Description: MessageMenuAdapter
 */

public class MenuListAdapter extends RecyclerView.Adapter<MenuListAdapter.MenuViewHolder> {



    public interface OnMenuClickListener {
        void onItemClick(int index);
    }

    private OnMenuClickListener menuClickListener;

    private List<MenuItem> menuItemList;

    public MenuListAdapter(OnMenuClickListener menuClickListener) {
        this.menuClickListener = menuClickListener;
    }

    public void setData(List<MenuItem> menuItemList) {
        this.menuItemList = menuItemList;
        notifyDataSetChanged();
    }

    @Override
    public MenuViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater mInflater = LayoutInflater.from(parent.getContext());
        return new MenuViewHolder(mInflater.inflate(R.layout.item_menu, parent, false));
    }

    @Override
    public void onBindViewHolder(MenuViewHolder holder, int position) {
        MenuItem menuItem = menuItemList.get(position);
        holder.tvMenu.setText(menuItem.getName());
        holder.index = menuItem.getIndex();
    }

    @Override
    public int getItemCount() {
        return menuItemList == null ? 0 : menuItemList.size();
    }

    public class MenuViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        public int index;
        public TextView tvMenu;

        public MenuViewHolder(View itemView) {
            super(itemView);
            tvMenu = (TextView) itemView.findViewById(R.id.tv_menu);
            tvMenu.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            menuClickListener.onItemClick(index);
        }
    }
}
