/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */
'use strict';

import React from 'react';

import {
    StyleSheet,
    TextInput
} from 'react-native';

export default class TextForInput extends React.PureComponent {
    constructor() {
        super();
        this.state = { text: '' };
    }

    //手机号
    setTextValueForTelephone(text){
        let textValue =  text.text  == '' ? '' : text.text.replace(/[^0-9]/g, '');
        this.setState({text:textValue});
    }

    //身份证
    setTextValueForIdentificationCard(text){
        let textValue =  text.text == '' ? '' : text.text.replace(/[^a-zA-Z0-9]/g, '');
        this.setState({text:textValue});
    }

    createInputText(){
        let inputType = this.props.inputType;
        switch (inputType){
            case 'telephone'://手机号
            {
                return(
                    <TextInput
                        placeholder={this.props.tips}
                        placeholderTextColor="#999999"
                        underlineColorAndroid="#DDDDDD"
                        key="telephone"
                        maxLength={11}
                        autoCorrect={false}
                        style={styles.inputTextStyle}
                        keyboardType="numeric"
                        onChangeText={(text) => this.setTextValueForTelephone({text})}
                        value={this.state.text}
                    >
                    </TextInput>
                );
            }
            case 'password'://密码
            {
                return(
                    <TextInput
                        placeholder={this.props.tips}
                        placeholderTextColor="#999999"
                        underlineColorAndroid="#DDDDDD"
                        key="password"
                        autoCorrect={false}
                        style={styles.inputTextStyle}
                        keyboardType="default"
                        secureTextEntry={true}
                    >
                    </TextInput>
                );
            }
            case 'identificationCard'://身份证
            {
                return(
                    <TextInput
                        placeholder={this.props.tips}
                        key="identificationCard"
                        maxLength={18}
                        autoCorrect={false}
                        style={styles.inputTextStyle}
                        placeholderTextColor="#999999"
                        underlineColorAndroid="#DDDDDD"
                        keyboardType="default"
                        onChangeText={(text) => this.setTextValueForIdentificationCard({text})}
                        value={this.state.text}
                    >
                    </TextInput>
                );
            }
            case 'eMailAddress'://邮箱地址
            {
                return(
                    <TextInput
                        placeholder={this.props.tips}
                        placeholderTextColor="#999999"
                        underlineColorAndroid="#DDDDDD"
                        key="eMailAddress"
                        autoCorrect={false}
                        style={styles.inputTextStyle}
                        keyboardType="email-address"
                        onChangeText={(text) => this.setState({text})}
                        value={this.state.text}
                    >
                    </TextInput>
                );
            }
            default://用户名
            {
                return(
                    <TextInput
                        placeholder={this.props.tips}
                        placeholderTextColor="#999999"
                        underlineColorAndroid="#DDDDDD"
                        key="customerNmae"
                        style={styles.inputTextStyle}
                        keyboardType="default"
                        onChangeText={(text) => this.setState({text})}
                        value={this.state.text}
                    >
                    </TextInput>
                );
            }
        }
    }
    render() {
        return  this.createInputText();
    }
}

TextForInput.defaultProps = {
    inputType:'',
    tips:'用户名'
};

const styles = StyleSheet.create({
    inputTextStyle: {

    }
});
