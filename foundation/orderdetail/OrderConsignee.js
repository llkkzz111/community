/**
 * Created by Administrator on 2017/5/8.
 */
'use strict';

import React, {
    Component,
    PropTypes
} from 'react';

import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image
} from 'react-native';

export default class OrderConsignee extends Component {
    constructor(props) {
        super(props);
        this.state = {

        }
    }

    render() {
        let { orderStatus} = this.props;
        return (
            <View style={styles.consigneeInforStyle}>
                <Image style={styles.img} source={require('../Img/order/address_status.jpg')} />
                <View style={styles.consigneeChildStyle}>
                    <View style={styles.customerInforStyle}>
                        <Text allowFontScaling={false} style={styles.consigneeTextStyle}>收货人</Text>
                        <Text allowFontScaling={false} style={styles.customerNameTextStyle}>{orderStatus.receiver.receiver_name}</Text>
                        <Text allowFontScaling={false} style={styles.telephoneTextStyle}>{orderStatus.receiver.hp_no.substr(0,3)}****{orderStatus.receiver.hp_no.substr(7,4)}</Text>
                    </View>
                    <View style={styles.addressInforViewStyle}>
                        <View>
                            <Image style={styles.imgAddressStyle} source={require('../Img/cart/location.png')}></Image>
                        </View>
                        <View style={{flex:1}}>
                            <Text allowFontScaling={false} style={styles.addressInforTextStyle}numberOfLines={2}>{orderStatus.receiver.receiver_addr}</Text>
                        </View>
                    </View>
                </View>
            </View>
        )
    }
}

// OrderConsignee.propTypes = {
//     customerName: PropTypes.string, //姓名
//     telephone: PropTypes.string, //电话
//     address: PropTypes.string //地址
// };
//
// OrderConsignee.defaultProps = {
//     customerName: '张大明',
//     telephone: '138 **** 5678',
//     address: '上海市杨闵行区浦江镇V领地青年公寓芦恒路社区店林恒路18号'
// };

const styles = StyleSheet.create({
    consigneeInforStyle: {
        flex:1,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        backgroundColor: '#FFFFFF',
        //paddingLeft: 10,
        //paddingTop: 10,
        //paddingBottom: 10,
        paddingRight: 80,
        marginBottom:10,
        height: 90,
    },
    consigneeChildStyle:{
        flex:5,
        flexDirection: 'column',
        justifyContent: 'flex-start',
        alignItems: 'flex-start',
        marginLeft:22,
    },
    customerInforStyle:{
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'flex-start'
    },
    consigneeTextStyle: {
        color: '#666666'
    },
    customerNameTextStyle: {
        color: '#333333',
        marginLeft: 10,
        fontSize:16
    },
    telephoneTextStyle:{
        color: '#666666',
        marginLeft: 10
    },
    defaultTextStyle: {
        backgroundColor: '#EA543D',
        color: '#FEFEFE',
        marginLeft: 10,
        width: 40,
        paddingLeft: 5,
        paddingRight: 5
    },
    addressInforViewStyle: {
        marginTop: 10,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center'
    },
    addressInforTextStyle: {
        flexWrap: 'wrap',
        color: '#666666',
        marginLeft: 10
    },
    modifyViewStyle: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center'
    },
    imgAddressStyle: {
        width: 30,
        height: 36,
        resizeMode: 'cover'
    },
    img: {
        width: 5,
        height: 90,
        maxWidth: 5,
        maxHeight: 90
    },
});