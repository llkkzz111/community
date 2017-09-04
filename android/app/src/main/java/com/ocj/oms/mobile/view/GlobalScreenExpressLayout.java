package com.ocj.oms.mobile.view;

import android.content.Context;
import android.support.annotation.Nullable;
import android.support.v7.widget.AppCompatImageView;
import android.support.v7.widget.AppCompatTextView;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.ui.global.Contact;
import com.ocj.oms.view.FixedGridView;

import java.util.ArrayList;
import java.util.List;

/**
 * 展开layout
 * Created by shizhang.cai on 2017/6/9.
 */

public class GlobalScreenExpressLayout extends LinearLayout {
    AppCompatTextView titleTv;
    AppCompatTextView hintTv;
    FixedGridView gridview;
    //    String[] str = {"韩伊都舍","韩伊都舍","韩伊都舍","韩伊都舍","韩伊都舍","韩伊都舍","韩伊都舍","韩伊都舍","韩伊都舍"};
    List<Contact> filterList = new ArrayList<>();
    List<Contact> selectList = new ArrayList<>();
    RelativeLayout showLayout;
    AppCompatImageView arrowIv;

    GridAdapter adapter;

    public GlobalScreenExpressLayout(Context context) {
        super(context);
        init();
    }

    public GlobalScreenExpressLayout(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init();
    }


    public GlobalScreenExpressLayout(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        adapter = new GridAdapter(filterList);
        View view = View.inflate(getContext(), R.layout.item_global_screen2_layout, null);
        titleTv = (AppCompatTextView) view.findViewById(R.id.titleTv);
        showLayout = (RelativeLayout) view.findViewById(R.id.showLayout);
        arrowIv = (AppCompatImageView) view.findViewById(R.id.arrowIv);
        hintTv = (AppCompatTextView) view.findViewById(R.id.hintTv);
        gridview = (FixedGridView) view.findViewById(R.id.gridview);
        gridview.setAdapter(adapter);
        gridview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//                if(position==8){
//                    ToastUtils.showLongToast("查看更多");
//                    return;
//                }
                if (!selectList.contains(filterList.get(position))) {
                    selectList.add(filterList.get(position));
                } else {
                    selectList.remove(filterList.get(position));
                }
                adapter.notifyDataSetChanged();
                getString();
            }
        });
        showLayout.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (gridview.getVisibility() == View.VISIBLE) {
                    gridview.setVisibility(View.GONE);
                    arrowIv.setRotation(180);
                } else {
                    gridview.setVisibility(View.VISIBLE);
                    arrowIv.setRotation(360);
                }
            }
        });
        addView(view);
    }

    class GridAdapter extends BaseAdapter {
        int position = -1;
        private List<Contact> filterList;

        public GridAdapter(List<Contact> filterList) {
            this.filterList = filterList;
        }

        @Override
        public int getCount() {
            return filterList.size();
        }

        @Override
        public Object getItem(int position) {
            return filterList.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder holder = null;
            if (convertView == null) {
                convertView = View.inflate(parent.getContext(), R.layout.item_global_grid_layout, null);
                holder = new ViewHolder();
                holder.filterBtn = (AppCompatTextView) convertView.findViewById(R.id.filterBtn);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
//            if(position == 8) {
//                holder.filterBtn.setText("查看更多");
//                holder.filterBtn.setCompoundDrawablesWithIntrinsicBounds(null,null,parent.getContext().getResources().getDrawable(R.drawable.icon_arrow),null);
//                holder.filterBtn.setBackgroundColor(getResources().getColor(R.color.white));
//            }else{
            if (selectList.contains(filterList.get(position))) {
                holder.filterBtn.setBackgroundDrawable(parent.getContext().getResources().getDrawable(R.drawable.icon_red));
            } else {
                holder.filterBtn.setBackgroundDrawable(parent.getContext().getResources().getDrawable(R.drawable.bg_global_btn));
            }
            holder.filterBtn.setText(filterList.get(position).getName());
//            }
            return convertView;
        }

        class ViewHolder {
            private AppCompatTextView filterBtn;
        }

        public int getPosition() {
            return position;
        }

        public void setPosition(int position) {
            this.position = position;
            notifyDataSetChanged();
        }
    }

    /**
     * 重置
     */
    public void reset() {
        hintTv.setText("");
        selectList.clear();
        adapter.notifyDataSetChanged();
    }

    public void setText(String title) {
        titleTv.setText(title);
    }

    public String getText() {
        return hintTv.getText().toString();
    }

    private void getString() {
        StringBuffer buffer = new StringBuffer();
        for (int i = 0; i < selectList.size(); i++) {
            if (i == selectList.size() - 1) {
                buffer.append(selectList.get(i).getName());
            } else {
                buffer.append(selectList.get(i).getName()).append(",");
            }
        }
        hintTv.setText(buffer.toString());
    }

    public Contact getSelect() {
        StringBuffer namebuffer = new StringBuffer();
        StringBuffer codebuffer = new StringBuffer();
        for (int i = 0; i < selectList.size(); i++) {
            if (i == selectList.size() - 1) {
                namebuffer.append(selectList.get(i).getName());
                codebuffer.append(selectList.get(i).getCode());
            } else {
                namebuffer.append(selectList.get(i).getName()).append(",");
                codebuffer.append(selectList.get(i).getCode());
            }
        }
        return new Contact("", namebuffer.toString(), codebuffer.toString());
    }

    public void setData(List<Contact> list, List<Contact> selectList) {
        this.filterList.clear();
        this.filterList.addAll(list);
        this.selectList.clear();
        this.selectList.addAll(selectList);
        adapter.notifyDataSetChanged();
        getString();
    }

    public List<Contact> getSelectList() {
        return selectList;
    }
}
