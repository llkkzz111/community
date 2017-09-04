/**
 * Created by MASTERMIAO on 2017/5/5.
 * 购物车赠品栏组件
 */
'use strict';

import React, {Component} from "react";

import {Animated, ART, Dimensions, Image, StyleSheet, Text, TouchableOpacity, View} from "react-native";
import GiftMenuItem from "./GiftMenuItem";
import * as ScreenUtils from "../../foundation/utils/ScreenUtil";
import Immutable from 'immutable'
const {width} = Dimensions.get('window');

var path;
//自适应
const {Surface, Shape, Path} = ART;
let isLayout = true;
export default class GiftMenu extends Component {
    constructor(props) {
        super(props);
        this.icons = {
            'down': require('../Img/cart/gift_menu.png'),
            'up': require('../Img/cart/gift_menu_up.png')
        };
        this.state = {
            animation: new Animated.Value(0),
            selfAnimation: new Animated.ValueXY(),
            explainNote: this.props.explainNote,
            gifts: this.props.gifts,
            canCollapse: false,
            expanded: false,
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            explainNote: nextProps.explainNote,
            gifts: nextProps.gifts,
        });
    }

    shouldComponentUpdate(nextProps, nextState) {
        return (this.props.cartType !== nextProps.cartType)
            || !(Immutable.is(this.props.gifts, nextProps.gifts))
            || !(this.props.explainNote !== nextProps.explainNote);
    }

    //str:传入的展示内容字符串，size:字体的大小；
    getStrLength(str, size) {
        let realLength = 0, len = str.length, charCode = -1;
        for (let i = 0; i < len; i++) {
            charCode = str.charCodeAt(i);
            if (charCode >= 0 && charCode <= 128)
                realLength += 1;
            else
                realLength += 2;
        }
        return realLength * ScreenUtils.scaleSize(size);
    };

    componentWillMount() {
        path = ART.Path();
        path.moveTo(0, 5);
        path.lineTo(30, 5);
        path.lineTo(35, 0);
        path.lineTo(40, 5);
        path.lineTo(width, 5);
        path.close();
    }

    _renderDelta = () => {
        return (
            <ART.Surface width={width} height={5}>
                <ART.Shape d={path} fill="#FFF1F4"/>
            </ART.Surface>
        )
    }

    //渲染随箱赠品信息
    renderGiftInfo() {
        return (
            <TouchableOpacity
                activeOpacity={1}
                style={styles.viewContainers}
                onPress={() => {
                    //展开收起
                    this.setState({
                        expanded: !this.state.expanded
                    });
                }}>
                {/*随箱赠品信息*/}
                <View style={styles.giftTitleBg}>
                    <Text
                        numberOfLines={this.state.expanded ? 0 : 2}
                        style={styles.giftStyle}
                        allowFontScaling={false}
                        onLayout={({nativeEvent: e}) => {
                            //行数计算
                            try {
                                let str = this.state.explainNote || "";
                                if (str.split('\n').length > 2) {
                                    this.setState({canCollapse: true});
                                    return;
                                }
                                if (this.getStrLength(str, 44) > (e.layout.width * 4 - ScreenUtils.scaleSize(12))) {
                                    this.setState({canCollapse: true});
                                }
                            } catch (e) {
                            }
                        }}>{this.state.explainNote}</Text>
                </View>
                {//收起展开
                    this.state.canCollapse ?
                        <View style={styles.giftBg}>
                            <Text
                                style={styles.giftDescStyle}
                                allowFontScaling={false}>{this.state.expanded ? '收起' : '展开'}</Text>
                            <Image style={styles.actionImg}
                                   source={this.state.expanded ? require('../Img/cart/gift_menu_up.png') : require('../Img/cart/gift_menu.png')}/>
                        </View> : null
                }
            </TouchableOpacity>
        );
    }

    render() {
        const path = Path()
            .moveTo(1, 1)
            .lineTo(width, 1);
        return (
            <View>
                {//小三角
                    this.state.explainNote || (this.state.gifts && Array.isArray(this.state.gifts) && this.state.gifts.length > 0) ?
                        <View style={styles.deltaStyle}>
                            {this._renderDelta()}
                        </View> : null
                }
                {//随箱赠品
                    this.state.explainNote ? this.renderGiftInfo() : null
                }
                {//非随箱赠品
                    (this.state.gifts && Array.isArray(this.state.gifts) && this.state.gifts.length > 0) ?
                        <View>
                            {/*虚线*/}
                            <Surface width={width - ScreenUtils.scaleSize(120)} height={1}>
                                <Shape d={path} stroke="#DDDDDD" strokeWidth={2} strokeDash={[3, 9]}/>
                            </Surface>
                            <GiftMenuItem
                                explainNote={this.state.explainNote}
                                gifts={this.state.gifts}
                                itemQty={this.props.itemQty}
                                changeGiftItem={(data) => this.props.changeGiftItem(data)}
                            />
                        </View> : null
                }
            </View>
        );
    }
}

const styles = StyleSheet.create({
    deltaStyle: {
        marginTop: -ScreenUtils.scaleSize(10),
    },
    viewContainers: {
        flex: 1,
        minHeight: ScreenUtils.setSpText(80),
        padding: ScreenUtils.scaleSize(10),
        justifyContent: 'center',
        flexDirection: 'row',
        backgroundColor: '#FFF1F4'
    },
    giftStyle: {
        fontSize: ScreenUtils.setSpText(22),
        color: '#333333',
    },
    giftDescStyle: {
        fontSize: ScreenUtils.setSpText(22),
        color: '#666666',
        marginHorizontal: ScreenUtils.scaleSize(10),
    },
    actionImg: {
        width: ScreenUtils.scaleSize(34),
        height: ScreenUtils.scaleSize(14),
        resizeMode: "contain",
        marginRight: ScreenUtils.scaleSize(18),
        marginTop: ScreenUtils.scaleSize(6),
    },
    giftTitleBg: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: ScreenUtils.scaleSize(10),
        marginLeft: ScreenUtils.scaleSize(10),
        marginBottom: ScreenUtils.scaleSize(10),
    },
    giftBg: {
        width: ScreenUtils.scaleSize(120),
        marginTop: ScreenUtils.scaleSize(18),
        alignItems: 'flex-start',
        justifyContent: 'center',
        flexDirection: 'row'
    },
});

GiftMenu.propTypes = {}
