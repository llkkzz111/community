/**
 * Created by YASIN on 2017/5/29.
 * 热销listview
 */
import React, {PropTypes}from 'react';
import {
    View,
    Text,
    FlatList,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import Datas from './Datas';
var key = 0;
export default class HotListView extends React.Component {
    static propTypes = {
        datas: PropTypes.array.isRequired,
        onRefresh: PropTypes.func,
        onLoadMore: PropTypes.func,
        refreshing: PropTypes.bool,
        onItemClick: PropTypes.func
    }
    // 构造
    constructor(props) {
        super(props);
        this._keyExtractor = (item, index) => index;
        this.scroll = false;
    }

    render() {
        return (
            <FlatList
                data={this.props.datas}
                renderItem={this._renderItem.bind(this)}
                refreshing={this.props.refreshing}
                onRefresh={this.props.onRefresh}
                overScrollMode={'never'}
                keyExtractor={this._keyExtractor}
                onScroll={this._onScroll.bind(this)}
            />
        );
    }

    /**
     * scrollview滑动的时候
     * @private
     */
    _onScroll(event) {
        let y = event.nativeEvent.contentOffset.y;
        let height = event.nativeEvent.layoutMeasurement.height;
        let contentHeight = event.nativeEvent.contentSize.height;
        if (contentHeight > height && (y + height >= contentHeight - 20)) {
            //如果满足上啦条件，并且上一次子内容高度=这一次子内容高度说明没有数据了～
            if (this.originContentHeight === contentHeight) {
                return;
            }
            this.originContentHeight = contentHeight;
            this.props.onLoadMore();
        }
    }

    initContentHeight() {
        this.originContentHeight = -1;
    }

    _renderItem({item, index}) {
        //赠品view
        let descView = null;
        if (item.gifts && item.gifts.length > 0) {
            let gift = item.gifts[0];
            descView = (
                <View style={styles.descContainer}>
                    <Image
                        source={require('../../../../foundation/Img/home/hotsale/Icon_gifts_.png')}
                        style={styles.descIcon}
                        stretch={'stretch'}
                    />
                    <Text allowFontScaling={false}
                        style={styles.descTextStyle}
                        numberOfLines={1}
                    >
                        {gift}
                    </Text>
                </View>
            );
        }
        return (
            <TouchableOpacity
                activeOpacity={0.8}
                key={index}
                onPress={()=> {
                    this.props.onItemClick(index)
                }}
            >
                <View style={styles.itemContainer}>
                    <View style={styles.itemIconContainer}>
                        <Image
                            source={{uri: item.firstImgUrl === null ? '' : item.firstImgUrl}}
                            style={styles.itemIconContainer}
                        />
                    </View>
                    <View style={styles.itemRightContainer}>
                        <View style={{alignSelf:'stretch',marginRight:ScreenUtils.scaleSize(10)}}>
                            <Text allowFontScaling={false} style={styles.itemTitleStyle}>
                                {/*主播推荐icon先隐藏*/}
                                {/*<Image*/}
                                {/*source={require('../../../../foundation/Img/home/hotsale/Icon_anchorrecommend_tag_@3x.png')}*/}
                                {/*style={styles.indicatorStyle_anchorrecommend}*/}
                                {/*resizeMode={'stretch'}*/}
                                {/*/>*/}
                                <Text allowFontScaling={false}> {item.title}</Text>
                            </Text>
                            {/*赠品view*/}
                            {descView}
                        </View>
                        <View>
                            <View style={styles.priceContainer}>
                                <Text allowFontScaling={false} style={styles.priceTextStyle}>
                                    <Text allowFontScaling={false} style={styles.priceTextType}>¥</Text>
                                    {item.salePrice}
                                </Text>
                                {(item.integral && parseFloat(item.integral) !== 0) ? (
                                    <View style={{flexDirection: 'row',alignItems:'center'}}>
                                        <Image
                                            style={styles.integralIconStyle}
                                            source={require('../../../../foundation/Img/home/hotsale/Icon_accumulate_.png')}
                                            resizeMode={'stretch'}
                                        />
                                        <Text allowFontScaling={false} style={styles.integralTextStyle}>{item.integral}</Text>
                                    </View>
                                ) : null}
                            </View>
                            {/*{(item.salesVolume&&parseInt(item.salesVolume)!==0)?(*/}
                                {/*<Text style={styles.itemCountTyle}>{item.salesVolume} 人已购买</Text>*/}
                            {/*):null}*/}
                        </View>
                    </View>
                    {(Datas.topIcons.length > index) ? (
                        <Image
                            source={Datas.topIcons[index].icon}
                            style={styles.itemIconTopStyle}
                        />
                    ) : (
                        <Image
                            style={styles.itemIconTopStyle2}
                            source={require('../../../../foundation/Img/home/hotsale/icon_hotsale_numberbg_.png')}
                        >
                            <Text allowFontScaling={false} style={{color:Colors.text_white,fontSize:ScreenUtils.scaleSize(20),backgroundColor:'transparent'}}>{index+1}</Text>
                        </Image>
                    )}
                </View>
            </TouchableOpacity>
        );
    }
}
const styles = StyleSheet.create({
    itemContainer: {
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        alignSelf: 'stretch',
        paddingTop: ScreenUtils.scaleSize(20),
        paddingLeft: ScreenUtils.scaleSize(20),
        width: ScreenUtils.screenW
    },
    itemIconTopStyle: {
        position: 'absolute',
        top: ScreenUtils.scaleSize(10),
        left: ScreenUtils.scaleSize(10)
    },
    itemIconContainer: {
        width: ScreenUtils.scaleSize(238),
        height: ScreenUtils.scaleSize(240),
        marginBottom: ScreenUtils.scaleSize(20),
    },
    itemRightContainer: {
        flex: 1,
        justifyContent: 'space-between',
        alignSelf: 'stretch',
        paddingLeft: ScreenUtils.scaleSize(10),
        paddingBottom: ScreenUtils.scaleSize(20),
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor: Colors.background_grey

    },
    itemTitleStyle: {
        fontSize: ScreenUtils.setSpText(28),
        color: Colors.text_black,
        alignSelf: 'stretch',
    },
    itemCountTyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(20),
        marginTop: ScreenUtils.scaleSize(4),
    },
    descContainer: {
        flexDirection: 'row',
        marginTop: ScreenUtils.scaleSize(6),
        alignItems: 'center'
    },
    descIcon: {
        width: ScreenUtils.scaleSize(56),
        height: ScreenUtils.scaleSize(30)
    },
    descTextStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(25),
        marginLeft: ScreenUtils.scaleSize(5),
        flex: 1,
    },
    priceContainer: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    priceTextStyle: {
        fontSize: ScreenUtils.setSpText(36),
        color: Colors.hotsale_price
    },
    priceTextType: {
        fontSize: ScreenUtils.setSpText(24),
        color: Colors.hotsale_price,
    },
    integralIconStyle: {
        width: ScreenUtils.scaleSize(28),
        height: ScreenUtils.scaleSize(28),
        marginLeft: ScreenUtils.scaleSize(8)
    },
    integralTextStyle: {
        fontSize: ScreenUtils.setSpText(26),
        color: Colors.hotsale_inter,
        marginLeft: ScreenUtils.scaleSize(8)
    },
    indicatorStyle_anchorrecommend: {
        ...Platform.select({
            android: {
                height: 110 * ScreenUtils.pixelRatio / 2,
                width: 26 * ScreenUtils.pixelRatio / 2
            },
        }),
    },
    itemIconTopStyle2:{
        width:ScreenUtils.scaleSize(40),
        height:ScreenUtils.scaleSize(40),
        resizeMode:'stretch',
        justifyContent:'center',
        alignItems:'center',
        position: 'absolute',
        top: ScreenUtils.scaleSize(10),
        left: ScreenUtils.scaleSize(10)
    }
});