/**
 * Created by MASTERMIAO on 2017/5/22.
 * TV团购页面
 */
'use strict';
import {
    View,
    Text,
    Image,
    TouchableOpacity,
    StyleSheet,
    Platform,
    FlatList,
    ActivityIndicator,
    ScrollView
} from 'react-native'
import {
    React,
    ScreenUtils,
    Colors,
    Fonts,
    NavigationBar,
} from '../../config/UtilComponent';

//TV请求接口
import TVGroupBuyRequest from '../../../foundation/net/group/TVGroupBuyRequest.js';
//TV加载更多接口
import TVGroupBuyMore from '../../../foundation/net/group/TVGroupBuyMore.js';
//TVItem组件
import TVGroupListItem from '../../../foundation/groupby/TVGroupListItem';

//埋点相关
import {DataAnalyticsModule} from '../../config/AndroidModules';
let codeValue = '';
let pageVersionName = '';
//分页
let page = 0;
let pageSize = 4;

export default class TVGroupBuy extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            loading: false,
            vedioArr: [],
            preVedioArr: [],
            isRefreshing:false,
            showBackTop: false,
        };
    }

    componentDidMount() {
        page = 0;//初始化当前页
        pageSize = 4;//一页包含的元素个数
        this._getTVGroupBuy();
    }

    render() {
        let _scrollView: ScrollView;
        return (
            <View style={styles.containers}>
                {this._renderTVGroupBuyNav()}
                <ScrollView
                    ref={(scrollView) => { _scrollView = scrollView;}}
                    scrollEventThrottle={30}
                    onScroll={(event)=>{
                        this._onScroll(event);
                    }}
                >
                    <FlatList
                        key={Math .random()}
                        onRefresh={() => {this.refreshAction}}
                        refreshing={this.state.isRefreshing}
                        data={this.state.vedioArr}
                        renderItem={({item,index}) => this.renderTVItem(item,index)}
                    />
                    {this.state.preVedioArr.length ?
                        <FlatList
                            ListHeaderComponent={() => this._renderHeader()}
                            style={styles.listStyle}
                            data={this.state.preVedioArr}
                            renderItem={this.renderItem.bind(this)}
                            ListFooterComponent={() => this._renderFooter()}
                        /> : null}
                </ScrollView>
                {
                    this.state.showBackTop ?
                        <TouchableOpacity ref='backTopView'
                                          style={styles.backTopView}
                                          activeOpacity={1}
                                          onPress={() => {_scrollView && _scrollView.scrollTo(0)}}>
                            <Image style={styles.backTopImg}
                                   source={require('../../../foundation/Img/channel/classification_channel_icon_back_top.png')}>
                            </Image>
                        </TouchableOpacity>
                        :
                        null
                }
            </View>
        )
    }
    /**
     * 列表滚动的回调
     * @private
     *
     */
    _onScroll(e) {
        let y = e.nativeEvent.contentOffset.y;
        if (y > ScreenUtils.screenH) {
            this.setState({
                showBackTop: true,
            })
        } else {
            this.setState({
                showBackTop: false,
            })
        }
    }

    /**
     * 渲染TV 直播Item
     * @private
     *
     */
    renderTVItem(item,index) {
        return (
            <TVGroupListItem
                key={index}
                data={item}
                fromPage={this.props.fromPage ? this.props.fromPage : ''}
                codeValue={codeValue}
                pageVersionName={pageVersionName}
            />
        )
    }

    /**
     * 刷新
     * @private
     */
    refreshAction() {
        this.setState({
            isRefreshing: true
        }, () => {
            this._getTVGroupBuy();
        });
    }
    /**
     * 渲染TV 团购nav
     * @private
     */
    _renderTVGroupBuyNav() {
        return (
            <NavigationBar
                key={'key'}
                title={'TV团购'}
                navigationBarBackgroundImage={require('../../../foundation/Img/groupbuy/Icon_brand_bg_@2x.png')}
                navigationStyle={{height: ScreenUtils.scaleSize(128), ...Platform.select({ios: {marginTop: -22}})}}
                titleStyle={{
                    color: Colors.text_white,
                    backgroundColor: 'transparent',
                    fontSize: ScreenUtils.scaleSize(36)
                }}
                leftButton={require('../../../foundation/Img/home/store/icon_back_white_.png')}
            />
        );
    }

    /**
     * 渲染TV 预告列表头部
     * @private
     */
    _renderHeader() {
        return (
            <View style={styles.titleView}>
                <Image
                    resizeMode={'cover'}
                        style={styles.titleImgStyles}
                       source={require('../../../foundation/Img/groupbuy/icon_notice_@3x.png')}/>
                <Text allowFontScaling={false} style={styles.titleTextStyle}> 预告</Text>
            </View>
        );
    }

    /**
     * 渲染TV 预告列表尾部
     * @private
     */
    _renderFooter() {
        return (
            <View>
                {
                    !this.state.loading ?
                        <TouchableOpacity activeOpacity={1} onPress={() => {
                            this.setState({
                                loading: true,
                            });
                            if (this.state.preVedioArr.length) {
                                this._getTVGroupBuyMore(this.state.preVedioArr[0].id);
                            }
                        }}>
                            <View style={styles.titleView}>
                                <Text allowFontScaling={false} style={styles.titleTextStyle}>更多预告></Text>
                            </View>
                        </TouchableOpacity>
                        :
                        <ActivityIndicator
                            style={{height: ScreenUtils.scaleSize(42), width: ScreenUtils.screenW}}
                            color="gray"
                            size="large"
                        />
                }
            </View>
        );
    }

    /**
     * 渲染列表
     * @private
     */
    //列表的每一行
    renderItem({item, index}) {
        return (
            <TouchableOpacity key={index} activeOpacity={1} style={[styles.productViewStyle]} onPress={() => {
            }}>
                <View style={styles.productImgStyle}>
                    {item.firstImgUrl ?
                        <Image
                            resizeMode={'cover'}
                            style={{
                                backgroundColor: 'rgba(0, 0, 0, 0)',
                                width: ScreenUtils.scaleSize(240),
                                height: ScreenUtils.scaleSize(160),
                            }}
                            source={{uri: item.firstImgUrl}}/>
                        :
                        <Image style={styles.productImgStyle}/>}
                </View>
                <View style={styles.productInfoStyle}>
                    <Image source={require('../../../foundation/Img/groupbuy/Icon_yellow_bg_@2x.png')}
                           style={styles.naticeBg}/>
                    <Text allowFontScaling={false} style={styles.programNameStyle}>即将播出</Text>
                    <Text allowFontScaling={false}
                        style={styles.programInfoStyle}>{(item.title ? item.title : '') + (item.subTitle ? item.subTitle : '') + (item.author ? item.author : '')}</Text>
                    <Text allowFontScaling={false} style={styles.programTimeStyle}>{item.videoDate ? item.videoDate + '开播' : '没有时间'}</Text>
                </View>
            </TouchableOpacity>
        )
    }

    /**
     * TV数据请求
     * @private
     */
    _getTVGroupBuy() {
        page = 0;
        let self = this;
        if (this.TVGroupBuyRequest) {
            this.TVGroupBuyRequest.setCancled(true);
        }
        this.TVGroupBuyRequest = new TVGroupBuyRequest({id: 'AP1706A003'}, 'GET');
        this.TVGroupBuyRequest.showLoadingView().start(
            (response) => {
                // console.log('TVGroupBuyRequest-----' + response.code);
                if (response.code === 200) {
                    let arr1 = [];
                    let arr2 = [];
                    if (response.data.packageList.length === 2) {
                        for (let i = 0; i < response.data.packageList.length; i++) {
                            if (response.data.packageList[i].packageId === '45') {
                                //直播预告
                                arr1.push.apply(arr1, response.data.packageList[i].componentList[0].componentList);
                            } else if (response.data.packageList[i].packageId === '46') {
                                //正在直播
                                // console.log('this.state.preVedioArr.id-----' + response.data.packageList[1].componentList.length);
                                arr2.push.apply(arr2, response.data.packageList[i].componentList[0].componentList);
                                // console.log('arr2.length-----' + arr2.length);
                            }
                        }
                        codeValue = response.data.codeValue;
                        pageVersionName = response.data.pageVersionName;
                        //页面埋点
                        DataAnalyticsModule.trackPageBegin(codeValue + pageVersionName);
                    }
                    self.setState({
                        preVedioArr: arr2,//正在直播
                        vedioArr: arr1,//直播预告
                        isRefreshing: false
                    });
                } else {
                    // alert(response.message);
                    self.setState({
                        isRefreshing: false
                    });
                }
            }, (erro) => {
                self.setState({
                    isRefreshing: false
                });
            });
    }
    /**
     * 预告加载更多
     * @private
     */
    _getTVGroupBuyMore(id) {
        if (this.TVGroupBuyMore) {
            this.TVGroupBuyMore.setCancled(true);
        }
        //id=6278074731946049536&pageNum=1&pageSize=2
        // console.log('TVGroupBuyMore id-----' + id);
        this.TVGroupBuyMore = new TVGroupBuyMore({id: id, pageNum: page + 1, pageSize: pageSize}, 'GET');
        this.TVGroupBuyMore.showLoadingView().start(
            (response) => {
                this.setState({
                    loading: false,
                });
                // console.log('TVGroupBuyMore-----' + response.code);

                if (response.code === 200 && response.data.list.length > 0) {
                    page++;//请求成功当前显示page+1页
                    let arr = response.data.list;
                    this.setState({
                        preVedioArr: this.state.preVedioArr.concat(arr),
                    })
                }
            }, (erro) => {
                this.setState({
                    loading: false,
                });
                // alert(erro.message);
            });
    }

    componentWillUnmount() {
        //页面埋点
        DataAnalyticsModule.trackPageEnd(codeValue + pageVersionName);
    }

}
const styles = StyleSheet.create({
    containers: {
        flex: 1,
        backgroundColor: Colors.background_grey
    },
    listStyle: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.background_grey
    },
    titleView: {
        marginTop: 0.5,
        backgroundColor: Colors.background_white,
        height: ScreenUtils.scaleSize(80),
        width: ScreenUtils.screenW,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
    },
    titleImgStyles: {
        width: ScreenUtils.scaleSize(40),
        height: ScreenUtils.scaleSize(40),
    },
    titleTextStyle: {
        backgroundColor: 'rgba(0, 0, 0, 0)',
        color: Colors.text_black,
        fontSize: Fonts.page_title_font(),
        // lineHeight: ScreenUtils.scaleSize(44),
        marginLeft: ScreenUtils.scaleSize(20),
    },
    productViewStyle: {
        width: ScreenUtils.screenW,
        backgroundColor: 'white',
        padding: ScreenUtils.scaleSize(30),
        flexDirection: 'row',
        marginTop: 0.5,
    },
    productImgStyle: {
        backgroundColor: 'rgba(0, 0, 0, 0)',
        width: ScreenUtils.scaleSize(240),
        height: ScreenUtils.scaleSize(160)
    },
    productInfoStyle: {
        marginLeft: ScreenUtils.scaleSize(30),
        flexWrap: 'wrap',
        justifyContent: 'space-between',
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(300),
    },
    programNameStyle: {
        fontSize: Fonts.tag_font() - 2,
        color: Colors.text_white,
        position: 'absolute',
        textAlign: 'center',
        padding: ScreenUtils.scaleSize(4),
        marginLeft: ScreenUtils.scaleSize(8),
        backgroundColor: 'transparent'
    },
    programInfoStyle: {
        fontSize: Fonts.standard_normal_font(),
        color: Colors.text_black,
    },
    programTimeStyle: {
        fontSize: Fonts.tag_font(),
        color: Colors.text_light_grey,
    },
    naticeBg: {
        backgroundColor: 'rgba(0, 0, 0, 0)',
        width: ScreenUtils.scaleSize(100),
        height: ScreenUtils.scaleSize(30)
    },
    navBgStyle: {
        width: ScreenUtils.screenW,
        position: 'absolute',
        top: 0,
        zIndex: -1,
        height: ScreenUtils.scaleSize(120)
    },
    titleBox: {
        position: 'absolute',
        top: 0,
        left: 0,
        zIndex: -1,
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(120),
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    titleText: {
        backgroundColor: 'transparent',
        color: Colors.text_white,
        fontSize: Fonts.page_title_font(),
        paddingTop: ScreenUtils.scaleSize(20),
        paddingBottom: ScreenUtils.scaleSize(20)
    },
    backTopView: {
        position: 'absolute',
        top: ScreenUtils.screenH - ScreenUtils.scaleSize(240),
        left: ScreenUtils.screenW - ScreenUtils.scaleSize(120),
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
    },
    backTopImg: {
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
    },
});
/*  {
 "id":"6278074731946049536",
 "title":"测试视频",
 "subTitle":"商品名称",
 "codeId":"405",
 "videoPlayBackUrl":"dddd",
 "contentCode":null,
 "firstImgUrl":"http://10.22.218.170:8080/cms/cms/151/05/2017/201705151041052.jpg",
 "secondImgUrl":null,
 "thirdImgUrl":null,
 "shortNumber":0,
 "componentId":null,
 "isComponents":0,
 "watchNumber":"1023213",
 "codeValue":"AP1706A015B18001E05001",
 "author":"徐飞",
 "videoDate":"06月11日 08:10-19:00",
 "gifts":null,
 "originalPrice":null,
 "salePrice":null,
 "integral":null,
 "salesVolume":null,
 "componentList":null,
 "description":null,
 "labelName":"精华"
 },*/
