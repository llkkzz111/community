package com.choudao.imsdk.imutils;

/**
 * Created by dufeng on 16/4/25.<br/>
 * Description: LoginManager
 */
public class LoginManager extends BaseManager {

    private LoginManager() {
    }

    private static LoginManager instance;

    public static LoginManager getInstance() {
        if (instance == null) {
            instance = new LoginManager();
        }
        return instance;
    }

}
