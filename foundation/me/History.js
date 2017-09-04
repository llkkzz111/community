/**
 * Created by Administrator on 2017/5/7.
 */


import React from 'react';
import {
    StyleSheet,
    Text,
    View,
} from 'react-native';

export default class History extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            nameRecommend:this.props.nameRecommend
        };
    }
    render() {
        return (
            <View style={styles.motherStyle}>
                <Text allowFontScaling={false} style={styles.motherStyleText}>· 近一个月 浏览足迹  ·</Text>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    motherStyle: {
        height: 45,
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: '#FFFFFF',
        borderBottomColor:"#dddddd",
        borderBottomWidth:0.5,
    },
    motherStyleText: {
        color: "#333333",
        fontSize: 15
    }
});
