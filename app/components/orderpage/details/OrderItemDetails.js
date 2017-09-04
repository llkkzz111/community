/**
 * Created by YASIN on 2017/6/10.
 * 订单详情页面物品显示
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
    FlatList,
    TouchableWithoutFeedback
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import GoodInfo from '../GoodInfo';
import {Actions}from 'react-native-router-flux';
import {
    detailsLookMore as TDDetailsLookMore,
} from '../OrderTdUtils';
export default class OrderItemDetails extends React.Component {
    static propTypes = {
        ...View.propTypes,
        datas: PropTypes.array,
        orderNo: PropTypes.string,
        isShowAllReturn: PropTypes.bool,

        onAllReturnClick: PropTypes.func,
        onReturnClick: PropTypes.func,
        onExchangeClick: PropTypes.func,
        onInstallClick: PropTypes.func,
        onSendClick: PropTypes.func,
        onExchangeDetails: PropTypes.func
    };
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isShowMore: (this.props.datas && this.props.datas.length > 2),
        };
    }

    componentWillReceiveProps(nextProps) {
        this.state.isShowMore = (nextProps.datas && nextProps.datas.length > 2);
    }

    render() {
        let items = [];
        if (this.props.datas && this.props.datas.length > 2 && this.state.isShowMore) {
            items = this.props.datas.slice(0, 2);
        } else {
            items = this.props.datas;
        }
        return (
            <View style={[styles.itemContainer, this.props.style]}>
                <View style={styles.itemNoContainer}>
                    <Text style={styles.orderNoText} allowFontScaling={false}>订单编号: {this.props.orderNo}</Text>
                    {!!this.props.isShowAllReturn ? (
                        <TouchableOpacity style={styles.allReturnStyle} onPress={this.props.onAllReturnClick}>
                            <Text style={{fontSize: ScreenUtils.scaleSize(26), color: Colors.text_light_grey}}
                                  allowFontScaling={false}>整单退货</Text>
                        </TouchableOpacity>
                    ) : null}
                </View>
                <FlatList
                    style={styles.itemListContainer}
                    data={items}
                    renderItem={({item, index}) => {
                        let icon = item.contentLink;
                        let title = item.item_name;
                        let color = item.dt_info;
                        let integral = item.itemSaveamt;
                        let count = item.item_qty;
                        let price = item.rsale_amt;
                        let coupous = [];//[{item_name: '赠品1'}, {item_name: '赠品2'}, {item_name: '赠品3'}, {item_name: '赠品4'}]
                        let otherDesc = [];//['11','11'],
                        let itemCode = item.item_code;
                        let isShowReturn = item.isShowReturn;
                        let isShowExchange = item.isShowExchange;
                        let isShowInstall = item.isShowInstall;
                        let isShowSend = item.isShowSend;
                        let isShowExchangeDetails = item.isShowReturnDetails;
                        return (
                            <TouchableOpacity
                                onPress={() => {
                                    Actions.GoodsDetailMain({itemcode: itemCode});
                                }}
                                activeOpacity={0.8}
                            >
                                <GoodInfo
                                    style={styles.itemStyle}
                                    icon={{uri: icon}}
                                    title={title}
                                    color={color}
                                    integral={integral}
                                    count={count}
                                    price={price}
                                    onlyOne={false}
                                    coupous={coupous}
                                    otherDesc={otherDesc}
                                    isShowReturn={isShowReturn}
                                    onReturnClick={() => {
                                        this.props.onReturnClick && this.props.onReturnClick(item);
                                    }}
                                    isShowExchange={isShowExchange}
                                    onExchangeClick={() => {
                                        this.props.onExchangeClick && this.props.onExchangeClick(item);
                                    }}
                                    isShowInstall={isShowInstall}
                                    onInstallClick={() => {
                                        this.props.onInstallClick && this.props.onInstallClick(item);
                                    }}
                                    isShowSend={isShowSend}
                                    onSendClick={() => {
                                        this.props.onSendClick && this.props.onSendClick(item);
                                    }}
                                    isShowExchangeDetails={isShowExchangeDetails}
                                    onExchangeDetails={() => {
                                        this.props.onExchangeDetails && this.props.onExchangeDetails(item);
                                    }}
                                />
                            </TouchableOpacity>
                        );
                    }}
                    ItemSeparatorComponent={(item)=> {
                        return (
                                    <View style={styles.lineStyle}/>
                               )
                    }}
                />
                {/*还有多少件*/}
                {this.state.isShowMore ? (
                    <TouchableOpacity
                        style={styles.moreContainer}
                        activeOpacity={0.8}
                        onPress={() => {
                            TDDetailsLookMore(this.props.page);
                            this.setState({
                                isShowMore: false
                            });
                        }}
                    >
                        <Text>{`还有${this.props.datas.length - 2}件`}</Text>
                        <Image style={styles.arrowDownStyle}
                               source={require('../../../../foundation/Img/shoppingPage/Icon_down_.png')}/>
                    </TouchableOpacity>
                ) : null}
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
    },
    itemNoContainer: {
        flexDirection: 'row',
        padding: ScreenUtils.scaleSize(30),
        alignItems: 'center',
        backgroundColor: Colors.text_white,
        justifyContent: 'space-between',
        borderBottomColor: Colors.line_grey,
        borderBottomWidth: ScreenUtils.scaleSize(1)
    },
    orderNoText: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
    },
    itemListContainer: {
        width: ScreenUtils.screenW,
        backgroundColor: 'white'
    },
    itemStyle: {
        marginTop: ScreenUtils.scaleSize(1),
        backgroundColor: Colors.text_white
    },
    moreContainer: {
        width: ScreenUtils.screenW,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: Colors.text_white,
        padding: ScreenUtils.scaleSize(20),
        marginTop: ScreenUtils.scaleSize(1)
    },
    arrowDownStyle: {
        width: ScreenUtils.scaleSize(20),
        height: ScreenUtils.scaleSize(14),
        resizeMode: 'stretch',
        marginLeft: ScreenUtils.scaleSize(10)
    },
    allReturnStyle: {
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: Colors.background_grey,
        borderRadius: ScreenUtils.scaleSize(3),
        paddingHorizontal: ScreenUtils.scaleSize(20),
        paddingVertical: ScreenUtils.scaleSize(10),
    },
    lineStyle: {
        backgroundColor: Colors.background_grey,
        height: ScreenUtils.scaleSize(1),
        alignSelf: 'center',
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(60),
        marginTop: ScreenUtils.scaleSize(10),
    },
});