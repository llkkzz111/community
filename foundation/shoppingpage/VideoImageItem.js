/**
 * Created by Administrator on 2017/5/23.
 */
//直播首页单个直播视频图片组件
import React from 'react';
import {
    Dimensions,
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image,
} from 'react-native';

import {Actions} from 'react-native-router-flux';
import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';

const {width} = Dimensions.get('window');
import RnConnect from '../../app/config/rnConnect';
import * as routeConfig from '../../app/config/routeConfig';
import TimerMiXin from 'react-timer-mixin';
import * as NativeRouter from'../../app/config/NativeRouter';
import * as RouteManager from '../../app/config/PlatformRouteManager';
export default class VideoImageItem extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {}
        this.times = 0
    }


    componentDidMount() {
        if (this.props.imageType && this.props.imageType === '0') {
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
        let {videoImageItem, imageType} = this.props;

        return (
            <TouchableOpacity activeOpacity={1}
                              style={styles.videoImageItemStyle}
                              onPress={(videoID) => this.props.imgClick({
                                  id: videoImageItem.contentCode,
                                  type: videoImageItem.liveSource,
                                  url: videoImageItem.videoPlayBackUrl,
                                  codeValue: videoImageItem.codeValue
                              })}>
                <Image source={{uri: videoImageItem.firstImgUrl ? videoImageItem.firstImgUrl : '1'}}
                       style={styles.videoImgStyle}>
                    {/*播放图标*/}
                    <Image source={require('../Img/shoppingPage/Icon_play_.png')} style={styles.iconPlayStyle}/>
                    {/*名称标签*/}
                    <View style={styles.marginT}>
                        <Text allowFontScaling={false} numberOfLines={1}
                              style={styles.title}>{videoImageItem.title}</Text>
                        {/*观看人数和作者*/}
                        <View style={styles.authorInforStyle}>
                            <View style={styles.watchStyle}>
                                <Image
                                    source={require('../../foundation/Img/shoppingPage/icon_eye_gray_.png')}
                                    style={styles.smallPlay}/>
                                <Text allowFontScaling={false} style={styles.videoContext}>{videoImageItem.watchNumber}
                                    观看</Text>
                            </View>
                            <View style={styles.watchStyle}>
                                <Text allowFontScaling={false} style={styles.videoContext}>
                                    {videoImageItem.author}</Text>

                                <Text allowFontScaling={false}
                                      style={styles.videoContext}>{videoImageItem.videoDate}</Text>

                            </View>
                        </View>
                    </View>
                </Image>

                {
                    imageType == '0' ? //正在直播
                        <View style={styles.onLiveTitleViewStyle}>
                            <View ref="onShowPoint" style={styles.circleStyle}/>
                            <Text allowFontScaling={false} style={styles.onLiveText}>正在直播</Text>
                        </View>
                        :
                        <View style={styles.onLiveTitleViewStyle}>
                            <View style={styles.circleStyle}/>
                            <Text allowFontScaling={false} style={styles.onLiveText}>精彩回放</Text>
                        </View>
                }
            </TouchableOpacity>
        )
    }


}

const styles = StyleSheet.create({
    label: {
        color: '#999',
        fontSize: ScreenUtil.setSpText(22),
    },

    authorInforStyle: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginTop: ScreenUtil.scaleSize(10)
        // backgroundColor:'green'
    },
    watchStyle: {
        flexDirection: 'row',
        alignItems: 'center'
    },

    videoImageItemStyle: {
        backgroundColor: Colors.text_white,
    },
    videoImgStyle: {
        width: ScreenUtil.screenW,
        height: ScreenUtil.screenW,
        resizeMode: 'stretch',
        justifyContent: 'flex-end',
    },
    onLiveTitleViewStyle: {
        flexDirection: 'row',
        height: ScreenUtil.scaleSize(30),
        width: ScreenUtil.scaleSize(124),
        backgroundColor: Colors.main_color,
        borderRadius: ScreenUtil.scaleSize(50),
        position: 'absolute',
        left: ScreenUtil.scaleSize(50),
        top: ScreenUtil.scaleSize(20),
        zIndex: 10,
        alignItems: 'center',
        justifyContent: 'center'
    },

    circleStyle: {
        backgroundColor: '#fff',
        height: ScreenUtil.scaleSize(6),
        width: ScreenUtil.scaleSize(6),
        borderRadius: ScreenUtil.scaleSize(3),
        marginRight: ScreenUtil.scaleSize(5),
    },

    onLiveText: {
        backgroundColor: Colors.main_color,
        color: Colors.text_white,
        //height:20,
        textAlignVertical: 'center',
        textAlign: 'center',
        fontSize: ScreenUtil.scaleSize(22),

    },

    iconPlayStyle: {
        width: ScreenUtil.scaleSize(110),
        height: ScreenUtil.scaleSize(110),
        resizeMode: 'contain',
        position: 'absolute',
        alignSelf: 'center',
        top: ScreenUtil.scaleSize(290),
    },

    coverView: {
        width: width - 20,
        height: 30,
        opacity: 0.05,
        resizeMode: 'cover',
        position: 'absolute',
        left: 10,
        bottom: 10,
        zIndex: 11,
        backgroundColor: Colors.background_grey,

    },
    videoContext: {
        color: '#666',
        fontSize: ScreenUtil.setSpText(24),
        marginLeft: ScreenUtil.scaleSize(10),
    },
    smallPlay: {
        width: ScreenUtil.scaleSize(26),
        height: ScreenUtil.scaleSize(26),
        resizeMode: 'contain'
    },
    marginT: {
        height: ScreenUtil.scaleSize(125),
        backgroundColor: '#fff',
        paddingHorizontal: ScreenUtil.scaleSize(30),
        paddingVertical: ScreenUtil.scaleSize(20),
        width: ScreenUtil.screenW,
        marginTop: ScreenUtil.scaleSize(10)
    },
    title: {
        fontSize: ScreenUtil.setSpText(28),
        color: '#333',
        maxWidth: ScreenUtil.scaleSize(680),
    },
    thislist: {
        paddingTop: ScreenUtil.scaleSize(22),

    },
    ellipse: {
        marginHorizontal: ScreenUtil.scaleSize(5),
        borderColor: Colors.text_light_grey,
        borderRadius: ScreenUtil.scaleSize(20),
        borderWidth: 0.5,
        paddingHorizontal: ScreenUtil.scaleSize(15),
        paddingVertical: ScreenUtil.scaleSize(2),
    },
    textview: {
        width: width - ScreenUtil.scaleSize(60),
        height: ScreenUtil.scaleSize(90),
        justifyContent: 'center',
        paddingLeft: ScreenUtil.scaleSize(10),
    },
});