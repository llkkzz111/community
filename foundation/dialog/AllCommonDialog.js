/**
 * Created by yin on 2017/7/31.
 * 公共确定按钮，修改confirmdialog
 */
import React, {PropTypes} from 'react'
import {
    View,
    Text,
    StyleSheet,
    Modal,
    TouchableOpacity,
    Image
} from 'react-native';
import * as ScreenUtil from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';

export default class AllCommonDialog extends React.Component {
    static propTypes = {
        title: PropTypes.string,
        confirmText: PropTypes.string,
        cancelText: PropTypes.string,
        onConfirm: PropTypes.func,
        onCancle: PropTypes.func,
        show: PropTypes.bool,
        isCancelAble: PropTypes.bool,
        showImage: PropTypes.bool,
        innerContainer: View.propTypes.style,
    };
    static defaultProps = {
        show: false,
        isCancelAble: true,
        showImage: false
    };

    constructor(props) {
        super(props);
        this.state = {
            isShow: this.props.show
        }
    }

    render() {
        let lineStyle = null;
        let cancelText = this.props.cancelText;
        let confirmText = this.props.confirmText;
        if (cancelText && cancelText.length > 0 && confirmText && confirmText.length > 0) {
            lineStyle = styles.buttonTextLineStyle;
        }

        return (
            <Modal
                animationType="fade"
                onRequestClose={() => {
                }}
                transparent={true}
                visible={this.state.isShow}
            >
                <TouchableOpacity style={styles.contentContainer} activeOpacity={1} onPress={() => {
                    this.props.isCancelAble && this.show(false);
                }}>
                    <View style={[styles.innerContainer, this.props.innerContainer]}>
                        {this.props.showImage ?
                            <View style={{paddingTop: ScreenUtil.scaleSize(30)}}>
                                <Image
                                    style={{width: ScreenUtil.scaleSize(90), height: ScreenUtil.scaleSize(90)}}
                                    source={require('../Img/order/img_success_@2x.png')}/>
                            </View> : null}
                        <TouchableOpacity style={[styles.titleContainer, this.props.titleContainer]} activeOpacity={1}>
                            <Text style={styles.titleStyle}
                                  allowFontScaling={false}>{this.props.title || this.state.title}</Text>
                        </TouchableOpacity>
                        <View style={styles.buttonContainer}>
                            {(cancelText && cancelText.length > 0) ? (
                                <TouchableOpacity
                                    style={[styles.buttonStyle]} activeOpacity={0.8}
                                    onPress={() => {
                                        if (this.props.onCancle) this.props.onCancle();
                                        if (this.cancelCallBack) this.cancelCallBack();
                                    }}>
                                    <Text style={[styles.buttonTextStyle]}>{cancelText}</Text>
                                </TouchableOpacity>
                            ) : null}
                            {(confirmText && confirmText.length > 0) ? (
                                <TouchableOpacity
                                    style={[styles.buttonStyle, lineStyle]} activeOpacity={0.8}
                                    onPress={() => {
                                        if (this.props.onConfirm) this.props.onConfirm();
                                        if (this.confirmCallBack) this.confirmCallBack();
                                    }}>
                                    <Text style={[styles.buttonTextStyle, {fontWeight: 'bold'}]}>{confirmText}</Text>
                                </TouchableOpacity>
                            ) : null}
                        </View>
                    </View>
                </TouchableOpacity>
            </Modal>
        );
    }

    /**
     * 弹出dialog
     * @param isShow
     */
    show(isShow) {
        if (this.state.isShow !== isShow) {
            this.setState({
                isShow: isShow
            });
        }
    }

    showDialog(isShow, title, cancelCallBack, confirmCallBack) {
        if (cancelCallBack) {
            this.cancelCallBack = cancelCallBack;
        }
        if (confirmCallBack) {
            this.confirmCallBack = confirmCallBack;
        }
        if (this.state.isShow !== isShow) {
            this.setState({
                isShow: isShow,
                title: title,
            });
        }
    }
}
const styles = StyleSheet.create({
    contentContainer: {
        flex: 1,
        width: ScreenUtil.screenW,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'rgba(0,0,0,0.5)',
    },
    innerContainer: {
        width: ScreenUtil.screenW * 0.6,
        alignItems: 'center',
        backgroundColor: Colors.text_white,
        borderRadius: ScreenUtil.scaleSize(8),
    },
    titleContainer: {
        alignSelf: 'stretch',
        alignItems: 'center',
        justifyContent: 'center',
        paddingHorizontal: ScreenUtil.scaleSize(30),
        paddingVertical: ScreenUtil.scaleSize(20),
    },
    titleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtil.setSpText(28),
    },
    buttonContainer: {
        alignSelf: 'stretch',
        alignItems: 'center',
        flexDirection: 'row',
        borderTopColor: Colors.main_color,
        borderTopWidth: StyleSheet.hairlineWidth,
    },
    buttonStyle: {
        flex: 1,
        alignItems: 'center',
        justifyContent: 'center',
        paddingVertical: ScreenUtil.scaleSize(20),
    },
    buttonTextStyle: {
        fontSize: ScreenUtil.scaleSize(28),
        color: Colors.text_dark_grey,
    },
    buttonTextLineStyle: {
        borderLeftColor: Colors.main_color,
        borderLeftWidth: StyleSheet.hairlineWidth,
    }
});