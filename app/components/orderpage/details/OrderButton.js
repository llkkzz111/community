/**
 * Created by pactera on 2017/7/27.
 */
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Text,
    TouchableOpacity
} from 'react-native';
import Colors from '../../../config/colors';
import TimerMixin from 'react-timer-mixin';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

export default class OrderButton extends Component {
    static propTypes = {
        isNoPay: PropTypes.bool,//实付款还是待支付
        isShowFapiao: PropTypes.bool,//是否显示发票按钮
        isShowWuliu: PropTypes.bool,//是否显示物流
        isShowComment: PropTypes.bool,//是否显示评价按钮
        isShowCancel: PropTypes.bool,//是否显示取消订单
        viewFapiao: PropTypes.func,
        viewWuliu: PropTypes.func,
        goComment: PropTypes.func,
        immediatePay: PropTypes.func,
        onCancleClick: PropTypes.func,
        currTime: PropTypes.string,
        endTime: PropTypes.string,
    }
    static defaultProps = {
        isNoPay: false,
        isShowFapiao: false,
        isShowComment: false,
        isShowWuliu: false,
        isShowCancel: false
    }

    constructor(props) {
        super(props);
        this.state = {
            times: [],
        }
    }


    render() {
        return (
            <View style={styles.container}>
                {this._renderBottom()}
            </View>
        );
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
        if (!!this.props.isShowCancel) {
            buttons.push(this._renderButton(styles.buttonStyleBlack, '取消订单', styles.buttonTitleStyleBlack, this.props.onCancleClick));
        }
        if (!!this.props.isShowComment) {
            buttons.push(this._renderButton(styles.buttonStyleRed, '去评价', styles.buttonTitleStyleRed, this.props.goComment));
        }
        if (!!this.props.isNoPay) {
            buttons.push(this._renderButton(styles.buttonStyleRed, '立即付款', styles.buttonTitleStyleRed, this.props.immediatePay));
        }
        if (buttons.length > 0) {
            return (
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
            );
        }
        return null;
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
        if (currTime !== NaN && endTime !== NaN) {
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
                        times: '',
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
        flex: 1,
    },
    buttonContainer: {
        width: ScreenUtils.screenW,
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: Colors.text_white,
        marginTop: ScreenUtils.scaleSize(20),
    },
    buttonContainerRigth: {
        flexDirection: 'row',
        alignItems: 'center',
        flexWrap: 'wrap',
        padding: ScreenUtils.scaleSize(30)
    },
    buttonStyleBlack: {
        borderColor: Colors.text_dark_grey,
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: ScreenUtils.scaleSize(8),
        paddingHorizontal: ScreenUtils.scaleSize(20),
        borderWidth: ScreenUtils.scaleSize(1),
        borderRadius: ScreenUtils.scaleSize(5),
        marginLeft: ScreenUtils.scaleSize(35)
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
    },
});