/**
 * Modify by MASTERMIAO on 2017/6/11.
 * 视频馆日历组件
 */
'use strict';

import React from 'react';

import {
    Dimensions,
    ScrollView,
    Text,
    View,
    StyleSheet
} from 'react-native';

import VideoDayModule from './VideoDayModule';

import moment from 'moment';
import styles from './styles';

const DEVICE_WIDTH = Dimensions.get('window').width;
const VIEW_INDEX = 1;
let currentIndex = 1;
let lastIndex = 1;
let leftCount = 0;
let rightCount = 0;
import * as ScreenUtil from '../../foundation/utils/ScreenUtil';

export default class CalendarModule extends React.PureComponent {

    state = {
        currentMoment: moment(this.props.startDate),
        selectedMoment: moment(this.props.selectedDate),
        rowHeight: null
    }


    componentWillMount() {
        // this.setState ({
        //         currentMoment: moment(this.props.startDate),
        //         selectedMoment: moment(this.props.selectedDate),
        //         rowHeight: null
        //     })
        // this.monthDates = this.getStack(this.state.currentMoment);
        this.monthDates = this.getStack(this.state.currentMoment);
    }

    componentDidMount() {
        setTimeout(() => this.scrollToItem(VIEW_INDEX), 0);
    }

    // componentDidUpdate() {
    //     this.scrollToItem(VIEW_INDEX);
    // }

    componentWillUnmount() {
        currentIndex = 1;
        lastIndex = 1;
        leftCount = 0;
        rightCount = 0;
    }
    componentWillReceiveProps(nextProps) {
        if (nextProps.selectedDate && this.props.selectedDate !== nextProps.selectedDate) {
            this.setState({selectedMoment: nextProps.selectedDate});
        }
        if (nextProps.currentMonth) {
            this.setState({currentMoment: moment(nextProps.currentMonth)});
        }
    }

    getStack(currentMoment) {
        let i = -VIEW_INDEX;
        const res = [];
        for (i; i <= VIEW_INDEX; i++) {
            res.push(moment(currentMoment).add(i, 'month'));
        }
        return res;
    }

    prepareEventDates(eventDates, events) {
        const parsedDates = {};
        if (events) {
            events.forEach(event => {
                if (event.date) {
                    parsedDates[event.date] = event;
                }
            });
        } else {
            eventDates.forEach(event => {
                parsedDates[event] = {};
            });
        }
        return parsedDates;
    }

    selectDate(date) {
        if (this.props.selectedDate === undefined) {
            this.setState({
                selectedMoment: date,
                currentMoment: date
            });
        }
    }

    scrollToItem(itemIndex) {
        const scrollToX = itemIndex * this.props.width;
        this._calendar.scrollTo({y: 0, x: scrollToX, animated: false});
    }

    scrollEnded(event) {
        const position = event.nativeEvent.contentOffset.x;
        if (position === 0) {
            currentIndex = 0;
            leftCount += 1;
        } else if (position === 2 * ScreenUtil.screenW) {
            currentIndex = 2;
            rightCount += 1;
        } else if (position === ScreenUtil.screenW) {
            currentIndex = 1;
            rightCount = 0;
            leftCount = 0;
        }
        const currentPage = position / this.props.width;
        if (leftCount <= 1 && rightCount <= 1) {
            if (currentIndex === 1) {
                if (lastIndex === 2) {
                    const newMoment = moment(this.state.currentMoment).add(currentPage - 2, 'month');
                    this.setState({currentMoment: newMoment});
                }
                if (lastIndex === 0) {
                    const newMoment = moment(this.state.currentMoment).add(1, 'month');
                    this.setState({currentMoment: newMoment});
                }
            } else {
                if (leftCount > 0) {
                    const newMoment = moment(this.state.currentMoment).add(currentPage - 1, 'month');
                    this.setState({currentMoment: newMoment});
                }
                if (rightCount > 0) {
                    const newMoment = moment(this.state.currentMoment).add(1, 'month');
                    this.setState({currentMoment: newMoment});
                }
                // const newMoment = moment(this.state.currentMoment).add(currentPage - 1, 'month');
                // this.setState({currentMoment: newMoment});
            }

        }
        lastIndex = currentIndex;

    }

    onWeekRowLayout = (event) => {
        if (this.state.rowHeight !== event.nativeEvent.layout.height) {
            this.setState({rowHeight: event.nativeEvent.layout.height});
        }
    }

    getStartMoment(calFormat, currMoment) {
        let res = moment(currMoment).startOf('month');
        return res;
    }

