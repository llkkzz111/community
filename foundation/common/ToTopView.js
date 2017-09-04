/**
 * Created by Lzy on 2017/7/21.
 */
import React from 'react';
import {
    View,
    Image,
    Text,
    StyleSheet
} from 'react-native';
import * as ScreenUtils from '../utils/ScreenUtil';

export default class ToTopView extends React.Component {

    render() {
        return (
            <View style={styles.outView}>
                <Image source={require('../Img/common/Btn_ZhiDing_.png')}
                />
                <Text style={styles.textStyle}>顶部</Text>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    outView: {
        width: ScreenUtils.scaleSize(80),
        height: ScreenUtils.scaleSize(80),
        backgroundColor: '#fff',
        opacity: 0.9,
        borderRadius: ScreenUtils.scaleSize(40),
        borderWidth: ScreenUtils.scaleSize(2),
        borderColor: '#D4D4D4',
        alignItems: 'center',
        justifyContent: 'center'
    },
    jImage: {
        width: ScreenUtils.scaleSize(32),
        height: ScreenUtils.scaleSize(23),
    },
    textStyle: {
        color: '#333',
        fontSize: ScreenUtils.setSpText(20),
        marginTop: ScreenUtils.scaleSize(5)
    }
});