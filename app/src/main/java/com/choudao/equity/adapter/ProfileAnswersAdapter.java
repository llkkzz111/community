package com.choudao.equity.adapter;

import android.app.Activity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.choudao.equity.R;
import com.choudao.equity.entity.AnswerEntity;
import com.choudao.equity.utils.Utils;

import java.util.List;

/**
 * Created by liuzhao on 16/4/18.
 */
public class ProfileAnswersAdapter extends BaseAdapter {
    private Activity mContext;
    private List<AnswerEntity> listAnswers;

    public ProfileAnswersAdapter(Activity mContext, List<AnswerEntity> listAnswers) {
        this.mContext = mContext;
        this.listAnswers = listAnswers;
    }

    @Override
    public int getCount() {
        return listAnswers.size();
    }

    @Override
    public Object getItem(int position) {
        return listAnswers.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        AnswerEntity answer = listAnswers.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mContext).inflate(R.layout.activity_profile_answers_item_layout, null);
            holder.tvContent = (TextView) convertView.findViewById(R.id.tv_answer_content);
            holder.tvTitle = (TextView) convertView.findViewById(R.id.tv_question_title);
            holder.tvName = (TextView) convertView.findViewById(R.id.tv_answer_user_name);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.tvName.setText(answer.getUser().getName());
        String title = Utils.formatStr(answer.getQuestion().trim());
        holder.tvTitle.setText(title);
        String content = Utils.formatStr(answer.getSafe_content().trim());
        holder.tvContent.setText(content);
        return convertView;
    }

    class ViewHolder {
        TextView tvContent;
        TextView tvTitle;
        TextView tvName;
    }
}
