/**
 * Created by YASIN on 2017/6/10.
 * 发票信息
 */
import React, {PropTypes} from 'react';
import {
    View,
    Text,
    StyleSheet,
    Image,
    Platform,
    TouchableOpacity,
    TextInput
} from 'react-native';
import Colors from '../../config/colors';
import * as ScreenUtils from '../../../foundation/utils/ScreenUtil';
const icons = {
    selected: require('../../../foundation/Img/cart/selected.png'),
    normal: require('../../../foundation/Img/cart/unselected.png'),
};
export default class InvoiceInfo extends React.Component {
    static propTypes = {
        ...View.propTypes.style,
        title: PropTypes.string,//发票抬头
        phone: PropTypes.string,//发票手机
        isNeedInvoice: PropTypes.bool,
        mail: PropTypes.string,//发票邮箱
        type: PropTypes.string,//发票种类
        invoiceType1: PropTypes.number,//0个人 1公司
        invoiceNum:PropTypes.string//纳税人识别号
    };
    static defaultProps = {
        isNeedInvoice: false,
        type: 'ELECTRONICS_INVOICE_PRINT',//ELECTRONICS_INVOICE  ELECTRONICS_INVOICE_PRINT
    };
    // 构造
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {
            isNeedInvoice: this.props.isNeedInvoice,
            invoiceType1: this.props.invoiceType1,
            invoiceNum:this.props.invoiceNum,
            showPhoneDeleteBtn: false,  // 手机号码的一键删除按钮
            showNameDeleteBtn: false,   // 发票抬头或者公司的一键删除按钮
            showNumberDeleteBtn: false, //
            phoneNumber: this.props.phone,//手机号码i
            invoiceName: this.props.title,

        };
        this.offsetY = 0;
    }

    render() {
        let placeholderStr = this.state.invoiceType1 === 1 ? '请填写公司名称' : "请填写发票抬头";
        return (
            <View style={[styles.container, this.props.style]}
                  onLayout={({nativeEvent: {layout: {x, y, width, height}}}) => {
                      this.offsetY = y;
                  }}

            >
                {this.state.isNeedInvoice ? (
                    <View>
                        {/*发票类型（个人、公司）*/}
                        <View style={[styles.titleContainer2]}>
                            <Text
                                allowFontScaling={false}
                                style={styles.topTextStyle}>发票类型</Text>
                            <View style={styles.checkBoxContainer}>
                                <TouchableOpacity
                                    activeOpacity={1}
                                    style={styles.checkBoxStyle}
                                    onPress={()=> {
                                        if (this.state.invoiceType1 === 0) {
                                            return;
                                        }
                                        this.setState({
                                            invoiceType1: 0
                                        }, ()=> {
                                            this.props.onInvoiceType1Change1&&this.props.onInvoiceType1Change1(0)
                                        });
                                    }}
                                >
                                    <Image
                                        source={!(this.state.invoiceType1 === 0) ? icons.normal : icons.selected}
                                        style={styles.checkbox}
                                    />
                                    <Text
                                        allowFontScaling={false}
                                        style={[styles.checkText,{width:ScreenUtils.scaleSize(120)}]}>个人</Text>
                                </TouchableOpacity>

                                <TouchableOpacity
                                    style={[styles.checkBoxStyle]}
                                    activeOpacity={1}
                                    onPress={()=> {
                                        if (this.state.invoiceType1 === 1) {
                                            return;
                                        }
                                        this.setState({
                                            invoiceType1: 1
                                        }, ()=> {
                                            this.props.onInvoiceType1Change1&&this.props.onInvoiceType1Change1(1)
                                        });
                                    }}
                                >
                                    <Image
                                        source={!(this.state.invoiceType1 === 1) ? icons.normal : icons.selected}
                                        style={styles.checkbox}
                                    />
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.checkText}>公司</Text>
                                </TouchableOpacity>
                            </View>
                        </View>

                        {/*发票抬头*/}
                        <View style={[styles.titleContainer]}>
                            <Text
                                allowFontScaling={false}
                                style={styles.titleTextStyle}>{this.state.invoiceType1 === 1 ? '公司名称' : '发票抬头'}</Text>
                            <TextInput
                                ref='nameTextInput'
                                style={styles.textInput}
                                placeholder= {placeholderStr}
                                underlineColorAndroid={'transparent'}
                                onChangeText={(num)=>{
                                    this.props.onInvoiceNameChange(num);
                                    if (num.length > 0) {
                                        this.setState({
                                            showNameDeleteBtn: true,
                                            invoiceName: num,
                                        })
                                    } else {
                                        this.setState({
                                            showNameDeleteBtn: false,
                                            invoiceName: num,
                                        })
                                    }
                                }}
                                defaultValue={this.state.invoiceName}
                                selectionColor={Colors.text_dark_grey}
                                onFocus={() => {
                                    this.props.onFocus(this.offsetY)
                                    if (this.state.invoiceName && this.state.invoiceName.length > 0) {
                                        this.setState({
                                           showNameDeleteBtn: true,
                                        })
                                    }
                                }}
                                onBlur={() => {
                                    this.setState({
                                       showNameDeleteBtn: false,
                                    })
                                }}
                            />
                            {
                                this.state.showNameDeleteBtn ?
                                    <TouchableOpacity style={styles.deleteBgView}
                                                      activeOpacity={1}
                                                      onPress={() => {
                                                            this.props.onInvoiceNameChange('');
                                                            this.setState({
                                                                   invoiceName: '',
                                                                   showNameDeleteBtn: false,
                                                                })
                                                        }}>
                                        <Image source={require('../../../foundation/Img/searchpage/Icon_cancel_.png')}
                                               style={styles.searchRowCancelIcon}/>
                                    </TouchableOpacity>
                                    : null
                            }
                        </View>

                        {/*纳税人识别号*/}
                        {(this.state.invoiceType1 === 1) ? (
                            <View style={[styles.titleContainer]}>
                                <Text
                                    allowFontScaling={false}
                                    style={styles.titleTextStyle}>纳税人识别号</Text>
                                <TextInput
                                    ref='numberTextInput'
                                    style={styles.textInput}
                                    clearButtonMode="never"
                                    placeholder="请填写纳税人识别号"
                                    underlineColorAndroid={'transparent'}
                                    onChangeText={(num)=>{
                                        this.props.onInvoiceType1Change(num);
                                        if (num.length > 0) {
                                            this.setState({
                                                showNumberDeleteBtn: true,
                                                invoiceNum: num,
                                            })
                                        } else {
                                            this.setState({
                                                showNumberDeleteBtn: false,
                                                invoiceNum: num,
                                            })
                                        }
                                    }}
                                    value={this.state.invoiceNum}
                                    selectionColor={Colors.text_dark_grey}
                                    onFocus={() => {
                                        this.props.onFocus(this.offsetY)
                                        if (this.state.invoiceNum && this.state.invoiceNum.length > 0) {
                                            this.setState({
                                               showNumberDeleteBtn: true,
                                            })
                                        }
                                    }}
                                    onBlur={() => {
                                        this.setState({
                                               showNumberDeleteBtn: false,
                                            })
                                    }}
                                />
                                {
                                    this.state.showNumberDeleteBtn ?
                                        <TouchableOpacity activeOpacity={1}
                                                          style={styles.deleteBgView}
                                                          onPress={() => {
                                                                this.props.onInvoiceType1Change('');
                                                                this.setState({
                                                                   showNumberDeleteBtn: false,
                                                                   invoiceNum: '',
                                                                })
                                                         }
                                        }>
                                            <Image source={require('../../../foundation/Img/searchpage/Icon_cancel_.png')}
                                                   style={styles.searchRowCancelIcon}/>
                                        </TouchableOpacity>
                                        : null
                                }
                            </View>
                        ) : null}
                        {/*手机号*/}
                        {
                            this.state.invoiceType1 != 1 ?
                                <View style={styles.titleContainer}>
                                    <Text
                                        allowFontScaling={false}
                                        style={styles.titleTextStyle}>收票人手机</Text>
                                    <TextInput
                                        ref='phoneTextInput'
                                        style={styles.textInput}
                                        placeholder="请填写收票人手机号"
                                        underlineColorAndroid={'transparent'}
                                        onChangeText={(num)=>{
                                            this.props.onInvoicePhoneChange(num);
                                            if (num.length > 0) {
                                                this.setState({
                                                    showPhoneDeleteBtn: true,
                                                    phoneNumber: num,
                                                })
                                            } else {
                                                 this.setState({
                                                    showPhoneDeleteBtn: false,
                                                    phoneNumber: num,
                                                })
                                            }
                                        }}
                                        defaultValue={this.state.phoneNumber}
                                        selectionColor={Colors.text_dark_grey}
                                        onFocus={() =>{
                                            this.props.onFocus(this.offsetY)
                                            if (this.state.phoneNumber && this.state.phoneNumber.length > 0) {
                                                this.setState({
                                                   showPhoneDeleteBtn: true,
                                                })
                                            }
                                        }}
                                        onBlur={() => {
                                            this.setState({
                                               showPhoneDeleteBtn: false,
                                            })
                                        }}
                                    />
                                    {
                                        this.state.showPhoneDeleteBtn ?
                                            <TouchableOpacity style={styles.deleteBgView}
                                                              activeOpacity={1}
                                                              onPress={() => {
                                                                    this.props.onInvoicePhoneChange('')
                                                                    this.setState({
                                                                       showPhoneDeleteBtn: false,
                                                                       phoneNumber: '',
                                                                    })
                                            }}>
                                                <Image source={require('../../../foundation/Img/searchpage/Icon_cancel_.png')}
                                                       style={styles.searchRowCancelIcon}/>
                                            </TouchableOpacity>
                                            : null
                                    }
                                </View>
                                :
                                null
                        }

                    </View>
                ) : null}
            </View>
        );
    }
}


