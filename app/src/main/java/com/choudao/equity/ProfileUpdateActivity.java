package com.choudao.equity;

import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.choudao.equity.api.BaseCallBack;
import com.choudao.equity.base.BaseActivity;
import com.choudao.equity.entity.ProfileEntity;
import com.choudao.equity.utils.Utils;
import com.choudao.equity.utils.params.IntentKeys;
import com.choudao.equity.view.TopView;
import com.choudao.imsdk.db.DBHelper;
import com.choudao.imsdk.db.bean.UserInfo;
import com.choudao.imsdk.dto.constants.UserType;
import com.choudao.imsdk.utils.Pinyin4jUtil;

import java.util.IdentityHashMap;
import java.util.Map;

import butterknife.BindColor;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import retrofit2.Call;


public class ProfileUpdateActivity extends BaseActivity {
    @BindView(R.id.topview) TopView topView;
    @BindView(R.id.et_profile_update) EditText etProfileUpdate;
    @BindView(R.id.tv_gender_man) TextView tvMan;
    @BindView(R.id.tv_gender_women) TextView tvWomen;
    @BindView(R.id.ll_gender) LinearLayout llGender;
    @BindColor(R.color.text_default_color) int defaultColor;
    @BindColor(R.color.tab_check_color) int checkColor;
    @BindColor(R.color.text_title_warning_text_color) int warningColor;
    @BindColor(R.color.grey) int enableColor;
    private String title;
    private int vId;
    private String content;
    private String hintText;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_profile_update_layout);
        ButterKnife.bind(this);
        content = getIntent().getStringExtra(IntentKeys.KEY_CONTENT);
        hintText = getIntent().getStringExtra(IntentKeys.KEY_HINT_TEXT);
        title = getIntent().getStringExtra(IntentKeys.KEY_TITLE);
        vId = getIntent().getIntExtra(IntentKeys.KEY_TYPE, -1);
        initView();
    }

    private void initView() {
        topView.setTitle(title);
        topView.setLeftImage();

        if (vId == R.id.ll_gender) {
            llGender.setVisibility(View.VISIBLE);
            etProfileUpdate.setVisibility(View.GONE);
        } else {
            llGender.setVisibility(View.GONE);
            etProfileUpdate.setVisibility(View.VISIBLE);
            topView.setRightText(R.string.text_save);
        }
        etProfileUpdate.setText(content);
        if (!TextUtils.isEmpty(content)) {
            etProfileUpdate.setSelection(content.length());
        }

        etProfileUpdate.setHint(hintText);

    }

    @OnTextChanged(value = R.id.et_profile_update, callback = OnTextChanged.Callback.TEXT_CHANGED)
    public void onTextChanged(CharSequence s) {
        content = etProfileUpdate.getText().toString();
        switch (vId) {
            case R.id.ll_address:
                checkInputTextLength(content, 100);
                break;
            case R.id.ll_experience:
                checkInputTextLength(content, 2000);
                break;
            case R.id.ll_education:
                checkInputTextLength(content, 2000);
                break;
            case R.id.ll_desc:
                checkInputTextLength(content, 300);
                break;
            case R.id.ll_title:
                checkInputTextLength(content, 26);
                break;
            case R.id.ll_nick_name:
                checkInputTextLength(content, 25);
                break;
        }
    }

    private void checkInputTextLength(String content, int length) {
        if (content.length() > length) {
            setRightDisable(content, length);
        } else {
            setRightEnabled();
        }
    }

    private void setRightEnabled() {
        if (topView.getTitleView().getText().toString().startsWith(getString(R.string.text_has_over))) {
            topView.setTitle(title);
            topView.getRightView().setEnabled(true);
            topView.getTitleView().setTextColor(defaultColor);
            topView.getRightView().setTextColor(checkColor);
        }
    }

    private void setRightDisable(String content, int length) {
        if (!topView.getTitleView().getText().toString().startsWith(getString(R.string.text_has_over))) {
            topView.getRightView().setEnabled(false);
            topView.getTitleView().setTextColor(warningColor);
            topView.getRightView().setTextColor(enableColor);
        }
        topView.setTitle(String.format(
                getString(R.string.text_has_over_text_size),
                (content.length() - length)));
    }

    @OnClick({R.id.iv_left, R.id.tv_gender_man, R.id.tv_gender_women, R.id.iv_right})
    public void onClick(View v) {
        String content = "";
        Utils.hideInput(v);
        switch (v.getId()) {
            case R.id.tv_gender_man:
                content = tvMan.getText().toString();
                break;
            case R.id.tv_gender_women:
                content = tvWomen.getText().toString();
                break;
            case R.id.iv_left:
                finish();
                return;
            case R.id.iv_right:
                content = etProfileUpdate.getText().toString().trim();
                updateUserProfile(content);
                break;
        }
        updateUserProfile(content);
    }

    private void updateUserProfile(String content) {
        Map<String, Object> params = new IdentityHashMap<>();
        switch (vId) {
            case R.id.ll_address:
                params.put("user_profile[address]", content);
                break;
            case R.id.ll_experience:
                params.put("user_profile[experience]", content);
                break;
            case R.id.ll_education:
                params.put("user_profile[education]", content);
                break;
            case R.id.ll_desc:
                params.put("user_profile[desc]", content);
                break;
            case R.id.ll_gender:
                params.put("user_profile[gender]", content);
                break;
            case R.id.ll_title:
                params.put("user_profile[title]", content);
                break;
            case R.id.ll_nick_name:
                params.put("user_profile[name]", content);
                break;
        }

        Call<ProfileEntity> call = service.updateProfile(params);
        call.enqueue(new BaseCallBack<ProfileEntity>() {

            @Override
            public void onSuccess(ProfileEntity response) {
                UserInfo userIfo = new UserInfo();
                userIfo.setUserId(response.getUser().getId());
                userIfo.setUserType(UserType.NORMAL.code);
                userIfo.setHeadImgUrl(response.getUser().getImg());
                userIfo.setName(response.getUser().getName());
                userIfo.setNamePinYin(Pinyin4jUtil.nameHanziToPinyin(response.getUser().getName()));
                userIfo.setTitle(response.getUser().getTitle());
                userIfo.setPhone(response.getUser().getPhone());
                userIfo.setFollowersCount(response.getUser().getFollowers_count());
                DBHelper.getInstance().saveUserInfo(userIfo);
                Utils.hideInput(topView);
                finish();
            }

            @Override
            public void onFailure(int errCode, String msg) {
                String sInfoFormat = getResources().getString(R.string.error_no_refresh);
                Toast.makeText(getBaseContext(), String.format(sInfoFormat, msg, String.valueOf(errCode)), Toast.LENGTH_SHORT).show();
            }

        });
    }

}
