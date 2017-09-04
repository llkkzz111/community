/**
 * Created by xiongmeng on 2017/5/1.
 * 视频直播页面
 */
'use strict';

import React from 'react';

import {
    StyleSheet,
    View,
    Image,
    TouchableOpacity,
    Dimensions,
    FlatList,
    Text,
    ScrollView,
    Platform,
    InteractionManager,
    DeviceEventEmitter
} from 'react-native';

import LiveInfor from '../../../foundation/shoppingpage/LiveInfor';

import PreparationItem from '../../../foundation/shoppingpage/PreparationItem';

import GetVideoPageData from '../../../foundation/net/video/GetVideoPageData';

import Fonts from '../../../app/config/fonts';

import Colors from '../../../app/config/colors';

import * as ScreenUtil from '../../../foundation/utils/ScreenUtil';

import NavigationBar from '../../../foundation/common/NavigationBar';

import Toast, {DURATION} from 'react-native-easy-toast';

import VideoDateTitle from '../../../foundation/shoppingpage/VideoDateTitle';

import CalendarModule from '../../../foundation/shoppingpage/CalendarModule';

import {DataAnalyticsModule} from '../../config/AndroidModules';
import * as RouteManager from '../../config/PlatformRouteManager';
import {Actions} from 'react-native-router-flux';
import * as routeConfig from '../../config/routeConfig';
import NetErro from '../../components/error/NetErro';


// 为本页添加缓存   缓存策略为  当天: 1小时缓存 不足一小时到第二天,缓存剩余时间  历史:缓存一天  未来:一小时
import * as LocalStorage from '../../../foundation/LocalStorage'

let codeValue = '';
let pageVersionName = '';

let {width, height} = Dimensions.get('window');

import moment from 'moment';

const customDayHeadings = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

const customMonthNames = ['1月', '2月', '3月', '4月', '5月',
    '6月', '7月', '8月', '9月', '10月', '11月', '12月'];

let date0, date1, date2, date3, date4;

let day0, day1, day3, day4;

let dateArray = [];

let preMonth, nextMonth;

let month1 = [1, 3, 5, 7, 8, 10, 12];

let month2 = [4, 6, 9, 11];

let month3 = [2];

export default class OnLiveVideoPage extends React.PureComponent {
    constructor(props) {
        super(props);
        this.icons = {
            'down': require('../../../foundation/Img/video/icon_up_@3x.png'),
            'up': require('../../../foundation/Img/video/icon_down_@3x.png')
        };
        this.childView;
        this.state = {
            open: true,
            expanded: false,
            expand: false,
            showDateModal: false,
            selectTab: 0,//初期显示TAB
            toTabIndex: -1,//去指定TAB
            data: [],
            isRefreshing: false,
            selectedDate: '',
            titleData: [],
            dateTitleIndex: 2,
            netStatus: true,//true:网络正常,false异常
            errStatus: true,//true:无错误,false有错误
        };
        this._click = this._click.bind(this);
        this._selectDateCallback = this._selectDateCallback.bind(this);
        this.initDate = this.initDate.bind(this);
        this.refreshDate = this.refreshDate.bind(this);
        this.leapYear = this.leapYear.bind(this);
        this.contain = this.contain.bind(this);
        this.getDateModule = this.getDateModule.bind(this);
        this._refreshVideo = this._refreshVideo.bind(this);
        this._dateCallBack = this._dateCallBack.bind(this);
        this._indexCallBack = this._indexCallBack.bind(this);
        this._getData = this._getData.bind(this);
        this.playY = 0;   //正在播放的位置
    }

    componentDidMount() {
        // InteractionManager.runAfterInteractions(() => {
        this._getAllVideo();
        this.initDate();
        // })
        DeviceEventEmitter.addListener('showToast', () => {
            this.refs.toast.show("请先登录", DURATION.LENGTH_LONG);
        });
    }

