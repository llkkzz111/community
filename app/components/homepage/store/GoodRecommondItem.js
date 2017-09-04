/**
 * Created by YASIN on 2017/6/2.
 * 好货推荐itemview
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    Text,
    TouchableOpacity,
    StyleSheet,
    Platform
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import * as IsEmptyUtil from '../../../../foundation/utils/IsEmptyUtil';

import {Actions} from 'react-native-router-flux';

import Toast, {DURATION} from 'react-native-easy-toast';

import {DataAnalyticsModule} from '../../../config/AndroidModules';

export default class GoodRecommondItem extends React.PureComponent {
    static propTypes = {
        ...View.propTypes.style,
        datas: React.PropTypes.array,
        icon: Image.propTypes.source,
        price: React.PropTypes.string,
        oldPrice: React.PropTypes.string,
        sellCount: React.PropTypes.string,
        title: React.PropTypes.string,
        titleIcon: React.PropTypes.string,
        sellDesc: React.PropTypes.string,
        integral: React.PropTypes.string,
        gifts: React.PropTypes.bool,
        isStore: React.PropTypes.bool,
        itemCode: React.PropTypes.string,
        isMasterRecommond: React.PropTypes.any,
        selfCodeValue: React.PropTypes.string,
        pageVersionName: React.PropTypes.string,
        codeValue: React.PropTypes.string,
    }

    render() {
        let titleIcon = this._showTitleIcon();
        let {isStore, isMasterRecommond, itemCode} = this.props;
        return (
            <View style={[isStore ? styles.container2 : styles.container, this.props.style]}>
                <View>
                    <TouchableOpacity activeOpacity={1} onPress={() => {
                        if (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(itemCode)) {
                            DataAnalyticsModule.trackEvent3(this.props.selfCodeValue, "", {
                                'pID': this.props.codeValue,
                                'vID': this.props.pageVersionName
                            });
                            Actions.GoodsDetailMain({itemcode: itemCode});
                        }
                    }}>
                        <Image
                            style={styles.itemIcon}
                            source={this.props.icon}
                        />
                    </TouchableOpacity>
                    <Text allowFontScaling={false} style={styles.titleStyle} numberOfLines={2}>
                        {parseInt(isMasterRecommond) === 1 && titleIcon}
                        <Text allowFontScaling={false}> {this.props.title}</Text>
                    </Text>
                </View>
                <View style={styles.bottomStyle}>
                    <View style={styles.priceContainer}>
                        <View style={styles.priceInner}>
                            <Text allowFontScaling={false} style={styles.priceTyle}>¥
                                <Text allowFontScaling={false}
                                      style={styles.price}>{(IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(this.props.price)) ? String(this.props.price) : ''}</Text>
                            </Text>
                            {(this.props.integral && parseFloat(this.props.integral) !== 0) ? (
                                <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                    <Image
                                        source={require('../../../../foundation/Img/home/hotsale/Icon_accumulate_.png')}
                                        style={styles.accumImg} resizeMode={'stretch'}/>
                                    <Text allowFontScaling={false}
                                          style={styles.integralDescStyle}>{(IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(this.props.integral)) ? String(this.props.integral) : ''}</Text>
                                </View>
                            ) : null}
                        </View>
                        {this.props.gifts ? (
                            <View style={styles.giftContainerStyle}>
                                <Text allowFontScaling={false} style={styles.giftStyle}>赠品</Text>
                            </View>
                        ) : null}
                    </View>
                    <Text allowFontScaling={false}
                          style={isStore ? styles.sellDescStyle2 : styles.sellDescStyle}>{String(parseFloat(this.props.sellDesc)) === 'NaN' ? this.props.sellDesc : ''}</Text>
                </View>
                <Toast ref="toast" position='center'/>
            </View>
        );
    }

    /**
     * title前面的icon
     * @private
     */
    _showTitleIcon() {
        let icon = null;
        let titleIcon = this.props.titleIcon;
        icon = (
            <Image
                source={require('../../../../foundation/Img/home/hotsale/Icon_anchorrecommend_tag_@3x.png')}
                style={styles.indicatorStyle_anchorrecommend}
                resizeMode={'stretch'}
            />
        );
        return icon;
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW / 2,
        height: ScreenUtils.scaleSize(555),
        alignItems: 'center',
        borderRightWidth: StyleSheet.hairlineWidth,
        borderRightColor: Colors.background_grey,
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: Colors.background_grey,
        justifyContent: 'space-between',
        padding: ScreenUtils.scaleSize(10),
        backgroundColor: Colors.text_white
    },
    container2: {
        width: ScreenUtils.screenW / 2,
        height: ScreenUtils.scaleSize(561),
        alignItems: 'center',
        borderRightWidth: StyleSheet.hairlineWidth,
        borderRightColor: Colors.background_grey,
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: Colors.background_grey,
        justifyContent: 'space-between',
        padding: ScreenUtils.scaleSize(10),
        backgroundColor: Colors.text_white
    },
    itemIcon: {
        width: ScreenUtils.scaleSize(355),
        height: ScreenUtils.scaleSize(355),
        minHeight: ScreenUtils.scaleSize(355)
    },
    titleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(26),
        marginTop: ScreenUtils.scaleSize(8)
    },
    priceContainer: {
        flexDirection: 'row',
        marginTop: ScreenUtils.scaleSize(20),
        justifyContent: 'space-between',
        alignSelf: 'stretch',
        alignItems: 'center'
    },
    priceTyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(20),
    },
    price: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(30)
    },
    priceInner: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    indicatorStyle_anchorrecommend: {
        ...Platform.select({
            android: {
                height: 110 * ScreenUtils.pixelRatio / 2,
                width: 26 * ScreenUtils.pixelRatio / 2
            },
        }),
    },
    bottomStyle: {
        alignItems: 'center',
        alignSelf: 'stretch'
    },
    giftContainerStyle: {
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: ScreenUtils.scaleSize(2),
        padding: ScreenUtils.scaleSize(2),
        backgroundColor: 'rgb(255,233,236)'
    },
    giftStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(22),
    },
    sellDescStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(22),
        alignSelf: 'flex-end',
        marginTop: ScreenUtils.scaleSize(8)
    },
    sellDescStyle2: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(22),
        alignSelf: 'flex-end'
    },
    integralTextStyle: {
        color: Colors.text_white,
        fontSize: ScreenUtils.scaleSize(22)
    },
    integralStyle: {
        backgroundColor: '#FF8400',
        alignItems: 'center',
        justifyContent: 'center',
        padding: ScreenUtils.scaleSize(2),
        borderRadius: ScreenUtils.scaleSize(2),
        marginLeft: ScreenUtils.scaleSize(10)
    },
    integralDescStyle: {
        color: '#FF8400',
        fontSize: ScreenUtils.scaleSize(22),
        marginLeft: ScreenUtils.scaleSize(10)
    },
    accumImg: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
        alignItems: 'center',
        justifyContent: 'center',
        padding: ScreenUtils.scaleSize(2),
        marginLeft: ScreenUtils.scaleSize(10)
    }
});