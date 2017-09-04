/**
 * updated by xian on 2017/5/31.
 * add a page description
 * 品牌团tab控件
 */
'use strict'

import React, {
    PropTypes,
} from 'react';
import {
    View,
    StyleSheet,
    Text,
    Platform,
    Image
} from 'react-native';
import Fonts from '../../config/fonts';

var styles = StyleSheet.create({
    container: {
        backgroundColor: 'transparent',
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center'
    },
    text: {
        fontSize: Fonts.tag_font(),
    }
})

const propTypes = {
    selected: PropTypes.bool,
    title: PropTypes.string,
    iconName: PropTypes.string,
};

const onTabIcons =
    {
        '首页': require('../../../foundation/Img/icons/icon_home_active_@2x.png'),
        '分类': require('../../../foundation/Img/icons/icon_catalogue_active_@2x.png'),
        '购物车': require('../../../foundation/Img/icons/icon_cart_active_@2x.png')
    };

const unTabIcons =
    {
        '首页': require('../../../foundation/Img/icons/icon_home_normal_@2x.png'),
        '分类': require('../../../foundation/Img/icons/icon_catalogue_normal_@2x.png'),
        '购物车': require('../../../foundation/Img/icons/icon_cart_normal_@2x.png')
    };

const TabBrandIcon = (props) => (
    <View style={styles.container}>
        {
            props.selected ?
                <Image style={{width: 25, height: 25, resizeMode: 'stretch'}} source={onTabIcons[props.title]}/> :
                <Image style={{width: 25, height: 25, resizeMode: 'stretch'}} source={unTabIcons[props.title]}/>
        }
        <Text allowFontScaling={false}
            style={[styles.text, {color: props.selected ? '#E5290D' : 'gray'}]}>
            {props.title}
        </Text>
    </View>
);

TabBrandIcon.propTypes = propTypes;

export default TabBrandIcon;