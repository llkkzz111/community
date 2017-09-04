/**
 * Created by jzz on 2017/7/8.
 */

import React from 'react';
import {
    WebView,
    Platform,
    View,
    StatusBar
} from 'react-native';
import * as ScreenUtil from '../../../foundation/utils/ScreenUtil';
export default class OrderWebView extends React.PureComponent {
    constructor(props) {
        super(props);
        // console.log('---> CommonWebView constructor');
        this.onWebLoadStart = this.onWebLoadStart.bind(this);
        this.onWebLoad = this.onWebLoad.bind(this);
        this.onWebLoadError = this.onWebLoadError.bind(this);
        this.state = {
            webUrl: this.props.webUrl,
        }
    }

    onWebLoadStart() {
        // console.log('--->onWebLoadStart');
    }

    onWebLoad() {
        // console.log('--->onWebLoad');
    }

    onWebLoadError() {
        // console.log('--->onWebLoadError');
    }

    //渲染页面
    render() {
        // console.log('---> CommonWebView render');
        return (
            <View style={{flex: 1, width: ScreenUtil.screenW}}>
                {this._renderStatus}
                <WebView
                    source={{uri: this.state.webUrl}}
                    style={{width: ScreenUtil.screenW}}
                    automaticallyAdjustContentInsets={false}
                    startInLoadingState={true}
                    domStorageEnabled={true}
                    javaScriptEnabled={true}
                    onLoadStart={this.onWebLoadStart}
                    onError={this.onWebLoadError}
                    onLoad={this.onWebLoad}
                    scalesPageToFit={true}
                />
            </View>
        )
    }

    _renderStatus() {
        return (
            <StatusBar
                translucent={false}
                barStyle={'dark-content'}
            />
        );
    }

    //页面渲染后调用
    componentDidMount() {
    }


    shouldComponentUpdate(nextProps, nextState) {
        // console.log('---> CommonWebView shouldComponentUpdate');
        if (!(this.state.webUrl === nextState.webUrl || Immutable.is(this.state.webUrl, nextState.webUrl))) {
            return true;
        } else {
            return false;
        }
    }

    //页面卸载前触发
    componentWillUnmount() {

    }
}
