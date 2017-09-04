/**
 * Created by Administrator on 2017/5/13.
 */
'use strict';
import React, {Component, PureComponent} from "react";
import {
    Dimensions,
    FlatList,
    Image,
    NetInfo,
    StyleSheet,
    Text,
    TouchableOpacity,
    View,
    StatusBar,
    Platform
} from "react-native";
import * as ScreenUtil from "../../../foundation/utils/ScreenUtil";
import Colors from "../../../app/config/colors";
import Fonts from "../../../app/config/fonts";
import {Actions} from "react-native-router-flux";
import ClassificationListRequest from "../../../foundation/net/classification/ClassificationListRequest";
import NetErro from '../../components/error/NetErro';
import Toast, {DURATION} from 'react-native-easy-toast';

const {width} = Dimensions.get('window');
let classificationListRequest;
//排序
let searchSelect = '';
//请求参数
let requestBody = {
    search: 'newitem',//排序(见changeSort方法)，
    currPageNo: '1',//当前页码
    brand_code: '',//筛选品牌
    priceRange: '',//筛选价格
};
import {getStatusHeight} from '../../../foundation/common/NavigationBar';
import ClassifyProductItem from '../../../foundation/classification/ClassifyProductItem';
import ShaiModel from './classifycomponents/ShaiModel';
var key = 0;
let page = 1;//当前页码

/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;

export default class ClassificationProductListPage extends Com {
    constructor(props) {
        super(props);
        this.state = {
            displayColumn: true,//true: column;false:row
            titleHintText: '',
            dataList: [],
            sortIndex: 0,
            showErro: false,
            noNet: false,
            openShaixuan: false,
            pinpai: [],
            jiage: [],
        }
        this.productRequest = this.productRequest.bind(this);
    }

    componentDidMount() {
        // console.log('-------->' + this.props.shopCode + '----' + this.props.itemCode);
        NetInfo.isConnected.fetch().done((isConnected) => {
            if (isConnected) {
                //有网络
                this.productRequest(this.props.shopCode, this.props.itemCode, requestBody);
            } else {
                //无网络
                this.setState({
                    noNet: true,
                    showErro: false,
                });
            }
        });
    }

    componentWillUnmount() {
        requestBody = {
            search: 'newitem',
            currPageNo: '1',
            priceRange: '',
            brand_code: '',
        }
        searchSelect = '';
        page = 1;
    }

    closeMySelf() {
        this.setState({
            openShaixuan: false
        })
    }

    submitShai(value) {
        this.setState({
            openShaixuan: false
        });
        //this.productRequest(this.props.shopCode,this.props.itemCode, requestBody);
        if (value) {
            if (value.brand_code) {
                requestBody.brand_code = value.brand_code;
            } else {
                requestBody.brand_code = '';
            }

            if (value.low && value.high) {
                value.prices.push(value.low + '-' + value.high);
            }

            if (value.prices.length > 0) {
                requestBody.priceRange = value.prices.join(',');
            } else {
                requestBody.priceRange = '';
            }
        }
        requestBody.search = 'newitem';
        requestBody.currPageNo = '1';
        page = 1;
        this.productRequest(this.props.shopCode, this.props.itemCode, requestBody);
    }

    productRequest(shopCode, itemCode, body) {
        classificationListRequest = new ClassificationListRequest(body, 'GET');
        classificationListRequest.setItemCode(shopCode, itemCode);
        classificationListRequest.showLoadingView().setShowMessage(true).start(
            (jsonResponse) => {
                if (jsonResponse.code === 200) {
                    let list;
                    let data = jsonResponse.data ? jsonResponse.data : null;
                    if (data) {
                        if (page === 1) {
                            ++key;
                            this.setState({
                                dataList: [],//clear搜索结果
                            });
                            list = data.gooList ? data.gooList : [];
                            if (data.gooList.length > 0) {
                                this.setState({
                                    titleHintText: jsonResponse.data.title,
                                    dataList: list,
                                    showErro: false,
                                    noNet: false,
                                    jiage: jsonResponse.data.priceList,
                                    pinpai: jsonResponse.data.brandList,
                                });
                            } else {
                                this.setState({
                                    titleHintText: jsonResponse.data.title,
                                    dataList: list,
                                    showErro: true,
                                    noNet: false,
                                    jiage: jsonResponse.data.priceList,
                                    pinpai: jsonResponse.data.brandList,
                                });
                            }
                        } else {
                            if (data.gooList) {
                                if (data.gooList.length > 0) {
                                    list = this.state.dataList.concat(data.gooList);
                                    this.setState({
                                        titleHintText: jsonResponse.data.title,
                                        dataList: list,
                                        showErro: false,
                                        noNet: false,
                                        jiage: jsonResponse.data.priceList,
                                        pinpai: jsonResponse.data.brandList
                                    });
                                } else {
                                    if (!data.hasMore) {
                                        this.refs.toast.show('已经是最后一页', DURATION.LENGTH_LONG);
                                        page -= 1;
                                    }
                                }
                            }
                        }
                        // for (let i = 0; i < data.gooList.length; i++) {
                        //     console.log('item_code:' + data.gooList.item_code);
                        // }
                    }
                } else {
                    // alert(jsonResponse.message);
                    this.refs.toast.show(jsonResponse.message, DURATION.LENGTH_LONG);
                }
            }
            ,
            (e) => {
                // alert(e);
                this.setState({
                    showErro: true,
                    noNet: false,
                });
            }
        );
    }

