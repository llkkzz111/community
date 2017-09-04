/**
* @file 浏览器自适应
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
import React, { Component } from 'react';
import {
    WebView,
    View,
    Image,
    StyleSheet,
    Dimensions,
    Linking
} from 'react-native';
import { Actions } from 'react-native-router-flux';
import Colors from 'CONFIG/colors';
import REXP from 'UTILS/RegularExpression';

export class WebViewAutoHeight extends Component {
    constructor(props) {
        super(props);
        this.loading = this.props.loading || true;
        this.state = {
            webHeight: 0
        };
    }
    async componentDidMount() {
        const _taht = this;
        // 获取ref
        this.props.getRef ? this.props.getRef(this.webview) : null;
        // 异步加载远程css，防止css在webview中加载延迟渲染速度
        if(this.props.cssModules) {
            let style = [];
            const cssModules = await Promise.all(this.props.cssModules.map(d => fetch(d, {
                method: 'GET'
            })));
            cssModules.forEach(async function(d, index) {
                if (d && d.ok && d.status === 200) {
                    const css = await d.text();
                    // 按照顺序加载css
                    style[index] = css;
                    index === cssModules.length - 1 ? _taht.webview.postMessage(JSON.stringify({
                        type: 'appendStyle',
                        style: style.join('')
                    })) : null;
                }
            });
        }
    }
    shouldComponentUpdate(nextProps, nextState) {
        return nextState.webHeight !== this.state.webHeight;
    }
    render() {
        const _that = this;
        return (
            <View style={this.props.style}>
                {
                    this.loading && !this.state.webHeight && <View style={styles.loadingBox}>
                        <Image source={require('FOUNDATION/Img/loading.gif')}/>
                    </View>
                }
                <WebView
                    {...this.props}
                    bounces={false}
                    ref={w => this.webview = w}
                    style={{
                        backgroundColor: Colors.background_white,
                        height: this.state.webHeight - 200
                    }}
                    onNavigationStateChange={n => {
                        // 监听页面高度变化
                        Number(n.title) ? (() => {
                            clearTimeout(this.timeout);
                            this.timeout = setTimeout(() => this.setState({
                                webHeight: Number(n.title) + 55
                            }));
                        })() : null;
                        this.props.onNavigationStateChange ? this.props.onNavigationStateChange(n) : null;
                    }}
                    /**
                    * @description
                    * 跳转到M站或者商品详情路由
                    */
                    onMessage = {
                        async function(d) {
                            _that.props.onMessage ? _that.props.onMessage(d) : null;
                            try {
                                // 跳转到商品详情路由
                                const {itemcode, isBone} = await REXP.isDetailUrl(d.nativeEvent.data);
                                const bone = isBone ? {
                                    isBone: '1'
                                } : {};
                                Actions.GoodsDetailMain({...{itemcode}, ...bone});
                            } catch (e) {
                                // 跳转到M站
                                e.err && e.err === "not detail url" ?
                                    Linking.openURL(e.d) : null;
                            }
                        }
                    }
                    // 小黑板HTML
                    source={{html: `
                        <!DOCTYPE html>
                        <html lang="zh-cn">
                            <head>
                                <meta name="viewport" content="width=device-width,initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
                                <style id="$$style$$" type="text/css"></style>
                                <style type="text/css">
                                    * {-webkit-touch-callout:none;-webkit-user-select:none;-khtml-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;}
                                    body, html {margin: 0; padding: 0; margin: 0 auto; overflow: hidden;}
                                    a, p {line-height: 1.5;}
                                    img, video {max-width: 100%; margin: 0; padding: 0;}
                                    #is-loading {display: "none";}
                                </style>
                            </head>
                            <body>
                                ${this.props.htmlInset}
                                <div id="$$is-loading$$">
                                    <?xml version="1.0" encoding="utf-8"?>
                                    <!-- Generator: Adobe Illustrator 16.0.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->
                                    <!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
                                    <svg version="1.1" id="图层_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                                         width="141.73px" height="141.73px" viewBox="0 0 141.73 141.73" enable-background="new 0 0 141.73 141.73" xml:space="preserve">
                                    <path fill-rule="evenodd" clip-rule="evenodd" fill="#FFFFFF" d="M139.116,129.423h-8.115c3.561-1.469,4.056-5.217,4.056-5.217
                                        V81.88c0.028-5.094-5.797-5.797-5.797-5.797H109.69l1.015-3.479h-8.697L96.79,86.519h9.857l0.844-2.898h17.129
                                        c1.364-0.322,2.32,0.58,2.32,0.58v4.639h-8.117l-10.437,30.729c-0.428,2.865-3.479,2.9-3.479,2.9l3.744,6.955h-8.729
                                        c2.357-1.771,3.825-6.955,3.825-6.955l11.596-33.629h-8.697l-11.597,33.049h-2.898v-14.496h6.377l-4.058-6.957h-2.319V86.519h2.319
                                        l2.318-7.537h-4.638v-6.377h-8.697v6.377h-1.741v-2.898h-7.536v10.436h-1.739l4.059,6.959c5.913,0.191,5.217-2.898,5.217-2.898
                                        v-4.061h1.162v13.916l-8.118,15.654h-1.739L66.64,69.125H39.962c2.834-1.6,3.486-5.797,3.486-5.797V43.034H67.8l-4.06-6.957H43.448
                                        v-6.958h-8.118v6.958H19.677v-1.16l4.141-11.596H66.06l-4.058-7.538H26.51l1.242-3.478H66.64l6.107,49.863h3.75
                                        c0,0,1.868,0.194,2.318-3.479l11.742-34.788H72.438L67.8,15.783h25.497l1.175-3.478h9.856l-1.225,3.478h26.735l4.059,8.118h-33.655
                                        l-3.268,9.276h27.065c0,0,5.22,0.355,5.22,6.378v24.352c0,0-0.927,5.218-5.799,5.218h10.437l6.958,55.082
                                        C141.705,129.648,139.116,129.423,139.116,129.423z M67.8,48.833l-8.118,2.319l-6.378-6.378v8.117l-7.538,3.479l8.117,2.899
                                        l1.16,8.117l5.218-6.377l8.696,1.739L63.74,55.79L67.8,48.833z M119.402,40.715H94.319l-7.966,22.613c0,0-0.202,4.261-5.219,5.797
                                        h26.672l-4.058-6.957h15.653c0,0,1.558,0.113,1.739-1.739V42.455C121.142,42.455,121.622,40.819,119.402,40.715z M6.341,15.783
                                        l4.059,7.538h3.878L9.24,36.657c0,0-1.897,6.377,5.218,6.377h20.873v17.395c0.051,1.518-1.159,1.739-1.159,1.739h-6.958l3.747,6.957
                                        H16.777c2.536-0.181,4.058-2.898,4.058-2.898l7.538-18.554h-9.277c0,0-2.425,5.412-4.059,9.857
                                        c-1.633,4.445-2.319,4.058-2.319,4.058h-4.06L2.862,17.523c-0.993-5.254,2.899-5.218,2.899-5.218h12.678l-1.314,3.478H6.341z
                                         M15.617,113.771V86.519h7.538v27.832c0,0,1.253,6.566,6.378,7.537h5.218l4.638,7.535H28.373c0,0-8.315-2.803-8.117-7.535
                                        c0,0-1.322,7.646-9.277,7.535H4.602l-4.059-6.955h9.856C10.399,122.468,15.299,120.611,15.617,113.771z M57.942,104.494v10.438
                                        c0,0-0.476,3.449-4.058,3.477H39.389c0,0-4.351-1.752-2.319-7.537l7.538-22.031h8.117l-8.117,22.031h5.798
                                        c0,0,0.609-0.174,0.579-1.158v-5.219H57.942z M59.683,120.728V85.939c0,0,0.685-2.482-1.74-2.318H44.994l-0.966,2.898h-9.277v27.252
                                        h-8.117v-30.73c0,0,0.464-2.998-2.319-2.898H12.719v33.629H4.602V72.605h23.771c0,0,6.257,0.383,6.378,6.377v4.445l4.058-10.822
                                        h9.857l-1.159,3.479h15.075c0,0,6.237,0.969,5.798,7.537v39.426c0,0,0.197,5.822-5.798,6.377H45.767l-4.639-7.535h17.975
                                        L59.683,120.728z M83.455,116.669v12.754h-8.697l-1.159-9.855l2.318,3.479C80.401,125.023,83.455,116.669,83.455,116.669z
                                         M92.152,129.423v-6.635l4.265,6.635H92.152z M111.401,129.423c2.434-1.357,3.363-4.637,3.363-4.637l12.176-32.654v28.596
                                        c0.285,1.234-1.161,1.74-1.161,1.74h-7.536l3.747,6.955H111.401z"/>
                                    </svg>
                                </div>
                                <script type="text/javascript">
                                    (function() {
                                        /*节流函数*/
                                        var timeoutHeight;
                                        /*改高度，需要函数节流，不然安卓下桥接太频繁会卡顿*/
                                        var changeHeight = function(fast) {
                                            clearTimeout(timeoutHeight);
                                            timeoutHeight = setTimeout(function() {
                                                if (document.title == document.body.clientHeight) return;
                                                document.title = document.body.clientHeight;
                                                location.hash="#$" + Math.random();
                                            }, 800);
                                        };
                                        /*获取a数组*/
                                        var aArray = Array.prototype.slice.call(document.querySelectorAll('a'));
                                        /*去除a标签的跳转功能*/
                                        aArray.forEach(function(ele){
                                            ele.addEventListener('click', function(e) {
                                                e.preventDefault();
                                                /**跳转到M站*/
                                                window.postMessage(e.target.href);
                                            });
                                        });
                                        /*监听加载完毕调整UI高度*/
                                        window.document.addEventListener('message', function (e) {
                                            const data = JSON.parse(e.data);
                                            /*监听css加载完毕，异步存入远程css库*/
                                            if (data && data.type === 'appendStyle') {
                                                document.getElementById('$$style$$').appendChild(document.createTextNode(data.style));
                                                changeHeight();
                                            }
                                        });
                                        /*回调*/
                                        var listenCallBack = function() {
                                            document.removeEventListener('DOMContentLoaded', listenCallBack);
                                            /*获取img数组*/
                                            var imgArray = Array.prototype.slice.call(document.querySelectorAll('img'));
                                            /*获取图片数量*/
                                            var imgLength = imgArray.length;
                                            /*最多加载时间, 加载不完的图片用默认图片代替*/
                                            var time = ${this.props.loadingTime};
                                            /*记时间超过规定时间则放弃加载*/
                                            var each = function(imgArray) {
                                                imgArray.forEach(function(e, index) {
                                                    /*没加载完*/
                                                    if(!e.complete) {
                                                        var loadingFlag = !e.width && !e.height;
                                                        loadingFlag ? e.id = "$$" + index + "$$" : null;
                                                        /*获取图片样式*/
                                                        var width = e.width || "100%";
                                                        var height = e.height || 200;
                                                        /*创建加载图片*/
                                                        var div = document.createElement("div");
                                                        div.style.display = "flex";
                                                        div.style.justifyContent = "center";
                                                        div.style.alignItems = "center";
                                                        div.style.width = width + "px";
                                                        div.style.height = height + "px";
                                                        div.style.backgroundColor = "#dddddd";
                                                        div.style.overflow = "hidden";
                                                        div.innerHTML = document.getElementById("$$is-loading$$").innerHTML;
                                                        /*没加载完直接隐藏*/
                                                        e.style.display = "none";
                                                        /*元素往后增加一个*/
                                                        e.parentNode.insertBefore(div, e);
                                                        (function(e, div, loadingFlag) {
                                                            e.onload = e.onerror = onabort = function () {
                                                                e.style.display = "block";
                                                                div.style.display = "none";
                                                                loadingFlag ? changeHeight() : null;
                                                            };
                                                        })(e, div, loadingFlag);
                                                    } else {
                                                        /*加载完毕*/
                                                        /*获取图片样式*/
                                                        if (e.width > ${Dimensions.get('window').width}) {
                                                            var width = e.width;
                                                            var height = e.height;
                                                            /*创建加载图片*/
                                                            var div = document.createElement("div");
                                                            div.style.width = "100%";
                                                            div.style.height = height * (Number(${Dimensions.get('window').width}) / width) + "px";
                                                            div.style.backgroundColor = "#dddddd";
                                                            /*没加载完直接隐藏*/
                                                            e.style.display="none";
                                                            /*元素往后增加一个*/
                                                            e.parentNode.insertBefore(div, e);
                                                            changeHeight();
                                                            e.style.display = "block";
                                                            div.style.display = "none";
                                                        }
                                                    };
                                                });
                                            };
                                            if (time !== 0) {
                                                setTimeout(function() {
                                                   each(imgArray);
                                                }, time);
                                            } else {
                                                /*显示出所有图片*/
                                                document.title = document.body.clientHeight;
                                                location.hash="#$" + Math.random();
                                                each(imgArray);
                                            }
                                            /*监听触摸改变高度*/
                                            document.addEventListener("touchstart", changeHeight.bind(this));
                                        };
                                        /*监听webview桥接连接成功*/
                                        document.addEventListener('DOMContentLoaded', listenCallBack);
                                    })();
                                </script>
                            </body>
                        </html>`
                    }}
                />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    loadingBox: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        height: 200,
        backgroundColor: 'white'
    }
});
