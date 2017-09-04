/*
 * Copyright (C) 2015 Bilibili <jungly.ik@gmail.com>
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

package com.bilibili.socialize.share.core.shareparam;

import android.os.Parcel;

/**
 * @author Jungly
 * @email jungly.ik@gmail.com
 * @since 2015/9/31
 */
public class ShareParamImage extends BaseShareParam {

    private ShareImage mImage;

    public ShareParamImage() {
    }

    public ShareParamImage(String title, String content) {
        super(title, content);
    }

    public ShareParamImage(String title, String content, String targetUrl) {
        super(title, content, targetUrl);
    }

    public ShareImage getImage() {
        return mImage;
    }

    public String getImageUrl() {
        return mImage == null ? null : mImage.getNetImageUrl();
    }

    public void setImage(ShareImage image) {
        mImage = image;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeParcelable(mImage, 0);
    }

    protected ShareParamImage(Parcel in) {
        super(in);
        mImage = in.readParcelable(ShareImage.class.getClassLoader());
    }

    public static final Creator<ShareParamImage> CREATOR = new Creator<ShareParamImage>() {
        public ShareParamImage createFromParcel(Parcel source) {
            return new ShareParamImage(source);
        }

        public ShareParamImage[] newArray(int size) {
            return new ShareParamImage[size];
        }
    };
}
