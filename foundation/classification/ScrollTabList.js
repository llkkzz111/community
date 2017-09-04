/**
 * Created by Xiang on 2017/6/12.
 */
import React from 'react'
import {
    StyleSheet,
    View,
    Text,
    Image,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    FlatList,
    Platform
} from 'react-native';
import {Actions} from "react-native-router-flux";
import GroupTag from'./GroupTag'
import TabTitle from'./TabTitle'
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import * as ScreenUtils from '../utils/ScreenUtil';
const {width} = Dimensions.get('window');
import ClassificationChannelListRequest from '../../foundation/net/classification/ClassificationChannelListRequest';
import  ScrollableTabView, {ScrollableTabBar} from 'react-native-scrollable-tab-view'
import Toast, {DURATION} from 'react-native-easy-toast';
import * as ScreenUtil from "../../foundation/utils/ScreenUtil";

import PressTextColor from 'FOUNDATION/pressTextColor';

let requestListBody = {
    id: '6279264955699036160',//商品componentList中的id
    pageNum: '1',
    pageSize: '20',
    cateLevelConditions: '1',//分类级别，第一层分类传1，第二层分类传2
    cateConditions: '123',//分类id，取destinationUrl的值
};
let defaultSecondClassData;
let defaultProductData;
let listRequest;
var key = 0;
//商品列表
export default class ScrollTabList extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            firstClassData: [],//一级分类
            secondClassData: [],//二级分类
            productData: [],//商品列表
            productListId: '',//商品列表id
            refresh: true,
        };
        this.getBottomListData = this.getBottomListData.bind(this);
        listRequest = new ClassificationChannelListRequest(requestListBody, 'GET');
    }

    selectTabTitlePosition(index) {
        this.refs.TabTitle && this.refs.TabTitle.selectPosition(0);
        //第十个展开更多，默认选中第一个
        if (index === 9) {
            this.refs.GroupTag && this.refs.GroupTag.setCollapse(false);
            this.refs.GroupTag && this.refs.GroupTag.selectPosition(0);
            this.getBottomListData(this.state.productListId, '2', defaultSecondClassData[0].lgroup);
        } else {
            this.refs.GroupTag && this.refs.GroupTag.setCollapse(true);
            this.refs.GroupTag && this.refs.GroupTag.selectPosition(index);
            this.getBottomListData(this.state.productListId, '2', defaultSecondClassData[index].lgroup);
        }

        this.setState({
            secondClassData: defaultSecondClassData,
            productData: defaultProductData,
            refresh: !this.state.refresh,
        });
    }

    componentDidMount() {
        //底部商品列表（第一屏静态数据）
        this.setState({
            firstClassData: this.props.firstClassData,
            secondClassData: this.props.secondClassData,
            productData: this.props.productData,
            productListId: this.props.productListId,
        });
        defaultSecondClassData = this.props.secondClassData;
        defaultProductData = this.props.productData;
    }

    componentWillUnmount() {
        defaultSecondClassData = null;
        defaultProductData = null;
    }
    //商品列表数据请求
    getBottomListData(id, cateLevelConditions, cateConditions) {
        requestListBody.id = id;
        requestListBody.cateLevelConditions = cateLevelConditions + '';
        requestListBody.cateConditions = cateConditions + '';
        listRequest.showLoadingView().start(
            (jsonResponse) => {
                if (jsonResponse.data) {
                    if (cateLevelConditions === '2') {
                        this.setState({
                            productData: jsonResponse.data.list ? jsonResponse.data.list : [],
                            refresh: !this.state.refresh,
                        });
                    } else if (cateLevelConditions === '1') {
                        this.setState({
                            secondClassData: jsonResponse.data.cateList ? jsonResponse.data.cateList : [],
                            productData: jsonResponse.data.list ? jsonResponse.data.list : [],
                            refresh: !this.state.refresh,
                        });
                    }
                }
            },
            (e) => {
                this.setState({
                    secondClassData: [],
                    productData: [],
                    refresh: !this.state.refresh,
                });
            }
        );
    }

    render() {

        return (
            <View style={{flex:1}}>
                <TabTitle
                    ref="TabTitle"
                    data={this.state.firstClassData}
                    onFirstClassSelect={(index, lgroup) => {
                        // 二级分类置顶
                        this.props.scrollToPageTop();
                        if (index === 0) {
                            this.setState({
                                secondClassData: defaultSecondClassData,
                                productData: defaultProductData,
                                refresh: !this.state.refresh,
                            });
                            this.refs.GroupTag && this.refs.GroupTag.selectPosition(0);
                        } else {
                            this.refs.GroupTag && this.refs.GroupTag.selectPosition(0);
                            this.refs.GroupTag && this.refs.GroupTag.setCollapse(true);
                            this.getBottomListData(this.state.productListId, '1', lgroup);
                        }
                    }}
                />
                <GroupTag
                    ref="GroupTag"
                    data={this.state.secondClassData}
                    onSecondClassSelect={(lgroup) => {
                        //alert(lgroup);
                        this.getBottomListData(this.state.productListId, '2', lgroup)
                    }}
                />

                <FlatList
                    key={++key}
                    style={{flex:1}}
                    data={this.state.productData}
                    numColumns={2}
                    initialNumToRender={10}
                    getItemLayout={(data, index) => (
                    {length: ScreenUtil.scaleSize(567), offset: ScreenUtil.scaleSize(567) * index, index}
                    )}
                    renderItem={({item}) => <Item item={item}/>}
                />
                <Toast ref="toast"/>
            </View>
        );
    }
}
class Item extends React.Component {

