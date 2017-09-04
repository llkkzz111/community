/**
 * Created by Administrator on 2017/6/4.
 */
//搜索页面单个商品ITEM

import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
} from 'react-native';

import {Actions} from 'react-native-router-flux';
import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';
import PressTextColor from 'FOUNDATION/pressTextColor';
import ProductItemImg from '../classification/ProductItemImg';

export default class SearchItem extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            displayDirection: this.props.displayDirection, //排列方向
            times: ['00', '00', '00', '00', '00', '00',],
        }
    }

    componentDidMount() {
        let data = this.props.searchItem;
        let distance;
        let tmpTime1;
        let tmpTime2;
        if (data.server_time !== null && data.groupbuy_pro_end_date !== null) {
            //Format:YYYY/MM/DD HH::MM:SS
            tmpTime1 = ScreenUtil.getTaskTime(data.groupbuy_pro_end_date);
            tmpTime2 = data.server_time;
            //Change Format:MM/DD/YYYY HH::MM:SS
            tmpTime1 = tmpTime1.substring(5, 7) + "/" + tmpTime1.substring(8, 10) + "/" + tmpTime1.substring(0, 4) + tmpTime1.substring(10, tmpTime1.length);
            tmpTime2 = tmpTime2.substring(5, 7) + "/" + tmpTime2.substring(8, 10) + "/" + tmpTime2.substring(0, 4) + tmpTime2.substring(10, 19);
            distance = ScreenUtil.toTimestamp(tmpTime1) - ScreenUtil.toTimestamp(tmpTime2);
            this.timeStart(distance);
        }

    }

    timeStart(distance) {
        if (distance > 0) {
            this.setState({
                times: ScreenUtil.getRemainingimeDistance(distance),//获取时间数组
            });
            this.interval = setInterval(() => {
                if (distance <= 0) {
                    clearInterval(this.interval);
                }//时间到

                this.setState({
                    times: ScreenUtil.getRemainingimeDistance(distance),//获取时间数组
                });
                distance--;
            }, 60000);
        }
    }

    componentWillUnmount() {
        clearInterval(this.interval);//移除计时器
    }

    _jump(itemCode) {
        if (this.props.fromPage === 'Home') {
            Actions.GoodsDetailMain({itemcode: itemCode + ""});
        } else if (this.props.fromPage === 'ClassificationPage') {
            Actions.GoodsDetailMain({itemcode: itemCode + ""});
        }
    }

    render() {
        let {searchItem} = this.props;
        return (
            <PressTextColor
                onPress={() => this._jump(searchItem.item_code)}
                nativeRef={[{
                    ref: this.refs.groupbuy,
                    touchColor: Colors.text_light_grey
                }, {
                    ref: this.refs.presenter,
                    touchColor: Colors.text_light_grey
                }, {
                    ref: this.refs.trade,
                    touchColor: Colors.text_light_grey
                }]}
            >
                <View style={this.state.displayDirection === 'row' ? styles.rowContainers : styles.columnContainers}>
                    <Image style={this.state.displayDirection === 'row' ? styles.rowImg : styles.columnImg}
                           source={require('../Img/img_defaul_@3x.png')}/>
                    {searchItem.item_url?
                        <Image style={this.state.displayDirection === 'row' ? styles.inRowImg : styles.inColumnImg}
                               source={{uri: searchItem.item_url}}/>:null
                    }
                    {/*<ProductItemImg*/}
                        {/*imgStyle={this.state.displayDirection === 'row' ? styles.rowImg : styles.columnImg}*/}
                        {/*imgUrl={searchItem.item_url}*/}
                    {/*/>*/}
                    {
                        searchItem.groupbuy_yn === '1' &&//团购中
                        <View
                            style={this.state.displayDirection === 'row' ? styles.rowImgTitleBg : styles.columnImgTitleBg}>
                            <Image style={styles.groupImgBg} source={require('../Img/searchpage/icon_time_@3x.png')}/>
                            <Text
                                style={styles.pImgTitle} allowFontScaling={false}>团购中 {parseInt(this.state.times[2])}天{parseInt(this.state.times[3])}小时{parseInt(this.state.times[4])}分</Text>
                        </View>
                    }
                    <View style={this.state.displayDirection === 'row' ? styles.rowContentsView : styles.columnContentsView}>
                        {
                            searchItem.trade_yn === '1' ? //全球购
                                <View style={{flexDirection:'row'}}>
                                    <Image source={require('../Img/searchpage/Icon_globalbuy_tag_@2x.png')} style={styles.iconStyle}/>
                                    <Text allowFontScaling={false} ref="trade" numberOfLines={2} style={this.state.displayDirection === 'row' ? styles.groupTitleRow : styles.groupTitle}>              {searchItem.item_name}</Text>
                                </View>
                                :
                                searchItem.presenter_name !== null &&  searchItem.presenter_name !== ''? //主播推荐
                                    <View style={{flexDirection:'row'}}>
                                        <Image source={require('../Img/searchpage/Icon_anchorrecommend_tag_@2x.png')} style={styles.commendStyle}/>
                                        <Text allowFontScaling={false} ref="presenter" numberOfLines={2} style={this.state.displayDirection === 'row' ? styles.groupTitleRow : styles.groupTitle}>                 {searchItem.item_name}</Text>
                                    </View>

                                    :
                                    searchItem.groupbuy_yn === '1' ? //团购
                                        <View style={{flexDirection: 'row'}}>
                                            <Image source={require('../Img/searchpage/Icon_groupbuy_tag2_@2x.png')}
                                                   style={styles.iconStyle}/>
                                            <Text allowFontScaling={false} numberOfLines={2}
                                                  style={this.state.displayDirection === 'row' ? styles.groupTitleRow : styles.groupTitle}>           {searchItem.item_name}</Text>
                                        </View>
                                        :
                                        <Text allowFontScaling={false} ref="groupbuy" numberOfLines={2} style={this.state.displayDirection === 'row' ? styles.groupTitleRow : styles.groupTitle}>{searchItem.item_name}</Text>

                        }
                        {
                            this.state.displayDirection === 'column' && searchItem.gift_yn === '1' ?//赠品显示
                                <View style={{flexDirection: 'row'}}>
                                    <Image source={require('../Img/searchpage/Icon_gifts_@2x.png')}
                                           style={styles.giftStyle}/>
                                    <Text allowFontScaling={false} numberOfLines={1} style={styles.giftText}>{searchItem.gift_item}</Text>
                                </View>
                                :
                                null
                        }

                        <View style={styles.priceView}>
                            <View style={{flexDirection: 'row', justifyContent: 'flex-end'}}>
                                {
                                    searchItem.last_sale_price ?
                                        <Text allowFontScaling={false} style={styles.moneyStyle}>￥</Text>
                                        :
                                        null
                                }
                                {
                                    searchItem.last_sale_price ?
                                        <Text allowFontScaling={false} style={styles.priceStyle}>{String(searchItem.last_sale_price)}</Text>
                                        :
                                        null
                                }

                                {
                                    //积分显示
                                    searchItem.saveamt !== null && Number(searchItem.saveamt) != 0 ?
                                        <Image source={require('../Img/searchpage/Icon_accumulate_@2x.png')}
                                               style={styles.accumImg}/>
                                        :
                                        null
                                }
                                {
                                    searchItem.saveamt !== null && Number(searchItem.saveamt) != 0 ?
                                        <Text allowFontScaling={false} style={styles.saveamtStyle}>{String(Number(searchItem.saveamt))}</Text>
                                        :
                                        null
                                }

                            </View>
                            {
                                this.state.displayDirection === 'row' && searchItem.gift_yn === '1' ?//赠品显示
                                    <Image source={require('../Img/searchpage/Icon_gifts_@2x.png')}
                                           style={styles.giftStyle}/>
                                    :
                                    null
                            }

                        </View>

                        {
                            searchItem.three_month_saleqty !== undefined && searchItem.three_month_saleqty !== null ?
                                <View style={styles.buyCountView}>
                                    <Text allowFontScaling={false} style={styles.buyCountStyle}>
                                        {Number(searchItem.three_month_saleqty)>0?String(searchItem.three_month_saleqty) + '人已经购买':''}</Text>
                                    {/*库存*/}
                                    <Text
                                        style={styles.stockIsTight} allowFontScaling={false}>{searchItem.stock_qty ? this.getStockStatus(parseInt(searchItem.stock_qty)) : ''}</Text>
                                </View> :
                                <View style={{alignItems: 'flex-end'}}>
                                    {/*库存*/}
                                    <Text
                                        style={styles.stockIsTight} allowFontScaling={false}>{searchItem.stock_qty ? this.getStockStatus(parseInt(searchItem.stock_qty)) : ''}</Text>
                                </View>
                        }
                    </View>
                </View>
            </PressTextColor>
        )

    }

    getStockStatus(stockNum) {
        if (stockNum > 20) {
            return '';
        } else if (stockNum >= 10) {
            return '库存紧张';
        } else if (stockNum > 0) {
            return '仅剩余' + stockNum + '件';
        } else {
            return '';
        }
    }

}

