/**
 * Created by Zhang.xinchun on 2017/5/4.
 * 购物车商品展示
 */
import React, { PureComponent } from 'react'
import {
    View,
} from 'react-native';

// 导入外部组件
import CartListView from 'FOUNDATION/cart/CartListView';
import AllCheckAndAccount from 'FOUNDATION/cart/AllCheckAndAccount';
import AllCheckAndEdit from 'FOUNDATION/cart/AllCheckAndEdit';
import Coupon from 'FOUNDATION/cart/Coupon';
import Immutable from 'immutable'

class CartList extends PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            allSelected: this.props.allSelected,//是否全选
            cartData: this.props.cartData,//购物车数据
            couponPriceData: this.props.couponPriceData,//价格抢购券数据
        };
    }

    //刷新整个购物车
    componentWillReceiveProps(nextProps) {
        this.setState({
            cartData: nextProps.cartData,
            allSelected: nextProps.allSelected,
            //编辑/完成切换
            cartType: nextProps.cartType,
            couponPriceData: nextProps.couponPriceData,
        });
    }

    //判断是否走 render
    shouldComponentUpdate(nextProps, nextState) {
        return ((this.props.cartType !== nextProps.cartType)
        || (this.props.allSelected !== nextProps.allSelected)
        || (this.props.couponPriceData !== nextProps.couponPriceData)
        || !(Immutable.is(this.props.cartData, nextProps.cartData)));
    }

    render() {
        return (
            <View style={{flex: 1, backgroundColor: '#ededed'}}>
                <CartListView
                    cancelChange={(seq) => this.props.cancelChange(seq)}
                    cartType={this.props.cartType}
                    dataSource={this.state.cartData}
                    isRefreshing={this.props.isRefreshing}
                    onRefresh={() => this.props.onRefresh()}
                    storeArray={this.props.storeArray}
                    selectedCartSeqs={this.props.selectedCartSeqs}
                    allShoppingArray={this.props.allShoppingArray}
                    selectedShoppingArray={this.props.selectedShoppingArray}
                    onShoppingClick={(data) => this.props.onShoppingClick(data)}
                    onPlus={(data) => this.props.onPlus(data)}
                    onAdd={(data) => this.props.onAdd(data)}
                    onDelete={(data) => this.props.onDelete(data)}
                    onCollection={(data) => this.props.onCollection(data)}
                    onBlur={(data) => this.props.onBlur(data)}
                    onCommercialSpecification={(data) => this.props.onCommercialSpecification(data)}
                    onSelected={(data) => this.props.onSelected(data)}
                    onStoreSelected={(data) => this.props.onStoreSelected(data)}
                    onSubmitEditing={(data) => this.props.onSubmitEditing(data)}
                    onTaxIcon={() => this.props.onTaxIcon()}
                    changeGiftItem={(data) => this.props.changeGiftItem(data)}
                />
                {/*折扣券详情传入参数*/}
                {
                    (this.props.cartType && this.state.couponPriceData) ?
                        <Coupon
                            couponCount={this.state.couponPriceData ? this.state.couponPriceData.couponCountsNum : 0}
                            couponPriceCount={this.state.couponPriceData ? this.state.couponPriceData.dc_money : 0}
                            toCouponDetailClick={() => this.props.toCouponDetailClick()}/> : null
                }
                {
                    (this.props.cartType && this.state.couponPriceData) ?
                        <AllCheckAndAccount
                            couponPriceData={this.state.couponPriceData}
                            allSelected={this.state.allSelected}
                            accountDisable={this.state.accountDisable}
                            selectedShoppingArray={this.props.selectedShoppingArray}
                            allStoreSelected={(data) => this.props.allStoreSelected(data)}
                            goToAccount={() => this.props.goToAccount()}
                        /> : null
                }
                {!this.props.cartType ?
                    <AllCheckAndEdit
                        couponPriceData={this.state.couponPriceData}
                        allSelected={this.state.allSelected}
                        accountDisable={this.state.accountDisable}
                        onAllShoppingSelected={(data) => this.props.onAllShoppingSelected(data)}
                        onCollectionSelectItem={() => this.props.onCollectionSelectItem()}
                        onDeleteSelectItem={() => this.props.onDeleteSelectItem()}
                    /> : null
                }

            </View>
        );
    }
}
export default CartList;
