/**
 * Created by jzz on 2017/8/1.
 */


import React from 'react';

import {
    View,
    Text,
    Image,
    StyleSheet,
    Platform,
    TextInput,
    TouchableOpacity,
} from 'react-native';

import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
export default class CustomTextInput extends React.PureComponent {

    static propTypes = {
        ...View.propTypes.style,
        title: PropTypes.string,
        placeholder: PropTypes.string,
        defaultText: PropTypes.string,
    }

    constructor(props) {
        super(props)
        this.state = {
            showDeleteBtn: false
        }
    }
    render() {
        return (
            <View style={[styles.titleContainer]}>
                <Text
                    allowFontScaling={false}
                    style={styles.titleTextStyle}>{this.props.title}</Text>
                <TextInput
                    ref='textInput'
                    style={styles.textInput}
                    placeholder={this.props.placeholder}
                    underlineColorAndroid={'transparent'}
                    onChangeText={(num)=>{
                                        this.state.invoiceNum=num;
                                        this.props.onInvoiceType1Change(num);
                                        if (num && num.length > 0) {
                                            this.setState({
                                                showNumberDeleteBtn: true
                                            })
                                        } else {
                                            this.setState({
                                                showNumberDeleteBtn: false
                                            })
                                        }
                                    }}
                    defaultValue={this.state.invoiceNum}
                    selectionColor={Colors.text_dark_grey}
                    onFocus={(num) => {
                                        this.props.onFocus(this.offsetY)
                                        if (num && num.length > 0) {
                                            this.setState({
                                                showNumberDeleteBtn: true
                                            })
                                        } else {
                                            this.setState({
                                                showNumberDeleteBtn: false
                                            })
                                        }
                                    }}
                    onBlur={() => {
                                         this.setState({
                                                showNumberDeleteBtn: false
                                            })
                                    }}
                />
                {
                    this.state.showNumberDeleteBtn ?
                        <TouchableOpacity activeOpacity={1} onPress={() => {
                                            console.log(this.refs)
                                            this.refs.numberTextInput.clear(),
                                            this.setState({
                                               showNumberDeleteBtn: false
                                            })}}>
                            <Image source={require('../../../foundation/Img/searchpage/Icon_cancel_.png')}
                                   style={styles.searchRowCancelIcon}/>
                        </TouchableOpacity>
                        : null
                }
            </View>
        )
    }

}

const styles = StyleSheet.create({

});

