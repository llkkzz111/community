/**
 * Created by jzz on 2017/8/16.
 * 活动浮层页面
 */

import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    TouchableOpacity,
    Modal,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
export default class AdFloatingLayer extends React.Component {
    static propTypes = {
        ...View.propTypes.style,
        icon: PropTypes.string,  //圆形浮层的图片
        title: PropTypes.string,       //title
        image: PropTypes.string,       //活动图片
        onClose: PropTypes.func,    //关闭的回调
        showAd: PropTypes.bool,
        showCircle: PropTypes.bool,
    }

    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
        };
    }

    /**
     * 点击圆形浮层  展示活动页面
     * @private
     */
    show() {
        this.props.onShow();
    }

    /**
     * 点击我知道了 关闭浮层
     * @private
     */
    close() {
        this.setState({
            showCircle: false,
            showAd: false,
        })
    }

    onClose() {
        this.props.onClose();
        this.close();
    }

    render() {
        const {style, icon, image, title, showAd, showCircle} = this.props;
        if (showCircle) {
            return (
                <View style={[styles.circleView, ...style]}>
                    <TouchableOpacity activeOpacity={1}
                                      onPress={() => this.show()}>
                        <Image style={styles.circleImage}
                               source={{uri: icon ? icon : 'bb'}}>
                        </Image>
                    </TouchableOpacity>
                </View>
            );
        }
        if (showAd) {
            return (
                <Modal transparent={true}
                       visible={showAd}
                       animationType={'fade'}
                       onRequestClose={() => this.close()}>
                    <View style={styles.view}>
                        <View style={styles.bgView}>
                            <View style={styles.imageAndTitle}>
                                <Image style={styles.adImage}
                                       source={{uri: image ? image : 'aa'}}></Image>
                                <Text style={styles.title1} numberOfLines={2}>{title}</Text>
                            </View>
                            <View style={styles.lineView}></View>
                            <TouchableOpacity style={styles.btnView}
                                              activeOpacity={1}
                                              onPress={() => this.onClose()}>
                                <Text style={styles.btnStyle}>我知道了</Text>
                            </TouchableOpacity>

                        </View>
                    </View>
                </Modal>
            );
        }
        return(
            <View>
            </View>
        );
    }
}
const styles = StyleSheet.create({
    view: {
        flex: 1,
        width: ScreenUtils.screenW,
        height: ScreenUtils.screenH,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: 'rgba(51,51,51,0.5)',
    },
    circleView: {
        position: 'absolute',
        top: ScreenUtils.screenH - ScreenUtils.scaleSize(300),
        left: ScreenUtils.screenW - ScreenUtils.scaleSize(170),
        width: ScreenUtils.scaleSize(130),
        height: ScreenUtils.scaleSize(130),
        borderRadius: ScreenUtils.scaleSize(65),
    },
    circleImage: {
        width: ScreenUtils.scaleSize(130),
        height: ScreenUtils.scaleSize(130),
        borderRadius: ScreenUtils.scaleSize(65),
    },
    bgView: {
        width: ScreenUtils.scaleSize(490),
        borderRadius: ScreenUtils.scaleSize(12),
        backgroundColor: Colors.background_white,
    },
    adImage: {
        width: ScreenUtils.scaleSize(450),
        height: ScreenUtils.scaleSize(250),
        backgroundColor: 'gray',
    },
    imageAndTitle: {
        marginLeft: ScreenUtils.scaleSize(20),
        marginTop: ScreenUtils.scaleSize(20),
    },
    lineView:{
        height: ScreenUtils.scaleSize(1),
        backgroundColor: '#F5A99E',
    },
    title1: {
        marginVertical: ScreenUtils.scaleSize(20),
        fontSize: ScreenUtils.scaleSize(28),
        color: Colors.text_black,
    },
    btnView: {
        height: ScreenUtils.scaleSize(80),
        width: ScreenUtils.scaleSize(490),
        borderRadius: ScreenUtils.scaleSize(12),
        alignItems: 'center',
        justifyContent: 'center',
    },
    btnStyle: {
        fontSize: ScreenUtils.scaleSize(28),
        color: Colors.text_black,
    }


});
