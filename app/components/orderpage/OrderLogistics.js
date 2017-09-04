/**
 * Created by pactera on 2017/7/31.
 *
 * 订单中心物流详情页
 */

'use strict';
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Text,
    Platform,
    Image,
    ScrollView
} from 'react-native';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
import NavigationBar from '../../../foundation/common/NavigationBar';
import GetLogisticsDetail from '../../../foundation/net/mine/GetLogisticsDetail'
import OrderLogisticsItem from './OrderLogisticsItem'
import NetErro from '../error/NetErro';

export default class OrderLogistics extends Component {
    static propTypes = {
        orderNo: PropTypes.string,
    }

    constructor(props) {
        super(props);
        this.state = {
            logistics: [],
            statusData: null,
            deliverData: null,
            isShowEmpty: false,
        }

    }

    render() {
        let content = null;
        if (this.state.isShowEmpty) {
            if (this.state.logistics.length > 0) {
                content = (
                    <ScrollView
                        style={styles.contentContainer}
                    >
                        {/*渲染订单物流状态*/}
                        {this._OrderLogisticsStatus()}
                        {/*渲染快递员信息*/}
                        {this._delivererMessage()}
                        {/*渲染物流跟踪信息*/}
                        {this._logisticsTrack()}
                    </ScrollView>
                )
            } else {
                content = (
                    <NetErro
                        style={{flex: 1}}
                        icon={require('../../../foundation/Img/order/img_DD_2x.png')}
                        title={'暂无相关物流信息'}
                    />
                );
            }
        }
        return (
            <View style={styles.container}>
                {/*渲染navbar*/}
                {this._renderNavBar()}
                {content}
            </View>
        )
    }


    /**
     * 渲染navbar
     * @private
     */
    _renderNavBar() {
        return (
            <NavigationBar
                title={'查看物流'}
                navigationStyle={{...Platform.select({ios: {marginTop: -22}}),marginBottom:ScreenUtils.scaleSize(1)}}
                titleStyle={{
                    color: Colors.text_black,
                    backgroundColor: 'transparent',
                    fontSize: ScreenUtils.scaleSize(36)
                }}
                barStyle={'dark-content'}
            />
        );
    }

    /**
     * 渲染订单物流状态
     * @private
     */
    _OrderLogisticsStatus() {
        if (this.state.statusData !== null) {
            let company = this.state.statusData.company;
            let waybill = this.state.statusData.waybill;
            let phoneNumber = this.state.statusData.phoneNumber;
            return (
                <View style={styles.topContainer}>
                    <Image style={styles.goodsImg} source={{uri: 'https://facebook.github.io/react/img/logo_og.png'}}/>
                    <View style={styles.logisticsStatusView}>
                        <Text
                            style={styles.logisticsStatusText}
                            allowFontScaling={false}>
                            物流状态：
                            <Text style={styles.logisticsStatus} allowFontScaling={false}>
                                {this.state.statusData.logisticsStatus}
                            </Text>
                        </Text>
                        <Text style={styles.logisticsText} allowFontScaling={false}>物流公司：{company}</Text>
                        <Text style={styles.logisticsText} allowFontScaling={false}>运单编号：{waybill}</Text>
                        <Text style={styles.logisticsText} allowFontScaling={false}>官方电话：{phoneNumber}</Text>
                    </View>
                </View>
            );
        }
        return null;
    }

    /**
     * 渲染快递员信息
     * @private
     */
    _delivererMessage() {
        if (this.state.deliverData !== null) {
            let name = this.state.deliverData.name;
            let phoneNumber = this.state.deliverData.phoneNumber;
            return (
                <View style={styles.middleContainer}>
                    <Image style={styles.delivererImg}
                           source={{uri: 'https://facebook.github.io/react/img/logo_og.png'}}/>
                    <View style={styles.delivererMessageView}>
                        <Text style={styles.delivererMessageText} allowFontScaling={false}>派送员：{name}</Text>
                        <Text style={styles.delivererMessageText} allowFontScaling={false}>电话：{phoneNumber}</Text>
                    </View>
                </View>
            );
        }
        return null;
    }

