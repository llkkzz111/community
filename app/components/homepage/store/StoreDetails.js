/**
 * Created by YASIN on 2017/6/2.
 * 商铺详情页面
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    TouchableOpacity,
    StyleSheet,
    Platform,
    Text,
    StatusBar,
    TextInput
} from 'react-native';

import {getStatusHeight} from '../../../../foundation/common/NavigationBar';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import { Actions }from 'react-native-router-flux';

import Toast, {DURATION} from 'react-native-easy-toast';

import StoreDetailRequest from '../../../../foundation/net/home/store/StoreDetailRequest';

import StoreDetailHomePage from '../../../../foundation/store/StoreDetailHomePage';

import NewArrivals from '../../../../foundation/store/NewArrivals';

import AllBaby from '../../../../foundation/store/AllBaby';

import StoreTitleModule from '../../../../foundation/store/StoreTitleModule';

export default class StoreDetails extends React.PureComponent {
    // 构造
    constructor(props) {
        super(props);
        this.tabViews = [];
        // 初始状态
        this.state = {
            place: '电饭锅打7.2折',
            selectedTabIndex: 0,
            pageNum: 1,
            pageSize: 2,
            totalPage: -1
        };
        this._refresh = this._refresh.bind(this);
        this._loadMore = this._loadMore.bind(this);
        this._doPostMore = this._doPostMore.bind(this);
        this._jumpToCart = this._jumpToCart.bind(this);
        this._jumpToSearch = this._jumpToSearch.bind(this);
    }

    render() {
        return (
            <View style={styles.container}>
                <StatusBar
                    translucent={true}
                    barStyle={'light-content'}
                    backgroundColor={'transparent'} />
                {/*渲染navigationbar*/}
                {this._renderNav()}
                {/*渲染tabview*/}
                {this._renderTabView()}
            </View>
        );
    }

    /**
     * 渲染tab导航栏view
     * @private
     */
    _renderTabView() {
        return (
            <StoreTitleModule>
                <StoreDetailHomePage />
                <AllBaby />
                <NewArrivals />
            </StoreTitleModule>
        );
    }

    /**
     * 渲染navigation
     * @private
     */
    _renderNav() {
        let icon = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496299246419&di=f6d9e7d99236cb4319782d95cbd7f740&imgtype=0&src=http%3A%2F%2Fwww.pptbz.com%2FSoft%2FUploadSoft%2F200911%2F2009110521380826.jpg';
        let icon2 = 'http://pic28.nipic.com/20130503/9252150_153601831000_2.jpg';
        return (
            <Image
                style={styles.headerContainer}
                source={{uri: icon2}}>
                <View style={styles.headerTopContainer}>
                    <TouchableOpacity style={styles.headerBackStyle} onPress={()=>{
                        Actions.pop();}} activeOpacity={1}>
                        <Image
                            style={styles.leftArrowDefaultStyle}
                            source={require('../../../../foundation/Img/icons/Icon_back_.png')}
                        />
                    </TouchableOpacity>
                    <View style={styles.headerCenterContainer}>
                        <Image
                            style={styles.headerQueryStyle}
                            source={require('../../../../foundation/Img/icons/question.png')}
                        />
                        <TextInput
                            style={styles.queryTextStyle}
                            selectionColor={Colors.text_dark_grey}
                            underlineColorAndroid={'transparent'}
                            placeholder={this.state.place}
                            placeholderTextColor={Colors.text_light_grey}
                            onFocus={this._jumpToSearch}
                        />
                    </View>
                    <View style={styles.headerRightContainer}>
                        <TouchableOpacity onPress={this._jumpToCart} activeOpacity={1}>
                            <Image
                                style={styles.navRightCartStyle}
                                source={require('../../../../foundation/Img/home/store/Icon_cart_.png')}
                            />
                        </TouchableOpacity>
                        <TouchableOpacity activeOpacity={1}>
                            <Image
                                style={styles.navRightShareStyle}
                                source={require('../../../../foundation/Img/home/store/Icon_more_.png')}
                            />
                        </TouchableOpacity>
                    </View>
                </View>
                <View style={styles.headerBottomStyle}>
                    <Image
                        style={styles.storeIcon}
                        source={{uri: icon}}
                    />
                    <View style={styles.headerDescStyle}>
                        <Text allowFontScaling={false} style={styles.storeTitleStyle}>苹果旗舰店</Text>
                        <Text allowFontScaling={false} style={styles.storeDescStyle}>此处是促销信息</Text>
                    </View>
                    <View style={styles.headerObseverStyle}>
                        <Text allowFontScaling={false} style={styles.obseverDeStyle}>已有2000人关注</Text>
                    </View>
                </View>
            </Image>
        );
    }

    _refresh(flag = false) {
        if(this.props.searchKeyWord) this.setState({place: this.props.searchKeyWord});

        if (this.StoreDetailRequest) this.StoreDetailRequest.setCancled(true);
        let params = {};
        this.StoreDetailRequest = new StoreDetailRequest(params, 'GET');
        if (flag) this.StoreDetailRequest.showLoadingView();
        this.StoreDetailRequest.showLoadingView().start((response) => {
            let state = {};





        }, (error) => {

        });
    }

    _loadMore() {

    }

    _doPostMore() {

    }

    _jumpToCart() {
        Actions.cartFromStoreDetail();
    }

    _jumpToSearch() {
        Actions.KeywordSearchPageHome({fromPage: 'StoreDetails'});
    }

    componentDidMount() {
        this._refresh(true);
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.background_grey,
        ...Platform.select({
            ios: {
                marginTop: -ScreenUtils.scaleSize(22)
            }
        })
    },
    headerContainer: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(273),
        paddingTop: getStatusHeight(),
        justifyContent: 'space-between'
    },
    headerTopContainer: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    leftArrowDefaultStyle: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(20)
    },
    headerBackStyle: {
        width: ScreenUtils.scaleSize(78),
        height: ScreenUtils.scaleSize(54),
        alignItems: 'center',
        justifyContent: 'center'
    },
    headerRightContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        marginLeft: ScreenUtils.scaleSize(20),
        marginRight: ScreenUtils.scaleSize(30)
    },
    navRightCartStyle: {
        width: ScreenUtils.scaleSize(43),
        height: ScreenUtils.scaleSize(43)
    },
    navRightShareStyle: {
        width: ScreenUtils.scaleSize(36),
        height: ScreenUtils.scaleSize(36),
        marginLeft: ScreenUtils.scaleSize(30)
    },
    headerCenterContainer: {
        flex: 1,
        backgroundColor: '#f5f5f5',
        marginHorizontal: ScreenUtils.scaleSize(15),
        borderRadius: ScreenUtils.scaleSize(5),
        alignItems: 'center',
        flexDirection: 'row'
    },
    headerQueryStyle: {
        width: ScreenUtils.scaleSize(21),
        height: ScreenUtils.scaleSize(21),
        marginLeft: ScreenUtils.scaleSize(20)
    },
    queryTextStyle: {
        color: Colors.text_light_grey,
        flex: 1,
        fontSize: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(10),
        ...Platform.select({
            ios: {
                height: ScreenUtils.scaleSize(54)
            },
            android: {
                height: ScreenUtils.scaleSize(68)
            }
        })
    },
    headerBottomStyle: {
        flexDirection: 'row',
        alignSelf: 'stretch',
        alignItems: 'center',
        paddingLeft: ScreenUtils.scaleSize(30),
        paddingRight: ScreenUtils.scaleSize(20),
        paddingBottom: ScreenUtils.scaleSize(20)
    },
    storeIcon: {
        width: ScreenUtils.scaleSize(82),
        height: ScreenUtils.scaleSize(82)
    },
    headerDescStyle: {
        marginLeft: ScreenUtils.scaleSize(20),
        flex: 1
    },
    storeTitleStyle: {
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(32),
        backgroundColor: 'transparent'
    },
    storeDescStyle: {
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(22),
        marginTop: ScreenUtils.scaleSize(10),
        backgroundColor: 'transparent'
    },
    headerObseverStyle: {
        alignItems: 'center'
    },
    obseverTextStyle: {
        textAlign: 'center',
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(24)
    },
    obseverStyle: {
        height: ScreenUtils.scaleSize(50),
        width: ScreenUtils.scaleSize(140),
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#FFC033',
        borderRadius: ScreenUtils.scaleSize(25)
    },
    obseverDeStyle: {
        backgroundColor: 'transparent',
        color: Colors.text_white,
        fontSize: ScreenUtils.setSpText(20),
        marginTop: ScreenUtils.scaleSize(10)
    },
    tabContainer: {
        backgroundColor: Colors.text_white,
        height: ScreenUtils.scaleSize(88),
        width: ScreenUtils.screenW,
        flexDirection: 'row'
    },
    tabItemContainer: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        alignSelf: 'stretch'
    },
    tabItemInner: {
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center',
        borderBottomWidth: ScreenUtils.scaleSize(2),
        borderBottomColor: Colors.main_color
    },
    tabItem: {
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center'
    },
    tabTitleNormalStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(28),
        fontWeight: 'bold'
    },
    tabTitleSelectedStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(28)
    }
});

StoreDetails.propTypes = {

}