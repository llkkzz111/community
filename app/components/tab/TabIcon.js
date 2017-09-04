/**
 * updated by Wjj on 2017/5/13.
 * add a page description
 * 首屏tab控件
 */
'use strict';

import React, { PureComponent } from 'react';
import {
    View,
    StyleSheet,
    Text,
    Image,
    Dimensions,
    DeviceEventEmitter,
    Animated,
    Easing,
} from 'react-native';

const { width, height } = Dimensions.get('window');
import Fonts from 'CONFIG/fonts';
import Colors from 'CONFIG/colors';
import * as ScreenUtils from 'FOUNDATION/utils/ScreenUtil';
const tabImgW = ScreenUtils.scaleSize(60);


const propTypes = {
    selected: React.PropTypes.bool,
    title: React.PropTypes.string,
    iconName: React.PropTypes.string,
};

let onTabIcons = {};
let ishuojian = false;

const unTabIcons =
    {
        '首页': require('IMG/icons/Icon_House_Normal_.png'),
        '分类': require('IMG/icons/Icon_Category_Normal_.png'),
        '购物车': require('IMG/icons/Icon_Cart_Normal_.png'),
        '我的': require('IMG/icons/Icon_Personal_Normal_.png'),
        '看直播': require('IMG/icons/Icon_ZhiBo_Normal_.png')
    };

class TabIcon extends PureComponent {
    constructor() {
        super();
        this.state = {
            // ishuojian: false,
            ishuojian: ishuojian,
            rotateZAnimation: new Animated.Value(0), // 旋转的动画
        }
        this.intervalCount = 0;

    }
    componentDidMount() {
        DeviceEventEmitter.addListener('huojian', (is) => {
            this.setState({
                ishuojian: is
            });
        })

        this.interval = setInterval(() => this.startRotate(), 4000)
    }

    startRotate () {
        this.intervalCount += 1;
        Animated.parallel([
            Animated.timing(this.state.rotateZAnimation,{
                toValue: this.intervalCount,
                duration: 2000,
                easing: Easing.linear
            })
        ]).start();
        /**
        * @TODO
        * 之后优化灭掉DeviceEventEmitter，用redux代替
        **/
        DeviceEventEmitter.addListener('huojian', is => this.setState({ishuojian: is}));
    }
    componentDidUpdate() {
        ishuojian = this.state.ishuojian;
    }
    render() {
        onTabIcons = {
            '首页': this.state.ishuojian ? require('IMG/home/icon_huojian.png')
                : require('IMG/icons/Icon_Home_Active_.png'),
            '分类': require('IMG/icons/Icon_Category_Active_.png'),
            '购物车': require('IMG/icons/Icon_Cart_Active_.png'),
            '我的': require('IMG/icons/Icon_Personal_Active_.png'),
            '看直播': require('IMG/icons/Icon_ZhiBo_Active_.png')
        };
        return (
            <View style={styles.cont}>
                {
                    this.props.selected ?
                        <Image style={styles.tabImg}
                               source={onTabIcons[this.props.title]}/> :
                        <Image style={styles.tabImg}
                               source={unTabIcons[this.props.title]}/>
                }
                {
                    this.props.title === '看直播' ?
                        <Animated.Image source={require('../../../foundation/Img/icons/tab_bar_icon_big_star.png')}
                               style={[styles.starImg, {transform:
                               [{rotateZ: this.state.rotateZAnimation.interpolate({inputRange:[0,1], outputRange:['0deg','720deg']})}]}]}/>
                        :
                        null
                }
                {
                    this.props.title === '看直播' ?
                        <Animated.Image source={require('../../../foundation/Img/icons/tab_bar_little_star.png')}
                                        style={[styles.littleStarImg, {transform:
                               [{rotateZ: this.state.rotateZAnimation.interpolate({inputRange:[0,1], outputRange:['0deg','720deg']})}]}]}/>
                        :
                        null
                }

                {
                    this.state.ishuojian && this.props.title === '首页' && this.props.selected ?
                        null
                        :
                        <Text allowFontScaling={false}
                              style={[styles.text, {color: this.props.selected ? '#E5290D' : 'gray'}]}>
                            {this.props.title}
                        </Text>
                }
            </View>
        );
    }

}

TabIcon.propTypes = propTypes;

let styles = StyleSheet.create({
    cont: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        width: width / 5,
        height: ScreenUtils.scaleSize(49),
        borderTopColor: Colors.line_grey,
        borderTopWidth: ScreenUtils.scaleSize(1),
    },
    tabImg: {
        position: 'relative',
        //width: tabImgW,
        //height: tabImgW,
        resizeMode: 'contain',
    },
    text: {
        fontSize: Fonts.tag_font(),
    },
    starImg: {
        position: 'absolute',
        width: ScreenUtils.scaleSize(12),
        height: ScreenUtils.scaleSize(12),
        top: ScreenUtils.scaleSize(10),
        // left: width / 5 / 2 + ScreenUtils.scaleSize(60) / 2 - ScreenUtils.scaleSize(5)
        left: width / 5 / 2 + tabImgW / 2 - ScreenUtils.scaleSize(5)
    },
    littleStarImg: {
        position: 'absolute',
        width: ScreenUtils.scaleSize(8),
        height: ScreenUtils.scaleSize(8),
        top: ScreenUtils.scaleSize(25),
        left: width / 5 / 2 + tabImgW / 2 - ScreenUtils.scaleSize(5)
    }
});
export default TabIcon;
