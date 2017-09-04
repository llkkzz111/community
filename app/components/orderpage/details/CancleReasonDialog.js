/**
 * Created by zhenzhen on 2017/7/31.
 * 取消订单reasondialog
 */
import React, {PropTypes} from 'react'
import {
    View,
    Text,
    StyleSheet,
    Modal,
    TouchableOpacity,
    FlatList,
    Image
} from 'react-native';
import * as ScreenUtil from '../../../../foundation/utils/ScreenUtil';
import Colors from '../../../config/colors';
import Datas from '../Datas';
var key = 0;
export default class CancleReasonDialog extends React.Component {
    static propTypes = {
        show: PropTypes.bool,
        isCancelAble: PropTypes.bool,
        onConfirmClick: PropTypes.func,
    }
    static defaultProps = {
        show: false,
        isCancelAble: true,
    }
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isShow: this.props.show,
            selectTab: Datas.cancleReasons[0].key,
        };
    }

    render() {
        return (
            <Modal
                animationType={'fade'}
                transparent={true}
                onRequestClose={() => console.log('onRequestClose...')}
                visible={this.state.isShow}
            >
                <TouchableOpacity
                    style={{flex: 1}}
                    activeOpacity={1}
                    onPress={() => {
                        this.props.isCancelAble && this.show(false);
                    }}
                >
                    <View style={{
                        flex: 1,
                        backgroundColor: 'rgba(0,0,0,0.5)',
                        alignItems: 'center'
                    }}/>
                    <View style={{
                        flex: 1,
                        position: 'absolute',
                        bottom: 0,
                        width: ScreenUtil.screenW,
                        backgroundColor: '#FFF',
                        opacity: 1,
                    }}>
                        <View style={styles.titleContainer}>
                            <View style={styles.rightImg}/>
                            <Text allowFontScaling={false} style={{
                                fontSize: ScreenUtil.setSpText(28),
                                color: Colors.text_black,
                                flex: 1,
                                textAlign: 'center',
                            }}>请选择原因</Text>
                            <TouchableOpacity activeOpacity={1} onPress={()=> {
                                this.show(false)
                            }} style={styles.rightImg}>
                                <Image
                                    style={styles.rightImg}
                                    source={require('../../../../foundation/Img/dialog/icon_close_@3x.png')}
                                />
                            </TouchableOpacity>
                        </View>
                        <View style={{backgroundColor: '#DDDDDD', width: ScreenUtil.screenW, height: 1}}/>
                        <View>
                            <FlatList
                                key={++key}
                                data={Datas.cancleReasons}
                                renderItem={({item}) => {
                                    return (
                                        <TouchableOpacity
                                            style={{width: ScreenUtil.screenW, alignItems: 'center'}}
                                            activeOpacity={1}
                                            onPress={() => this.reasonBut(item.key)}>
                                            <View style={{
                                                flexDirection: 'row',
                                                alignItems: 'center',
                                                paddingVertical: ScreenUtil.scaleSize(30)
                                            }}>
                                                <Text allowFontScaling={false}
                                                      style={styles.textCon}>{item.value}</Text>
                                                <Image
                                                    style={{width: 15, height: 15, marginRight: 20}}
                                                    source={this.state.selectTab === item.key ? require('../../../../foundation/Img/cart/selected.png') : require(
                                                        '../../../../foundation/Img/cart/unselected.png')}/>
                                            </View>
                                            <View style={{
                                                backgroundColor: '#DDDDDD',
                                                width: ScreenUtil.screenW - 40,
                                                height: 1
                                            }}/>
                                        </TouchableOpacity>
                                    );
                                }
                                }
                            />
                        </View>
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                this.show(false);
                                setTimeout(()=> {
                                    this.props.onConfirmClick && this.props.onConfirmClick(this.state.selectTab);
                                }, 200);
                            }}
                        >
                            <Image style={styles.btnImage}
                                   source={require('../../../../foundation/Img/home/globalshopping/icon_statusbg_@3x.png')}
                                   resizeMode={'cover'}>
                                <Text
                                    allowFontScaling={false}
                                    style={[{
                                        backgroundColor: 'transparent',
                                        color: '#ffffff',
                                        fontSize: ScreenUtil.scaleSize(28),
                                    }]}>
                                    确定
                                </Text>
                            </Image>
                        </TouchableOpacity>
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

    //选择原因
    reasonBut(i) {
        if (this.state.selectTab === i) {
            return;
        }
        this.setState({
            selectTab: i
        })
    }
}
const styles = StyleSheet.create({
    textCon: {
        flex: 1,
        marginLeft: 20,
        fontSize: ScreenUtil.setSpText(28),
        color: Colors.text_black,
    },
    btnImage: {
        height: 44,
        width: ScreenUtil.screenW,
        resizeMode: 'cover',
        justifyContent: 'center',
        alignItems: 'center'
    },
    titleContainer: {
        width: ScreenUtil.screenW,
        padding: 20,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
    },
    rightImg: {
        height: ScreenUtil.scaleSize(25),
        width: ScreenUtil.scaleSize(25),
    },
});