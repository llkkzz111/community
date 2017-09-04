/**
 * Created by dongfanggouwu-xiong on 2017/5/24.
 */
'use strict';

import React, {
    Component,
    PropTypes
} from 'react';

import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image
} from 'react-native';


export default class OderMixpool extends Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <TouchableOpacity activeOpacity={1}>
                <View style={styles.buttonStyleView}>
                    <Image
                        style={styles.imaStyle}
                        source={require('../../foundation/Img/order/Icon_call_@2x.png')}
                    />
                    <Text allowFontScaling={false} style={styles.buttonStyle}>联系客服</Text>
                </View>
            </TouchableOpacity>
        )
    }
}

const styles = StyleSheet.create({
    buttonStyleView:{
        padding:10,
        marginBottom:10,
        backgroundColor:'#FFFFFF',
        flexDirection:'row',
        alignItems:'center',
        justifyContent: 'center',
        height:50,
},
    imaStyle:{
        width:20,
        height:20,
        alignItems:"center"
    },
    buttonStyle:{
        marginLeft:10,
        textAlign:'center'
    }

});