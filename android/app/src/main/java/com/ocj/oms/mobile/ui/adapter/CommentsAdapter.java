package com.ocj.oms.mobile.ui.adapter;

import android.content.Context;
import android.os.Handler;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.blankj.utilcode.utils.LogUtils;
import com.blankj.utilcode.utils.ToastUtils;
import com.iarcuschin.simpleratingbar.SimpleRatingBar;
import com.ocj.oms.common.loader.LoaderFactory;
import com.ocj.oms.mobile.R;
import com.ocj.oms.mobile.bean.DataBean;
import com.ocj.oms.mobile.ui.createcomment.CreateComentActivity;
import com.ocj.oms.mobile.ui.personal.order.ImageAdapter;
import com.ocj.oms.mobile.view.ScrollEditText;
import com.ocj.oms.view.FixedGridView;

import java.util.ArrayList;
import java.util.HashMap;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * 类描述：
 * 创建人：yanglinchuan
 * 邮箱：linchuan.yang@pactera.com
 * 创建日期：2017/6/8 17:37
 */
public class CommentsAdapter extends BaseAdapter {
    private final Context mContext;
    private final LayoutInflater mInflater;
    private CreateComentActivity createComentActivity;
    private DataBean dataBean;
    private int currentClick;

    public CommentsAdapter(Context context, DataBean dataBean) {
        this.mContext = context;
        this.mInflater = LayoutInflater.from(context);
        this.dataBean = dataBean;
        createComentActivity = (CreateComentActivity) context;
    }

    @Override
    public int getCount() {
        return dataBean.getItems().size();
    }

