import React, {
    PropTypes
} from 'react';
import {
    Text,
    View,
    TextInput,
    StyleSheet,
    TouchableOpacity
} from 'react-native';
import {connect} from 'react-redux'
import Colors from'../../app/config/colors'

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
            btnPlusEnable: 0,
            btnAddEnable: 0,
        }
    }

    onPlus(text) {
        let inputVal = text === '' ? minValue : text === minValue ? minValue : parseFloat(text) - 1;
        this.changeState(inputVal);
        this.props.onPlus(inputVal);
    }

    onAdd(text) {
        let inputVal = text === '' ? 1 : text === maxValue ? text : parseFloat(text) + 1;
        this.changeState(inputVal);
        this.props.onAdd(inputVal)
    }

    onChange(text) {
        let inputVal = text.trim().replace(/[^0-9]/g, '').replace(/^0+$/g, '1');
        this.changeState(inputVal);
        this.props.onChange(inputVal);
    }

    onBlur(text) {
        let inputVal = text === '' ? 1 : text;
        this.changeState(inputVal);
        this.props.onBlur(inputVal)
    }

    changeState(inputVal) {
        this.setState({buyCnt: inputVal});
        this.setState({btnPlusEnable: (inputVal === minValue ? 1 : 0)});
        this.setState({btnAddEnable: (inputVal === maxValue ? 1 : 0)});
    }

    render() {
        return (
            <View style={styles.InputNumberContainer}>
                <TouchableOpacity style={[styles.InputNumberLeftBtn, this.props.width]}
                                  activeOpacity={this.state.btnPlusEnable}
                                  onPress={() => this.state.btnPlusEnable !== 1 && this.onPlus(this.state.buyCnt)}>
                    <Text style={{color: this.state.btnPlusEnable === 1 ? '#dddddd' : '#666666'}} allowFontScaling={false}>-</Text>
                </TouchableOpacity>
                <TextInput style={[styles.InputNumberText, this.props.inputWidth]}
                           editable={this.state.editable}
                           underlineColorAndroid={'transparent'}
                           maxLength={this.props.maxLength}
                           keyboardType="numeric"
                           value={this.state.buyCnt.toString()}
                           onChangeText={(text) => this.onChange(text)}
                           onBlur={() => this.onBlur(this.state.buyCnt)}
                />
                <TouchableOpacity style={[styles.InputNumberRightBtn, this.props.width]}
                                  activeOpacity={this.state.btnAddEnable}
                                  onPress={() => this.state.btnAddEnable !== 1 && this.onAdd(this.state.buyCnt)}>
                    <Text style={{color: this.state.btnAddEnable === 1 ? '#dddddd' : '#666666'}} allowFontScaling={false}>+</Text>
                </TouchableOpacity>
            </View>
        );
    }
}
//样式定义
const styles = StyleSheet.create({
        InputNumberContainer: {
            flexDirection: 'row',
            borderWidth: 1,
            borderColor: Colors.text_light_grey,
            justifyContent: 'center',
            alignItems: 'center',
            height: 25,
            borderRadius: 3
        },
        InputNumberLeftBtn: {
            alignItems: 'center',
            justifyContent: 'center',
            width: 20,
        },
        InputNumberRightBtn: {
            alignItems: 'center',
            justifyContent: 'center',
            width: 20,
        },
        InputNumberText: {
            height: 25,
            width: 35,
            padding: 2,
            textAlign: 'center',
        },
    }
);
InputNumberText.propTypes = {
    onPlus: PropTypes.func,
    onAdd: PropTypes.func,
    onChange: PropTypes.func,
    onBlur: PropTypes.func,
    inputWidth: PropTypes.number,
    width: PropTypes.number,
};

export default connect(state => ({
        //cartType: state.ChangeCartTypeReducer
    }),
    dispatch => ({})
)(InputNumberText)
