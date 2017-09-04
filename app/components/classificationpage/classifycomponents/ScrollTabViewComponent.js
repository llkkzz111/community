/**
 * Created by wangwenliang on 2017/8/7.
 * 商品详情中底部的 图文详情 商品细则 全部评价
 *
 */
'use strict';
import React, {Component, PureComponent} from 'react';
import {
    StyleSheet,
    View,
    Text,
    Image,
    TouchableOpacity,
    ScrollView,
    Dimensions,
    StatusBar,
    Platform,
    findNodeHandle,
    DeviceEventEmitter,
    Alert,
} from 'react-native';
//图文详情，规格参数，评价详情 组件
import PicAndText from './PicAndText';
import StandardNum from './StandardNum';
import EvaluateAll from './EvaluateAll';


//字体颜色统一引用
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

//埋点
import {DataAnalyticsModule} from '../../../config/AndroidModules';
const {width, height} = Dimensions.get('window');


/**
 * @description
 * 根据开发环境选择是否要不可变数据结构
 * @const {class}
 */
const Com = __DEV__ ? Component : PureComponent;


export default class ScrollTabViewComponent extends Com {
    constructor(props) {
        super(props);
        this.state = {
            evaPage: 0,
        };

    }


    //返回底部三个page，图文详情，规格参数，评价详情
    renderPages(allDatas) {
        switch (this.state.evaPage) {
            case 0:
                //17.1 图文详情class
                return <PicAndText allDatas={allDatas} loadFinish={() => {
                    // alert("图文详情加载完成")
                }}/>;
                break;
            case 1:
                //17.2 商品详情描述class
                return <StandardNum allDatas={allDatas} loadFinish={() => {
                    // alert("图文详情加载完成")
                }}/>;
                break;
            case 2:
                //17.3 全部评价class
                return <EvaluateAll allDatas={allDatas} loadFinish={() => {
                    // alert("图文详情加载完成")
                }}/>;
                break;
        }
    }


    // 详情tag切换
    detailTag(evaPage) {
        // 切换tag
        this.setState({evaPage});


        if (evaPage === 0) {

            //图文详情 埋点
            DataAnalyticsModule.trackEvent2("AP1706C032F012001O006001", "");
        } else if (evaPage === 1) {

            //规格参数 埋点
            DataAnalyticsModule.trackEvent2("AP1706C032F012001O006002", "");
        } else {

            //评价信息 埋点
            DataAnalyticsModule.trackEvent2("AP1706C032F012001O006003", "");
        }

        // 获取原生元素y轴位置
        setTimeout(() => {
            this.props._scrollView.scrollTo({
                y: this.props.scrollTabViewHeight - ScreenUtils.scaleSize(135),
                animated: false
            });
        }, 500);
    }


    //自己封装的scrolltabview
    render(){

        let allDatas = this.props.allDatas;

        let startX = 0;
        let startY = 0;
        let color0 = cg;
        let color1 = cg;
        let color2 = cg;
        let borderWidth0 = 0;
        let borderWidth1 = 0;
        let borderWidth2 = 0;

        switch (this.state.evaPage) {
            case 0:
                color0 = cr;
                color1 = cg;
                color2 = cg;
                borderWidth0 = 2;
                borderWidth1 = 0;
                borderWidth2 = 0;
                break;
            case 1:
                color0 = cg;
                color1 = cr;
                color2 = cg;
                borderWidth0 = 0;
                borderWidth1 = 2;
                borderWidth2 = 0;
                break;
            case 2:
                color0 = cg;
                color1 = cg;
                color2 = cr;
                borderWidth0 = 0;
                borderWidth1 = 0;
                borderWidth2 = 2;
                break;
        }

        return (
            <View>
                <View ref='detailScrollHeight' style={{
                    width: width,
                    height: ScreenUtils.scaleSize(92),
                    flexDirection: 'row',
                    justifyContent: 'center',
                    alignItems: 'center',
                    borderBottomWidth: ScreenUtils.scaleSize(0),
                    borderBottomColor: '#ddd',
                    //marginBottom:ScreenUtils.scaleSize(10)
                }}>
                    <View style={styles.tabContainer}>
                        <View style={{
                            height: ScreenUtils.scaleSize(90),
                            justifyContent: 'center',
                            alignItems: 'center',
                            borderBottomWidth: ScreenUtils.scaleSize(2),
                            borderBottomColor: this.state.evaPage === 0 ? color0 : '#fff'
                        }}>
                            <Text allowFontScaling={false} style={{
                                color: color0,
                                fontSize: ScreenUtils.setSpText(26),
                            }} onPress={this.detailTag.bind(this, 0)}>图文详情</Text>
                        </View>
                    </View>
                    <View style={styles.tabContainer}>
                        <View style={{
                            height: ScreenUtils.scaleSize(90),
                            justifyContent: 'center',
                            alignItems: 'center',
                            borderBottomWidth: ScreenUtils.scaleSize(2),
                            borderBottomColor: this.state.evaPage === 1 ? color1 : '#fff'
                        }}>
                            <Text allowFontScaling={false} style={{
                                color: color1,
                                fontSize: ScreenUtils.setSpText(26),
                            }} onPress={this.detailTag.bind(this, 1)}>规格参数</Text>
                        </View>

                    </View>
                    <View style={styles.tabContainer}>
                        <View style={{
                            height: ScreenUtils.scaleSize(90),
                            justifyContent: 'center',
                            alignItems: 'center',
                            borderBottomWidth: ScreenUtils.scaleSize(2),
                            borderBottomColor: this.state.evaPage === 2 ? color2 : '#fff'
                        }}>

                            <Text allowFontScaling={false} style={{
                                color: color2,
                                fontSize: ScreenUtils.setSpText(26),
                            }} onPress={this.detailTag.bind(this, 2)}>评价详情</Text>
                        </View>
                    </View>
                </View>
                <View
                    onStartShouldSetResponder={() => {
                        return true
                    }}
                    onResponderStart={(e) => {
                        startX = e.nativeEvent.pageX;
                        startY = e.nativeEvent.pageY;
                    }}
                    onResponderEnd={(e) => {
                        let endX = e.nativeEvent.pageX;
                        let endY = e.nativeEvent.pageY;

                        if ((endX - startX) < -ScreenUtils.scaleSize(100) && Math.abs(startY - endY) < ScreenUtils.scaleSize(100)) {
                            this.setState({evaPage: (this.state.evaPage + 1) % 3})
                        } else if ((endX - startX) > ScreenUtils.scaleSize(100) && Math.abs(startY - endY) < ScreenUtils.scaleSize(100)) {
                            let page = this.state.evaPage;
                            if (page == 0) {
                                this.setState({evaPage: 2})
                            } else if (page == 1) {
                                this.setState({evaPage: 0})
                            } else if (page == 2) {
                                this.setState({evaPage: 1});
                            }
                        }
                    }}
                >
                    {this.renderPages(allDatas)}
                </View>
            </View>
        )
    }





}


const cg = Colors.text_dark_grey;
const cr = Colors.main_color;
const styles = StyleSheet.create({

    tabContainer: {
        flex: 1,
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center'
    }
});

