/**
 * Created by lume on 2017/6/5.
 * 今日团购页面 滚动列表组件
 *
 *
 */
'use strict';

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
import {Actions} from 'react-native-router-flux';
let deviceWidth = Dimensions.get('window').width;
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';

// 倒入人气排行榜页面
import Ranking from '../../app/components/groupbuypage/Ranking';

export default class ScrollViewHeader extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
         //   icons:'../Img/groupbuy/Icon_groupbuybtn_@2x.png',
            title:'',
            listTitle:'',
            linkUrl:'',

            flag:0,

            id:this.props.id,
            singleProductitions:this.props.singleProductitions


        };

    }

    componentWillReceiveProps(nextPros) {

    }

    render(){
        return (
            <View style={styles.scrollViewItemTitle}>
                <View style={styles.itemTitleCenter}>
                    <Image
                        source={require('../Img/groupbuy/Icon_groupbuybtn_@2x.png')}
                        style={{
                            width:ScreenUtils.scaleSize(38),
                            height:ScreenUtils.scaleSize(40)
                        }}
                    />
                    <Text style={styles.popularityStyle} allowFontScaling={false}>{this.props.title}</Text>
                </View>
                {this._clicklinks()}
            </View>
        )
    }

    /***
     *
     */
    _clicklinks(){
        if( this.props.flag === 0 ){
            return(
                <TouchableOpacity
                    activeOpacity={1}
                    onPress={()=>{this.renderPage()}}
                    style={styles.itemTitleRight}
                >
                    <Text style={styles.rankingStyle} allowFontScaling={false}>{this.props.listTitle}</Text>
                    <Image
                        source={require('../Img/groupbuy/Icon_right_gray_@2x.png')}
                        style={{
                            width:ScreenUtils.scaleSize(16),
                            height:ScreenUtils.scaleSize(24)
                        }}
                    />
                </TouchableOpacity>
            )
        }

        if( this.props.flag === 1 ){
            return(
                <TouchableOpacity
                    activeOpacity={1}
                    onPress={()=>{this.renderPage()}}
                    style={styles.itemTitleRight}
                >
                    <Text style={styles.rankingStyle} allowFontScaling={false}>{this.props.listTitle}</Text>
                    <Image
                        source={require('../Img/groupbuy/Icon_right_gray_@2x.png')}
                        style={{
                            width:ScreenUtils.scaleSize(16),
                            height:ScreenUtils.scaleSize(24)
                        }}
                    />
                </TouchableOpacity>
            )
        }
    }

    renderPage(){
        Actions.Ranking({"id":this.state.id,"singleProductitions":this.state.singleProductitions});
    }

}




const styles = StyleSheet.create({
    scrollViewItemTitle:{
        flexDirection:"row",
        height:ScreenUtils.scaleSize(105),
        alignItems:"center",
        backgroundColor:Colors.text_white,
        justifyContent:"center",
        borderBottomColor:"#dddddd",
        borderBottomWidth:1,
    },
    itemTitleCenter:{
        flexDirection:"row",
        alignItems:"center",
        justifyContent:"center",
    },
    itemTitleRight:{
        flexDirection:"row",
        position:"absolute",
        right:ScreenUtils.scaleSize(30),
    },
    popularityStyle:{
        color:Colors.text_black,
        fontSize:ScreenUtils.setSpText(32),
        marginLeft:ScreenUtils.scaleSize(10)
    },
    rankingStyle:{
        fontSize:ScreenUtils.setSpText(26),
        marginRight:ScreenUtils.scaleSize(10)
    }

})