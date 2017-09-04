/**
 * Created by jzz on 2017/6/14.
 * 描述类信息的底部弹窗
 */


import React  from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    ScrollView,
    TouchableOpacity,
    Modal,
    StatusBar,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import data from './OrderDescriptionDatas'
export default class OrderDescriptionInfo extends React.Component {

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isVisible: false,
            showType: undefined,
        };
    }

    /**
     * 展示描述信息
     * @private
     */
    show(type) {
        this.setState({
            isVisible: true,
            showType: type,
        });
    }

    /**
     * 关闭当前描述信息
     * @private
     */
    _close() {
        this.setState({
            isVisible: false
        });
    }

    render() {
        let title, smallTitle, context = '';
        if (this.state.showType) {
            title = data[this.state.showType].title
            smallTitle = data[this.state.showType].smallTitle
            context = data[this.state.showType].context;
        }
        return (
            <Modal transparent={true}
                   visible={this.state.isVisible}
                   animationType={'fade'}
                   onRequestClose={() => this.close()}>
                <View style={styles.view1}>
                    <Text
                        allowFontScaling={false}
                        style={styles.overlay} onPress={() => this._close()}/>
                    <View style={styles.container1}>
                        <View style={styles.titleView}>
                            <Text
                                allowFontScaling={false}
                                style={styles.title}>{title}</Text>
                        </View>
                        <TouchableOpacity activeOpacity={1} style={styles.rightImgView} onPress={() => this._close()}>
                            <Image style={styles.rightImg}
                                   source={require('../../../foundation/Img/dialog/icon_close_@3x.png')}/>
                        </TouchableOpacity>
                        <View style={styles.smallTitleView}>
                            <Text
                                allowFontScaling={false}
                                style={styles.smallTitle}>{smallTitle}</Text>
                        </View>
                        <ScrollView style={styles.contextView}>
                            <Text
                                allowFontScaling={false}
                                style={styles.context}>{context}</Text>
                        </ScrollView>
                        <TouchableOpacity activeOpacity={1} onPress={() => this._close()}>
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
                </View>
            </Modal>
        );
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
                height: ScreenUtils.screenH - StatusBar.currentHeight + 1,
            }
        }),
        top: 0,
        position: 'absolute'
    },
    overlay: {
        position: 'absolute',
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
        opacity: 0.4,
    },
    container1: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        height: ScreenUtils.scaleSize(750),
    },
    titleView: {
        height: ScreenUtils.scaleSize(100),
        alignItems: 'center',
        justifyContent: 'center',
    },
    smallTitleView: {
        height: ScreenUtils.scaleSize(60),
        justifyContent: 'center',
        borderBottomColor: Colors.background_grey,
        borderBottomWidth: ScreenUtils.scaleSize(1),
    },
    title: {
        fontSize: ScreenUtils.scaleSize(30),
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
    contextView: {
        flex: 1,
    },
    context: {
        paddingHorizontal: ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(20),
        fontSize: ScreenUtils.scaleSize(26),
        color: Colors.text_dark_grey,
        lineHeight: ScreenUtils.scaleSize(31),
    },
    smallTitle: {
        paddingHorizontal: ScreenUtils.scaleSize(30),
        fontSize: ScreenUtils.scaleSize(28),
        color: Colors.text_black,
    }

});