/**
 * Created by 卓原 on 2017/5/23 0023.
 * 视频全列表的item，宽度接近于屏幕，内含一个播放图标，含有小眼睛图标和播放次数，
 * 图下有一行标题和一组标签栏
 */

import React from 'react';
import {
    View,
    Image,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
} from 'react-native';

import * as ScreenUtil from'../utils/ScreenUtil';
export default class VideoAllListItem extends React.PureComponent {

    render() {

        let item = this.props.item;
        return (
            <TouchableOpacity activeOpacity={1} style={styles.container} onPress={() => this.pressbtn(item.url)}>
                <Image source={item.img} style={styles.outsideimg}>
                    <View style={styles.center}>
                        <Image source={require('./img/Icon_play_.png')} style={styles.insideimg}/>
                    </View>
                    <View style={styles.space}>
                        <View style={styles.horizat}>
                            <Image source={require('./img/Icon_eye_.png')} style={styles.eye}/>
                            <Text style={styles.whitetext} allowFontScaling={false}>{item.watchtimes} 观看</Text>
                        </View>
                        <Text style={styles.whitetext} allowFontScaling={false}>{item.long}</Text>
                    </View>
                </Image>
                <View style={styles.marginT}>
                    <Text style={styles.title} numberOfLines={1} allowFontScaling={false}>{item.title}</Text>
                    <View style={styles.thislist}>
                        <FlatList
                            showsHorizontalScrollIndicator={false}
                            numColumns={3}
                            data={item.tab}
                            renderItem={({item}) => <View style={styles.ellipse}
                            ><Text style={styles.label} allowFontScaling={false}>{item}</Text>
                            </View>}/>
                    </View>
                </View>
            </TouchableOpacity>
        )
    }

    pressbtn(url) {
        alert(url);
    }
}

const styles = StyleSheet.create({
    container: {
        marginVertical: 5,
        width: ScreenUtil.screenW * 0.9,
    },
    space: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingHorizontal: 5,
        paddingBottom: 10,
        opacity: 0.25,
        alignItems: 'flex-end',
    },
    marginT: {
        marginTop: 10,
        flexDirection: 'row',
        justifyContent: 'center',
    },
    outsideimg: {
        resizeMode: 'cover',
        width: ScreenUtil.screenW * 0.9,
        height: ScreenUtil.screenH / 4,
    },
    insideimg: {
        resizeMode: 'cover',
        width: 70,
        height: 70,
    },
    whitetext: {
        color: '#fff',
        fontSize: 12,
    },
    center: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    ellipse: {
        marginHorizontal: 5,
        borderColor: '#999',
        borderRadius: 10,
        borderWidth: 0.5,
        paddingHorizontal: 5,
    },
    label: {
        color: '#999',
        fontSize: 10,
        margin: 1,
    },
    title: {
        fontSize: 14,
        flex: 1,
    },
    thislist: {
        paddingTop: 2
    },
    horizat: {
        flexDirection: 'row',
        alignItems: 'center',

    },
    eye: {
        marginHorizontal: 5
    }
});