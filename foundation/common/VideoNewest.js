/**
 * Created by 卓原 on 2017/5/24 0024.
 * 最新视频列表的item，宽度接近于屏幕的一半，图下有一行标题和一组标签栏
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

export default class VideoItem extends React.PureComponent {

    render() {

        let item = this.props.item;
        return (
            <TouchableOpacity activeOpacity={1} style={styles.container} onPress={() => this.pressbtn(item.url)}>
                <View style={styles.contain}>
                    <Image source={item.img} style={styles.outsideimg}>
                        <View style={styles.space}>
                            <Text style={styles.whitetext} allowFontScaling={false}>今日{item.releasetime}发布</Text>
                            <Text style={styles.whitetext} allowFontScaling={false}>{item.long}</Text>
                        </View>
                    </Image>
                </View>
                <View style={styles.marginT}>
                    <Text style={styles.title}
                          numberOfLines={1} allowFontScaling={false}>{item.title}</Text>
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
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtil.screenW * 0.45,
        margin: 5,
    },
    space: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        marginHorizontal: 5,
        marginBottom: 2,
        opacity: 0.5,
        alignItems: 'flex-end',
    },
    marginT: {
        marginTop: 5,
        flexDirection: 'column',
        justifyContent: 'center',
    },
    outsideimg: {
        resizeMode: 'cover',
        width: ScreenUtil.screenW * 0.45,
        height: ScreenUtil.screenH / 5,
        justifyContent: 'flex-end'
    },
    whitetext: {
        color: '#fff',
        fontSize: 10,
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
        paddingTop: 2,
    },
    contain: {}
});