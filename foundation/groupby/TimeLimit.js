/**
 * Created by zhaojiazhen on 2017/7月15号.
 * 今日团购限时抢购组件
 */
'use strict';

import React, {PureComponent} from 'react'
import {
    View,
    Text,
    Image,
    Dimensions,
    TouchableOpacity,
    ScrollView,
    StyleSheet,
    FlatList
} from 'react-native'

import {Actions} from 'react-native-router-flux';
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
import Swiper from 'react-native-swiper';
import TotayGroupRequest from '../net/group/totayGroup/TotayGroupRequest' ;
import {DataAnalyticsModule} from '../../app/config/AndroidModules';

export default class TimeLimit extends PureComponent {

    constructor(props) {
        super(props);
        this.state = {
            times: ['00', '00', '00', '00', '00', '00'],
            activeIndex: 0,
            startOrEnd: true
        };
    }

    componentDidMount() {
        this.countdownData(0, this.props.limitedTimeBuy)
    }

    render() {
        const {limitedTime} = this.props;
        return (
            <View style={styles.limitedTimeBuyBox}>
                <Image source={require('../Img/groupbuy/img_bg@2x.png')}
                       style={styles.limitedTimeBgImg}>
                    <View style={styles.LimitedTimeHead}>
                        <Text style={styles.title} allowFontScaling={false}>限时抢购</Text>
                        <View style={styles.section}>
                            <Text style={styles.sectionText} allowFontScaling={false}>
                                {limitedTime && limitedTime.length && limitedTime[this.state.activeIndex] &&
                                limitedTime[this.state.activeIndex].length >= 3 ? limitedTime[this.state.activeIndex].substr(0, 2) : ''}
                            </Text>
                            {limitedTime && limitedTime.length && limitedTime[this.state.activeIndex] ?
                                <Text style={styles.sectionText} allowFontScaling={false}>点场</Text>
                                : null}
                        </View>
                        <View style={styles.time}>
                            <Text style={styles.timeStartOrEnd}
                                  allowFontScaling={false}>{this.state.startOrEnd ? '距离开始' : '距离结束'}</Text>
                            <View style={styles.timeBg}>
                                <Text style={styles.timeNum} allowFontScaling={false}>{this.state.times[3]}</Text>
                            </View>
                            <Text style={styles.timeSeparator} allowFontScaling={false}>:</Text>
                            <View style={styles.timeBg}>
                                <Text style={styles.timeNum} allowFontScaling={false}>{this.state.times[4]}</Text>
                            </View>
                            <Text style={styles.timeSeparator} allowFontScaling={false}>:</Text>
                            <View style={styles.timeBg}>
                                <Text style={styles.timeNum} allowFontScaling={false}>{this.state.times[5]}</Text>
                            </View>
                        </View>
                    </View>
                    <View style={styles.LimitedTimeContent}>
                        <Swiper
                            ref="swiper"
                            height={ScreenUtils.scaleSize(400)}

                            marginTop={ScreenUtils.scaleSize(20)}
                            showsButtons={false}
                            index={0}
                            autoplay={false}
                            pagingEnabled={true}
                            onMomentumScrollEnd={this._onMomentumScrollEnd.bind(this)}
                            dot={<View style={{
                                backgroundColor: Colors.text_white,
                                width: 6,
                                height: 6,
                                borderRadius: 3,
                                marginLeft: 3,
                                marginRight: 3,
                                marginTop: 3,
                                marginBottom: 3
                            }}/>
                            }
                            activeDot={<View style={{
                                backgroundColor: Colors.magenta,
                                width: 6,
                                height: 6,
                                borderRadius: 3,
                                marginLeft: 3,
                                marginRight: 3,
                                marginTop: 3,
                                marginBottom: 3
                            }}/>
                            }
                            paginationStyle={{
                                bottom: -3,
                                left: 0,
                                right: 0
                            }}
                            loop={true}>
                            {
                                this.props.limitedGoods.map((item, index) => {
                                    return this._renderIsShow(item, item.length, index);
                                })
                            }
                        </Swiper>
                    </View>
                </Image>
            </View>
        )
    }

