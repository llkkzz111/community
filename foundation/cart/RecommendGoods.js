/**
 * Created by Administrator on 2017/5/11.
 * Update by Wjj on 2017/5/14.
 */
import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
    FlatList,
} from 'react-native';
//自适应
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
import {Actions} from 'react-native-router-flux'
import PressTextColor from 'FOUNDATION/pressTextColor';
import Colors from '../../app/config/colors';
let Dimensions = require('Dimensions');
let screenWidth = Dimensions.get('window').width;

export default class RecommendGoods extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            dataSource: [],
        }
    }

    //初始化数据源
    componentWillMount() {
        this.setState({
            dataSource: this.props.dataSource,
        });
    }

    //数据源变化
    componentWillReceiveProps(nextProps) {
        this.setState({
            dataSource: nextProps.dataSource,
        });
    }

    render() {
        return (
            <View>
                <View style={styles.recommendForYouStyle} allowFontScaling={false}>
                    <Text style={styles.recommendForYouTextStyle} allowFontScaling={false}>· 为您推荐 ·</Text>
                </View>
                <FlatList
                    data={this.state.dataSource}
                    contentContainerStyle={styles.allGoodsStyle}
                    renderItem={this.renderItem}>
                </FlatList>
            </View>
        )
    }

    renderItem = ({item}) => (
        <RecommendGoodsItem arrayValue={item}/>
    );
}

//item抽离列表
class RecommendGoodsItem extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            data: [],
        }
    }

    componentWillMount() {
        this.setState({
            data: this.props.arrayValue,
        })
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            data: nextProps.arrayValue,
        })
    }

    render() {
        return (
            <View style={styles.recommendGoodsStyle}>
                <PressTextColor
                    onPress={() => {Actions.GoodsDetailMain({itemcode: this.state.data.ITEM_CODE,})}}
                    nativeRef={[{
                        prop: this.refs.titleText,
                        touchColor: Colors.text_light_grey
                    }]}
                >
                    <Image source={{uri: this.state.data.url}} style={styles.productImgStyle}/>
                    {this.state.data.dc !== "" && this.state.data.dc !== "0" && <View style={styles.discountStyle}>
                        <Text style={styles.discountTextStyle} allowFontScaling={false}>{String(this.state.data.dc)}折</Text>
                    </View>}
                    <View style={styles.productNameStyle}>
                        <Text ref="titleText" style={styles.productNameTextStyle} numberOfLines={2} allowFontScaling={false}>{this.state.data.ITEM_NAME}</Text>
                    </View>
                    <View style={styles.priceStyle}>
                        <View style={styles.originPriceViewStyle}>
                            <Text style={styles.priceTextStyle} allowFontScaling={false}>¥{String(this.state.data.SALE_PRICE)}</Text>
                        </View>
                        <Text style={styles.saleQtyStyle} allowFontScaling={false}>{String(this.state.data.SALES_VOLUME)} 件已售</Text>
                    </View>
                </PressTextColor>
            </View>
        );
    }
}


const styles = StyleSheet.create({
    recommendForYouStyle: {
        backgroundColor: "#FFFFFF",
        justifyContent: "center",
        alignItems: 'center',
        height: ScreenUtils.scaleSize(100),
        paddingVertical:ScreenUtils.scaleSize(30),
        borderBottomWidth:1,
        borderColor:'#DDDDDD'
    },
    recommendForYouTextStyle: {
        color: '#ED1C41',
        fontSize: ScreenUtils.setSpText(30),
    },
    allGoodsStyle: {
        backgroundColor: "#FFFFFF",
        flexDirection: 'row',
        flexWrap: 'wrap',
        justifyContent: 'space-between',
        paddingBottom:ScreenUtils.scaleSize(15)
    },
    recommendGoodsStyle: {
        backgroundColor: "#FFFFFF",
        flexDirection: 'column',
        width: (screenWidth) / 2,
        height: ScreenUtils.scaleSize(490),
        paddingTop:ScreenUtils.scaleSize(10),
        paddingLeft:ScreenUtils.scaleSize(10),
        paddingBottom:ScreenUtils.scaleSize(10),
        borderRightWidth:1,
        borderColor:'#DDDDDD',
    },
    productImgStyle: {
        width: (screenWidth-40) / 2,
        height: ScreenUtils.scaleSize(320),
    },

    discountStyle: {
        backgroundColor: '#ED1C41',
        width: 40,
        height: 40,
        position: 'absolute',
        left: 0,
        top: 0,
        zIndex: 10,
    },
    discountTextStyle: {
        color: '#FFFFFF',
        textAlign: 'center',
        paddingTop: 10,
        fontSize: ScreenUtils.setSpText(26),
    },
    productNameStyle: {
        padding: 5,
        height: 50
    },

    priceStyle: {
        flexDirection: 'row',
        alignItems: 'flex-start',
        justifyContent: 'space-between',
        width: (screenWidth - 20) / 2,
    },
    originPriceViewStyle: {
        flexDirection: 'row',
    },
    priceViewStyle: {
        flexDirection: 'row',
    },
    productNameTextStyle: {
        color: '#333333',
        fontSize: ScreenUtils.setSpText(26),
        flexWrap: "wrap",
    },
    priceTextStyle: {
        color: '#E5290D',
        fontSize: ScreenUtils.setSpText(36),
    },
    originPriceStyle: {
        color: '#999999',
        fontSize: ScreenUtils.setSpText(22),
        textDecorationLine: 'line-through',
        marginLeft: 5,
        paddingTop: 5
    },

    saleQtyStyle: {
        color: '#666666',
        fontSize: ScreenUtils.setSpText(22),
        paddingTop: 5,
    },
});
