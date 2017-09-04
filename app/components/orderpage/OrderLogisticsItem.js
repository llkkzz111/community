/**
 * Created by pactera on 2017/7/31.
 *
 * 订单中心物流详情页Item
 */

'use strict';
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Text,
    FlatList,
    TouchableOpacity
} from 'react-native';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import Colors from '../../config/colors';

export default class OrderLogisticsItem extends Component {
    static propTypes = {
        ...View.propTypes,
        title: PropTypes.string,
        desc: PropTypes.string,
        circleStyle: View.propTypes.style,
        lineStyle: View.propTypes.style,
        titleStyle: Text.propTypes.style,
        descStyle: Text.propTypes.style,
        lineShow: PropTypes.bool,
    }
    static defaultProps = {
        lineShow: true,
    }
    // 构造
      constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            bgImageHeight:0,
        };
      }
    render() {
        return (
            <View style={[styles.container, this.props.style]}>
                <View style={styles.leftContainer}>
                    <View style={[styles.circleStyle, this.props.circleStyle]}/>
                    {(!!this.props.lineShow) ? (
                        <View style={[styles.lineStyle, this.props.lineStyle,{height:this.state.bgImageHeight}]}/>
                    ) : null}
                </View>
                <View style={styles.rightContainer} onLayout={(event)=>{
                     let height = event.nativeEvent.layout.height;
                     if(this.state.bgImageHeight !== height) {
                        this.setState({
                            bgImageHeight: height
                        });
                }
                }}>
                    <Text style={[styles.titleStyle, this.props.titleStyle]}
                          allowFontScaling={false}>{this.props.title}</Text>
                    <Text style={[styles.descStyle, this.props.descStyle]} allowFontScaling={false}
                          numberOfLines={2}>{this.props.desc}</Text>
                </View>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        backgroundColor: 'white',
        width: ScreenUtils.screenW,
        alignItems: 'flex-start',
        flexDirection: 'row',
    },
    leftContainer: {
        alignItems: 'center',
    },
    rightContainer: {
        flex: 1,
        marginLeft: ScreenUtils.scaleSize(30),
        marginRight: ScreenUtils.scaleSize(30),
    },
    circleStyle: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
        backgroundColor: Colors.line_grey,
        borderRadius: ScreenUtils.scaleSize(15),
    },
    lineStyle: {
        width: ScreenUtils.scaleSize(2),
        flex: 1,
        backgroundColor: Colors.orderLine,
    },
    titleStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(28),
    },
    descStyle: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.setSpText(26),
        marginTop: ScreenUtils.scaleSize(20),
    },
});