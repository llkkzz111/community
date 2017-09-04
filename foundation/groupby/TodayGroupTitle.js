/**
 * Created by lu weiguo on 2017/6月3号.
 * 今日团购页面导航栏组件
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
    FlatList,
    Touchable,
    TouchableHighlight,
    Platform
} from 'react-native'
let width = Dimensions.get('window').width;
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
import ScrollableTabView, {ScrollableTabBar,DefaultTabBar} from 'react-native-scrollable-tab-view';
export default class TodayGroupTitle extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
        };
    }
    onClickTitle(obj){
        let dt={
            index:obj.i,
            destinationUrl:this.props.titles[obj.i]?this.props.titles[obj.i].destinationUrl:"",
            destinationUrlType:this.props.titles[obj.i]?this.props.titles[obj.i].destinationUrlType:"",
        }
        this.props.onClickTitle(dt);
    }
    render() {
        let titles = this.props.titles;
        return (
            <View style={styles.todayGroupStyle}>
                <ScrollableTabView
                    locked={false}
                    renderTabBar={() => <ScrollableTabBar style={{
                        height: ScreenUtils.scaleSize(88)
                    }}
                    tabStyle={{
                        height: ScreenUtils.scaleSize(88)
                    }}/>}
                    tabBarActiveTextColor="#ED1C41"
                    tabBarInactiveTextColor="#666666"
                    tabBarUnderlineStyle={{backgroundColor: '#ED1C41', height: 2}}
                    tabBarBackgroundColor="transparent"
                    scrollWithoutAnimation={Platform.OS === 'android'}
                    // tabBarTextStyle={{
                    //     display: 'flex',
                    //     // al: 'center',
                    //     // lineHeight: ScreenUtils.scaleSize(10),
                    //     justifyContent: 'center'
                    // }}
                     onChangeTab={(obj) => {
                         this.onClickTitle(obj)
                     }}
                >
                    {titles.map((item,index) =>{
                        return(
                            <TouchableOpacity
                                activeOpacity={1}
                                style={styles.listTitle}
                                tabLabel={item.title}
                                destinationUrl={item.destinationUrl}
                                destinationUrlType={item.destinationUrlType}
                                key={index}
                            >
                            </TouchableOpacity>
                        )
                    })
                    }
                </ScrollableTabView>
            </View>
        )
    }
    /**
     * 渲染分类标题
     */
}
const styles = StyleSheet.create({
    todayGroupStyle:{
        width: width,
        height: ScreenUtils.scaleSize(88),
        backgroundColor: 'white',
        borderBottomWidth: 1,
        borderBottomColor: '#DDDDDD'
    },
    todayGroupTitleBg:{
        width: width,
        height:ScreenUtils.scaleSize(88),
    },
    todayNameStyle:{
        width:width,
        height:ScreenUtils.scaleSize(88),
        backgroundColor: 'transparent',
    },
    tabNameStyle:{
        backgroundColor: 'transparent',
        fontSize:ScreenUtils.setSpText(28),
        color:Colors.text_white,
        opacity:0.8,
        marginLeft:ScreenUtils.scaleSize(15),
        marginRight:ScreenUtils.scaleSize(15),
        // alignSelf:"center",
    },
    firstTabNameStyle:{
        marginLeft:ScreenUtils.scaleSize(30)
    },
    lastTabNameStyle:{
        marginRight:ScreenUtils.scaleSize(30)
    },
    selectedTabName:{
        opacity:1,
    },
    todayNameBox:{
        // borderBottomWidth:2,
        // borderBottomColor:Colors.text_white,
        // alignItems:"center",
        // justifyContent:"center"
    },
    listTitle:{
        height: ScreenUtils.scaleSize(88),
        backgroundColor: 'transparent',
    }
})