    /**
     * 显示每组抢购商品
     * @param data  {object} - 数据源
     * @param number {object} - 每一组商品个数
     * @returns {XML}
     * @private
     */
    _renderIsShow(data, number, index) {
        return (
            <View key={index} style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
                <FlatList
                    keyExtractor={this._keyExtractor}
                    horizontal={true}
                    extraData={this.state}
                    data={data}
                    renderItem={({item, index}) => this._readerItem(item, number, index)}
                /></View>
        )
    }

    _keyExtractor = (item, index) => index;

    /**
     *  每组每个商品的展示组件
     * @param item {object} - 每组商品的数据源
     * @param number {object} - 每一组商品个数
     * @returns {XML}
     * @private
     */

    _readerItem(item, number, index) {
        switch (number) {
            case 1: {
                return (
                    <TouchableOpacity
                        activeOpacity={1}
                        style={styles.singleGoodsView}
                        onPress={() => this._limitLink(item.contentCode)}>
                        <Image style={styles.singleGoodsImg}
                               source={{uri: item.firstImgUrl}}>
                            {(item.discount !== '0') || (item.discount !== '0.0') ?
                                <View style={styles.discountView}>
                                    <Text style={styles.discountAmount} allowFontScaling={false}>{item.discount}<Text
                                        style={{fontSize: ScreenUtils.setSpText(18)}} allowFontScaling={false}>折</Text></Text>
                                </View> : null}
                        </Image>
                        <View style={[styles.singleGoodsInfos]}>
                            <View style={styles.singleGoodsTitle}>
                                <Text style={styles.singleGoodsTNmaes} numberOfLines={3}
                                      allowFontScaling={false}>{item.title}</Text>
                            </View>
                            {this.state.startOrEnd ?
                                <View style={{
                                    backgroundColor: 'transparent',
                                    marginTop: ScreenUtils.scaleSize(30),
                                    flex: 1,
                                    alignItems: 'center'
                                }}>
                                    <Image style={{
                                        width: ScreenUtils.scaleSize(310),
                                        height: ScreenUtils.scaleSize(78),
                                        marginBottom: ScreenUtils.scaleSize(10)
                                    }}
                                           source={require('../Img/groupbuy/img_wait.png')} resizeMode={'stretch'}/>
                                    <Text style={styles.goodsOriginalPrice}
                                          allowFontScaling={false}>￥{item.originalPrice}</Text>
                                </View>
                                :
                                <View style={styles.singleGoodsPrice}>
                                    <Image style={{width: ScreenUtils.scaleSize(90), height: ScreenUtils.scaleSize(26)}}
                                           source={require('../Img/groupbuy/tag_price_@2x.png')}/>
                                    <Text style={{marginTop: ScreenUtils.scaleSize(5)}}>
                                        <Text style={styles.singleGoodsPriceSymbol} allowFontScaling={false}>¥</Text>
                                        <Text style={styles.singleGoodsSalePrice}
                                              allowFontScaling={false}>{item.salePrice}</Text>
                                        <Text> </Text>
                                        <Text style={styles.goodsOriginalPrice}
                                              allowFontScaling={false}>￥{item.originalPrice}</Text>
                                    </Text>
                                    <Text style={styles.singleGoodsSale} allowFontScaling={false}>{item.salesVolume}
                                        件已售</Text>
                                    <View style={{
                                        width: ScreenUtils.scaleSize(120),
                                        height: ScreenUtils.scaleSize(40),
                                        backgroundColor: Colors.main_color,
                                        position: 'absolute',
                                        right: 0,
                                        bottom: 0,
                                        borderRadius: ScreenUtils.scaleSize(6),
                                        justifyContent: 'center',
                                        alignItems: 'center'
                                    }}>
                                        <Text style={{fontSize: ScreenUtils.setSpText(22), color: Colors.text_white}}
                                              allowFontScaling={false}>立即抢购</Text>
                                    </View>
                                </View>}
                        </View>
                    </TouchableOpacity>
                )
            }
                break;

            case 2: {
                return (
                    <TouchableOpacity activeOpacity={1} style={styles.doubleGoodsView}
                                      onPress={() => this._limitLink(item.contentCode)}>
                        <Image style={styles.goodsImg}
                               source={{uri: item.firstImgUrl}}>
                            {(item.discount !== '0') || (item.discount !== '0.0') ?
                                <View style={styles.discountView}>
                                    <Text style={styles.discountAmount} allowFontScaling={false}>{item.discount}<Text
                                        style={{fontSize: ScreenUtils.setSpText(18)}} allowFontScaling={false}>折</Text></Text>
                                </View> : null}
                        </Image>
                        <Text style={styles.goodsName} numberOfLines={1} allowFontScaling={false}>{item.title}</Text>
                        {this.state.startOrEnd ?
                            <View style={{flexDirection: 'column', justifyContent: 'center', alignItems: 'center'}}>
                                <Image style={{
                                    width: ScreenUtils.scaleSize(168),
                                    height: ScreenUtils.scaleSize(19),
                                    marginTop: ScreenUtils.scaleSize(10),
                                    marginBottom: ScreenUtils.scaleSize(10)
                                }}
                                       source={require('../Img/groupbuy/img_wait2.png')}/>
                                <Text style={styles.goodsOriginalPrice}
                                      allowFontScaling={false}>￥{item.originalPrice}</Text>
                            </View>
                            :
                            <View style={styles.goodsPriceView}>
                                <Text style={styles.goodsPriceText}>
                                    <Text style={styles.goodsPriceSymbol} allowFontScaling={false}>￥</Text>
                                    <Text style={styles.goodsSalePrice} allowFontScaling={false}>{item.salePrice}</Text>
                                    <Text> </Text>
                                    <Text style={styles.goodsOriginalPrice}
                                          allowFontScaling={false}>￥{item.originalPrice}</Text>
                                </Text>
                                <Text style={styles.goodsSale} allowFontScaling={false}>{item.salesVolume} 件已售</Text>
                            </View>}
                    </TouchableOpacity>
                )
            }
                break;

            case 3: {
                return (
                    <TouchableOpacity
                        activeOpacity={1}
                        style={[styles.tripleGoodsView, {marginRight: index === 2 ? 0 : ScreenUtils.scaleSize(10)}]}
                        onPress={() => this._limitLink(item.contentCode)}>
                        <Image style={styles.goodsImg}
                               source={{uri: item.firstImgUrl}}>
                            {(item.discount !== '0') || (item.discount !== '0.0') ?
                                <View style={styles.discountView}>
                                    <Text style={styles.discountAmount} allowFontScaling={false}>{item.discount}<Text
                                        style={{fontSize: ScreenUtils.setSpText(18)}} allowFontScaling={false}>折</Text></Text>
                                </View> : null}
                        </Image>
                        <Text style={styles.goodsName} numberOfLines={1} allowFontScaling={false}>{item.title}</Text>
                        {this.state.startOrEnd ?
                            <View style={{flexDirection: 'column', justifyContent: 'center', alignItems: 'center'}}>
                                <Image style={{
                                    width: ScreenUtils.scaleSize(168),
                                    height: ScreenUtils.scaleSize(19),
                                    marginTop: ScreenUtils.scaleSize(10),
                                    marginBottom: ScreenUtils.scaleSize(10)
                                }}
                                       source={require('../Img/groupbuy/img_wait2.png')}/>
                                <Text style={styles.goodsOriginalPrice}
                                      allowFontScaling={false}>￥{item.originalPrice}</Text>
                            </View>
                            :
                            <View style={styles.goodsPriceView}>
                                <Text style={styles.goodsPriceText}>
                                    <Text style={styles.goodsPriceSymbol} allowFontScaling={false}>￥</Text>
                                    <Text style={styles.goodsSalePrice} allowFontScaling={false}>{item.salePrice}</Text>
                                    <Text> </Text>
                                    <Text style={styles.goodsOriginalPrice}
                                          allowFontScaling={false}>￥{item.originalPrice}</Text>
                                </Text>
                                <Text style={styles.goodsSale} allowFontScaling={false}>{item.salesVolume} 件已售</Text>
                            </View>}
                    </TouchableOpacity>
                )
            }
                break;
            default:
                break;

        }
    }

