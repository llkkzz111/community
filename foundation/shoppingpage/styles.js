/**
 * Modify by MASTERMIAO on 2017/6/11.
 * 视频馆日历组价的样式组件
 */
import { Dimensions, StyleSheet } from 'react-native';

const DEVICE_WIDTH = Dimensions.get('window').width;

import Colors from '../../app/config/colors';

import * as ScreenUtil from '../../foundation/utils/ScreenUtil';

const styles = StyleSheet.create({
    calendarContainer: {
        backgroundColor: 'white'
    },
    monthContainer: {
        width: DEVICE_WIDTH,
    },
    calendarControls: {
        flexDirection: 'row'
    },
    controlButton: {

    },
    controlButtonText: {
        margin: 10,
        fontSize: 15
    },
    title: {
        flex: 1,
        margin: 10
    },
    titleText: {
        textAlign: 'center',
        fontSize: 15
    },
    calendarHeading: {
        width: DEVICE_WIDTH,
        height: ScreenUtil.scaleSize(88),
        flexDirection: 'row',
        borderBottomWidth: 1,
        borderColor: Colors.line_grey,
        justifyContent: 'center',
        alignItems: 'center'
    },
    dayHeading: {
        flex: 1,
        fontSize: 15,
        textAlign: 'center',
        marginVertical: 5
    },
    weekendHeading: {
        flex: 1,
        fontSize: 13,
        textAlign: 'center',
        color: '#cccccc'
    },
    weekRow: {
        flexDirection: 'row'
    },
    weekendDayButton: {
        // backgroundColor: '#fafafa'
    },
    dayButton: {
        alignItems: 'center',
        padding: 5,
        width: DEVICE_WIDTH / 7,
        borderTopWidth: 1,
        borderTopColor: '#e9e9e9'
    },
    dayButtonFiller: {
        padding: 5,
        width: DEVICE_WIDTH / 7
    },
    day: {
        fontSize: 16,
        alignSelf: 'center'
    },
    eventIndicatorFiller: {
        marginTop: 3,
        borderColor: 'transparent',
        width: 4,
        height: 4,
        borderRadius: 2
    },
    eventIndicator: {
        backgroundColor: '#cccccc'
    },
    dayCircleFiller: {
        justifyContent: 'center',
        backgroundColor: 'transparent',
        width: 28,
        height: 28,
        borderRadius: 14
    },
    currentDayCircle: {
        backgroundColor: 'red'
    },
    currentDayText: {
        color: '#E5270D'
    },
    selectedDayCircle: {
        backgroundColor: 'blue'
    },
    hasEventCircle: {

    },
    hasEventDaySelectedCircle: {

    },
    hasEventText: {

    },
    selectedDayText: {
        color: 'white',
        fontWeight: 'bold'
    },
    grayColor: {
        color: '#dddddd',
    },
    blackColor: {
        color: 'black',
    },
    weekendDayText: {
        // color: '#cccccc'
    }
});

export default styles;