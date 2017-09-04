/**
 * Created by jzz on 2017/6/10.
 */
/**
 * Created by jzz on 2017/6/10.
 * 全球购身份认证
 */

import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    TextInput,
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
import OrderDescriptionInfo from './OrderDescriptionInfo';
export default class OrderIDVerify extends React.Component {

    // 构造
      constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            name: undefined,
            IDValue: undefined
        };
        this.offsetY = 0;
      }

    render() {
        return (
            <View style={styles.container}
                  onLayout={({nativeEvent: {layout: {x, y, width, height}}}) => {
                      this.offsetY = y;
                  }}>
                <View style={{flexDirection:'row',alignItems:'center',marginTop: ScreenUtils.scaleSize(40)}}>
                    <Text
                        allowFontScaling={false}
                        style={styles.title}>证件信息填写</Text>
                    <TouchableOpacity activeOpacity={1} onPress={() => this.showAction('identityInfoDescription')}>
                        <Image
                            source={require('../../../foundation/Img/cart/askIcon.png')}
                            style={styles.shoppingInfoIconStyle}/>
                    </TouchableOpacity>

                </View>
                <Text
                    allowFontScaling={false}
                    style={styles.description}>(海关备案所需，请确保证件内容且与实际支付账户人信息一致)</Text>
                <TextInput
                    style={styles.textInput}
                    placeholder="请填写姓名"
                    value={this.state.name}
                    onChangeText={(text) => this.changeName(text)}
                    selectionColor={Colors.text_dark_grey}
                    underlineColorAndroid={'transparent'}
                    onFocus={() => this.props.onFocus(this.offsetY)}
                />
                <View style={styles.line}/>
                <TextInput
                    style={[styles.textInput, styles.textInput1]}
                    placeholder="请填写身份证号码"
                    value={this.state.IDValue}
                    numberOfLines={1}
                    onChangeText={(text) => this.changeIDString(text)}
                    selectionColor={Colors.text_dark_grey}
                    underlineColorAndroid={'transparent'}
                    onFocus={() => this.props.onFocus(this.offsetY)}
                />
                <View style={styles.line}/>
                <TouchableOpacity activeOpacity={1} onPress={() => {this.showAction('delegateInfo')}}>
                    <View style={styles.delegateView}>
                        <Text allowFontScaling={false} style={styles.descText}>提交订单则表示您接受东方全球购《个人委托申报协议》</Text>
                        <Image style={styles.icon}
                               source={require('../../../foundation/Img/home/store/icon_view_more_.png')}>
                        </Image>
                    </View>
                </TouchableOpacity>
                <OrderDescriptionInfo ref='OrderDescriptionInfo'/>
            </View>
        );
    }


    changeName(text) {
        this.setState({
            name: text
        });
        this.props.onNameTextChanged(text)
    }

    changeIDString(text){
        this.setState({
            IDValue: text
        });
        this.props.onIDTextChanged(text)
    }

    showAction (style) {
        this.refs.OrderDescriptionInfo.show(style)
    }

}
const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        paddingHorizontal: ScreenUtils.scaleSize(30),
        marginTop: ScreenUtils.scaleSize(20),
    },
    textInput: {
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(60),
        fontSize: ScreenUtils.scaleSize(26),
        ...Platform.select({
            ios: {
                height: ScreenUtils.scaleSize(54),
                marginTop: ScreenUtils.scaleSize(20),
            },
            android: {
                paddingTop: 5,
                paddingBottom: 5
            }
        }),
    },
    title: {
        fontSize: ScreenUtils.scaleSize(30),
        color:Colors.text_black
    },
    description: {
        marginTop: ScreenUtils.scaleSize(10),
        fontSize: ScreenUtils.scaleSize(22),
        color:Colors.text_dark_grey
    },
    line: {
        ...Platform.select({
            ios: {
                marginTop: ScreenUtils.scaleSize(10),
            },
            android: {
                marginTop: ScreenUtils.scaleSize(0),
            }
        }),
        height: ScreenUtils.scaleSize(1),
        width: ScreenUtils.screenW - ScreenUtils.scaleSize(60),
        backgroundColor: Colors.background_grey,
    },
    shoppingInfoIconStyle: {
        width: ScreenUtils.scaleSize(28),
        height: ScreenUtils.scaleSize(28),
        marginLeft: ScreenUtils.scaleSize(10),
    },
    delegateView: {
        marginVertical: ScreenUtils.scaleSize(30),
        flexDirection: 'row',
        justifyContent: 'space-between'
    },
    descImage: {
        width: ScreenUtils.scaleSize(20),
        height: ScreenUtils.scaleSize(20),
    },
    descText: {
        fontSize: ScreenUtils.scaleSize(25),
        color: Colors.text_dark_grey,
    },
    icon: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
    },
});