    _onMomentumScrollEnd() {
        this._getServiceTime();
        this.setState({
            activeIndex: this.refs.swiper.state.index
        });
    }

    _getServiceTime() {
        if (this.TotayGroupRequest) {
            this.TotayGroupRequest.setCancled(true);
        }
        this.TotayGroupRequest = new TotayGroupRequest({id: "AP1706A008"}, 'GET');
        this.TotayGroupRequest.start(
            (response) => {
                console.log(response);
                let data = response.data;
                if (data.packageList && data.packageList.length > 0) {
                    let packageList = data.packageList;
                    packageList.forEach((component, index) => {
                        if (component && component.packageId === '26') {   // packageId  = "26" 获取限时抢购数据
                            let limitedTimeBuy = component.componentList;
                            this.countdownData(this.refs.swiper.state.index, limitedTimeBuy);
                        }
                    })
                }
                ;
            }, (erro) => {
                // console.log(erro);
            }
        );
    }

    /**
     *  跳入商品详情页面
     * @param item
     * @private
     */
    _limitLink(item) {
        DataAnalyticsModule.trackEvent3(item.codeValue, "", {
            'pID': this.props.codeValue,
            'vID': this.props.pageVersionName
        });
        Actions.GoodsDetailMain({'itemcode': item});
    }

