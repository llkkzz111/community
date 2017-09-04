/**
 * Created by MASTERMIAO on 2017/6/18.
 * 商城店铺首航组件
 */
'use strict';

import React from 'react';

import {
    View,
    TouchableOpacity,
    Text,
    StyleSheet
} from 'react-native';

import Colors from '../../app/config/colors';

import * as ScreenUtils from '../utils/ScreenUtil';

export default class StoreTitleModule extends React.PureComponent {
    constructor() {
        super();
        this.state = {
            selectedTabIndex: 0
        }
        this._selectedIndex = this._selectedIndex.bind(this);
    }

    render() {
        return (
            <View style={styles.titleBgStyle}>
                <View style={styles.tabContainer}>
                    {['店铺首页', '全部宝贝', '新品上架'].map((item, index)=> {
                        return (
                            <View key={index} style={styles.tabItemContainer}>
                                <TouchableOpacity activeOpacity={1} style={this.state.selectedTabIndex == index ? styles.tabItemInner : styles.tabItem} onPress={() => {this._selectedIndex(index)}}>
                                    <Text allowFontScaling={false} style={this.state.selectedTabIndex == index ? styles.tabTitleSelectedStyle : styles.tabTitleNormalStyle}>{item}</Text>
                                </TouchableOpacity>
                            </View>
                        );
                    })}
                </View>
                {this.props.children[this.state.selectedTabIndex]}
            </View>
        )
    }

    _selectedIndex(index) {
        this.setState({selectedTabIndex: index});
    }
}

const styles = StyleSheet.create({
    titleBgStyle: {
        flexDirection: 'column',
        flex: 1
    },
    tabContainer: {
        backgroundColor: Colors.text_white,
        height: ScreenUtils.scaleSize(88),
        width: ScreenUtils.screenW,
        flexDirection: 'row'
    },
    tabItemContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        alignSelf: 'stretch'
    },
    tabItemInner: {
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center',
        borderBottomWidth: ScreenUtils.scaleSize(2),
        borderBottomColor: Colors.main_color
    },
    tabItem: {
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center'
    },
    tabTitleNormalStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(28),
        fontWeight: 'bold'
    },
    tabTitleSelectedStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(28)
    }
});
