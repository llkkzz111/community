/**
 * Created by YASIN on 2017/6/10.
 * 单商品选用抵用券
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    Modal,
    StatusBar,
    TextInput,
    FlatList,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import CouponItem from './CouponItem';
const icons = {
    selected: require('../../../foundation/Img/cart/selected.png'),
    normal: require('../../../foundation/Img/cart/unselected.png'),
};
var key = 0;
export default class CouponSingleModal extends React.Component {
    static propTypes = {
        ...View.propTypes.style,
        order: PropTypes.object,
        onClose: PropTypes.func,
        onSelectedChange: PropTypes.func,
        onConfirm: PropTypes.func
    }
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isShowDialog: false,
            isUseConpon: true,//默认使用抵用券
            order: this.props.order
        };
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            order: nextProps.order
        });
    }

    render() {
        let couponList = this.state.order.couponList;
        return (
            <Modal
                animationType={"fade"}
                transparent={true}
                visible={this.state.isShowDialog}
                onRequestClose={() => {
                }}
            >
                <View style={styles.container}>
                    <View style={styles.itemContainer}>
                        <View style={styles.itemTopContainer}>
                            <View style={styles.rightImg}/>
                            <Text
                                allowFontScaling={false}
                                style={styles.titleStyle}>使用抵用券</Text>
                            <TouchableOpacity activeOpacity={1} onPress={this._onCloseClick.bind(this)}>
                                <Image
                                    style={styles.rightImg}
                                    source={require('../../../foundation/Img/dialog/icon_close_@3x.png')}
                                />
                            </TouchableOpacity>
                        </View>
                        {/*是否需要显示兑换抵用券的标记*/}
                        {this.state.order.isExchangeCouponUse === 'YES' ? (
                            <View style={styles.inputContainer}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.subTitleStyle}>兑换码</Text>
                                <TextInput
                                    style={styles.textInput}
                                    placeholder="请输入兑换码"
                                    underlineColorAndroid={'transparent'}
                                />
                                <View style={styles.changeOuterStyle}>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.changeTextStyle}>兑换</Text>
                                </View>
                            </View>) : null}
                        <View style={styles.itemDescContainer}>
                            <Text
                                allowFontScaling={false}
                                style={styles.subTitleStyle}>可用优惠券</Text>
                            <Text
                                allowFontScaling={false}
                                style={styles.canUseStyle}>(以下是您账户里可用于该商品的优惠券)</Text>
                        </View>
                        {/*抵用券列表*/}
                        {(this.state.order.couponList && this.state.order.couponList.length > 0) ? (
                            <View style={{flex: 1, width: ScreenUtils.screenW, maxHeight: ScreenUtils.screenH * 0.4}}>
                                <FlatList
                                    key={++key}
                                    data={this.state.order.couponList}
                                    renderItem={({item, index}) => {
                                        if (!item.selected && index === 0) {
                                            item.selected = '1';
                                        } else if (!item.selected) {
                                            item.selected = '0';
                                        }
                                        return (
                                            <CouponItem
                                                key={index}
                                                title={item.coupon_note}
                                                price={item.real_coupon_amt}
                                                limitDesc={''}
                                                desc={''}
                                                date={'有效期至' + item.dc_endDate}
                                                onCheckChange={(check) => {
                                                    couponList.forEach((coupon, index1) => {
                                                        if (check) {
                                                            coupon.selected = '0';
                                                        } else {
                                                            if (index === index1) {
                                                                coupon.selected = '1';
                                                            } else {
                                                                coupon.selected = '0';
                                                            }
                                                        }
                                                    })
                                                    this.setState({
                                                        order: this.state.order
                                                    });
                                                }}
                                                isSelected={item.selected === '1'}
                                            />
                                        );
                                    }}
                                    overScrollMode={'never'}
                                />
                            </View>
                        ) : null}
                        {/*不使用抵用券选择*/}
                        <TouchableOpacity
                            activeOpacity={1}
                            style={styles.canNotUseContainer}
                            onPress={() => {
                                this.setState({
                                    isUseConpon: !this.state.isUseConpon
                                });
                            }}
                        >
                            <Image
                                source={this.state.isUseConpon ? icons.normal : icons.selected}
                                style={styles.checkbox}
                            />
                            <Text
                                allowFontScaling={false}
                                style={styles.canNotUseText}>不使用抵用券</Text>
                        </TouchableOpacity>
                        {/*提交按钮*/}
                        <TouchableOpacity onPress={this._onComfirm.bind(this)} activeOpacity={1}>
                            <Image
                                resizeMode={'stretch'}
                                source={require('../../../foundation/Img/order/icon_orderconfirm_topbar_.png')}
                                style={styles.btnBgImg}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.submitTitle}> 确定 </Text>
                            </Image>
                        </TouchableOpacity>
                    </View>
                </View>
            </Modal>
        );
    }

    /**
     * 点击确定按钮
     * @private
     */
    _onComfirm() {
        let order = this.state.order;
        order.isUseConpon = this.state.isUseConpon;
        this.props.onConfirm && this.props.onConfirm();
        this.close();
    }

    /**
     *
     * @private
     */
    _onCloseClick() {
        this.close();
    }

    /**
     * 打开dailog
     */
    open() {
        if (this.state.isShowDialog) {
            return;
        }
        this.setState({
            isShowDialog: true
        })
    }

    /**
     * 关闭dialog
     */
    close() {
        if (!this.state.isShowDialog) {
            return;
        }
        this.setState({
            isShowDialog: false
        });
        this.props.onClose();
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: 'rgba(0,0,0,0.5)',
        position: 'absolute',
        top: 0,
        bottom: 0,
        ...Platform.select({
            android: {
                marginTop: StatusBar.currentHeight
            }
        })
    },
    itemContainer: {
        backgroundColor: Colors.text_white,
        position: 'absolute',
        bottom: 0,
        width: ScreenUtils.screenW,
    },
    itemTopContainer: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        justifyContent: 'space-between',
        width: ScreenUtils.screenW,
        padding: ScreenUtils.scaleSize(30),
    },
    titleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(32)
    },
    rightImg: {
        height: ScreenUtils.scaleSize(25),
        width: ScreenUtils.scaleSize(25),
    },
    inputContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        marginHorizontal: ScreenUtils.scaleSize(30),
        borderBottomWidth: ScreenUtils.scaleSize(1),
        borderBottomColor: Colors.background_grey,
        paddingTop: ScreenUtils.scaleSize(30),
        paddingBottom: ScreenUtils.scaleSize(15)
    },
    subTitleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28)
    },
    textInput: {
        flex: 1,
        textAlignVertical: 'center',
        fontSize: ScreenUtils.scaleSize(28),
        color: Colors.text_light_grey,
        ...Platform.select({
            ios: {
                height: ScreenUtils.scaleSize(54)
            },
            android: {
                height: ScreenUtils.scaleSize(72)
            }
        }),
        marginLeft: ScreenUtils.scaleSize(30)
    },
    changeOuterStyle: {
        borderRadius: ScreenUtils.scaleSize(2),
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.main_color,
        padding: ScreenUtils.scaleSize(4)
    },
    changeTextStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(26)
    },
    itemDescContainer: {
        padding: ScreenUtils.scaleSize(30),
        flexDirection: 'row',

    },
    canUseStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(20)
    },
    btnBgImg: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(88),
        alignItems: 'center',
        justifyContent: 'center',
    },
    submitTitle: {
        color: Colors.text_white,
        fontSize: ScreenUtils.scaleSize(28),
        backgroundColor: 'transparent'
    },
    checkbox: {
        width: ScreenUtils.scaleSize(31),
        height: ScreenUtils.scaleSize(31)
    },
    canNotUseContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        padding: ScreenUtils.scaleSize(30)
    },
    canNotUseText: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28),
        marginLeft: ScreenUtils.scaleSize(10)
    }
});