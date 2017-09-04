/**
 * Created by MASTERMIAO on 2017/5/20.
 * 今日团购精选部分组件
 */
'use strict'

import React, {
    PureComponent,
    PropTypes
} from 'react';

import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    ListView,
    TouchableOpacity,
    Image,
    FlatList
} from 'react-native'
import Swiper from 'react-native-swiper';
import {Actions} from 'react-native-router-flux';
import * as ScreenUtils from '../utils/ScreenUtil';
import HorizontalItem from '../common/HorizontalItem';
import Colors from '../../app/config/colors';
import TuanItem from '../../app/components/homepage/componets/TuanItem';
import GroupBuyDetails from '../../app/components/groupbuypage/GroupBuyDetails';
export default class Choiceness extends PureComponent {
    constructor(props) {
        super(props);
        this.state = {

        }
    }

    render() {
        return (
            <ScrollView style={styles.containers}>
                <Swiper
                    style={styles.swiper}
                    height={150}
                    horizontal={true}
                    paginationStyle={{bottom: 10}}
                    dot={<View style={{
                        backgroundColor: 'rgba(0,0,0,.2)',
                        width: 8,
                        height: 8,
                        borderRadius: 4,
                        marginLeft: 5,
                        marginRight: 4,
                        marginTop: 4,
                        marginBottom: 4,
                    }}/>}
                    activeDot={<View style={{
                        backgroundColor: Colors.main_color,
                        width: 8,
                        height: 8,
                        borderRadius: 4,
                        marginLeft: 5,
                        marginRight: 4,
                        marginTop: 4,
                        marginBottom: 4,
                    }}/>}
                    showsButtons={false}>
                    <Image source={require('../Img/groupbuy/banner@2x.png')} style={styles.img}/>
                    <Image source={require('../Img/groupbuy/banner@2x.png')} style={styles.img}/>
                    <Image source={require('../Img/groupbuy/banner@2x.png')} style={styles.img}/>
                    <Image source={require('../Img/groupbuy/banner@2x.png')} style={styles.img}/>
                    <Image source={require('../Img/groupbuy/banner@2x.png')} style={styles.img}/>
                    <Image source={require('../Img/groupbuy/banner@2x.png')} style={styles.img}/>
                </Swiper>
                <View style={styles.timelimitBox}>
                    <Image source={require('../Img/groupbuy/bg1@2x.png')}></Image>
                    <View style={styles.timelimitTop}>
                        <Text style={styles.timelimitText} allowFontScaling={false}>限时抢购</Text>
                        <Text style={styles.timelimitText} allowFontScaling={false}>14点场</Text>
                        <View style={styles.timeView}>
                            <View style={styles.timelimitStyle}>
                                <Text style={styles.timelimitTextStyle} allowFontScaling={false}>01</Text>
                            </View>

                            <Text style={styles.timelimitolon} allowFontScaling={false}>:</Text>
                            <View style={styles.timelimitStyle}>
                                <Text style={styles.timelimitTextStyle} allowFontScaling={false}>21</Text>
                            </View>

                            <Text style={styles.timelimitolon} allowFontScaling={false}>:</Text>
                            <View style={styles.timelimitStyle}>
                                <Text style={styles.timelimitTextStyle} allowFontScaling={false}>38</Text>
                            </View>
                        </View>
                    </View>
                    {/*<HorizontalItem />*/}
                </View>

                <View style={styles.titleViewStyle}>
                    <Image style={styles.titleImgStyles} source={require('../Img/groupbuy/Icon_iconleft_@2x.png')}/>
                    <Text style={styles.titleTextStyle} allowFontScaling={false}> 每日 0 点上新</Text>
                    <Image style={styles.titleImgStyles} source={require('../Img/groupbuy/Icon_iconright_@2x.png')}/>
                </View>

                {/*标题*/}
                <TouchableOpacity activeOpacity={1} onPress={this.GroupBuyDetails}>
                    <View style={styles.titleViewStyle}>
                        <Image source={require('../Img/groupbuy/Icon_groupbuybtn_@2x.png')}
                               style={styles.titleImgStyle}></Image>
                        <Text style={styles.titleTextStyle} allowFontScaling={false}> 人气推荐</Text>
                        {/*查看*/}
                        <View style={styles.viewStyle}>
                            <Text style={styles.viewTextStyle} allowFontScaling={false}>人气排行榜</Text>
                            <Image source={require('../Img/home/goTo.png')}
                                   style={styles.gotoImgStyle}/>
                        </View>
                    </View>
                </TouchableOpacity>
                {/*组件引用*/}
                {/*<View style={styles.flatOutView}>*/}
                {/*<FlatList*/}
                {/*horizontal="true"*/}
                {/*data={[{"key": 1}, {key: 2}, {"key": 3}, {"key": 14}, {"key": 5}]}*/}
                {/*renderItem={({item}) => <TuanItem/>}*/}
                {/*/>*/}
                {/*</View>*/}

            </ScrollView>
        )
    }
    GroupBuyDetails = () => {
        Actions.GroupBuyDetails();
    }
}

const styles = StyleSheet.create({
    containers: {
        flex: 1,
        backgroundColor: Colors.background_grey
    },
    img: {
        width:ScreenUtils.screenW,
        height:ScreenUtils.scaleSize(300)
    },
    timelimitBox:{
        width:ScreenUtils.screenW,
        height:ScreenUtils.scaleSize(522),
        marginTop:ScreenUtils.scaleSize(20)
    },
    timelimitTop:{
        flexDirection:'row',
        position:'absolute',
        height:ScreenUtils.scaleSize(100),
        backgroundColor:'transparent',
        justifyContent:'space-between',
        alignItems:'center',
    },
    timelimitStyle:{
        width:ScreenUtils.scaleSize(60),
        height:ScreenUtils.scaleSize(40),
        backgroundColor:Colors.background_white,
        borderRadius:4,
        marginLeft:ScreenUtils.scaleSize(20),
        marginRight:ScreenUtils.scaleSize(20)
    },
    timelimitTextStyle:{
        color:Colors.main_color,
        fontSize:ScreenUtils.setSpText(28),
        textAlign:'center',

    },
    timelimitText:{
        color:Colors.text_white,
        fontSize:ScreenUtils.setSpText(32),
        paddingLeft:ScreenUtils.scaleSize(30)
    }
    ,
    timelimitolon:{
        color:Colors.text_white,
        fontSize:ScreenUtils.setSpText(32)
    },
    timeView:{
        flexDirection:'row',
        marginLeft:ScreenUtils.scaleSize(90)
    },
    //标题
    titleViewStyle: {
        width: ScreenUtils.screenW,
        height: 42,
        marginTop: 10,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: Colors.background_white,

    },
    titleImgStyle: {
        width: 20,
        height: 20,
        color: Colors.text_black,
        fontSize: ScreenUtils.setSpText(32)
    },
    //标题 查看
    viewStyle: {
        flexDirection: 'row',
        position: 'absolute',
        right: 15,
        alignItems: 'center'
    },
    viewTextStyle: {
        fontSize: ScreenUtils.setSpText(26),
        color: Colors.text_light_grey
    },
    gotoImgStyle: {
        width: 11,
        height: 16
    },
})

Choiceness.propTypes = {


}