const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        backgroundColor: Colors.text_white,
        borderWidth: ScreenUtils.scaleSize(1),
        borderColor: Colors.background_grey,
    },
    invoiceTopContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        borderBottomColor: Colors.background_grey,
        borderBottomWidth: ScreenUtils.scaleSize(1),
        padding: ScreenUtils.scaleSize(30)
    },
    topTextStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(30)
    },
    checkBoxContainer: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    checkBoxStyle: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    checkbox: {
        width: ScreenUtils.scaleSize(31),
        height: ScreenUtils.scaleSize(31)
    },
    checkText: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(26),
        marginLeft: ScreenUtils.scaleSize(5)
    },
    titleContainer: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        ...Platform.select({
            ios: {
                paddingVertical: ScreenUtils.scaleSize(20),
            },
            android: {
                paddingVertical: ScreenUtils.scaleSize(10),
            }
        }),
        borderBottomColor: Colors.background_grey,
        borderBottomWidth: ScreenUtils.scaleSize(1),
        marginHorizontal: ScreenUtils.scaleSize(30)
    },
    titleContainer2: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginHorizontal: ScreenUtils.scaleSize(30),
        borderBottomColor: Colors.background_grey,
        borderBottomWidth: ScreenUtils.scaleSize(1),
        paddingVertical: ScreenUtils.scaleSize(30)
    },
    titleTextStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(26),
        textAlign: 'left',

    },
    textInput: {
        flex: 1,
        textAlign: 'right',
        textAlignVertical: 'center',
        fontSize: ScreenUtils.scaleSize(26),
        color: Colors.text_black,
        ...Platform.select({
            ios: {
                height: ScreenUtils.scaleSize(54)
            },
            android: {
                paddingTop: 5,
                paddingBottom: 5
            }
        }),
    },
    searchRowCancelIcon: {
        width: ScreenUtils.scaleSize(30),
        height: ScreenUtils.scaleSize(30),
    },
    deleteBgView: {
        width: ScreenUtils.scaleSize(40),
        height: ScreenUtils.scaleSize(40),
        alignItems: 'center',
        justifyContent: 'center',
        marginLeft: ScreenUtils.scaleSize(8),
    }
});