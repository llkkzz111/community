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
    Platform,
    DeviceEventEmitter,
} from 'react-native';
import {Actions} from 'react-native-router-flux';
import Colors from '../../config/colors';
// 倒入 收藏夹删除组件
import FavoriteItem from '../../../foundation/me/FavoriteItem';
// 适屏
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
// 引入获取收藏商品 URL 请求
import UserFavoriteRequest from '../../../foundation/net/mine/UserFavoriteRequest';
import EmptyFavorite from '../../../foundation/me/EmptyFavorite';
// 导航栏
import NavigationBar from '../../../foundation/common/NavigationBar';
import Toast, {DURATION} from 'react-native-easy-toast';
import {DataAnalyticsModule} from '../../config/AndroidModules';
import Notification from '../../constants/NotificationCenterInfo';

export default class FavoritePage extends Component {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            tabState: 0,
            userFavorite: {},
            totalCnt: 0
        };
    }

    render() {
        return (
            <View style={styles.container}>
                {this._renderFavoriteTitle()}
                <View style={{flex: 1}}>
                    {this._isEmpty(this.state.totalCnt)}
                </View>
                <Toast ref="toast"/>
            </View>
        )
    }

    /**
     *
     */
    _isEmpty(myFavoriteListSize) {
        if (myFavoriteListSize !== 0) {
            return (
                <FavoriteItem
                    userFavorite={this.state.userFavorite}
                    deleteSuccessCallBack={() => {
                        this._favoriteItem();
                    }}
                />
            )
        } else {
            return (
                <EmptyFavorite />
            )
        }
    }

    /**
     * 自定义导航
     * @returns {XML}
     * @private
     */
    _renderFavoriteTitle() {
        return (
            <NavigationBar
                /*onLeftPress={() =>{
                 DeviceEventEmitter.emit('refreshCartData', '刷新个人中心');
                 Actions.pop();
                 }}*/
                renderTitle={() => {
                    return (
                        <Text
                            allowFontScaling={false}
                            style={{
                                fontSize: ScreenUtils.setSpText(34),
                                color: Colors.text_black
                            }}
                        >收藏夹({this.state.totalCnt})</Text>
                    )
                }}
                barStyle={'dark-content'}
                navigationStyle={{
                    ...Platform.select({ios: {marginTop: -22}}),
                    height: ScreenUtils.scaleSize(128)
                }}
                onLeftPress={() => {
                    DataAnalyticsModule.trackEvent('AP1706C046D003001C003001');
                    Actions.pop();
                }}
            />
        );
    }

    /**
     *  请求收藏商品数据
     *
     */
    componentDidMount() {
        this._favoriteItem();
        DeviceEventEmitter.addListener(Notification.REFRESH_COLLECT_GOODS,(param) => this._favoriteItem(param.showLoading));
    }

    /**
     * 请求方法
     * @private
     */
    _favoriteItem(showLoading) {
        let self = this;
        if (this.UserFavoriteRequest) {
            this.UserFavoriteRequest.setCancled(true);
        }
        this.UserFavoriteRequest = new UserFavoriteRequest({page: 1}, 'GET');
        if (showLoading !== false) {
            this.UserFavoriteRequest.showLoadingView().start(
                (response) => {
                    // console.log(response)
                    if (response.data && response.data.myFavoriteList) {
                        self.setState({
                            userFavorite: response.data.myFavoriteList,
                            totalCnt: String(response.data.totalCnt - response.data.totalCnt_unable),
                        });
                    }
                }, (erro) => {
                    // console.log(erro);
                });
        } else {
            this.UserFavoriteRequest.start(
                (response) => {
                    // console.log(response)
                    if (response.data && response.data.myFavoriteList) {
                        self.setState({
                            userFavorite: response.data.myFavoriteList,
                            totalCnt: response.data.totalCnt,
                        });
                    }
                }, (erro) => {
                    // console.log(erro);
                });
        }

    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.background_grey,
    },
    tabItem: {
        flexDirection: "row",
        height: ScreenUtils.scaleSize(88),
        paddingTop: ScreenUtils.scaleSize(20),
        paddingBottom: ScreenUtils.scaleSize(20),
        backgroundColor: "#ffffff",
        borderBottomWidth: 1,
        borderBottomColor: '#DDDDDD',
        borderTopWidth: 1,
        borderTopColor: '#DDDDDD',
    },
    itemInfo: {
        flex: 1,
        alignItems: "center",
        justifyContent: "center",
    },
    itemRightBorder: {
        borderRightWidth: 1,
        borderRightColor: "#DDDDDD"
    },
    normalStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(28),
    },
    selectedStyle: {
        fontSize: ScreenUtils.setSpText(28),
        color: Colors.main_color,
    }
});