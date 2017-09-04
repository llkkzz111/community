/**
 * Created by Administrator on 2017/5/9.
 */
'use strict';

import React  from 'react'
import {
    View,
    Text,
    StyleSheet,
    Image,
    TextInput,
    Dimensions,
    TouchableOpacity,
    ScrollView,
} from 'react-native'
const {width} = Dimensions.get('window');
const minValue = 1;
const maxValue = 99;
export class Certificate extends React.PureComponent {
    constructor(props) {
        super(props);
    }

    addImage() {
        this.props.addImage && this.props.addImage()
    }

    render() {
        return (
            <View style={styles.cartificateContainer}>
                <View style={styles.cartificateTitleLayout}>
                    <Text allowFontScaling={false}>上传凭证 (可选, 最多9张)</Text>
                    <Text allowFontScaling={false}>样图示范</Text>
                </View>
                <View style={styles.minSeparator}/>
                <View style={styles.cartificateImageLayout}>
                    <TouchableOpacity activeOpacity={1} style={styles.cartificateImageStyle}>
                        <Image source={{uri: 'http://cdnimg.ocj.com.cn/item_images/item/15/13/4226/15134226L2.jpg'}}
                               style={styles.cartificateImage}/>
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={1} style={styles.cartificateImageStyle} onPress={() => {
                        this.addImage()
                    }}>
                        <Image source={require('../../../foundation/Img/order/cartificateImage.png')}
                               style={styles.cartificateImage}/>
                    </TouchableOpacity>
                </View>
            </View>
        );
    }
}
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
        this.props.onPlus && this.props.onPlus(inputVal);
    }

    onAdd(text) {
        let inputVal = text === '' ? 1 : text === maxValue ? text : parseFloat(text) + 1;
        this.changeState(inputVal);
        this.props.onAdd && this.props.onAdd(inputVal)
    }

    onChange(text) {
        let inputVal = text.trim().replace(/[^0-9]/g, '').replace(/^0+$/g, '1');
        this.changeState(inputVal);
        this.props.onChange && this.props.onChange(inputVal);
    }

    onBlur(text) {
        let inputVal = text === '' ? 1 : text;
        this.changeState(inputVal);
        this.props.onBlur && this.props.onBlur(inputVal)
    }

    changeState(inputVal) {
        this.setState({buyCnt: inputVal});
        this.setState({btnPlusEnable: (inputVal === minValue ? 1 : 0)});
        this.setState({btnAddEnable: (inputVal === maxValue ? 1 : 0)});
    }

    render() {
        return (
            <View style={styles.InputNumberContainer}>
                <TouchableOpacity activeOpacity={this.state.btnPlusEnable}
                                  onPress={() => this.state.btnPlusEnable !== 1 && this.onPlus(this.state.buyCnt)}>
                    <View style={[styles.InputNumberLeftBtn, this.props.width]}>
                        <Text allowFontScaling={false} style={{color: this.state.btnPlusEnable === 1 ? '#dddddd' : '#666666'}}>-</Text>
                    </View>
                </TouchableOpacity>
                <TextInput style={[styles.InputNumberText, this.props.inputWidth]}
                           editable={this.state.editable}
                           underlineColorAndroid={'transparent'}
                           maxLength={this.props.maxLength}
                           keyboardType="numeric"
                           allowFontScaling={false}
                           value={this.state.buyCnt.toString()}
                           onChangeText={(text) => this.onChange(text)}
                           onBlur={() => this.onBlur(this.state.buyCnt)}
                />
                <TouchableOpacity activeOpacity={this.state.btnAddEnable}
                                  onPress={() => this.state.btnAddEnable !== 1 && this.onAdd(this.state.buyCnt)}>
                    <View style={[styles.InputNumberRightBtn, this.props.width]}>
                        <Text allowFontScaling={false} style={{color: this.state.btnAddEnable === 1 ? '#dddddd' : '#666666'}}>+</Text>
                    </View>
                </TouchableOpacity>
            </View>
        );
    }
}

