/**
 * Created by YASIN on 2017/6/10.
 * 填写订单商品列表
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    ScrollView,
    FlatList
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import GoodInfo from './GoodInfo';
import {Actions}from 'react-native-router-flux';
import OrderGiftMenu from './OrderGiftMenu';
export default class OrderGoodList extends React.Component {
    static propTypes = {
        ...View.propTypes.type,
        goods: PropTypes.array.isRequired,//所有的商品信息
        totalCount: PropTypes.number
    };

    render() {
        let component = null;
        let {goods}=this.props;
        //如果只有一件商品
        if (goods && goods.length === 1) {
            component = this._renderBaseInfo();
        } else {
            component = this._renderGoodList();
        }
        return (
            <View style={[styles.container, this.props.style]}>
                {component}
            </View>
        );
    }

    /**
     * 渲染单商品的情况
     * @private
     */
    _renderBaseInfo() {
        let item = this.props.goods[0].item;
        let coupon = [];
        if (this.props.goods[0].twgiftcartVO && this.props.goods[0].twgiftcartVO.length > 0) {
            coupon.push(...this.props.goods[0].twgiftcartVO);
        }
        return (
            <TouchableOpacity
                style={{paddingBottom: ScreenUtils.scaleSize(30)}}
                activeOpacity={1}
                onPress={()=> {
                    //跳转到商品详情页面
                    {/*Actions.GoodsDetailMain({itemcode:item.item_code});*/
                    }
                }}
            >
                <GoodInfo
                    icon={{uri: item.path}}
                    title={item.item_name}
                    color={item.colour}
                    type={item.unit_code}
                    integral={item.integral}
                    count={String(item.count)}
                    weight={item.weight}
                    price={String(item.price)}
                    onlyOne={true}
                    isFirstBuy={item.eightFiveDiscount === '85' || item.eightFiveDiscount === '95'}
                    style={{borderColor: Colors.text_white, paddingBottom: 0,width:ScreenUtils.screenW}}
                />
                {(coupon.length > 0 || (item.sx_gifts && item.sx_gifts.length > 0)) ? (
                    <OrderGiftMenu
                        onlyOne={true}
                        coupous={coupon}
                        style={{
                            marginHorizontal: ScreenUtils.scaleSize(30),
                            marginBottom: ScreenUtils.scaleSize(30)
                        }}
                        otherDesc={item.sx_gifts}
                    />
                ) : null}

            </TouchableOpacity>
        );
    }

    /**
     * 多商品渲染列表
     * @private
     */
    _renderGoodList() {
        //首页三个商品
        let indexGoods = [];
        if (this.props.goods.length >= 3) {
            for (let i = 0; i < 3; i++) {
                indexGoods.push(this.props.goods[i]);
            }
        } else {
            indexGoods = this.props.goods;
        }
        return (
            <View style={{width: ScreenUtils.screenW}}>
                <View style={styles.orderListIndexContainer}>
                    <Text
                        allowFontScaling={false}
                        style={styles.orderListDesc}>商品清单</Text>
                    <View style={styles.orderListContainer}>
                        <View style={styles.orderListLeft}>
                            {indexGoods.map((good, index)=> {
                                return (
                                    <Image
                                        key={index}
                                        style={[styles.orderListIcon, index !== 0 ? {marginLeft: ScreenUtils.scaleSize(30)} : null]}
                                        source={{uri: good.item.path}}
                                    />
                                );
                            })}
                        </View>
                        <TouchableOpacity activeOpacity={1} style={styles.orderListRight} onPress={this._jumpToGoodList.bind(this)}>
                            <Text
                                allowFontScaling={false}
                                style={styles.updateDescStyle}>共{this.props.totalCount}件</Text>
                            <Image style={styles.updateIconStyle}
                                   source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>
                        </TouchableOpacity>
                    </View>

                </View>
            </View>
        );
    }

    /**
     * 多商品跳转到商品列表页面
     * @private
     */
    _jumpToGoodList() {
        // DataAnalyticsModule.trackEvent3("AP1706C017F010002A001001", "", {'itemnum' :this.props.totalCount});
        Actions.OrderGoodInfoList({goods: this.props.goods, totalCount: this.props.totalCount});
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
    },
    //订单首页如果是多商品时
    orderListIndexContainer: {
        padding: ScreenUtils.scaleSize(30)
    },
    orderListDesc: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28),
    },
    orderListContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        marginTop: ScreenUtils.scaleSize(20)
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
    updateIconStyle: {
        width: ScreenUtils.scaleSize(18),
        height: ScreenUtils.scaleSize(26)
    },
});