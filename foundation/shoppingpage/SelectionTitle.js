/**
 * Created by Administrator on 2017/5/25.
 */
//视频主页分类精选栏目
'use strict';

import React from 'react'
import {
    View,
    StyleSheet,
    FlatList
} from 'react-native'
import ScrollableTabView, {ScrollableTabBar} from 'react-native-scrollable-tab-view';
import SelectionItem from './SelectionItem';
import * as ScreenUtil from '../utils/ScreenUtil';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';

export default class SelectionTitle extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {}
    }

    // render 渲染页面
    render() {
        let {selections} = this.props;
        // console.log('===============' + selections);
        return (
            <View style={styles.orderCenter}>
                <ScrollableTabView
                    renderTabBar={() => <ScrollableTabBar
                        style={{borderBottomWidth: StyleSheet.hairlineWidth, borderBottomColor: '#ddd'}}/>}
                    style={{backgroundColor: Colors.background_white}}
                    //tabBarTextStyle={}
                    tabBarBackgroundColor={Colors.text_white}
                    tabBarUnderlineStyle={{backgroundColor: Colors.main_color, height: 2}}
                    tabBarInactiveTextColor={Colors.text_dark_grey}
                    //tabBarUnderlineColor='#E5290D'
                    tabBarActiveTextColor={Colors.main_color}
                    initialPage={0}

                    ref={(tabView) => {
                        this.tabView = tabView;
                    }}
                    // onChangeTab={(obj) => {
                    //     this.onChangeTab(obj);
                    // }}
                    // page = {this.state.toTabIndex}
                >
                    {
                        selections ? selections.map((list, i) => {
                            if (list.componentList && list.componentList.length > 1 &&
                                list.componentList[1].componentList) {
                                return (
                                    <View key={i} tabLabel={list.componentList[0].title}>
                                        <FlatList
                                            keyExtractor={this._keyExtractor}
                                            scrollEnabled={false}
                                            data={list.componentList[1].componentList}
                                            renderItem={({item, index}) => {
                                                return (
                                                    <View style={{backgroundColor: Colors.line_grey}}>
                                                        <SelectionItem selectionItem={item} selectionItemClick={(v)=>{
                                                            this.props.pressbtn(v);
                                                        }}/>
                                                    </View>
                                                )
                                            }}>
                                        </FlatList>
                                    </View>
                                )
                            }

                        })

                            :
                            null }

                </ScrollableTabView>
            </View>
        )
    }

}

const styles = StyleSheet.create({
    orderCenter: {
        flex: 1,
        backgroundColor: Colors.background_grey,
    },
});
