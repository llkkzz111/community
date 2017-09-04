/**
 * Created by wangwenliang on 2017/6/10.
 * 商品详情中的积分
 */
import React, { Component, PureComponent } from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Dimensions,
    Modal,
    TouchableOpacity,
    ScrollView,
} from 'react-native'
const {width, height} = Dimensions.get('window');
import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

/**
* @description
* 根据开发环境选择是否要不可变数据结构
* @const {class}
*/
const Com = __DEV__ ? Component : PureComponent;

export default class JiFen extends Com {
    constructor(props) {
        super(props);
        this.state = {
            show: this.props.show,
            data: this.props.datas,
        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({show: nextProps.show});
    }

    render() {
        return (
            <Modal animationType="fade"
                   onrequestclose={() => {
                   }}
                   transparent={true}
                   style={styles.container}
                   visible={this.state.show}>
                <View style={styles.contentContainer}>
                    <Text
                        allowFontScaling={false}
                        style={{flex: 1}} onPress={() => {
                        this.props.close(false);
                    }}/>
                    <View style={styles.showContent}>

                        <View style={styles.topTitleItem1}>
                            <Text
                                allowFontScaling={false}
                                style={styles.topTitleText}>积分细则说明</Text>
                            <TouchableOpacity activeOpacity={1} onPress={() => {
                                this.props.close(false);
                            }}>
                                <Image style={styles.topImage}
                                       source={require('../../../../foundation/Img/dialog/icon_close_@3x.png')}/>
                            </TouchableOpacity>
                        </View>

                        <ScrollView style={styles.listStyle}>
                            {this.state.data.goodsDetail.saveamt_original !== null && this.state.data.goodsDetail.saveamt_original != "0.0" &&
                            <Text
                                allowFontScaling={false}
                                style={{
                                    fontSize: ScreenUtils.setSpText(26),
                                    color: '#666'
                                }}>商品原积分：{this.state.data.goodsDetail.saveamt_original + ""}</Text>
                            }

                            {this.state.data.goodsDetail.isShowNetpay != null && this.state.data.goodsDetail.isShowNetpay != "N" && this.state.data.goodsDetail.saveamt_order != "0.0" &&
                            <Text
                                allowFontScaling={false}
                                style={{
                                    fontSize: ScreenUtils.setSpText(26),
                                    color: '#666'
                                }}>在线订购所得积分：{this.state.data.goodsDetail.saveamt_original + ""}</Text>
                            }

                            {this.state.data.goodsDetail.isShowNetpay != null && this.state.data.goodsDetail.isShowNetpay !== "N" && this.state.data.goodsDetail.saveamt_pay != "0.0" &&
                            <Text
                                allowFontScaling={false}
                                style={{
                                    fontSize: ScreenUtils.setSpText(26),
                                    color: '#666'
                                }}>在线支付所得积分：{this.state.data.goodsDetail.saveamt_pay + ""}</Text>
                            }

                            {this.state.data.goodsDetail.saveamt_promo != null && this.state.data.goodsDetail.saveamt_promo != "0.0" &&
                            <Text
                                allowFontScaling={false}
                                style={{
                                    fontSize: ScreenUtils.setSpText(26),
                                    color: '#666'
                                }}>商品加赠积分：{this.state.data.goodsDetail.saveamt_promo + ""}</Text>
                            }
                            {this.state.data.goodsDetail.saveamt_promoDesc != null && this.state.data.goodsDetail.saveamt_promoDesc != "" &&
                            <Text
                                allowFontScaling={false}
                                style={{
                                    fontSize: ScreenUtils.setSpText(26),
                                    color: '#666'
                                }}>商品加赠积分描述：{this.state.data.goodsDetail.saveamt_promoDesc + ""}</Text>
                            }
                        </ScrollView>
                    </View>
                </View>
            </Modal>
        );
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
    },

    contentContainer: {
        flex: 1,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        flexDirection: 'column',
        width: width,
        height: height,
    },
    showContent: {
        width: width,
        // height:height*0.5,
        backgroundColor: 'white',
        padding: 20,
    },
    btnCancel: {
        height: 50,
        flex: 1,
        backgroundColor: "#ffb000",
        justifyContent: 'center',
        alignItems: 'center'
    },
    btnSure: {
        height: 50,
        flex: 1,
        backgroundColor: "#E5290D",
        justifyContent: 'center',
        alignItems: 'center',
    },
    topTitleItem1: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
        height: 40,
    },
    topTitleText: {
        fontSize: ScreenUtils.setSpText(30),
        color: '#666',
        marginLeft: 15,
        flex: 1,
        textAlign: 'center',
    },
    topImage: {
        width: ScreenUtils.scaleSize(22),
        height: ScreenUtils.scaleSize(22),
        flex: 0,
    },
    listStyle: {
        height: height * 0.2,
    },
});
