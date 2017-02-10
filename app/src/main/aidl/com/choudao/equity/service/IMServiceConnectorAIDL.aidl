// IIMConnectAIDL.aidl
package com.choudao.equity.service;

// Declare any non-default types here with import statements

interface IMServiceConnectorAIDL {

    void loginIMServer(int userId);

    void logoutIMServer();

    void setKickOut(boolean kickOut);

    void cancelNotificationById(String tag,int id);
}
