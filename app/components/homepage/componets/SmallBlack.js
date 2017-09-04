/**
 * Created by zhuoy on 2017/5/23.
 */

import React from 'react';
import {
    Text,
    View,
    StyleSheet,
} from 'react-native';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
export default class Item extends React.PureComponent {
    constructor(props) {
        super(props);
    }

    render() {
        let item = this.props.item;
        return (

            <View style={styles.noticeRowStyle}>
                <View style={styles.noticeTagBgStyle}>
                    <Text
                        allowFontScaling={false}
                        style={styles.noticeTagTextStyle}>{item.labelName}</Text>
                </View>
                <Text
                    allowFontScaling={false}
                    numberOfLines={1}
                    style={styles.noticeTextStyle}>{item.title}</Text>
            </View>

        )
    }
}

const styles = StyleSheet.create({
    noticeRowStyle: {
        flexDirection: 'row',
        marginVertical: ScreenUtils.scaleSize(5),
        alignItems: 'center',
        backgroundColor: 'transparent',
        height: ScreenUtils.scaleSize(49),
    },
    noticeTagBgStyle: {
        backgroundColor: '#E5290D',
        borderRadius: 2,
        width: ScreenUtils.scaleSize(58),
        height: ScreenUtils.scaleSize(30),
        marginLeft: ScreenUtils.scaleSize(20),
        justifyContent: 'center',
        alignItems: 'center',
    },
    noticeTagTextStyle: {
        color: '#fff',
        fontSize: ScreenUtils.setSpText(22),
        textAlign: 'center',
        backgroundColor: 'transparent'
    },
    noticeTextStyle: {
        fontSize: ScreenUtils.setSpText(24),
        color: '#444444',
        marginLeft: ScreenUtils.scaleSize(10),
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(240)
    },
})