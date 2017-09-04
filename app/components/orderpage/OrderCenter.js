/**
 * created by zhenzhen
 * 订单中心主页
 */

'use strict';
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    FlatList,
    Platform,
    Text,
    Dimensions,
    DeviceEventEmitter
} from 'react-native';
import ScrollableTabView, {ScrollableTabBar} from '../../../foundation/common/scrollabletabview';
import NavigationBar from '../../../foundation/common/NavigationBar';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';
import Styles from './Styles';
import Datas from './Datas';
import {Actions}from 'react-native-router-flux';
import {
    backPress as TDbackPress,
    onTabClick as TDOnTabClick,
}from './OrderTdUtils';
export default class OrderCenter extends Component {
    static propTypes = {
        pageId: PropTypes.number,
    }
    static defaultProps = {
        pageId: 0,
    }

    constructor(props) {
        super(props);
        this.state = {
            firstTime: 0,
            secondTime: 0,
            flag: true,
        };
        this.pageRefs = [];
        this.orderPage = this.props.pageId;
    }

    render() {
        return (
            <View style={styles.container}>
                {/*渲染navbar*/}
                {this._renderNavbar()}
                {/*主内容模块*/}
                <ScrollableTabView
                    initialPage={this.orderPage}
                    style={styles.contentStyle}
                    renderTabBar={() => <ScrollableTabBar />}
                    locked={true}
                    onChangeTab={(currentPage, pageNumber) => {
                        if(this.orderPage ===currentPage.i){
                            return;
                        }
                        this.orderPage=currentPage.i;
                        TDOnTabClick(this.orderPage);
                        if(this.pageRefs&&this.pageRefs.length>0){
                            let pageRef=this.pageRefs[currentPage.i];
                            if(pageRef&&pageRef.refresh){
                                pageRef.refresh(true);
                            }
                        }
                    }}
                    tabBarActiveTextColor={Styles.tabStyle.tabBarActiveTextColor}
                    tabBarBackgroundColor={Styles.tabStyle.tabBarBackgroundColor}
                    tabBarUnderlineStyle={Styles.tabStyle.tabBarUnderlineStyle}
                >
                    {Datas.components.map((item, index)=> {
                        return (
                            <item.component
                                key={index}
                                tabLabel={ item.tabLabel}
                                ref={(ref)=>{
                                    this.pageRefs[index] = ref}
                                }
                                proc_state={item.procState}
                                page={index}
                            />
                        );
                    })}
                </ScrollableTabView>
            </View>
        );
    }

    /**
     * 渲染navbar
     * @private
     */
    _renderNavbar() {
        return (
            <NavigationBar
                title={'订单中心'}
                navigationStyle={{...Platform.select({ios: {marginTop: -22}})}}
                titleStyle={{
                    color: Colors.text_black,
                    backgroundColor: 'transparent',
                    fontSize: ScreenUtils.scaleSize(36)
                }}
                barStyle={'dark-content'}
                onLeftPress={()=>{
                    TDbackPress(this.orderPage);
                    this._onBackClick();
                }}
            />
        );
    }

    componentDidMount() {
        //取消订单等操作需要刷新列表
        DeviceEventEmitter.addListener(Datas.flags.refrushOrder, (event = {refresh: true})=> {
            if (this.pageRefs && this.pageRefs.length > 0) {
                let pageRef = this.pageRefs[this.orderPage];
                if (pageRef && pageRef.refresh) {
                    pageRef.refresh(event.refresh);
                }
            }
        });
    }

    /**
     * 点击返回按钮，限制点击频率，防止多次快速点击返回按钮导致路由引起的崩溃
     * @private
     */
    _onBackClick() {
        let date = new Date(); //点击后首先获取当前时间
        let seconds = date.getTime(); //返回从 1970 年 1 月 1 日至今的毫秒数。
        if (this.state.flag) {
            this.setState({
                firstTime: seconds,
                flag: false
            });
        } else {
            this.setState({
                secondTime: seconds,
                flag: true
            });
        }
        if (this.state.secondTime === 0) { //第一次点击时
            Actions.pop();
        } else { //如果是第二次点击时，就进行时间间隔控制
            if (Math.abs(this.state.secondTime - this.state.firstTime) > 1000) //如果两次点击间隔大于1秒
            {
                Actions.pop();
            } else { //如果两次点击间隔小于1秒

            }
        }
    }

}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        flex: 1,
        backgroundColor: Colors.background_grey
    },
    contentStyle: {
        width: ScreenUtils.screenW,
        flex: 1,
        marginTop: ScreenUtils.scaleSize(1),
    }
});

