/**
 * Created by jzz on 2017/6/11.
 * 订单配送时间选择
 */

import React,{PropTypes} from 'react';
import {Actions}from 'react-native-router-flux';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    DeviceEventEmitter,
} from 'react-native';
import Colors from '../../config/colors';
import OrderDatePicker from './OrderDatePicker';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import {DataAnalyticsModule} from '../../config/AndroidModules';
export default class OrderDistributionDate extends React.Component{

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            showDescription: false, // 当指定配送时间的时候 需要显示 '指定日发货' 描述文字
            refreshTitle: '',
            showDateArr: [],
            refresh: false
        };
        this._getDefaultTime();
    }

    componentWillMount() {
        DeviceEventEmitter.addListener('REQUEST_CHANGE_ADDRESS', this._getDefaultTime.bind(this, 'notify'));
        DeviceEventEmitter.addListener('FRESH_PACKAGEDATE', this.freshOrder.bind(this));
    }

    componentWillUnmount() {
        DeviceEventEmitter.removeListener('FRESH_PACKAGEDATE');
        DeviceEventEmitter.removeListener('REQUEST_CHANGE_ADDRESS');
    }

    render () {
        const { showDateArr } = this.state
        const { data } = this.props
        return(
            <View>
                {
                    showDateArr.length === 1 ?
                    <TouchableOpacity activeOpacity={1} onPress={() => this._chooseDistributionDate()}>
                        <View style={styles.container}>
                            <Text
                                allowFontScaling={false}
                                style={styles.title}>配送时间</Text>
                            <Text
                                allowFontScaling={false}
                                style={styles.chooseDate}>
                                {showDateArr[0].selectDate}{' '} {showDateArr[0].date}
                            </Text>
                            {
                                showDateArr[0].selectDateType === '0' ?
                                <View/>
                                    :
                                <Image style={styles.icon}
                                       source={require('../../../foundation/Img/home/store/icon_view_more_.png')}>
                                </Image>
                            }
                        </View>
                    </TouchableOpacity>
                        :
                    <View/>
                }

                {
                    showDateArr.length >1
                        ?
                    <View>
                        <View style={styles.container}>
                            <Text
                                allowFontScaling={false}
                                style={styles.title}>配送时间</Text>
                            <TouchableOpacity activeOpacity={1} onPress={() => this._chooseDistributionDate()}>
                                <View style={styles.pushBtn}>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.change}>
                                        修改
                                    </Text>
                                    <Image style={styles.icon}
                                           source={require('../../../foundation/Img/home/store/icon_view_more_.png')}>
                                    </Image>
                                </View>
                            </TouchableOpacity>

                        </View>
                        {
                            showDateArr.map(function (item, index) {
                                return(
                                    <View style={styles.dateDetail} key={item + index}>
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.package}>
                                            包裹{index + 1}
                                        </Text>
                                        <Text
                                            allowFontScaling={false}
                                            style={styles.packageDate}>
                                            {item.selectDate}{' '}{item.date}
                                        </Text>
                                    </View>
                                )
                            })
                        }
                    </View>
                        :
                    <View />
                }
                <OrderDatePicker ref='OrderDatePicker'
                                 data={data}
                                 refresh={() => {}} />
            </View>
        );
    }

    /**
     * 刷新配送日期列表
     * @private
     */
    freshOrder () {
        let dataArr = [];
        this.props.data.forEach((item,index)=>{
            let pay={};
            pay.selectDate = item.selectDate;
            pay.selectDateType = item.selectDateType;
            pay.date = item.date;
            dataArr.push(pay);
        });
        this.setState({
            showDateArr: dataArr
        })
    }

    /**
     * 配置默认选中界面
     * @private
     */
    _getDefaultTime(notify) {
        this.props.data.forEach((item,index)=>{
            let sendTime={};
            let deliveryStyle = item.deliveryStyle;
            let defaultStyle = '';
            let defaultDate='';
            let date = '';
            //如果是任意配送时间
            if (deliveryStyle === 'arbitrarilyday') {
                defaultStyle = '0';
                defaultDate='任意日期配送';
                date = '';
            } else if (deliveryStyle === 'appointday' && item.appointData) {
                item.appointData.forEach((appoint,index)=>{
                    if(appoint.workyn==='1'){
                        defaultStyle = '1';
                        defaultDate=appoint.date_day_t;
                        date = appoint.weekdayDescr;
                        return;
                    }
                });
            } else if (deliveryStyle === 'all') {
                defaultStyle = '2';
                defaultDate='任意日期配送';
                date = '';
            }
            item.selectDate=defaultDate;
            item.selectDateType=defaultStyle;
            item.date= date;
            sendTime.selectDate = defaultDate;
            sendTime.selectDateType = defaultStyle;
            sendTime.date = date;
            this.state.showDateArr = [];
            this.state.showDateArr.push(sendTime);
        });
        if (notify) {
            this.setState({
                refresh: !this.state.refresh
            })
        }
    }

    /**
     * 进入选择配送时间详情页
     * @private
     */
    _chooseDistributionDate () {
        if (this.state.showDateArr.length > 1) {
            Actions.OrderDistributionDateDetail({data: this.props.data});
            let date = [];
            this.props.data.forEach((item,index)=>{
                date.push(item.selectDate)
            })
            DataAnalyticsModule.trackEvent3("AP1706C017F010003A001001", "",{'time': date});

        } else {
            if (this.state.showDateArr[0].selectDateType === '2'){
                DataAnalyticsModule.trackEvent3("AP1706C016F010002A001001", "",{'time': this.props.data[0].selectDate});
                this.refs.OrderDatePicker.show(0);
            }
        }

    }

}
const styles=StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        height: ScreenUtils.scaleSize(88),
        paddingHorizontal: ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(20),
        flexDirection: 'row',
        alignItems: 'center',
    },
    title: {
        flex: 1,
        fontSize: ScreenUtils.scaleSize(30),
        color:Colors.text_black
    },
    descriptionBg: {
        width: ScreenUtils.scaleSize(130),
        height: ScreenUtils.scaleSize(40),
        backgroundColor: Colors.background_light_orange,
        alignItems: 'center',
        justifyContent: 'center',
        borderRadius: ScreenUtils.scaleSize(4),
    },
    description: {
        fontSize: ScreenUtils.scaleSize(20),
        color: Colors.text_orange,
    },
    chooseDate: {
        marginLeft: ScreenUtils.scaleSize(6),
        fontSize: ScreenUtils.scaleSize(24),
        color: Colors.text_dark_grey,
    },
    icon: {
        marginLeft: ScreenUtils.scaleSize(6),
        width: ScreenUtils.scaleSize(18),
        height: ScreenUtils.scaleSize(26),
    },
    dateDetail: {
        flexDirection: 'row',
        height: ScreenUtils.scaleSize(70),
        alignItems: 'center',
        justifyContent:'space-between',
        paddingHorizontal: ScreenUtils.scaleSize(30),
        backgroundColor: Colors.background_white,
    },
    package: {
        fontSize: ScreenUtils.scaleSize(26),
        color: Colors.text_black,
    },
    change: {
        fontSize: ScreenUtils.scaleSize(26),
        color: Colors.text_dark_grey,
        width: ScreenUtils.scaleSize(60),
    },
    packageDate: {
        fontSize: ScreenUtils.scaleSize(26),
        color: Colors.text_dark_grey,
    },
    pushBtn: {
        width: ScreenUtils.scaleSize(100),
        height: ScreenUtils.scaleSize(80),
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row'
    }
});