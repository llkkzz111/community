/**
 * Created by YASIN on 2017/6/10.
 * 填写订单的所有物品list
 */
import React, {PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Platform,
    FlatList
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import GoodInfo from './GoodInfo';
import NavigationBar from '../../../foundation/common/NavigationBar';
import OrderGiftMenu from './OrderGiftMenu';
export default class GoodInfoList extends React.Component {
    static propTypes = {
        goods: PropTypes.array
    };

    render() {
        return (
            <View style={styles.container}>
                {/*渲染头部nav*/}
                {this._renderNavBar()}
                <FlatList
                    style={{flex: 1}}
                    data={this.props.goods}
                    renderItem={({item, index}) => {
                        let item1 = item.item;
                        let coupon = [];
                        if (item.twgiftcartVO && item.twgiftcartVO.length > 0) {
                            coupon.push(...item.twgiftcartVO);
                        }
                        return (
                            <View
                                style={[styles.itemContainer, index !== 0 ? {marginTop: ScreenUtils.scaleSize(16)} : null]}>
                                <GoodInfo
                                    key={index}
                                    icon={{uri: item1.path}}
                                    title={item1.item_name}
                                    color={item1.colour}
                                    type={item1.unit_code}
                                    integral={item1.integral}
                                    count={String(item1.count)}
                                    weight={item1.weight}
                                    price={String(item1.price)}
                                    onlyOne={false}
                                    isFirstBuy={item1.eightFiveDiscount === '85' || item1.eightFiveDiscount === '95'}
                                />
                                {(coupon.length > 0 || (item1.sx_gifts && item1.sx_gifts.length > 0)) ? (
                                    <OrderGiftMenu
                                        style={{marginHorizontal: ScreenUtils.scaleSize(26),
                                        marginBottom: ScreenUtils.scaleSize(20)}}
                                        onlyOne={true}
                                        coupous={coupon}
                                        otherDesc={item1.sx_gifts}
                                    />
                                ) : null}
                            </View>
                        );
                    }}
                    overScrollMode={'never'}
                    showsHorizontalScrollIndicator={false}
                />
            </View>
        );
    }

    /**
     * 渲染navbar
     * @private
     */
    _renderNavBar() {
        return (
            <NavigationBar
                title={'商品清单'}
                navigationStyle={{...Platform.select({ios: {marginTop: -22}})}}
                titleStyle={styles.titleTextStyle}
                barStyle={'dark-content'}
                rightText={'共' + this.props.totalCount + '件'}
                rightStyle={styles.rightNavStyle}
            />
        );
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        flex: 1,
        backgroundColor: Colors.background_grey
    },
    titleTextStyle: {
        color: Colors.text_black
    },
    rightNavStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.scaleSize(26)
    },
    itemContainer: {
        backgroundColor: Colors.text_white,
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.background_grey
    }
});