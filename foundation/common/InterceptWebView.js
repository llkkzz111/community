/**
 * Created by MASTERMIAO on 2017/6/20.
 * 拦截跳转WebView
 */
'use strict';

import React from 'react';

import {
    View,
    StyleSheet,
    Dimensions,
    WebView,
    Platform
} from 'react-native';

const { width, height } = Dimensions.get('window');

import * as ScreenUtils from '../../foundation/utils/ScreenUtil';

import NavigationBar from '../../foundation/common/NavigationBar';

import * as DialogAction from '../../app/actions/dialogaction/DialogAction';

import store from '../../app/createStore';

import * as InterceptParameterUtil from '../../foundation/utils/InterceptParameterUtil';

import { Actions } from 'react-native-router-flux';

let tempUrl = '';

export default class InterceptWebView extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            url: this.props.webUrl,
            status: 'No Page Loaded',
            backButtonEnabled: false,
            forwardButtonEnabled: false,
            loading: true,
            scalesPageToFit: true
        }
        this.renderNav = this.renderNav.bind(this);
    }

    render() {
        return (
            <View style={styles.webViewBg}>
                {this.renderNav()}
                <WebView
                    automaticallyAdjustContentInsets={false}
                    style={styles.webView}
                    source={{uri: this.state.url}}
                    javaScriptEnabled={true}
                    domStorageEnabled={true}
                    onLoadStart={this._onLoadStart}
                    onLoad={this._onLoad}
                    onLoadEnd={this._onDismissProgress}
                    onError={this._onWebLoadError}
                    onNavigationStateChange={(event) => {
                        tempUrl = event.url;
                        console.log('tempUrl:   ' + tempUrl)
                        let itemCode = InterceptParameterUtil.getParam(tempUrl);
                        Actions.GoodsDetailMain({itemcode: itemCode});
                    }}
                    scalesPageToFit={this.state.scalesPageToFit}
                    />
            </View>
        )
    }

    renderNav() {
        return (
            <NavigationBar
                title={''}
                navigationStyle={{...Platform.select({ios: {marginTop: -22}})}}
                titleStyle={{
                    fontSize: ScreenUtils.scaleSize(36)
                }}
                barStyle={'dark-content'}
            />
        )
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

    componentWillUnmount() {
        tempUrl = null;
    }
}

const styles = StyleSheet.create({
    webViewBg: {
        flex: 1,
        flexDirection: 'column'
    },
    webView: {
        width: width,
        height: height
    }
})

InterceptWebView.propTypes = {

}
