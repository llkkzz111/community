/**
 * Created by MASTERMIAO on 2017/6/11.
 * 视频馆日历组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    TouchableOpacity,
    ScrollView,
    FlatList,
    Modal
} from 'react-native';

const { width } = Dimensions.get('window');

import * as ScreenUtil from '../../foundation/utils/ScreenUtil';

import CalendarModule from './CalendarModule';

const customDayHeadings = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
const customMonthNames = ['1月', '2月', '3月', '4月', '5月',
    '6月', '7月', '8月', '9月', '10月', '11月', '12月'];


export default class VideoCalendarModule extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            show: this.props.show
        }
        this._closeModal = this._closeModal.bind(this);

    }

    componentWillReceiveProps(nextProps) {
        this.setState({ show: nextProps.show });
    }

    render() {
        const customer = {
            calendarContainer: {

            }
        }
        return (
            <Modal transparent={true}
                   visible={this.state.show}
                   style={styles.containers}
                   animationType={'fade'}
                   onRequestClose={() => { this._closeModal()}}>
                <View style={styles.bg}>
                    <View style={styles.dateBg}>
                        <CalendarModule
                            ref="calendar"
                            scrollEnabled
                            showControls
                            dayHeadings={customDayHeadings}
                            monthNames={customMonthNames}
                            titleFormat={'MMMM YYYY'}
                            prevButtonText={'上个月'}
                            nextButtonText={'下个月'}
                            onDateSelect={(date) => this.setState({ selectedDate: date })}
                            customStyle={customer}

                            // onTouchPrev={(e) => console.log('onTouchPrev: ', e)}
                            // onTouchNext={(e) => console.log('onTouchNext: ', e)}
                            // onSwipePrev={(e) => console.log('onSwipePrev: ', e)}
                            // onSwipeNext={(e) => console.log('onSwipeNext', e)}
                            />
                    </View>
                </View>
            </Modal>
        )
    }

    _closeModal() {
        this.setState({ show: false });
        this.props.closeModal(false);
    }
}

const styles = StyleSheet.create({
    containers: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        // justifyContent: 'flex-end'
    },
    dateBg: {
        width: width,
        height: ScreenUtil.scaleSize(670)
    },
    bg: {
        flex: 1,
        // justifyContent: 'flex-end',
        position: 'absolute',
        top: ScreenUtil.scaleSize(216),
        backgroundColor: 'rgba(0, 0, 0, 0.5)'
    },



})

VideoCalendarModule.propTypes = {
    show: React.PropTypes.bool,
    closeModal: React.PropTypes.func
}