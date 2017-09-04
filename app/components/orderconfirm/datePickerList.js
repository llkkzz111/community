{/*/***/}
 {/** Created by jzz on 2017/6/11.*/}
 {/** 填写订单地址填写*/}

{/*import React, {PropTypes} from 'react';*/}
{/*import Immutable from 'immutable';*/}
{/*import {*/}
    {/*View,*/}
    {/*Text,*/}
    {/*StyleSheet,*/}
    {/*Image,*/}
    {/*Platform,*/}
    {/*TouchableOpacity,*/}
    {/*ScrollView,*/}
    {/*Modal*/}
{/*} from 'react-native';*/}
{/*import Colors from '../../config/colors';*/}
{/*import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';*/}
{/*export default class OrderDatePicker extends React.Component {*/}

    {/*// 构造*/}
    {/*constructor(props) {*/}
        {/*super(props);*/}
        {/*this.state = {*/}
            {/*show: false*/}
        {/*}*/}
    {/*}*/}

    {/*render() {*/}
        {/*return (*/}
            {/*<Modal transparent={true}*/}
                   {/*style={styles.modal}*/}
                   {/*visible={this.state.show}*/}
                   {/*animationType={'fade'}>*/}
                    {/*<View style={styles.bgView}>*/}
                        {/*<View style={styles.titleView}>*/}
                            {/*<Text style={styles.title}>送货时间</Text>*/}
                            {/*<TouchableOpacity onPress={() => this.closeModel()}>*/}
                                {/*<Image style={styles.rightImg} source={require('../../../foundation/Img/cart/close.png')}/>*/}
                            {/*</TouchableOpacity>*/}
                        {/*</View>*/}
                        {/*<ScrollView style={styles.listView}>*/}
                            {/*{*/}
                                {/*this.props.date.map(function (item, index) {*/}
                                    {/*<View style={styles.dateView}>*/}
                                        {/*<Text>item</Text>*/}
                                    {/*</View>*/}
                                {/*})*/}
                            {/*}*/}
                        {/*</ScrollView>*/}
                        {/*<TouchableOpacity onPress={this._confirmAddress}>*/}
                            {/*<View style={styles.submitBtn}>*/}
                                {/*<Image resizeMode={'stretch'}*/}
                                       {/*source={require('../../../foundation/Img/order/icon_orderconfirm_topbar_.png')}*/}
                                       {/*style={styles.btnBgImg}/>*/}
                                {/*<Text style={styles.submitTitle}> 确定 </Text>*/}
                            {/*</View>*/}
                        {/*</TouchableOpacity>*/}
                    {/*</View>*/}
                {/**/}
            {/*</Modal>*/}

        {/*);*/}
    {/*}*/}

    {/*show () {*/}
        {/*this.setState({*/}
            {/*show: true*/}
        {/*})*/}
    {/*}*/}

    {/*/***/}
     {/** 隐藏modal*/}
     {/** @private*/}

    {/*closeModel () {*/}

        {/*this.setState({*/}
            {/*show: false*/}
        {/*})*/}
    {/*}*/}
{/*}*/}
{/*const styles = StyleSheet.create({*/}
    {/*modal: {*/}
        {/*flex: 1,*/}
        {/*justifyContent: 'flex-end',*/}
        {/*backgroundColor: 'rgba(0, 0, 0, 0.5)'*/}
    {/*},*/}
    {/*bgView: {*/}
        {/*width: ScreenUtils.screenW,*/}
        {/*backgroundColor: Colors.text_white,*/}
        {/*width: ScreenUtils.scaleSize(666),*/}
    {/*},*/}
    {/*titleView: {*/}
        {/*height: ScreenUtils.scaleSize(100),*/}
        {/*alignItems: 'center',*/}
        {/*justifyContent: 'center',*/}

    {/*},*/}
    {/*title: {*/}
        {/*fontSize: ScreenUtils.scaleSize(30),*/}
    {/*},*/}
    {/*listView: {*/}

    {/*},*/}
    {/*rightImg: {*/}
        {/*position: 'absolute',*/}
        {/*marginTop: ScreenUtils.scaleSize(40),*/}
        {/*marginRight: ScreenUtils.scaleSize(40),*/}
    {/*},*/}
    {/*submitBtn: {*/}
        {/*height: ScreenUtils.scaleSize(88),*/}
        {/*width: ScreenUtils.screenW*/}
    {/*},*/}
    {/*flatList: {*/}
        {/*flex: 1,*/}
    {/*},*/}
    {/*btnBgImg: {*/}
        {/*width: ScreenUtils.screenW,*/}
        {/*height: ScreenUtils.scaleSize(88),*/}
    {/*},*/}
    {/*submitTitle: {*/}
        {/*position: 'absolute',*/}
        {/*alignSelf: 'center',*/}
        {/*marginTop: ScreenUtils.scaleSize(23),*/}
        {/*fontSize: ScreenUtils.scaleSize(30),*/}
        {/*backgroundColor: 'transparent',*/}
        {/*color: Colors.text_white,*/}
    {/*},*/}
    {/*dateView: {*/}
        {/*height:  ScreenUtils.scaleSize(80),*/}
        {/*fontSize: ScreenUtils.scaleSize(30),*/}
        {/*backgroundColor: 'red'*/}
    {/*},*/}
    {/*view: {*/}
        {/*flex: 1,*/}
    {/*}*/}
{/*});*/}

