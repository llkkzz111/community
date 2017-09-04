/**
 * Created by MASTERMIAO on 2017/6/11.
 * 视频馆日期标题导航组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    StyleSheet,
    Dimensions,
    TouchableOpacity,
    ScrollView
} from 'react-native';

import Colors from '../../app/config/colors';

const { width } = Dimensions.get('window');

import * as ScreenUtil from '../utils/ScreenUtil';

import Immutable from 'immutable';

let tim, year, toMonth, day;

import moment from 'moment';

export default class VideoDateTitle extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            currentIndex: this.props.select
        }
        this.initDate = this.initDate.bind(this);
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.select !== this.state.currentIndex) {
            this.setState({
                currentIndex: nextProps.select
            });
        }
    }

    render() {
        tim = null;
        year = null;
        toMonth = null;
        day = null;
        this.initDate();
        let { titleData } = this.props;
        return (
            <View showsHorizontalScrollIndicator={false}
                        alwaysBounceVertical={false}
                        alwaysBounceHorizontal={false}>
                <View style={styles.bg}>
                    {titleData !== null && titleData.length > 0 &&
                        titleData.map((it, index) => {
                            let object = Immutable.fromJS(it);
                            let title;
                            let display = object.get('title')
                            let cYear = object.get('year');
                            let now = year + '-' + parseInt(toMonth) + '-' + day;
                            let titleNow = cYear + '-' + object.get('title').replace('月', '-').replace('日', '');
                            let nextDay = parseInt(day) + 1;
                            let tomorrow = year + '-' + parseInt(toMonth) + '-' + nextDay;
                            if (now === titleNow) {
                                title = '今日';
                            } else if (tomorrow === titleNow) {
                                title = '明日';
                            } else {
                                title = object.get('title');
                            }
                            return (
                                <TouchableOpacity key={index} activeOpacity={1}
                                                  onPress={() => {this._selectTitleIndex(index, cYear, display)}} style={styles.dateBgStyle}>
                                    <Text style={index === this.state.currentIndex ? styles.selectedIndexStyle : styles.dateStyle} allowFontScaling={false}>{title}</Text>
                                    {index === this.state.currentIndex &&
                                            <View style={styles.titleBottom} />}
                                </TouchableOpacity>
                            )
                        })
                    }
                </View>
            </View>
        )
    }

    initDate() {
        tim = moment().format('YYYY-MM-DD').toString();
        year = tim.substring(0, 4);
        toMonth = tim.substring(5, 7);
        day = tim.substring(8, 10);
    }

    _selectTitleIndex = (index, year, title) => {
        this.setState({ currentIndex: index });
        let timer = year + '-' + title.toString().replace('月', '-').replace('日', '');
        this.props.dateCallBack(timer);
        this.props.indexCallBack(index);
    }

    componentWillUnmount() {
        tim = null;
        year = null;
        toMonth = null;
        day = null;
    }
}

const styles = StyleSheet.create({
    selectedIndexStyle: {
        width: ScreenUtil.scaleSize(118),
        height: ScreenUtil.scaleSize(40),
        fontSize: 13,
        textAlign: 'center',
        color: '#E5270D'
    },
    dateBgStyle: {
        width: ScreenUtil.scaleSize(133),
        height: ScreenUtil.scaleSize(88),
        justifyContent: 'center',
        alignItems: 'center'
    },
    dateStyle: {
        width: ScreenUtil.scaleSize(118),
        height: ScreenUtil.scaleSize(40),
        fontSize: 13,
        color: Colors.text_dark_grey,
        textAlign: 'center'
    },
    titleBottom: {
        width: ScreenUtil.scaleSize(56),
        backgroundColor: '#E5270D',
        height: ScreenUtil.scaleSize(3),
        position: 'absolute',
        bottom: 0
    },
    bg: {
        flexDirection: 'row',
        flex: 1,

        alignItems:'center',
        justifyContent: 'center'
    },
    scrollBg: {
        width: width - ScreenUtil.scaleSize(88),
        height: ScreenUtil.scaleSize(88)
    }
});

VideoDateTitle.propTypes = {
    titleData: React.PropTypes.array,
    dateCallBack: React.PropTypes.func,
    indexCallBack: React.PropTypes.func
};