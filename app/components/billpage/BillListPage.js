/**
 * @author Xiang
 *
 * 发票列表
 */
import {
    StyleSheet,
    View,
    Text,
    TouchableOpacity,
    Dimensions,
    FlatList,
    Image,
    Platform,
} from 'react-native';
import {
    Component,
    PureComponent,
    React,
    ScreenUtils,
    NavigationBar,
    Actions,
    NetErro,
    DataAnalyticsModule,
} from '../../config/UtilComponent';

import GetBillListRequest from '../../../foundation/net/mine/GetBillListRequest'
import GetAllBillListRequest from '../../../foundation/net/mine/GetAllBillListRequest';
import ModalDropdown from '../../../foundation/common/ModalDropdown'

const width = Dimensions.get('window').width;
const Com = __DEV__ ? Component : PureComponent;
const selects = ['one', 'three', 'six', 'halfYearAgo'];
var key = 0;
export default class BillListPage extends Com {
    constructor(props) {
        super(props);
        this.state = {
            time: 'one',
            pageNum: 1,
            pageSize: 20,
            BillData: [],
            isShowEmpty:false,
        };
        this._getAllBillListRequest = this._getAllBillListRequest.bind(this)

    }

    componentDidMount() {
        this._getAllBillListRequest();
        DataAnalyticsModule.trackEvent('AP1706C047F008001O008001');//查看电子发票
        DataAnalyticsModule.trackEvent('AP1706C048F008001O008001');//查看纸质发票
    }


    _getAllBillListRequest() {
        let self = this;
        if (this.getAllBillListR) {
            this.getAllBillListR.setCancled(true);
        }
        let rbody = {
            time: this.state.time,
            pageNum: this.state.pageNum,
            pageSize: this.state.pageSize,
        };
        this.getAllBillListR = new GetAllBillListRequest(rbody, 'GET');
        this.getAllBillListR.showLoadingView().setShowMessage(true).start(
            (response) => {
                this.setState({
                    isShowEmpty:true,
                })
                if (response.code === 200 && response.data && response.data.invoiceList) {
                    if (this.state.pageNum === 1) {
                        key++;
                        if (response.data.invoiceList.length >= 0) {
                            self.setState({
                                BillData: response.data.invoiceList,
                            });
                        }
                    } else {
                        if (response.data.invoiceList.length > 0) {
                            let BillDa = this.state.BillData;
                            BillDa.push(...response.data.invoiceList);
                            self.setState({
                                BillData: BillDa,
                            });
                        } else {
                            this.state.pageNum--;
                        }
                    }
                }
            }, (erro) => {
                this.setState({
                    isShowEmpty:true,
                })
                if (this.state.pageNum !== 1) {
                    this.state.pageNum--;
                }
            });
    }


    /**
     * 渲染导航栏
     * @private
     */
    _renderNav() {
        return (
            <NavigationBar
                barStyle={'dark-content'}
                renderTitle={() => {
                    return (
                        <ModalDropdown options={['近一个月的订单', '近三个月的订单', '近半年内的订单', '半年前的订单']}
                                       defaultValue="近一个月的订单"
                                       dropdownStyle={{
                                           marginLeft: Platform.OS === 'ios' ? (-(width / 2) + ScreenUtils.scaleSize(120)) : (-(width / 2) + ScreenUtils.scaleSize(140)),
                                           width: width + ScreenUtils.scaleSize(20),
                                           alignItems: 'center',
                                           backgroundColor: 'white',
                                           position: 'absolute',
                                           height: (40 + StyleSheet.hairlineWidth) * 4,
                                           borderWidth: StyleSheet.hairlineWidth,
                                           borderColor: 'lightgray',
                                           borderRadius: 2,
                                           justifyContent: 'center'
                                       }}
                                       showsVerticalScrollIndicator={false}
                                       dropdownTextStyle={{
                                           fontSize: 15,
                                           color: '#333333'
                                       }}
                                       textStyle={{
                                           paddingHorizontal: 6,
                                           paddingVertical: 10,
                                           fontSize: 17,
                                           color: '#333333',
                                           backgroundColor: 'white',
                                           textAlignVertical: 'center'
                                       }}
                                       onSelect={(idx, value) => this._dropdownSelect(idx, value)}
                        />
                    );
                }}
                onLeftPress={() => {
                    DataAnalyticsModule.trackEvent('AP1706C047C005001C003001');
                    DataAnalyticsModule.trackEvent('AP1706C048C005001C003001');//纸质
                    Actions.pop();
                }}
            />
        );


    }

