/**
 * Created by xiongmeng on 2017/5/1.
 * 空购物车
 */
import React, { PureComponent } from 'react';
import {
    StyleSheet,
    View,
    Text,
    Image,
    ScrollView,
    Dimensions,
    Platform,
} from 'react-native';
import {Actions} from 'react-native-router-flux';
import RecommendGoods from "FOUNDATION/cart/RecommendGoods";
import * as ScreenUtils from 'FOUNDATION/utils/ScreenUtil'
import * as LocalStorage from 'FOUNDATION/LocalStorage';
import Colors from 'CONFIG/colors';
import * as RouteManager from 'CONFIG/PlatformRouteManager';
import * as routeConfig from 'CONFIG/routeConfig';

const {width} = Dimensions.get('window');

class CartPage extends PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            recommendData: [],
        };
    }
    //初始化数据源
    componentWillMount() {
        this.setState({
            recommendData: this.props.recommendData,
        });
    }
    //数据源变化
    componentWillReceiveProps(nextProps) {
        this.setState({
            recommendData: nextProps.recommendData,
        });
    }
    render() {
        return (
            <ScrollView>
                <View style={styles.noCartStyle}>
                    <Image source={require('IMG/cart/cartPage.png')}
                           style={styles.imgCenterStyle}
                           resizeMode={'contain'}
                    />
                    <Text style={styles.noCartText} allowFontScaling={false}>您的购物车可用容量5吨</Text>
                    <Text style={styles.noCartText2} allowFontScaling={false}>已用为0哦</Text>
                    <View style={styles.buttons}>
                        <Text onPress={this._renderBackHome.bind(this)} style={styles.beginToShopping}
                              allowFontScaling={false}>开始购物 ></Text>
                    </View>
                </View>
                <View style={styles.formLineContainer}>
                    <RecommendGoods dataSource={this.state.recommendData}/>
                </View>
                <View style={styles.footerView}>
                    <View style={styles.noMoreView}>
                        <Image source={require('IMG/cart/img_nomore_3x.png')} style={{
                            height: ScreenUtils.scaleSize(106),
                            width: ScreenUtils.scaleSize(180)
                        }}/>
                    </View>
                </View>
            </ScrollView>
        )
    }
    /**
     * 空购物车 开始购物返回首页刷新
     * @private
     */
    _renderBackHome() {
        if (Platform.OS === 'android' && this.props.showLeft) {
            Actions.pop();
        }
        RouteManager.resetToHome();
    }
}

export default CartPage

let styles = StyleSheet.create({
    footerView: {
        flexDirection: 'row',
        height: ScreenUtils.scaleSize(166),
        backgroundColor: '#ededed',
        alignItems: 'center',
        justifyContent: 'center'
    },
    noCartText: {
        color: '#333333',
        fontSize: ScreenUtils.setSpText(32),
        marginTop: ScreenUtils.scaleSize(20)
    },
    emptyView: {
        width: width - 20,
        borderColor: "#CCCCCC",
        height: 1,
        borderTopWidth: ScreenUtils.scaleSize(3)
    },
    noMoreView: {
        alignItems: 'center',
        justifyContent: 'center',
        marginTop: ScreenUtils.scaleSize(30),
        marginBottom: ScreenUtils.scaleSize(30),
    },
    noMoreText: {
        color: "#666666",
        fontSize: ScreenUtils.setSpText(28),
    },
    beginToShopping: {
        color: "#D60707",
        fontSize: ScreenUtils.setSpText(28),
        marginTop: ScreenUtils.scaleSize(51),
        marginBottom: ScreenUtils.scaleSize(100)
    },
    imgCenterStyle: {
        width: ScreenUtils.setSpText(440),
        height: ScreenUtils.setSpText(280),
        borderRadius: 8,
    },
    container: {
        flex: 1,
        backgroundColor: Colors.background_white,
    },
    noCartText2: {
        color: "#999999",
        fontSize: ScreenUtils.setSpText(26),
        marginTop: ScreenUtils.scaleSize(20),
    },
    noCartStyle: {
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#ededed',
        height: ScreenUtils.scaleSize(611),
    },
    backImage: {
        position: 'absolute',
        top: Platform.OS === 'android' ? -54 : -64,
        left: 0,
        right: 0,
        bottom: 0,
        width: Dimensions.get('window').width,
        height: Platform.OS === 'android' ? Dimensions.get('window').height + 54 : Dimensions.get('window').height + 64
    },
    formLineContainer: {
        backgroundColor: '#FFFFFF',
    },
})
