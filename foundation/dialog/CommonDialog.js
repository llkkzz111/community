import React from "react";
import {connect} from "react-redux";
import {Dimensions, Modal, Image, StyleSheet, Text, View, TouchableOpacity} from "react-native";
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
const {width, height} = Dimensions.get('window');
/**
 * @author Xiang
 *
 * 通用弹窗框
 * @example
 * <pre>
 *  &lt;CommonDialog
 *      title="默认标题"
 *      show={this.state.showDialog}
 *      buttons={[
 *          {text: '加入购物车', color: '#DAA520', onClicked: () =&gt; {alert('加入购物车')}},
 *          {text: '立即购买', color: 'orange',},
 *          ]}
 *      setVisible={(show) =&gt; {
 *         if (show) {
 *          this.setState({showDialog: false,});
 *          }
 *          }}&gt;
 *      &lt;Text style={{height: 150,color:'white'}}&gt;通用弹窗&lt;/Text&gt;
 *  &lt;/CommonDialog&gt;
 *</pre>
 */
class CommonDialog extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            show: this.props.show,
        }
    }

    componentWillReceiveProps(nextProps) {
        if (nextProps.show != this.state.show) {
            this.setState({show: nextProps.show});
        }
    }

    render() {
        return (
            <Modal animationType="fade"
                   onRequestClose={() => {
                   }}
                   transparent={true}
                   style={CommonDialogStyle.container}
                   visible={this.state.show}>
                <View style={CommonDialogStyle.contentContainer}>
                    <Text
                        onPress={() => {
                            this.props.closeDialog()
                        }}
                        style={{flex: 1}} allowFontScaling={false}/>
                    <View style={CommonDialogStyle.titleContainer}>
                        <Text style={CommonDialogStyle.titleLeft} allowFontScaling={false}/>
                        <Text style={CommonDialogStyle.dialogTitleText} allowFontScaling={false}>{this.props.title}</Text>
                        <TouchableOpacity style={CommonDialogStyle.dialogClose}
                                          activeOpacity={1}
                                          onPress={() => {
                                              this.props.closeDialog()
                                          }}>
                            <Image style={CommonDialogStyle.closeImg}
                                   source={require('../Img/dialog/icon_close_@3x.png')}/>
                        </TouchableOpacity>
                    </View>
                    <View style={CommonDialogStyle.bodyContainer}>
                        {this.props.children}
                    </View>
                    <View style={CommonDialogStyle.btnContainer}>
                        {
                            this.props.buttons.map((item, id) => {
                                return (
                                    <TouchableOpacity
                                        key={item.text + id}
                                        onPress={item.autoClose ? () => this.setState({show: false}) : item.onClicked}
                                        activeOpacity={1}
                                        style={{
                                            justifyContent: 'center',
                                            alignItems: 'center',
                                            backgroundColor: item.bg,
                                            height: ScreenUtils.scaleSize(100),
                                            flex: 1
                                        }}>
                                        <Text allowFontScaling={false} style={[CommonDialogStyle.buttonText, {
                                            color: item.color,
                                            backgroundColor: item.bg,
                                        }]}
                                              key={id}
                                        >{item.text}</Text>
                                    </TouchableOpacity>
                                )
                            })
                        }
                    </View>
                </View>
            </Modal>
        );
    }
}
const CommonDialogStyle = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'flex-end',
    },
    contentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        justifyContent: 'flex-end',
        width: width,
        height: height
    },
    titleContainer: {
        paddingLeft: 16,
        paddingRight: 16,
        paddingTop: 16,
        paddingBottom: 4,
        backgroundColor: 'white',
        justifyContent: 'center',
        alignItems: 'center',
        flexDirection: 'row',
    },
    bodyContainer: {
        backgroundColor: 'white',
    },
    btnContainer: {
        backgroundColor: 'white',
        justifyContent: 'center',
        flexDirection: 'row',
        alignItems: 'center',
    },
    titleLeft: {
        flex: 1,
    },
    dialogTitleText: {
        flex: 1,
        textAlign: 'center',
        textAlignVertical: 'center',
        justifyContent: 'center',
        alignItems: 'center',
        color: '#333',
        fontSize: ScreenUtils.setSpText(30),
    },
    closeImg: {
        width: 15,
        height: 15,
    },
    dialogClose: {
        flex: 1,
        alignItems: 'flex-end',
        justifyContent: 'flex-end'
    },
    buttonText: {
        color: 'white',
        textAlign: 'center',
        textAlignVertical: 'center',
        alignItems: 'center',
        fontSize: ScreenUtils.setSpText(30),
    },
});

export default connect(state => ({}),
    dispatch => ({})
)(CommonDialog)
