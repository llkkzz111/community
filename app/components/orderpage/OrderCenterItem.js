/**
 * Created by zhenzhen on 2017/7/25.
 * 订单中心item
 */
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    FlatList,
    DeviceEventEmitter,
    Platform,
    Text,
    Dimensions,
    Image,
    TouchableOpacity
} from 'react-native';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
import GoodInfo from './GoodInfo';
import TimerMixin from 'react-timer-mixin';
export default class OrderCenterItem extends Component {
    static propTypes = {
        ...View.propTypes.style,
        orderNo: PropTypes.string,
        orderState: PropTypes.string,
        orderPicList: PropTypes.array.isRequired,
        goodsCount: PropTypes.string,
        title: PropTypes.string,
        color: PropTypes.string, //颜色
        type: PropTypes.string, //规格
        integral: PropTypes.string, //积分
        weight: PropTypes.string, //重量
        price: PropTypes.string, //价格
        freight: PropTypes.string,//运费
        isNoPay: PropTypes.bool,//实付款还是待支付
        noPayAmt: PropTypes.string,//待支付金额
        payAmt: PropTypes.string,//实支付金额
        isShowFapiao: PropTypes.bool,//是否显示发票按钮
        isShowWuliu: PropTypes.bool,//是否显示物流
        isNoPayButton: PropTypes.bool,//是否显示
        currTime: PropTypes.string,//当前时间
        endTime: PropTypes.string,//支付截止时间


        isShowComment: PropTypes.bool,//是否显示评价按钮
        isShowReceiver: PropTypes.bool,//是否显示确认收货按钮,
        isShowExchange: PropTypes.bool,//是否显示退换货按钮,
        viewFapiao: PropTypes.func,
        viewWuliu: PropTypes.func,
        goComment: PropTypes.func,
        confirmReceiver: PropTypes.func,
        immediatePay: PropTypes.func,
        viewExchangeDetail: PropTypes.func,
        onItemClick: PropTypes.func,
        onRefresh: PropTypes.func,
        obtainCard: PropTypes.bool,
        showCard: PropTypes.bool,
        goCard: PropTypes.func,
        getCard: PropTypes.func,
    }
    static defaultProps = {
        isSelected: false,
        freight: '0.00',
        isNoPay: false,
        isShowFapiao: false,
        isShowComment: false,
        isShowReceiver: false,
        isShowExchange: false,
        isShowWuliu: false,
        isNoPayButton: false,
        obtainCard: false,
        showCard: false,
    }

    constructor(props) {
        super(props);
        this.state = {
            times: [],
        }
    }

    render() {
        return (
            <TouchableOpacity
                style={[styles.container, this.props.style]}
                onPress={this.props.onItemClick}
                activeOpacity={0.9}
            >
                {/*上面一部分*/}
                <View style={styles.topContainer}>
                    <View style={styles.orderStatus}>
                        <Text
                            allowFontScaling={false}
                            style={styles.orderNoText}
                        >
                            订单编号：
                        </Text>
                        <Text
                            allowFontScaling={false}
                            style={styles.orderNo}
                        >
                            {this.props.orderNo}
                        </Text>
                    </View>
                    <Text
                        allowFontScaling={false}
                        style={styles.orderState}
                    >
                        {this.props.orderState}
                    </Text>
                </View>
                {/*中间一部分*/}
                {this._renderMiddle()}
                {/*下面一部分*/}
                {this._renderBottom()}
            </TouchableOpacity>
        );
    }

    /**
     * 渲染中间部分
     * @private
     */
    _renderMiddle() {
        let component = null;
        if (this.props.orderPicList && this.props.orderPicList.length > 1) {
            component = (
                <View style={styles.orderListContainer}>
                    <View style={styles.orderListLeft}>
                        {this.props.orderPicList.map((pic, index) => {
                            return (
                                <Image
                                    key={index}
                                    style={[styles.orderListIcon, index !== 0 ? {marginLeft: ScreenUtils.scaleSize(30)} : null]}
                                    source={{uri: pic}}
                                />
                            );
                        })}
                    </View>
                    <View style={styles.orderListRight}>
                        <Text
                            allowFontScaling={false}
                            style={styles.updateDescStyle}>共{this.props.goodsCount}件</Text>
                        <Image style={styles.updateIconStyle}
                               source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>
                    </View>
                </View>
            );
        } else if (this.props.orderPicList && this.props.orderPicList.length === 1) {
            let pic = this.props.orderPicList[0];
            component = (
                <GoodInfo
                    icon={{uri:pic}}
                    color={this.props.color}
                    title={this.props.title}
                    type={this.props.type}
                    integral={this.props.integral}
                    count={this.props.goodsCount}
                    price={this.props.price}
                    onlyOne={false}
                />
            );
        }
        return (
            <View style={styles.midddleContainer}>
                {component}
            </View>
        )
    }

