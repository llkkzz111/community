/**
 * Created by lume on 2017/6/22.
 */
import React, {PropTypes} from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    FlatList,
    TouchableOpacity,
    Image,
} from 'react-native';
import * as ScreenUtils from '../utils/ScreenUtil';
// 请求加入购物车
export default class EmptyFavorite extends React.PureComponent {
    render() {
        return (
            <View style={styles.emptyFavorite}>
                <Image
                    style={styles.emptyImage}
                    source={require("../Img/icon_favorites_state_@3x.png")}
                />
                <Text allowFontScaling={false} style={styles.themTitle}>这年头，谁没几个心头爱</Text>
                <Text allowFontScaling={false} style={styles.cimtitle}>喜欢你见一个爱一个的样子</Text>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    emptyFavorite: {
        flex: 1,
        justifyContent: "center",
        alignItems: "center"
    },
    emptyImage: {
        width: ScreenUtils.scaleSize(369),
        height: ScreenUtils.scaleSize(219)
    },
    themTitle: {
        color: "#333333",
        fontSize: ScreenUtils.setSpText(32),
        marginTop: ScreenUtils.scaleSize(50),
        marginBottom: ScreenUtils.scaleSize(15)
    },
    cimtitle: {
        color: "#999999",
        fontSize: ScreenUtils.setSpText(26)
    }
});