    _getData() {
        NetInfo.fetch().done((status) => {
            if (status !== 'none' || status !== 'NONE') {
                this._getAllVideo();
            } else {
                this.refs.toast.show('网络异常', DURATION.LENGTH_LONG);
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        })
    }

    _refreshVideo(today, flag = false) {
        this.GetVideoData = new GetVideoPageData({id: 'AP1706A047', playDate: today}, 'GET');
        //if (flag) this.GetVideoData.showLoadingView();
        this.GetVideoData.showLoadingView().start(
            (response) => {
                let data = response.data.packageList
                if (response.code === 200) {
                    // if (data && data[0].componentList && data[0].componentList.length &&
                    //     data[1].componentList && data[1].componentList.length && data[2].componentList &&
                    //     data[2].componentList.length ) {
                    //     this.refs.toast.show('当前选中日期暂无相关视频', DURATION.LENGTH_LONG);
                    // }
                    this.setState({
                        data: response.data.packageList,
                        isRefreshing: false,
                        netStatus: true,
                        errStatus: true,
                    });
                    //视频页面埋点
                    codeValue = response.data.codeValue;
                    pageVersionName = response.data.pageVersionName;
                    DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                } else {
                    this.refs.toast.show(response.code, DURATION.LENGTH_LONG);
                    this.setState({
                        isRefreshing: false,
                        netStatus: true,
                        errStatus: false,
                    });
                }
            }, (error) => {
                this.setState({
                    isRefreshing: false,
                    netStatus: true,
                    errStatus: false,
                });
            });
    }

    itemSep() {
        return (<View style={{
            marginLeft: ScreenUtil.scaleSize(30),
            height: ScreenUtil.scaleSize(0.5),
            backgroundColor: '#ddd'
        }}></View>)
    }

    _getAllVideo() {
        this.setState({isRefreshing: true});
        if (this.GetVideoData) {
            this.GetVideoData.setCancled(true);
        }

        let tim = moment().format('YYYY-MM-DD').toString();
        let year = tim.substring(0, 4);
        let toMonth = tim.substring(5, 7);
        let day = tim.substring(8, 10);
        let today = parseInt(year) + '-' + parseInt(toMonth) + '-' + parseInt(day);
        this._refreshVideo(today, true);
    }

    componentWillUnmount() {
        //页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }

    /**
     * 渲染导航栏
     * @private
     */
    _renderNav() {
        return (
            <NavigationBar
                title={'节目单'}
                titleStyle={{
                    backgroundColor: 'transparent',
                    color: Colors.text_white,
                    fontSize: ScreenUtil.scaleSize(34)
                }}
                navigationStyle={{
                    ...Platform.select({ios: {marginTop: ScreenUtil.scaleSize(-44)}}),
                    height: ScreenUtil.scaleSize(128)
                }}
                leftButton={require('../../../foundation/Img/shoppingPage/Icon_back_white_@3x.png')}
                showRight={false}
                barStyle={'light-content'}
                navigationBarBackgroundImage={require('../../../foundation/Img/groupbuy/Icon_brand_bg_.png')}
            />
        );
    }

    imgClick(video) {
        DataAnalyticsModule.trackEvent3(video.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
        switch (video.type) {
            case 1:   //tv
                RouteManager.routeJump({
                    page: routeConfig.Video,
                    param: {id: video.id},
                    //fromRNPage: routeConfig.VideoNewest,
                });
                break;
            case 2:   //网络
                Actions.VipPromotion({value: video.url});
                break;
            case 3:   //短视频
                RouteManager.routeJump({
                    page: routeConfig.Video,
                    param: {id: video.id},
                    //fromRNPage: routeConfig.VideoNewest,
                });
                break;
            default:
                break;
        }
    }

    render() {
        this.childView = this.childView || <CalendarModule ref="calendar"
                                                           calendarFormat={'monthly'}
                                                           dayHeadings={customDayHeadings}
                                                           monthNames={customMonthNames}
                                                           titleFormat={'MMMM YYYY'}
                                                           prevButtonText={'上个月'}
                                                           nextButtonText={'下个月'}
                                                           weekStart={1}
                                                           onDateSelect={(date) => {
                                                               this._selectDateCallback(date)
                                                           }}
                                                           onTouchPrev={(e) => console.log('onTouchPrev: ', e)}
                                                           onTouchNext={(e) => console.log('onTouchNext: ', e)}
                                                           onSwipePrev={(e) => console.log('onSwipePrev: ', e)}
                                                           onSwipeNext={(e) => console.log('onSwipeNext', e)}/>;
        let icon = this.icons['up'];
        if (this.state.expanded) icon = this.icons['down'];
        let data = this.state.data;
        let viewingList = [];
        let willList = [];
        let playbackList = [];
        let showNoView = false;
        if (data && data.length) {
            if (data[0] && data[0].componentList && data[0].componentList[0]) {
                viewingList = data[0].componentList[0].componentList;
            }
            if (data[1] && data[1].componentList && data[1].componentList[0]) {
                willList = data[1].componentList[0].componentList;
            }
            if (data[2] && data[2].componentList && data[2].componentList[0]) {
                playbackList = data[2].componentList[0].componentList;
            }
            // if (viewingList.length === 0 && willList.length === 0 && playbackList.length === 0) {
            //     showNoView = true;
            //     alert('showNoView')
            // }
        }
        //网络错误
        if (!this.state.netStatus) {
            return (
                <View style={{flex: 1}}>
                    {
                        /*渲染navigator*/
                        this._renderNav()

                    }
                    <NetErro
                        style={{flex: 1}}
                        title={'您的网络好像很傲娇'}
                        confirmText={'刷新试试'}
                        icon={require('../../../foundation/Img/cart/img_net_error_3x.png')}
                        onButtonClick={() => {
                            //根据不同的页面做不同的请求
                            this._getData();
                        }}
                    />
                    <Toast ref="toast"/>
                </View>

            );
        }
        //异常发生
        if (!this.state.errStatus) {
            return (
                <View style={styles.container}>
                    {
                        /*渲染navigator*/
                        this._renderNav()

                    }
                    <NetErro
                        style={{flex: 1}}
                        title={'亲,服务异常啦!'}
                        confirmText={'刷新试试'}
                        onButtonClick={() => {
                            this._getData();
                        }}
                    />
                    <Toast ref="toast"/>
                </View>
            );
        }

        return (
            <View style={styles.baseBg}>
                {this._renderNav()}
                <View style={styles.dateTitleBg}>
                    <View style={styles.videoTitleBg}>
                        <VideoDateTitle titleData={this.state.titleData}
                                        select={this.state.dateTitleIndex}
                                        indexCallBack={(params) => {
                                            this._indexCallBack(params)
                                        }}
                                        dateCallBack={(date) => {
                                            this._dateCallBack(date)
                                        }}/>
                        <View style={{
                            width: ScreenUtil.screenW, height: ScreenUtil.scaleSize(0.5),
                            backgroundColor: '#DDDDDD'
                        }}/>
                    </View>
                    <TouchableOpacity activeOpacity={1} onPress={this._click} style={styles.dateImgBg}>
                        <Image style={styles.dateImg} resizeMode={'stretch'} source={icon}/>
                    </TouchableOpacity>
                </View>
                <View style={styles.basicBg}>
                    <ScrollView
                        ref="_scrollview"
                        onContentSizeChange={() => {
                            if (this.playY > 0) {
                                this.refs._scrollview.scrollTo({y: this.playY, animated: false});
                            }
                        }}
                        onLayout={() => {
                            if (this.playY > 0) {
                                this.refs._scrollview.scrollTo({y: this.playY, animated: false});
                            }
                        }}
                        showsVerticalScrollIndicator={false}
                        showsHorizontalScrollIndicator={false} tabLabel={"今日"}>

                        <View style={styles.allInfor}>
                            {/*精彩回放*/}
                            {playbackList && playbackList.length > 0 ?
                                <View style={styles.onLiveBackView}>
                                    <View style={styles.centerViewStyle}>
                                        <Text allowFontScaling={false}
                                              style={styles.onLiveTextStyle}>{'· 精彩回放 ·'}</Text>
                                    </View>
                                    <View style={{
                                        width: ScreenUtil.screenW, height: ScreenUtil.scaleSize(0.5),
                                        backgroundColor: '#DDDDDD'
                                    }}/>
                                    <FlatList showsHorizontalScrollIndicator={false} data={playbackList}
                                              renderItem={({item, index}) => {
                                                  return (
                                                      <View key={index} style={{backgroundColor: '#FFFFFF'}}>
                                                          <LiveInfor liveInforData={item} imgClick={(video) => {
                                                              this.imgClick(video);
                                                          }}/>
                                                      </View>
                                                  )
                                              }}
                                              ItemSeparatorComponent={this.itemSep}
                                    >
                                    </FlatList>
                                    <View style={{
                                        width: ScreenUtil.screenW, height: ScreenUtil.scaleSize(20),
                                        backgroundColor: '#DDDDDD'
                                    }}/>
                                </View> : null}

                            {/*正在播出*/}
                            {viewingList && viewingList.length > 0 ?
                                <View style={styles.onLivingView} onLayout={e => {
                                    this.playY = e.nativeEvent.layout.y;
                                }}>
                                    <View style={styles.centerViewStyle}>
                                        <Text allowFontScaling={false}
                                              style={styles.onLiveTextStyle}>{'· 正在播出 ·'}</Text>
                                    </View>
                                    <View style={{
                                        width: ScreenUtil.screenW,
                                        height: ScreenUtil.scaleSize(0.5),
                                        backgroundColor: '#DDDDDD'
                                    }}/>

                                    <FlatList showsHorizontalScrollIndicator={false} data={viewingList}
                                              renderItem={({item, index}) => {
                                                  return (
                                                      <View key={index} style={{backgroundColor: '#DDDDDD'}}>
                                                          <LiveInfor liveInforData={item}
                                                                     imgClick={(video) => {
                                                                         this.imgClick(video);
                                                                     }}
                                                                     now={true}/>
                                                      </View>
                                                  )
                                              }}
                                              ItemSeparatorComponent={this.itemSep}
                                    >
                                    </FlatList>
                                    <View style={{
                                        width: ScreenUtil.screenW, height: ScreenUtil.scaleSize(20),
                                        backgroundColor: '#DDDDDD'
                                    }}/>
                                </View> : null}

                            {/*即将播出*/}
                            {willList && willList.length > 0 ?

                                <View style={styles.onLivingView}>
                                    <View style={styles.centerViewStyle}>
                                        <Text allowFontScaling={false}
                                              style={styles.onLiveTextStyle}>{'· 即将播出 ·'}</Text>
                                    </View>
                                    <View style={{
                                        width: ScreenUtil.screenW,
                                        height: ScreenUtil.scaleSize(0.5),
                                        backgroundColor: '#DDDDDD'
                                    }}/>

                                    <FlatList showsHorizontalScrollIndicator={false} data={willList}
                                              renderItem={({item, index}) => {
                                                  return (
                                                      <PreparationItem key={index} preparationItem={item}/>
                                                  )
                                              }}>
                                    </FlatList>
                                </View> : null}
                        </View>
                    </ScrollView>
                </View>
                {this.state.expand ?
                    <View style={styles.bg}>
                        <View style={styles.dateBg}>
                            {this.childView}
                        </View>
                        <TouchableOpacity activeOpacity={1} style={styles.popBg} onPress={this._click}/>
                    </View> : null
                }
                <Toast ref="toast"/>

            </View>
        )
    }

    _indexCallBack(params) {
        this.setState({
            dateTitleIndex: params
        });
    }

    contain(a, obj) {
        let i = a.length;
        while (i--) {
            if (a[i] === obj) {
                return true;
            }
        }
        return false;
    }

    initDate() {
        let tim = moment().format('YYYY-MM-DD').toString();
        let year = tim.substring(0, 4);
        let toMonth = tim.substring(5, 7);
        let day = tim.substring(8, 10);
        this.refreshDate(parseInt(year), parseInt(toMonth), parseInt(day), false);
    }

    leapYear(year) {
        if (((year % 400 === 0) || (year % 100 !== 0) ) && (year % 4 === 0)) {
            return true;
        } else {
            return false;
        }
    }

    getDateModule(index, year, month, day) {
        return {index: index, year: year, title: month + '月' + day + '日'}
    }

    refreshDate(year, month, date, openMenu) {
        let dateData = parseInt(date);
        let monthData = parseInt(month);
        let flag = this.leapYear(parseInt(year));
        day0 = '';
        day1 = '';
        day3 = '';
        day4 = '';
        let nivada = this.contain(month3, monthData);
        let intel = this.contain(month1, monthData);
        if (nivada) {
            if (flag) {
                if (dateData === 1) {
                    date0 = this.getDateModule(0, year, 1, 30);
                    date1 = this.getDateModule(1, year, 1, 31);
                    date2 = this.getDateModule(2, year, monthData, 1);
                    date3 = this.getDateModule(3, year, monthData, 2);
                    date4 = this.getDateModule(4, year, monthData, 3);
                } else if (dateData === 2) {
                    date0 = this.getDateModule(0, year, 1, 31);
                    date1 = this.getDateModule(1, year, monthData, 1);
                    date2 = this.getDateModule(2, year, monthData, 2);
                    date3 = this.getDateModule(3, year, monthData, 3);
                    date4 = this.getDateModule(4, year, monthData, 4);
                } else if (date === 28) {
                    date0 = this.getDateModule(0, year, monthData, 26);
                    date1 = this.getDateModule(1, year, monthData, 27);
                    date2 = this.getDateModule(2, year, monthData, 28);
                    date3 = this.getDateModule(3, year, monthData, 29);
                    date4 = this.getDateModule(4, year, 3, 1);
                } else if (dateData === 29) {
                    date0 = this.getDateModule(0, year, monthData, 27);
                    date1 = this.getDateModule(1, year, monthData, 28);
                    date2 = this.getDateModule(2, year, monthData, 29);
                    date3 = this.getDateModule(3, year, 3, 1);
                    date4 = this.getDateModule(4, year, 3, 2);
                } else {
                    day0 = dateData - 2;
                    day1 = dateData - 1;
                    day3 = dateData + 1;
                    day4 = dateData + 2;
                    date0 = this.getDateModule(0, year, monthData, day0);
                    date1 = this.getDateModule(1, year, monthData, day1);
                    date2 = this.getDateModule(2, year, monthData, dateData);
                    date3 = this.getDateModule(3, year, monthData, day3);
                    date4 = this.getDateModule(4, year, monthData, day4);
                }
            } else {
                if (dateData === 1) {
                    date0 = this.getDateModule(0, year, 1, 30);
                    date1 = this.getDateModule(1, year, 1, 31);
                    date2 = this.getDateModule(2, year, monthData, 1);
                    date3 = this.getDateModule(3, year, monthData, 2);
                    date4 = this.getDateModule(4, year, monthData, 3);
                } else if (dateData === 2) {
                    date0 = this.getDateModule(0, year, 1, 31);
                    date1 = this.getDateModule(1, year, monthData, 1);
                    date2 = this.getDateModule(2, year, monthData, 2);
                    date3 = this.getDateModule(3, year, monthData, 3);
                    date4 = this.getDateModule(4, year, monthData, 4);
                } else if (date === 27) {
                    date0 = this.getDateModule(0, year, monthData, 25);
                    date1 = this.getDateModule(1, year, monthData, 26);
                    date2 = this.getDateModule(2, year, monthData, 27);
                    date3 = this.getDateModule(3, year, monthData, 28);
                    date4 = this.getDateModule(4, year, 3, 1);
                } else if (dateData === 28) {
                    date0 = this.getDateModule(0, year, monthData, 26);
                    date1 = this.getDateModule(1, year, monthData, 27);
                    date2 = this.getDateModule(2, year, monthData, 28);
                    date3 = this.getDateModule(3, year, 3, 1);
                    date4 = this.getDateModule(4, year, 3, 2);
                } else {
                    day0 = dateData - 2;
                    day1 = dateData - 1;
                    day3 = dateData + 1;
                    day4 = dateData + 2;
                    date0 = this.getDateModule(0, year, monthData, day0);
                    date1 = this.getDateModule(1, year, monthData, day1);
                    date2 = this.getDateModule(2, year, monthData, dateData);
                    date3 = this.getDateModule(3, year, monthData, day3);
                    date4 = this.getDateModule(4, year, monthData, day4);
                }
            }
        } else {
            if (intel) {
                month1.map((it) => {
                    if (it === monthData) {
                        if (it === 1) {
                            if (dateData === 1) {
                                let preYear = parseInt(year) - 1;
                                date0 = this.getDateModule(0, preYear, 12, 30);
                                date1 = this.getDateModule(1, preYear, 12, 31);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, 2);
                                date4 = this.getDateModule(4, year, monthData, 3);
                            } else if (dateData === 2) {
                                let preYear = parseInt(year) - 1;
                                date0 = this.getDateModule(0, preYear, 12, 31);
                                date1 = this.getDateModule(1, year, monthData, 1);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, 3);
                                date4 = this.getDateModule(4, year, monthData, 4);
                            } else if (dateData === 30) {
                                date0 = this.getDateModule(0, year, 1, 28);
                                date1 = this.getDateModule(1, year, 1, 29);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, 31);
                                date4 = this.getDateModule(4, year, 2, 1);
                            } else if (dateData === 31) {
                                date0 = this.getDateModule(0, year, 1, 29);
                                date1 = this.getDateModule(1, year, 1, 30);
                                date2 = this.getDateModule(2, year, 1, dateData);
                                date3 = this.getDateModule(3, year, 2, 1);
                                date4 = this.getDateModule(4, year, 2, 2);
                            } else {
                                day0 = dateData - 2;
                                day1 = dateData - 1;
                                day3 = dateData + 1;
                                day4 = dateData + 2;
                                date0 = this.getDateModule(0, year, monthData, day0);
                                date1 = this.getDateModule(1, year, monthData, day1);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, day3);
                                date4 = this.getDateModule(4, year, monthData, day4);
                            }
                        } else if (it === 12) {
                            if (dateData === 1) {
                                date0 = this.getDateModule(0, year, 1, 30);
                                date1 = this.getDateModule(1, year, 1, 31);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, 2);
                                date4 = this.getDateModule(4, year, monthData, 3);
                            } else if (dateData === 2) {
                                day3 = dateData + 1;
                                day4 = dateData + 2;
                                date0 = this.getDateModule(0, year, 1, 31);
                                date1 = this.getDateModule(1, year, monthData, 1);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, day3);
                                date4 = this.getDateModule(4, year, monthData, day4);
                            } else if (dateData === 30) {
                                let nextYear = parseInt(year) + 1;
                                date0 = this.getDateModule(0, year, monthData, 28);
                                date1 = this.getDateModule(1, year, monthData, 29);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, 31);
                                date4 = this.getDateModule(4, nextYear, 1, 1);
                            } else if (dateData === 31) {
                                let nextYear = parseInt(year) + 1;
                                date0 = this.getDateModule(0, year, 12, 29);
                                date1 = this.getDateModule(1, year, 12, 30);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, nextYear, 1, 1);
                                date4 = this.getDateModule(4, nextYear, 1, 2);
                            } else {
                                day0 = dateData - 2;
                                day1 = dateData - 1;
                                day3 = dateData + 1;
                                day4 = dateData + 2;
                                date0 = this.getDateModule(0, year, monthData, day0);
                                date1 = this.getDateModule(1, year, monthData, day1);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, day3);
                                date4 = this.getDateModule(4, year, monthData, day4);
                            }
                        } else if (it === 3) {
                            if (dateData === 1) {
                                if (flag) {
                                    date0 = this.getDateModule(0, year, 2, 28);
                                    date1 = this.getDateModule(1, year, 2, 29);
                                    date2 = this.getDateModule(2, year, monthData, dateData);
                                    date3 = this.getDateModule(3, year, monthData, 2);
                                    date4 = this.getDateModule(4, year, monthData, 3);
                                } else {
                                    date0 = this.getDateModule(0, year, 2, 27);
                                    date1 = this.getDateModule(1, year, 2, 28);
                                    date2 = this.getDateModule(2, year, monthData, dateData);
                                    date3 = this.getDateModule(3, year, monthData, 2);
                                    date4 = this.getDateModule(4, year, monthData, 3);
                                }
                            } else if (dateData === 2) {
                                if (flag) {
                                    date0 = this.getDateModule(0, year, 2, 29);
                                    date1 = this.getDateModule(1, year, monthData, 1);
                                    date2 = this.getDateModule(2, year, monthData, dateData);
                                    date3 = this.getDateModule(3, year, monthData, 3);
                                    date4 = this.getDateModule(4, year, monthData, 4);
                                } else {
                                    date0 = this.getDateModule(0, year, 2, 28);
                                    date1 = this.getDateModule(1, year, monthData, 1);
                                    date2 = this.getDateModule(2, year, monthData, dateData);
                                    date3 = this.getDateModule(3, year, monthData, 3);
                                    date4 = this.getDateModule(4, year, monthData, 4);
                                }
                            } else if (dateData === 30) {
                                date0 = this.getDateModule(0, year, monthData, 28);
                                date1 = this.getDateModule(1, year, monthData, 29);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, 31);
                                date4 = this.getDateModule(4, year, 4, 1);
                            } else if (dateData === 31) {
                                date0 = this.getDateModule(0, year, monthData, 29);
                                date1 = this.getDateModule(1, year, monthData, 30);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, 4, 1);
                                date4 = this.getDateModule(4, year, 4, 2);
                            } else {
                                day0 = dateData - 2;
                                day1 = dateData - 1;
                                day3 = dateData + 1;
                                day4 = dateData + 2;
                                date0 = this.getDateModule(0, year, monthData, day0);
                                date1 = this.getDateModule(1, year, monthData, day1);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, day3);
                                date4 = this.getDateModule(4, year, monthData, day4);
                            }
                        } else {
                            if (dateData === 1) {
                                preMonth = monthData - 1;
                                day3 = dateData + 1;
                                day4 = dateData + 2;
                                date0 = this.getDateModule(0, year, preMonth, 30);
                                date1 = this.getDateModule(1, year, preMonth, 31);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, day3);
                                date4 = this.getDateModule(4, year, monthData, day4);
                            } else if (dateData === 2) {
                                preMonth = monthData - 1;
                                day1 = dateData - 1;
                                day3 = dateData + 1;
                                day4 = dateData + 2;
                                date0 = this.getDateModule(0, year, preMonth, 31);
                                date1 = this.getDateModule(1, year, monthData, day1);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, day3);
                                date4 = this.getDateModule(4, year, monthData, day4);
                            } else if (dateData === 30) {
                                nextMonth = monthData + 1;
                                date0 = this.getDateModule(0, year, monthData, 28);
                                date1 = this.getDateModule(1, year, monthData, 29);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, 31);
                                date4 = this.getDateModule(4, year, nextMonth, 1);
                            } else if (dateData === 31) {
                                nextMonth = monthData + 1;
                                date0 = this.getDateModule(0, year, monthData, 29);
                                date1 = this.getDateModule(1, year, monthData, 30);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, nextMonth, 1);
                                date4 = this.getDateModule(4, year, nextMonth, 2);
                            } else {
                                day0 = dateData - 2;
                                day1 = dateData - 1;
                                day3 = dateData + 1;
                                day4 = dateData + 2;
                                date0 = this.getDateModule(0, year, monthData, day0);
                                date1 = this.getDateModule(1, year, monthData, day1);
                                date2 = this.getDateModule(2, year, monthData, dateData);
                                date3 = this.getDateModule(3, year, monthData, day3);
                                date4 = this.getDateModule(4, year, monthData, day4);
                            }
                        }
                    }
                });
            } else {
                month2.map((it) => {
                    if (it === monthData) {
                        if (dateData === 1) {
                            preMonth = monthData - 1;
                            day3 = dateData + 1;
                            day4 = dateData + 2;
                            date0 = this.getDateModule(0, year, preMonth, 30);
                            date1 = this.getDateModule(1, year, preMonth, 31);
                            date2 = this.getDateModule(2, year, monthData, dateData);
                            date3 = this.getDateModule(3, year, monthData, day3);
                            date4 = this.getDateModule(4, year, monthData, day4);
                        } else if (dateData === 2) {
                            preMonth = monthData - 1;
                            date0 = this.getDateModule(0, year, preMonth, 31);
                            date1 = this.getDateModule(1, year, monthData, 1);
                            date2 = this.getDateModule(2, year, monthData, dateData);
                            date3 = this.getDateModule(3, year, monthData, 3);
                            date4 = this.getDateModule(4, year, monthData, 4);
                        } else if (dateData === 29) {
                            nextMonth = monthData + 1;
                            date0 = this.getDateModule(0, year, monthData, 27);
                            date1 = this.getDateModule(1, year, monthData, 28);
                            date2 = this.getDateModule(2, year, monthData, dateData);
                            date3 = this.getDateModule(3, year, monthData, 30);
                            date4 = this.getDateModule(4, year, nextMonth, 1);
                        } else if (dateData === 30) {
                            nextMonth = monthData + 1;
                            day0 = dateData - 2;
                            day1 = dateData - 1;
                            date0 = this.getDateModule(0, year, monthData, day0);
                            date1 = this.getDateModule(1, year, monthData, day1);
                            date2 = this.getDateModule(2, year, monthData, dateData);
                            date3 = this.getDateModule(3, year, nextMonth, 1);
                            date4 = this.getDateModule(4, year, nextMonth, 2);
                        } else {
                            day0 = dateData - 2;
                            day1 = dateData - 1;
                            day3 = dateData + 1;
                            day4 = dateData + 2;
                            date0 = this.getDateModule(0, year, monthData, day0);
                            date1 = this.getDateModule(1, year, monthData, day1);
                            date2 = this.getDateModule(2, year, monthData, dateData);
                            date3 = this.getDateModule(3, year, monthData, day3);
                            date4 = this.getDateModule(4, year, monthData, day4);
                        }
                    }
                })
            }
        }
        dateArray = [];
        dateArray.push(date0);
        dateArray.push(date1);
        dateArray.push(date2);
        dateArray.push(date3);
        dateArray.push(date4);
        if (openMenu === false) {
            this.setState({
                titleData: dateArray,
                dateTitleIndex: 2
            });
        } else if (openMenu === true) {
            this.setState({
                expanded: !this.state.expanded,
                expand: !this.state.expand,
                titleData: dateArray,
                dateTitleIndex: 2
            });
        }
        let m = month.toString().replace('月', '');
        let today = year + '-' + parseInt(m) + '-' + parseInt(date);
        this._refreshVideo(today, true);
    }

    _click() {
        window.requestAnimationFrame(() => {
            this.setState({
                expanded: !this.state.expanded,
                expand: !this.state.expand
            });
        });
    }

    _selectDateCallback(date) {
        let year = date.toString().substring(0, 4);
        let day = date.toString().substring(8, 10);
        let month = date.toString().substring(5, 8).replace('-', '月');
        this.refreshDate(year, month, day, true);
    }

    _dateCallBack(date) {
        this.setState({
            dateTitleIndex: 2
        });
        this._refreshVideo(date, true);
    }
}

