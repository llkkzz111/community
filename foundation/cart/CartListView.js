/**
 * Created by Zhang.xinchun on 2017/5/10.
 * 购物车的列表组件
 */
import React, {
    PropTypes
} from 'react';

import {
    View,
    ScrollView,
    Dimensions,
    RefreshControl,
    TouchableOpacity,
    StyleSheet,
    Text
} from 'react-native';
//购物车组件
import GiftMenu from './GiftMenu';
import ShoppingRender from './ShoppingRender'
import Immutable from 'immutable'
import SectionHeaderRender from './SectionHeaderRender'
//常量定义
import * as Constants from '../../app/constants/Constants'
//自适应
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
import Swipeable from '../common/Swipeable';
/**
 * ListView that renders SwipeRows.
 */
//购物车中信息展示的组件
const {height} = Dimensions.get('window');

class CartListView extends React.PureComponent {
    constructor(props) {
        super(props);
        //被选中的列表
        this.shoppingArray = [];
        this.state = {
            datas: this.props.dataSource,//购物车列表数据
            currentlyOpenSwipeable: null,//滑动的状态互斥
            swipe: false,
            editedData: false,
        }
    }

    //刷列表数据
    componentWillReceiveProps(nextProps) {
        this.setState({
            datas: nextProps.dataSource,
            cartType: nextProps.cartType,
        })
        if (this.state.currentlyOpenSwipeable) {
            //关闭swipe
            this.state.currentlyOpenSwipeable.recenter();
        }
    }

    shouldComponentUpdate(nextProps, nextState) {
        return ((this.state.swipe !== nextState.swipe)
        || (this.props.cartType !== nextProps.cartType)
        || !(Immutable.is(this.props.dataSource, nextProps.dataSource)));
    }

    //滚动时关闭swipe
    handleScroll = () => {
        if (this.state.currentlyOpenSwipeable) {
            this.state.currentlyOpenSwipeable.recenter();
        }
    };

    //渲染各商铺的标题内容
    renderStoreTitleView(cars, itemProps) {
        // console.log("==渲染各商铺");
        return (
            cars.shop.map((item, index) => {
                // console.log("商铺的标题")
                this.shoppingArray = [];
                this.props.storeArray.set(item.ven_code, this.shoppingArray);
                return (
                    <View key={index}>

                        <View style={{height: ScreenUtils.scaleSize(20), backgroundColor: '#ededed'}}/>
                        <SectionHeaderRender
                            cartType={this.props.cartType}
                            sectionHeaderData={item}
                            shoppingItemsByStore={this.props.storeArray}
                            onStoreSelected={(venCode) => this.props.onStoreSelected(venCode)}
                        />
                        {this.renderShopContent(item.cart_items_info, index, {...itemProps})}
                    </View>
                );
            })
        )
    }

    //渲染商品内容
    renderShopContent(shops, j, {onOpen, onClose}) {
        // console.log("==渲染商品内容");
        return (
            shops.map((item, index) => {
                // console.log("渲染商品")
                this.shoppingArray.push(item.cart_seq);
                this.props.allShoppingArray.push(item.cart_seq);
                if (item.check_cart_yn === Constants.Selected) {
                    this.props.selectedShoppingArray.push(item);
                    this.props.selectedCartSeqs.push(item.cart_seq)
                }
                let marginTop = index === 0 ? 20 : 0;
                return (
                    <View key={j + '#' + index} style={{backgroundColor: 'white'}}>
                        {(item.item_status === 1 || item.item_status === 2) && index !== 0 &&
                        <View style={{height: ScreenUtils.scaleSize(20), backgroundColor: '#dddddd'}}/>}
                        <View style={{marginTop: marginTop}}>
                            <View>
                                <Swipeable
                                    rightButtons={[
                                        <TouchableOpacity activeOpacity={1} style={styles.backRightBtnRightColl}
                                                          onPress={() => {
                                                              this.props.onCollection({
                                                                  cart_seq: item.cart_seq,
                                                                  item_code: item.item_code,
                                                              });
                                                          }}>
                                            <Text style={styles.backTextGary} allowFontScaling={false}>移入</Text>
                                            <Text style={styles.backTextGary} allowFontScaling={false}>收藏</Text>
                                        </TouchableOpacity>,
                                        <TouchableOpacity activeOpacity={1} style={styles.backRightBtnRight}
                                                          onPress={() => {
                                                              this.props.onDelete({
                                                                  cart_seq: item.cart_seq,
                                                                  item_code: item.item_code,
                                                              });
                                                          }}>
                                            <Text style={styles.backTextWhite} allowFontScaling={false}>删除</Text>
                                        </TouchableOpacity>
                                    ]}
                                    //划开与关闭
                                    onRightButtonsOpenRelease={onOpen}
                                    onRightButtonsCloseRelease={onClose}
                                    onSwipeMove={() => {
                                        this.setState({swipe: true})
                                    }}
                                    onSwipeRelease={() => {
                                        this.setState({swipe: false})
                                    }}>
                                    <ShoppingRender
                                        dataSource={item}
                                        cartType={this.props.cartType}
                                        cancelChange={(seq) => this.props.cancelChange(seq)}
                                        onSubmitEditing={(data) => this.props.onSubmitEditing({
                                            cart: data,
                                            storeIndex: j,
                                            shopIndex: index,
                                            shopCnt: item.item_qty
                                        })}
                                        onAdd={(data) => this.props.onAdd({
                                            cart: data,
                                            storeIndex: j,
                                            shopIndex: index,
                                            shopCnt: item.item_qty
                                        })}
                                        onBlur={(data) => this.props.onBlur({
                                            cart: data,
                                            storeIndex: j,
                                            shopIndex: index,
                                            shopCnt: item.item_qty
                                        })}
                                        onPlus={(data) => this.props.onPlus({
                                            cart: data,
                                            storeIndex: j,
                                            shopIndex: index,
                                            shopCnt: item.item_qty
                                        })}
                                        onSelected={(cartSeq) => this.props.onSelected(cartSeq)}
                                        onCommercialSpecification={(data) => this.props.onCommercialSpecification(data)}
                                        onShoppingClick={(cartSeq) => this.props.onShoppingClick(cartSeq)}
                                        clickTaxIcon={() => this.props.onTaxIcon()}/>
                                </Swipeable>
                            </View>
                        </View>
                        {(item.item_status !== 1 && item.item_status !== 2 ) ? this.renderGiftContents(item, j, index) : null}
                    </View>
                )
            })
        );
    }

