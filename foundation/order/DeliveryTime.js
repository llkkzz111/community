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

let deliveryTime;
let currentId = 0;
let ds;

export default class DeliveryTime extends React.PureComponent {
    constructor(props) {
        super(props)
        ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        this.state = {
            isVisible: this.props.show,
            dataSource: ds.cloneWithRows(this.props.appointDateListData),
            currentRowID: 0
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            isVisible: nextProps.show,
            dataSource: ds.cloneWithRows(this.props.appointDateListData)
        });
    }

    render() {
        return (
            <Modal transparent={true}
                   style={styles.dtContaineer}
                   visible={this.state.isVisible}
                   animationType={'fade'}
                   onRequestClose={() => this.closeModal()}>
                <View style={styles.dtContentContainer}>
                    <View style={styles.dtContainers}>
                        <View style={styles.firstBuyDiscountTitle}>
                            <Text allowFontScaling={false} style={styles.title}>送货时间</Text>
                            <TouchableOpacity activeOpacity={1} style={styles.backImg} onPress={() => this.closeModal()}>
                                <Image style={styles.rightImg} source={require('../Img/cart/close.png')} />
                            </TouchableOpacity>
                        </View>
                        <View style={styles.datePickerViewBg}>
                            <ListView dataSource={this.state.dataSource}
                                      style={styles.datePickerBg}
                                      renderRow={this._renderRow} />
                        </View>
                        <TouchableOpacity activeOpacity={1} onPress={() => this.closeModal()} style={styles.bottomBg}>
                            <Text allowFontScaling={false} style={styles.confirmStyle}>确定</Text>
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
        this.props.closeModal(false);
        this.props.callBackMethod(deliveryTime);
    }

    _renderRow = (rowData, sectionID: number, rowID: number) => {
        let { date_day_t, weekdayDescr } = rowData
        return (
            <TouchableOpacity activeOpacity={1} onPress={() => this._click(date_day_t + weekdayDescr)} style={styles.dateListViewItemStyle}>
                <Text allowFontScaling={false} style={styles.firstMenuItem}>{date_day_t}  {weekdayDescr}</Text>
            </TouchableOpacity>
        )
    }

    _click = (param) => {
        deliveryTime = param;
    }

    componentWillUnmount() {

    }
}

const styles = StyleSheet.create({
    dtContaineer: {
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
        borderTopWidth: 0.65,
        borderTopColor: '#DDDDDD'
    },
    generalItemStyle: {
        height: 30,
        alignItems: 'center',
        justifyContent: 'center'
    },
    thirdMenuBg: {
        width: 100,
        borderTopWidth: 0.65,
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
