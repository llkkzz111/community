/**
 * Created by MASTERMIAO on 2017/6/18.
 * 商城店铺首页组件WebView
 */
'use strict';

import React from 'react';

import {
    View,
    StyleSheet,
    Dimensions,
    WebView
} from 'react-native';

const { width, height } = Dimensions.get('window');

let WEBVIEW_REF = 'webview';

import showLoadingDialog from '../../app/actions/dialogaction/DialogUtils';

export default class StoreDetailHomePage extends React.PureComponent {
    state = {
        url: 'https://www.2345.com',
        status: 'No Page Loaded',
        backButtonEnabled: false,
        forwardButtonEnabled: false,
        loading: true,
        scalesPageToFit: true
    };

    render() {
        return (
            <View style={styles.webViewBg}>
                <WebView
                    ref={WEBVIEW_REF}
                    automaticallyAdjustContentInsets={false}
                    style={styles.webView}
                    source={{uri: this.state.url}}
                    javaScriptEnabled={true}
                    domStorageEnabled={true}
                    onLoadStart={this._onLoadStart}
                    onLoad={this._onLoad}
                    onLoadEnd={this._onDismissProgress}
                    onError={this._onWebLoadError}
                    decelerationRate="normal"
                    onNavigationStateChange={this.onNavigationStateChange}
                    onShouldStartLoadWithRequest={this.onShouldStartLoadWithRequest}
                    scalesPageToFit={this.state.scalesPageToFit}
                />
            </View>
        )
    }

    onShouldStartLoadWithRequest = (event) => {
        return true;
    }

    onNavigationStateChange = (navState) => {
        this.setState({
            backButtonEnabled: navState.canGoBack,
            forwardButtonEnabled: navState.canGoForward,
            url: navState.url,
            status: navState.title,
            loading: navState.loading,
            scalesPageToFit: true
        });
    }

    _onDismissProgress = () => {
        showLoadingDialog(false);
    }

    _onLoadStart = () => {
        showLoadingDialog(true);
    }

    _onWebLoadError = () => {
        showLoadingDialog(false);
    }

    _onLoad = () => {

    }
}

const styles = StyleSheet.create({
    webViewBg: {
        flex: 1
    },
    webView: {
        width: width,
        height: height
    }
});

StoreDetailHomePage.propTypes = {

}