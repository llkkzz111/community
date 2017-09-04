/**
 * Created by 卓原 on 2017/5/24 0023.
 * 视频主页第一屏的item，宽度接近于屏幕，内含一个播放图标，商品名称，
 * 左上角可能有正在直播
 */

import React, {Component, PureComponent} from 'react';
import {
    View,
    Image,
    Text,
    StyleSheet,

} from 'react-native';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import PressTextColor from 'FOUNDATION/pressTextColor';
import TimerMiXin from 'react-timer-mixin';

const Com = __DEV__ ? Component : PureComponent;

export default class VideoItem extends Com {

    constructor(props) {
        super(props);
        this.times = 0
    }

    componentDidMount() {
        let item = this.props.item;
        if (item.videoStatus && item.videoStatus === 1) {
            this.interval = TimerMiXin.setInterval(() => {
                this.refs.onShowPoint.setNativeProps({
                    style: {
                        opacity: this.times % 2 === 0 ? 0 : 1
                    }
                });
                this.times += 1;
            }, 500);
        }
    }

    componentWillUnmount() {
        if (this.interval) {
            clearInterval(this.interval)
        }
    }

    render() {
        let item = this.props.item;
        return (
            <PressTextColor onPress={() => this.props.onClick({
                id: item.contentCode,
                type: item.liveSource,
                url: item.videoPlayBackUrl,
                codeValue: item.codeValue
            })}>
                <View style={styles.outViewStyle}>

                    <Image source={{uri: item.firstImgUrl ? item.firstImgUrl : '1'}}
                           style={styles.outsideimg}>
                        {
                            item.videoStatus && item.videoStatus === 1 ? //正在直播
                                <View style={styles.onLiveTitleViewStyle}>
                                    <View ref="onShowPoint" style={styles.circleStyle}/>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.onLiveText}>正在直播</Text>
                                </View>
                                :
                                <View style={styles.yellowView}>
                                    <View style={styles.yellowcircleStyle}/>
                                    <Text style={styles.onLiveText}>即将播出</Text>
                                </View>
                        }

                        <View style={styles.greyView}>
                        </View>
                        <Image source={require('../../../../foundation/Img/shoppingPage/Icon_play_.png')}
                               style={styles.play}/>
                    </Image>
                    <View style={styles.textview}>
                        <Text
                            allowFontScaling={false}
                            style={styles.whitetext} numberOfLines={1}>{item.title}</Text>
                    </View>
                </View>


            </PressTextColor>
        );
    }
}

const styles = StyleSheet.create({
    outViewStyle: {
        marginHorizontal: ScreenUtils.scaleSize(20),
    },
    outsideimg: {
        resizeMode: 'contain',
        width: ScreenUtils.scaleSize(310),
        height: ScreenUtils.scaleSize(310),
        justifyContent: 'center',
        alignItems: 'center',
    },
    whitetext: {
        color: '#333',
        fontSize: ScreenUtils.setSpText(26),
        backgroundColor: 'transparent',
        width: ScreenUtils.scaleSize(300),
    },
    textview: {
        width: ScreenUtils.scaleSize(310),
        height: ScreenUtils.scaleSize(70),
        justifyContent: 'center',
        paddingVertical: ScreenUtils.scaleSize(20),
        backgroundColor: '#fff'
    },
    onLiveTitleViewStyle: {
        flexDirection: 'row',
        height: ScreenUtils.scaleSize(30),
        width: ScreenUtils.scaleSize(124),
        backgroundColor: '#E5290D',
        borderRadius: ScreenUtils.scaleSize(50),
        position: 'absolute',
        left: ScreenUtils.scaleSize(20),
        top: ScreenUtils.scaleSize(20),
        zIndex: 10,
        alignItems: 'center',
        justifyContent: 'center'
    },

    circleStyle: {
        backgroundColor: '#fff',
        height: ScreenUtils.scaleSize(6),
        width: ScreenUtils.scaleSize(6),
        borderRadius: ScreenUtils.scaleSize(3),
        marginRight: ScreenUtils.scaleSize(5),
    },

    onLiveText: {
        backgroundColor: 'transparent',
        color: '#fff',
        //height:20,
        textAlignVertical: 'center',
        textAlign: 'center',
        fontSize: ScreenUtils.scaleSize(22),
        includeFontPadding: false,
    },

    yellowView: {
        flexDirection: 'row',
        height: ScreenUtils.scaleSize(30),
        width: ScreenUtils.scaleSize(124),
        backgroundColor: '#FFB000',
        borderRadius: ScreenUtils.scaleSize(50),
        position: 'absolute',
        left: ScreenUtils.scaleSize(20),
        top: ScreenUtils.scaleSize(20),
        zIndex: 10,
        alignItems: 'center',
        justifyContent: 'center'
    },

    yellowcircleStyle: {
        backgroundColor: '#fff',
        height: ScreenUtils.scaleSize(6),
        width: ScreenUtils.scaleSize(6),
        borderRadius: ScreenUtils.scaleSize(3),
        marginRight: ScreenUtils.scaleSize(5),
    },
    greyView: {
        backgroundColor: '#000',
        opacity: 0.05,
        width: ScreenUtils.scaleSize(310),
        height: ScreenUtils.scaleSize(310),
        justifyContent: 'center',
        position: 'absolute',
    },
    play: {
        width: ScreenUtils.scaleSize(110),
        height: ScreenUtils.scaleSize(110),
        //  alignSelf: 'center'
    }
});
