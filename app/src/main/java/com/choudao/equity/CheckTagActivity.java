package com.choudao.equity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.provider.Settings;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.choudao.equity.adapter.CheckTagsAdapter;
import com.choudao.equity.adapter.CheckTagsAddAdapter;
import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.api.MyCallBack;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.base.BaseApiResponse;
import com.choudao.equity.dialog.BaseDialogFragment;
import com.choudao.equity.entity.QuestionEntity;
import com.choudao.equity.entity.TagEntity;
import com.choudao.equity.utils.ActivityStack;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.LinearLineWrapLayout;
import com.choudao.equity.view.TopView;

import java.util.ArrayList;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemClick;
import retrofit2.Call;

/**
 * Created by liuzhao on 16/4/11.
 */
public class CheckTagActivity extends BaseActivity {
    @BindView(R.id.topview) TopView topview;
    @BindView(R.id.fgl_tags) LinearLineWrapLayout fglTags;
    @BindView(R.id.lv_tags) ListView lvTags;

    private List<TagEntity> listTags = new ArrayList<>();
    private BaseAdapter adapter = null;
    private String questionContent;
    private String questionTitle;
    private List<TagEntity> listCheckTag = new ArrayList<>();
    private boolean isCheckTag = false;
    private BaseDialogFragment dialog = BaseDialogFragment.newInstance();

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_check_tag_layout);
        ButterKnife.bind(this);
        setSubContentView(lvTags);
        fglTags.setVisibility(View.GONE);
        if (getIntent().hasExtra(IntentKeys.KEY_TITLE)) {
            isCheckTag = true;
            questionTitle = getIntent().getStringExtra(IntentKeys.KEY_TITLE);
            questionContent = getIntent().getStringExtra(IntentKeys.KEY_CONTENT);
            adapter = new CheckTagsAddAdapter(this, listTags);
        } else {
            isCheckTag = false;
            adapter = new CheckTagsAdapter(this, listTags);
        }
        lvTags.setAdapter(adapter);
        initView();
        showLoadView();
        getData();

    }

    private void initView() {
        topview.setLeftImage();
        topview.setTitle(R.string.text_please_choise);
        if (isCheckTag) {
            topview.setRightText(R.string.text_publish);
            topview.getRightView().setEnabled(false);
            topview.getRightView().setTextColor(getResources().getColor(R.color.tab_uncheck_color));
        }
    }

    private void addItemView(LinearLineWrapLayout viewGroup, String text) {
        final View v = LayoutInflater.from(mContext).inflate(R.layout.tag_text_layout, null);
        TextView tvItem = (TextView) v.findViewById(R.id.tv_tags);
        tvItem.setText(text);
        viewGroup.addView(v);
    }

    private void getData() {
        Call<BaseApiResponse<List<TagEntity>>> repos = service.listTag();
        repos.enqueue(new MyCallBack<List<TagEntity>>() {

            @Override
            public void onSuccess(BaseApiResponse<List<TagEntity>> response) {
                showContentView();
                setData(response.getDataSource());
            }

            @Override
            public void onFailure(int code, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                showErrorView(String.format(sInfoFormat, msg, String.valueOf(code)));
            }

            @Override
            public void onFailure(Call<BaseApiResponse<List<TagEntity>>> call, Throwable t) {
                super.onFailure(call, t);
                String msg = "请检查当前网络状态\n 点击跳转设置界面";
                showErrorView(msg).findViewById(R.id.error_message).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent intent = new Intent(Settings.ACTION_SETTINGS);
                        startActivity(intent);
                    }
                });
            }
        });

    }

    /**
     * 刷新数据
     *
     * @param tags
     */
    private void setData(List<TagEntity> tags) {
        if (!isCheckTag) {
            TagEntity tag = new TagEntity();
            tag.setName(getString(R.string.text_all));
            tag.setIcon("");
            listTags.add(0, tag);
        }
        listTags.addAll(tags);
        adapter.notifyDataSetChanged();
    }

    @OnClick({R.id.iv_left, R.id.iv_right})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_left:
                finish();
                break;
            case R.id.iv_right:
                topview.getRightView().setFocusable(false);
                addQuestion();
                break;
        }
    }

    @OnItemClick(R.id.lv_tags)
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        TagEntity tag = listTags.get(position);
        if (!getIntent().hasExtra(IntentKeys.KEY_CONTENT)) {
            Intent intent = new Intent();
            intent.putExtra(IntentKeys.KEY_TAG_ID, tag.getName());
            setResult(Activity.RESULT_FIRST_USER, intent);
            finish();
        } else {
            CheckTagsAddAdapter.ViewHolder holder = (CheckTagsAddAdapter.ViewHolder) view.getTag();
            holder.cbCheckTag.toggle();
            if (holder.cbCheckTag.isChecked()) {

                if (listCheckTag.size() < 5) {
                    addItemView(fglTags, tag.getName());
                    listCheckTag.add(tag);
                } else {
                    Toast.makeText(CheckTagActivity.this, "最多选择五个标签", Toast.LENGTH_SHORT).show();
                    holder.cbCheckTag.toggle();
                }
                if (fglTags.getChildCount() > 0) {
                    fglTags.setVisibility(View.VISIBLE);
                    topview.getRightView().setEnabled(true);
                    topview.getRightView().setTextColor(getResources().getColor(R.color.tab_check_color));
                }
            } else {
                for (int i = 0; i < fglTags.getChildCount(); i++) {
                    LinearLayout v = (LinearLayout) fglTags.getChildAt(i);
                    TextView tvTagName = (TextView) v.getChildAt(0);
                    if (tvTagName.getText().equals(tag.getName())) {
                        fglTags.removeViewAt(i);
                        listCheckTag.remove(tag);
                    }
                }
                if (fglTags.getChildCount() == 0) {
                    topview.getRightView().setEnabled(false);
                    topview.getRightView().setTextColor(getResources().getColor(R.color.tab_uncheck_color));
                    fglTags.setVisibility(View.GONE);
                }
            }
        }
    }

    private void addQuestion() {
        dialog.addProgress();
        dialog.show(getSupportFragmentManager(), "load");


        Map<String, Object> map = new IdentityHashMap<>();
        map.put("question[content]", questionContent);
        map.put("question[title]", questionTitle);
        for (int i = 0; i < listCheckTag.size(); i++) {
            map.put(new String("question[tags][]"), listCheckTag.get(i).getName());
        }
        Call<QuestionEntity> repos = service.addQuestions(map);
        repos.enqueue(new BaseCallBack<QuestionEntity>() {
            @Override
            public void onSuccess(QuestionEntity response) {
                ActivityStack.getInstance().popAllActivityUntilCls(MainActivity.class);
                Intent intent = new Intent();
                intent.setClass(mContext, QuestionDetailsActivity.class);
                intent.putExtra(IntentKeys.KEY_QUESTION_ID, response.getId());
                startActivity(intent);
                topview.getRightView().setFocusable(false);
                dialog.dismissAllowingStateLoss();
            }

            @Override
            public void onFailure(Call<QuestionEntity> call, Throwable t) {
                topview.getRightView().setFocusable(false);
                dialog.dismissAllowingStateLoss();
            }

            @Override
            public void onFailure(int code, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                Toast.makeText(getBaseContext(), String.format(sInfoFormat, msg, String.valueOf(code)), Toast.LENGTH_SHORT).show();
                topview.getRightView().setFocusable(false);
                dialog.dismissAllowingStateLoss();
            }
        });

    }

}
