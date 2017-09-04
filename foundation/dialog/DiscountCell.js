/**
 *  没类折扣券DiscountCell   Created by dhy on 2017/5/11.
 */
import React, {Component, PropTypes} from 'react'

import {
    View,
    Text,
    StyleSheet,
    ListView,
    Dimensions,
    FlatList,
} from 'react-native'
const {width} = Dimensions.get('window');
let cellHeight = 100;
//每张折扣券Item
class Item extends Component {
    render() {
        let data = this.props.data;
        return (
            <View style={dcstyles.container}>
                <View style={dcstyles.marginViewTop}>
                    <Text style={dcstyles.categoryTip} allowFontScaling={false}>{data.categoryTip}</Text>
                    <Text style={dcstyles.btnText} allowFontScaling={false}>¥20 去瞧瞧></Text>
                </View>
                <View style={dcstyles.listContainer}>
                    <View style={dcstyles.leftView}>
                        <View style={dcstyles.priceView}>
                            <Text style={dcstyles.leftLog} allowFontScaling={false}>¥</Text>
                            <Text style={dcstyles.leftNum} allowFontScaling={false}>{data.price}</Text>
                        </View>
                        <Text style={dcstyles.leftText} allowFontScaling={false}>{data.condition}</Text>
                    </View>
                    <View style={dcstyles.up}/>
                    <View style={dcstyles.down}/>
                    <View style={dcstyles.dashLine}/>
                    <View style={dcstyles.rightView}>
                        <Text style={dcstyles.shopText} allowFontScaling={false}>{data.shop}</Text>
                        <Text style={dcstyles.couponText} allowFontScaling={false}>{data.coupon}</Text>
                        <Text style={dcstyles.dateText} allowFontScaling={false}>{data.date}</Text>
                    </View>
                </View>
                <View style={dcstyles.marginView}/>
            </View>
        );
    }
}
Item.defaultProps = {
    index: 0,
    data: ['1', '2', '3', '4', '5'],
};
export  default  class DiscountCell extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <FlatList
                horizontal={false}
                data={this.props.dataSource}
                renderItem={({item}) => (
                    <Item data={item}/>
                )}
            />
        );
    }

}

const dcstyles = StyleSheet.create({
    btnText: {
        color: '#E5290D',
    },
    categoryTip: {
        color: '#333333',
    },
    marginViewTop: {
        zIndex: 4,
        height: 25,
        flexDirection: 'row',
        backgroundColor: 'white',
        justifyContent: 'flex-end',
        alignItems: 'center',
    },
    marginView: {
        zIndex: 4,
        height: 10,
        backgroundColor: 'white',
    },
    dashLine: {
        borderColor: '#E5290D',
        borderWidth: 2,
        borderStyle: 'dashed',
        width: 4,

    },
    container: {
        flex: 1,
        backgroundColor: 'white',
        flexDirection: 'column'
    },
    listContainer: {
        backgroundColor: 'white',
        flex: 1,
        flexDirection: 'row',
        height: cellHeight,
        // marginRight:10,
    },
    leftView: {
        flex: 1.2,
        flexDirection: 'column',
        backgroundColor: 'red',
        justifyContent: 'center',
    },
    priceView: {
        flexDirection: 'row',
        justifyContent: 'center',
    },
    leftNum: {
        color: 'white',
        textAlign: 'center',
        fontSize: 25,
    },
    leftLog: {
        color: 'white',
        paddingTop: 10,
        textAlign: 'center',
    },
    leftText: {
        color: 'white',
        textAlign: 'center',
    },
    rightView: {
        flex: 3,
        // zIndex:4,
        marginLeft: -2,
        marginRight: 0,
        paddingTop: 10,
        paddingLeft: 20,
        flexDirection: 'column',
        backgroundColor: 'white',
        borderWidth: 0.5,
        borderColor: 'red',
    },
    rightText: {
        color: 'white',
        textAlign: 'left',
    },
    up: {
        position: 'absolute',
        left: (width - 20) / 4.2,
        top: -10,
        zIndex: 3,
        backgroundColor: 'white',
        width: 20,
        height: 20,
        borderRadius: 10,
        borderColor: '#E5290D',
        borderWidth: 0.5,
    },
    down: {
        position: 'absolute',
        left: (width - 20) / 4.2,
        top: cellHeight - 10,
        zIndex: 3,
        backgroundColor: 'white',
        width: 20,
        height: 20,
        borderRadius: 10,
        borderColor: '#E5290D',
        borderWidth: 0.5,
    },
    shopText: {
        height: 30,
        color: '#333333',
        fontSize: 18,
    },
    dateText: {
        color: '#666666',
        fontSize: 14,
    },
    couponText: {
        color: '#666666',
        fontSize: 14,
    },

});