/**
 * Created by Administrator on 2017/5/19.
 */

import React from 'react';
import {
    Dimensions,
    StyleSheet,
    Text,
    View,
    Image,
    FlatList,
    TouchableWithoutFeedback
} from 'react-native';

import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';
const {width} = Dimensions.get('window');
import RnConnect from '../../app/config/rnConnect';
import * as routeConfig from '../../app/config/routeConfig';
import {Actions} from 'react-native-router-flux';
import * as NativeRouter from'../../app/config/NativeRouter';
import * as RouteManager from '../../app/config/PlatformRouteManager';
export default class LiveInfor extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            liveInforData: this.props.liveInforData
        }
        this.times = 0
    }

    componentDidMount() {
        if (this.props.now) {
            this.interval = setInterval(() => {
                this.refs.onShowPoint1.setNativeProps({
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
        let {liveInforData} = this.props;
        return (
            <TouchableWithoutFeedback
                onPress={(videoID) => this.props.imgClick({
                    id: liveInforData.contentCode,
                    type: liveInforData.liveSource,
                    url: liveInforData.videoPlayBackUrl,
                    codeValue: liveInforData.codeValue
                })}>
                <View style={styles.programItem}>
                    <Image source={{uri: liveInforData.firstImgUrl ? liveInforData.firstImgUrl : '1'}}
                           style={styles.programImg}>

                        {
                            this.props.now === true ? //正在直播
                                <View style={styles.onLiveTitleViewStyle}>
                                    <View ref="onShowPoint1" style={styles.circleStyle}></View>
                                    <Text style={styles.onLiveText} allowFontScaling={false}>正在直播</Text>
                                </View>
                                :
                                <View style={styles.soonTitleViewStyle}>
                                    <Text style={styles.circleStyle} allowFontScaling={false}></Text>
                                    <Text style={styles.broadcastSoon} allowFontScaling={false}>精彩回放</Text>
                                </View>
                        }
                    </Image>

                    <View style={styles.contents}>
                        <Text allowFontScaling={false} style={styles.programItemName}
                              numberOfLines={3}>{liveInforData.title}</Text>
                        <View style={styles.countAndAuthor}>
                            <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                <Image
                                    source={require('../../foundation/Img/shoppingPage/icon_eye_gray_.png')}
                                    style={styles.smallPlay}/>
                                <Text allowFontScaling={false} style={styles.counter}>{liveInforData.watchNumber}
                                    观看</Text>
                            </View>
                            <Text allowFontScaling={false} style={styles.author}>{liveInforData.videoDate}</Text>
                        </View>
                    </View></View>
            </TouchableWithoutFeedback>


        )
    }


}

LiveInfor.propTypes = {};

LiveInfor.defaultProps = {};


const styles = StyleSheet.create({

    onLiveTitleViewStyle: {
        flexDirection: 'row',
        height: ScreenUtil.scaleSize(30),
        width: ScreenUtil.scaleSize(124),
        backgroundColor: Colors.main_color,
        borderRadius: 12,
        position: 'absolute',
        left: ScreenUtil.scaleSize(10),
        top: ScreenUtil.scaleSize(10),
        zIndex: 10,
        alignItems: 'center',
        justifyContent: 'center'
    },

    circleStyle: {
        backgroundColor: Colors.text_white,
        height: ScreenUtil.scaleSize(6),
        width: ScreenUtil.scaleSize(6),
        borderRadius: ScreenUtil.scaleSize(3),
    },

    onLiveText: {
        backgroundColor: Colors.main_color,
        color: Colors.text_white,
        //height:ScreenUtil.scaleSize(20),
        width: ScreenUtil.scaleSize(100),
        textAlignVertical: 'center',
        textAlign: 'center',
        borderRadius: 12,
        fontSize: Fonts.tag_font(),

    },

    soonTitleViewStyle: {
        flexDirection: 'row',
        height: ScreenUtil.scaleSize(30),
        width: ScreenUtil.scaleSize(124),
        backgroundColor: '#000',
        borderRadius: 12,
        position: 'absolute',
        left: ScreenUtil.scaleSize(10),
        top: ScreenUtil.scaleSize(10),
        zIndex: 10,
        alignItems: 'center',
        justifyContent: 'center',
        opacity: 0.4
    },
    broadcastSoon: {
        //backgroundColor:Colors.yellow,
        color: Colors.text_white,
        //height:ScreenUtil.scaleSize(20),
        width: ScreenUtil.scaleSize(100),
        textAlignVertical: 'center',
        textAlign: 'center',
        borderRadius: 12,
        fontSize: Fonts.tag_font(),
    },

    smallPlay: {
        width: ScreenUtil.scaleSize(20),
        height: ScreenUtil.scaleSize(20),
        marginRight: ScreenUtil.scaleSize(10),
        resizeMode: 'contain'
    },

    title: {
        fontSize: Fonts.secondary_font(),
        color: Colors.text_dark_grey,
    },


    programImg: {
        width: ScreenUtil.scaleSize(180),
        height: ScreenUtil.scaleSize(180),
    },
    programItem: {
        padding: ScreenUtil.scaleSize(20),
        backgroundColor: Colors.background_white,
        flexDirection: 'row',
        justifyContent: 'flex-start'
    },
    contents: {
        paddingLeft: ScreenUtil.scaleSize(20),
        flex: 1,
        justifyContent: 'space-between',
    },
    programItemName: {
        color: Colors.text_black,
        fontSize: Fonts.standard_normal_font(),

    },
    counter: {
        color: '#666',
        fontSize: ScreenUtil.setSpText(24),
    },
    author: {
        color: '#F14967',
        fontSize: Fonts.secondary_font(),
        marginLeft: ScreenUtil.scaleSize(30),
        flex: 1,
        textAlign: 'right'
    },
    countAndAuthor: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-end',
    },
});