    _renderStatus() {
        return (
            <StatusBar
                translucent={true}
                barStyle={'dark-content'}
                backgroundColor={'transparent'}
            />
        );
    }

    render() {
        return (
            <View style={styles.containers}>
                {this._renderStatus()}
                <ProductListTitle
                    count={5}
                    hintText={this.state.titleHintText}
                    onListTypeChange={(isRow) => {
                        this.setState({displayColumn: isRow});
                    }}
                    changeSort={(index) => {
                        switch (index) {
                            case 0:
                                //最新排序
                                searchSelect = searchSelect === 'newitem' ? 'newitemasc' : 'newitem';
                                break;
                            case 1:
                                //销量排序
                                searchSelect = searchSelect === 'orderdesc' ? 'orderasc' : 'orderdesc';
                                break;
                            case 2:
                                //评论排序
                                searchSelect = searchSelect === 'commdesc' ? 'commasc' : 'commdesc';
                                break;
                            case 3:
                                //价格排序
                                searchSelect = searchSelect === 'pricedesc' ? 'priceasc' : 'pricedesc';
                                break;
                            case 4:
                                //筛选
                                this.setState({
                                    openShaixuan: true,
                                })
                                break;
                        }
                        //选择排序，重置页码
                        requestBody = {
                            search: searchSelect,
                            currPageNo: '1',
                            priceRange: requestBody.priceRange,
                            brand_code: requestBody.brand_code,
                        };
                        page = 1;

                        NetInfo.isConnected.fetch().done((isConnected) => {
                            if (isConnected) {
                                //有网络
                                if (index < 4) {
                                    this.productRequest(this.props.shopCode, this.props.itemCode, requestBody);
                                }
                            } else {
                                //无网络
                                this.setState({
                                    noNet: true,
                                    showErro: false,
                                });
                            }
                        });

                    }
                    }
                    titleData={[
                        {selectIndex: 0, title: '最新', range: false, isSelected: true},
                        {selectIndex: 1, title: '销量', range: false, isSelected: false},
                        {selectIndex: 2, title: '评论', range: true, isSelected: false},
                        {selectIndex: 3, title: '价格', range: false, isSelected: false},
                        {selectIndex: 4, title: '筛选', range: false, isSelected: false},
                    ]}/>
                {
                    //断网
                    this.state.noNet ?
                        <NetErro
                            style={styles.errorView}
                            icon={require('../../../foundation/Img/searchpage/img_noNetWork_2x.png')}
                            title={'您的网络好像很傲娇'}
                            confirmText={'刷新试试'}
                            onButtonClick={() => {
                                //根据不同的页面做不同的请求
                                NetInfo.isConnected.fetch().done((isConnected) => {
                                    if (isConnected) {
                                        //有网络
                                        this.productRequest(this.props.shopCode, this.props.itemCode, requestBody);
                                    }
                                });
                            }}
                        />
                        :
                        // 接口异常
                        this.state.showErro ?
                            <NetErro
                                style={styles.errorView}
                                icon={require('../../../foundation/Img/searchpage/img_no_search_result_2x.png')}
                                title={'真心找不到呀！'}
                                titleStyle={{fontSize: ScreenUtil.setSpText(32), color: Colors.text_black}}
                                desc={'要不要考虑换个关键词'}
                                descStyle={{
                                    fontSize: ScreenUtil.setSpText(26),
                                    color: Colors.text_light_grey
                                }}
                            />
                            :
                            <FlatList
                                ref="productList"
                                key={key}
                                style={{
                                    ...Platform.select({
                                        ios: {height: ScreenUtil.screenH - 54 - ScreenUtil.scaleSize(88) - 22},
                                        android: {height: ScreenUtil.screenH - 54 - ScreenUtil.scaleSize(88)}
                                    })
                                }}
                                data={this.state.dataList}
                                numColumns={this.state.displayColumn ? 1 : 2}
                                onEndReachedThreshold={0.1}
                                refreshing={false}
                                onRefresh={() => {
                                    requestBody = {
                                        search: requestBody.search,
                                        currPageNo: '1',
                                        priceRange: requestBody.priceRange,
                                        brand_code: requestBody.brand_code,
                                    };
                                    page = 1;
                                    NetInfo.isConnected.fetch().done((isConnected) => {
                                        if (isConnected) {
                                            //有网络
                                            this.productRequest(this.props.shopCode, this.props.itemCode, requestBody);
                                        } else {
                                            //无网络
                                            this.setState({
                                                noNet: true,
                                                showErro: false,
                                            });
                                        }
                                    });
                                }
                                }
                                onEndReached={() => {
                                    page += 1;
                                    requestBody = {
                                        search: requestBody.search,
                                        currPageNo: page.toString(),
                                        priceRange: requestBody.priceRange,
                                        brand_code: requestBody.brand_code,
                                    };
                                    NetInfo.isConnected.fetch().done((isConnected) => {
                                        if (isConnected) {
                                            //有网络
                                            this.productRequest(this.props.shopCode, this.props.itemCode, requestBody);
                                        } else {
                                            //无网络
                                            this.setState({
                                                noNet: true,
                                                showErro: false,
                                            });
                                        }
                                    });
                                }
                                }
                                renderItem={({item, index}) => {
                                    return (
                                        <ClassifyProductItem searchItem={item}
                                                             displayDirection={this.state.displayColumn ? "column" : "row"}/>
                                    );
                                }}
                            />
                }
                {
                    //非断网
                    !this.state.showErro && !this.state.noNet ?
                        <View style={{
                            resizeMode: 'contain',
                            position: 'absolute',
                            bottom: ScreenUtil.scaleSize(100),
                            right: ScreenUtil.scaleSize(24),
                        }}>
                            <TouchableOpacity activeOpacity={1} onPress={() => {
                                Actions.cartFromGoodsDetail();
                            }}>
                                <Image
                                    style={{
                                        height: ScreenUtil.scaleSize(80),
                                        width: ScreenUtil.scaleSize(80),
                                        marginLeft: ScreenUtil.scaleSize(6),
                                        resizeMode: 'contain',
                                    }}
                                    source={require('../../../foundation/Img/searchpage/Icon_cart_gray_@3x.png')}/>
                            </TouchableOpacity>
                        </View>
                        :
                        null
                }

                <ShaiModel open={this.state.openShaixuan}
                           pinpai={this.state.pinpai}
                           jiage={this.state.jiage}
                           close={() => {
                               this.closeMySelf()
                           }}
                           submit={(value) => {
                               this.submitShai(value)
                           }}
                />

                <Toast ref="toast"/>
            </View>
        )
    }
}