    renderCalendarView(calFormat, argMoment, eventsMap) {
        let renderIndex = 0, weekRows = [], days = [];
        const
            startOfArgMoment = this.getStartMoment(calFormat, argMoment),
            selectedMoment = moment(this.state.selectedMoment),
            weekStart = this.props.weekStart,
            todayMoment = moment(this.props.today),
            argDaysCount = argMoment.daysInMonth(),
            offset = (startOfArgMoment.isoWeekday() - weekStart + 7) % 7;
        do {
            const dayIndex = renderIndex - offset;
            const isoWeekday = (renderIndex + weekStart) % 7;
            const thisMoment = moment(startOfArgMoment).add(dayIndex, 'day');
            if (dayIndex >= 0 && dayIndex < argDaysCount) {
                days.push((
                    <VideoDayModule
                        startOfMonth={startOfArgMoment}
                        isWeekend={isoWeekday === 0 || isoWeekday === 6}
                        key={`${renderIndex}`}
                        onPress={() => {
                            this.selectDate(thisMoment);
                            this.props.onDateSelect && this.props.onDateSelect(thisMoment ? thisMoment.format() : null);
                        }}
                        caption={`${thisMoment.format('D')}`}
                        thisMoment={thisMoment.format('YYYY-MM-DD')}
                        today={todayMoment.format('YYYY-MM-DD')}
                        isToday={todayMoment.format('YYYY-MM-DD') == thisMoment.format('YYYY-MM-DD')}
                        isSelected={selectedMoment.isSame(thisMoment)}
                        event={eventsMap[thisMoment.format('YYYY-MM-DD')] ||
                        eventsMap[thisMoment.format('YYYYMMDD')]}
                        showEventIndicators={this.props.showEventIndicators}/>
                ));
            } else {
                days.push(<VideoDayModule key={`${renderIndex}`} filler/>);
            }
            if (renderIndex % 7 === 6) {
                weekRows.push(
                    <View key={weekRows.length}
                          onLayout={weekRows.length ? undefined : this.onWeekRowLayout}
                          style={styles.weekRow}>
                        {days}
                    </View>);
                days = [];
                if (dayIndex + 1 >= argDaysCount) {
                    break;
                }
            }
            renderIndex += 1;
        } while (true)
        const containerStyle = styles.monthContainer;
        return <View key={`${startOfArgMoment.format('YYYY-MM-DD')}-${calFormat}`} style={containerStyle}>
            {weekRows}
        </View>;
    }

    renderHeading() {
        let headings = [];
        let i = 0;
        for (i; i < 7; ++i) {
            const j = (i + this.props.weekStart) % 7;
            headings.push(
                <Text key={i}
                      style={styles.weekendHeading} allowFontScaling={false}>
                    {this.props.dayHeadings[j]}
                </Text>
            );
        }
        return (
            <View style={styles.calendarHeading}>
                {headings}
            </View>
        );
    }

    render() {
        const calendarDates = this.monthDates;
        const eventDatesMap = this.prepareEventDates(this.props.eventDates, this.props.events);
        let localizedMonth = this.props.monthNames[this.state.currentMoment.month()];
        return (
            <View style={styles.calendarContainer}>
                {this.renderHeading(this.props.titleFormat)}
                <View style={stylee.yearDate}>
                    <Text style={stylee.dayDate} allowFontScaling={false}>
                        {String(this.state.currentMoment.year())}年{localizedMonth}
                    </Text>
                </View>
                <ScrollView
                    alwaysBounceVertical={false}
                    alwaysBounceHorizontal={false}
                    ref={calendar => this._calendar = calendar}
                    horizontal
                    pagingEnabled
                    removeClippedSubviews={this.props.removeClippedSubviews}
                    scrollEventThrottle={50}
                    showsVerticalScrollIndicator={false}
                    showsHorizontalScrollIndicator={false}
                    automaticallyAdjustContentInsets={false}
                    onMomentumScrollEnd={(event) => this.scrollEnded(event)}
                    style={stylee.sc}>
                    {calendarDates.map((date) => this.renderCalendarView(this.props.calendarFormat, moment(date), eventDatesMap))}
                </ScrollView>
            </View>
        );
    }
}

const stylee = StyleSheet.create({
    yearDate: {
        width: DEVICE_WIDTH,
        height: ScreenUtil.scaleSize(88),
        justifyContent: 'center'
    },
    dayDate: {
        // width: ScreenUtil.scaleSize(175),
        height: ScreenUtil.scaleSize(42),
        position: 'absolute',
        right: ((DEVICE_WIDTH / 7)) / 2 - 5,
        fontSize: 14,
        textAlign: 'center',
        color: 'black'
    },
    sc: {
        height: ScreenUtil.scaleSize(730)
    }
});

CalendarModule.defaultProps = {
    customStyle: {},
    width: DEVICE_WIDTH,
    dayHeadings: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
    eventDates: [],
    monthNames: ['1月', '2月', '3月', '4月', '5月',
        '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    nextButtonText: '下个月',
    prevButtonText: '上个月',
    removeClippedSubviews: true,
    scrollEnabled: true,
    showControls: false,
    showEventIndicators: false,
    startDate: moment().format('YYYY-MM-DD'),
    titleFormat: 'MMMM YYYY',
    weekStart: 1,
    calendarFormat: 'monthly'
}
