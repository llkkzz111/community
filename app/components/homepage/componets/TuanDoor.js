/**
 * Created by 卓原 on 2017/6/25.
 *
 */
import React, { Component, PureComponent } from 'react';
import {
    Text,
    View,
    StyleSheet,
    Image,
    TouchableOpacity,
} from 'react-native';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import Colors from '../../../config/colors';
import PressTextColor from 'FOUNDATION/pressTextColor';

const Com = __DEV__ ? Component : PureComponent;

export  default  class TuanDoor extends Com {

    constructor(props) {
        super(props);
        this.state = {
            times: ['00', '00', '00', '00', '00', '00'],
        }
    }

    componentWillUnmount() {
        clearInterval(this.interval);//移除计时器
    }

    componentDidMount() {
        let data = this.props.data;
        let distance = (Number(data[0].playDateLong) - Number(data[0].curruntDateLong)) / 1000;//毫秒转秒
        this.timeStart(distance);
    }

    timeStart(distance) {
        if (distance > 0) {
            this.interval = setInterval(() => {
                if (distance <= 0) {
                    clearInterval(this.interval);
                }//时间到
                this.setState({
                    times: ScreenUtils.getRemainingimeDistance(distance),//获取时间数组
                });
                distance--;
            }, 1000);
        }
    }

    render() {
        let data = this.props.data;
        return (
            <View style={{
                borderTopWidth: StyleSheet.hairlineWidth,
                borderTopColor: '#dddddd',
                flexDirection: 'row',
                width: ScreenUtils.screenW,
                justifyContent: 'space-around'
            }}>
                {data.map((item, index) => {
                    return (
                        <PressTextColor
                            key={index + item.codeValue}
                            onPress={() => this.props.onClick({index: {index}.index, codeValue: item.codeValue})}>
                            <View style={item.playDateLong ? styles.tuanView1 : styles.tuanView2}>
                                <Text
                                    allowFontScaling={false}
                                    style={item.playDateLong ? styles.tuanTextRed : styles.tuanText}>{item.title}</Text>
                                {item.playDateLong ?
                                    <View style={{flexDirection: 'row', marginHorizontal: ScreenUtils.scaleSize(20)}}>
                                        <View style={styles.timeText}>
                                            <Text
                                                allowFontScaling={false}
                                                style={styles.text}>{this.state.times[3]}</Text>
                                        </View>
                                        <Text
                                            allowFontScaling={false}
                                            style={{
                                            color: '#FF7F96',
                                            fontSize: ScreenUtils.setSpText(28),
                                            marginHorizontal: ScreenUtils.scaleSize(5)
                                        }}>:</Text>
                                        <View style={styles.timeText}>
                                            <Text
                                                allowFontScaling={false}
                                                style={styles.text}>{this.state.times[4]}</Text>
                                        </View>
                                        <Text
                                            allowFontScaling={false}
                                            style={{
                                            color: '#FF7F96',
                                            fontSize: ScreenUtils.setSpText(28),
                                            marginHorizontal: ScreenUtils.scaleSize(5)
                                        }}>:</Text>
                                        <View style={styles.timeText}>
                                            <Text
                                                allowFontScaling={false}
                                                style={styles.text}>{this.state.times[5]}</Text>
                                        </View>
                                    </View> : null}
                                <Image
                                    style={[styles.tuanImg, index === 0 ? {
                                        width: ScreenUtils.scaleSize(236),
                                    } : null]}
                                    source={{uri: item.firstImgUrl ? item.firstImgUrl : '11'}}/>
                            </View>
                        </PressTextColor>
                    )
                })}
            </View>
        )
    }
}

const styles = StyleSheet.create({
    tuanView1: {
        alignItems: 'center',
        paddingBottom: ScreenUtils.scaleSize(10),
        width: ScreenUtils.scaleSize(276),
        height: ScreenUtils.scaleSize(220),
        backgroundColor: '#fff'
    },
    tuanView2: {
        alignItems: 'center',
        paddingBottom: ScreenUtils.scaleSize(10),
        width: (ScreenUtils.screenW - ScreenUtils.scaleSize(276) - 2)    / 2,
        height: ScreenUtils.scaleSize(220),
        backgroundColor: '#fff'
    },
    tuanText: {
        margin: ScreenUtils.scaleSize(10),
        width: (ScreenUtils.screenW - 4) / 3 - 20,
        fontSize: ScreenUtils.setSpText(28),
        //lineHeight: ScreenUtils.scaleSize(40),
        color: '#333'
    },
    tuanTextRed: {
        margin: ScreenUtils.scaleSize(10),
        width: (ScreenUtils.screenW - 2) / 3 - 10,
        fontSize: ScreenUtils.setSpText(28),
        color: '#E5290D'
    },
    tuanImg: {
        resizeMode: 'contain',
        flex: 1,
        width: ScreenUtils.scaleSize(222),
        height: ScreenUtils.scaleSize(138),
        marginHorizontal: ScreenUtils.scaleSize()
    },
    timeText: {
        flex: 1,
        justifyContent: 'center',
        backgroundColor: '#FF8399',
        borderRadius: ScreenUtils.scaleSize(4),
    },
    text: {
        textAlign: 'center',
        color: '#fff',
        backgroundColor: "rgba(0,0,0,0)"
    }
})