    // 选择发票时间
    _dropdownSelect(idx, value) {
        DataAnalyticsModule.trackEvent('AP1706C047C005001A001001');//电子
        DataAnalyticsModule.trackEvent('AP1706C048C005001A001001');//纸质
        //  time	one 30天 two 60天 three 90天 six 180天 halfYearAgo 半年以前
        this.state.time = selects[parseInt(idx)];
        this.state.pageNum = 1;
        this._getAllBillListRequest();

    }

    //主render
    render() {
        let datas = this.state.BillData;
        let content=null;
        if(this.state.isShowEmpty){
            if(datas.length>0){
                content=(
                    <View style={{flex: 1}}>
                        <FlatList
                            key={key}
                            data={datas}
                            renderItem={this._renderItem.bind(this)}
                            onEndReachedThreshold={0.1}
                            onEndReached={() => {
                                this.state.pageNum++;
                                this._getAllBillListRequest();
                            }}
                        >
                        </FlatList>
                    </View>
                );
            }else{
                content=(<NetErro
                    style={{flex: 1}}
                    icon={require('../../../foundation/Img/order/img_DD_2x.png')}
                    title={'当前没有发票信息！'}
                />);
            }
        }
        return (
            <View style={styles.orderCenter}>
                {/*头部导航栏*/}
                {this._renderNav()}
                <View style={{width: width, height: 1, backgroundColor: '#DDDDDD'}}/>
                {/*显示发票列表*/}
                {content}
            </View>
        )
    }

    // render UI 组件
    _renderItem(item) {
        return (
            <View style={styles.orderBox}>
                <View style={styles.orderHead}>
                    <View style={styles.orderStatus}>
                        <Text style={[styles.commonStyle, styles.orderLabel]} allowFontScaling={false}>订单编号</Text>
                        <Text style={[styles.commonStyle, styles.orderNumber]}
                              allowFontScaling={false}>{item.item.order_no}</Text>
                    </View>

                    {item.item.tidingYn === 'Y' ?
                        <Text style={styles.orderCallViewText}>需纸质发票，请至官网下载</Text>
                        :
                        <View/>
                    }

                </View>
                <View style={styles.orderBottom}>
                    {this._renderGoods(item.item, item.item.order_no)}
                </View>
            </View>
        )
    }


    // 渲染 商品UI
    _renderGoods(item, orderNo) {

        return (
            <View >
                <TouchableOpacity
                    activeOpacity={1}
                    // onPress={this.goOrderDetail}
                    style={styles.delivery}>

                    {/*商品图片*/}
                    <View style={styles.deliveryLeft}>
                        <Image style={styles.goodsImgs}
                               source={{uri: item.itemImage}}/>
                    </View>

                    {/*商品详细内容*/}
                    <View style={styles.deliveryRight}>

                        {/*商品名字*/}
                        <Text style={styles.deliveryTitle}
                              numberOfLines={2} allowFontScaling={false}>{item.item_name}</Text>

                        {/*商品规格*/}
                        {(item.dtInfo) ?
                            <Text style={{color: '#999999', fontSize: 13}} allowFontScaling={false}>{item.dtInfo}</Text>
                            :
                            null
                        }

                        {/*商品价格和积分*/}
                        <View style={styles.deliveryPrice}>
                            <View style={styles.deliveryPriceLeft}>

                                {item.sum_amt ?
                                    <Text style={{color: 'red', marginTop: 5, fontSize: 12}}
                                          allowFontScaling={false}>￥</Text>
                                    :
                                    null
                                }
                                {item.sum_amt ?
                                    <Text
                                        style={[styles.colorRed, styles.amountPrice]}
                                        allowFontScaling={false}>{item.sum_amt}</Text>
                                    :
                                    null
                                }


                                {/*积分显示*/}
                                {(item.saveamt !== "") && (item.saveamt) && (item.saveamt !== '0') ?
                                    <View style={{flexDirection: 'row'}}>
                                        <Image style={{marginTop: 3, marginLeft: 5, marginRight: 5}}
                                               source={require('../../../foundation/Img/home/Icon_accumulate_@2x.png')}/>
                                        <Text style={{
                                            color: '#FFC033',
                                            fontSize: 14,
                                            marginTop: 3
                                        }} allowFontScaling={false}>{item.saveamt}</Text>
                                    </View> : null}
                            </View>


                            <Text allowFontScaling={false}> x
                                <Text allowFontScaling={false}>{item.order_qty}</Text></Text>
                        </View>
                    </View>
                </TouchableOpacity>
                {this.orderType(item, orderNo)}
            </View>
        );

    }

