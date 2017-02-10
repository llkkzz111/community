package com.choudao.equity.adapter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.choudao.equity.R;
import com.choudao.equity.entity.QuestionEntity;
import com.choudao.equity.utils.Utils;

import java.util.List;

/**
 * Created by liuzhao on 16/4/8.
 */
public class QuestionsAdapter extends BaseAdapter {
    private Context mContext;
    private List<QuestionEntity> listQuestion;

    public QuestionsAdapter(Activity mContext, List<QuestionEntity> listQuestion) {
        this.mContext = mContext;
        this.listQuestion = listQuestion;
    }

    @Override
    public int getCount() {
        return listQuestion.size();
    }

    @Override
    public Object getItem(int position) {
        return listQuestion.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        QuestionEntity question = listQuestion.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(mContext).inflate(R.layout.activity_question_item_layout, null);
            holder.tvTitle = (TextView) convertView.findViewById(R.id.tv_question_item_title);
            holder.tvAnswerCount = (TextView) convertView.findViewById(R.id.tv_question_answer_count);
            holder.tvBrowseCount = (TextView) convertView.findViewById(R.id.tv_question_browse_count);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        String title = Utils.formatStr(question.getTitle().trim());
        holder.tvTitle.setText(title);

        holder.tvAnswerCount.setText(question.getAnswersCount() + "条回答");
        holder.tvBrowseCount.setText(question.getView_count() + "次浏览");
        return convertView;
    }

    class ViewHolder {
        TextView tvTitle;
        TextView tvAnswerCount;
        TextView tvBrowseCount;
    }
}