    /**
     * 倒计时
     */
    countdownData(index, limitedTimeBuy) {
        let countData = limitedTimeBuy;
        if (countData && countData.length > 0) {
            let countDown = [];
            let startOrEnd = [];
            countData.forEach(item => {
                let distance = (Number(item.endDateLong) - Number(item.curruntDateLong)) / 1000;
                countDown.push(distance);
                // Number(item.curruntDateLong) - Number(item.playDateLong) ? startOrEnd.push(false) : startOrEnd.push(true);
                let duration = Number(item.curruntDateLong) - Number(item.playDateLong);
                startOrEnd.push((duration && duration !== NaN && duration < 0));
            });
            this.timeStart(countDown[index]);
            this.setState({
                startOrEnd: startOrEnd[index]
            });
        }
    }

    /**
     * 倒计时 运算
     * @param distance
     */
    timeStart(distance) {
        if (distance > 0) {
            if (this.interval) {
                clearInterval(this.interval);
            }
            this.interval = setInterval(() => {
                if (distance <= 0) {
                    clearInterval(this.interval);
                }//时间到
                this.setState({
                    times: ScreenUtils.getRemainingimeDistance(distance),//获取时间数组
                });
                // console.log(this.state.times);
                distance--;
            }, 1000);
        }
    }


    /**
     * 清除倒计时
     */
    componentWillUnmount() {
        clearInterval(this.interval);
    }


}


