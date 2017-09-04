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

package com.ocj.oms.mobile.ui.register;


import com.ocj.oms.mobile.base.BaseContract;
import com.ocj.oms.mobile.bean.UserInfo;


/**
 * <p>
 * 注册presenter
 */
public interface RigesterContract extends BaseContract.View<String> {

    interface View extends BaseContract.View<String> {

        void fail(String msg);

        void succed(UserInfo userInfo);

        void showErrorMsg(String msg);

        void showOverLimitTimes();//验证码次数超限

        void showTimmer(String verifyCode);//显示时间


    }

    interface Presenter extends BaseContract.Presenter<View> {

        void rigsterCommit(String thirdPartyID, String mobile, String code, String pwd);

        void sendMobileCode(String phone, String purpose);
    }


}
