/*
 * Copyright 2016, The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.ocj.oms.mobile.ui.login;

import com.ocj.oms.mobile.base.BaseContract;
import com.ocj.oms.mobile.bean.UserBean;
import com.ocj.oms.mobile.bean.UserInfo;

import java.util.Map;


/**
 * This specifies the contract between the view and the presenter.
 */
public interface LoginContract extends BaseContract {

    interface View extends BaseContract.View<UserBean> {

        void fail(String msg);

        /**
         * 不同用户类型登录
         */

        void showNewMediaMail();

        void showNewMediaMob();

        void showTVTel();

        void showTVMob();

        void showUnknown(String msg);

        /**
         * 普通、动态密码登录
         */
        void inputNormalPwd();

        void inputDynamicPwd();

        /**
         * 登录结果
         */
        void loginFail(int code, String msg);

        void loginSuccess(UserInfo userInfo);

        /**
         * 获取验证码
         */
        void startCountTime();

        void countingTime(long time);

        void finishCountTime();

        void loadingCode();

        void finishLoadingCode();

        void getVerifyFail();

        void getVerifySuccess(String verifyCode);


        void hideSlide();

        void getInternalId(String id);

        void setUserType(int type);
    }

    interface Presenter extends BaseContract.Presenter<View> {
        void checkUserType(String loginId);

        void getVerifyCode(long countTime, String mobileNum);

        void smsLogin(Map<String, String> params);

        void passwordLogin(Map<String, String> params);

        void tvMobLogin(String mobile, String verifyCode, String name, String internalId, String thirdId);

        void tvTelLogin(String tel, String name);


    }


}