const styles = StyleSheet.create({
    allInfor: {
        paddingBottom: ScreenUtil.scaleSize(360)
    },
    scrollStyle: {
        width: width - ScreenUtil.scaleSize(100),
        height: ScreenUtil.scaleSize(100),
        borderBottomWidth: 0
    },
    container: {
        flex: 1,
        backgroundColor: Colors.background_white
    },
    textStyle: {
        resizeMode: 'cover',
        position: 'absolute',
        right: 0,
        top: ScreenUtil.scaleSize(0),
        zIndex: 10,
        backgroundColor: Colors.background_white,
        width: ScreenUtil.scaleSize(100),
        height: ScreenUtil.scaleSize(100),
        borderLeftWidth: 1,
        borderColor: Colors.line_grey,
        alignItems: 'center',
        justifyContent: 'center'
    },
    imgStyle: {
        width: ScreenUtil.scaleSize(30),
        height: ScreenUtil.scaleSize(30)
    },
    onLiveBackView: {
        backgroundColor: Colors.background_white,
    },
    onLivingView: {
        backgroundColor: Colors.background_white,
        marginBottom: ScreenUtil.scaleSize(20)
    },
    onLiveStyle: {
        backgroundColor: Colors.background_white,
        alignItems: 'center',
        paddingTop: ScreenUtil.scaleSize(30),
        paddingBottom: ScreenUtil.scaleSize(30),
        marginTop: ScreenUtil.scaleSize(20)
    },
    onLiveTextStyle: {
        fontSize: ScreenUtil.setSpText(30),
        color: '#333',
        fontWeight: 'bold',
    },
    centerViewStyle: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        height: ScreenUtil.scaleSize(80),
        backgroundColor: Colors.background_white
    },
    preparationTextStyle: {
        fontSize: Fonts.standard_title_font(),
        color: Colors.text_black,
        marginLeft: ScreenUtil.scaleSize(10)
    },
    moreTextStyle: {
        fontSize: Fonts.standard_normal_font(),
        color: Colors.text_dark_grey
    },
    dateBgStyle: {
        width: ScreenUtil.scaleSize(176),
        height: ScreenUtil.scaleSize(88),
        justifyContent: 'center',
        alignItems: 'center'
    },
    dateStyle: {
        width: ScreenUtil.scaleSize(101),
        height: ScreenUtil.scaleSize(40),
        fontSize: Fonts.secondary_font(),
        color: Colors.text_dark_grey,
        textAlign: 'center'
    },
    dateBg: {
        width: width,
        height: ScreenUtil.scaleSize(730)
    },
    bg: {
        ...Platform.select({
            ios: {
                flex: 1,
                position: 'absolute',
                top: ScreenUtil.scaleSize(216) - 22,
                flexDirection: 'column'
            },
            android: {
                flex: 1,
                position: 'absolute',
                top: ScreenUtil.scaleSize(216),
                flexDirection: 'column'
            }
        })
    },
    popBg: {
        width: width,
        height: height - ScreenUtil.scaleSize(216) - ScreenUtil.scaleSize(730),
        backgroundColor: 'rgba(0, 0, 0, 0.5)'
    },
    baseBg: {
        flexDirection: 'column'
    },
    basicBg: {
        flexDirection: 'row'
    },
    dateImgBg: {
        width: ScreenUtil.scaleSize(88),
        height: ScreenUtil.scaleSize(88),
        justifyContent: 'center',
        alignItems: 'center',
        borderColor: Colors.line_grey,
        borderWidth: 1
    },
    dateImg: {
        width: ScreenUtil.scaleSize(24),
        height: ScreenUtil.scaleSize(16),
        maxWidth: ScreenUtil.scaleSize(24),
        maxHeight: ScreenUtil.scaleSize(16)
    },
    dateTitleBg: {
        flexDirection: 'row',
        width: width,
        height: ScreenUtil.scaleSize(88),
        backgroundColor: 'white'
    },
    videoTitleBg: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center'
    }
});