    /**
     * 渲染物流跟踪信息
     * @private
     */
    _logisticsTrack() {
        let {logistics} = this.state;
        if (logistics && logistics.length > 0) {
            return (
                <View style={styles.bottomOuterContainer}>
                    <View style={styles.titleView}>
                        <Text style={styles.title} allowFontScaling={false}>物流跟踪</Text>
                    </View>
                    <View style={styles.bottomContainer}>
                        {logistics.map((item, index) => {
                            let title = item.detail;
                            let desc = '';
                            if (item.date) {
                                desc += item.date;
                            }
                            if (item.time) {
                                desc += ' ' + item.time;
                            }
                            let circleStyle = {backgroundColor: Colors.orderLine};
                            let lineStyle = {backgroundColor: Colors.orderLine};
                            let titleStyle = {color: Colors.orderLine};
                            let descStyle = {color: Colors.text_dark_grey};
                            return (
                                <OrderLogisticsItem
                                    key={index}
                                    title={title}
                                    desc={desc}
                                    circleStyle={circleStyle}
                                    lineStyle={lineStyle}
                                    titleStyle={titleStyle}
                                    descStyle={descStyle}
                                    lineShow={index !== logistics.length - 1}
                                />
                            );
                        })}
                    </View>
                </View>
            );
        }
        return null;
    }

    componentDidMount() {
        this._doPost();
    }

    /**g
     * 请求物流接口
     * @private
     */
    _doPost() {
        if (this.getLogisticsDetail) {
            this.getLogisticsDetail.setCancled(true);
        }
        this.getLogisticsDetail = new GetLogisticsDetail({order_no: this.props.orderNo}, 'GET');
        this.getLogisticsDetail.showLoadingView().setShowMessage(true).start(
            (response) => {
                if (response) {
                    this.setState({
                        logistics: response.logistics,
                        statusData: response.statusData,
                        deliverData: response.deliverData,
                        isShowEmpty: true
                    });
                }
            }, (erro) => {
                this.setState({
                    isShowEmpty: true
                })
            });
    }

    componentWillUnMount() {
        if (this.getLogisticsDetail) {
            this.getLogisticsDetail.setCancled(true);
        }
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        flex: 1,
        backgroundColor: Colors.background_grey
    },
    contentContainer: {
        flex: 1,
        width: ScreenUtils.screenW,
    },
    topContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        width: ScreenUtils.screenW,
        padding: ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(2),
        backgroundColor: Colors.background_white,
    },
    goodsImg: {
        width: ScreenUtils.scaleSize(180),
        height: ScreenUtils.scaleSize(180),
    },
    logisticsStatusView: {
        marginLeft: ScreenUtils.scaleSize(22),
        justifyContent: 'space-between',
        flex: 1
    },
    logisticsStatusText: {
        fontSize: ScreenUtils.setSpText(32),
        color: Colors.text_black,
        paddingVertical: ScreenUtils.scaleSize(5)
    },
    logisticsStatus: {
        fontSize: ScreenUtils.setSpText(32),
        color: '#27CB43'
    },
    logisticsText: {
        fontSize: ScreenUtils.setSpText(28),
        color: Colors.text_dark_grey,
        paddingVertical: ScreenUtils.scaleSize(5)

    },
    middleContainer: {
        marginTop: ScreenUtils.scaleSize(20),
        flexDirection: 'row',
        alignItems: 'center',
        width: ScreenUtils.screenW,
        padding: ScreenUtils.scaleSize(30),
        backgroundColor: Colors.background_white,
    },
    delivererImg: {
        width: ScreenUtils.scaleSize(100),
        height: ScreenUtils.scaleSize(100)
    },
    delivererMessageView: {
        marginLeft: ScreenUtils.scaleSize(30)
    },
    delivererMessageText: {
        fontSize: ScreenUtils.scaleSize(32),
        color: Colors.text_black,
        paddingVertical: ScreenUtils.scaleSize(5)
    },
    bottomOuterContainer: {
        marginTop: ScreenUtils.scaleSize(20),
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_grey,
    },
    bottomContainer: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_white,
        padding: ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(1),
    },
    titleView: {
        backgroundColor: Colors.background_white,
        padding: ScreenUtils.scaleSize(30)
    },
    title: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(32),
    },
});