    render() {
        let item = this.props.item;
        return (
            <PressTextColor
                nativeRef={[{
                    ref: this.refs.prodTitle,
                    touchColor: Colors.text_light_grey
                }]}
                style={{justifyContent: 'center'}}
                onPress={() => {
                    Actions.GoodsDetailMain({itemcode: item.contentCode});
                }}>
                <View style={styles.tabItem}>
                    <Image
                        style={styles.tabItemImg}
                        source={{uri: item.firstImgUrl ? item.firstImgUrl : ''}}/>

                    {/*
                        item.contentType !== null && item.contentType !== '0' ? //主播推荐
                            <View style={{flexDirection: 'row'}}>
                                <Image
                                    source={require('../Img/searchpage/Icon_anchorrecommend_tag_@2x.png')}
                                    style={styles.commendStyle}/>
                                <Text ref="prodTitle" numberOfLines={2}
                                      allowFontScaling={false}
                                      style={styles.tabItemDesc}>                 {item.title}</Text>
                            </View> :
                            <Text ref="prodTitle" style={styles.tabItemDesc}
                                  allowFontScaling={false}
                                  numberOfLines={2}>{item.title}</Text>
                    */}


                    <Text
                        numberOfLines={2}
                        ref="prodTitle"
                        allowFontScaling={false}
                        style={styles.tabItemDesc}>
                        {this._renderFlagImg(item)}{item.title}
                    </Text>
                    <View style={styles.tabItemPriceRow}>
                        <Text allowFontScaling={false} style={styles.tabItemPriceSymbol}>￥</Text>
                        <Text
                            allowFontScaling={false}
                            style={styles.tabItemPrice}>{parseInt(item.salePrice.split('.')[1]) > 0 ? item.salePrice : item.salePrice.split('.')[0]}</Text>
                        {
                            //积分显示
                            item.integral !== null && parseFloat(item.integral) !== 0 ?
                                <Image source={require('../Img/searchpage/Icon_accumulate_@2x.png')}
                                       style={styles.accumImg}/>
                                : null
                        }
                        {
                            item.integral !== null && parseFloat(item.integral) !== 0 ?
                                <View style={{alignItems:'flex-start',justifyContent:'flex-end',flex:1}}>
                                    <Text allowFontScaling={false}
                                          style={styles.saveamtStyle}>{String(item.integral)}</Text>
                                </View> :
                                <View style={{justifyContent:'center',flex:1}}>
                                    <Text allowFontScaling={false} style={styles.saveamtStyle}>{''}</Text>
                                </View>
                        }
                        <Text
                            allowFontScaling={false}
                            style={styles.tabItemGift}>{item.gifts ? '赠品' : null}</Text>
                    </View>
                    <View style={styles.tabItemSaleRow}>
                        <Text
                            allowFontScaling={false}
                            style={styles.tabItemSaleNum}>{item.salesVolume ? item.salesVolume + '人已购买' : null}</Text>
                        <Text
                            allowFontScaling={false}
                            style={styles.tabItemStockStatus}>{item.isInStock === 1 ? '库存紧张' : null}</Text>
                    </View>
                </View>
            </PressTextColor>
        )
    }

