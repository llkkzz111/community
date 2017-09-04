import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image
} from 'react-native';

export default class Coupon extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            display: true
        };
    }

    static defaultProps = {
        display: true
    };

    //关闭
    closeClick() {
        this.setState({display: false});
        this.forceUpdate();
    }

    render() {
        if (String(this.props.couponCount) === "0"||!this.state.display) {
            return null;
        }
        return (
            <View style={styles.couponViewStyle}>
                <View style={styles.leftImgViewStyle}>
                    <Image source={require('../Img/cart/Icon_tips_@3x.png')} style={styles.imgLeftStyle}/>
                    <Text
                        style={styles.textViewStyle} allowFontScaling={false}>当前{String(this.props.couponCount)}张抵用券可用，可节省¥ {String(this.props.couponPriceCount)}</Text>
                    <TouchableOpacity activeOpacity={1} onPress={() => {
                        this.props.toCouponDetailClick()
                    }}>
                        <View style={styles.toLookViewStyle}>
                            <Text style={styles.toLookTextStyle} allowFontScaling={false}>点击查看</Text>
                        </View>
                    </TouchableOpacity>
                </View>
                <TouchableOpacity activeOpacity={1} onPress={() => {
                    this.closeClick()
                }}>
                    <TouchableOpacity activeOpacity={1} style={styles.leftImgViewStyless} onPress={() => this.closeClick()}>
                        <Image source={require('../Img/cart/close.png')} style={styles.imgRightStyle}/>
                    </TouchableOpacity>
                </TouchableOpacity>
            </View>
        )
    }
}


Coupon.propTypes = {
    display: React.PropTypes.bool, //显示不显示
    couponCount: React.PropTypes.number, //抵用券张数
    couponPriceCount: React.PropTypes.number, //节省价格
    toCouponDetailClick: React.PropTypes.func, //去抵用券详细
};

Coupon.defaultProps = {
    display: true, //显示不显示
    couponCount: 0, //抵用券张数
    couponPriceCount: 0, //节省价格
    toCouponDetailClick: React.PropTypes.func, //去抵用券详细
};
const styles = StyleSheet.create({
    couponViewStyle: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        backgroundColor: '#FFF7E5',
        height: 40,
        paddingLeft: 10,
        paddingRight: 10
    },
    imgLeftStyle: {
        width: 16,
        height: 16,
        marginRight: 5,
        marginLeft: 5,
    },
    imgRightStyle: {
        width: 12,
        height: 12,
        marginTop: 5
    },
    leftImgViewStyle: {
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
    },
    leftImgViewStyless: {
        marginTop: 10,
    },
    textViewStyle: {
        alignItems: 'center',
        justifyContent: 'center',
        color: '#DF2928',
        fontSize: 12,
    },
    toLookViewStyle: {
        marginLeft: 5,
    },
    toLookTextStyle: {
        alignItems: 'center',
        justifyContent: 'center',
        color: '#666666',
        fontSize: 12,
        textDecorationLine: 'underline',
    }
});
