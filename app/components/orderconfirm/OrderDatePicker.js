/**
 * Created by jzz on 2017/6/11.
 * 订单配送时间选择
 */

import React  from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    ListView,
    Modal,
    DeviceEventEmitter,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';

let index = 0;

export default class OrderDatePicker extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isVisible: false,
            flag: ''
        };
    }

    componentWillUnmount() {
        DeviceEventEmitter.removeListener('FRESH_PACKAGEDATE');
    }

    /**
     * 展示当前选择的日期列表
     * @private
     */
    show(index1) {
        index = index1;
        this.setState({
            isVisible: true
        });
    }

    /**
     * 关闭当前展示的日期列表
     * @private
     */
    close() {
        this.setState({
            isVisible: false
        });
    }
    render() {
        let ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        let dataSource = ds.cloneWithRows(this.props.data[index] && this.props.data[index].appointData ? this.props.data[index].appointData : [])
        return (
            <Modal transparent={true}
                   visible={this.state.isVisible}
                   animationType={'fade'}
                   onRequestClose={() => this.close()}>
                <TouchableOpacity activeOpacity={1}
                                  style={styles.view1}
                                  onPress={() => this.close()}>
                        <View style={styles.container1}>
                            <View style={styles.titleView}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.title}>送货时间</Text>
                            </View>
                            <TouchableOpacity activeOpacity={1} style={styles.rightImgView} onPress={() => this.close()}>
                                <Image style={styles.rightImg}
                                       source={require('../../../foundation/Img/dialog/icon_close_@3x.png')}/>
                            </TouchableOpacity>

                            <ListView dataSource={dataSource}
                                      style={styles.listView}
                                      renderRow={(rowData, sectionID, rowID) => this._renderRow(rowData, sectionID, rowID)}/>
                            <TouchableOpacity activeOpacity={1} onPress={() => this.close()}>
                                <View style={styles.submitBtn}>
                                    <Image resizeMode={'stretch'}
                                           source={require('../../../foundation/Img/order/icon_orderconfirm_topbar_.png')}
                                           style={styles.btnBgImg}/>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.submitTitle}> 确定 </Text>
                                </View>
                            </TouchableOpacity>
                        </View>
                </TouchableOpacity>
            </Modal>
        );
    }

    /**
     * 渲染日期选择列表
     * @private
     */
    _renderRow(rowData, sectionID, rowID) {
        let {date_day_t, weekdayDescr} = rowData;
        let isSelect = false;
        if (this.props.data[index].selectDate === date_day_t) {
            isSelect = true;
        }
        let noSelect = true;
        if (this.props.data[index].appointData[rowID].workyn === '1') {
            noSelect = false;
        }
        return (
            <TouchableOpacity activeOpacity={1} onPress={() => this.selectDate(rowID, date_day_t, weekdayDescr, noSelect)}>
                <View style={styles.cell}>
                    <Text
                        allowFontScaling={false}
                        style={[styles.cellText,
                        isSelect ? styles.selectTextColor : '', noSelect ? styles.noSelectColor : '']}>
                        {date_day_t} {weekdayDescr}
                    </Text>
                    {
                        isSelect ?
                            <Image style={styles.selectImage}
                                   source={require('../../../foundation/Img/dialog/item_selected@2x.png')}/>
                            :
                            <View/>
                    }
                </View>
            </TouchableOpacity>
        )
    }

    /**
     * 点击日期
     * @private
     */
    selectDate(rowId, date, weekdayDescr, noSelect) {
        if (!noSelect) {
            this.props.data[index].selectDate = date;
            this.props.data[index].date = weekdayDescr;
            this.close();
            this.props.refresh(date, weekdayDescr, index);
            DeviceEventEmitter.emit('FRESH_PACKAGEDATE', '刷新订单配送时间');
        }
    }

}
const styles = StyleSheet.create({
    modal: {
        flex: 1,
    },
    view1: {
        justifyContent: 'flex-end',
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        width: ScreenUtils.screenW,
        ...Platform.select({
            ios: {
                height: ScreenUtils.screenH
            },
            android: {
                height: ScreenUtils.screenH - 22,
            }
        }),
        top: 0,
        position: 'absolute'
    },
    container1: {
        justifyContent: 'flex-end',
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        height: ScreenUtils.scaleSize(700),
    },
    titleView: {
        height: ScreenUtils.scaleSize(100),
        alignItems: 'center',
        justifyContent: 'center',
        borderBottomColor: Colors.background_grey,
        borderBottomWidth: ScreenUtils.scaleSize(1),
    },
    title: {
        fontSize: ScreenUtils.scaleSize(30),
    },
    listView: {
        flex: 1,
    },
    rightImgView: {
        position: 'absolute',
        top: ScreenUtils.scaleSize(29),
        right: ScreenUtils.scaleSize(20),
        height: ScreenUtils.scaleSize(42),
        width: ScreenUtils.scaleSize(42),
        alignItems: 'center',
        justifyContent: 'center',
    },
    rightImg: {
        height: ScreenUtils.scaleSize(20),
        width: ScreenUtils.scaleSize(20),
    },
    submitBtn: {
        height: ScreenUtils.scaleSize(88),
        width: ScreenUtils.screenW,
    },
    btnBgImg: {
        width: ScreenUtils.screenW,
        height: ScreenUtils.scaleSize(88),
    },
    submitTitle: {
        position: 'absolute',
        alignSelf: 'center',
        marginTop: ScreenUtils.scaleSize(23),
        fontSize: ScreenUtils.scaleSize(30),
        backgroundColor: 'transparent',
        color: Colors.text_white,
    },
    cell: {
        height: ScreenUtils.scaleSize(80),
        alignItems: 'center',
        flexDirection: 'row',
        justifyContent: 'space-between',
        paddingHorizontal: ScreenUtils.scaleSize(30),
        borderBottomColor: Colors.background_grey,
        borderBottomWidth: ScreenUtils.scaleSize(1),
    },
    cellText: {
        fontSize: ScreenUtils.scaleSize(30),
    },
    selectTextColor: {
        color: Colors.text_orange,
    },
    noSelectColor: {
        color: Colors.text_light_grey,
    },
    selectImage: {
        height: ScreenUtils.scaleSize(24),
        width: ScreenUtils.scaleSize(32),
    },

});