/**
 * Created by Administrator on 2017/5/25.
 */
/**
 * Created by 卓原 on 2017/5/23 0023.
 * 视频榜单的item，宽度接近于屏幕，内含一个播放图标，
 * 内容有：发布时间和视频时长
 * 图下有一行标题和一组标签栏
 */
//视频主页榜单大视频ITEM
import React, {PureComponent} from 'react';
import {
    View,
    Dimensions,
    Image,
    Text,
    StyleSheet,
    FlatList,
    TouchableOpacity,
} from 'react-native';

import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';

export default class VideoLargeItem extends PureComponent {
    render() {
        let item = this.props.item;
        return (
            <TouchableOpacity activeOpacity={1} style={styles.container} onPress={() => this.pressbtn()}>
                <Image source={{uri:item.img}} style={styles.outsideimg}>
                    <View style={styles.center}>
                        <Image source={require('../Img/shoppingPage/Icon_play_@3x.png')} style={styles.insideimg}/>
                    </View>
                    <View style={styles.space}>
                        <Text style={styles.whitetext} allowFontScaling={false}>今日{item.releasetime}发布</Text>
                        <Text style={styles.whitetext} allowFontScaling={false}>{item.long}</Text>
                    </View>
                </Image>
                <View style={styles.marginT}>
                    <Text style={styles.title} numberOfLines={1} allowFontScaling={false}>{item.title}</Text>
                    <View style={styles.thislist}>
                        <FlatList
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
    pressbtn() {
    }
}
const styles = StyleSheet.create({
    container: {
        marginVertical: 5,
        padding:10

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
        marginTop: 10,
        flexDirection: 'row',
        justifyContent: 'center',
    },
    outsideimg: {
        resizeMode: 'cover',
        width: Dimensions.get('window').width -20,
        height: 150,
    },
    insideimg: {
        resizeMode: 'cover',
        width: 70,
        height: 70,
    },
    whitetext: {
        color: Colors.text_light_grey,
        fontSize: Fonts.secondary_font(),
    },
    center: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    ellipse: {
        marginHorizontal: 5,
        borderColor: Colors.text_light_grey,
        borderRadius: 10,
        borderWidth: 0.5,
        paddingHorizontal: 5,
    },
    label: {
        color: Colors.text_light_grey,
        fontSize: Fonts.tag_font(),
        margin: 1,
    },
    title: {
        fontSize: Fonts.standard_normal_font(),
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