export default class ApplyExchangeGoods extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            isNeed: false,
            isDoNotNeed: false,
            isYes: false,
            isNo: false,
            isYesFetch: false,
            isNoFetch: false,
        }
    }

    render() {
        return (
            <ScrollView>
                <View style={styles.orderExchangeGoodsContainer}>
                    <Text allowFontScaling={false} style={styles.orderExchangeGoodsTitle}>申请退货</Text>
                </View>
                <View style={styles.orderExchangeGoodsBackStyle}>
                    <Text> allowFontScaling={false}返回</Text>
                </View>
                <View style={styles.minSeparator}/>
                <View style={styles.orderExchangeGoodsReason}>
                    <Text allowFontScaling={false}>换货原因</Text>
                </View>
                <View style={styles.minSeparator}/>
                <View style={styles.orderExchangeGoodsLayout}>
                    <Text allowFontScaling={false}>请选择换货原因</Text>
                    <Image source={require('../../../foundation/Img/order/goTo.png')}/>
                </View>
                <View style={styles.minSeparator}/>
                <TextInput multiline={true}
                           numberOfLines={5}
                           maxLength={1000}
                           keyboardAppearance={true}
                           underlineColorAndroid={'transparent'}
                           placeholder={'具体问题描述(可不填)'}
                           placeholderTextColor={"#666666 "}
                           style={styles.cartificateInputReason}>

                </TextInput>
                <View style={styles.maxSeparator}/>
                <View style={styles.orderExchangeGoodsLayout}>
                    <Text allowFontScaling={false}>请选择您要换的商品</Text>
                    <Image source={require('../../../foundation/Img/order/goTo.png')}/>
                </View>
                <View style={styles.minSeparator}/>
                <View style={styles.orderExchangeGoodsShoppingLayout}>
                    <View>
                        <Image
                            source={{uri: 'http://cdnimg.ocj.com.cn/item_images/item/15/08/6226/15086226L.jpg'}}
                            style={styles.orderExchangeGoodsShoppingImg}/>
                        <Text allowFontScaling={false} style={styles.orderExchangeGoodsShoppingImgPosition}> </Text>
                        <View style={styles.orderExchangeGoodsShoppingInfoLayout}>
                            <Text allowFontScaling={false} style={styles.orderExchangeGoodsShoppingInfo}>库存紧张</Text>
                        </View>
                    </View>

                    <View style={styles.orderExchangeGoodsShoppingDescription}>
                        <View style={styles.orderExchangeGoodsShoppingDescriptionLayout}>
                            <Text allowFontScaling={false} style={styles.orderExchangeGoodsShoppingTitle}>博朗（Braun）HD580家用便携大功率离子电吹风 吹风机</Text>
                            <TouchableOpacity activeOpacity={1} onPress={() => {
                                this.props.onCommercialSpecification && this.props.onCommercialSpecification()
                            }}>
                                <View style={styles.orderExchangeGoodsShoppingSpecification}>
                                    <Text allowFontScaling={false} style={styles.baseFontStyle}>颜色分类:白色</Text>
                                    <Image style={styles.orderExchangeGoodsGoToIcon}
                                           source={require('../../../foundation/Img/cart/goto.png')}/>
                                </View>
                            </TouchableOpacity>
                        </View>
                        <InputNumberText
                            maxLength={this.props.maxLength}
                            value={1}
                            onAdd={(text) => {
                                this.props.onAdd && this.props.onAdd(text);
                            }}
                            onPlus={(text) => {
                                this.props.onPlus && this.props.onPlus(text);
                            }}
                            onChange={(text) => {
                                this.props.onChange && this.props.onChange(text);
                            }}
                            onBlur={(text) => {
                                this.props.onBlur && this.props.onBlur(text);
                            }}
                            width={{width: 80}}
                            inputWidth={{width: 120}}
                        />
                    </View>
                </View>
                <View style={styles.minSeparator}/>
                <View style={styles.orderExchangeGoodsLayout}>
                    <View>
                        <Text allowFontScaling={false}>是否使用过</Text>
                    </View>
                    <View style={styles.orderExchangeGoodsSeelctBoxLayout}>
                        <View style={styles.checkStyle}>
                            <TouchableOpacity style={styles.checkBoxStyle2} activeOpacity={1} onPress={() => {
                                this.checkSelect('NO')
                            }}>
                                <Image style={styles.imgStyle}
                                       source={this.state.isDoNotNeed ? require('../../../foundation/Img/cart/selected.png') : require('../../../foundation/Img/cart/unselected.png')}/>

                                <Text allowFontScaling={false} style={styles.checkBoxDescStyle}>是</Text></TouchableOpacity>
                        </View>
                        <View style={styles.checkStyle}>
                            <TouchableOpacity style={styles.checkBoxStyle2} activeOpacity={1} onPress={() => {
                                this.checkSelect('YES')
                            }}>
                                <Image style={styles.imgStyle}
                                       source={this.state.isNeed ? require('../../../foundation/Img/cart/selected.png') : require('../../../foundation/Img/cart/unselected.png')}/>
                                <Text allowFontScaling={false} style={styles.checkBoxDescStyle}>否</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </View>
                <View style={styles.minSeparator}/>
                <View style={styles.orderExchangeGoodsLayout}>
                    <View>
                        <Text allowFontScaling={false}>构成齐全与否</Text>
                    </View>
                    <View style={styles.orderExchangeGoodsSeelctBoxLayout}>
                        <View style={styles.checkStyle}>
                            <TouchableOpacity style={styles.checkBoxStyle2} activeOpacity={1} onPress={() => {
                                this.checkSelect2('NO')
                            }}>
                                <Image style={styles.imgStyle}
                                       source={this.state.isNo ? require('../../../foundation/Img/cart/selected.png') : require('../../../foundation/Img/cart/unselected.png')}/>

                                <Text allowFontScaling={false} style={styles.checkBoxDescStyle}>是</Text></TouchableOpacity>
                        </View>
                        <View style={styles.checkStyle}>
                            <TouchableOpacity style={styles.checkBoxStyle2} activeOpacity={1} onPress={() => {
                                this.checkSelect2('YES')
                            }}>
                                <Image style={styles.imgStyle}
                                       source={this.state.isYes ? require('../../../foundation/Img/cart/selected.png') : require('../../../foundation/Img/cart/unselected.png')}/>
                                <Text allowFontScaling={false} style={styles.checkBoxDescStyle}>否</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </View>
                <View style={styles.maxSeparator}/>
                <View style={styles.orderExchangeGoodsLayout}>
                    <View>
                        <Text allowFontScaling={false}>退换货方式</Text>
                    </View>
                    <View style={styles.orderExchangeGoodsSeelctBoxLayout}>
                        <View style={styles.checkStyle}>
                            <TouchableOpacity style={styles.checkBoxStyle2} activeOpacity={1} onPress={() => {
                                this.checkSelect3('NO')
                            }}>
                                <Image style={styles.imgStyle}
                                       source={this.state.isNoFetch ? require('../../../foundation/Img/cart/selected.png') : require('../../../foundation/Img/cart/unselected.png')}/>

                                <Text allowFontScaling={false} style={styles.checkBoxDescStyle}>自行邮寄</Text></TouchableOpacity>
                        </View>
                        <View style={styles.checkStyle}>
                            <TouchableOpacity style={styles.checkBoxStyle2} activeOpacity={1} onPress={() => {
                                this.checkSelect3('YES')
                            }}>
                                <Image style={styles.imgStyle}
                                       source={this.state.isYesFetch ? require('../../../foundation/Img/cart/selected.png') : require('../../../foundation/Img/cart/unselected.png')}/>
                                <Text allowFontScaling={false} style={styles.checkBoxDescStyle}>上门取货</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </View>
                <View style={styles.maxSeparator}/>
                <View>
                    <Certificate />
                </View>
                <View style={styles.maxSeparator}/>
                <TouchableOpacity
                    activeOpacity={1}
                    style={[styles.orderExchangeGoodsLayout, styles.orderExchangeGoodsApply]}>
                    <Text allowFontScaling={false}>提交申请</Text>
                </TouchableOpacity>
            </ScrollView>
        )
    }

    componentDidMount() {

    }

    checkSelect(text) {
        if (text === 'YES') {
            this.setState({
                isNeed: true,
                isDoNotNeed: false
            });
        } else if (text === 'NO') {
            this.setState({
                isNeed: false,
                isDoNotNeed: true
            });
        }
    }

    checkSelect2(text) {
        if (text === 'YES') {
            this.setState({
                isYes: true,
                isNo: false
            });
        } else if (text === 'NO') {
            this.setState({
                isYes: false,
                isNo: true
            });
        }
    }

    checkSelect3(text) {
        if (text === 'YES') {
            this.setState({
                isYes: true,
                isNo: false
            });
        } else if (text === 'NO') {
            this.setState({
                isYesFetch: false,
                isNoFetch: true
            });
        }
    }
}

