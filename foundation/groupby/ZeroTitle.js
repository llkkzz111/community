/**
 * Created by lume on 2017/6/12.
 */

import React, {
    PureComponent,
    PropTypes
} from 'react'
import {
    View,
    Text,
    Image,
    Dimensions,
    TouchableOpacity,
    ScrollView,
    StyleSheet,
    FlatList
} from 'react-native'
let deviceWidth = Dimensions.get('window').width;
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
// 引入外部组件
export default class ZeroTitle extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {};
    }
    render(){
        return (
            <View style={styles.NewProductWeb}>
                {this._renderNatime()}
            </View>
        )
    }

    _renderNatime(){
        return(
            <View style={styles.NewProductHead}>
                <Image
                    source={require('../Img/groupbuy/Icon_iconleft_@2x.png')}
                    style={{
                        width:ScreenUtils.scaleSize(33),
                        height:ScreenUtils.scaleSize(31)
                    }}
                />
                <Text style={styles.newTimeGoods} allowFontScaling={false}>每日 0 点上新</Text>
                <Image
                    source={require('../Img/groupbuy/Icon_iconright_@2x.png')}
                    style={{
                        width:ScreenUtils.scaleSize(33),
                        height:ScreenUtils.scaleSize(31)
                    }}
                />
            </View>
        )
    }
}
const styles = StyleSheet.create({
    NewProductWeb:{
        width:deviceWidth,
    },
    NewProductHead:{
        flexDirection:"row",
        width:deviceWidth,
        height:ScreenUtils.scaleSize(100),
        justifyContent:"center",
        alignItems:'center',
        backgroundColor:Colors.text_white,
        marginTop:ScreenUtils.scaleSize(20)
    },
    newTimeGoods:{
        color:"#ED1C41",
        fontSize:ScreenUtils.scaleSize(30),
        marginRight:ScreenUtils.scaleSize(20),
        marginLeft:ScreenUtils.scaleSize(20)
    },
    NewProductStyle:{
        backgroundColor:Colors.text_white,
        borderTopColor:Colors.background_grey,
        borderTopWidth:1,
        flexDirection:"row",
        flexWrap:'wrap',
    },

})