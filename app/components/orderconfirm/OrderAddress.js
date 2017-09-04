/**
 * Created by YASIN on 2017/6/10.
 * 填写订单地址填写
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import RNconnect from '../../../app/config/rnConnect';
import * as routeConfig from '../../../app/config/routeConfig';
import {DataAnalyticsModule} from '../../config/AndroidModules';
import * as RouteManager from '../../config/PlatformRouteManager';
export default class OrderAddress extends React.Component {
    static propTypes = {
        hasAddress: PropTypes.bool,//是否有地址
        receiveName: PropTypes.string,//收货人姓名
        receivePhone: PropTypes.string,//收货人手机
        isDefaultAdd: PropTypes.bool,//是否是默认地址
        address: PropTypes.string,//地址名称
        orderUserName: PropTypes.string,//下单人姓名,
        orderUserPhone: PropTypes.string,//下单人手机,
        orderUserDefault: PropTypes.bool,//下单人是否为默认,
        hasOrderUser: PropTypes.bool,//是否有下单人
        onAddressUpdate: PropTypes.func,
        isSingle: PropTypes.bool
    };
    static defaultProps = {
        hasAddress: false,
        hasOrderUser: false
    };
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this._onUpdateClick = this._onUpdateClick.bind(this);
        this.state = {
            bgImageHeight: ScreenUtils.scaleSize(200)
        }
    }

    render() {
        let component = null;
        let {hasAddress} = this.props;
        if (hasAddress) {
            component = this._renderBaseInfo();
        } else {
            component = this._renderAddAdress();
        }
        return (
            <View style={styles.container} onLayout={(event) => {
                let height = event.nativeEvent.layout.height;
                if (this.state.bgImageHeight !== height) {
                    this.setState({
                        bgImageHeight: height
                    });
                }
            }}>
                {component}
                <Image
                    style={[styles.bgLeftStyle, {height: this.state.bgImageHeight}]}
                    source={require('../../../foundation/Img/order/address_status.jpg')
                    }/>
            </View>
        );
    }

    /**
     * 显示地址基本信息
     * @private
     */
    _renderBaseInfo() {
        return (
            <View style={styles.baseAddressContainer}>
                <View style={styles.baseInfoTopContainer}>
                    <Text
                        allowFontScaling={false}
                        style={styles.receiveDescTitle}>收货人</Text>
                    <View style={styles.baseInfoTopRightContainer}>
                        <View style={{flexDirection: 'row', alignItems: 'center'}}>
                            <Text
                                allowFontScaling={false}
                                style={styles.receiveName}>{this.props.receiveName}</Text>
                            <Text
                                allowFontScaling={false}
                                style={styles.receivePhone}>{this.props.receivePhone}</Text>
                            {this.props.isDefaultAdd ? (
                                <View style={styles.defaultContainer}>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.defaultDescStyle}>默认</Text>
                                </View>
                            ) : null}
                        </View>
                        <TouchableOpacity activeOpacity={1} style={styles.updateContainer}
                                          onPress={this._onUpdateClick}>
                            <Text
                                allowFontScaling={false}
                                style={styles.updateDescStyle}>修改</Text>
                            <Image style={styles.updateIconStyle}
                                   source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>
                        </TouchableOpacity>
                    </View>
                </View>
                <View style={styles.bottomInfoContainer}>
                    <View style={styles.imgAddressContainer}>
                        <Image
                            style={styles.imgAddressStyle}
                            source={require('../../../foundation/Img/order/location.png')}
                        />
                    </View>
                    <View style={styles.bottomInfoRight}>
                        <Text
                            allowFontScaling={false}
                            style={styles.addressTextStyle}>{this.props.address}</Text>
                    </View>
                </View>
            </View>
        );
    }

    /**
     * 修改地址
     * @private
     */
    _onUpdateClick() {
        // alert('选择地址');
        // 埋点
        if (this.props.isSingle === true) {
            DataAnalyticsModule.trackEvent2("AP1706C016F010001A001001", "");
            // console.log('1111')
        } else if (this.props.isSingle === false) {
            DataAnalyticsModule.trackEvent2("AP1706C017F010001A001001", "");
        }
        // RNconnect.pushs({page: routeConfig.MePageocj_SelectAddress, param: {action: 'addAddress'}}, (events) => {
        //     try {
        //         let object = events;
        //         if (object.addressID !== null && object.addressID !== undefined) {
        //             let address = {};
        //             address.receiveName = object.receiverName;
        //             address.address = object.addrProCity;
        //             if(object.addrDetail){
        //                 address.address+=object.addrDetail;
        //             }
        //             address.isDefaultAdd = object.isDefault;
        //             address.receivePhoneWidthStart = object.mobile2;
        //             address.receivePhone = object.mobile1;
        //             address.addressSeq = object.addressID;
        //             this.props.onAddressUpdate(address);
        //         }
        //     } catch (erro) {
        //     }
        // });
        RouteManager.routeJump({
            page: routeConfig.SelectAddress,
            param: {action: 'addAddress'},
            fromRNPage: routeConfig.VideoNewest,
        }, (event) => {
            try {
                let object = event;
                if (object.addressID !== null && object.addressID !== undefined) {
                    let address = {};
                    address.receiveName = object.receiverName;
                    address.address = object.addrProCity;
                    if (object.addrDetail) {
                        address.address += object.addrDetail;
                    }
                    address.isDefaultAdd = object.isDefault;
                    address.receivePhoneWidthStart = object.mobile2;
                    address.receivePhone = object.mobile1;
                    address.addressSeq = object.addressID;
                    this.props.onAddressUpdate(address);
                }
            } catch (erro) {
            }
        });
    }

    /**
     * 渲染添加地址页面
     * @private
     */
    _renderAddAdress() {
        return (
            <View style={styles.addAddContainer}>
                <Text
                    allowFontScaling={false}
                    style={styles.addDescStyle}>请添加收货人和下单人信息</Text>
                <View style={{flexDirection: 'row', alignItems: 'center'}}>
                    <TouchableOpacity activeOpacity={1} style={styles.updateContainer} onPress={this._onUpdateClick}>
                        <Text
                            allowFontScaling={false}
                            style={styles.updateDescStyle}>新增</Text>
                        <Image style={styles.updateIconStyle}
                               source={require('../../../foundation/Img/home/store/icon_view_more_.png')}/>
                    </TouchableOpacity>
                </View>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
    },
    bgLeftStyle: {
        width: ScreenUtils.scaleSize(8),
        height: ScreenUtils.scaleSize(200),
        position: 'absolute',
        top: 0,
        left: 0,
        bottom: 0,
    },
    baseAddressContainer: {
        alignItems: 'center',
        padding: ScreenUtils.scaleSize(35),
        height: ScreenUtils.scaleSize(200)
    },
    receiveDescTitle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28),
    },
    receiveName: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(28),
        marginLeft: ScreenUtils.scaleSize(30)
    },
    receivePhone: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(20)
    },
    defaultDescStyle: {
        color: Colors.text_white,
        fontSize: ScreenUtils.scaleSize(24),
    },
    defaultContainer: {
        borderRadius: ScreenUtils.scaleSize(4),
        backgroundColor: '#EA543D',
        alignItems: 'center',
        justifyContent: 'center',
        marginLeft: ScreenUtils.scaleSize(20),
        padding: ScreenUtils.scaleSize(5)
    },
    baseInfoTopContainer: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    baseInfoTopRightContainer: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
    updateContainer: {
        flexDirection: 'row',
        alignItems: 'center'
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
    bottomInfoContainer: {
        flexDirection: 'row',
        alignSelf: 'stretch',
        marginTop: ScreenUtils.scaleSize(30)
    },
    imgAddressStyle: {
        width: ScreenUtils.scaleSize(75),
        height: ScreenUtils.scaleSize(75),
    },
    imgAddressContainer: {
        width: ScreenUtils.scaleSize(90),
        alignItems: 'center',
        justifyContent: 'center'
    },
    bottomInfoRight: {
        flexDirection: 'row',
        flex: 1,
        marginTop: ScreenUtils.scaleSize(5)
    },
    addressTextStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(26),
        marginLeft: ScreenUtils.scaleSize(30),
        flex: 1,
        marginRight: ScreenUtils.scaleSize(160),
    },
    addAddContainer: {
        alignItems: 'center',
        flexDirection: 'row',
        height: ScreenUtils.scaleSize(150),
        justifyContent: 'space-between',
        paddingHorizontal: ScreenUtils.scaleSize(30)
    },
    addDescStyle: {
        fontSize: ScreenUtils.scaleSize(30),
        color: Colors.text_dark_grey,
    }
});