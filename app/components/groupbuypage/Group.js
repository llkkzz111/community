/**
 * Created by dhy on 2017/6/1.
 * 团购主界面 测试中
 * pageID  TodayGroupBuy  BrandGroup TVGroupBuy
*/

'use strict';

import {
    StyleSheet,
    Image,
    Platform
} from 'react-native';

import {
    React,
    ScreenUtils,
    Colors,
} from '../../config/UtilComponent';
import TabNavigator from 'react-native-tab-navigator';
//今日团
import TodayGroupBuy from './TodayGroupBuy';
//品牌团
import BrandGroup from './BrandGroup';
//TV团购
import TVGroupBuy from './TVGroupBuy';

//选中icon
const onTabIcons =
    [
        require('../../../foundation/Img/groupbuy/icon1_jinri_active_.png'),
        require('../../../foundation/Img/groupbuy/icon2_tvtuan_active_.png'),
        require('../../../foundation/Img/groupbuy/icon3_pinpai_active_.png'),
    ];
//未选中icon
const unTabIcons =
    [
        require('../../../foundation/Img/groupbuy/icon1_jinri_normal_.png'),
        require('../../../foundation/Img/groupbuy/icon2_tvtuan_normal_.png'),
        require('../../../foundation/Img/groupbuy/icon3_pinpai_normal_.png'),
    ];

export default class TabDemo extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            selectedTab: this.props.pageID?this.props.pageID:'TodayGroupBuy',//默认今日团购
        };
    }
    render() {
        return (
            <TabNavigator>
                <TabNavigator.Item
                    tabStyle={{justifyContent:'center'}}
                    title="今日最新"
                    selected={this.state.selectedTab === 'TodayGroupBuy'}
                    selectedTitleStyle={styles.selectedTextStyle}
                    titleStyle={[styles.textStyle,Platform.OS!=='ios'?{marginTop:ScreenUtils.scaleSize(2)}:{}]}
                    renderIcon={() => <Image source={unTabIcons[0]} style={styles.iconStyle}/>}
                    renderSelectedIcon={() => <Image source={onTabIcons[0]} style={styles.iconStyle}/>}
                    onPress={() => this.setState({ selectedTab: 'TodayGroupBuy' })}>
                    <TodayGroupBuy {...this.props}/>
                </TabNavigator.Item>
                <TabNavigator.Item
                    tabStyle={{justifyContent:'center'}}
                    title="TV团购"
                    selected={this.state.selectedTab === 'TVGroupBuy'}
                    selectedTitleStyle={styles.selectedTextStyle}
                    titleStyle={[styles.textStyle,Platform.OS!=='ios'?{marginTop:ScreenUtils.scaleSize(2)}:{}]}
                    renderIcon={() => <Image source={unTabIcons[1]} style={styles.iconStyle}/>}
                    renderSelectedIcon={() => <Image source={onTabIcons[1]} style={styles.iconStyle}/>}
                    onPress={() => this.setState({ selectedTab: 'TVGroupBuy' })}>
                    <TVGroupBuy {...this.props}/>
                </TabNavigator.Item>
                <TabNavigator.Item
                    tabStyle={{justifyContent:'center'}}
                    title="品牌团购"
                    selected={this.state.selectedTab === 'BrandGroup'}
                    selectedTitleStyle={styles.selectedTextStyle}
                    titleStyle={[styles.textStyle,Platform.OS!=='ios'?{marginTop:ScreenUtils.scaleSize(2)}:{}]}
                    renderIcon={() => <Image source={unTabIcons[2]} style={styles.iconStyle}/>}
                    renderSelectedIcon={() => <Image source={onTabIcons[2]} style={styles.iconStyle}/>}
                    onPress={() => this.setState({ selectedTab: 'BrandGroup' })}>
                    {/*<BrandGroup {...this.props}/>*/}
                    <BrandGroup {...this.props}/>
                </TabNavigator.Item>
            </TabNavigator>
        );
    }
}

const styles = StyleSheet.create({
    iconStyle:{
        width: ScreenUtils.scaleSize(41),
        height: ScreenUtils.scaleSize(40),
        resizeMode: 'contain',
    },
    textStyle:{
        color:Colors.text_dark_grey,
        fontSize: 11,
    },
    selectedTextStyle:{
        color: '#F14967',
        fontSize: 11,
    }
});
