/**
 * Created by YASIN on 2017/6/1.
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    TouchableOpacity,
    StyleSheet,
    Text
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import * as IsEmptyUtil from '../../../../foundation/utils/IsEmptyUtil';

export default class HotGoodItem extends React.PureComponent {
    static propTypes = {
        discount: React.PropTypes.string,
        icon: Image.propTypes.source,
        title: React.PropTypes.string,
        price: React.PropTypes.string,
        onItemClick: React.PropTypes.func
    };

    render() {
        return (
            <TouchableOpacity
                onPress={this.props.onItemClick}
                activeOpacity={1}>
                <View style={styles.container}>
                    <Image
                        source={this.props.icon}
                        resizeMode={'cover'}
                        style={styles.iconStyle}>
                        {this.props.discount ? <View style={styles.discountView}>
                                <Text allowFontScaling={false} style={styles.discount}>{String(this.props.discount)}<Text allowFontScaling={false}
                                    style={{fontSize: ScreenUtils.setSpText(20)}}>折</Text></Text>
                            </View> : null}
                    </Image>
                    <View style={styles.descContainer}>
                        <Text allowFontScaling={false}
                            numberOfLines={2}
                            style={styles.titleText}>
                            {this.props.title}
                        </Text>
                        <Text allowFontScaling={false} style={styles.price}>
                            ¥
                            <Text allowFontScaling={false} style={styles.priceStyle}>
                                {(IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(this.props.price)) ? String(this.props.price) : ''}
                            </Text>
                        </Text>
                    </View>
                </View>
            </TouchableOpacity>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        alignItems: 'center',
        width: ScreenUtils.scaleSize(220)
    },
    iconStyle: {
        width: ScreenUtils.scaleSize(180),
        height: ScreenUtils.scaleSize(180)
    },
    discountView: {
        width: ScreenUtils.scaleSize(70),
        height: ScreenUtils.scaleSize(40),
        backgroundColor: "#ED1C41",
        justifyContent: 'center',
        alignItems: 'center'
    },
    discount: {
        color: 'white',
        fontWeight: 'bold',
        fontSize: ScreenUtils.scaleSize(26)
    },
    descContainer: {
        width: ScreenUtils.scaleSize(180),
        height: ScreenUtils.scaleSize(130),
        marginTop: ScreenUtils.scaleSize(10),
        justifyContent: 'space-between'
    },
    titleText: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(26),
    },
    price: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(24)
    },
    priceStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(30)
    }
});