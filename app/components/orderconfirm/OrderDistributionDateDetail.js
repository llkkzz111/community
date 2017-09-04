/**
 * Created by jzz on 2017/6/11.
 * 订单配送时间选择
 */

import React, {PropTypes} from 'react';
import OrderDatePicker from './OrderDatePicker'
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
    DeviceEventEmitter,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import NavigationBar from '../../../foundation/common/NavigationBar';
let currentIndex = 0;
let key = 0;
export default class OrderDistributionDateDetail extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            sendTimes: []
        }
        this._getDefaultTime();
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
                <TouchableOpacity activeOpacity={1} onPress={this._confirmAddress}>
                    <View style={styles.submitBtn}>
                        <Image resizeMode={'stretch'}
                               source={require('../../../foundation/Img/order/icon_orderconfirm_topbar_.png')}
                               style={styles.btnBgImg}/>
                        <Text
                            allowFontScaling={false}
                            style={styles.submitTitle}> 确定 </Text>
                    </View>
                </TouchableOpacity>
                <OrderDatePicker ref='OrderDatePicker'
                                 data={data}
                                 refresh={(date,day, index) => this.refreshView(date,day, index)}/>
            </View>
        );
    }

    /**
     * 刷新当前视图 当选择日期的时候  选择日期界面通知界面刷新
     * @private
     */
    refreshView(date, day, index) {
        let tempData = {}
        tempData.selectDateType = this.props.data[currentIndex].selectDateType
        tempData.selectDate = date;
        tempData.date = day;
        let tempSendTimes = this.state.sendTimes
        tempSendTimes[currentIndex] = tempData
        this.setState({
            sendTimes: tempSendTimes
        })
    }

    /**
     * 渲染items
     * @private
     */
    _renderItems = ({item, index}) => {
        let deliveryStyle = this.state.sendTimes[index].selectDateType;
        let deliveryDate = this.state.sendTimes[index].selectDate;
        let dates = this.state.sendTimes[index].date;
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
                                    <View key={item1.item.path + index1}
                                          style={[styles.imageView,(index1 !== 0 ? styles.marginLeft10 : null)]}>
                                        <Image key={index1}
                                               style={[styles.image]}
                                               source={{uri: item1.item.path}}/>
                                    </View>
                                    )
                            })
                        }
                    </ScrollView>
                    <View style={styles.addressInfo}>
                        <Text
                            allowFontScaling={false}
                            style={styles.date}>{deliveryDate} {dates}</Text>
                        {
                            deliveryStyle === '0' ?
                                <View/>
                                :
                                <TouchableOpacity activeOpacity={1} onPress={() => this._showDateList(index)}>
                                    <View style={styles.change}>
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.changeText}>修改</Text>
                                        <Image style={styles.icon}
                                               source={require('../../../foundation/Img/home/store/icon_view_more_.png')}>
                                        </Image>
                                    </View>
                                </TouchableOpacity>
                        }
                    </View>
                </View>
                <View style={styles.grayView}></View>
            </View>)
    }

    /**
     * 显示配送日期列表
     * @private
     */
    _showDateList (index) {
        currentIndex = index
        if (this.props.data[index].deliveryStyle !== 'arbitrarilyday' && this.props.data[index].appointData) {
            this.refs.OrderDatePicker.show(index)
        }
    }


    /**
     * 获取默认属性  上级界面获取过来的
     * @private
     */
    _getDefaultTime() {
        this.props.data.forEach((item, index)=> {
            let sendTime = {};
            let defaultStyle = item.selectDateType;
            let defaultDate = item.selectDate;
            let date = item.date;
            sendTime.selectDate = defaultDate;
            sendTime.selectDateType = defaultStyle;
            sendTime.date = date;
            this.state.sendTimes.push(sendTime)
        });
    }

    /**
     * 渲染nav
     * @private
     */
    _renderNav() {
        return (
            <NavigationBar
                title={'选择配送时间'}
                navigationStyle={{...Platform.select({ios: {marginTop: ScreenUtils.scaleSize(-44)}}),borderBottomColor:Colors.background_grey,borderBottomWidth:ScreenUtils.scaleSize(1)}}
                titleStyle={styles.titleTextStyle}
                barStyle={'dark-content'}
            />
        );
    }

    /**
     * 确定并返回上级界面
     * @private
     */
    _confirmAddress () {
        Actions.pop();
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
    }
});