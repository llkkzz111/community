/**
* @file 小黑板详情(木偶组件)
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import React, { Component } from 'react';
import {
    Text,
    View,
    Image,
    ScrollView,
    FlatList,
    TouchableWithoutFeedback,
    TouchableOpacity,
    StatusBar,
    Platform
} from 'react-native';
import { Actions }from 'react-native-router-flux';
import NavigationBar from 'COMMON/NavigationBar';
import PureWebView from 'FOUNDATION/WebView';
import layouts from '../layouts';
import { SmallBlackBoardDetails as styles } from '../style';

/**
* @classdesc
* 小黑板详情(木偶组件)
*/
export default class SmallBlackBoardDetailsContent extends Component {
    shouldComponentUpdate() {
        // 这个组件不去更新，只做首次渲染
        return false;
    }
    /**
    *渲染图文
    **/
    _renderPicText(item) {
        return (
            <View style={styles.articleBox}>
                <View style={styles.articleTitle}>
                    <Text allowFontScaling={false} style={styles.titleStyle}>{ item.title }</Text>
                    <View style={styles.countContent}>
                        <Text allowFontScaling={false} style={styles.publishTime}>{ item.publishTime }</Text>
                        <Text allowFontScaling={false} style={styles.labelName}>{ `${item.watchNumber}` ? '阅读' : '' }</Text>
                        <Text allowFontScaling={false} style={styles.watchNumber}>{ item.watchNumber }</Text>
                    </View>
                </View>
                <View style={styles.contentValueBox}>
                    {
                        item.contentValue && (
                            <View>
                                <PureWebView.WebViewAutoHeight
                                    cssModules={[
                                        'https://cdn.bootcss.com/normalize/7.0.0/normalize.min.css',
                                        'https://cdn.bootcss.com/quill/1.3.1/quill.snow.min.css',
                                        'https://cdn.bootcss.com/quill/1.3.1/quill.bubble.min.css'
                                    ]}
                                    scrollEnabled={false}
                                    startInLoadingState={false}
                                    javaScriptEnabled={true}
                                    domStorageEnabled={true}
                                    scalesPageToFit={true}
                                    automaticallyAdjustContentInsets={true}
                                    loadingTime={0}
                                    htmlInset={ item.contentValue }
                                />
                                {
                                    `${item.articleType}` === '2' && item.destinationUrl &&
                                        (
                                            <View style={styles.officialWebsiteBox}>
                                                <TouchableOpacity
                                                    activeOpacity={1} 
                                                    style={styles.officialWebsite}
                                                    onPress={()=> {
                                                        Actions.OrderWebView({webUrl: item.destinationUrl});
                                                    }}
                                                >
                                                    <Text allowFontScaling={false} style={styles.officialWebsiteText}>进入企业官网</Text>
                                                </TouchableOpacity>
                                            </View>
                                        )
                                }
                            </View>
                        )
                    }
                    {/**@description 更多内容*/}
                    <TouchableWithoutFeedback onPress={() => Actions.SmallBlackBoard()}>
                        <View style={styles.bottomBox}>
                            <View style={styles.angularBox}>
                                <Text allowFontScaling={false} style={styles.angular}>
                                    ▽
                                    <Text allowFontScaling={false} style={styles.moreTitle}>
                                        点击阅读更多精彩内容
                                    </Text>
                                </Text>
                            </View>
                            <Text allowFontScaling={false} style={styles.more}>
                                更多文章
                            </Text>
                        </View>
                    </TouchableWithoutFeedback>
                </View>
            </View>
        )
    }
    _renderProductList(goodsList, productLink) {
        return (
            <View>
                {/*相关商品推荐*/}
                <View style={styles.goodsList}>
                    <View style={styles.titleView}>
                        <Text allowFontScaling={false} style={styles.titleTextStyle}>· 相关商品推荐 ·</Text>
                    </View>
                </View>
                <FlatList
                    data={ goodsList }
                    numColumns={1}
                    keyExtractor={d => d.contentCode}
                    renderItem={({item}) => (
                            <layouts.ItemPhotoPrice
                                item={ item }
                                itemKey={ item.contentCode }
                                onPress={ productLink.bind(this, item) }
                            />
                        )
                    }
                />
            </View>
        );
    }
    render() {
        const { graphic, goodsList, share, productLink } = this.props;
        return (
            <View style={styles.box}>
                <StatusBar barStyle="light-content"/>
                {/*板书详情title*/}
                <NavigationBar
                    renderTitle={() => {
                        return (
                            <View style={styles.titleBox}>
                                <Image
                                    source={require('IMG/smallblackboard/Icon_smallblackboard_bg_@2x.png')}
                                    style={styles.navBgStyle}
                                />
                                <Image style={styles.titleText} source={require('IMG/smallblackboard/title_@2x.png')}/>
                            </View>
                        );
                    }}
                    leftButton = {require('IMG/icons/Icon_back_white_@2x.png')}
                    rightButton = {require('IMG/header/icon_share_.png')}
                    onRightPress = { share.bind(this, graphic) }
                    barStyle = {'light-content'}
                    navigationStyle = {{...Platform.select({ios: {marginTop: -22}})}}
                />
                {/*板书详情content*/}
                <ScrollView style={styles.container}>
                    {/*文章*/}
                    { graphic && this._renderPicText(graphic) }
                    { goodsList && goodsList.length > 0 && this._renderProductList(goodsList, productLink) }
                </ScrollView>
            </View>
        )
    }
}
