package com.community.imsdk.imutils.callback;

import com.community.imsdk.dto.constants.StatusType;

/**
 * Created by dufeng on 16/5/23.<br/>
 * Description: IMStatusListener
 */
public interface IMStatusListener {


    void notifyNetStatus(StatusType statusType);

    void notifySocketStatus(StatusType statusType);
}