SearchItem.propTypes = {
    searchItem: React.PropTypes.object.isRequired,
    displayDirection: React.PropTypes.string.isRequired,

};

SearchItem.defaultProps = {};


const styles = StyleSheet.create({
    //一行两个
    rowContainers: {
        backgroundColor: Colors.background_white,
        padding: ScreenUtil.scaleSize(10),
        flexDirection: 'column',
        borderRightWidth: ScreenUtil.scaleSize(1),
        borderBottomWidth: ScreenUtil.scaleSize(1),
        borderRightColor: Colors.line_grey,
        borderBottomColor: Colors.line_grey,
        justifyContent: 'flex-start',
        width: ScreenUtil.screenW / 2,
    },
    //一行一个
    columnContainers: {
        backgroundColor: Colors.background_white,
        paddingRight: ScreenUtil.scaleSize(20),
        paddingLeft: ScreenUtil.scaleSize(30),
        flexDirection: 'row',
        // borderWidth: 1,
        // borderColor: Colors.line_grey,
        justifyContent: 'flex-start',
    },

    rowImg: {
        width: ScreenUtil.screenW / 2 - ScreenUtil.scaleSize(20),
        height: ScreenUtil.scaleSize(320),
    },

    columnImg: {
        width: ScreenUtil.scaleSize(240),
        height: ScreenUtil.scaleSize(240),
        marginTop: ScreenUtil.scaleSize(20),
        marginBottom: ScreenUtil.scaleSize(20),
    },
    inRowImg: {
        width: ScreenUtil.screenW / 2 - ScreenUtil.scaleSize(20),
        height: ScreenUtil.scaleSize(320),
        position:'absolute',
        left:ScreenUtil.scaleSize(10),
        top:ScreenUtil.scaleSize(10),
    },

    inColumnImg: {
        width: ScreenUtil.scaleSize(240),
        height: ScreenUtil.scaleSize(240),
        marginTop: ScreenUtil.scaleSize(20),
        marginBottom: ScreenUtil.scaleSize(20),
        position:'absolute',
        left:ScreenUtil.scaleSize(30),
        top:0,
    },
    rowImgTitleBg: {
        backgroundColor: "rgba(229,41,13,0.7)",
        paddingTop: ScreenUtil.scaleSize(10),
        paddingBottom: ScreenUtil.scaleSize(10),
        flexDirection: 'row',
        justifyContent: 'center',
        width: ScreenUtil.screenW / 2 - ScreenUtil.scaleSize(40),
        height: ScreenUtil.scaleSize(46),
        position: 'absolute',
        left: ScreenUtil.scaleSize(10),
        top: ScreenUtil.scaleSize(300),
        zIndex: 10,
        //resizeMode: 'cover',
        alignItems: 'center',
    },
    columnImgTitleBg: {
        width: ScreenUtil.scaleSize(240),
        height: ScreenUtil.scaleSize(36),
        backgroundColor: "rgba(229,41,13,0.7)",
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        position: 'absolute',
        left: ScreenUtil.scaleSize(30),
        bottom: ScreenUtil.scaleSize(20),
        zIndex: 10,
        //resizeMode: 'cover',
    },

    groupImgBg: {
        width: ScreenUtil.scaleSize(20),
        height: ScreenUtil.scaleSize(20),
        marginRight: ScreenUtil.scaleSize(4),

    },

    pImgTitle: {
        color: Colors.text_white,
        fontSize: ScreenUtil.setSpText(20),
    },
    rowContentsView: {
        flexDirection: 'column',
        flex: 1,
        justifyContent: 'space-between',
        marginTop: 5
    },
    columnContentsView: {
        flexDirection: 'column',
        flex: 1,
        justifyContent: 'space-between',
        paddingLeft: ScreenUtil.scaleSize(30),
        borderBottomWidth: ScreenUtil.scaleSize(1),
        borderBottomColor: '#dddddd',
        height: ScreenUtil.scaleSize(275),
        paddingVertical: ScreenUtil.scaleSize(14)
    },
    groupTitle: {
        color: Colors.text_black,
        fontSize: ScreenUtil.setSpText(28),
        lineHeight: parseInt(ScreenUtil.scaleSize(44)),
    },
    groupTitleRow: {
        color: Colors.text_black,
        fontSize: ScreenUtil.setSpText(28),
        height: ScreenUtil.scaleSize(80),
        lineHeight: parseInt(ScreenUtil.scaleSize(44))
    },
    priceView: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginTop: ScreenUtil.scaleSize(10),
    },
    moneyStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(24),
        textAlignVertical: "bottom"
    },
    priceStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(36),
        marginRight: ScreenUtil.setSpText(10),
        marginTop: ScreenUtil.setSpText(2) * -1,
        textAlignVertical: "bottom",
    },
    originalPriceStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtil.setSpText(24),
        textDecorationLine: 'line-through',
        //textAlign:'center',
        textAlignVertical: 'center',
    },
    stockIsTight: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(20),
        textAlignVertical: 'center',
    },
    buyCountView: {
        justifyContent: 'space-between',
        flexDirection: 'row',
        height: ScreenUtil.scaleSize(40),
    },
    buyCountStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtil.setSpText(24),
    },
    iconStyle: {
        width: ScreenUtil.scaleSize(70),
        height: ScreenUtil.scaleSize(32),
        position: 'absolute',
        left: 0,
        top: ScreenUtil.scaleSize(8),
        zIndex: 11,
        borderRadius: 0,
        resizeMode: 'contain',
    },
    commendStyle: {
        width: ScreenUtil.scaleSize(110),
        height: ScreenUtil.scaleSize(40),
        position: 'absolute',
        left: 0,
        top: ScreenUtil.scaleSize(4),
        zIndex: 11,
        borderRadius: ScreenUtil.scaleSize(0),
        resizeMode: 'contain',
    },
    giftsIconStyle: {
        width: ScreenUtil.scaleSize(50),
        height: ScreenUtil.scaleSize(60),
    },
    giftText: {
        width: ScreenUtil.scaleSize(300),
        fontSize: ScreenUtil.setSpText(24),
        color: Colors.text_dark_grey,
        marginLeft: ScreenUtil.scaleSize(10),
    },
    giftStyle: {
        width: ScreenUtil.scaleSize(60),
        height: ScreenUtil.scaleSize(26),
        borderRadius: 5,
        marginTop: ScreenUtil.scaleSize(4),
    },
    saveamtStyle: {
        color: '#FA6923',
        fontSize: ScreenUtil.setSpText(24),
        marginTop: ScreenUtil.scaleSize(4),
        height: ScreenUtil.scaleSize(36),
        textAlignVertical: "bottom"
    },

    accumImg:{
        width:ScreenUtil.scaleSize(32),
        height:ScreenUtil.scaleSize(32),
        marginTop:ScreenUtil.scaleSize(4),
        marginRight:ScreenUtil.scaleSize(10),
    },
    integralStyle: {
        backgroundColor: '#FFC033',
        color: '#FEFEFE',
        paddingLeft: ScreenUtil.scaleSize(6),
        marginTop: ScreenUtil.scaleSize(4),
        paddingRight: ScreenUtil.scaleSize(6),
        height: ScreenUtil.scaleSize(36),
        textAlign: 'center',
        marginRight: ScreenUtil.scaleSize(10),
        textAlignVertical: 'center',
        paddingBottom: ScreenUtil.scaleSize(6),
    },
});
