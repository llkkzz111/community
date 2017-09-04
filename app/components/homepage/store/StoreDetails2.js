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
    TextInput,
    ScrollView
} from 'react-native';

import {getStatusHeight} from '../../../../foundation/common/NavigationBar';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import ScrollableTabView, {ScrollableTabBar} from '../../../../foundation/common/scrollabletabview';
import Styles from '../../orderpage/Styles';
const topHeight = ScreenUtils.scaleSize(273);
export default class StoreDetails extends React.PureComponent {
    // 构造
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <View style={styles.container}>
                <StatusBar
                    translucent={true}
                    barStyle={'light-content'}
                    backgroundColor={'transparent'}/>
                {this._renderHeader()}
                {this._renderContent()}
                {this._renderTopBar()}
            </View>
        );
    }

    /**
     * 渲染头部
     * @private
     */
    _renderHeader() {
        let icon = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496299246419&di=f6d9e7d99236cb4319782d95cbd7f740&imgtype=0&src=http%3A%2F%2Fwww.pptbz.com%2FSoft%2FUploadSoft%2F200911%2F2009110521380826.jpg';
        let icon2 = 'http://pic28.nipic.com/20130503/9252150_153601831000_2.jpg';
        return (
            <Image
                ref={(ref)=>this.topView = ref}
                style={styles.headerContainer}
                source={{uri: icon2}}>
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

    /**
     * 渲染topbar
     * @private
     */
    _renderTopBar() {
        return (
            <View
                ref={(ref)=>this.statusView = ref}
                style={styles.headerTopContainer}
                onLayout={(event)=> {
                    let height = event.nativeEvent.layout.height;
                    if (this.statusHeight !== height) {
                        this.statusHeight = height;
                        this.contentView.setNativeProps({
                            style: {
                                bottom: -(topHeight - height)
                            }
                        })
                    }
                }}
            >
                <TouchableOpacity style={styles.headerBackStyle} onPress={()=> {
                    Actions.pop();
                }} activeOpacity={1}>
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
                        placeholder={'搜索'}
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
        );
    }

    /**
     * 渲染主内容模块
     * @private
     */
    _renderContent() {
        return (
            <View
                ref={(ref)=>this.contentView = ref}
                style={styles.contentStyle}
            >
                <ScrollableTabView
                    initialPage={this.orderPage}
                    style={{width: ScreenUtils.screenW, flex: 1}}
                    locked={false}
                    renderTabBar={() => <ScrollableTabBar />}
                    onChangeTab={(currentPage, pageNumber) => {
                    }}
                    tabBarActiveTextColor={Styles.tabStyle.tabBarActiveTextColor}
                    tabBarBackgroundColor={Styles.tabStyle.tabBarBackgroundColor}
                    tabBarUnderlineStyle={Styles.tabStyle.tabBarUnderlineStyle}
                >
                    {['店铺首页', '全部宝贝', '新品上架'].map((title, index)=> {
                        return (
                            <ScrollView
                                style={{flex: 1}}
                                key={index}
                                tabLabel={title}
                                scrollEventThrottle={1}
                                onScroll={this._onScroll.bind(this)}
                                overScrollMode={'never'}
                            >
                                <Text>{title}</Text>
                                <Text style={{marginTop: 100}}>{title}</Text>
                                <Text style={{marginTop: 100}}>{title}</Text>
                                <Text style={{marginTop: 100}}>{title}</Text>
                                <Text style={{marginTop: 100}}>{title}</Text>
                                <Text style={{marginTop: 100}}>{title}</Text><Text
                                style={{marginTop: 100}}>{title}</Text>
                                <Text style={{marginTop: 100}}>{title}</Text>
                                <Text style={{marginTop: 100}}>{'sfafadfdafadsf'}</Text>
                            </ScrollView>)
                    })}
                </ScrollableTabView>
            </View>
        );
    }

    /**
     *
     * @private
     */
    _onScroll(e) {
        let y = e.nativeEvent.contentOffset.y;
        this.lastY = y;
        let limit = topHeight - this.statusHeight;
        console.log('limit-->' + limit);
        console.log('y-->' + y);
        console.log('layoutMeasurement-->' + e.nativeEvent.layoutMeasurement.height);
        if (y <= limit) {
            this.topView.setNativeProps({
                style: {
                    height: topHeight - y,
                }
            });

            this.contentView.setNativeProps({
                style: {
                    transform: [
                        {translateY: -y}
                    ]
                }
            });
        } else {
            this.contentView.setNativeProps({
                style: {
                    transform: [
                        {translateY: -limit}
                    ]
                }
            });
        }
        this.statusView.setNativeProps({
            style: {
                backgroundColor: `rgba(0,0,0,${y / limit})`,
            }
        })

    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: Colors.background_grey,
    },
    headerContainer: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(273),
        justifyContent: 'flex-end',
        position: 'absolute',
        top: 0,
    },
    headerTopContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        position: 'absolute',
        paddingTop: getStatusHeight(),
        paddingBottom: ScreenUtils.scaleSize(20),
        left: 0,
        right: 0,
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
        flex: 1,
        fontSize: ScreenUtils.scaleSize(26),
        color: Colors.text_black,
        ...Platform.select({
            ios: {
                height: ScreenUtils.scaleSize(54)
            },
            android: {
                paddingTop: 0,
                paddingBottom: 0
            }
        }),
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
    contentStyle: {
        width: ScreenUtils.screenW,
        position: 'absolute',
        top: topHeight,
        backgroundColor: Colors.background_grey,
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

});