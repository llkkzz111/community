/**
 * Created by MASTERMIAO on 2017/5/7.
 * 个人中心物流状态栏组件
 */
'use strict';

import React, {
    PropTypes
} from 'react';

import {
    View,
    Text,
    Dimensions,
    TouchableOpacity,
    ScrollView,
    StyleSheet
} from 'react-native';

import LogisticalItem from '../order/LogisticalItem';
import Immutable from 'immutable'
export default class LogisticalStatus extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state={
            materialFlow:this.props.materialFlow
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            materialFlow:nextProps.materialFlow
        });
    }

    shouldComponentUpdate(nextProps,nextState){
        return !Immutable.is(this.state.materialFlow,nextProps.materialFlow)
    }

    render() {
        return (
        <View style={{backgroundColor:"#F5F5F5"}}>
            <ScrollView horizontal={true}
                        showsHorizontalScrollIndicator={false}>
                <View style={styles.goodsInfo}>
                    {
                        this.state.materialFlow.map((data, index) => {
                            return (
                                <LogisticalItem dataSource={data} key={index}/>
                            )
                        })
                    }
                </View>
            </ScrollView>
        </View>
        )
    }
}

const styles = StyleSheet.create({
    goodsInfo: {
        flexDirection: 'row',
        flex: 1,
        backgroundColor: '#F5F5F5',
    },
})

LogisticalStatus.propTypes = {}
