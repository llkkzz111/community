/**
 * created by zhenzhen
 * 退换货详情
 */

import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Platform,
    Text,
    TouchableOpacity,
    ScrollView,
    FlatList,
    Image,
} from 'react-native';
import NavigationBar from '../../../foundation/common/NavigationBar';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
import {Actions} from 'react-native-router-flux';
import OrderStatus from './details/OrderStatus';
import ExchangeStep from './details/ExchangeStep';
import ExchangeBaseInfo from './details/ExchangeBaseInfo';
import KeFuRequest from '../../../foundation/net/GoodsDetails/KeFuRequest';
import GetChangeDetail from '../../../foundation/net/mine/GetChangeDetail';
import Datas from './Datas';
export default class ExchangeReturnDetail extends Component {
    static propTypes = {
        title: PropTypes.string,
        orderNo: PropTypes.string,
    }
    static defaultProps = {
        title: '退换货详情'
    }
    // 构造
    constructor(props) {
        super(props);
        this.state = {
            stepDatas: [],//步骤数据
            baseInfo: {},//基本信息
            goodsInfo: [],//物品信息跟价格信息
            returnFlag: '',//退换货标记
        }
    }

    render() {
        return (
            <View style={styles.container}>
                {/*渲染navbar*/}
                {this._renderNavbar()}
                {/*主内容模块*/}
                <ScrollView
                    style={styles.contentContainer}
                >
                    {/*渲染头部status模块*/}
                    {this._renderStatus()}
                    {/*渲染流程信息*/}
                    {this._renderSteps()}
                    {/*渲染基本信息*/}
                    {this._renderBaseInfo()}
                    {/*联系客服按钮*/}
                    {this._renderLinking()}
                </ScrollView>
            </View>
        );
    }

    componentDidMount() {
        this._doPost();
    }

    /**
     * 渲染navbar
     * @private
     */
    _renderNavbar() {
        return (
            <NavigationBar
                title={this.props.title}
                navigationStyle={{...Platform.select({ios: {marginTop: -22}}), marginBottom: ScreenUtils.scaleSize(1)}}
                barStyle={'dark-content'}
            />
        );
    }

    /**
     * 渲染status模块
     * @private
     */
    _renderStatus() {
        let status = this.state.baseInfo.status;
        let orderTime = this.state.baseInfo.statusTime;
        if ((status && status.length > 0) || (orderTime && orderTime.length > 0)) {
            return (
                <OrderStatus
                    status={status}
                    orderTime={orderTime}
                />
            );
        }
        return null;
    }

    /**
     * 渲染退换货流程信息
     * @private
     */
    _renderSteps() {
        let title = '';
        if (this.state.returnFlag === Datas.returnFlags.returnGoodsOne || this.state.returnFlag === Datas.returnFlags.returnGoodsTwo) {
            title = '退货流程';
        } else if (this.state.returnFlag === Datas.returnFlags.exchangeGoodsOne || this.state.returnFlag === Datas.returnFlags.exchangeGoodsTwo) {
            title = '换货流程';
        }
        return (
            <ExchangeStep
                title={title}
                datas={this.state.stepDatas}
            />
        );
    }

    /**
     * 渲染基本信息
     * @private
     */
    _renderBaseInfo() {
        let title = '';
        let returnReason = this.state.baseInfo.reason;
        let returnAmount = '';
        let applyDate = this.state.baseInfo.apply_date;
        let returnNo = '';
        if (this.state.returnFlag === Datas.returnFlags.returnGoodsOne || this.state.returnFlag === Datas.returnFlags.returnGoodsTwo) {
            title = '退货流程';
        } else if (this.state.returnFlag === Datas.returnFlags.exchangeGoodsOne || this.state.returnFlag === Datas.returnFlags.exchangeGoodsTwo) {
            title = '换货流程';
        }
        if (this.state.baseInfo.return_amt) {
            returnAmount = '¥ ' + this.state.baseInfo.return_amt;
        }
        return (
            <ExchangeBaseInfo
                title={title}
                goods={this.state.goodsInfo}
                returnReason={returnReason}
                returnAmount={returnAmount}
                applyDate={applyDate}
                returnNo={returnNo}
            />
        );
    }

    /**
     * 联系客服
     * @private
     */
    _renderLinking() {
        return (
            <View style={styles.bottomContainer}>
                <View style={{width: 1}}/>
                <TouchableOpacity
                    style={styles.buttonStyleBlack}
                    onPress={this._goCustomerService.bind(this)}
                    activeOpacity={0.618}
                >
                    <Text style={styles.buttonTitleStyleBlack} allowFontScaling={false}>联系客服</Text>
                </TouchableOpacity>
            </View>
        );
    }

    /**
     * 跳转客服
     * @private
     */
    _goCustomerService() {
        if (this.contactCustomerService) {
            this.contactCustomerService.setCancled(true)
        }
        this.contactCustomerService = new KeFuRequest({
            order_no: "",
            item_code: "",
            imsource: "",
            last_sale_price: "",
        }, "GET");
        this.contactCustomerService.showLoadingView(true).start((response) => {
            if (response.code === 200 && response.data !== null && response.data.url) {
                Actions.VipPromotionGoodsDetail({value: response.data.url});
            } else {
            }
        }, (err) => {
        });
    }

    /**
     * 获取退换货详情
     * @private
     */
    _doPost() {
        let orderNo = this.props.orderNo;
        if (this.getExchangeDetail) {
            this.getExchangeDetail.setCancled(true)
        }
        this.getExchangeDetail = new GetChangeDetail({
            order_no: orderNo,
        }, "GET");
        this.getExchangeDetail.showLoadingView(true).start((response) => {
            this.setState({
                stepDatas: response.stepDatas,//步骤数据
                baseInfo: response.baseInfo,//基本信息
                goodsInfo: response.goodsInfo,//物品信息跟价格信息
                returnFlag: response.returnFlag,//退换货标记
            });
        }, (error) => {

        })
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_grey
    },
    bottomContainer: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        padding: ScreenUtils.scaleSize(30),
        alignItems: 'center',
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginTop: ScreenUtils.scaleSize(1)
    },
    buttonTitleStyleBlack: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(28)
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
});