/**
 * Created by MASTERMIAO on 2017/5/16.
 *  订单填写页面的选择送货时间Dialog组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    Platform,
    TouchableOpacity,
    Modal,
    ScrollView,
    ListView,
    InteractionManager,
    FlatList
} from 'react-native';

const { width, height } = Dimensions.get('window');
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
let deliveryTime;
let currentId = 0;
let ds;

export default class DeliveryTime extends React.PureComponent {
    constructor(props) {
        super(props)
        ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        this.state = {
            isVisible: false,
            dataSource: ds.cloneWithRows(this.props.appointDateListData),
        }
    }
    render() {
        return (
            <Modal transparent={true}
                   style={styles.dtContainer}
                   visible={this.state.isVisible}
                   animationType={'fade'}
                   onRequestClose={() => this.closeModal()}>
                <View style={styles.dtContentContainer}>
                    <View style={styles.dtContainers}>
                        <View style={styles.firstBuyDiscountTitle}>
                            <Text
                                allowFontScaling={false}
                                style={styles.title}>送货时间</Text>
                            <TouchableOpacity style={styles.backImg} activeOpacity={1} onPress={() => this.closeModal()}>
                                <Image style={styles.rightImg} source={require('../../../foundation/Img/cart/close.png')} />
                            </TouchableOpacity>
                        </View>
                        <View style={styles.datePickerViewBg}>
                            <ListView dataSource={this.state.dataSource}
                                      style={styles.datePickerBg}
                                      renderRow={this._renderRow} />
                        </View>
                        <TouchableOpacity activeOpacity={1} onPress={() => this.closeModal()} style={styles.bottomBg}>
                            <Text
                                allowFontScaling={false}
                                style={styles.confirmStyle}>确定</Text>
                        </TouchableOpacity>
                    </View>
                </View>
            </Modal>
        )
    }

    closeModal = () => {
        this.setState({
            isVisible: false
        });
        // this.props.callBackMethod(deliveryTime);
    };

    show() {
        this.setState({
            isVisible: true
        });
    }

    _renderRow = (rowData, sectionID, rowID) => {
        let { date_day_t, weekdayDescr } = rowData
        return (
            <TouchableOpacity activeOpacity={1}
                              onPress={() => this._click(date_day_t + weekdayDescr)}
                              style={styles.dateListViewItemStyle}>
                <Text
                    allowFontScaling={false}
                    style={styles.firstMenuItem}>rowData</Text>
            </TouchableOpacity>
        )
    }

    _click = (param) => {
        deliveryTime = param;
    }
}

const styles = StyleSheet.create({
    dtContainer: {
        flex: 1,
        justifyContent: 'flex-end',
        backgroundColor: 'rgba(0, 0, 0, 0.5)'
    },
    dtContainers: {
        flex: 1,
        backgroundColor: 'white',
        justifyContent: 'flex-end',
        marginTop: height - 400
    },
    dtContentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        justifyContent: 'flex-end',
        width: width,
    height: height
    },
    imgStyle: {
        width: 17,
        height: 17,
        marginLeft: 10
    },
    rightImg: {
        width: 15,
        height: 15
    },
    title: {
        color: '#666666',
        fontSize: 13
    },
    firstBuyDiscountTitle: {
        width: width,
        height: 30,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'white',
        flexDirection: 'row'
    },
    bottomBg: {
        width: width,
        height: 50,
        backgroundColor: '#E5290D',
        alignItems: 'center',
        justifyContent: 'center'
    },
    dateListViewItemStyle: {
        flexDirection: 'row',
        borderColor: '#DDDDDD',
        borderWidth: 0.65,
        alignItems: 'center',
        justifyContent: 'center',
        height: 30
    },
    datePickerBg: {
        width: width,
        height: 300,
        maxHeight: 300
    },
    datePickerViewBg: {
        width: width,
        height: 300,
        flexDirection: 'row'
    },
    timeStyle: {
        fontSize: 12,
        color: '#E5290D'
    },
    timeStyle2: {
        fontSize: 12,
        color: 'black'
    },
    backImg: {
        position: 'absolute',
        right: 10
    },
    dateSectionStyle: {
        width: width - 230,
        height: 300,
        flexDirection: 'column',
        borderTopWidth: 1,
        borderTopColor: '#DDDDDD'
    },
    generalItemStyle: {
        height: 30,
        alignItems: 'center',
        justifyContent: 'center'
    },
    thirdMenuBg: {
        width: 100,
        borderTopWidth: 1,
        borderTopColor: '#DDDDDD'
    },
    confirmStyle: {
        fontSize: 13,
        color: 'white'
    },
    firstMenuItem: {
        color: 'black',
        fontSize: 12
    },
    firstMenuItem2: {
        color: '#E5290D',
        fontSize: 12
    }
});

DeliveryTime.propTypes = {
    deliveryTimeList: React.PropTypes.any,
    appointDateListData: React.PropTypes.any,
    callBackMethod: React.PropTypes.func
}