class ProductListTitle extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            selectedIndex: 0,
            listTypeIsRow: true,
            saleSortIndex: 0,
        }
    }

    _clickSelect = (index) => {
        let tmp = 0;
        if (index === 3) {
            if (this.state.sortIndex === 0) {
                tmp = 1;
            } else if (this.state.sortIndex === 1) {
                tmp = 2;
            } else {
                tmp = 1;
            }
        }
        let tmpSaleSort = 0;
        if (index === 1) {
            if (this.state.saleSortIndex === 0) {
                tmpSaleSort = 1;
            } else if (this.state.saleSortIndex === 1) {
                tmpSaleSort = 2;
            } else {
                tmpSaleSort = 1;
            }
        }
        this.setState({
            sortIndex: tmp,
            selectedIndex: index,
            saleSortIndex: tmpSaleSort,
        });
        this.props.changeSort(index);
    }

    render() {
        return (
            <View style={{paddingTop: getStatusHeight(), backgroundColor: Colors.background_white}}>
                <View>
                    <View style={styles.searchRow}>
                        <TouchableOpacity
                            style={styles.backIconContainer}
                            activeOpacity={1}
                            onPress={() => {
                                Actions.pop();
                                page = 1;
                                requestBody.page = 1;
                            }}>
                            <Image source={require('../../../foundation/Img/searchpage/Icon_back_@3x.png')}
                                   style={styles.searchRowBackIcon}/>
                        </TouchableOpacity>
                        <Text
                            allowFontScaling={false}
                            style={styles.pageTitleText}>{this.props.hintText}</Text>

                        <TouchableOpacity activeOpacity={1} onPress={() => {
                            this.setState({listTypeIsRow: !this.state.listTypeIsRow});
                            this.props.onListTypeChange(!this.state.listTypeIsRow);
                        }}>
                            <Image
                                source={this.state.listTypeIsRow ? require('../../../foundation/Img/searchpage/Icon_listrow_@3x.png') : require('../../../foundation/Img/searchpage/Icon_listcolumn_@3x.png')}
                                style={styles.listTypeBtnIcon}/>
                        </TouchableOpacity>
                    </View>
                    <View style={{height: 1, backgroundColor: Colors.line_grey}}/>
                </View>
                <View style={styles.titleRow}>
                    {
                        this.props.titleData !== '' && this.props.titleData !== null && this.props.titleData.map((titleItem, i) => {
                            return (
                                <View style={styles.titleRowItem} key={i}>
                                    <TouchableOpacity
                                        style={[styles.titleRowTouchableItem, {width: width / this.props.count,}]}
                                        activeOpacity={1}
                                        onPress={() => this._clickSelect(i)}>
                                        <View style={styles.titleItemTextContainer}>
                                            {
                                                i === 4 ?
                                                    this.state.selectedIndex === 4 ?
                                                        <Image
                                                            source={require('../../../foundation/Img/searchpage/icon_filter_red_.png')}
                                                            style={styles.filterStyle}/>
                                                        :
                                                        <Image
                                                            source={require('../../../foundation/Img/searchpage/Icon_filter_.png')}
                                                            style={styles.filterStyle}/>
                                                    :
                                                    null
                                            }
                                            <Text
                                                allowFontScaling={false}
                                                style={[styles.titleItemText, {color: i === this.state.selectedIndex ? Colors.main_color : Colors.text_dark_grey}]}>{titleItem.title}</Text>
                                            {
                                                i === 3 ?
                                                    this.state.selectedIndex === 3 ?
                                                        this.state.sortIndex === 1 ?
                                                            <Image
                                                                source={require('../../../foundation/Img/searchpage/icon_desc_@2x.png')}
                                                                style={styles.sortStyle}/>
                                                            :
                                                            <Image
                                                                source={require('../../../foundation/Img/searchpage/Icon_sort_ltoh_@3x.png')}
                                                                style={styles.sortStyle}/>
                                                        :
                                                        <Image
                                                            source={require('../../../foundation/Img/searchpage/Icon_sort_@3x.png')}
                                                            style={styles.sortStyle}/>
                                                    :
                                                    null
                                            }

                                            {
                                                i === 1 ?
                                                    this.state.selectedIndex === 1 ?
                                                        this.state.saleSortIndex === 1 ?
                                                            <Image
                                                                source={require('../../../foundation/Img/searchpage/icon_desc_@3x.png')}
                                                                style={styles.sortStyle}/>
                                                            :
                                                            <Image
                                                                source={require('../../../foundation/Img/searchpage/Icon_sort_ltoh_@2x.png')}
                                                                style={styles.sortStyle}/>
                                                        :
                                                        <Image
                                                            source={require('../../../foundation/Img/searchpage/Icon_sort_@3x.png')}
                                                            style={styles.sortStyle}/>
                                                    :
                                                    null
                                            }
                                        </View>
                                        <View
                                            style={[styles.indicatorLine, {
                                                width: width / this.props.count,
                                                backgroundColor: i === this.state.selectedIndex ? Colors.main_color : Colors.background_white
                                            }]}/>
                                    </TouchableOpacity>
                                    <View style={styles.divideLine}/>
                                </View>
                            )
                        })
                    }
                </View>
                <View style={{height: 1, backgroundColor: Colors.line_grey}}/>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    cartIcon: {
        width: 35,
        height: 35,
        resizeMode: 'contain',
        position: 'absolute',
        right: 100,
        bottom: 100,
        left: 0,
        top: 0,
    },
    pageTitleText: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        textAlign: 'center',
        fontSize: ScreenUtil.setSpText(34),
        color: Colors.text_black,
    },
    commendStyle: {
        width: ScreenUtil.scaleSize(110),
        height: ScreenUtil.scaleSize(26),
        position: 'absolute',
        left: 0,
        top: ScreenUtil.scaleSize(4),
        zIndex: 11,
        borderRadius: ScreenUtil.scaleSize(0),
        resizeMode: 'contain',
    },
    groupTitle: {
        color: Colors.text_black,
        fontSize: ScreenUtil.setSpText(28)
    },
    containers: {
        backgroundColor: '#EDEDED',
        ...Platform.select({
            ios: {marginTop: -35},
            android: {marginTop: -20}
        })
    },
    rowGoods: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        paddingBottom: ScreenUtil.scaleSize(200),
    },
    columnGoods: {
        flexDirection: 'column',
        paddingBottom: ScreenUtil.scaleSize(200),
    },
    searchRow: {
        height: ScreenUtil.scaleSize(88),
        backgroundColor: Colors.background_white,
        marginTop: 1,
        flexDirection: 'row',
        alignItems: 'center',
        paddingLeft: ScreenUtil.scaleSize(20),
        paddingRight: ScreenUtil.scaleSize(20),
    },
    backIconContainer: {
        justifyContent: 'center',
        alignItems: 'center',
        width: ScreenUtil.scaleSize(88),
        height: ScreenUtil.scaleSize(64),
    },
    searchRowBackIcon: {
        width: ScreenUtil.scaleSize(20),
        height: ScreenUtil.scaleSize(32),
    },
    listMessageIcon: {
        resizeMode: 'contain',
        width: ScreenUtil.scaleSize(44),
        height: ScreenUtil.scaleSize(41),
    },
    titleRow: {
        backgroundColor: 'white',
        flexDirection: 'row'
    },
    titleRowItem: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    titleRowTouchableItem: {
        justifyContent: 'center',
        alignItems: 'center',
    },
    titleItemTextContainer: {
        height: 38,
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'row'
    },
    titleItemText: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtil.setSpText(26)
    },
    sortStyle: {
        height: ScreenUtil.scaleSize(24),
        width: ScreenUtil.scaleSize(20),
        marginLeft: 5,
    },

    filterStyle: {
        height: ScreenUtil.scaleSize(26),
        width: ScreenUtil.scaleSize(24),
        marginTop: 1,
        marginRight: 1,
        resizeMode: 'contain'
    },
    indicatorLine: {
        backgroundColor: Colors.main_color,
        height: 2,
    },
    divideLine: {
        height: 20,
        width: 1,
        backgroundColor: Colors.line_grey
    },
    item: {
        marginRight: 1,
        marginBottom: 1,
        backgroundColor: Colors.background_white,
        width: ScreenUtil.screenW / 2,
        padding: 5,
        justifyContent: 'center',
    },
    itemImg: {
        width: ScreenUtil.scaleSize(355),
        height: ScreenUtil.scaleSize(355),
        resizeMode: 'stretch'
    },
    itemTextMark: {
        position: 'absolute',
        left: 0,
        borderRadius: 5,
        color: Colors.text_white,
        fontSize: Fonts.secondary_font(),
    },
    itemText: {
        marginTop: 10,
        height: ScreenUtil.scaleSize(66),
        fontSize: ScreenUtil.setSpText(26),
        color: Colors.text_black,
        textAlign: "left"
    },
    priceRow: {
        marginTop: 10,
        flexDirection: 'row',
        alignItems: 'flex-end',
    },
    itemPrice: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(36),
    },
    itemScoreMark: {
        marginLeft: 5,
        paddingLeft: 3,
        paddingRight: 3,
        paddingTop: 2,
        paddingBottom: 2,
        color: Colors.text_white,
        fontSize: ScreenUtil.setSpText(22),
        backgroundColor: Colors.yellow,
        borderRadius: 3,
    },
    itemScore: {
        marginLeft: 5,
        color: Colors.yellow,
        fontSize: ScreenUtil.setSpText(26),
    },
    itemGiftMark: {
        padding: 2,
        color: Colors.magenta,
        backgroundColor: '#FBE7EA',
        fontSize: ScreenUtil.setSpText(22),
        borderRadius: 3,
    },
    itemStockStatus: {
        marginTop: 10,
        color: Colors.magenta,
        fontSize: ScreenUtil.setSpText(22),
    },
    errorView: {
        ...Platform.select({
            ios: {height: ScreenUtil.screenH - 54 - ScreenUtil.scaleSize(88) - 22},
            android: {height: ScreenUtil.screenH - 54 - ScreenUtil.scaleSize(88)}
        })
    },
    listTypeBtnIcon: {
        width: ScreenUtil.scaleSize(88),
        height: ScreenUtil.scaleSize(44),
        resizeMode: 'contain',
    }
});
