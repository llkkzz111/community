/**
 * Created by Zhang.xinchun on 2017/5/10.
 * 购物车的数值组件
 */
import React, {
    PropTypes
} from 'react';

import {
    Text,
    View,
    TextInput,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity
} from 'react-native';
import {connect} from 'react-redux'
import * as ScreenUtils from '../../foundation/utils/ScreenUtil'
const maxValue = 99;
const minValue = 1;
/**
 * 购物车中入力件数组件
 */
export class InputNumberText extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            buyCnt: this.props.value,
        }
    }

    //商品数量减1
    onPlus(text) {
        let inputVal = text === '' ? minValue : parseFloat(text) === minValue ? minValue : parseFloat(text) - 1;
        this.changeState(inputVal);
        this.props.onPlus(inputVal);
    }

    //商品数量加1
    onAdd(text) {
        let inputVal = text === '' ? 1 : parseFloat(text) === maxValue ? text : parseFloat(text) + 1;
        this.changeState(inputVal);
        this.props.onAdd(inputVal);
    }

    //商品数量修改
    onChange(text) {
        let inputVal = text.trim().replace(/[^0-9]/g, '').replace(/^0+$/g, '1');
        this.changeState(inputVal);
        this.props.onChange(inputVal);
    }

    //焦点离开
    onBlur(text) {
        let inputVal = text === '' ? 1 : text;
        this.changeState(inputVal);
        this.props.onBlur(inputVal);
    }

    // 编辑完成
    onSubmitEditing(text) {
        let inputVal = text === '' ? 1 : text;
        this.changeState(inputVal);
        this.props.onSubmitEditing(inputVal);
    }

    changeState(inputVal) {
        this.setState({buyCnt: inputVal})
    }

    componentWillMount() {
        this.changeState(this.props.value);
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            buyCnt: nextProps.value,
        })
    }

    render() {
        let disableFontColor = this.props.editable ? '#999999 ' : '#333333';
        let keyboardType = Platform.OS === 'ios' ? "default" : "numeric";
        return (
            <View style={styles.inputNumberContainer}>
                <TouchableOpacity style={[styles.inputNumberLeftBtn, {width: this.props.width}]}
                                  activeOpacity={1}
                                  onPress={() => this.state.buyCnt !== minValue && this.onPlus(this.state.buyCnt)}>
                    <Image source={require('../Img/cart/Icon_minus_@3x.png')} style={styles.inputNumberLeftIcon}/>
                </TouchableOpacity>
                <TextInput
                    returnKeyType="done"
                    style={[styles.inputNumberText, {color: disableFontColor, width: this.props.inputWidth}]}
                    underlineColorAndroid={'transparent'}
                    maxLength={this.props.maxLength}
                    keyboardType={keyboardType}
                    value={this.state.buyCnt.toString()}
                    onChangeText={(text) => this.onChange(text)}
                    onSubmitEditing={() => {
                        this.onSubmitEditing(this.state.buyCnt)
                    }}
                    onBlur={() => this.onBlur(this.state.buyCnt)}
                />
                <TouchableOpacity style={[styles.inputNumberRightBtn, {width: this.props.width}]}
                                  activeOpacity={1}
                                  onPress={() => this.state.buyCnt !== maxValue && this.onAdd(this.state.buyCnt)}>
                    <Image source={require('../Img/cart/Icon_add_@3x.png')} style={styles.inputNumberRightIcon}/>
                </TouchableOpacity>
            </View>
        );
    }
}
//样式定义
const styles = StyleSheet.create({
        inputNumberContainer: {
            flexDirection: 'row',
            borderWidth: 1,
            borderColor: '#999999',
            justifyContent: 'center',
            alignItems: 'center',
            height: ScreenUtils.scaleSize(55),
            borderRadius: 2,
            flex: 1,
            marginTop: ScreenUtils.scaleSize(5),
        },
        inputNumberLeftBtn: {
            alignItems: 'center',
            justifyContent: 'center',
            flex: 1,
            height: ScreenUtils.scaleSize(50),
        },
        inputNumberRightBtn: {
            alignItems: 'center',
            justifyContent: 'center',
            flex: 1,
            height: ScreenUtils.scaleSize(50),
        },
        inputNumberText: {
            height: ScreenUtils.scaleSize(55),
            flex: 1,
            padding: ScreenUtils.scaleSize(2),
            textAlign: 'center',
            color: '#333333',
            borderRightColor: '#979797',
            borderRightWidth: 1,
            borderLeftWidth: 1,
            borderLeftColor: '#979797',
        },
        inputNumberLeftIcon: {
            height: 2,
            width: 8,
            resizeMode: Image.resizeMode.stretch
        },
        inputNumberRightIcon: {
            height: 10,
            width: 10,
            resizeMode: Image.resizeMode.stretch
        }

    }
)
InputNumberText.propTypes = {
    onPlus: PropTypes.func,
    onAdd: PropTypes.func,
    onChange: PropTypes.func,
    onBlur: PropTypes.func,
    inputWidth: PropTypes.number,
    width: PropTypes.number,
}
InputNumberText.defaultProps = {
    maxLength: 2,
    inputWidth: 40,
    width: 30,
}
export default InputNumberText
