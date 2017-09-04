/**
 * Created by MASTERMIAO on 2017/5/20.
 * 品牌团购家电、家居、厨具部分组件
 */
'use strict';

import React,{
    PureComponent,
    PropTypes
} from 'react';

import {
    StyleSheet,
    View,
    Text,
    ScrollView,
    FlatList,
    Dimensions,
    TouchableOpacity
} from 'react-native';

const { width } = Dimensions.get('window');

import BrandGroupListItem from './BrandGroupListItem'
import TVGroupListItem from './TVGroupListItem'
import Colors from '../../app/config/colors';
export default class Electrical extends PureComponent {
    constructor(props) {
        super(props);
        this.state = {

        }
    }

    render() {
        // console.log('Electrical.length=' + this.props.data.length);
        return (
            <FlatList
                horizontal={false}
                data={this.props.data}
                renderItem={({item}) => (
                    <BrandGroupListItem data={item}/>
                )}
            />
        )
    }


}

const styles = StyleSheet.create({
    containers: {
        flex: 1,
        backgroundColor: Colors.background_grey
    },

})

Electrical.propTypes = {

}