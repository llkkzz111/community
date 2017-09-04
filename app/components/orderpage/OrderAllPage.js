/**
 * Created by zhenzhen on 2017/7/25.
 * 订单中心全部列表页面
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
import OrderCenterItem from './OrderCenterItem';
import GetOderListRequest from '../../../foundation/net/mine/GetOderListRequest';
import GetBillDetailRequest from '../../../foundation/net/mine/GetBillDetailRequest';
import NetErro from '../error/NetErro';
import OrderFootView from './OrderFootView';
import {Actions} from 'react-native-router-flux';
import {AndroidRouterModule}from '../../config/AndroidModules';
import * as RouteManager from '../../config/PlatformRouteManager';
import RnConnect from '../../config/rnConnect';
import * as routeConfig from '../../config/routeConfig'
import Datas from './Datas';
import {
    onTotalClick as TDOnTotalClick,
    goPay as TDGoPay,
    checkOrderLogistics as TDCheckOrderLogistics,
    viewFaPiao as TDViewFaPiao,
    goComment as TDGoComment,
    exchangeDetails as TDExchangeDetails
}from './OrderTdUtils';
import AllCommonDialog from '../../../foundation/dialog/AllCommonDialog';
import GetCardNumberRequest from '../../../foundation/net/order/GetCardNumberRequest';

var key = 0;
export default class OrderAllPage extends Component {
    static propTypes = {
        proc_state: PropTypes.string,
        isShowClickMore: PropTypes.bool,
    }
    static defaultProps = {
        isShowClickMore: true,
    }

    constructor(props) {
        super(props);
        this.state = {
            pageNum: 1,
            pageSize: 20,
            isShowEmpty: false,
            isRefresh: false,
            datas: [],
            isMore: true,
            reachedEnd: false,
        }
        this._renderItem = this._renderItem.bind(this);
        this._goHomePage = this._goHomePage.bind(this);
        this.itemRefs = [];
    }

    render() {
        let content = null;
        if (this.state.isShowEmpty) {
            if (this.state.datas.length > 0) {
                content = (
                    <FlatList
                        key={key}
                        data={this.state.datas}
                        renderItem={this._renderItem}
                        refreshing={this.state.isRefresh}
                        onRefresh={() => {
                            if(this.state.reachedEnd)return;
                            this.setState({
                                isRefresh: true,
                            }, () => {
                                this.refresh(false);
                            });
                        }}
                        onEndReachedThreshold={0.1}
                        onEndReached={() => {
                          this._onLoadMore()
                        }}
                        ListFooterComponent={()=>{
                            return (
                                <OrderFootView
                                    isMore={this.state.isMore}
                                    isShowClickMore={this.props.isShowClickMore}
                                    reachedEnd={this.state.reachedEnd}
                                    onLoadMore={()=>{
                                        this._onLoadMore()
                                    }}
                                />
                            );
                        }}
                    />
                );
            } else {
                content = (
                    <NetErro
                        style={{flex: 1}}
                        icon={require('../../../foundation/Img/order/img_DD_2x.png')}
                        title={'您还没有相关订单'}
                        confirmText={'去逛逛'}
                        onButtonClick={this._goHomePage}
                    />
                );
            }
        }
        return (
            <View style={styles.container}>
                {content}
                <AllCommonDialog
                    ref={(ref) => this.getCardDialog = ref}
                    titleContainer={{
                        paddingHorizontal: ScreenUtils.scaleSize(50),
                        paddingBottom: ScreenUtils.scaleSize(50)
                    }}
                    title={Datas.cardText.cancelTitle}
                    cancelText={Datas.cardText.cancelText}
                    onCancle={() => {
                        this.getCardDialog && this.getCardDialog.show(false);
                    }}
                    confirmText={Datas.cardText.confirmText}
                    onConfirm={() => {
                        this.getCardDialog && this.getCardDialog.show(false);
                        this.timer = setTimeout(() => {
                            RouteManager.routeJump({
                                page: routeConfig.GiftRecharge,
                            }, (event) => {
                            });
                        }, 600)
                    }}
                    showImage={true}
                    innerContainer={{width: ScreenUtils.screenW * 0.7}}
                />
            </View>
        );
    }

    /**
     * 渲染list
     * @param item
     * @param index
     * @returns {XML}
     * @private
     */
    _renderItem({item, index}) {
        let orderPicList = [];//图片集合
        let state = item.proc_state_str;//订单状态
        let itemOne = {};
        let isShowFapiao = item.showFapiao;
        let isShowWuliu = item.showWuliu;
        let isShowComment = item.showComment;
        let isShowExchange = item.showReturnDetails;
        let isNoPayButton = item.noPayButton;
        let goodsCount = item.order_qty;
        let orderNo = item.order_no;
        let freight = item.freight;
        let payAmt = item.pay_amt;
        let noPayAmt = item.no_pay_amt;
        let isNoPay = item.noPay;
        let currTime = item.curr_time;
        let endTime = item.end_time;
        let obtainCard = item.obtainCard;
        let showCard = item.showCard;
        //多商品的情况
        if (item.items && item.items.length > 0) {
            let items = item.items;
            items.map((picItem, index) => {
                if (index > 2) {
                    return;
                }
                orderPicList.push(picItem.contentImage);
            });
        }
        //如果只有一种商品
        if (item.items && item.items.length === 1) {
            itemOne = item.items[0];
        }
        return (
            <OrderCenterItem
                key={index}
                ref={(ref)=>{this.itemRefs.push(ref)}}
                style={{marginTop: ScreenUtils.scaleSize(20)}}
                orderNo={'' + orderNo}
                orderState={state}
                orderPicList={orderPicList}
                goodsCount={'' + goodsCount}
                title={itemOne.item_name}
                color={itemOne.dt_info}
                type={''}
                integral={'' + itemOne.save_amt}
                price={'' + itemOne.sale_price}
                payAmt={'' + payAmt}
                noPayAmt={''+noPayAmt}
                freight={''+freight}
                onItemClick={() => this._onItemClick(item)}
                isShowFapiao={isShowFapiao}
                viewFapiao={() => {
                    this._showFapiao(item)
                }}
                isShowWuliu={isShowWuliu}
                viewWuliu={() => {
                    this._viewWuliu(item)
                }}
                isShowComment={isShowComment}
                goComment={() => {
                    this._goComment(item)
                }}
                isShowExchange={isShowExchange}
                viewExchangeDetail={() => {
                    this._viewExchangeDetail(item);
                }}
                isNoPayButton={isNoPayButton}
                isNoPay={isNoPay}
                immediatePay={() => {
                    this._immediatePay(item)
                }}
                onRefresh={this.refresh.bind(this)}
                currTime={''+currTime}
                endTime={''+endTime}
                obtainCard={obtainCard}
                showCard={showCard}
                goCard={() => {
                    this._goCard(item)
                }}
                getCard={() => {
                    this._getCard(item)
                }}
            />
        )
    }

    /**
     * 渲染完毕
     */
    componentDidMount() {
        this.state.pageNum = 1;
        this._doPost(true);
    }

    /**
     *请求数据
     * @private
     */
    _doPost(showLoading = true) {
        let self = this;
        if (this.getOderListRequest) {
            this.getOderListRequest.setCancled(true);
        }
        let param = {
            proc_state: this.props.proc_state,
            page_currPageNo: this.state.pageNum,
            pageSize: this.state.pageSize,
        };
        this.getOderListRequest = new GetOderListRequest(param, 'GET');
        if (showLoading) this.getOderListRequest.showLoadingView();
        this.getOderListRequest.start((response) => {
            this.setState({
                isShowEmpty: true,
                isRefresh: false,
            });
            if (response.data && response.data.orderItems) {
                let orderItems = response.data.orderItems;
                //如果请求到的数据条数小于pagesize的话，就不需要加载更多
                // if (orderItems.length < this.state.pageSize) {
                //     this.state.isMore = false;
                // }
                if (this.state.pageNum === 1) {
                    if (orderItems.length >= 0) {
                        key++;
                        this.setState({
                            datas: orderItems
                        });
                    }
                } else {
                    if (orderItems.length > 0) {
                        self.state.datas.push(...orderItems);
                        this.setState({
                            datas: self.state.datas
                        });
                    } else {
                        if (this.state.pageNum > 1) this.state.pageNum--;
                        this.setState({
                            isMore: false,
                        });
                    }
                }
                this.setState({
                    reachedEnd: false,
                });
            }
        }, (erro) => {
            let isMore = (erro && erro.code === 0) ? false : true;
            if (!isMore && this.state.pageNum === 1) {
                this.state.datas = [];
            }
            if (this.state.pageNum > 1) this.state.pageNum--;
            this.setState({
                isShowEmpty: true,
                isRefresh: false,
                reachedEnd: false,
                isMore: isMore,
            });
        })
    }

    /**
     * 下拉刷新
     */
    refresh(refresh = false) {
        this.state.pageNum = 1;
        this.state.isMore = true;
        this._doPost(refresh);
    }

    /**
     * 上拉加载
     * @private
     */
    _onLoadMore() {
        if (!this.state.isMore || this.state.reachedEnd || this.state.isRefresh)return;
        this.state.pageNum++;
        this.setState({
            reachedEnd: true
        });
        this._doPost(false);
    }

    /**
     * 跳转到首页
     * @private
     */
    _goHomePage() {
        Actions.pop();
        setTimeout(() => {
            Actions.popTo('Home')
        }, 100);
    }

    /**
     * 点击每个item跳转到商品详情
     * @private
     */
    _onItemClick(item) {
        if (item.order_no && item.order_no.length > 0) {
            TDOnTotalClick(this.props.page, item.order_qty);
            let params = {};
            params.orderNo = item.order_no;
            params.orderType = item.items[0].order_type;
            params.cCode = item.c_code;
            params.orderStatus = item.items[0].proc_state_str;
            params.page = this.props.page;
            Actions.orderDetail(params);
        }
    }

    /**
     * 显示发票
     * @private
     */
    _showFapiao(item) {
        TDViewFaPiao(this.props.page);
        if (this.getBillDetailRequest) {
            this.getBillDetailRequest.setCancled(true);
        }
        this.getBillDetailRequest = new GetBillDetailRequest({
            order_no: item.order_no,
            order_g_seq: '001'
        }, 'GET');
        this.getBillDetailRequest.showLoadingView().start(
            (response) => {
                if (response && response.data && response.data.length >= 0) {
                    let url = response.data[0].rcpt_url;
                    if (url && url.length > 0) {
                        if (Platform.OS === 'ios') {
                            Actions.BillListDetailPage({data: url});
                        } else {
                            AndroidRouterModule.startSystemBrowser(url);
                        }
                    }
                }
            }, (erro) => {
            });
    }

    /**
     * 查看物流详情
     * @private
     */
    _viewWuliu(item) {
        TDCheckOrderLogistics(this.props.page);
        Actions.ViewLogistics({orderNo: item.order_no});
    }

    /**
     * 去评价
     * @private
     */
    _goComment(item) {
        TDGoComment(this.props.page);
        RouteManager.routeJump({
            page: routeConfig.Valuate,
            param: {orderNo: item.order_no, ordertype: item.items[0].order_type}
        }, (event) => {
            this.refresh(true);
        })
    }

    /**
     * 查看退换货详情
     * @private
     */
    _viewExchangeDetail(item) {
        TDExchangeDetails(this.props.page);
        let orderNo = item.order_no;
        let orderSeq = '';
        let code = item.c_code;
        if (item.items && item.items.length > 0) {
            orderSeq = item.items[0].o_order_g_seq;
        }
        Actions.ExchangeDetail({
            orderNo: orderNo,
            orderSeq: orderSeq,
            code: code,
            title: '退换货详情',
        });
    }

    /**
     * 立即付款
     * @private
     */
    _immediatePay(item) {
        TDGoPay(this.props.page);
        RouteManager.routeJump({
            page: routeConfig.Pay,
            param: {orders: [item.order_no]}
        }, (event) => {
            //刷新订单列表数据
            DeviceEventEmitter.emit(Datas.flags.refrushOrder, {refresh: false});
            //刷新订单详情数据
            this._doPost();
        })
    }

    /**
     *  查看卡号卡密
     * @param item
     * @private
     */
    _goCard(item) {
        RouteManager.routeJump({
            page: routeConfig.GiftRecharge,
        });
    }

    /**
     * 获取卡号卡密
     * @param item
     * @private
     */
    _getCard(item) {
        // this.getCardDialog && this.getCardDialog.show(true);
        if (this.getCardNumberRequest) {
            this.getCardNumberRequest.setCancled(true);
        }
        this.getCardNumberRequest = new GetCardNumberRequest({orderNo: item.order_no}, 'GET');
        this.getCardNumberRequest.start((response) => {
            if (response && response.data && response.data.result && response.data.result === 'OK') {
                this.refresh(false);
                this.getCardDialog && this.getCardDialog.show(true);
            }
        },(erro) => {
        })
    }

    componentWillUnMount() {
        if (this.getOderListRequest) {
            this.getOderListRequest.setCancled(true);
        }

        if (this.getBillDetailRequest) {
            this.getBillDetailRequest.setCancled(true);
        }

        if (this.timer) {
            clearTimeout(this.timer);
        }
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        flex: 1,
    },
});