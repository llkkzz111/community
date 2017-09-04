/**
 * Created by 张恭 on 2017/5/18.
 *
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    Image,
    ScrollView,
    Dimensions,
    StyleSheet,
    TouchableOpacity
} from 'react-native';

import Fonts from '../../app/config/fonts';

export default class SendTime extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            sendTimeText: this.props.sendTimeText,
            // imgData: this.props.imgData
        }
    }

    componentWillReceiveProps(nextProps) {
        // this.setState({ imgData: nextProps.dataSource });
    }

    render() {
        let {sendTimeText} = this.props;
        return (
            <TouchableOpacity activeOpacity={1} onPress={() => {this.props.openMenu()}} style={styles.sendTimeView}>
                <Text allowFontScaling={false} style={styles.sendTimeText}>{sendTimeText}</Text>
                <Text allowFontScaling={false} style={styles.changeText}>修改 ＞</Text>
            </TouchableOpacity>
        )
    }
}

const styles = StyleSheet.create({
    sendTimeView:{
        padding:10,
        flexDirection:'row',
        justifyContent:'space-between',
        backgroundColor:'#FFFFFF'
    },
    sendTimeText:{
        color:'#333333',
        fontSize:Fonts.standard_normal_font(),

    },
    changeText:{
        color:'#666666',
        fontSize:Fonts.secondary_font(),
    }
});