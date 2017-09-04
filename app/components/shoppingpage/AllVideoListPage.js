/**
 * Created by Administrator on 2017/5/26.
 */

//视频全列表页面
import React from 'react'
import {
    StyleSheet,
    View,
    Text,
    Image,
    TouchableOpacity,
    FlatList,
    Platform,
} from 'react-native'
import PressTextColor from 'FOUNDATION/pressTextColor';

import Colors from '../../config/colors';
import SelectionItem from '../../../foundation/shoppingpage/SelectionItem';
import * as ScreenUtil from '../../../foundation/utils/ScreenUtil';
import NavigationBar from '../../../foundation/common/NavigationBar';
import GetVideoPageData from '../../../foundation/net/video/GetVideoPageData';
import Toast, {DURATION} from 'react-native-easy-toast';
import GetMoreListData from '../../../foundation/net/home/GetMoreListData';
import NetErro from '../error/NetErro';
import ToTopView from '../../../foundation/common/ToTopView';
import {DataAnalyticsModule} from '../../config/AndroidModules';
import * as RouteManager from '../../config/PlatformRouteManager';
import {Actions} from 'react-native-router-flux';
import * as routeConfig from '../../config/routeConfig';
let codeValue = '';
let pageVersionName = '';

export default class AllVideoListPage extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            selectTab: -1,     //其他tab的选中
            selectTabPx: -1,  //排序的选中
            itemViewData: [{key: '6284218152104493056', title: "精品楠得"}, {key: '6284218225207017472', title: "家装第一战"},
                {key: '6284218308497506304', title: "丹丹李强惠生活"}, {key: '6284218408573599744', title: "时尚派对"},
                {key: '6288968517370773504', title: "最新"}, {key: '6283569139344736256', title: "夜食堂"},
                {key: '6283847057337745408', title: "实验室"}, {key: '6283568941813989376', title: "尝试了没"}],
            showArray: [],
            childViewIndex: 0,
            open: false,
            data: undefined,
            isRefreshing: false,
            screenText: -1,
            id: 0,
            pageNum: 1,
            haveMore: true,
            showToTop: false,
        };

    }

    componentDidMount() {
        let video = this.props.video;
        let lgroup = 99;
        let contentType = 5;
        if (video && video.lgroup) {
            lgroup = video.lgroup;
            for (let i = 0; i < this.state.itemViewData.length; i++) {
                if (lgroup === this.state.itemViewData[i].key) {
                    this.state.screenText = i
                }
            }
        }
        let select = this.props.select;
        if (select === 1001) {
            this.setState({
                selectTab: 0
            })
        } else {
            this.setState({
                selectTab: 3
            })
        }

        if (video && video.contentType) {
            contentType = video.contentType;
        }
        this._getAllVideo(lgroup, contentType);
        this.setState({showArray: this.state.itemViewData[0]});
    }

    componentWillUnmount() {
        //页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }

    _getAllVideo(lg, contentType) {
        this.setState({isRefreshing: true});
        if (this.GetVideoData) {
            this.GetVideoData.setCancled(true);
        }
        this.GetVideoData = new GetVideoPageData({id: 'AP1706A049', lgroup: lg, contentType: contentType}, 'GET');
        this.GetVideoData.showLoadingView().start(
            (response) => {
                if (response.code === 200) {
                    if (response.data && response.data.packageList && response.data.packageList[0] &&
                        response.data.packageList[0].componentList && response.data.packageList[0].componentList[0].componentList) {
                        this.setState({
                            data: response.data.packageList[0].componentList[0].componentList,
                            isRefreshing: false,
                            id: response.data.packageList[0].componentList[0].id,
                        });
                    }
                    //视频页面埋点
                    codeValue = response.data.codeValue;
                    pageVersionName = response.data.pageVersionName;
                    DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                } else {
                    this.setState({
                        isRefreshing: false,
                    });
                    this.refs.toast.show(response.code, DURATION.LENGTH_LONG);
                }
            }, (erro) => {
                this.setState({
                    isRefreshing: false,
                });
                // console.log(erro);
            });
    }

    tabClick(index) {

        if (index === 0 || index === 3) {
            this.setState({selectTab: index});
            if (index === 0) {
                this.setState({selectTabPx: -1});
            }
        }
        else {
            this.setState({selectTabPx: index});
        }

        if (this.state.open) {
            this.setState({
                open: false
            })
        }

        if (index === 0) {
            this.state.screenText = 99;
            this._getMore(0);
        }
        else if (index === 3) {
            /*if (this.state.open && this.state.screenText > -1 && this.state.screenText < 99) {
             this._getMore(0);
             }*/
            this.setState({
                open: !this.state.open,
                //  screenText:-1,
            });
        }
        else {
            this._getMore(index);
        }

    }

    _getMoreVideo() {
        if (this.GetMoreListDataRequest) {
            this.GetMoreListDataRequest.setCancled(true);
        }
        this.GetMoreListDataRequest = new GetMoreListData({
            id: this.state.id, pageNum: this.state.pageNum + 1, cateConditions: this.state.screenText,
        }, 'GET');
        this.GetMoreListDataRequest.start(
            (response) => {

                if (response.code === 200) {
                    if (response.data) {
                        if (response.data.list && response.data.list.length > 0) {
                            this.setState({
                                data: this.state.data.concat(response.data.list),
                                pageNum: this.state.pageNum + 1,
                            });
                        } else {
                            this.setState({
                                haveMore: false
                            })
                        }
                    }
                } else {
                    this.refs.toast.show(response.code, DURATION.LENGTH_LONG);

                }
            }, (erro) => {
                //this.refs.toast.show(response.code, DURATION.LENGTH_LONG);
                // console.log(erro);
            });
    }

    _getMore(index) {

        if (this.GetMoreListDataRequest) {
            this.GetMoreListDataRequest.setCancled(true);
        }
        this.GetMoreListDataRequest = new GetMoreListData({
            id: this.state.id, pageNum: 1, cateConditions: this.state.screenText,
            salesSort: index,
        }, 'GET');
        this.GetMoreListDataRequest.showLoadingView().start(
            (response) => {

                if (response.code === 200) {
                    if (response.data) {
                        this.setState({
                            data: response.data.list,
                            haveMore: true,
                            pageNum: 1
                        });
                    }
                } else {
                    this.refs.toast.show(response.code, DURATION.LENGTH_LONG);

                }
            }, (erro) => {
                //this.refs.toast.show(response.code, DURATION.LENGTH_LONG);
                // console.log(erro);
            });
    }

    _PressTab(index) {
        this.state.screenText = index;
        this.setState({
            open: false,
            selectTab: -1
        });
        this._getMore(0);

    }

    clickChildContent(item, index) {
        this.setState({open: !this.state.open});
    }

    _foot = () => {
        return (
            <PressTextColor onPress={
                () => {
                    this._getMoreVideo();
                }
            }>
                {this.state.data && this.state.data.length > 0 ? <View style={{alignItems: 'center',}}>
                    {this.state.haveMore ?
                        <Text
                            allowFontScaling={false}
                            style={{
                                color: '#999',
                                textAlign: 'center',
                                fontSize: ScreenUtil.setSpText(26),
                                margin: ScreenUtil.scaleSize(40),
                            }}>点击加载更多</Text>
                        :
                        <Image
                            style={{
                                margin: ScreenUtil.scaleSize(30),
                                width: ScreenUtil.scaleSize(180),
                                height: ScreenUtil.scaleSize(106)
                            }}
                            source={require('../../../foundation/Img/home/IMG_nomore.png')}/>
                    }
                </View> : null}
            </PressTextColor>
        );
    };

    _sepComponent() {
        return (
            <View style={{
                backgroundColor: Colors.line_grey,
                height: ScreenUtil.scaleSize(0.5),
            }}
            >
                <View style={{
                    width: ScreenUtil.scaleSize(30),
                    backgroundColor: '#fff',
                    height: ScreenUtil.scaleSize(0.5)
                }}></View>
            </View>
        )
    }

    onScroll = (e) => {
        let y = e.nativeEvent.contentOffset.y;

        if (y > ScreenUtil.scaleSize(1334)) {
            this.setState({
                showToTop: true
            })
        } else {
            this.setState({
                showToTop: false
            })
        }
    };

    /**
     * 渲染导航栏
     * @private
     */
    _renderNav() {
        return (
            <NavigationBar
                title={this.video ? this.video.title : '视频全列表'}
                titleStyle={{
                    backgroundColor: 'transparent',
                    color: Colors.text_white,
                    fontSize: ScreenUtil.scaleSize(34),
                }}
                navigationStyle={{
                    ...Platform.select({ios: {marginTop: ScreenUtil.scaleSize(-44)}}),
                    height: ScreenUtil.scaleSize(128)
                }}
                leftButton={require('../../../foundation/Img/shoppingPage/Icon_back_white_@3x.png')}
                showRight={false}
                barStyle={'light-content'}
                navigationBarBackgroundImage={require('../../../foundation/Img/groupbuy/Icon_brand_bg_@2x.png')}
            />
        );
    }

    selectionItemClick(video) {
        DataAnalyticsModule.trackEvent3(video.codeValue, "", {'pID': codeValue, 'vID': pageVersionName});
        switch (video.type) {
            case 1:   //tv
                RouteManager.routeJump({
                    page: routeConfig.Video,
                    param: {id: video.id},
                    fromRNPage: routeConfig.AllVideoListPage,
                })
                break;
            case 2:   //网络
                Actions.VipPromotion({value: video.url});
                break;
            case 3:   //短视频
                RouteManager.routeJump({
                    page: routeConfig.Video,
                    param: {id: video.id},
                    fromRNPage: routeConfig.AllVideoListPage,
                });
                break;
            default:
                break;
        }
    }

    render() {
        let data = this.state.data;

        return (
            <View style={styles.allVideoView}>
                {
                    this._renderNav()
                }
                <View style={styles.itemsTab}>
                    <TouchableOpacity activeOpacity={1} style={styles.itemTab} onPress={() => this.tabClick(0)}>
                        <Text allowFontScaling={false}
                              style={this.state.selectTab === 0 ? styles.selectedTab : styles.unSelectedTab}>逛了玩玩</Text>
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={1} style={styles.itemTab} onPress={() => this.tabClick(1)}>
                        <Text allowFontScaling={false}
                              style={this.state.selectTabPx === 1 ? styles.selectedTab : styles.unSelectedTab}>播放次数排序</Text>
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={1} style={styles.itemTab} onPress={() => this.tabClick(2)}>
                        <Text allowFontScaling={false}
                              style={this.state.selectTabPx === 2 ? styles.selectedTab : styles.unSelectedTab}>上架排序</Text>
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={1} style={styles.selectionTab} onPress={() => this.tabClick(3)}>
                        <Image style={{
                            height: ScreenUtil.scaleSize(25),
                            width: ScreenUtil.scaleSize(25),
                            resizeMode: 'stretch',
                            marginRight: ScreenUtil.scaleSize(7.5)
                        }}
                               source={this.state.selectTab === 3 ?
                                   require('../../../foundation/Img/shoppingPage/ico_shaixuan_active.png')
                                   :
                                   require('../../../foundation/Img/shoppingPage/ico_shaixuan_normal.png')}/>
                        <Text allowFontScaling={false} style={this.state.selectTab === 3 ? {
                            fontSize: ScreenUtil.setSpText(26),
                            color: '#E5290D',
                        } : {
                            fontSize: ScreenUtil.setSpText(26),
                            color: Colors.text_dark_grey,
                        }}>筛选</Text>

                    </TouchableOpacity>
                </View>
                <View style={{
                    backgroundColor: Colors.line_grey,
                    height: ScreenUtil.scaleSize(0.5)
                }}
                />
                <FlatList data={data}
                          ref="_flatList"
                          extraData={this.state}
                          renderItem={({item, index}) => {
                              return (
                                  <View style={{backgroundColor: Colors.line_grey, flex: 1}}>
                                      <SelectionItem selectionItem={item} selectionItemClick={(video) => {
                                          this.selectionItemClick(video);
                                      }}/>
                                  </View>
                              )
                          }}
                          ListFooterComponent={this._foot}
                          ItemSeparatorComponent={this._sepComponent}
                          onScroll={this.onScroll}
                />

                {
                    data && data.length === 0 ?
                        <NetErro title={'已经没有更多视频了'} style={{
                            backgroundColor: '#DDDDDD',
                            position: 'absolute',
                            top: ScreenUtil.scaleSize(400)
                        }}/> : null
                }

                {
                    this.state.open === true ?
                        <View style={{
                            backgroundColor: '#fff', width: ScreenUtil.screenW,
                            paddingTop: ScreenUtil.scaleSize(30), position: 'absolute',
                            ...Platform.select({
                                ios: {
                                    top: ScreenUtil.scaleSize(172)
                                },
                                android: {
                                    top: ScreenUtil.scaleSize(216)
                                }
                            }), borderTopWidth: 1, borderTopColor: '#DDDDDD',
                            flexDirection: 'row', flexWrap: 'wrap'
                        }}>
                            {
                                this.state.itemViewData.map((item, index) => {
                                    return (
                                        <TouchableOpacity
                                            activeOpacity={1}
                                            onPress={
                                                () => {
                                                    this._PressTab(index)
                                                }
                                            }
                                        >
                                            <View style={{
                                                marginLeft: ScreenUtil.scaleSize(30),
                                                marginBottom: ScreenUtil.scaleSize(30),
                                            }}>
                                                <Text allowFontScaling={false}
                                                      style={{
                                                          backgroundColor: this.state.screenText ===
                                                          {index}.index ? '#FFEBE8' : '#EDEDED',
                                                          paddingHorizontal: ScreenUtil.scaleSize(20),
                                                          paddingVertical: ScreenUtil.scaleSize(16),
                                                          borderRadius: ScreenUtil.scaleSize(4)
                                                      }}>{item.title}</Text>
                                                {this.state.screenText ===
                                                {index}.index ? <Image style={{
                                                    position: 'absolute',
                                                    right: 0,
                                                    bottom: 0,
                                                    height: ScreenUtil.scaleSize(30),
                                                    width: ScreenUtil.scaleSize(30),
                                                    borderBottomRightRadius: ScreenUtil.scaleSize(4)
                                                }}
                                                                       source={require('../../../foundation/Img/shoppingPage/selected_.png')}/>
                                                    : null}
                                            </View></TouchableOpacity>)
                                })
                            }
                        </View> : null
                }
                {this.state.showToTop ? <TouchableOpacity onPress={
                    () => {
                        this.refs._flatList.scrollToOffset({animated: true, offset: 0.1})
                    }
                }
                                                          style={{
                                                              position: 'absolute',
                                                              right: ScreenUtil.scaleSize(30),
                                                              bottom: ScreenUtil.scaleSize(54)
                                                          }}
                >
                    <ToTopView />
                </TouchableOpacity> : null}
                < Toast
                    ref="toast"/>

            </View>
        )
    }
}

