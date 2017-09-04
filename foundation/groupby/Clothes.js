/**
 * Created by MASTERMIAO on 2017/5/20.
 * 品牌团购服饰、箱包、美妆部分组件
 */
'use strict';

import React,{
    PureComponent,
    PropTypes
} from 'react';

import {
    View,
    Text,
    ScrollView,
    FlatList,
    StyleSheet,
    Dimensions,
    TouchableOpacity
} from 'react-native';
import Colors from '../../app/config/colors';
const { width } = Dimensions.get('window');

import BrandGroupListItem from './BrandGroupListItem'

export default class Clothes extends PureComponent {
    constructor(props) {
        super(props);
    }

    render() {
        // console.log('Clothes.length=' + this.props.data.length);
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
        backgroundColor:Colors.background_grey
    },

})

Clothes.propTypes = {

}

/*[
 {
 "id":"6275971112295727104",
 "title":null,
 "codeId":"406",
 "destinationUrl":null,
 "firstImgUrl":"http://10.22.218.170:8080/cms/cms/151/05/2017/201705151041052.jpg",
 "subtitle":null,
 "contentCode":"12321",
 "shortNumber":0,
 "componentId":"19",
 "salesVolume":"90",
 "remainingDays":"4",
 "componentList":null,
 "isComponents":0,
 "codeValue":"AP1706A0003J03001F01001",
 "destinationUrlType":null
 },
 {
 "id":"6275971112295727104",
 "title":null,
 "codeId":"406",
 "destinationUrl":null,
 "firstImgUrl":"http://10.22.218.170:8080/cms/cms/151/05/2017/201705151041052.jpg",
 "subtitle":null,
 "contentCode":"3232",
 "shortNumber":1,
 "componentId":"19",
 "salesVolume":"90",
 "remainingDays":"2",
 "componentList":null,
 "isComponents":0,
 "codeValue":"AP1706A0003J03001F01001",
 "destinationUrlType":null
 },
 {
 "id":"6275971112295727104",
 "title":null,
 "codeId":"406",
 "destinationUrl":null,
 "firstImgUrl":"http://10.22.218.170:8080/cms/cms/151/05/2017/201705151041052.jpg",
 "subtitle":null,
 "contentCode":"232",
 "shortNumber":2,
 "componentId":"19",
 "salesVolume":"190",
 "remainingDays":"6",
 "componentList":null,
 "isComponents":0,
 "codeValue":"AP1706A0003J03001F01001",
 "destinationUrlType":null
 },
 {
 "id":"6275971112295727104",
 "title":null,
 "codeId":"406",
 "destinationUrl":null,
 "firstImgUrl":"http://10.22.218.170:8080/cms/cms/151/05/2017/201705151041052.jpg",
 "subtitle":null,
 "contentCode":"4323",
 "shortNumber":3,
 "componentId":"19",
 "salesVolume":"20",
 "remainingDays":"1",
 "componentList":null,
 "isComponents":0,
 "codeValue":"AP1706A0003J03001F01001",
 "destinationUrlType":null
 }
 ]*/