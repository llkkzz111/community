/**
 * @author Xiang
 *
 * 消息列表
 */
import React from "react"
import {
    StyleSheet,
    View,
    Text,
    Dimensions,
    Image,
    ScrollView,
    Platform,
    TouchableOpacity,
    RefreshControl
} from 'react-native'
import {Actions} from 'react-native-router-flux';
import UserMessagesRequest from '../../foundation/net/mine/UserMessagesRequest.js';
import NetErro from '../../app/components/error/NetErro';
import NavigationBar from '../../foundation/common/NavigationBar';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
import Colors from '../../app/config/colors';
import * as routeConfig from '../../app/config/routeConfig';
let {width} = Dimensions.get('window');
import RnConnect from '../../app/config/rnConnect';
import * as NativeRouter from'../../app/config/NativeRouter';
import * as LocalStorage from '../../foundation/LocalStorage';
import * as RouteManager from '../../app/config/PlatformRouteManager';
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
export default class MessageListPage extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            messagesData: [],
            More: [],
            isRefreshing: false,
        };
        this.page = 1;
        this.MessageData = [];
    }

    componentWillMount() {
        //  if (this.props.beforepage === routeConfig.Globalocj_MessageListPage) {
        //      LocalStorage.save("jumpkey", {MessageListocj: routeConfig.Globalocj_MessageListPage});
        //  }
    }

    render() {
        this.MessageData = this.MessageData.concat(this.state.More);
        let MessageData = this.state.messagesData.concat(this.MessageData);
        return (
            <View style={{flex: 1}}>
                <NavigationBar
                    title={'消息'}
                    navigationStyle={{height: ScreenUtils.scaleSize(128), ...Platform.select({ios: {marginTop: -22}})}}
                    titleStyle={{
                        color: Colors.text_black,
                        backgroundColor: 'transparent',
                        fontSize: ScreenUtils.scaleSize(36)
                    }}
                    renderLeft={() => {
                        return (
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {
                                    DataAnalyticsModule.trackEvent('AP1706C050');
                                    if (this.props.beforepage) {
                                        RouteManager.routeBack(this.props.beforepage);
                                    } else {
                                        Actions.pop();
                                    }
                                }}
                                style={styles.leftContainerDefaultStyle}
                            >
                                <Image style={styles.leftArrowDefaultStyle}
                                       source={require('../../foundation/Img/icons/Icon_back_.png')}
                                />
                            </TouchableOpacity>
                        );
                    }}
                    barStyle={'dark-content'}
                />
                <View style={{width: width, backgroundColor: '#DDDDDD', height: 0.5}}/>
                {MessageData.length > 0 ?
                    <ScrollView style={{
                        borderTopWidth: 1,
                        borderTopColor: '#FFFFFF',
                    }}
                                refreshControl={
                                    <RefreshControl
                                        refreshing={this.state.isRefreshing}
                                        onRefresh={() => this._onRefresh()}
                                        tintColor="#ff0000"
                                        title="加载中..."
                                        titleColor="#DDDDDD"
                                        colors={['#ff0000', '#00ff00', '#0000ff']}
                                        progressBackgroundColor="#FFFFFF"
                                    />
                                }>
                        {
                            MessageData.map((item, i) => {
                                return (
                                    <TouchableOpacity activeOpacity={1} onPress={() => this.goMessageListDetail(item)}>
                                        <View style={styles.container}>
                                            <View style={styles.contentRow}>
                                                <Image style={styles.contentImg}
                                                       source={(item.typeCode === '200') || (item.typeCode === '300') || (item.typeCode == '400') || (item.typeCode === '600') || (item.typeCode === '700') || (item.typeCode === '800') || '' ? require('../Img/me/icon_GG_3x.png') :
                                                           require('../Img/me/icon_Message_3x.png')}/>
                                                <View style={styles.contentText}>
                                                    <View style={styles.textTitleRow}>
                                                        <Text allowFontScaling={false}
                                                              style={styles.textTitle}>{item.type}</Text>
                                                        <Text allowFontScaling={false}
                                                              style={styles.textDate}>{item.startDate}</Text>
                                                    </View>
                                                    <Text allowFontScaling={false} style={styles.textMessage}
                                                          numberOfLines={1}>{item.subject}</Text>
                                                </View>
                                            </View>
                                            <View style={styles.divideLine}/>
                                        </View>
                                    </TouchableOpacity>
                                )
                            })
                        }
                    </ScrollView> : <NetErro
                        style={{height: ScreenUtils.screenH}}
                        icon={require('../../foundation/Img/order/img_DD_2x.png')}
                        title={'当前没有消息！'}
                    />}
            </View>
        )
    }

    _onRefresh() {
        let Page = this.page += 1;
        this._messagesListMore(Page)
    }

    goMessageListDetail(item) {
        switch (item.typeCode) {
            case '01'://中奖通知
                break;
            case '02'://活动公告
                DataAnalyticsModule.trackEvent('AP1706C052');
                break;
            case '09'://其他
                break;
            case '06'://客服系统
                break;
            case '05'://播出提醒
                break;
            case '10'://系统消息
                break;
            case '700'://0+俱乐部
                break;
            case '200'://会员社区
                break;
            case '300'://顾客中心
                DataAnalyticsModule.trackEvent('AP1706C053');
                break;
            case '400'://活动公告
                DataAnalyticsModule.trackEvent('AP1706C052');
                break;
            case '800'://招标公告
                break;
            case '600'://汽车馆
                break;
            default:
                break;

        }
        if (this.props.beforepage === routeConfig.Global) {
            //全球购消息
            Actions.MessageDetailFromGlobalOcj({item: item});
        } else {
            switch (this.props.fromPage) {
                case 'ClassificationChannel':
                    //分类频道消息
                    Actions.MessageDetailFromClassificationChannel({item: item});
                    break;
                case 'Classification':
                    //分类导航消息
                    Actions.MessageDetailFromClassification({item: item});
                    break;
                case 'HomePage':
                    //首页消息
                    Actions.MessageDetailFromHome({item: item});
                    break;
                case 'HomeStore':
                    //商城首页消息
                    Actions.MessageDetailFromHomeStore({item: item});
                    break;
                case 'MePage':
                    //个人中心消息
                    Actions.MessageListDetailPage({item: item});
                    break;
            }
        }
    }

    componentDidMount() {
        this._messagesList();
    }

    componentWillUnmount() {
        //TODO 消息列表逻辑
        if (this.props.fromPage === 'ClassificationChannel' || this.props.fromPage === 'Clssification' ||
            this.props.fromPage === 'ShopPage' || this.props.fromPage === 'HomePage') {
            null
        }
        //else if (this.props.beforepage && this.props.beforepage === routeConfig.MessageListPage) {
        // RnConnect.pushs({page: routeConfig.Homeocj_Global}, (event) => {
        //     NativeRouter.nativeRouter(event);
        // });
        //    RouteManager.routeJump({
        //       page: routeConfig.Global
        //   })
        // }
    }

    _messagesList() {
        let self = this;
        //当请求之前存在的时候，取消之前请求
        if (this.UserMessagesRequest) {
            this.UserMessagesRequest.setCancled(true);
        }
        //创建一个请求，参数（请求参数、请求方法）
        this.UserMessagesRequest = new UserMessagesRequest({currentPage: 1}, 'GET');
        //显示一个进度条showLoadingView()，默认不显示
        //失败后显示后台message，setShowMessage(true) 默认不显示
        this.UserMessagesRequest.showLoadingView().start(
            (response) => {
                if (response.code === 200) {
                    DataAnalyticsModule.trackEvent('AP1707C071D013001D024001');
                    self.setState({
                        messagesData: response.data,
                        isRefreshing: false
                    });
                }
                //接口请求成功
                console.log('---> _messagesList UserMessagesRequest ' + response.data);
            }, (erro) => {
                //接口请求失败
                // console.log(erro);
            });
    }

    //上拉加载更多
    _messagesListMore(Page) {
        let self = this;
        //当请求之前存在的时候，取消之前请求
        if (this.UserMessagesRequest) {
            this.UserMessagesRequest.setCancled(true);
        }
        //创建一个请求，参数（请求参数、请求方法）
        this.UserMessagesRequest = new UserMessagesRequest({currentPage: Page}, 'GET');
        //显示一个进度条showLoadingView()，默认不显示
        //失败后显示后台message，setShowMessage(true) 默认不显示
        this.UserMessagesRequest.showLoadingView().setShowMessage(true).start(
            (response) => {
                if (response.code === 200) {
                    self.setState({
                        More: response.data,
                        isRefreshing: false
                    });
                }
                //接口请求成功
                // console.log('---> _messagesList UserMessagesRequest ' + response.data);
            }, (erro) => {
                //接口请求失败
                // console.log(erro);
            });
    }

    // componentDidUnMount() {
    //     if (this.UserMessagesRequest) this.UserMessagesRequest.setCancled(true);
    // }
}

const styles = StyleSheet.create({
    container: {
        width: width,
        paddingLeft: 16,
        paddingRight: 16,
    },
    contentRow: {
        flex: 1,
        paddingTop: 12,
        paddingBottom: 12,
        flexDirection: 'row',
    },
    contentImg: {
        width: 40,
        height: 40,
        resizeMode: 'contain',
        marginRight: 12,
    },
    contentText: {
        flex: 1,
        justifyContent: 'center',
    },
    textTitleRow: {
        flexDirection: 'row',
    },
    textTitle: {
        flex: 1,
        fontSize: 16,
        color: '#333333'
    },
    textDate: {
        fontSize: 16,
        color: '#333333'
    },
    textMessage: {
        marginTop: 10,
        fontSize: 14,
        color: '#666666'
    },
    divideLine: {
        height: ScreenUtils.scaleSize(0.5),
        backgroundColor: '#DDDDDD',
        width: width
    },
    leftContainerDefaultStyle: {
        width: ScreenUtils.scaleSize(120),
        height: ScreenUtils.scaleSize(70),
        justifyContent: 'center',
    },
    leftArrowDefaultStyle: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(20)
    },
});
// export default connect(
//     state => ({}),
//     dispatch => ({
//     })
// )(MessageListPage)