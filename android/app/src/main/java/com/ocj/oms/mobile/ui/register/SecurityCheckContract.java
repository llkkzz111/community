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
import com.ocj.oms.mobile.bean.ItemsBean;
import com.ocj.oms.mobile.bean.UserInfo;

import java.util.List;
import java.util.Map;


/**
 * <p>
 * 注册presenter
 */
public interface SecurityCheckContract extends BaseContract.View<String> {

    interface View extends BaseContract.View<String> {

        void showList(List<ItemsBean> data);

        void onVerifySucced(UserInfo userInfo);

        void onVerifyFail(String msg);


    }

    interface Presenter extends BaseContract.Presenter<View> {

        void getImgList(String menberId);//获取图片列表

        void commitTvUserVerfy(Map<String, String> param);//确认校验


    }


}
