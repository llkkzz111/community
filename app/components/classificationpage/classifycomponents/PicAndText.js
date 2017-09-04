/**
 * Created by wangwenliang on 2017/5/11.
 * 商品详情的图文详情
 */
import React, { Component, PureComponent } from 'react';
import {
    Dimensions,
    WebView,
    View,
    Platform
} from 'react-native';
import AppConstant, {DEBUG_MODE} from '../../../constants/AppConstant';
import Global from '../../../config/global';
const {width} = Dimensions.get('window');

/**
* @description
* 根据开发环境选择是否要不可变数据结构
* @const {class}
*/
const Com = __DEV__ ? Component : PureComponent;

export default class PicAndText extends Com {

    constructor(props) {
        super(props);
        this.state = {
            webHeight: 0,
            html: ''
        }
    }

    getHeightFromUrl(url) {
        let split = url.split("#");
        if (split.length < 2) {
            return 0;
        }
        let lastIndex = split.length - 1;
        let str = split[lastIndex];

        let n = Number(str);
        if (!isNaN(n)) {
            let number = parseFloat(split[lastIndex]);
            return number;
        } else {
            return 0;
        }

    }

    getUserToken() {
        if (DEBUG_MODE) {
            return Global.testToken;
        } else {
            return Global.token;
        }
    }

    render() {
        let source = {};
        let url = AppConstant.BASE_URL + "/api/items/detailImageContent?item_Code=" + this.props.allDatas.goodsDetail.item_code + "&isPufa&access_token=" + this.getUserToken();
        if (Platform.OS === 'android') {
            source['html'] = this.state.html;
        } else {
            source['uri'] = url;
        }
        return (
            <View style={{
                minHeight: Dimensions.get('window').height - 120
            }}>
                <WebView
                    javaScriptEnabled={true}
                    onStartShouldSetResponder={()=> {
                        return true
                    }}
                    onStartShouldSetResponderCapture={()=> {
                        return true
                    }}
                    ref="webviewbridge"
                    domStorageEnabled={true}
                    scrollEnabled={false}
                    source={source}
                    // source={{html: demo}}
                    style={{
                        width: width,
                        height: this.state.webHeight,
                        minHeight: Dimensions.get('window').height - 120
                    }}
                    scalesPageToFit={true}
                    startInLoadingState={true}
                    onNavigationStateChange={(info) => {
                        // console.log(' ---> onNavigationStateChange  ' + info.url);
                        // console.log(' ---> onNavigationStateChange  newheight:' + this.getHeightFromUrl(info.url));
                        let height1 = this.getHeightFromUrl(info.url);
                        if (height1 !== this.state.webHeight) {
                            this.setState({
                                webHeight: this.getHeightFromUrl(info.url)
                            })
                        }
                    }}
                    automaticallyAdjustContentInsets={true}
                />
            </View>
        )
    }

    componentDidMount() {
        if (Platform.OS === 'android' && this.state.html.length === 0) {
            let url = AppConstant.BASE_URL + "/api/items/detailImageContent?item_Code=" + this.props.allDatas.goodsDetail.item_code + "&isPufa&access_token=" + this.getUserToken();
            fetch(url).then((response) => response.text()).then((responseText) => {
                this.setState({
                    html: responseText
                });
            }).catch((error) => {
                // console.error(error);
            });
        }
    }
}
