/**
 * Created by YASIN on 2017/6/5.
 * 全球购首页
 */
import React from 'react';
import {
    View,
    StyleSheet,
    Image,
    Platform,
    ScrollView,
    TouchableOpacity
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import NavigationBar from '../../../../foundation/common/NavigationBar';
import Swiper from 'react-native-swiper';
import Styles from './Styles';
import HeaderTab from './HeaderTab';
import GlobalCommonTitle from './GlobalCommonTitle';
export default class GlobalShopping extends React.Component {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            headerTabDatas: [
                {
                    title: '厨房用具',
                    flag: '新'
                },
                {
                    title: '美妆洗护',
                },
                {
                    title: '家居家饰',
                },
                {
                    title: '手机数码',
                    flag: '新'
                },
                {
                    title: '更多分类',
                }
            ]
        };
    }

    render() {
        return (
            <View style={styles.container}>
                {/*头部导航栏*/}
                {this._renderNav()}
                <ScrollView overScrollMode={'never'}>
                    {/*头部banner*/}
                    {this._renderHeaderBanner()}
                    {/*头部tabdao*/}
                    {this._renderHeaderTab()}
                    {/*200元购边全球*/}
                    {this._renderGlobalShopping()}
                </ScrollView>
            </View>
        );
    }

    /**
     * 渲染头部广告
     * @private
     */
    _renderHeaderBanner() {
        let banners = [];
        banners.push('https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1496289161&di=0551ac0fcaa7435228a849fb1d47a71f&src=http://pic51.nipic.com/file/20141101/12414773_004922825867_2.jpg');
        banners.push('https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496299246419&di=f6d9e7d99236cb4319782d95cbd7f740&imgtype=0&src=http%3A%2F%2Fwww.pptbz.com%2FSoft%2FUploadSoft%2F200911%2F2009110521380826.jpg');
        return (
            <View style={styles.bannerContainerStyle}>
                <Swiper
                    height={ScreenUtils.scaleSize(300)}
                    autoplay={true}
                    paginationStyle={{bottom: 0}}
                    dot={<View style={Styles.swiper.dot}/>}
                    activeDot={<View style={Styles.swiper.activeDot}/>}
                >
                    {banners.map((item, key) => {
                        return (
                            <TouchableOpacity
                                activeOpacity={1}
                                key={key}
                            >
                                <Image
                                    style={styles.headerBannerStyle}
                                    source={{uri: item}}
                                />
                            </TouchableOpacity>
                        )
                    })}
                </Swiper>
            </View>
        );
    }

    /**
     * 渲染导航栏
     * @private
     */
    _renderNav() {
        return (
            <NavigationBar
                title={'商城'}
                renderRight={() => {
                    return (
                        <View style={styles.navRightStyle}>
                            <TouchableOpacity activeOpacity={1}>
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
                    )
                }}
                navigationBarBackgroundImage={require('../../../../foundation/Img/home/globalshopping/icon_titleBg_.png')}
                navigationStyle={{height: ScreenUtils.scaleSize(128), ...Platform.select({ios: {marginTop: -22}})}}
                renderTitle={() => {
                    return (
                        <Image
                            source={require('../../../../foundation/Img/home/globalshopping/icon_globalbuylogo_.png')}
                            style={styles.globalTitleStyle}
                        />
                    )
                }}
            />
        );
    }

    /**
     * 渲染头部tabview
     * @private
     */
    _renderHeaderTab() {
        return (
            <HeaderTab
                datas={this.state.headerTabDatas}
                onItemClick={(index) => {
                    if (this.state.headerTabDatas && this.state.headerTabDatas[index]) {
                        alert(this.state.headerTabDatas[index].title);
                    }
                }}
            />
        );
    }

    /**
     * 200元购遍全球
     * @private
     */
    _renderGlobalShopping() {
        return (
            <View>
                <GlobalCommonTitle
                    style={styles.globalShoppingStyle}
                    title={'· 200元购遍全球 ·'}
                    desc={'每天10点更新'}
                />
                {/**/}
            </View>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: Colors.background_grey
    },
    navRightStyle: {
        width: ScreenUtils.scaleSize(120),
        flexDirection: 'row',
        alignItems: 'center',
        paddingRight: ScreenUtils.scaleSize(20),
    },
    navRightCartStyle: {
        width: ScreenUtils.scaleSize(43),
        height: ScreenUtils.scaleSize(43)
    },
    navRightShareStyle: {
        width: ScreenUtils.scaleSize(36),
        height: ScreenUtils.scaleSize(36),
        marginLeft: ScreenUtils.scaleSize(15)
    },
    globalTitleStyle: {
        width: ScreenUtils.scaleSize(127),
        height: ScreenUtils.scaleSize(54),
        alignSelf: 'center',
        resizeMode: 'stretch',
        marginTop: ScreenUtils.scaleSize(-10)
    },
    headerBannerStyle: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(300),
        resizeMode: 'stretch'
    },
    bannerContainerStyle: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(300),
        marginBottom: ScreenUtils.scaleSize(10)
    },
    globalShoppingStyle: {
        marginTop: ScreenUtils.scaleSize(20)
    }
});