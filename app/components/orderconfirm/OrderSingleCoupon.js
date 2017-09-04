/**
 * Created by jzz on 2017/6/17.
 */

import React,{PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    ListView,
    Modal,
    DeviceEventEmitter,
    TextInput,
    StatusBar,
    Keyboard,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import CouponItem from './CouponItem';
import OrderExchangeCouponRequest from '../../../foundation/net/order/OrderExchangeCoupon'
import Toast, {DURATION} from 'react-native-easy-toast'

const icons = {
    selected: require('../../../foundation/Img/cart/selected.png'),
    normal: require('../../../foundation/Img/cart/unselected.png'),
};
let title = undefined;
export default class OrderTaxChoose extends React.Component{

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isVisible: false,
            showData: [],
            offSetY: 0, // y轴偏移  防止遮挡键盘
        };
        this._resolveData('notify');
        this.keyboardIsShow = false;
        this.layoutY = 0;
    }

    componentWillMount() {
        DeviceEventEmitter.addListener('REQUEST_CHANGE_ADDRESS', this._resolveData.bind(this));
        this.keyboardDidShowListener = Keyboard.addListener('keyboardWillShow', (e) => this.keyboardDidShow(e));
        this.keyboardDidHideListener = Keyboard.addListener('keyboardWillHide', (e) => this.keyboardDidHidden(e));
    }

    // 视图被销毁的时候 移除通知
    componentWillUnmount() {
        DeviceEventEmitter.removeListener('REFRESH_MONEY_INFO');
        DeviceEventEmitter.removeListener('REFRESH_COUPON_MESSAGE');
        DeviceEventEmitter.removeListener('REQUEST_CHANGE_ADDRESS');
        this.keyboardDidShowListener.remove();
        this.keyboardDidHideListener.remove();
    }

    keyboardDidShow(e) {
        this.keyboardIsShow=true
        this.refs.textInput && this.refs.textInput.measure((ox, oy, width, height, px, py)=>{
            if (py > ScreenUtils.screenH - e.startCoordinates.height) {
                this.refs.bgView && this.refs.bgView.setNativeProps({
                    style: {
                        top: ScreenUtils.screenH -  e.startCoordinates.height - ScreenUtils.scaleSize(200)
                    }
                })
            }
        })
    }

    keyboardDidHidden(e) {
        this.keyboardIsShow=false
        this.refs.bgView && this.refs.bgView.setNativeProps({
            style: {
                top: this.layoutY
            }
        })
    }

    /**
     * 展示当前选择的日期列表
     * @private
     */
    show () {
        this.setState( {
            isVisible: true
        });
        this._resolveData();
    }

    /**
     * 关闭当前展示的日期列表
     * @private
     */
    close () {
        if (this.keyboardIsShow) {
            Keyboard.dismiss();
        } else {
            this.setState ({
                isVisible: false
            });
        }
    }

    render () {
        let ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        let dataSource = []
        let noSelect = false
        let showData = this.state.showData[0]
        if (this.state.showData[0] && this.state.showData[0].couponList) {
            dataSource = ds.cloneWithRows(this.state.showData[0].couponList)
            noSelect = Number(showData.couponIndex) === -1 ? true : false;
        }
        return(
            <View>
                {
                    showData
                        ?
                    <Modal transparent={true}
                           visible={this.state.isVisible}
                           animationType={'fade'}
                           style={{flex: 1}}
                           onRequestClose={() => this.close()}>
                            <View style={styles.view1}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.overlay} onPress={() => this.close()}/>
                                <View style={styles.itemContainer}
                                      ref='bgView'
                                      onLayout={({nativeEvent: {layout: {x, y, width, height}}}) => {
                                          if (this.layoutY === 0) {
                                              this.layoutY = y
                                          }
                                      }}>
                                    <View style={styles.itemTopContainer}>
                                        <View style={styles.rightImg}/>
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.titleStyle}>使用抵用券</Text>
                                        <TouchableOpacity activeOpacity={1} onPress={this.close.bind(this)}>
                                            <Image
                                                style={styles.rightImg}
                                                source={require('../../../foundation/Img/dialog/icon_close_@3x.png')}
                                            />
                                        </TouchableOpacity>
                                    </View>
                                    {/*是否需要显示兑换抵用券的标记*/}
                                    {showData.isExchangeCouponUse === 'YES' ? (
                                        <View style={styles.inputContainer}>
                                            <Text
                                                allowFontScaling={false}
                                                style={styles.subTitleStyle}>兑换码</Text>
                                            <TextInput
                                                ref="textInput"
                                                style={styles.textInput}
                                                placeholder="请输入兑换码"
                                                underlineColorAndroid={'transparent'}
                                                onChangeText={(text) => {title = text}}
                                            />
                                            <TouchableOpacity activeOpacity={1} onPress={() => this.exchangeCoupon()}>
                                                <View style={styles.changeOuterStyle}>
                                                    <Text
                                                        allowFontScaling={false}
                                                        style={styles.changeTextStyle}>兑换</Text>
                                                </View>
                                            </TouchableOpacity>
                                        </View>) : null}
                                    {
                                        showData.isCouponUsable === 'YES' && showData.couponList &&
                                        showData.couponList.length ?
                                            <View>
                                                <View style={styles.itemDescContainer}>
                                                    <Text
                                                        allowFontScaling={false}
                                                        style={styles.subTitleStyle}>可用优惠券</Text>
                                                    <Text
                                                        allowFontScaling={false}
                                                        style={styles.canUseStyle}>(以下是您账户里可用于该商品的优惠券)</Text>
                                                </View>

                                                <ListView dataSource={dataSource}
                                                          enableEmptySections={true}
                                                          style={[styles.listView,
                                                              {height: showData.couponList.length >= 2 ? ScreenUtils.scaleSize(400) : ScreenUtils.scaleSize(240)}]}
                                                          renderRow={(rowData, sectionID, rowID) => this._renderRow(rowData, sectionID, rowID)}/>
                                                {/*不使用抵用券选择*/}
                                                <TouchableOpacity activeOpacity={1}
                                                                  style={styles.canNotUseContainer}
                                                                  onPress={() => this.changeSelect('-1')}>
                                                    <Image source={noSelect ? icons.selected : icons.normal}
                                                           style={styles.checkbox}
                                                    />
                                                    <Text
                                                        allowFontScaling={false}
                                                        style={styles.canNotUseText}>不使用抵用券</Text>
                                                </TouchableOpacity>
                                            </View>
                                            :
                                            null
                                    }

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
                            </View>
                            <Toast ref="toast"/>
                    </Modal>
                    :
                    <View />
                }
            </View>
        );
    }

    /**
     * 渲染日期选择列表
     * @private
     */
    _renderRow (rowData, sectionID, rowID) {
        let showData = this.state.showData[0];
        // 当前选中的优惠券
        let isSelect = Number(showData.couponIndex) === Number(rowID) ? true : false;
        return(
            <View>
                <CouponItem
                    key={rowID}
                    title={rowData.dccoupon_name}
                    price={rowData.real_coupon_amt}
                    limitDesc={rowData.min_order_amt}
                    desc={rowData.coupon_note}
                    onCheckChange={() => this.changeSelect(rowID)}
                    date={'有效期至' + rowData.dc_endDate}
                    isSelected={isSelect}
                />
            </View>
        )
    }

    /**
     * 切换抵用券 刷新数据
     * @private
     */
    changeSelect(row) {
        let tempData = this.state.showData[0];
        tempData.couponIndex = String(row);
        let tempShowData = this.state.showData;
        tempShowData[0] = tempData;
        this.setState({
            showData: tempShowData
        })
    }

    /**
     * 初始化数据
     * @private
     */
    _resolveData (notify) {
        // console.log('*************************************')
        let data = this.props.data;
        let tempDataArr =[];
        for(let index in data) {
            if ((data[index].isCouponUsable === 'YES' || data[index].isExchangeCouponUse === 'YES')) {
                // 当前可以抵用券的订单在订单列表的index
                if (data[index].couponList && data[index].couponList.length) {
                    data[index].sourceIndex = index;
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
     * 确认切换抵用券
     * @private
     */
    submitChoose () {
        let currentData = this.state.showData; // 当前页的数据
        let data = this.props.data; // 源数据
        for (let index in currentData) {
            let sourceIndex = currentData[index].sourceIndex;
            data[Number(sourceIndex)]['couponIndex'] = currentData[index].couponIndex;
            data[Number(sourceIndex)]['sourceIndex'] = currentData[index].sourceIndex;
        }
        DeviceEventEmitter.emit('REFRESH_COUPON_MESSAGE','当切换抵用券,刷新抵用券信息');
        DeviceEventEmitter.emit('REFRESH_MONEY_INFO','当切换抵用券,刷新账单显示列表');
        this.close();
    }

    /**
     * 兑换抵用券
     * @private
     */
    exchangeCoupon() {
        if (this.keyboardIsShow) {
            Keyboard.dismiss()
        }
        let param = {};
        let self = this;
        let cart = this.props.data[0];
        param.coupon_check_cart_seqs = cart.cart_seq;
        if (title && title.length) {
            param.coupon_no = title;
        } else {
            this.refs.toast.show('请先填写抵用券兑换码', DURATION.LENGTH_LONG);
            return;
        }
        new OrderExchangeCouponRequest(param).showLoadingView().start(
            function (json) {
                self.refs.toast.show('兑换成功!', DURATION.LENGTH_LONG);
                self.refs.textInput && self.refs.textInput.clear();
                let couponData = json.data;
                // 先初始化一个对象
                let couponInfo = {}
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
                self._resolveData()
            },
            function (json) {
                self.refs.toast.show(json.message, DURATION.LENGTH_LONG);
            })
    }

}
const styles=StyleSheet.create({
    modal: {
        flex: 1,
    },
    overlay: {
        position: 'absolute',
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
        opacity: 0.4,
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
        flex: 1
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
    itemContainer: {
        backgroundColor: Colors.text_white,
        position: 'absolute',
        bottom: -2,
        width: ScreenUtils.screenW,
        maxHeight: ScreenUtils.screenH * 0.7
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