const styles = StyleSheet.create({
    cartificateContainer: {
        height: 220
    },
    cartificateTitleLayout: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        height: 40,
        alignItems: 'center',
        paddingHorizontal: 15,
        backgroundColor: 'white'
    }
    ,
    cartificateImageLayout: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        alignItems: 'center',
    }
    ,
    cartificateImageStyle: {
        width: (width - 10) / 5,
        alignItems: 'center',
        marginVertical: 10,
    }
    ,
    cartificateImage: {
        width: 40,
        height: 60,
    }
    ,
    orderExchangeGoodsContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        height: 40,
        alignItems: 'center',
        backgroundColor: 'white'
    },
    orderExchangeGoodsTitle: {
        fontSize: 15,
        color: "#333333"
    },
    orderExchangeGoodsBackStyle: {
        position: 'absolute',
        left: 15,
        top: 12,
        backgroundColor: 'white'
    },
    orderExchangeGoodsReason: {
        alignItems: 'center',
        flexDirection: 'row',
        height: 40
        , backgroundColor: 'white',
        paddingLeft: 15,
    },
    orderExchangeGoodsLayout: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        height: 40,
        alignItems: 'center',
        paddingHorizontal: 15,
        backgroundColor: 'white'
    },
    orderExchangeGoodsSeelctBoxLayout: {
        justifyContent: 'flex-end',
        flexDirection: 'row'
    },
    cartificateInputReason: {
        paddingLeft: 15,
        textAlignVertical: 'top'
    },
    orderExchangeGoodsApply: {
        alignItems: 'center',
        justifyContent: 'center',
    },
    orderExchangeGoodsShoppingLayout: {
        flexDirection: 'row',
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingHorizontal: 15,
        backgroundColor: 'white',
        paddingVertical: 10,

    },
    orderExchangeGoodsShoppingImg: {
        height: 90,
        width: 90,
        borderWidth: 1,
        borderColor: '#EEEEEE',
    },
    orderExchangeGoodsShoppingImgPosition: {
        width: 90,
        height: 18,
        backgroundColor: '#ED1C41',
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 2,
        opacity: 0.75,
        position: "absolute",
        bottom: 0,
        left: 0,
        zIndex: 1,
        right: 0
    },

    orderExchangeGoodsShoppingInfoLayout: {
        width: 90,
        position: 'absolute',
        bottom: 0,
        height: 18,
        zIndex: 10,
        left: 0,
        alignItems: "center",
        justifyContent: "center"
    },
    orderExchangeGoodsShoppingInfo: {
        color: 'white',
        fontSize: 10,
        textAlign: "center"
    },
    orderExchangeGoodsShoppingDescription: {
        marginLeft: 5,
        justifyContent: 'space-between',
        flex: 1,
        backgroundColor: 'white'

    },
    orderExchangeGoodsShoppingDescriptionLayout: {
        alignSelf: "flex-start",
        marginBottom: 5,
    },
    orderExchangeGoodsShoppingTitle: {
        marginLeft: 0,
        marginRight: 5,
        fontSize: 13,
        color: "#333333",
        alignSelf: "flex-start",
    },
    orderExchangeGoodsShoppingSpecification: {
        backgroundColor: '#F0F0F0',
        height: 25,
        justifyContent: 'space-between',
        alignItems: 'center',
        paddingRight: 5,
        flexDirection: 'row',
        marginTop: 5,
    },
    baseFontStyle: {
        color: "#666666",
        fontSize: 11
    },
    orderExchangeGoodsGoToIcon: {
        width: 7,
        height: 10,
        resizeMode: "contain"
    },
    InputNumberContainer: {
        flexDirection: 'row',
        borderWidth: 1,
        borderColor: '#999999',
        justifyContent: 'center',
        alignItems: 'center',
        height: 25,
        borderRadius: 3
    }
    ,
    InputNumberLeftBtn: {
        alignItems: 'center',
        justifyContent: 'center',
        width: 20,

    }
    ,
    InputNumberRightBtn: {
        alignItems: 'center',
        justifyContent: 'center',
        width: 20,
    }
    ,
    InputNumberText: {
        height: 25,
        width: 35,
        padding: 2,
        textAlign: 'center',
    }
    ,
    minSeparator: {
        borderBottomWidth: 1,
        borderBottomColor: '#ededed'
    }
    ,
    maxSeparator: {
        borderBottomWidth: 10,
        borderBottomColor: '#ededed'
    }
    ,
    checkStyle: {
        flexDirection: 'row',
        height: 40,
        alignItems: 'center',
    }
    ,
    checkBoxStyle: {
        marginRight: 10,
    }
    ,
    checkBoxStyle2: {
        marginLeft: 15,
        flexDirection: 'row',
    }
    ,
    checkBoxDescStyle: {
        fontSize: 12,
        color: '#666666',
        marginLeft: 5,
    }
    ,
    imgStyle: {
        width: 15,
        height: 15
    }
});


