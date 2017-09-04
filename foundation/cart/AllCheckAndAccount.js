import React, {PropTypes} from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    Platform,
} from 'react-native';
//价格明细弹窗
import PriceDetailDialog from '../../foundation/dialog/PriceDetailDialog'
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
//自适应
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
import * as Utils from './CartUtils'
export class AllCheckAndAccount extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            showPriceDialog: false,
            allSelected: this.props.allSelected,
            accountDisable: this.props.accountDisable,
            selectedShoppingArray: this.props.selectedShoppingArray,
            couponPriceData: this.props.couponPriceData,
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            allSelected: nextProps.allSelected,
            accountDisable: nextProps.accountDisable,
            selectedShoppingArray: nextProps.selectedShoppingArray,
            couponPriceData: nextProps.couponPriceData,
        });
    }

    //渲染应付价格
    renderRealPrice() {
        let totalRealPrice = 0;
        if (!Utils.isEmpty(this.state.couponPriceData) && !Utils.isEmpty(this.state.couponPriceData.total_real_price)) {
            totalRealPrice = this.state.couponPriceData.total_real_price;
        }
        return (
            <View style={styles.countViewStyle}>
                <Text style={styles.countTextStyle} allowFontScaling={false}>应付:</Text>
                <Text style={styles.countPriceTextStyle} allowFontScaling={false}>¥ {String(totalRealPrice)}</Text>
            </View>
        );
    }

    //渲染已优惠
    renderDcAmt() {
        let buySaveAmt = 0;
        let dcAmt = 0;
        if (this.state.couponPriceData !== null && this.state.couponPriceData !== undefined) {
            if (!Utils.isEmpty(this.state.couponPriceData.buysaveamt)) {
                buySaveAmt = this.state.couponPriceData.buysaveamt;
            }
            if (!Utils.isEmpty(this.state.couponPriceData.dc_amt)) {
                dcAmt = this.state.couponPriceData.dc_amt;
            }
        }
        return (
            <View style={styles.reduceViewStyle}>
                <Text style={styles.reduceTextStyle} allowFontScaling={false}>已优惠 ¥{String(dcAmt)}</Text>
                <Image source={require('../Img/searchpage/Icon_accumulate_@2x.png')} resizeMode={'cover'}
                       style={styles.accumImg}/>
                <Text style={styles.integralValueStyle} allowFontScaling={false}>{String(buySaveAmt)}</Text>
            </View>
        );
    }

    //购买商品件数
    renderTotalCount() {
        let totalCount = 0;
        if (!Utils.isEmpty(this.state.couponPriceData) && !Utils.isEmpty(this.state.couponPriceData.total_count)) {
            totalCount = this.state.couponPriceData.total_count;
        }
        return (
            <Text style={styles.toAccountTextStyle} allowFontScaling={false}> 结算({String(totalCount)})</Text>
        );
    }

    //价格详情
    renderPriceDetail() {
        DataAnalyticsModule.trackEvent2("AP1706C001F001001A001001", "");
        this.setState({showPriceDialog: true});
    }

    render() {
        let image = this.state.allSelected ?
            require('../Img/cart/selected.png') : require('../Img/cart/unselected.png');
        return (
            <View style={styles.accountViewStyle}>
                <View style={styles.allCheckViewStyle}>
                    <TouchableOpacity style={{flexDirection: 'row', height: 30, alignItems: "center"}} activeOpacity={1}
                                      onPress={() => this.props.allStoreSelected({selected: this.state.allSelected})}>
                        <View style={styles.imgViewStyle}>
                            <Image source={image} style={styles.imgStyle} resizeMode={'contain'}/>
                        </View>
                        <View style={styles.chooseViewStyle}>
                            <Text style={styles.allCheckTextStyle} allowFontScaling={false}>全选</Text>
                        </View>
                    </TouchableOpacity>
                    <TouchableOpacity style={[styles.allCheckViewStyle, {height: 30}]} activeOpacity={1}
                                      onPress={() => this.renderPriceDetail()}>
                        <View style={{flexDirection: 'row', justifyContent: 'center', alignItems: 'center'}}>
                            <Text style={styles.priceDetailTextStyle} allowFontScaling={false}>价格明细</Text>
                            <Image source={require('../Img/cart/Icon_up_grey_@3x.png')} style={styles.imgStyle2}/>
                        </View>

                    </TouchableOpacity>
                </View>
                <View style={styles.totalViewStyle}>
                    {/*渲染应付价格*/}
                    {this.renderRealPrice()}
                    {/*渲染已优惠*/}
                    {this.renderDcAmt()}
                </View>
                <TouchableOpacity activeOpacity={1} onPress={() => this.props.goToAccount()}>
                    <View style={styles.toAccountViewStyle}>
                        {/*购买商品件数*/}
                        <Image source={require("../../foundation/Img/cart/Element_waikuang_@3x.png")}
                               style={styles.gotoAccount}/>
                        {this.renderTotalCount()}
                    </View>
                </TouchableOpacity>
                {this.state.couponPriceData ?
                    <PriceDetailDialog
                        datas={this.state.couponPriceData}
                        show={this.state.showPriceDialog}
                        closeDialog={() => {
                            this.setState({showPriceDialog: false})
                        }}/> : null
                }
            </View>
        )
    }
}
const styles = StyleSheet.create({
    accountViewStyle: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        height: ScreenUtils.scaleSize(110),
        backgroundColor: "#fff",
        borderTopWidth: ScreenUtils.scaleSize(1),
        borderColor: 'rgba(200,200,200,.4)',
    },
    allCheckViewStyle: {
        flexDirection: 'row',
        flex: 1,
        alignItems: 'center',
    },
    imgViewStyle: {
        marginLeft: ScreenUtils.scaleSize(30),
    },
    imgStyle: {
        width: ScreenUtils.scaleSize(36),
        height: ScreenUtils.scaleSize(36),
    },
    imgStyle2: {
        width: ScreenUtils.scaleSize(15),
        height: ScreenUtils.scaleSize(10),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    chooseViewStyle: {
        marginLeft: ScreenUtils.scaleSize(20)
    },
    allCheckTextStyle: {
        fontSize: ScreenUtils.setSpText(26),
        color: '#4A4A4A',
    },
    totalViewStyle: {
        flexDirection: 'column',
        flex: 1,
        justifyContent: 'center',
        alignItems: 'flex-end',
        marginRight: ScreenUtils.scaleSize(20),
    },
    countViewStyle: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'flex-end',
        paddingTop: ScreenUtils.scaleSize(20),
    },
    countTextStyle: {
        fontSize: ScreenUtils.setSpText(26),
        color: '#333333'
    },
    reduceViewStyle: {
        flexDirection: 'row',
        marginBottom: ScreenUtils.scaleSize(20),
        paddingTop: ScreenUtils.scaleSize(10),
    },
    reduceTextStyle: {
        color: '#DF2928',
        fontSize: ScreenUtils.setSpText(24),
    },
    integralTextStyle: {
        height: ScreenUtils.scaleSize(32),
        width: ScreenUtils.scaleSize(32),
        backgroundColor: '#FD8606',
        alignItems: 'center',
        justifyContent: 'center',
        marginHorizontal: ScreenUtils.scaleSize(10),
        borderRadius: 2
    },
    integralValueStyle: {
        color: '#FD8606'
        , fontSize: ScreenUtils.setSpText(24),
    },
    countPriceTextStyle: {
        fontSize: ScreenUtils.setSpText(30),
        color: '#333333',
        marginLeft: ScreenUtils.scaleSize(6),
    },

    priceDetailTextStyle: {
        fontSize: ScreenUtils.setSpText(24),
        color: '#666666',
        textDecorationLine: 'underline',
        marginLeft: ScreenUtils.scaleSize(8),
    },
    toPriceDetailTextStyle: {
        fontSize: ScreenUtils.setSpText(20),
        color: '#666666',
        marginLeft: ScreenUtils.scaleSize(10),
    },
    toAccountViewStyle: {
        justifyContent: 'center',
        alignItems: 'center',
        width: ScreenUtils.scaleSize(180),
        height: ScreenUtils.scaleSize(120)

    },
    toAccountTextStyle: {
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: ScreenUtils.setSpText(30),
        color: '#FEFEFE',
        backgroundColor: "rgba(0,0,0,0)",
    },
    gotoAccount: {
        width: ScreenUtils.scaleSize(180),
        height: Platform.OS === "android" ? ScreenUtils.scaleSize(120) : ScreenUtils.scaleSize(110),
        zIndex: -1,
        position: 'absolute',
        bottom: Platform.OS === "android" ? ScreenUtils.scaleSize(0) : ScreenUtils.scaleSize(10),
        right: 0
    },
    accumImg: {
        width: ScreenUtils.scaleSize(32),
        height: ScreenUtils.scaleSize(32),
        alignItems: 'center',
        justifyContent: 'center',
        marginHorizontal: ScreenUtils.scaleSize(10),
    }
});
AllCheckAndAccount.propTypes = {
    goToAccount: PropTypes.func,
}
export default AllCheckAndAccount