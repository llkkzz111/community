/**
* @file 小黑板page
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
    TouchableOpacity,
    Platform,
    TouchableNativeFeedback
} from 'react-native';
import { Actions } from 'react-native-router-flux';
import ScrollableTabView, {ScrollableTabBar} from 'react-native-scrollable-tab-view';
import Colors from 'CONFIG/colors';
import Page from 'FOUNDATION/Page';
import * as ScreenUtils from 'FOUNDATION/utils/ScreenUtil';
import NavigationBar from 'FOUNDATION/common/NavigationBar';
import AdFloatingLayer from 'COMPONENTS/AdFloatinglayer';
import layouts from '../layouts';
import { SmallBlackBoard as styles } from '../style';

// Tab按钮
const Button = props => Platform.select({
    android: (
        <TouchableNativeFeedback
            delayPressIn={0}
            {...props}
        >
            {props.children}
        </TouchableNativeFeedback>
    ),
    ios: (
        <TouchableOpacity {...props}>
            {props.children}
        </TouchableOpacity>
    )
});

export default class SmallBlackBoardContent extends Component {
    static defaultProps = {
        tabList: [],
        showAd: false,
        showCircle: false
    };
    shouldComponentUpdate(nextProps) {
        // 组件只会更新一次,获取数据后就不会更新了
        return this.props.tabList.length === 0
            || nextProps.showAd !== this.props.showAd
            || nextProps.showCircle !== this.props.showCircle;
    }
    render() {
        return (
            <View style={styles.box}>
                {/**头部组件*/}
                <NavigationBar
                    leftButton={require('IMG/icons/Icon_back_white_.png')}
                    onLeftPress={() => Actions.Home()}
                    renderTitle={() => (
                        <View style={styles.titleBox}>
                            <Image style={styles.navBgStyle} source={require('IMG/smallblackboard/Icon_smallblackboard_bg_.png')}/>
                            <Image style={styles.titleText} source={require('IMG/smallblackboard/title_.png')}/>
                        </View>
                    )}
                    barStyle={'light-content'}
                    navigationStyle={{...Platform.select({ios: {marginTop: -22}})}}
                />
                {/**滚动条组件*/}
                <ScrollableTabView
                    style={styles.scrollableTabViewStyle}
                    renderTabBar={data => <ScrollableTabBar renderTab={(name, page, isTabActive, onPressHandler, onLayoutHandler) => {
                        const textColor = isTabActive ? '#E5290D' : 'black';
                        const fontWeight = isTabActive ? 'bold' : 'normal';
                        return (
                            <Button
                                key={name}
                                accessible={true}
                                accessibilityLabel={name}
                                accessibilityTraits='button'
                                onPress={() => onPressHandler(page)}
                                onLayout={onLayoutHandler}
                            >
                                <View style={styles.tab}>
                                    <Text style={[{color: textColor, fontWeight } ]} allowFontScaling={false}>
                                        {name}
                                    </Text>
                                </View>
                            </Button>
                        );
                    }}/>}
                    tabBarActiveTextColor='#E5290D'
                    tabBarUnderlineStyle={styles.tabBarUnderLine}
                    onChangeTab={(obj) => this.props.onClickTitle(obj)}
                >
                    {
                        /*渲染tab*/
                        this.props.tabList.map(tab =>
                            !tab.title || !tab.codeValue ? (<View key={Math.random()}/>) : (
                                <Page.ScrollPage
                                    key={tab.codeValue}
                                    keyExtractor={(item, index) => item.contentCode || index}
                                    namespace={tab.title != null ? tab.title : ''}
                                    bounces={false}
                                    onEndReachedDefault={true}
                                    tabLabel={tab.title != null ? tab.title : ''}
                                    style={{flex: 1, width: ScreenUtils.screenW}}
                                    change={::this.props.addPage}
                                    getRedux={
                                        (addData, changeData) =>
                                            this.props.getRedux(tab.title, addData, changeData)
                                    }
                                    getItemLayout={(item, index) => {
                                        return {
                                            length: ScreenUtils.scaleSize(212),
                                            offset: ScreenUtils.scaleSize(212) * index,
                                            index
                                        }
                                    }}
                                    renderItem={
                                        ({item}) => (
                                            <layouts.ReaderList
                                                item={item}
                                                itemKey={item.contentCode}
                                                onPress={this.props.jumpDetails.bind(this, item)}
                                            />
                                        )
                                    }
                                />
                            )
                        )
                    }
                </ScrollableTabView>
                {/*活动浮层页面*/}
                {
                    this.props.AdFloatingLayerData && this.props.AdFloatingLayerData.open_state === 'Y' &&
                        <AdFloatingLayer style={{flex: 1}}
                            showAd={this.props.showAd}
                            showCircle={this.props.showCircle}
                            icon={this.props.AdFloatingLayerData.firstImgUrl}
                            title={this.props.AdFloatingLayerData.msg}
                            image={this.props.AdFloatingLayerData.secondImgUrl}
                            onShow={::this.props.getAdResultData}
                            onClose={::this.props.closeAdFloatingLayer}/>
                }
            </View>
        )
    }
}
