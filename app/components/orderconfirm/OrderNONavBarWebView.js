/**
 * Created by jzz on 2017/7/11.
 */

import React from 'react'
import {
    StyleSheet,
    View,
    WebView,
    StatusBar,
    Platform
} from 'react-native'
import {Actions} from 'react-native-router-flux';
import {getStatusHeight}from '../../../foundation/common/NavigationBar';
export default class KeFu extends React.PureComponent {

    constructor(props) {
        super(props);
        // alert(this.props.url);
        this.state={
            first:true
        }
    }

    render() {
        return (
            <View style={[{flex:1},{backgroundColor: '#fff'},  {...Platform.select({ios:{marginTop:-22}}), paddingTop:getStatusHeight()}]}>
                <StatusBar
                    translucent={true}
                    barStyle={'dark-content'}
                    backgroundColor={'#fff'}
                />
                <WebView
                    javaScriptEnabled={true}
                    onStartShouldSetResponder={true}
                    onStartShouldSetResponderCapture={true}
                    scalesPageToFit={true}
                    domStorageEnabled={true}
                    contentInset={ {top:0,left:0,bottom:0,right:0}}
                    source={{uri:this.props.url}}
                    startInLoadingState={true}
                    onNavigationStateChange={(info) => {
                         if (info.url && info.url != "about:blank" && info.url!=this.props.url && info.url.startsWith('http://m.ocj.com.cn')){
                             if (this.state.first){
                                 Actions.pop();
                                 this.setState({first:false});
                             }
                         }
                    }}
                    automaticallyAdjustContentInsets={true}
                />
            </View>
        )
    }
}

const styles = StyleSheet.create({});