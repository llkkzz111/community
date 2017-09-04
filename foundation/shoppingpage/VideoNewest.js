/**
 * Created by 卓原 on 2017/5/24 0024.
 * 最新视频列表的item，宽度接近于屏幕的一半，图下有一行标题和一组标签栏
 */

//视频主页最新视频ITEM
import React from 'react';
import {
    View,
    Image,
    Text,
    StyleSheet,
    TouchableOpacity,
} from 'react-native';
import RnConnect from '../../app/config/rnConnect';
import {Actions} from 'react-native-router-flux';
import * as routeConfig from '../../app/config/routeConfig';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
import * as RouteManager from '../../app/config/PlatformRouteManager';
import * as NativeRouter from '../../app/config/NativeRouter';

export default class VideoNewest extends React.PureComponent {
    render() {
        let item = this.props.item;
        return (
            <TouchableOpacity activeOpacity={1} style={styles.container}
                              onPress={() => this.props.pressbtn({
                                  id: item.contentCode,
                                  type: item.liveSource,
                                  url: item.videoPlayBackUrl,
                                  codeValue: item.codeValue
                              })}>

                <Image source={{uri: item.firstImgUrl ? item.firstImgUrl : '1'}}
                       style={styles.outsideImg}>
                </Image>
                <View style={styles.marginT}>
                    <Text allowFontScaling={false} style={styles.title}
                          numberOfLines={1}>{item.title}</Text>
                </View>

            </TouchableOpacity>
        )
    }

}
const styles = StyleSheet.create({
    container: {
        paddingVertical: ScreenUtils.scaleSize(20),
        paddingHorizontal: ScreenUtils.scaleSize(30),
        marginRight: ScreenUtils.scaleSize(2),
        backgroundColor: '#fff'
    },

    marginT: {
        marginVertical: ScreenUtils.scaleSize(20),
        flexDirection: 'column',
        justifyContent: 'center',
    },
    outsideImg: {
        resizeMode: 'stretch',
        width: (ScreenUtils.screenW - ScreenUtils.scaleSize(122)) / 2,
        height: (ScreenUtils.screenW - ScreenUtils.scaleSize(122)) / 2,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#ddd'
    },

    center: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    title: {
        fontSize: ScreenUtils.setSpText(28),
        color: '#333',
        maxWidth: (ScreenUtils.screenW - ScreenUtils.scaleSize(122)) / 2,
    },

});