    /**
     * 渲染底部
     * @private
     */
    _renderBottom() {
        let buttons = [];
        if (!!this.props.isShowFapiao) {
            buttons.push(this._renderButton(styles.buttonStyleBlack, '查看发票', styles.buttonTitleStyleBlack, this.props.viewFapiao));
        }
        if (!!this.props.isShowWuliu) {
            buttons.push(this._renderButton(styles.buttonStyleBlack, '查看物流', styles.buttonTitleStyleBlack, this.props.viewWuliu));
        }
        if (!!this.props.isShowComment) {
            buttons.push(this._renderButton(styles.buttonStyleRed, '去评价', styles.buttonTitleStyleRed, this.props.goComment));
        }
        if (!!this.props.isShowReceiver) {
            buttons.push(this._renderButton(styles.buttonStyleRed, '确认收货', styles.buttonTitleStyleRed, this.props.confirmReceiver));
        }
        if (!!this.props.isNoPayButton) {
            buttons.push(this._renderButton(styles.buttonStyleRed, '立即付款', styles.buttonTitleStyleRed, this.props.immediatePay));
        }
        if (!!this.props.isShowExchange) {
            buttons.push(this._renderButton(styles.buttonStyleRed, '退货换详情', styles.buttonTitleStyleRed, this.props.viewExchangeDetail));
        }
        if (!!this.props.obtainCard) {
            buttons.push(this._renderButton(styles.buttonStyleRed, '获取卡号卡密', styles.buttonTitleStyleRed, this.props.getCard));
        }
        if (!!this.props.showCard) {
            buttons.push(this._renderButton(styles.buttonStyleRed, '查看卡号卡密', styles.buttonTitleStyleRed, this.props.goCard));
        }
        return (
            <View style={styles.bottomContainer}>
                <View style={styles.priceContainer}>
                    <View style={{flex: 1}}/>
                    <View style={styles.priceRightContainer}>
                        <Text style={styles.countTextStyle}
                              allowFontScaling={false}>{`共计${this.props.goodsCount}件商品`}</Text>
                        <Text style={styles.countTextStyle2}
                              allowFontScaling={false}>{`运费：${this.props.freight}`}</Text>
                        <Text style={styles.countTextStyle2}
                              allowFontScaling={false}>{!!this.props.isNoPay ? ('待支付：') : '实支付：'}</Text>
                        <Text
                            style={styles.countTextStyle3}
                            allowFontScaling={false}>{`¥${!!this.props.isNoPay ? (this.props.noPayAmt) : this.props.payAmt}`}</Text>
                    </View>
                </View>
                {(buttons.length > 0) ? (
                    <View style={styles.buttonContainer}>
                        <View style={{flex: 1}}>
                            {(this.state.times && this.state.times.length === 2) ? (
                                <View style={styles.timeContainer}>
                                    <Text style={styles.timeTitle} allowFontScaling={false}>付款剩余时间：</Text>
                                    <Text
                                        style={styles.timeText} allowFontScaling={false}>{`${this.state.times[0]}小时${this.state.times[1]}分钟`}</Text>
                                </View>
                            ) : null}
                        </View>
                        <View style={styles.buttonContainerRigth}>
                            {buttons}
                        </View>
                    </View>
                ) : null}
            </View>
        );
    }

    /**
     * button
     * @param style
     * @param title
     * @param textStyle
     * @param callBack
     * @private
     */
    _renderButton(style, title, textStyle, callBack) {
        return (
            <TouchableOpacity
                key={title}
                style={style}
                onPress={callBack}
                activeOpacity={0.618}
            >
                <Text style={textStyle} allowFontScaling={false}>{title}</Text>
            </TouchableOpacity>
        );
    }

