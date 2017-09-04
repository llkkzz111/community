/**
 * Created by 卓原 on 2017/5/24 0023.
 * 视频主页第一屏的item，宽度接近于屏幕，内含一个播放图标，商品名称，
 * 左上角可能有正在直播
 */

import React from 'react';
import {
    View,
    Image,
    Text,
    StyleSheet,
    TouchableOpacity,
} from 'react-native';

import * as ScreenUtil from'../utils/ScreenUtil';

export default class VideoMainItem extends React.PureComponent {

    render() {

        let item = this.props.item;
        return (
            <TouchableOpacity activeOpacity={1} style={styles.container} onPress={() => this.pressbtn(item.url)}>
                <Image source={item.img} style={styles.outsideimg}>
                    {item.playing ? <Image
                        style={styles.lefttopimg}
                        source={require('./img/Icon_info_bg_.png')}>
                        <Text style={styles.playing} allowFontScaling={false}>正在直播</Text>
                    </Image> : null}
                    <View style={styles.center}>
                        <Image source={require('./img/Icon_play_.png')} style={styles.insideimg}/>
                    </View>
                    <View style={styles.textview}>
                        <Text style={styles.whitetext} numberOfLines={1} allowFontScaling={false}>{item.title}</Text>
                    </View>
                </Image>
            </TouchableOpacity>
        )
    }

    pressbtn(url) {
    }
}

const styles = StyleSheet.create({
    container: {
        marginVertical: 5,
        width: ScreenUtil.screenW * 0.9,
    },
    outsideimg: {
        resizeMode: 'cover',
        width: ScreenUtil.screenW * 0.9,
        height: ScreenUtil.screenH / 3.5,
    },
    insideimg: {
        resizeMode: 'cover',
        width: 60,
        height: 60,
    },
    whitetext: {
        color: '#fff',
        fontSize: 14,
    },
    center: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    title: {
        fontSize: 14,
        flex: 1,
    },
    lefttopimg: {
        resizeMode: 'cover',
        position: 'absolute',
        top: 10,
        left: 15,
        paddingLeft: 10,
        justifyContent: 'center'
    },
    textview: {
        marginBottom: 10,
        marginLeft: 10,
    },
    playing: {
        fontSize: 8,
        color: '#fff'
    }
});