    @Override
    public Object getItem(int i) {
        return dataBean.getItems().get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    int index = -1;

    @Override
    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
        final ViewHolder viewHolder;
        if (convertView == null) {
            convertView = mInflater.inflate(R.layout.item_create_comment, null);
            viewHolder = new ViewHolder(convertView);
            viewHolder.etComment.setTag(position);//注意设置position
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        //数据展示
        LoaderFactory.getLoader().loadNet(viewHolder.imageView, dataBean.getItems().get(position).getContentLink());
        viewHolder.tvName.setText(dataBean.getItems().get(position).getItem_name());
        viewHolder.rbQuality.setOnRatingBarChangeListener(new SimpleRatingBar.OnRatingBarChangeListener() {
            @Override
            public void onRatingChanged(SimpleRatingBar simpleRatingBar, float v, boolean b) {
                changeText(v, viewHolder.tvQuality);
                dataBean.getItems().get(position).getStars().put(0, v);
            }
        });
        viewHolder.rbPrice.setOnRatingBarChangeListener(new SimpleRatingBar.OnRatingBarChangeListener() {
            @Override
            public void onRatingChanged(SimpleRatingBar simpleRatingBar, float v, boolean b) {
                changeText(v, viewHolder.tvPrice);
                dataBean.getItems().get(position).getStars().put(1, v);
            }
        });
        viewHolder.occPrice.setText("￥" + dataBean.getItems().get(position).getRsale_amt());
        viewHolder.rbSpeed.setOnRatingBarChangeListener(new SimpleRatingBar.OnRatingBarChangeListener() {
            @Override
            public void onRatingChanged(SimpleRatingBar simpleRatingBar, float v, boolean b) {
                changeText(v, viewHolder.tvSpeed);
                dataBean.getItems().get(position).getStars().put(2, v);
            }
        });
        viewHolder.rbServe.setOnRatingBarChangeListener(new SimpleRatingBar.OnRatingBarChangeListener() {
            @Override
            public void onRatingChanged(SimpleRatingBar simpleRatingBar, float v, boolean b) {
                changeText(v, viewHolder.tvServe);
                dataBean.getItems().get(position).getStars().put(3, v);
            }
        });
        viewHolder.etComment.setText(dataBean.getItems().get(position).getComment());
        if (Float.parseFloat(dataBean.getItems().get(position).getItemSaveamt()) == 0) {
            viewHolder.scoreLayout.setVisibility(View.GONE);
        } else {
            viewHolder.scoreLayout.setVisibility(View.VISIBLE);
            viewHolder.tvScore.setText(dataBean.getItems().get(position).getItemSaveamt() + "");
        }
        //图片选择处理
        if (dataBean.getItems().get(position).getListUri() == null) {
            dataBean.getItems().get(position).setListUri(new ArrayList<String>());
        }
        final ImageAdapter adapter = new ImageAdapter(mContext, dataBean.getItems().get(position).getListUri(), viewHolder.gvImage) {
            @Override
            protected void updateView() {

            }
        };

        viewHolder.gvImage.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                viewHolder.gvImage.setAdapter(adapter);
                adapter.notifyDataSetChanged();
                viewHolder.gvImage.getViewTreeObserver().removeOnGlobalLayoutListener(this);
            }
        });
        adapter.setOnDeleteClickListener(new ImageAdapter.OnDeleteClickListener() {
            @Override
            public void delete(int i) {
                dataBean.getItems().get(position).getListUri().remove(i);
                adapter.notifyDataSetChanged();
            }
        });


        viewHolder.gvImage.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int i, long id) {
                LogUtils.d("TAG:" + "i:" + i);
                LogUtils.d("TAG:" + "count:" + adapter.getCount());
                //图片选择处理
                if (i == dataBean.getItems().get(position).getListUri().size() && (CreateComentActivity.IMG_MAX_NUM - dataBean.getItems().get(position).getListUri().size() != 0)) {
                    createComentActivity.showChoiceDialog(CreateComentActivity.IMG_MAX_NUM - dataBean.getItems().get(position).getListUri().size());
                    currentClick = position;
                    createComentActivity.getPhoto(position);

                }
            }
        });

        viewHolder.etComment.addTextChangedListener(new MyTextChangedListener(viewHolder));  //尽可能减少new 新对象出来

        viewHolder.etComment.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (event.getAction() == MotionEvent.ACTION_UP) {
                    index = position;
                }
                return false;
            }
        });
        viewHolder.tvColor.setText("颜色分类:" + dataBean.getItems().get(position).getDt_info());
        viewHolder.tvCount.setText("x " + dataBean.getItems().get(position).getItem_qty());
        viewHolder.etComment.clearFocus();
        if (index != -1 && index == position) {
            // 如果当前的行下标和点击事件中保存的index一致，手动为EditText设置焦点。
            viewHolder.etComment.requestFocus();
        }
        viewHolder.etComment.setSelection(viewHolder.etComment.getText().length());
        return convertView;
    }

    public void changeText(float f, TextView view) {
        if (f == 5f) {
            view.setText("很好");
        } else if (f == 4f) {
            view.setText("好");
        } else if (f == 3f) {
            view.setText("一般");
        } else {
            view.setText("差");
        }
    }


    public class MyTextChangedListener implements TextWatcher {

        public ViewHolder holder;

        public MyTextChangedListener(ViewHolder holder) {
            this.holder = holder;
        }

        @Override
        public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

        }

        @Override
        public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

        }

        @Override
        public void afterTextChanged(Editable editable) {

            if (holder != null && !TextUtils.isEmpty(editable)) {
                int position = (int) holder.etComment.getTag();
                String str = holder.etComment.getText().toString();
                if(editable.length() > 1000){
                    ToastUtils.showLongToast("评论不允许超过1000字");
                    try {
                        str = str.substring(0,1000);
                        holder.etComment.setText(str);
                        holder.etComment.setSelection(str.length());
                    }catch (Exception e){

                    }
                }
                dataBean.getItems().get(position).setComment(str);
            }
        }
    }

    static class ViewHolder {
        @BindView(R.id.imageView)
        ImageView imageView;
        @BindView(R.id.tv_name)
        TextView tvName;
        @BindView(R.id.tv_color)
        TextView tvColor;
        @BindView(R.id.tv_score)
        TextView tvScore;
        @BindView(R.id.rb_quality)
        SimpleRatingBar rbQuality;
        @BindView(R.id.tv_quality)
        TextView tvQuality;
        @BindView(R.id.rb_price)
        SimpleRatingBar rbPrice;

        @BindView(R.id.tv_occ_price)
        TextView occPrice;

        @BindView(R.id.tv_price)
        TextView tvPrice;
        @BindView(R.id.rb_speed)
        SimpleRatingBar rbSpeed;
        @BindView(R.id.tv_speed)
        TextView tvSpeed;
        @BindView(R.id.rb_serve)
        SimpleRatingBar rbServe;
        @BindView(R.id.tv_serve)
        TextView tvServe;
        @BindView(R.id.et_comment)
        ScrollEditText etComment;
        @BindView(R.id.gv_image)
        FixedGridView gvImage;

        @BindView(R.id.ll_score)
        LinearLayout scoreLayout;

        @BindView(R.id.tv_count)
        TextView tvCount;


        ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }


    /*static class ViewHolder {
        @BindView(R.id.tv_name)
        TextView tvName;
        @BindView(R.id.tv_color)
        TextView tvColor;
        @BindView(R.id.tv_jifen)
        TextView tvJifen;
        @BindView(R.id.rb_zhiliang)
        SimpleRating rbZhiliang;
        @BindView(R.id.tv_zhiliang)
        TextView tvZhiliang;
        @BindView(R.id.rb_jiage)
        SimpleRatingBar rbJiage;
        @BindView(R.id.tv_jiage)
        TextView tvJiage;
        @BindView(R.id.rb_sudu)
        SimpleRatingBar rbSudu;
        @BindView(R.id.tv_sudu)
        TextView tvSudu;
        @BindView(R.id.rb_fuwu)
        SimpleRatingBar rbFuwu;
        @BindView(R.id.tv_fuwu)
        TextView tvFuwu;
        @BindView(R.id.et_comment)
        EditText etComment;
        @BindView(R.id.gv_image)
        FixedGridView gvImage;

        ViewHolder(View view) {
            ButterKnife.bind(this, view);
        }
    }*/

}
