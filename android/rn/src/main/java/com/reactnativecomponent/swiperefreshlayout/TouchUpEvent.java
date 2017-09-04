package com.reactnativecomponent.swiperefreshlayout;


import com.facebook.react.uimanager.events.Event;
import com.facebook.react.uimanager.events.RCTEventEmitter;

/**
 * Created by jiajiewang on 2017/6/27.
 */

public class TouchUpEvent extends Event<TouchUpEvent> {

    public TouchUpEvent(int viewTag, long timestampMs) {
        super(viewTag);
    }

    @Override
    public String getEventName() {
        return "RCTSwipeRefreshLayout.TouchUp";
    }

    @Override
    public void dispatch(RCTEventEmitter rctEventEmitter) {
        rctEventEmitter.receiveEvent(getViewTag(), getEventName(), null);
    }
}
