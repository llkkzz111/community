/**
 * Created by MASTERMIAO on 2017/6/25.
 * 商城通用WebView
 */
'use strict';

import React from 'react';

import {
    View,
    StyleSheet,
    Dimensions,
    WebView,
    Platform,
    StatusBar
} from 'react-native';

const { width, height } = Dimensions.get('window');

import * as DialogAction from '../../../../app/actions/dialogaction/DialogAction';

import store from '../../../../app/createStore';

import { Actions } from 'react-native-router-flux';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import { getStatusHeight }from '../../../../foundation/common/NavigationBar';

let canJump = true;

let iosUserAgent = 'OCJ_A1JKapp_log Mozilla/5.0 (iPhone; CPU; iPhone OS 7.0; zh-cn; C6802 Build/14.2.A.0.290) AppleWebKit/537.51.1 (KHTML, like Gecko) iOS Mobile[95955F33-BFBD-48BA-A630-866D2DAE482D]app_reconsitution';

let androidUserAgent = 'OCJ_A1JKapp_log Mozilla/5.0 (Linux; U; Android 4.3; zh-cn; C6802 Build/14.2.A.0.290) AppleWebKit/534.30 (KHTML, like Gecko) Android Mobile[355066062891876#f0:25:b7:b3:15:69#SM-G9008V#6.0.1#WIFIMAC:f0:25:b7:b3:15:69]app_reconsitution';

import Global from '../../../config/global';

export default class StoreWebView extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            url: this.props.webUrl,
            token: Global.token,
            title: this.props.title,
            status: '',
            backButtonEnabled: false,
            forwardButtonEnabled: false,
            loading: true,
            scalesPageToFit: true
        }
        this.renderStatusBar = this.renderStatusBar.bind(this);
        this.webJump = this.webJump.bind(this);
    }

    render() {
        return (
            <View style={styles.webViewBg}>
                {this.renderStatusBar()}
                <WebView
                    automaticallyAdjustContentInsets={false}
                    style={styles.webView}
                    source={{uri: this.state.url,
                        headers: {
                        'X-access-token': this.state.token,
                        'User-Agent': Platform.OS === 'ios' ? iosUserAgent : androidUserAgent }}}
                    javaScriptEnabled={true}
                    domStorageEnabled={true}
                    onLoadStart={this._onLoadStart}
                    onLoad={this._onLoad}
                    onLoadEnd={this._onDismissProgress}
                    onError={this._onWebLoadError}
                    scalesPageToFit={this.state.scalesPageToFit}
                    onShouldStartLoadWithRequest={(event) => {
                        if (event.url.indexOf('#') != -1) {
                            let uncodeUrl = decodeURI(event.url);
                            if (canJump) {
                                try {
                                    if (event.url.indexOf('IM') != -1) {
                                        Actions.pop();
                                    } else {
                                        let webJson = JSON.parse(uncodeUrl.split('#')[1]);
                                        this.webJump(webJson.action, webJson.url ? webJson.url : '', webJson.param);
                                    }
                                } catch (e) {

                                }
                            }
                        }
                        return true;
                    }}
                    onNavigationStateChange={(event) => {
                        if (event.url.indexOf('#') != -1) {
                            if (canJump) {
                                try {
                                    if (event.url.indexOf('IM') != -1) {
                                        Actions.pop();
                                    } else {
                                        let webJson = JSON.parse(event.url.split('#')[1]);
                                        this.webJump(webJson.action, webJson.url ? webJson.url : '', webJson.param);
                                    }
                                } catch (e) {

                                }
                            }
                        }
                    }}
                />
            </View>
        )
    }

    renderStatusBar() {
        return (
            <StatusBar
                translucent={true}
                barStyle={'dark-content'}
                backgroundColor={'transparent'}
            />
        );
    }

    _onDismissProgress = () => {
        store.dispatch(DialogAction.showLoading(false));
    }

    _onLoadStart = () => {
        store.dispatch(DialogAction.showLoading(true));
    }

    _onWebLoadError = () => {
        store.dispatch(DialogAction.showLoading(false));
    }

    _onLoad = () => {

    }

    webJump(action, returnUrl, param) {
        canJump = false;
        switch (action) {
            case 'back':
                Actions.pop();
                break;
            default:
                break;
        }
    }

    componentDidMount() {
        canJump = true;
    }

    componentWillUnmount() {
        canJump = true;
    }
}

const styles = StyleSheet.create({
    webViewBg: {
        flex: 1,
        ...Platform.select({
            ios: {
                marginTop: -22
            }
        })
    },
    webView: {
        width: width,
        // height: height,
        marginTop: getStatusHeight()
    }
});

StoreWebView.propTypes = {
    webUrl: React.PropTypes.string,
    title: React.PropTypes.string
}
