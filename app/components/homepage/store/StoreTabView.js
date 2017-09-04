/**
 * Created by YASIN on 2017/6/8.
 * 店铺列表tabview
 */
'use strict';

import React from 'react';

import {
    View,
    StyleSheet,
    Text,
    TouchableOpacity
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

export default class StoreTabView extends React.PureComponent {
    static defaultProps = {
        tabs: [
            {
                name: '时尚大牌'
            },
            {
                name: '优品推荐'
            }
        ],
        selectedIndex: 0
    }
    static propTypes = {
        ...View.propTypes,
        tabs: React.PropTypes.array,
        selectedIndex: React.PropTypes.number,
        onTabClick: React.PropTypes.func
    }

    render() {
        return (
            <View style={[styles.tabContainer, this.props.style]}>
                {this.props.tabs.map((item, index)=> {
                    let tabTextStyle = index === this.props.selectedIndex ? styles.tabText : styles.tabNormalStyle;
                    let tabLine = index === this.props.selectedIndex ? (<View style={styles.tabLineStyle}/>) : null;
                    return (
                        <TouchableOpacity
                            key={index}
                            style={styles.tabItemContainer}
                            onPress={()=> {
                                this.props.onTabClick(index);
                            }}
                            activeOpacity={1}
                        >
                            <View style={styles.tabTextContainer}>
                                <Text allowFontScaling={false} style={tabTextStyle}>{item.name}</Text>
                                {tabLine}
                            </View>
                        </TouchableOpacity>
                    );
                })}
            </View>
        );
    }
}
const styles = StyleSheet.create({
    tabContainer: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(80),
        alignItems: 'center',
        backgroundColor: Colors.text_white,
        flexDirection: 'row',
    },
    tabItemContainer: {
        flex: 1,
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center'
    },
    tabTextContainer: {
        alignItems: 'center',
        justifyContent: 'center',
        height: ScreenUtils.scaleSize(80),
    },
    tabText: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(28),
    },
    tabNormalStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(28),
    },
    tabLineStyle: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        height: ScreenUtils.scaleSize(3),
        backgroundColor: Colors.main_color,
        marginHorizontal: ScreenUtils.scaleSize(5),
    }
});