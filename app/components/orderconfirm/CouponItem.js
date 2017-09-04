/**
 * Created by YASIN on 2017/6/14.
 * 单商品优惠券item
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
const icons = {
    selected: require('../../../foundation/Img/cart/selected.png'),
    normal: require('../../../foundation/Img/cart/unselected.png'),
};
export default class CouponItem extends React.Component {
    static propTypes = {
        ...View.propTypes.style,
        isSelected: PropTypes.bool,
        price: PropTypes.string,
        limitDesc: PropTypes.string,
        title: PropTypes.string,
        desc: PropTypes.string,
        date: PropTypes.string,
        onCheckChange: PropTypes.func
    }
    static defaultProps = {
        isSelected: false
    }

    render() {
        return (
            <View style={[styles.container, this.props.style]}>
                <TouchableOpacity
                    activeOpacity={1}
                    onPress={() => {
                        this.props.onCheckChange(this.props.isSelected);
                    }}
                >
                    <Image
                        source={this.props.isSelected ? icons.selected : icons.normal}
                        style={styles.checkbox}
                    />
                </TouchableOpacity>
                <View style={styles.rightContainer}>
                    <View style={styles.leftView}>
                        <Image style={styles.priceContainer}
                               source={require('../../../foundation/Img/order/icon_left_coupon.png')}/>
                        <View style={[styles.leftView, styles.leftTopView]}>
                            <View style={{
                                flexDirection: 'row', alignItems: 'flex-end', backgroundColor: 'transparent',
                                width: ScreenUtils.scaleSize(184), justifyContent: 'center',
                            }}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.priceTypeStyle}>¥
                                    <Text allowFontScaling={false} style={styles.priceTextStyle}>{String(this.props.price)}</Text></Text>
                            </View>
                            {
                                this.props.limitDesc ?
                                    <Text allowFontScaling={false}
                                          style={styles.priceDescText}>
                                        满{this.props.limitDesc}元可用
                                    </Text>
                                    :
                                    null
                            }
                        </View>
                    </View>

                    <Image
                        style={styles.descContainer}
                        source={require('../../../foundation/Img/order/icon_right_coupon@2x.png')}>
                        <View style={{padding: ScreenUtils.scaleSize(20), marginLeft: ScreenUtils.scaleSize(10)}}>
                            <Text
                                allowFontScaling={false}
                                style={styles.descTitleStyle}>{this.props.title}</Text>
                            <Text
                                allowFontScaling={false}
                                style={styles.descTextStyle}>{this.props.desc}</Text>
                            <Text
                                allowFontScaling={false}
                                style={styles.dateTextStyle}>{this.props.date}</Text>
                        </View>
                    </Image>
                </View>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        alignItems: 'center',
        backgroundColor: Colors.text_white,
        flexDirection: 'row',
        paddingHorizontal: ScreenUtils.scaleSize(30),
        paddingVertical: ScreenUtils.scaleSize(15)
    },
    checkbox: {
        width: ScreenUtils.scaleSize(31),
        height: ScreenUtils.scaleSize(31)
    },
    rightContainer: {
        flex: 1,
        flexDirection: 'row',
        marginLeft: ScreenUtils.scaleSize(20)
    },
    leftView: {
        width: ScreenUtils.scaleSize(184),
        height: ScreenUtils.scaleSize(194),
    },
    priceContainer: {
        width: ScreenUtils.scaleSize(184),
        height: ScreenUtils.scaleSize(194),
        alignItems: 'center',
        justifyContent: 'center',
        resizeMode: 'stretch',
    },
    descContainer: {
        flex: 1,
        height: ScreenUtils.scaleSize(194),
        justifyContent: 'center',
        resizeMode: 'stretch'
    },
    priceTypeStyle: {
        color: Colors.text_white,
        fontSize: ScreenUtils.scaleSize(28),
        backgroundColor: 'transparent'
    },
    priceTextStyle: {
        color: Colors.text_white,
        fontSize: 26,
    },
    priceDescText: {
        color: Colors.text_white,
        fontSize: ScreenUtils.scaleSize(22),
        marginTop: ScreenUtils.scaleSize(30),
        backgroundColor: 'transparent'
    },
    descTitleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28),
    },
    descTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(22),
        marginTop: ScreenUtils.scaleSize(30)
    },
    dateTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(22),
        marginTop: ScreenUtils.scaleSize(10)
    },
    leftTopView: {
        position: 'absolute',
        left: 0,
        top: 0,
        alignItems: 'center',
        justifyContent: 'center'
    }
});