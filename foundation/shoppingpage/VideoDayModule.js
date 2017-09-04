/**
 * Modify by MASTERMIAO on 2017/6/11.
 * 视频馆日历组件
 */
'use strict';

import React from 'react';

import {
    Text,
    TouchableOpacity,
    TouchableWithoutFeedback,
    View
} from 'react-native';

import styles from './styles';
const dateDelay = 2 * 24 * 60 * 60 * 1000; // 当前日期延时两天的时间间隔
export default class VideoDayModule extends React.PureComponent {
    dayCircleStyle = (isWeekend, isSelected, isToday, event) => {
        const dayCircleStyle = [styles.dayCircleFiller];
        if (isSelected) {
            if (isToday) {
                dayCircleStyle.push(styles.currentDayCircle);
            } else {
                dayCircleStyle.push(styles.selectedDayCircle);
            }
        }
        if (event) {
            if (isSelected) {
                dayCircleStyle.push(styles.hasEventDaySelectedCircle, event.hasEventDaySelectedCircle);
            } else {
                dayCircleStyle.push(styles.hasEventCircle, event.hasEventCircle);
            }
        }
        return dayCircleStyle;
    }

    dayTextStyle = (isWeekend, isSelected, isToday, event) => {
        const dayTextStyle = [styles.day];
        const {today, thisMoment} = this.props;
        if (isToday && !isSelected) {
            dayTextStyle.push(styles.currentDayText);
        } else if (isToday || isSelected) {
            dayTextStyle.push(styles.selectedDayText);
        } else if (isWeekend) {
            dayTextStyle.push(styles.weekendDayText);
        }
        if (today && thisMoment) {
            // 转换今天的时间 为毫秒数
            let todayDate = today.replace(/-/g,"/");
            let today1 = new Date(todayDate);
            today1 = today1.getTime();
            // 转化当前 要渲染的日期 为毫秒数
            let currentDate =  thisMoment.replace(/-/g,"/");
            let current = new Date(currentDate);
            current = current.getTime();
            if ((today1 + dateDelay) < current) {
                dayTextStyle.push(styles.grayColor);
            } else if ((today1 + dateDelay) >= current && today1 !== current) {
                dayTextStyle.push(styles.blackColor);
            }
        }
        if (event) {
            dayTextStyle.push(styles.hasEventText, event.hasEventText)
        }
        return dayTextStyle;
    }

    dateCanClick (today, thisMoment) {

        if (today && thisMoment) {
            // 转换今天的时间 为毫秒数
            let todayDate = today.replace(/-/g,"/");
            let today1 = new Date(todayDate);
            today1 = today1.getTime();
            // 转化当前 要渲染的日期 为毫秒数
            let currentDate =  thisMoment.replace(/-/g,"/");
            let current = new Date(currentDate);
            current = current.getTime();
            if ((today1 + dateDelay) < current) {
                return false;
            }
        }
        return true;
    }

    render() {

        let { caption, today, thisMoment } = this.props;
        let canClick = this.dateCanClick(today, thisMoment);
        const {
            filler, event, isWeekend, isSelected, isToday, showEventIndicators
        } = this.props;

        return filler
                    ?
                <TouchableWithoutFeedback>
                    <View style={styles.dayButtonFiller}>
                        <Text style={styles.day} allowFontScaling={false}/>
                    </View>
                </TouchableWithoutFeedback>
                :
                (canClick ?
                    <TouchableOpacity activeOpacity={1} onPress={this.props.onPress}>
                        <View style={[styles.dayButton, isWeekend ? styles.weekendDayButton : null]}>
                            <View style={this.dayCircleStyle(isWeekend, isSelected, isToday, event)}>
                                <Text style={this.dayTextStyle(isWeekend, isSelected, isToday, event)} allowFontScaling={false}>{caption}</Text>
                            </View>
                            {showEventIndicators && <View style={[
                                styles.eventIndicatorFiller,
                                event && styles.eventIndicator,
                                event && event.eventIndicator]} />}
                        </View>
                    </TouchableOpacity>
                    :
                    <View style={[styles.dayButton, isWeekend ? styles.weekendDayButton : null]}>
                        <View style={this.dayCircleStyle(isWeekend, isSelected, isToday, event)}>
                            <Text style={this.dayTextStyle(isWeekend, isSelected, isToday, event)} allowFontScaling={false}>{caption}</Text>
                        </View>
                        {showEventIndicators && <View style={[
                            styles.eventIndicatorFiller,
                            event && styles.eventIndicator,
                            event && event.eventIndicator]} />}
                    </View>
                )
           ;
    }
}
