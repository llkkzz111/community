/**
 * @author lu weiguo
 *
 * 收藏夹
 */
import React, {Component} from 'react'
import {
    StyleSheet,
    View,
    Text,
    Image,
    FlatList,
    TouchableOpacity,
} from 'react-native';

// 适屏
import * as ScreenUtils from '../utils/ScreenUtil';
import DelectFavoriteRequest from '../net/mine/DelectFavoriteRequest';

import {Actions} from 'react-native-router-flux';
// 请求加入购物车
import AddCartRequest from '../../foundation/net/GoodsDetails/AddCartRequest';
// 引入提示信息
import ToastShow from '../../foundation/common/ToastShow';

// 引入获取收藏商品 URL 请求
import UserFavoriteRequest from '../net/mine/UserFavoriteRequest';
import {DataAnalyticsModule} from '../../app/config/AndroidModules';

import {SwipeRow} from 'react-native-swipe-list-view';

let requestBody = {
    page: "1"
};

let key = 1;

export default class FavoriteItem extends Component {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            //     userFavorite:this.props.userFavorite,
            delectRequre: {},
            currentlyOpenSwipeable: null,
            userFavorite: this.props.userFavorite,

            swipe: false,
        };
        this.page = 1;
    }

    handleScroll = () => {
        //      const currentlyOpenSwipeable = this.state.currentlyOpenSwipeable;
        if (this.state.currentlyOpenSwipeable) {
            this.state.currentlyOpenSwipeable.recenter();
        }
    };

    render() {
        const {userFavorite} = this.state;
        const itemProps = {
            onOpen: (event, gestureState, swipeable) => {
                if (this.state.currentlyOpenSwipeable && this.state.currentlyOpenSwipeable !== swipeable) {
                    this.state.currentlyOpenSwipeable.recenter();
                }
                this.setState({currentlyOpenSwipeable: swipeable});
            },
            onClose: () => this.setState({currentlyOpenSwipeable: null})
        };
        return (
            <FlatList
                //key={++key}
                scrollEnabled={!this.state.swipe}
                iosalwaysBounceHorizontal={false}
                data={this.state.userFavorite} onScroll={this.handleScroll} style={styles.container}
                renderItem={({item}) => (this._FavoriteItem({item, ...itemProps}))}
                onEndReachedThreshold={0.1}
                onEndReached={this._nextPage.bind(this)}
            >
            </FlatList>
        );
    }

    componentWillReceiveProps(nextPros) {
        this.setState({
            userFavorite: nextPros.userFavorite,
        });
        if (this.state.currentlyOpenSwipeable) {
            //关闭swipe
            this.state.currentlyOpenSwipeable.recenter();
        }
    }


    //加载更多
    _nextPage() {
        let self = this;
        this.page = this.page + 1;
        requestBody.page = this.page.toString();
        if (this.UserFavoriteRequest) {
            this.UserFavoriteRequest.setCancled(true);
        }
        this.UserFavoriteRequest = new UserFavoriteRequest(requestBody, 'GET');
        this.UserFavoriteRequest.showLoadingView(true).start(
            (response) => {
                if (response.data && response.data.myFavoriteList && response.data.myFavoriteList.length > 0) {
                    self.setState({
                        userFavorite: this.state.userFavorite.concat(response.data.myFavoriteList)
                    });
                } else {
                    this.page = this.page - 1;
                }
            }, (erro) => {
                this.page = this.page - 1;
            });
    }

    /**
     * 删除收藏夹数据
     * @param item_code
     * @private
     */
    _delectItem(item_code) {
        let self = this;
        if (this.DelectFavoriteRequest) {
            this.DelectFavoriteRequest.setCancled(true);
        }
        this.DelectFavoriteRequest = new DelectFavoriteRequest({item_code: item_code}, 'POST');
        this.DelectFavoriteRequest.showLoadingView(true).start(
            (response) => {
                DataAnalyticsModule.trackEvent3("AP1706C046F008002O008001", "", {type: "删除收藏", itemcode: item_code});
                self.props.deleteSuccessCallBack();
                //    ToastShow.toast(response.data.result);
            }, (erro) => {
                ToastShow.toast(response.message);
            });
    }

    /**
     * 加入购物车
     * @param item_code
     * @private
     */
    _addCart(item_code) {
        this.addCartR = new AddCartRequest({
            item_code: item_code,
            qty: 1,
            unit_code: "001",
            gift_item_code: "",
            gift_unit_code: "",
            giftPromo_no: "",
            giftPromo_seq: "",
            media_channel: "",
            msale_source: "",
            msale_cps: "",
            source_url: "http://ocj.com.cn",
            source_obj: "",
            timeStamp: "",
            ml_msale_gb: ""
        }, "POST");
        this.addCartR.setShowMessage(true).showLoadingView(true).start(
            (response) => {
                let jsonData = response.data;
                if (response.code && response.code === 200) {
                    ToastShow.toast(response.data.result.cart_msg)
                }
                DataAnalyticsModule.trackEvent3("AP1706C046F008002O008001", "", {type: "加入购物车", itemcode: item_code});
            }, (erro) => {
                ToastShow.toast(response.message)
            });
    }

    _FavoriteItem({item, onOpen, onClose}) {
        return (

            <SwipeRow
                rightOpenValue={-ScreenUtils.scaleSize(248)}
                disableRightSwipe={true}
            >
                <View style={styles.standaloneRowBack}>
                    <Text>_</Text>
                    <View style={{flexDirection: 'row'}}>
                        <TouchableOpacity
                            activeOpacity={1}
                            style={styles.favoritemStyle}
                            onPress={() => {
                                this._addCart(item.item_code)
                            }}
                        >
                            <Text allowFontScaling={false} style={styles.addCart}>加入</Text>
                            <Text allowFontScaling={false} style={styles.addCart}>购物车</Text>
                        </TouchableOpacity>
                        <TouchableOpacity
                            onPress={() => {
                                this._delectItem(item.item_code)
                            }}
                            activeOpacity={1}
                            style={[
                                styles.favoritemStyle,
                                {
                                    backgroundColor: '#ED1C41',
                                    justifyContent: "center",
                                    width: ScreenUtils.scaleSize(124),
                                    height: ScreenUtils.scaleSize(280)
                                }
                            ]}>
                            <Text allowFontScaling={false} style={styles.deleteBtn}>删除</Text>
                        </TouchableOpacity></View>
                </View>
                <TouchableOpacity
                    activeOpacity={1}
                    onPress={() => {
                        this._favoritetLink(item.item_code)
                    }}
                    style={[styles.listItem]}
                >
                    <View style={styles.listItemImgBox}>
                        <Image style={styles.listItemImg} source={{uri: item.item_image}}/>
                    </View>
                    <View style={styles.listItemInfo}>
                        <View style={{height: ScreenUtils.scaleSize(140)}}>
                            <Text allowFontScaling={false} numberOfLines={2}
                                  style={styles.itemName}>{item.item_name}</Text>
                            {
                                item.explain_note !== null && item.explain_note !== "" &&
                                <View style={styles.itemBottom}>
                                    <Image
                                        style={{
                                            width: ScreenUtils.scaleSize(44),
                                            height: ScreenUtils.scaleSize(30),
                                        }}
                                        source={require("../Img/me/Icon_gifts_@2x.png")}
                                    />
                                    <Text allowFontScaling={false}
                                          style={{
                                              paddingLeft: ScreenUtils.scaleSize(10),
                                              flex: 1,
                                          }}
                                          numberOfLines={1}
                                    >
                                        {String(item.explain_note)}
                                    </Text>
                                </View>
                            }
                        </View>
                        <View style={styles.listItemInfoHead}>
                            <Text allowFontScaling={false} style={[styles.redColor, styles.spPriceStype]}>¥</Text>
                            <Text allowFontScaling={false}
                                  style={[styles.redColor, styles.spPrice]}>{String(item.item_price)}</Text>
                            <Text allowFontScaling={false} style={styles.oldPrice}>¥{String(item.cust_price)}</Text>
                            {
                                item.save_amt !== null && item.save_amt !== 0 &&
                                <View style={{flexDirection: "row"}}>
                                    <Image source={require("../Img/common/Icon_integralbg_@3x.png")}
                                           style={{
                                               width: ScreenUtils.scaleSize(50),
                                               height: ScreenUtils.scaleSize(30)
                                           }}
                                    />
                                    <Text allowFontScaling={false}
                                          style={{marginLeft: ScreenUtils.scaleSize(10)}}>{String(item.save_amt)}</Text>
                                </View>
                            }
                        </View>
                        <Text allowFontScaling={false} style={{color: "#666666"}}>{String(item.saleQty)} 人已购买</Text>
                        {this._renderInventor(item.qty_label)}
                    </View>
                </TouchableOpacity>
            </SwipeRow>
        );
    }

    _favoritetLink(item) {
        DataAnalyticsModule.trackEvent('AP1706C046B008001D002001');
        Actions.GoodsDetailMain({'itemcode': item});
    }

    /**
     * 是否显示原价
     * @param num
     * @private
     */
    _renderOrigina(num) {
        if (num !== 0) {
            return (
                <Text allowFontScaling={false} style={styles.oldPrice}>¥{num}</Text>
            )
        }
    }

    /**
     * 是否显示库存
     * @param num
     * @returns {XML}
     * @private
     */
    _renderInventor(num) {
        if (num) {
            return (
                <Text allowFontScaling={false} style={styles.nervousStyle}>{String(num)}</Text>
            )
        }
    }

    /**
     * 是否显示赠品
     * @param num
     * @private
     */
    _renderGift(num) {
        if (num !== null) {
            return (
                <View style={styles.itemBottom}>
                    <Image
                        style={{
                            width: ScreenUtils.scaleSize(44),
                            height: ScreenUtils.scaleSize(30),
                        }}
                        source={require("../Img/me/Icon_gifts_@2x.png")}
                    />
                    <Text allowFontScaling={false}
                          style={{
                              paddingLeft: ScreenUtils.scaleSize(10),
                              flex: 1,
                          }}
                          numberOfLines={1}
                    >
                        {item.explain_note}
                    </Text>
                </View>
            )
        }
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        paddingTop: ScreenUtils.scaleSize(0.5)
    },
    listItem: {
        flexDirection: "row",
        justifyContent: "space-between",
        backgroundColor: "#ffffff",
        paddingLeft: ScreenUtils.scaleSize(30),
        paddingTop: ScreenUtils.scaleSize(20),
        width: ScreenUtils.screenW,
    },
    leftSwipeItem: {
        flex: 1,
        alignItems: 'flex-end',
        paddingRight: ScreenUtils.scaleSize(20)
    },
    rightSwipeItem: {
        flex: 1,
        paddingLeft: ScreenUtils.scaleSize(40)
    },
    deleteBtn: {
        color: "#FFFFFF",
        fontSize: ScreenUtils.setSpText(28),
    },


    listItemImgBox: {
        width: ScreenUtils.scaleSize(240),
        height: ScreenUtils.scaleSize(240),
    },
    listItemImg: {
        width: ScreenUtils.scaleSize(238),
        height: ScreenUtils.scaleSize(240),
        resizeMode: "stretch",
    },
    listItemInfo: {
        flex: 1,
        marginLeft: ScreenUtils.scaleSize(30),
        paddingRight: ScreenUtils.scaleSize(30),
        borderBottomWidth: 1,
        borderBottomColor: '#DDDDDD',
        paddingBottom: ScreenUtils.scaleSize(30),
    },
    listItemInfoHead: {
        flexDirection: "row",
        alignItems: "center",
        paddingBottom: ScreenUtils.scaleSize(15)
    },
    redColor: {
        color: "#E5290D"
    },
    spPriceStype: {
        fontSize: ScreenUtils.setSpText(26)
    },
    spPrice: {
        fontSize: ScreenUtils.setSpText(36)
    },
    oldPrice: {
        color: "#999999",
        fontSize: ScreenUtils.setSpText(24),
        textDecorationLine: "line-through",
        marginRight: ScreenUtils.scaleSize(8),
        marginLeft: ScreenUtils.scaleSize(8),
    },
    itemName: {
        fontSize: ScreenUtils.setSpText(28),
        color: "#333333",
        lineHeight: 20,
    },
    itemBottom: {
        flexDirection: "row",
        marginTop: ScreenUtils.scaleSize(10)
    },
    giftTitle: {
        color: "#666666",
        fontSize: ScreenUtils.setSpText(24),
        marginLeft: ScreenUtils.scaleSize(10)
    },
    favoritemStyle: {
        width: ScreenUtils.scaleSize(124),
        height: ScreenUtils.scaleSize(280),
        justifyContent: "center",
        alignItems: "center",
    },
    addCart: {
        fontSize: ScreenUtils.setSpText(28),
    },
    nervousStyle: {
        position: "absolute",
        right: 10,
        bottom: 20,
        color: "#ED1C41",
        fontSize: ScreenUtils.setSpText(22)
    },
    standaloneRowBack: {
        alignItems: 'center',
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'space-between',
        height: ScreenUtils.scaleSize(280),
    },
});