const styles = StyleSheet.create({
    limitedTimeBuyBox: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(522),
        alignItems: "center",
        justifyContent: "center",
        marginTop: ScreenUtils.scaleSize(20)
    },
    limitedTimeBgImg: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(522),
    },
    LimitedTimeHead: {
        backgroundColor: "transparent",
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "space-between",
        paddingLeft: ScreenUtils.scaleSize(30),
        paddingRight: ScreenUtils.scaleSize(30)
    },
    title: {
        fontSize: ScreenUtils.setSpText(32),
        color: Colors.text_white,
    },
    section: {
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center"
    },
    sectionText: {
        color: Colors.text_white,
        fontSize: ScreenUtils.scaleSize(32)
    },
    time: {
        flexDirection: "row",
        height: ScreenUtils.scaleSize(87),
        alignItems: "center",
    },
    timeStartOrEnd: {
        fontSize: ScreenUtils.setSpText(26),
        color: Colors.text_white,
        marginRight: ScreenUtils.scaleSize(10)
    },
    timeBg: {
        width: ScreenUtils.scaleSize(60),
        height: ScreenUtils.scaleSize(40),
        backgroundColor: Colors.text_white,
        borderRadius: ScreenUtils.scaleSize(4),
        alignItems: "center",
        justifyContent: "center",
    },
    timeNum: {
        color: Colors.magenta
    },
    timeSeparator: {
        color: Colors.text_white,
        paddingLeft: ScreenUtils.scaleSize(20),
        paddingRight: ScreenUtils.scaleSize(20)
    },
    LimitedTimeContent: {
        width: ScreenUtils.screenW,
        flexDirection: "row",
        alignItems: "center",
        justifyContent: "center",

        // backgroundColor: '#fff000'
    },
    // timeLimitStyle:{
    //     width: ScreenUtils.screenW,
    //     flexDirection:"row",
    //     marginLeft:ScreenUtils.scaleSize(50),
    //     marginRight:ScreenUtils.scaleSize(50),
    //     justifyContent:"center",
    //     alignItems:"center"
    // },
    singleGoodsView: {
        backgroundColor: Colors.background_white,
        height: ScreenUtils.scaleSize(340),
        padding: ScreenUtils.scaleSize(20),
        flexDirection: "row",
        // justifyContent:"center",
        alignItems: "center",
    },
    singleGoodsImg: {
        width: ScreenUtils.scaleSize(270),
        height: ScreenUtils.scaleSize(270),
    },
    discountView: {
        width: ScreenUtils.scaleSize(70),
        height: ScreenUtils.scaleSize(40),
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: Colors.main_color,
    },
    discountAmount: {
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(26)
    },
    singleGoodsInfos: {
        width: ScreenUtils.scaleSize(380),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    singleGoodsTitle: {
        flex: 1,
        height: ScreenUtils.scaleSize(200),
    },
    singleGoodsTNmaes: {
        fontSize: ScreenUtils.setSpText(30),
        color: Colors.text_black,
    },
    singleGoodsPrice: {
        flex: 1,
        marginTop: ScreenUtils.scaleSize(100)
    },
    singleGoodsPriceSymbol: {
        color: Colors.main_color,
        fontSize: ScreenUtils.setSpText(24),
    },
    singleGoodsSalePrice: {
        color: Colors.main_color,
        fontSize: ScreenUtils.setSpText(32),
    },
    singleGoodsSale: {
        fontSize: ScreenUtils.setSpText(22),
        color: Colors.text_dark_grey,
    },
    doubleGoodsView: {
        backgroundColor: Colors.background_white,
        flex: 1,
        marginLeft: ScreenUtils.scaleSize(41),
        marginRight: ScreenUtils.scaleSize(41),
        padding: ScreenUtils.scaleSize(20),
    },
    tripleGoodsView: {
        backgroundColor: Colors.background_white,
        padding: ScreenUtils.scaleSize(10),
      // marginRight: ScreenUtils.scaleSize(10),
        justifyContent: "center",
    },
    goodsImg: {
        width: ScreenUtils.scaleSize(220),
        height: ScreenUtils.scaleSize(220),
    },
    goodsName: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(28),
        paddingTop: ScreenUtils.scaleSize(15),
        width: ScreenUtils.scaleSize(220),
        height: ScreenUtils.scaleSize(50),
    },
    goodsPriceView: {
        // flexDirection:"row",
        justifyContent: "flex-end"
    },
    goodsPriceText: {
        flexDirection: "row",
        paddingTop: ScreenUtils.scaleSize(12),
    },
    goodsPriceSymbol: {
        color: Colors.main_color,
        fontSize: ScreenUtils.setSpText(22),
    },
    goodsSalePrice: {
        color: Colors.main_color,
        fontSize: ScreenUtils.setSpText(30),
    },
    goodsOriginalPrice: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(22),
        textDecorationLine: "line-through",
        marginLeft: ScreenUtils.scaleSize(10),
    },
    goodsSale: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(22),
        paddingTop: ScreenUtils.scaleSize(8),
    },
})
