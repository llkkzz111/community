/**
 * Created by zhenzhen on 2017/7/27.
 * 退换货详情下面的流程组件
 */
'use strict';
import React, {Component, PropTypes} from 'react';
import {
    View,
    StyleSheet,
    Text,
} from 'react-native';
import Colors from '../../../config/colors';
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';
import OrderLogisticsItem from '../OrderLogisticsItem';
export default class ExchangeStep extends Component {
    static propTypes = {
        ...View.propTypes,
        title: PropTypes.string,
        datas: PropTypes.array,
    }

    render() {
        return (
            <View style={[styles.container, this.props.style]}>
                <View style={styles.titleContainer}>
                    <Text style={styles.titleStyle} allowFontScaling={false}>{this.props.title}</Text>
                </View>
                {/*流程模块*/}
                {(this.props.datas && this.props.datas.length > 0) ? (
                    <View style={styles.innerContainer}>
                        {this.props.datas.map((data, index) => {
                                let title = data.title;
                                let desc = data.desc;
                                let lineStyle = {backgroundColor: Colors.orderLine};
                                let circleStyle = {backgroundColor: Colors.line_grey};
                                let titleStyle = {color: Colors.text_light_grey};
                                let descStyle = {color: Colors.text_light_grey};
                                if (!!data.isError) {
                                    circleStyle = {backgroundColor: 'red'};
                                    titleStyle = {color: Colors.text_black}
                                    descStyle = {color: Colors.text_dark_grey};
                                }
                                if (!!data.isReached) {
                                    circleStyle = {backgroundColor: Colors.orderLine};
                                    titleStyle = {color: Colors.orderLine}
                                    descStyle = {color: Colors.text_dark_grey};
                                } else {

                                }
                                return (
                                    <OrderLogisticsItem
                                        key={index}
                                        title={title}
                                        desc={desc}
                                        lineShow={index !== this.props.datas.length - 1}
                                        lineStyle={lineStyle}
                                        circleStyle={circleStyle}
                                        titleStyle={titleStyle}
                                        descStyle={descStyle}
                                    />
                                );
                            }
                        )}
                    </View>
                ) : null}
            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        marginTop: ScreenUtils.scaleSize(20),
    },
    titleContainer: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        alignItems: 'center',
        flexDirection: 'row',
        padding: ScreenUtils.scaleSize(30),
    },
    titleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(26)
    },
    innerContainer: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        marginTop: ScreenUtils.scaleSize(1),
        padding: ScreenUtils.scaleSize(30),
    }
});