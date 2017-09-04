/**
 * Created by MASTERMIAO on 2017/6/19.
 * 商城店铺网页版
 */
'use strict';

import React from 'react';

import {
    View,
    StyleSheet,
    Dimensions,
    WebView,
    StatusBar,
    Platform
} from 'react-native';

const { width, height } = Dimensions.get('window');

import StoreDetailHtml5Request from '../../../../foundation/net/home/store/StoreDetailHtml5Request';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import Immutable from 'immutable';

import * as DialogAction from '../../../../app/actions/dialogaction/DialogAction';

import store from '../../../../app/createStore';

import { Actions } from 'react-native-router-flux';

export default class StoreDetailHtml5 extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            url: '',
            status: '',
            backButtonEnabled: false,
            forwardButtonEnabled: false,
            loading: true,
            scalesPageToFit: true
        }
    }

    render() {
        let viewer = <View />;
        if (this.state.url !== '' && this.state.url !== "") {
            viewer = <WebView
                automaticallyAdjustContentInsets={false}
                style={styles.webView}
                source={{uri: this.state.url}}
                javaScriptEnabled={true}
                domStorageEnabled={true}
                onLoadStart={this._onLoadStart}
                onLoad={this._onLoad}
                onLoadEnd={this._onDismissProgress}
                onError={this._onWebLoadError}
                scalesPageToFit={this.state.scalesPageToFit}
            />
        }
        return (
            <View style={styles.webViewBg}>
                {viewer}
            </View>
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

    componentDidMount() {
        let { contentCode } = this.props;
        let params = {
            id: 'AP1706A045',
            contentCode: String(contentCode)
        }
        this.StoreDetailHtml5Request = new StoreDetailHtml5Request(params, 'GET');
        this.StoreDetailHtml5Request.start((response) => {
            let object = Immutable.fromJS(response);
            this.setState({url: object.get('destinationUrl')})
        }, (error) => {
            Actions.pop();
        });
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
        height: height,
    }
});

StoreDetailHtml5.propTypes = {
    destinationUrl: React.PropTypes.any,
    contentCode: React.PropTypes.number,
    title: React.PropTypes.string
}