    //渲染各赠品
    renderGiftContents(item, j, h) {
        return (
            <View key={j + '#' + h }
                  style={{
                      paddingHorizontal: ScreenUtils.scaleSize(15),
                      marginLeft: ScreenUtils.scaleSize(90),
                      marginBottom: ScreenUtils.scaleSize(30)
                  }}>
                <GiftMenu
                    explainNote={item.explain_note}
                    gifts={item.giftcartItemInfos}
                    itemQty={item.item_qty}
                    changeGiftItem={(data) => this.props.changeGiftItem({
                        gift_item_code: data.sitem_code,
                        storeIndex: j,
                        shopIndex: h
                    })}
                />
            </View>
        )
    }

    render() {
        // console.log("==CartListView");
        const itemProps = {
            onOpen: (event, gestureState, swipeable) => {
                if (this.state.currentlyOpenSwipeable && this.state.currentlyOpenSwipeable !== swipeable) {
                    this.state.currentlyOpenSwipeable.recenter();
                }
                this.setState({currentlyOpenSwipeable: swipeable});
            },
            onClose: () => this.setState({currentlyOpenSwipeable: null})
        };
        return (
            <ScrollView style={{height: height}}
                        scrollEnabled={!this.state.swipe}
                        onScroll={this.handleScroll}
                        refreshControl={<RefreshControl
                            refreshing={this.props.isRefreshing}
                            onRefresh={() => this.props.onRefresh()}
                        />}
            >
                {this.renderStoreTitleView(this.state.datas, {...itemProps})}
            </ScrollView>
        )
    }
}
CartListView.propTypes = {
    renderRow: PropTypes.func,
    renderHiddenRow: PropTypes.func,
    leftOpenValue: PropTypes.number,
    rightOpenValue: PropTypes.number,
    stopLeftSwipe: PropTypes.number,
    stopRightSwipe: PropTypes.number,
    closeOnScroll: PropTypes.bool,
    closeOnRowPress: PropTypes.bool,
    closeOnRowBeginSwipe: PropTypes.bool,
    disableLeftSwipe: PropTypes.bool,
    disableRightSwipe: PropTypes.bool,
    recalculateHiddenLayout: PropTypes.bool,
    onRowOpen: PropTypes.func,
    onRowDidOpen: PropTypes.func,
    onRowClose: PropTypes.func,
    onRowDidClose: PropTypes.func,
    swipeRowStyle: View.propTypes.style,
    listViewRef: PropTypes.func,
    previewFirstRow: PropTypes.bool,
    previewRowIndex: PropTypes.number,
    previewDuration: PropTypes.number,
    previewOpenValue: PropTypes.number,
    friction: PropTypes.number,
    tension: PropTypes.number,
    directionalDistanceChangeThreshold: PropTypes.number,
    swipeToOpenPercent: PropTypes.number,
    onStoreSelected: PropTypes.func,
    onCollection: PropTypes.func,
    onDelete: PropTypes.func,
    onSubmitEditing: PropTypes.func,
    onAdd: PropTypes.func,
    onBlur: PropTypes.func,
    onPlus: PropTypes.func,
    onSelected: PropTypes.func,
    onCommercialSpecification: PropTypes.func,
    onShoppingClick: PropTypes.func,
    onTaxIcon: PropTypes.func,
}
//样式定义
const styles = StyleSheet.create({
        backRightBtn: {
            bottom: 0,
            position: 'absolute',
            top: 0,
            width: 100,
            right: 0,
            flex: 1,
            flexDirection: 'row',
        },
        backRightBtnRightColl: {
            backgroundColor: '#DDDDDD',
            flex: 1,
            justifyContent: 'center',
            paddingLeft: ScreenUtils.scaleSize(45),
        },
        backRightBtnRight: {
            justifyContent: 'center',
            flex: 1,
            paddingLeft: ScreenUtils.scaleSize(45),
            backgroundColor: "#ED1C41",
        },
        backTextWhite: {
            color: '#FEFEFE',
            fontSize: ScreenUtils.setSpText(30),
        },
        backTextGary: {
            color: '#666666',
            fontSize: ScreenUtils.setSpText(30),
        },
    }
)
CartListView.defaultProps = {
    leftOpenValue: 0,
    rightOpenValue: 0,
    closeOnRowBeginSwipe: false,
    closeOnScroll: true,
    closeOnRowPress: true,
    disableLeftSwipe: false,
    disableRightSwipe: false,
    recalculateHiddenLayout: false,
    previewFirstRow: false,
    directionalDistanceChangeThreshold: 2,
    swipeToOpenPercent: 10,
    maxLength: 2,
    value: ''
}
export default CartListView
