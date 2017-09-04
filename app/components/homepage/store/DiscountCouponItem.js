/**
 * Created by YASIN on 2017/6/1.
 * 抵用券itemview
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    Text,
    TouchableOpacity,
    StyleSheet,
    Platform
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import * as IsEmptyUtil from '../../../../foundation/utils/IsEmptyUtil';

import ReceiveCouponRequest from '../../../../foundation/net/home/store/ReceiveCouponRequest';

import Immutable from 'immutable';

export default class DiscountCouponItem extends React.PureComponent {
    static propTypes = {
        ...View.propTypes.style,
        amount: React.PropTypes.string,
        desc: React.PropTypes.string,
        name: React.PropTypes.string,
        isReceive: React.PropTypes.string,
        couponId: React.PropTypes.string,
        updateCouponList: React.PropTypes.func,
        errorCallback: React.PropTypes.func
    }

    constructor(props){
        super(props);
        this.state={
            isReceive: this.props.isReceive
        }
    }

    componentWillReceiveProps(nextProps){
        this.setState({
            isReceive: nextProps.isReceive
        });
    }

    render() {
        let { couponId } = this.props;
        let receive = this.state.isReceive === '1';
        let rightBg;
        if (receive) {
            rightBg = require('../../../../foundation/Img/home/store/Icon_rightbg2_.png');
        } else {
            rightBg = require('../../../../foundation/Img/home/store/Icon_rightbg_.png');
        }
        return (
            <View style={styles.container}>
                <Image
                    source={require('../../../../foundation/Img/home/store/Icon_leftbg_.png')}
                    style={styles.leftBgStyle}>
                    <Text allowFontScaling={false} style={styles.priceType}>¥<Text allowFontScaling={false} style={styles.price}>{(IsEmptyUtil.stringIsEmptyAndUndefined(this.props.amount)) ? String(this.props.amount) : ''}</Text></Text>
                    <Text allowFontScaling={false} style={styles.desc}>{this.props.desc}</Text>
                </Image>
                <Image
                    source={rightBg}
                    style={styles.rightBgStyle}>
                    <Text allowFontScaling={false} style={styles.infoStyle}>{this.props.name}</Text>
                    <TouchableOpacity activeOpacity={1} onPress={() => {this._receiveCoupon(couponId)}}
                        style={receive ? styles.confirmContainer2 : styles.confirmContainer}>
                        <Text allowFontScaling={false} style={styles.confirmStyle}>{receive ? '' : '立即领取'}</Text>
                    </TouchableOpacity>
                </Image>
            </View>
        );
    }

    _receiveCoupon = (couponId) => {
        if (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(couponId)) {
            let params = {
                coupon_no: String(couponId)
            }
            this.ReceiveCouponRequest = new ReceiveCouponRequest(params, null);
            this.ReceiveCouponRequest.start((response) => {
                let object = Immutable.fromJS(response);
                let code = object.get('code');
                if (code == 200) {
                    this.setState({ isReceive: '1' });
                    this.props.updateCouponList();
                }
            }, (error) => {
                if (error) {
                    let object = Immutable.fromJS(error);
                    if (object.get('code')) {
                        let code = object.get('code');
                        let message=object.get('message');
                        if(message&&message.length>0){
                            this.props.errorCallback(message);
                        }
                    }
                }
            });
        }
    }
}

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        paddingHorizontal: ScreenUtils.scaleSize(15)
    },
    leftBgStyle: {
        width: ScreenUtils.scaleSize(156),
        height: ScreenUtils.scaleSize(104),
        resizeMode: 'stretch',
        alignItems: 'center',
        justifyContent: 'center'
    },
    rightBgStyle: {
        width: ScreenUtils.scaleSize(116),
        height: ScreenUtils.scaleSize(104),
        resizeMode: 'stretch',
        alignItems: 'center'
    },
    priceType: {
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(24),
        backgroundColor:'transparent',
        marginTop:ScreenUtils.scaleSize(-13)
    },
    price: {
        color: Colors.text_white,
        fontSize: 20,
        backgroundColor:'transparent'
    },
    desc: {
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(20),
        backgroundColor:'transparent',
        marginTop:ScreenUtils.scaleSize(-4)
    },
    infoStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.setSpText(26),
        backgroundColor:'transparent',
        textAlign: 'center',
        width: ScreenUtils.scaleSize(87),
        height: ScreenUtils.scaleSize(40),
        marginTop: ScreenUtils.scaleSize(13)
    },
    confirmStyle:{
        color:Colors.text_white,
        fontSize:ScreenUtils.scaleSize(20),
        textAlign:'center',
        width: ScreenUtils.scaleSize(88),
        height: ScreenUtils.scaleSize(30),
        backgroundColor: 'transparent'
    },
    confirmContainer:{
        alignItems:'center',
        justifyContent:'center',
        backgroundColor:Colors.main_color,
        borderRadius:ScreenUtils.scaleSize(3),
        ...Platform.select({
            ios:{
                // padding: ScreenUtils.scaleSize(2),
                // paddingVertical: ScreenUtils.scaleSize(2),
                paddingTop: ScreenUtils.scaleSize(5),
            },
            android:{
                padding: ScreenUtils.scaleSize(2)
            }
        }),
        marginTop:ScreenUtils.scaleSize(3)
    },
    confirmContainer2: {
        backgroundColor: 'transparent'
    }
});