const styles = StyleSheet.create({
    allVideoView: {
        backgroundColor: Colors.line_grey,
        flex: 1
    },
    itemsTab: {
        flexDirection: 'row',
        height: ScreenUtil.scaleSize(88),
        justifyContent: 'space-around',
        alignItems: 'center',
        paddingHorizontal: ScreenUtil.scaleSize(20),
        backgroundColor: Colors.background_white,
    },
    itemTab: {
        paddingRight: ScreenUtil.scaleSize(20),
        alignItems: 'center',
        justifyContent: 'center',
        borderRightColor: Colors.line_grey,
        borderRightWidth: 1,
        marginTop: ScreenUtil.scaleSize(10),
        marginBottom: ScreenUtil.scaleSize(10),
    },
    selectionTab: {
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',

    },
    selectionImg: {
        width: ScreenUtil.scaleSize(20),
        height: ScreenUtil.scaleSize(20),
        marginLeft: ScreenUtil.scaleSize(4),
    },
    selectedTab: {
        fontSize: ScreenUtil.setSpText(26),
        color: '#E5290D',
        paddingHorizontal: ScreenUtil.scaleSize(20),

    },
    unSelectedTab: {
        fontSize: ScreenUtil.setSpText(26),
        color: Colors.text_dark_grey,
        paddingHorizontal: ScreenUtil.scaleSize(20),
    },
});
