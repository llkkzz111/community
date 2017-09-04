/**
 * Created by jzz on 2017/6/11.
 * 订单支付选择
 */

import React, {PropTypes} from 'react';
import {Actions}from 'react-native-router-flux';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    ScrollView,
    TouchableOpacity,
    FlatList,
    Modal,
    TouchableWithoutFeedback,
    DeviceEventEmitter
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import NavigationBar from '../../../foundation/common/NavigationBar';
let key = 100000;
export default class OrderPayStyle extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            payMethod: [],
            refresh: false
        };
        this._getDefaultData();
    }

    componentWillMount() {
        DeviceEventEmitter.addListener('REQUEST_CHANGE_ADDRESS', this.refresh.bind(this));
    }

    componentWillUnmount() {
        DeviceEventEmitter.removeListener('FRESH_ORDERPAY');
        DeviceEventEmitter.removeListener('REQUEST_CHANGE_ADDRESS');
    }

    refresh() {
       this.setState({
           refresh: !this.state.refresh
       })
    }
    render() {
        let {data} =  this.props
        return (
            <View style={styles.container}>
                {/*渲染nav*/}
                {this._renderNav()}
                <FlatList
                    key={++key}
                    style={styles.flatList}
                    data={data}
                    renderItem={this._renderItems}
                />
            </View>
        );
    }

    /**
     * 渲染items
     * @private
     */
    _renderItems = ({item, index}) => {
        let { payMethod } = this.state;
        let canUsePayStyle = payMethod[index].canUsePayStyle;
        let selectPatStyle = payMethod[index].selectPayStyle;
        let onlineStyle=styles.noSelectBorderColor;
        let offlineStyle=styles.noSelectBorderColor;
        let onlineTextColor=styles.noSelectColor;
        let offlineTextColor=styles.noSelectColor;
        if(canUsePayStyle==='0'){//在线支付可选
            onlineStyle=styles.selectBorderColor;
            offlineStyle=styles.noSelectBorderColor;
            onlineTextColor=styles.selectColor;
            offlineTextColor=styles.noSelectColor;
        }else if(canUsePayStyle==='1'){//货到
            onlineStyle=styles.noSelectBorderColor;
            offlineStyle=styles.selectBorderColor;
            onlineTextColor=styles.noSelectColor;
            offlineTextColor=styles.selectColor;
        }else{//两个都可以
            onlineStyle=styles.normalBorderColor;
            offlineStyle=styles.normalBorderColor;
            if(selectPatStyle==='0'){
                onlineStyle=styles.selectBorderColor;
                onlineTextColor=styles.selectColor;
                offlineTextColor=styles.normalColor;
            }else{
                offlineStyle=styles.selectBorderColor;
                offlineTextColor=styles.selectColor;
                onlineTextColor=styles.normalColor;
            }
        }

        return (
            <View style={styles.bgView}>
                <View style={styles.detailView}>
                    <Text
                        allowFontScaling={false}
                        style={styles.title}>包裹 {index + 1} </Text>
                    <ScrollView horizontal={true}
                                showsHorizontalScrollIndicator={false}
                                style={styles.horizontalImageList}>
                        {
                            item.carts.map(function (item1, index1) {
                                return (
                                    <View key={index1}
                                          style={[styles.imageView,
                                              (index1 !== 0 ? styles.marginLeft10 : null)]}>
                                        <Image key={index1}
                                               style={[styles.image]}
                                               source={{uri: item1.item.path}}/>
                                    </View>
                                    )
                            })
                        }
                    </ScrollView>
                    <View style={styles.payStyle}>
                        {
                            canUsePayStyle !== '1' ?
                                <TouchableWithoutFeedback onPress={() => this._choosePayMethod('online', index, canUsePayStyle)}>
                                    <View style={[styles.descriptionBg, onlineStyle]}>
                                        <Text
                                            allowFontScaling={false}
                                            style={[styles.description, onlineTextColor]}>在线支付</Text>
                                    </View>
                                </TouchableWithoutFeedback>
                                :
                                <View/>
                        }
                        {
                            canUsePayStyle !== '0' ?
                            <TouchableWithoutFeedback onPress={() => this._choosePayMethod('offline', index, canUsePayStyle)}>
                                <View style={[styles.descriptionBg, styles.marginLeft20, offlineStyle]}>
                                    <Text
                                        allowFontScaling={false}
                                        style={[styles.description, offlineTextColor]}>货到付款</Text>
                                </View>
                            </TouchableWithoutFeedback>
                                :
                            <View/>
                        }

                    </View>
                </View>
                <View style={styles.grayView}/>
            </View>)
    };

    /**
     * 选择支付方式
     * @private
     */
    _choosePayMethod (style, index, canUsePayStyle) {
        if (style === 'online' && canUsePayStyle !== '1') {
            this.props.data[index].selectPayStyle = '0';
            let payStyle = this.state.payMethod;
            payStyle[index].selectPayStyle = '0'
            this.setState({
                payMethod: payStyle
            })
        }

        if (style === 'offline' && canUsePayStyle !== '0') {
            this.props.data[index].selectPayStyle = '1';
            let payStyle = this.state.payMethod;
            payStyle[index].selectPayStyle = '1'
            this.setState({
                payMethod: payStyle
            })
        }
        DeviceEventEmitter.emit('FRESH_ORDERPAY', '刷新订单显示页的支付方式');
    }


    /**
     * 初始化数据
     * @private
     */
    _getDefaultData () {
        this.props.data.forEach((item, index)=> {
            let sendTime = {};
            let canUsePayStyle = item.canUsePayStyle;
            let selectPayStyle = item.selectPayStyle;
            sendTime.canUsePayStyle = canUsePayStyle;
            sendTime.selectPayStyle = selectPayStyle;
            this.state.payMethod.push(sendTime)
        });
    }

    /**
     * 渲染nav
     * @private
     */
    _renderNav() {
        return (
            <NavigationBar
                title={'选择支付方式'}
                navigationStyle={{...Platform.select({ios: {marginTop: -22}})}}
                titleStyle={styles.titleTextStyle}
                barStyle={'dark-content'}
            />
        );
    }

}
const styles=StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.background_grey,
    },
    bgView: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(350),
        flex: 1,
    },
    detailView: {
        padding: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(330),
        backgroundColor: Colors.background_white,
    },
    grayView: {
        flex: 1,
        backgroundColor: Colors.background_grey,
    },
    title: {
        fontSize: ScreenUtils.scaleSize(30),
    },
    horizontalImageList: {
        height: ScreenUtils.scaleSize(150),
        marginTop: ScreenUtils.scaleSize(10),
    },
    imageView: {
        width: ScreenUtils.scaleSize(150),
        height: ScreenUtils.scaleSize(150),
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.text_light_grey,
        borderRadius: ScreenUtils.scaleSize(4),
        alignItems: 'center',
        justifyContent: 'center',
        padding: ScreenUtils.scaleSize(1),
    },
    image: {
        width: ScreenUtils.scaleSize(142),
        height: ScreenUtils.scaleSize(146),
    },
    marginLeft10: {
        marginLeft: ScreenUtils.scaleSize(10),
    },
    addressInfo: {
        height: ScreenUtils.scaleSize(40),
        alignItems: 'center',
        flexDirection: 'row',
    },
    date: {
        flex: 1,
        fontSize: ScreenUtils.scaleSize(26),
    },
    change: {
        flexDirection: 'row',

    },
    changeText: {
        fontSize: ScreenUtils.scaleSize(24),
        color: Colors.text_dark_grey,
    },
    icon: {
        marginLeft: ScreenUtils.scaleSize(6),
        width: ScreenUtils.scaleSize(18),
        height: ScreenUtils.scaleSize(26),
    },
    submitBtn: {
        height: ScreenUtils.scaleSize(88),
        width: ScreenUtils.screenW
    },
    flatList: {
        flex: 1,
    },
    btnBgImg: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(88),
    },
    submitTitle: {
        position: 'absolute',
        alignSelf: 'center',
        marginTop: ScreenUtils.scaleSize(23),
        fontSize: ScreenUtils.scaleSize(30),
        backgroundColor: 'transparent',
        color: Colors.text_white,
    },
    titleTextStyle: {
        color: Colors.text_black,
    },
    payStyle: {
        flexDirection: 'row'
    },
    descriptionBg: {
        width: ScreenUtils.scaleSize(130),
        height: ScreenUtils.scaleSize(40),
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: ScreenUtils.scaleSize(4),
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.text_black,
    },
    normalBorderColor: {
        borderColor: Colors.text_black,
    },
    selectBorderColor: {
        borderColor: Colors.text_orange,
    },
    noSelectBorderColor: {
        borderColor: Colors.text_light_grey,
    },
    marginLeft20: {
        marginLeft: ScreenUtils.scaleSize(20),
    },
    description: {
        fontSize: ScreenUtils.scaleSize(20),
        color: Colors.text_black,
    },
    normalColor: {
        color: Colors.text_black,
    },
    selectColor: {
        color: Colors.text_orange,
    },
    noSelectColor: {
        color: Colors.text_light_grey,
    },
    chooseDate: {
        marginLeft: ScreenUtils.scaleSize(6),
        fontSize: ScreenUtils.scaleSize(24),
        color: Colors.text_light_grey,
    },
    icon: {
        marginLeft: ScreenUtils.scaleSize(6),
        width: ScreenUtils.scaleSize(18),
        height: ScreenUtils.scaleSize(26),
    },

});