/**
 * Created by dhy on 2017/5/11.
 * DiscountCoupon 商品折扣券列表
 *
 */
import React from 'react'
import {connect} from 'react-redux'
import {
    View,
    Text,
    StyleSheet,
    Dimensions,
    Modal,
    FlatList,
} from 'react-native'
import * as actions from '../../app/actions/actions'
import * as actionTypes from '../../app/actions/actionTypes'
import * as CartTypeAction from '../../app/actions/cartaction/CartAction'
import DiscountCell from './DiscountCell'
var {width, height} = Dimensions.get('window');

const data = {
    total: 5,
    types: [
        {
            type: 1,
            categoryName: '已选商品可用抵用券',
            categoryTip: '没有提示',
            items: [
                {
                    categoryTip: '没有提示',
                    price: '30',
                    condition: '满200可用',
                    shop: '甄选生活专营店活动',
                    coupon: '满500减80',
                    date: '有效期2018.4.18'
                },
                {
                    categoryTip: '没有提示',
                    price: '30',
                    condition: '满200可用',
                    shop: '甄选生活专营店活动',
                    coupon: '满500减80',
                    date: '有效期2018.4.18'
                },
                {
                    categoryTip: '没有提示',
                    price: '30',
                    condition: '满200可用',
                    shop: '甄选生活专营店活动',
                    coupon: '满500减80',
                    date: '有效期2018.4.18'
                }
            ],
        },
        {
            type: 1,
            categoryName: '未选商品可用抵用券',
            categoryTip: '提示gogogogo',
            items: [
                {
                    price: '30',
                    condition: '满200可用',
                    shop: '甄选生活专营店活动',
                    coupon: '满500减80',
                    date: '有效期2018.4.18'
                },
                {
                    price: '30',
                    condition: '满200可用',
                    shop: '甄选生活专营店活动',
                    coupon: '满500减80',
                    date: '有效期2018.4.18'
                }
            ],
        },
        {
            type: 1,
            categoryName: '已满足使用条件，可节省100元',
            categoryTip: '已满足',
            items: [
                {
                    categoryTip: '已满足',
                    price: '30',
                    condition: '满200可用',
                    shop: '甄选生活专营店活动',
                    coupon: '满500减80',
                    date: '有效期2018.4.18'
                },
            ],
        },
        {
            type: 1,
            categoryName: '未满足使用条件，可节省100元',
            categoryTip: '还差20',
            items: [
                {
                    categoryTip: '还差20',
                    price: '30',
                    condition: '满200可用',
                    shop: '甄选生活专营店活动',
                    coupon: '满500减80',
                    date: '有效期2018.4.18'
                },
            ],
        },
        {
            type: 1,
            categoryName: '超级用户，可节省10000元',
            categoryTip: '还差20',
            items: [
                {
                    categoryTip: '还差20',
                    price: '30',
                    condition: '满200可用',
                    shop: '甄选生活专营店活动',
                    coupon: '满500减80',
                    date: '有效期2018.4.18'
                },
            ],
        },
    ]
};

class Item extends React.PureComponent {
    render() {
        let data = this.props.data;
        return (
            data.items.length > 0 ?
                <View>
                    <View style={dcstyles.titleView}>
                        <Text style={dcstyles.categoryName} allowFontScaling={false}>{data.categoryName}</Text>
                    </View>
                    <DiscountCell dataSource={data.items}/>
                </View>
                :
                <View/>
        );
    }
}

class DiscountCoupon extends React.PureComponent {
    constructor(props) {
        super(props);
    }

    render() {
        let {closeDiscountCoupon} = this.props;
        return (
            <Modal onRequestClose={() => {
            }} animationType="fade"
                   transparent={true}
                   visible={this.props.show}>
                <View style={dcstyles.container}>
                    <View style={dcstyles.contentContainer}>
                        <Text style={dcstyles.titleClose} onPress={() => closeDiscountCoupon()} allowFontScaling={false}>x</Text>
                        {data.types.length > 0 ?
                            <FlatList
                                horizontal={false}
                                data={this.props.data.types}
                                renderItem={({item}) => (
                                    <Item data={item}/>
                                )}
                            />
                            :
                            <View style={dcstyles.no}>
                                <Text style={dcstyles.noText} allowFontScaling={false}>没有啥优惠券哦！</Text>
                            </View>
                        }
                    </View>
                </View>
            </Modal>
        );
    }
}
DiscountCoupon.defaultProps = {
    index: 0,
    data: data,
};
const dcstyles = StyleSheet.create({
    noText: {
        justifyContent: 'center',
        color: 'red',
        alignSelf: 'center',
        fontSize: 18,
    },
    no: {
        width: width,
        height: 90,
        backgroundColor: 'white',
        justifyContent: 'center',
    },
    categoryName: {
        flex: 2,
        justifyContent: 'flex-end',
        alignSelf: 'center',
        fontSize: 16,
    },
    listContainer: {
        backgroundColor: 'white',
        marginRight: 15,
        marginLeft: 15,
    },
    container: {
        flex: 1,
        justifyContent: 'flex-end',
        backgroundColor: 'rgba(0,0,0,0.5)',
    },
    contentContainer: {
        // flex: 1,
        marginTop: height / 5,
        flexDirection: 'column',
        backgroundColor: 'white',
        justifyContent: 'flex-end',
        paddingTop: 10,
        paddingLeft: 10,
        paddingRight: 10,
    },
    titleView: {
        // flex: 1,
        flexDirection: 'row',
        height: 30,
    },
    buttons: {
        justifyContent: 'center',
        flexDirection: 'row',
        alignItems: 'center',
    },
    titleLeft: {
        marginTop: 25,
        width: 20,
        backgroundColor: 'white',
    },
    titleImg: {
        borderRadius: 3,
        width: 100,
        height: 100,
        resizeMode: 'cover',
    },
    titleText: {
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'flex-end',
        paddingLeft: 10,
        paddingRight: 10,
        paddingTop: 10,
        marginTop: 25,
        backgroundColor: 'white',
    },
    titleClose: {
        zIndex: 4,
        position: 'absolute',
        // alignSelf: 'flex-end',
        top: 10,
        right: 10,
        width: 30,
        height: 30,
        fontSize: 24,
        // backgroundColor: 'white',
        textAlign: 'center',
    },
    price: {
        color: '#ff8c00'
    },
    categoryTitle: {
        marginTop: 10,
        marginBottom: 10,
    },
    categoryItems: {
        flexDirection: 'row',
        marginBottom: 10,
    },
    categoryItemText: {
        padding: 5,
        marginLeft: 5,
        marginRight: 5,
        backgroundColor: '#666666',
        color: 'white',
        borderRadius: 8,
    },
    addCartBtn: {
        height: 50,
        flex: 1,
        color: 'white',
        flexDirection: 'row',
        textAlign: 'center',
        textAlignVertical: 'center',
        alignItems: 'center',
        backgroundColor: '#ff8c00'
    },
    purchaseBtn: {
        height: 50,
        flex: 1,
        color: 'white',
        flexDirection: 'row',
        textAlign: 'center',
        textAlignVertical: 'center',
        alignItems: 'center',
        backgroundColor: '#daa520',
    },
    divideLine: {
        backgroundColor: 'rgba(0,0,0,0.5)',
        height: 1,
    }
});

export default connect(state => ({
    currentState: state.OrderReducer,
}), dispatch => ({
    closeDiscountCoupon: (data) => dispatch(CartTypeAction.closeDiscountCoupon(actionTypes.DISCOUNTCOUPON_ClOSE, data)),
}))(DiscountCoupon)