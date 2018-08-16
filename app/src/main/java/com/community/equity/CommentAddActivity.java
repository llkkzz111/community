package com.community.equity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.community.equity.api.BaseCallBack;
import com.community.equity.base.BaseActivity;
import com.community.equity.entity.CommentEntity;
import com.community.equity.utils.ConstantUtils;
import com.community.equity.utils.Utils;
import com.community.equity.utils.params.IntentKeys;
import com.community.equity.view.TopView;

import java.util.IdentityHashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import retrofit2.Call;

public class CommentAddActivity extends BaseActivity {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.et_comment) EditText etComment;
    @BindView(R.id.iv_left) TextView ivLeft;
    @BindView(R.id.iv_right) TextView ivRight;

    private int questionId = -1, answerId = -1;
    private CommentEntity commentEntity;
    private int maxLength = ConstantUtils.COMMENT_CONTENT_MAX_LENGTH;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_comment_add_layout);
        ButterKnife.bind(this);
        questionId = getIntent().getIntExtra(IntentKeys.KEY_QUESTION_ID, -1);
        answerId = getIntent().getIntExtra(IntentKeys.KEY_ANSWER_ID, -1);
        commentEntity = (CommentEntity) getIntent().getSerializableExtra(IntentKeys.KEY_COMMENT_ENTITY);
        initView();
    }

    private void initView() {
        topView.setRightText(R.string.text_publish);
        topView.setLeftImage();
        if (commentEntity != null) {
            topView.setTitle(getString(R.string.text_update_comment));
            etComment.setText(commentEntity.getContent());
            if (!TextUtils.isEmpty(commentEntity.getContent()))
                etComment.setSelection(commentEntity.getContent().length());
        } else {
            topView.setTitle(getString(R.string.text_write_comment));
        }
    }

    private void addOrUpdateCommunity(String mComment) {
        Map<String, Object> params = new IdentityHashMap<>();
        params.put("comment[content]", mComment);
        Call<CommentEntity> call = null;
        if (commentEntity != null) {
            params.put("answerId", answerId);
            params.put("commentId", commentEntity.getId());
            call = service.editComment(answerId, commentEntity.getId(), params);
        } else {
            call = service.addComment(questionId, answerId, params);
        }
        call.enqueue(new BaseCallBack<CommentEntity>() {
            @Override
            protected void onSuccess(CommentEntity body) {
                onHttpSuccess(body);
            }

            @Override
            protected void onFailure(int code, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                topView.getRightView().setEnabled(true);
                Toast.makeText(getBaseContext(), String.format(sInfoFormat, msg, String.valueOf(code)), Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void onHttpSuccess(CommentEntity commentEntity) {
        if (commentEntity != null) {
            Intent intent = new Intent();
            intent.putExtra(IntentKeys.KEY_COMMENT_ENTITY, commentEntity);
            setResult(Activity.RESULT_OK, intent);
            Utils.hideInput(topView);
            finish();
        }
    }


    @OnClick({R.id.iv_left, R.id.iv_right})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_left:
                Utils.hideInput(topView);
                finish();
                break;
            case R.id.iv_right:
                String mComment = etComment.getText().toString().trim();
                if (TextUtils.isEmpty(mComment)) {
                    Toast.makeText(mContext, getString(R.string.text_please_add_comment), Toast.LENGTH_SHORT).show();
                    return;
                }
                topView.getRightView().setEnabled(false);
                addOrUpdateCommunity(mComment);
                break;
        }
    }

    @OnTextChanged(value = R.id.et_comment, callback = OnTextChanged.Callback.TEXT_CHANGED)
    public void onTextChenge(CharSequence text) {
        int length = etComment.getText().toString().length();
        if (length > maxLength) {
            if (!topView.getTitleView().getText().toString().startsWith("评论")) {
                topView.getRightView().setEnabled(false);
                topView.getRightView().setTextColor(getResources().getColor(R.color.grey));
                topView.getTitleView().setTextColor(getResources().getColor(R.color.text_title_warning_text_color));
            }
            topView.setTitle(String.format(
                    getString(R.string.text_has_over_text_size),
                    (length - maxLength)));
        } else {
            if (!topView.getTitleView().getText().toString().endsWith("评论")) {
                topView.getRightView().setEnabled(true);
                topView.getRightView().setTextColor(getResources().getColor(R.color.tab_check_color));
                topView.getTitleView().setTextColor(getResources().getColor(R.color.text_default_color));
                if (commentEntity != null) {
                    topView.setTitle(getString(R.string.text_update_comment));
                } else {
                    topView.setTitle(getString(R.string.text_write_comment));
                }
            }

        }
    }


}