    /**
     * 倒计时 运算
     */
    timeStart() {
        let distance = 0;
        let currTime = parseFloat(this.props.currTime);
        let endTime = parseFloat(this.props.endTime);
        if (currTime !== NaN && endTime !== NaN && !!this.props.isNoPayButton) {
            distance = (endTime - currTime);
        }
        if (distance > 0) {
            if (this.interval) {
                TimerMixin.clearInterval(this.interval);
            }
            this.interval = TimerMixin.setInterval(() => {
                if (distance <= 1000) {
                    TimerMixin.clearInterval(this.interval);
                    this.setState({
                        times: [],
                    }, ()=> {
                        this.props.onRefresh && this.props.onRefresh(false);
                    });
                } else {
                    this.setState({
                        times: ScreenUtils.getRemainingimeDistance2(distance),//获取时间数组
                    });
                }
                distance -= 1000;
            }, 1000);
        }
    }

    componentDidMount() {
        this.timeStart();
    }

    componentWillUnmount() {
        if (this.interval) {
            TimerMixin.clearInterval(this.interval);
        }
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_grey,
    },
    topContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        width: ScreenUtils.screenW,
        paddingHorizontal: ScreenUtils.scaleSize(30),
        paddingVertical: ScreenUtils.scaleSize(33),
        backgroundColor: Colors.text_white,
        justifyContent: 'space-between',
    },
    orderStatus: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    orderNoText: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.setSpText(28),
    },
    orderNo: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(26),
    },
    orderState: {
        color: Colors.order_state,
        fontSize: ScreenUtils.scaleSize(28)
    },
    midddleContainer: {
        width: ScreenUtils.screenW,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: Colors.text_white,
        marginTop: ScreenUtils.scaleSize(2),
    },
    orderListContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: ScreenUtils.scaleSize(30)
    },
    orderListLeft: {
        flexDirection: 'row',
        alignItems: 'center',
        flexWrap: 'wrap',
        flex: 1
    },
    orderListIcon: {
        width: ScreenUtils.scaleSize(150),
        height: ScreenUtils.scaleSize(150),
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.line_grey
    },
    orderListRight: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    updateDescStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
        marginRight: ScreenUtils.scaleSize(5)
    },
    bottomContainer: {
        width: ScreenUtils.screenW,
    },
    priceContainer: {
        width: ScreenUtils.screenW,
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: ScreenUtils.scaleSize(2),
        marginBottom: ScreenUtils.scaleSize(2),
        backgroundColor: Colors.text_white,
        paddingHorizontal: ScreenUtils.scaleSize(30),
        paddingVertical: ScreenUtils.scaleSize(20)
    },
    priceRightContainer: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    countTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(26),
    },
    countTextStyle2: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(26),
        marginLeft: ScreenUtils.scaleSize(8)
    },
    countTextStyle3: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(26),
    },
    buttonContainer: {
        width: ScreenUtils.screenW,
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.text_white,
    },
    buttonContainerRigth: {
        flexDirection: 'row',
        alignItems: 'center',
        flexWrap: 'wrap',
        paddingHorizontal: ScreenUtils.scaleSize(30),
        paddingBottom: ScreenUtils.scaleSize(30),
    },
    buttonStyleBlack: {
        borderColor: Colors.text_dark_grey,
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: ScreenUtils.scaleSize(8),
        paddingHorizontal: ScreenUtils.scaleSize(20),
        borderWidth: ScreenUtils.scaleSize(1),
        borderRadius: ScreenUtils.scaleSize(5),
        marginLeft: ScreenUtils.scaleSize(35),
        marginTop: ScreenUtils.scaleSize(30)
    },
    buttonStyleRed: {
        borderColor: Colors.main_color,
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: ScreenUtils.scaleSize(8),
        paddingHorizontal: ScreenUtils.scaleSize(20),
        borderWidth: ScreenUtils.scaleSize(1),
        marginLeft: ScreenUtils.scaleSize(35),
        borderRadius: ScreenUtils.scaleSize(5),
        marginTop: ScreenUtils.scaleSize(30)
    },
    buttonTitleStyleBlack: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(28)
    },
    buttonTitleStyleRed: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(28)
    },
    timeContainer: {
        marginLeft: ScreenUtils.scaleSize(30),
    },
    timeTitle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
    },
    timeText: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(28),
        marginTop: ScreenUtils.scaleSize(5),
    }
});
