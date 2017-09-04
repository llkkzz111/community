/**
 * Created by jzz on 2017/6/11.
 * 多订单优惠券选择
 */

import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    ListView,
    Modal,
    ScrollView,
    DeviceEventEmitter,
    TextInput,
    StatusBar,
} from 'react-native';
import Toast, {DURATION} from 'react-native-easy-toast'
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import OrderExchangeCouponRequest from '../../../foundation/net/order/OrderExchangeCoupon'
const icons = {
    selected: require('../../../foundation/Img/cart/selected.png'),
    normal: require('../../../foundation/Img/cart/unselected.png'),
};
let title = [];
export default class OrderTaxChoose extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isVisible: false,
            showData: [],
        };
        this.inputs = [];
        this._resolveData1('notify');
    }

    componentWillMount() {
        DeviceEventEmitter.addListener('REQUEST_CHANGE_ADDRESS', this._resolveData1.bind(this));
    }

    // 视图被销毁的时候 移除通知
    componentWillUnmount() {
        DeviceEventEmitter.removeListener('REFRESH_MONEY_INFO');
        DeviceEventEmitter.removeListener('REFRESH_COUPON_MESSAGE');
        DeviceEventEmitter.removeListener('REQUEST_CHANGE_ADDRESS');
    }

    /**
     * 展示当前选择的日期列表
     * @private
     */
    show() {
        this.setState({
            isVisible: true
        });
        this._resolveData1();
    }

    /**
     * 关闭当前展示的日期列表
     * @private
     */
    close() {
        this.setState({
            isVisible: false
        });
    }

    render() {
        let ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        let dataSource = ds.cloneWithRows(this.state.showData)
        return (
            <Modal transparent={true}
                   visible={this.state.isVisible}
                   animationType={'fade'}
                   style={{flex: 1}}
                   onRequestClose={() => this.close()}>
                    <View style={styles.view1}>
                        <Text
                            allowFontScaling={false}
                            style={styles.overlay} onPress={() => this.close()}/>
                        <View style={styles.container1}>
                            <View style={styles.titleView}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.title}>使用抵用券</Text>
                            </View>
                            <TouchableOpacity activeOpacity={1} onPress={() => this.close()}>
                                <Image style={styles.rightImg}
                                       source={require('../../../foundation/Img/dialog/icon_close_@3x.png')}/>
                            </TouchableOpacity>
                            <ListView dataSource={dataSource}
                                      enableEmptySections={true}
                                      style={styles.listView}
                                      ref="listView"
                                      renderRow={(rowData, sectionID, rowID) => this._renderRow(rowData, sectionID, rowID)}/>
                            <TouchableOpacity activeOpacity={1} onPress={() => this.submitChoose()}>
                                <View style={styles.submitBtn}>
                                    <Image resizeMode={'stretch'}
                                           source={require('../../../foundation/Img/order/icon_orderconfirm_topbar_.png')}
                                           style={styles.btnBgImg}/>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.submitTitle}> 确定 </Text>
                                </View>
                            </TouchableOpacity>
                        </View>
                        <Toast ref="toast"/>
                    </View>
            </Modal>
        );
    }

    /**
     * 渲染日期选择列表
     * @private
     */
    _renderRow(rowData, sectionID, rowID) {
        // console.log(rowData)
        // 当前选中的优惠券是否是系统默认选中的优惠券
        let defaultSelect = rowData.couponIndex === '0' ? true : false;
        // 当前选中的优惠券
        let selectIndex = Number(rowData.couponIndex);
        let self = this;
        return (
            <View style={styles.bgCell}>
                <View style={styles.cell}>
                    {
                        rowData.isExchangeCouponUse === 'YES'
                            ?
                            <View style={styles.inputContainer}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.subTitleStyle}>兑换码</Text>
                                <TextInput
                                    ref={(ref)=> {
                                        this.inputs.push(ref)
                                    }}
                                    style={styles.textInput}
                                    placeholder="请输入兑换码"
                                    underlineColorAndroid={'transparent'}
                                    onChangeText={(text) => {title[Number(rowID)] = text}}
                                />
                                <TouchableOpacity activeOpacity={1} onPress={() => this.exchangeCoupon(Number(rowID), rowData)}>
                                    <View style={styles.changeOuterStyle}>
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.changeTextStyle}>兑换</Text>
                                    </View>
                                </TouchableOpacity>
                            </View>
                            :
                            null
                    }
                    <View style={styles.titleView1}>
                        <Text
                            allowFontScaling={false}
                            style={styles.title1}>分类 {Number(rowID) + 1} </Text>
                        <Text
                            allowFontScaling={false}
                            style={styles.descriptions}>
                            {rowData.isCouponUsable === 'YES' ? '(此组内商品已满足优惠券使用条件)' : ''}
                        </Text>
                    </View>
                    <View>
                        <ScrollView horizontal={true}
                                    showsHorizontalScrollIndicator={false}
                                    style={styles.horizontalImageList}>
                            {
                                rowData.carts.map(function (item1, index1) {
                                    return (
                                        <View key={item1.item.path + index1}
                                              style={[styles.imageView, (index1 !== 0 ? styles.marginLeft10 : null)]}>
                                            <Image key={index1}
                                                   style={[styles.image]}
                                                   source={{uri: item1.item.path}}/>
                                        </View>
                                    )
                                })
                            }
                        </ScrollView>
                    </View>

                    {
                        rowData.isCouponUsable === 'YES' && rowData.couponList &&
                        rowData.couponList.length ?
                            <View>
                                <View style={styles.titleView1}>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.title1}>
                                        {rowData.isCouponUsable === 'YES' ? '可用优惠券' : '暂无可用抵用券'}
                                    </Text>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.descriptions}>
                                        { rowData.isCouponUsable === 'YES' && defaultSelect ? '(已默认为您选择最省方案)' : ''}
                                    </Text>
                                </View>
                                {
                                    rowData.isCouponUsable === 'YES' ?
                                        rowData.couponList.map(function (item, index) {
                                            return (
                                                <View style={styles.invoiceInfo}
                                                      key={index}>
                                                    <TouchableOpacity activeOpacity={1} style={styles.checkBoxStyle}
                                                                      onPress={() => self.selectCoupon(index, rowID)}>
                                                        <Image source={selectIndex === index ? icons.selected : icons.normal}
                                                               style={styles.checkbox}/>
                                                    </TouchableOpacity>
                                                    <Text
                                                        allowFontScaling={false}
                                                        style={styles.invoiceInfoTitle}>{item.coupon_note}</Text>
                                                </View>
                                            )
                                        })
                                        :<View/>
                                }
                                {
                                    rowData.isCouponUsable === 'YES'
                                        ?
                                        <View style={styles.invoiceInfo}>
                                            <TouchableOpacity activeOpacity={1} style={styles.checkBoxStyle}
                                                              onPress={() => this.selectCoupon('-1', rowID)}>
                                                <Image source={selectIndex === -1 ? icons.selected : icons.normal}
                                                       style={styles.checkbox}/>
                                            </TouchableOpacity>
                                            <Text
                                                allowFontScaling={false}
                                                style={styles.invoiceInfoTitle}>不使用抵用券</Text>
                                        </View>
                                        :
                                        <View/>
                                }
                            </View>
                            :
                            <View style={styles.marginTop20}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.title1}>暂无可用抵用券</Text>
                            </View>

                    }
                </View>
                <View style={styles.line}>
                </View>
            </View>
        )
    }

    /**
     * 兑换抵用券
     * @private
     */
    exchangeCoupon(index, rowData) {
        let self = this;
        let cart = this.props.data[index];
        let param = {};
        param.coupon_check_cart_seqs = rowData.cart_seq;
        if (title[index] && title[index].length) {
            param.coupon_no = title[index];
        } else {
            this.refs.toast.show('请先填写抵用券兑换码', DURATION.LENGTH_LONG);
            return;
        }

        new OrderExchangeCouponRequest(param).showLoadingView().start(
            function (json) {
                self.refs.toast.show('兑换成功!', DURATION.LENGTH_LONG);
                self.inputs[index] && self.inputs[index].clear();
                title[index] = undefined;
                let couponData = json.data;
                // 先初始化一个对象
                let couponInfo = {};
                couponInfo.coupon_no = couponData.coupon_no;
                couponInfo.coupon_note = couponData.coupon_note;
                couponInfo.coupon_seq = couponData.coupon_seq;
                couponInfo.dc_endDate = couponData.dc_endDate;
                couponInfo.dc_gb = couponData.dc_gb;
                couponInfo.real_coupon_amt = couponData.real_coupon_amt;
                // 把控制可以显示抵用券的字段置为YES
                cart.isCouponUsable = "YES";
                if (cart.couponList && cart.couponList.length) {
                    cart.couponList.push(couponInfo)
                } else {
                    cart.couponList = []
                    cart.couponList.push(couponInfo)
                }
                self._resolveData1()
            },
            function (json) {
                self.refs.toast.show(json.message, DURATION.LENGTH_LONG);
            })
    }

    _resolveData1(notify) {
        let data = this.props.data;
        let tempDataArr = [];
        for (let index in data) {
            if ((data[index].isCouponUsable === 'YES' || data[index].isExchangeCouponUse === 'YES') ) {
                // 当前可以抵用券的订单在订单列表的index
                data[index].sourceIndex = index;
                if (data[index].couponList && data[index].couponList.length) {
                    if (!data[index].couponIndex && data[index].isCouponUsable === 'YES') {
                        // 选中使用的抵用券在抵用券列表的index
                        data[index].couponIndex = '0';
                    }
                    if (data[index].couponIndex && data[index].couponIndex === null ) {
                        data[index].couponIndex = '0';
                    }
                }
                tempDataArr.push(data[index]);
            }
        }
        let deepCopyObj = JSON.stringify(tempDataArr)
        deepCopyObj = JSON.parse(deepCopyObj)
        if (notify) {
            this.state.showData.push(deepCopyObj)
        } else {
            this.setState({
                showData: deepCopyObj
            })
        }

    }

    /**
     * 切换抵用券 刷新数据
     * @private
     */
    selectCoupon(index, row) {
        let tempData = this.state.showData[Number(row)];
        tempData.couponIndex = String(index);
        let tempShowData = this.state.showData;
        tempShowData[Number(row)] = tempData;
        this.setState({
            showData: tempShowData
        })
    }

    /**
     * 确认切换抵用券
     * @private
     */
    submitChoose() {
        let currentData = this.state.showData; // 当前页的数据
        let data = this.props.data; // 源数据
        for (let index in currentData) {
            let sourceIndex = currentData[index].sourceIndex;
            data[Number(sourceIndex)]['couponIndex'] = currentData[index].couponIndex;
            data[Number(sourceIndex)]['sourceIndex'] = currentData[index].sourceIndex;
        }
        DeviceEventEmitter.emit('REFRESH_COUPON_MESSAGE', '当切换抵用券,刷新抵用券信息');
        DeviceEventEmitter.emit('REFRESH_MONEY_INFO', '当切换抵用券,刷新账单显示列表');
        this.close();
    }

}
const styles = StyleSheet.create({
    modal: {
        flex: 1,
    },
    view1: {
        justifyContent: 'flex-end',
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        width: ScreenUtils.screenW,
        ...Platform.select({
            ios: {
                height: ScreenUtils.screenH
            },
            android: {
                height: ScreenUtils.screenH - StatusBar.currentHeight + 1,
            }
        }),
        top: 0,
        position: 'absolute'
    },
    overlay: {
        position: 'absolute',
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
        opacity: 0.4,
    },
    container1: {
        justifyContent: 'flex-end',
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        height: ScreenUtils.scaleSize(1000),
    },
    titleView: {
        height: ScreenUtils.scaleSize(100),
        alignItems: 'center',
        justifyContent: 'center',
        borderBottomColor: Colors.background_grey,
        borderBottomWidth: ScreenUtils.scaleSize(1),
    },
    title: {
        fontSize: ScreenUtils.scaleSize(30),
    },
    listView: {
        flex: 1,
    },
    rightImg: {
        position: 'absolute',
        top: ScreenUtils.scaleSize(-65),
        right: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
        width: ScreenUtils.scaleSize(30),
    },
    submitBtn: {
        height: ScreenUtils.scaleSize(88),
        width: ScreenUtils.screenW,
    },
    btnBgImg: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(88),
    },
    submitTitle: {
        position: 'absolute',
        alignSelf: 'center',
        marginTop: ScreenUtils.scaleSize(23),
        fontSize: ScreenUtils.scaleSize(30),
        backgroundColor: 'transparent',
        color: Colors.text_white,
    },
    bgCell: {
        width: ScreenUtils.screenW,
    },
    cell: {
        paddingLeft: ScreenUtils.scaleSize(30),
    },
    line: {
        marginTop: ScreenUtils.scaleSize(20),
        marginLeft: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(1),
        backgroundColor: Colors.background_grey,
    },
    cellText: {
        fontSize: ScreenUtils.scaleSize(30),
    },
    selectTextColor: {
        color: Colors.text_orange,
    },
    noSelectColor: {
        color: Colors.text_light_grey,
    },
    selectImage: {
        height: ScreenUtils.scaleSize(24),
        width: ScreenUtils.scaleSize(32),
    },
    titleView1: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: ScreenUtils.scaleSize(20),
    },
    title1: {
        fontSize: ScreenUtils.scaleSize(28),
    },
    descriptions: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    horizontalImageList: {
        height: ScreenUtils.scaleSize(150),
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(20),
    },
    imageView: {
        width: ScreenUtils.scaleSize(150),
        height: ScreenUtils.scaleSize(150),
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.text_light_grey,
        borderRadius: ScreenUtils.scaleSize(4),
        alignItems: 'center',
        justifyContent: 'center',
        padding: ScreenUtils.scaleSize(1),
    },
    image: {
        width: ScreenUtils.scaleSize(142),
        height: ScreenUtils.scaleSize(146),
    },
    marginLeft10: {
        marginLeft: ScreenUtils.scaleSize(10),
    },
    checkbox: {
        width: ScreenUtils.scaleSize(31),
        height: ScreenUtils.scaleSize(31),
    },
    invoiceInfo: {
        flexDirection: 'row',
        height: ScreenUtils.scaleSize(50),
        marginTop: ScreenUtils.scaleSize(10),
        alignItems: 'center',
    },
    invoiceInfoTitle: {
        marginLeft: ScreenUtils.scaleSize(20),
        fontSize: ScreenUtils.scaleSize(26),
        color: Colors.text_black,
    },
    inputContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(60),
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
        marginLeft: ScreenUtils.scaleSize(30),
        ...Platform.select({
            ios: {
                height: ScreenUtils.scaleSize(54)
            },
            android: {
                paddingTop: 5,
                paddingBottom: 5
            }
        })
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
    marginTop20: {
        marginTop: ScreenUtils.scaleSize(20)
    }


});