    // 判断是否显示  发票详情字样
    orderType(item, orderNo) {
        if (item.invoiceDetailYn === 'Y') {
            return (
                <View style={styles.payBottom}>
                    <View style={styles.orderPriceLeft}>
                    </View>
                    <View style={styles.orderPriceRight}>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                DataAnalyticsModule.trackEvent('AP1706C047F012001O006001');
                                this.goElectronBill(item, orderNo)
                            }}
                        >
                            <Text style={styles.btnCommonStyle} allowFontScaling={false}>发票详情</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            )
        } else {
            return null;
        }
    }

    //查看电子发票
    goElectronBill(item, orderNo) {
        Actions.ElectronBillpage({order_no: orderNo, order_g_seq: item.order_g_seq});
    }

}
const styles = StyleSheet.create({
    orderCenter: {
        flex: 1,
        backgroundColor: '#ededed',
        ...Platform.select({
            ios: {
                marginTop: -22
            }
        })
    },
    orderBox: {
        width: width,
        backgroundColor: "#FFFFFF",
        marginTop: 10
    },
    orderHead: {
        flexDirection: "row",
        paddingRight: 15,
        paddingLeft: 15,
        height: 45,
        alignItems: "center",
        justifyContent: "space-between",
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",

    },
    orderStatus: {
        flexDirection: "row",
    },
    orderCallView: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    orderCallViewImage: {
        width: ScreenUtils.scaleSize(28),
        height: ScreenUtils.scaleSize(28),
        marginRight: ScreenUtils.scaleSize(10),
    },
    orderCallViewText: {
        fontSize: ScreenUtils.setSpText(24),
        color: '#666',
    },
    commonStyle: {
        fontSize: 13,
        color: "#666666"
    },
    orderNumber: {
        marginLeft: 5
    },
    orderComon: {
        color: "#df2928",
        fontSize: 13,
    },
    orderBottom: {},
    orderImg: {
        width: width,
        flexDirection: "row",
        justifyContent: "space-between",
        padding: 15,
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",
    },
    orderImgLft: {
        flexDirection: "row",
    },
    imgStyles: {
        width: 80,
        height: 80,
        marginRight: 8,
        borderRadius: 5
    },
    orderImgRight: {
        width: 80,
        alignItems: "flex-end",
        justifyContent: "center"
    },
    orderPrice: {
        padding: 15,
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",
        alignItems: "flex-end",
    },
    priceSnum: {
        color: "#151515"
    },
    payBottom: {
        flexDirection: "row",
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",
        justifyContent: "space-between",
        height: 60,
        paddingLeft: 15,
        paddingRight: 15,
        alignItems: "center"
    },
    orderPriceLeft: {},
    orderPriceRight: {
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "center"
    },
    btnCommonStyle: {
        borderRadius: 5,
        borderWidth: 0.5,
        alignSelf: "center",
        paddingRight: 10,
        paddingLeft: 10,
        paddingTop: 5,
        paddingBottom: 5,
        marginLeft: 10
    },
    logisticsBottom: {
        color: "#333333",
        borderColor: "#999999",
    },
    paymentBottom: {
        color: "#e5290d",
        borderColor: "#e5290d",
    },
    restTime: {},
    countdown: {
        color: "#e5290d"
    },
    // 待发货
    delivery: {
        width: width,
        flexDirection: "row",
        padding: 15,
        borderBottomWidth: 0.5,
        borderBottomColor: "#dddddd",
    },
    deliveryLeft: {
        width: 80,
        height: 80
    },
    goodsImgs: {
        width: 80,
        height: 80
    },
    deliveryRight: {
        justifyContent: "flex-start",
        marginLeft: 10,
        flex: 1
    },
    deliveryTitle: {
        flexWrap: 'wrap',
        flex: 1,
    },
    deliveryPrice: {
        flexDirection: "row",
        justifyContent: "space-between"
    },
    deliveryPriceLeft: {
        flexDirection: "row"
    },
    colorRed: {
        color: "#e5290d",
    },
    amountPrice: {
        fontSize: 16,
    },
    integration: {
        fontSize: 10,
        backgroundColor: "#ffc033",
        color: "#FFF",
        height: 14,
        alignSelf: "center",
        paddingLeft: 2,
        paddingRight: 2,
        marginLeft: 4,
        marginRight: 3,
        borderRadius: 5,
    },
    payBottomRight: {
        flexDirection: "row",
        justifyContent: "flex-end"
    }
});
