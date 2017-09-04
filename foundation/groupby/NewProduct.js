/**
 * Created by lu weiguo on 2017/6月4号.
 * 今日团购页面导航栏组件
 */
'use strict';
import React, {
    PureComponent,
} from 'react'
import {
    View,
    Text,
    Dimensions,
    StyleSheet,
    FlatList,
    TouchableOpacity,
    Image,
} from 'react-native'
let deviceWidth = Dimensions.get('window').width;
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
// 引入外部组件
import NewProductItem from './NewProductItem';
let key = 1;
export default class NewProduct extends PureComponent {

    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            showBackTop: false,
            showAll: false,
    };
        this.dataSource = [];
    }

    render() {
        //提取前八个商品信息
        if(!this.state.showAll&&this.props.dataSource&&this.props.dataSource.length>8){
            this.dataSource = this.props.dataSource.slice(0,8);
        }else {
            this.dataSource = this.props.dataSource;
        }
        return (
            <View style={styles.NewProductWeb}>
                <View style={styles.NewProductStyle}>
                    <FlatList
                        style={{flex: 1}}
                        horizontal={false}
                        numColumns={2}
                        initialNumToRender={6}
                        data={this.dataSource}
                        renderItem={({item}) => this._renderProduct(item)}
                        ListFooterComponent={() => this._goodsTip()}
                        onEndReachedThreshold={0.1}
                        onEndReached={() => this.props.onEndReached()}
                        getItemLayout={(data, index) => ( {length: ScreenUtils.scaleSize(496), offset: ScreenUtils.scaleSize(496) * index, index} )}
                        onScroll={(e) => this.onScroll(e)}
                        ref="ScrollView"
                        scrollEventThrottle={10}
                    />
                </View>
                {
                    this.state.showBackTop && this.props.canShowBackTopBtn ?
                        <TouchableOpacity ref='backTopView'
                                          style={styles.backTopView}
                                          activeOpacity={1}
                                          onPress={() => {
                                              this.refs.ScrollView && this.refs.ScrollView.scrollToOffset({y: 0})
                                          }}>
                            <Image style={styles.backTopImg}
                                   source={require('../../foundation/Img/channel/classification_channel_icon_back_top.png')}>
                            </Image>
                        </TouchableOpacity>
                        :
                        null
                }
            </View>
        )
    }

    onScroll(e) {
        this.setState({
            showAll: true,
        });
        if (!this.props.canShowBackTopBtn) {
            return;
        }

        let y = e.nativeEvent.contentOffset.y;
        if (y > ScreenUtils.screenH - ScreenUtils.scaleSize(400)) {
            this.setState({
                showBackTop: true,
            })
        } else {
            this.setState({
                showBackTop: false,
            })
        }
    }

    _goodsTip() {
        if (this.props.noGoodsTip) {
            return (
                <View style={{
                    justifyContent: 'center',
                    alignItems: 'center',
                    marginTop: ScreenUtils.scaleSize(20),
                    paddingBottom:ScreenUtils.scaleSize(20)
                }}>
                    <Text style={{color: Colors.text_dark_grey}}>没有更多商品了</Text>
                </View>
            )
        } else {
            return null
        }
    }

    //   返回 NewProductItem 组件
    _renderProduct(item) {
        return (
            <NewProductItem
                codeValue={this.props.codeValue}
                pageVersionName={this.props.pageVersionName}
                dataSource={item}/>
        )

    }


}
const styles = StyleSheet.create({
    NewProductWeb: {
        width: deviceWidth,
        flex: 1
    },
    NewProductHead: {
        flexDirection: "row",
        width: deviceWidth,
        height: ScreenUtils.scaleSize(100),
        justifyContent: "center",
        alignItems: 'center',
        backgroundColor: Colors.text_white
    },
    newTimeGoods: {
        color: "#ED1C41",
        fontSize: ScreenUtils.scaleSize(30),
        marginRight: ScreenUtils.scaleSize(20),
        marginLeft: ScreenUtils.scaleSize(20)
    },
    NewProductStyle: {
        backgroundColor: Colors.text_white,
        borderTopColor: Colors.background_grey,
        borderTopWidth: 1,
        flexDirection: "row",
        flexWrap: 'wrap',
        flex: 1
    },
    NewProductItem: {
        width: deviceWidth / 2,
        padding: ScreenUtils.scaleSize(10),
        borderRightWidth: 1,
        borderRightColor: Colors.background_grey,
    },
    NewProductBox: {
        flex: 1,
        width: ScreenUtils.scaleSize(355),
        height: ScreenUtils.scaleSize(355),
    },
    NewProductItemImg: {
        width: ScreenUtils.scaleSize(355),
        height: ScreenUtils.scaleSize(355),
    },
    NewProductName: {
        fontSize: ScreenUtils.setSpText(26),
        color: Colors.text_black,
        paddingTop: ScreenUtils.scaleSize(5),
        paddingBottom: ScreenUtils.scaleSize(5)
    },
    discountStyle: {
        width: ScreenUtils.scaleSize(70),
        height: ScreenUtils.scaleSize(70),
        backgroundColor: Colors.main_color,
        justifyContent: "center",
        alignItems: "center",
        position: "absolute",
        top: 0,
    },
    discountNum: {
        fontSize: ScreenUtils.setSpText(26),
        color: Colors.text_white,
    },
    discountNumStyle: {
        fontSize: ScreenUtils.scaleSize(20),
        color: Colors.text_white,
    },
    bottomLayer: {
        width: ScreenUtils.scaleSize(355),
        height: ScreenUtils.scaleSize(40),
        backgroundColor: Colors.main_color,
        opacity: 0.6,
        justifyContent: "center",
        position: "absolute",
        bottom: 0,
        zIndex: 10
    },
    remainingTime: {
        height: ScreenUtils.scaleSize(40),
        flexDirection: "row",
        position: "absolute",
        bottom: 0,
        alignItems: "center",
        zIndex: 20,
        justifyContent: "center",
        left: 0,
        right: 0
    },
    countdown: {
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(20),
        backgroundColor: "transparent",
    },
    donation: {
        width: ScreenUtils.scaleSize(44),
        height: ScreenUtils.scaleSize(30),
    },
    accumulateIcon: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
        marginLeft: ScreenUtils.scaleSize(10)
    },
    todayPriceBox: {
        justifyContent: "space-between",
        flexDirection: "row",
        alignItems: "center",
    },
    todayPrice: {
        flexDirection: "row",
        alignItems: "center",
        marginLeft: ScreenUtils.scaleSize(6)
    },
    redColor: {
        color: Colors.main_color
    },
    priceSymbol: {
        //    alignSelf:"flex-end"
        alignSelf: "center",
    },
    currentPrice: {
        fontSize: ScreenUtils.scaleSize(36),
        marginLeft: ScreenUtils.scaleSize(0)
    },
    accumulateNum: {
        marginLeft: ScreenUtils.scaleSize(6)
    },
    inventoryBox: {
        flexDirection: "row",
        justifyContent: "space-between",
        marginTop: ScreenUtils.scaleSize(5)
    },
    inventoryNum: {
        fontSize: ScreenUtils.setSpText(22),
        color: Colors.text_dark_grey
    },
    inventoryInfo: {
        fontSize: ScreenUtils.setSpText(22),
        color: Colors.magenta
    },
    backTopView: {
        position: 'absolute',
        top: ScreenUtils.screenH - ScreenUtils.scaleSize(500),
        left: ScreenUtils.screenW - ScreenUtils.scaleSize(120),
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
    },
    backTopImg: {
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
    },
});