    /**
     * 渲染商品标记
     * @param item
     * @private
     */
    _renderFlagImg(item) {
        let img = null;
        let imgStyle = null;
        if (item.contentType === '0') {
            img = require('../Img/searchpage/Icon_globalbuy_tag_.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (80 / 2) * ScreenUtils.pixelRatio,
                        width: (23 / 2) * ScreenUtils.pixelRatio,
                    }
                })
            };
        } else if (item.contentType === '1') {
            img = require('../Img/searchpage/Icon_anchorrecommend_tag_.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (110 / 2) * ScreenUtils.pixelRatio,
                        width: (26 / 2) * ScreenUtils.pixelRatio,
                    },
                    ios: {
                        height: ScreenUtils.scaleSize(26),
                        width: ScreenUtils.scaleSize(110)
                    }
                })
            };
        } else if (item.contentType === '3') {
            img = require('../Img/searchpage/icon_groupbuying2_@3x.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (79 / 2) * ScreenUtils.pixelRatio,
                        width: (24 / 2) * ScreenUtils.pixelRatio,
                    },
                    ios: {
                        height: ScreenUtils.scaleSize(26),
                        width: ScreenUtils.scaleSize(70)
                    }
                })
            };
        } else if (item.contentType === '2') {
            img = require('../Img/searchpage/tag_shangcheng@3x.png');
            imgStyle = {
                ...Platform.select({
                    android: {
                        height: (72 / 2) * ScreenUtils.pixelRatio,
                        width: (27 / 2) * ScreenUtils.pixelRatio,
                    },
                    ios: {
                        height: ScreenUtils.scaleSize(27),
                        width: ScreenUtils.scaleSize(72)
                    }
                })
            };
        }
        if (img) {
            return (
                <Image
                    source={img}
                    resizeMode={'stretch'}
                    style={imgStyle}/>
            );
        }
        return <Text/>;
    }
}

const styles = StyleSheet.create({
        //scrollableTabView
        scrollableTabView: {
            flex: 1,
            width: width,
            marginTop: 10,
            backgroundColor: Colors.background_white,
        },
        tabBarText: {
            fontSize: Fonts.page_normal_font(),
        },
        tabBarUnderLine: {
            height: 2,
            color: '#E5290D',
            backgroundColor: Colors.main_color
        },
        tabFlatList: {
            backgroundColor: Colors.background_grey,
        },
        tabItem: {
            backgroundColor: Colors.background_white,
            alignItems: 'flex-start',
            justifyContent: 'flex-start',
            flex: 1,
            padding: 10,
            marginBottom: 1,
            marginRight: 1,
            width: width / 2,
        },
        tabItemImg: {
            resizeMode: 'contain',
            height: ScreenUtil.scaleSize(355),
            width: width / 2 - 20,
        },
        tabItemDesc: {
            fontSize: ScreenUtil.setSpText(28),
            color: Colors.text_black,
            marginTop: 10,
            includeFontPadding: false
        },
        iconStyle: {
            width: ScreenUtil.scaleSize(70),
            height: ScreenUtil.scaleSize(32),
            position: 'absolute',
            left: 0,
            top: ScreenUtil.scaleSize(20),
            zIndex: 11,
            borderRadius: 0,
            resizeMode: 'contain',
        },
        tabItemPriceRow: {
            flexDirection: 'row',
            marginTop: 5,
            alignItems:'center',
        },
        tabItemPriceSymbol: {
            fontSize: ScreenUtil.setSpText(26),
            color: Colors.main_color,
        },
        tabItemPrice: {
            fontSize: ScreenUtil.setSpText(36),
            color: Colors.main_color,
            marginBottom: -1
        },
        tabItemOldPrice: {
            fontSize: Fonts.secondary_font(),
            marginLeft: 5,
            textDecorationLine: 'line-through',
            flex: 1,
            color: Colors.text_light_grey,
        },
        tabItemGift: {
            fontSize: Fonts.secondary_font(),
            borderRadius: 3,
            color: Colors.main_color,
        },
        tabItemSaleRow: {
            marginTop: 5,
            flexDirection: 'row'
        },
        tabItemSaleNum: {
            flex: 1,
            fontSize: Fonts.secondary_font(),
            color: Colors.text_light_grey,
        },
        tabItemStockStatus: {
            fontSize: Fonts.secondary_font(),
            color: Colors.main_color,
        },
        saveamtStyle: {
            flex: 1,
            color: '#FA6923',
            fontSize: ScreenUtil.setSpText(24),
            marginTop: ScreenUtil.scaleSize(4),
            marginLeft: ScreenUtil.scaleSize(10),
            height: ScreenUtil.scaleSize(36),
            textAlignVertical: "bottom"
        },
        accumImg: {
            width: ScreenUtil.scaleSize(32),
            height: ScreenUtil.scaleSize(32),
            borderRadius: 4,
            marginTop: ScreenUtil.scaleSize(4),
            marginLeft: ScreenUtil.scaleSize(10),
        },
        commendStyle: {
            width: ScreenUtil.scaleSize(110),
            height: ScreenUtil.scaleSize(40),
            position: 'absolute',
            left: 0,
            top: ScreenUtil.scaleSize(16),
            zIndex: 11,
            borderRadius: ScreenUtil.scaleSize(0),
            resizeMode: 'contain',
        },
    }
)
