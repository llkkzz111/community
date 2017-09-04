/**
* @file 图文列表item
* @author 魏毅
* @version 0.0.2
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
"use strict";
import React, { Component } from 'react';
import { Text, View, StyleSheet } from 'react-native';
import * as ScreenUtils from 'UTILS/ScreenUtil';
import Colors from 'CONFIG/colors';
import pressStorage from 'FOUNDATION/PressStorage';
import ImgComponent from 'FOUNDATION/imgComponent';
import { SmallBlackBoardItem as styles } from '../style';

/**
* @description
* 图文列表
*/
@pressStorage({
    name: 'smallblackboard'
})
export class ReaderList extends Component {
    constructor(props){
    	super(props);
    	this.state = {
            select: this.props.filter()
        };
    }
    componentWillReceiveProps(nextProps) {
        nextProps.filter ? this.setState({
            select: nextProps.filter()
        }) : null;
    }
    shouldComponentUpdate(newProps, newState) {
        return newState.select !== this.state.select;
    }
    render() {
        const { item } = this.props;
        return (
            <View style={styles.rowstyle}>
                <View style={styles.outImgStyle}>
                    {
                        item.firstImgUrl ?
                            (
                                <ImgComponent
                                    style={styles.outImgStyle}
                                    source={{uri: item.firstImgUrl}} />
                            ) : null
                    }
                </View>
                <View style={styles.textViewStyle}>
                    <Text allowFontScaling={false} numberOfLines={2} style={[styles.text, {
                        color: this.state.select ? Colors.text_light_grey : Colors.text_black
                    }]}>{item.title}</Text>
                    <Text allowFontScaling={false} style={styles.watchNumber}>阅读 {item.watchNumber}</Text>
                </View>
            </View>
        );
    }
}
