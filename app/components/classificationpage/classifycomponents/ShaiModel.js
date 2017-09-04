import React from 'react';
import {
    View,
    Text,
    StyleSheet,
    Modal,
    TouchableWithoutFeedback,
    Image,
    TextInput,
    ScrollView,
    TouchableOpacity,

} from 'react-native';
import * as ScreenUtil from '../../../../foundation/utils/ScreenUtil';
import Colors from '../../../../app/config/colors';
import Toast, {DURATION} from 'react-native-easy-toast';


let productType = ['主播推荐', '团购', '全球购', '促销商品'];


export default class ShaiModel extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            open: this.props.open,
            screenText: -1,
            selectedJiage: [],
            selectedPinpai: [],
            selectedType: [],
            selectedLength: 0,
            low: '',
            high: '',
            selectedLogo: [],
            brand_codes: '',
            sendPrices: [],
        }

        this.textY = 0;
    }


    componentWillReceiveProps(nextProps) {

        this.setState({
            open: nextProps.open,
        });
    }

    /*
     * 品牌点击
     */
    _PressTabPinpai(index) {

        if (this.state.selectedPinpai.indexOf(index) === -1) {
            if (this.state.selectedLength === 5) {
                this.refs.toast.show("筛选个数最多不超过5个", DURATION.LENGTH_LONG);
                return;
            }
            this.state.selectedPinpai.push(index);
            this.setState({
                selectedLength: this.state.selectedLength + 1,
                selectedLogo: this.state.selectedLogo + this.props.pinpai[index].brand_name + ',',
                brand_codes: this.state.brand_codes + this.props.pinpai[index].brand_code + ',',
            })
        } else {
            for (let i = 0; i < this.state.selectedPinpai.length; i++) {
                if (index === this.state.selectedPinpai[i]) {
                    this.state.selectedPinpai.splice(i, 1);
                }
            }
            this.setState({
                brand_codes: this.state.brand_codes.replace(this.props.pinpai[index].brand_code + ',', ''),
                selectedLogo: this.state.selectedLogo.replace(this.props.pinpai[index].brand_name + ',', ''),
                selectedLength: this.state.selectedLength - 1
            })
        }
    }

    /*
     * 价格点击
     */
    _PressTabjiage(index) {

        if (this.state.selectedJiage.indexOf(index) === -1) {
            if (this.state.selectedLength === 5) {
                this.refs.toast.show("筛选个数最多不超过5个", DURATION.LENGTH_LONG);
                return;
            }
            this.state.selectedJiage.push(index);
            this.state.sendPrices.push(this.props.jiage[index].join('-'));
            this.setState({
                selectedLength: this.state.selectedLength + 1,
            })
        } else {
            for (let i = 0; i < this.state.selectedJiage.length; i++) {
                if (index === this.state.selectedJiage[i]) {
                    this.state.selectedJiage.splice(i, 1);
                    this.state.sendPrices.splice(i, 1);
                }
            }
            this.setState({
                selectedLength: this.state.selectedLength - 1
            })
        }
    }

    /*
     * 商品类型点击
     */
    _PressTab(index) {

        if (this.state.selectedType.indexOf(index) === -1) {
            if (this.state.selectedLength === 5) {
                this.refs.toast.show("筛选个数最多不超过5个", DURATION.LENGTH_LONG);
                return;
            }
            this.state.selectedType.push(index);
            this.setState({
                selectedLength: this.state.selectedLength + 1
            })
        } else {
            for (let i = 0; i < this.state.selectedType.length; i++) {
                if (index === this.state.selectedType[i]) {
                    this.state.selectedType.splice(i, 1);
                }
            }
            this.setState({
                selectedLength: this.state.selectedLength - 1
            })
        }

    }

    resetClick() {
        this.setState({
            selectedJiage: [],
            selectedPinpai: [],
            selectedType: [],
            selectedLength: 0,
            low: '',
            high: '',
            selectedLogo: [],
            brand_codes: '',
            sendPrices: [],
        })
        /* this.props.submit({
         prices: [],
         brand_code: '',
         low: '',
         high: '',
         })*/
    }

    //最低价
    setLow(text) {
        this.setState({
            low: text,
        })
    }

    //最高价
    setHigh(text) {
        this.setState({
            high: text,
        })
    }

    //输入框获得焦点时
    scrollTextY() {
        if (this.textY > ScreenUtil.screenH / 2) {
            this.refs._scrollView.scrollTo({y: this.textY - 22});
        }
    }

    //输入框失去焦点
    scrollBegin() {
        if (this.textY > ScreenUtil.screenH / 2) {
            this.refs._scrollView.scrollTo({y: ScreenUtil.scaleSize(64) - 22});
        }
    }

    render() {
        let {pinpai, jiage} = this.props;
        return (
            <Modal
                onRequestClose={() => {
                }}
                animationType='fade'
                visible={this.state.open}
                transparent={true}>
                <View style={styles.outView}>
                    <TouchableWithoutFeedback onPress={
                        this.props.close
                    }>
                        <View style={styles.left}></View>
                    </TouchableWithoutFeedback>
                    <View>
                        <ScrollView style={styles.right} ref="_scrollView">
                            <View style={[styles.titleContainer, {marginTop: ScreenUtil.scaleSize(64),}]}>
                                <Text style={styles.titleTextContainer} allowFontScaling={false}>品牌</Text>
                                <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                    <Text style={styles.brandSelection}
                                          numberOfLines={1}
                                          allowFontScaling={false}>{this.state.selectedLogo}</Text>
                                    <Image style={styles.collapseArrow}
                                           source={require('../../../../foundation/Img/dialog/collapse_down.png')}/>
                                </View>
                            </View>

                            {/*品牌*/}
                            <View style={{flexDirection: 'row', flexWrap: 'wrap'}}>

                                {
                                    pinpai && pinpai.length > 0 ? pinpai.map((item, index) => {
                                        return (
                                            <TouchableWithoutFeedback
                                                onPress={
                                                    () => {
                                                        this._PressTabPinpai(index)
                                                    }
                                                }
                                            >
                                                <View style={[styles.tabTextView, {
                                                    backgroundColor: this.state.selectedPinpai.indexOf(index) > -1 ?
                                                        '#FFEBE8' : '#EDEDED',
                                                    marginRight: index === 2 ? 0 : ScreenUtil.scaleSize(20)
                                                }]}>
                                                    <Text allowFontScaling={false}
                                                          numberOfLines={1}
                                                          style={styles.tabText}>{item.brand_name}</Text>
                                                    {this.state.selectedPinpai.indexOf(index) > -1 ?
                                                        <Image style={{
                                                            position: 'absolute',
                                                            right: 0,
                                                            bottom: 0,
                                                            height: ScreenUtil.scaleSize(30),
                                                            width: ScreenUtil.scaleSize(30),
                                                        }}
                                                               source={require('../../../../foundation/Img/shoppingPage/selected_.png')}/>
                                                        : null}
                                                </View>
                                            </TouchableWithoutFeedback>)
                                    })
                                        : null}</View>
                            {/*价格*/}
                            <Text style={styles.titleTextContainer}
                                  allowFontScaling={false}
                                  onLayout={(e) => {
                                      this.textY = e.nativeEvent.layout.y;
                                  }}>价格区间(元)</Text>
                            <View style={styles.priceSelection}>

                                <TextInput style={styles.priceInputStyle}
                                           placeholder="最低价"
                                           placeholderTextColor={Colors.text_light_grey}
                                           keyboardType='numeric'
                                           selectionColor="red"
                                           underlineColorAndroid="transparent"
                                           onChangeText={(text) => {
                                               this.setLow(text)
                                           }}
                                           value={this.state.low}
                                           onFocus={() => {
                                               this.scrollTextY();
                                           }}
                                           onBlur={() => {
                                               this.scrollBegin();
                                           }}
                                />
                                <Text style={styles.itemBlank}
                                      numberOfLines={1}
                                      allowFontScaling={false}> - </Text>
                                <TextInput style={styles.priceInputStyle}
                                           placeholder="最高价"
                                           placeholderTextColor={Colors.text_light_grey}
                                           underlineColorAndroid="transparent"
                                           keyboardType='numeric'
                                           selectionColor="red"
                                           onChangeText={(text) => {
                                               this.setHigh(text)
                                           }}
                                           value={this.state.high}
                                           onFocus={() => {
                                               this.scrollTextY();
                                           }}
                                           onBlur={() => {
                                               this.scrollBegin();
                                           }}
                                />
                            </View>
                            <View style={{flexDirection: 'row', flexWrap: 'wrap'}}>

                                {
                                    jiage && jiage.length > 0 ? jiage.map((item, index) => {
                                        return (
                                            <TouchableWithoutFeedback
                                                onPress={
                                                    () => {
                                                        this._PressTabjiage(index)
                                                    }
                                                }
                                            >
                                                <View style={[styles.tabTextView, {
                                                    backgroundColor: this.state.selectedJiage.indexOf(index) > -1 ?
                                                        '#FFEBE8' : '#EDEDED',
                                                    marginRight: index === 2 ? 0 : ScreenUtil.scaleSize(20)
                                                }]}>
                                                    <Text allowFontScaling={false}
                                                          style={styles.tabText}>{item.join('-')}</Text>
                                                    {this.state.selectedJiage.indexOf(index) > -1 ?
                                                        <Image style={{
                                                            position: 'absolute',
                                                            right: 0,
                                                            bottom: 0,
                                                            height: ScreenUtil.scaleSize(30),
                                                            width: ScreenUtil.scaleSize(30),
                                                        }}
                                                               source={require('../../../../foundation/Img/shoppingPage/selected_.png')}/>
                                                        : null}
                                                </View>
                                            </TouchableWithoutFeedback>)
                                    })
                                        : null}</View>
                            {/*商品类型*/}
                            {/* <Text style={styles.titleTextContainer}
                             allowFontScaling={false}>商品类型</Text>
                             <View style={{flexDirection: 'row', flexWrap: 'wrap'}}>

                             {
                             productType.map((item, index) => {
                             return (
                             <TouchableWithoutFeedback
                             onPress={
                             () => {
                             this._PressTab(index)
                             }
                             }
                             >
                             <View style={[styles.tabTextView, {
                             backgroundColor: this.state.selectedType.indexOf(index) > -1 ?
                             '#FFEBE8' : '#EDEDED',
                             marginRight: index === 2 ? 0 : ScreenUtil.scaleSize(20)
                             }]}>
                             <Text allowFontScaling={false}
                             style={styles.tabText}>{item}</Text>
                             {this.state.selectedType.indexOf(index) > -1 ?
                             <Image style={{
                             position: 'absolute',
                             right: 0,
                             bottom: 0,
                             height: ScreenUtil.scaleSize(30),
                             width: ScreenUtil.scaleSize(30),
                             borderBottomRightRadius: ScreenUtil.scaleSize(4)
                             }}
                             source={require('../../../../foundation/Img/shoppingPage/selected_.png')}/>
                             : null}
                             </View>
                             </TouchableWithoutFeedback>)
                             })}</View>*/}

                            <View style={{height: ScreenUtil.scaleSize(600), width: ScreenUtil.screenW}}/>
                        </ScrollView>
                        <View style={styles.buttons}>
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {
                                    this.resetClick()
                                }}
                                style={styles.btnLeft}
                            >
                                <Text style={styles.resetBtn} allowFontScaling={false}>重置</Text>
                            </TouchableOpacity>
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {

                                    this.props.submit({
                                        prices: this.state.sendPrices,
                                        brand_code: this.state.brand_codes,
                                        high: this.state.high,
                                        low: this.state.low,
                                    });
                                }}
                                style={styles.btnRight}
                            >
                                <Image style={styles.rightBtn}
                                       source={require('../../../../foundation/Img/searchpage/icon_rightbtn_.png')}/>
                                <Text style={styles.confirmBtn} allowFontScaling={false}>确定</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                    <Toast ref="toast"/>
                </View>
            </Modal>
        )
    }
}

const styles = StyleSheet.create({
    outView: {
        flexDirection: 'row',
        flex: 1
    },
    left: {
        backgroundColor: '#000',
        opacity: 0.5,
        width: ScreenUtil.scaleSize(98),
        height: ScreenUtil.screenH
    },
    right: {
        flex: 1,
        backgroundColor: '#fff',
        height: ScreenUtil.screenH,
        //width: ScreenUtil.screenW - ScreenUtil.scaleSize(98),
        paddingLeft: ScreenUtil.scaleSize(28),
        paddingRight: ScreenUtil.scaleSize(32),
    },
    titleContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        width: ScreenUtil.scaleSize(592)
    },
    titleTextContainer: {
        fontSize: ScreenUtil.setSpText(28),
        color: Colors.text_black,
        marginTop: ScreenUtil.setSpText(20),
        marginBottom: ScreenUtil.setSpText(20),
    },
    brandSelection: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(24),
        width: ScreenUtil.scaleSize(300),
        textAlign: 'right',
    },
    collapseArrow: {
        height: ScreenUtil.scaleSize(12),
        width: ScreenUtil.scaleSize(24),
        marginLeft: ScreenUtil.scaleSize(10),
        marginRight: ScreenUtil.scaleSize(20)
    },
    priceSelection: {
        flexDirection: 'row',
        alignItems: 'center',
        marginTop: ScreenUtil.scaleSize(20),
        marginBottom: ScreenUtil.scaleSize(30)
    },
    priceInputStyle: {
        width: ScreenUtil.scaleSize(260),
        height: ScreenUtil.scaleSize(70),
        textAlign: 'center',
        textAlignVertical: 'center',
        backgroundColor: '#EEEEEE',
        fontSize: ScreenUtil.setSpText(24),
        borderRadius: 5,
    },
    buttons: {
        flexDirection: 'row',
        height: ScreenUtil.scaleSize(88),
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0
    },
    btnLeft: {
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'white',
        borderTopWidth: ScreenUtil.scaleSize(1),
        borderTopColor: Colors.line_grey,
        height: ScreenUtil.scaleSize(87),
        width: ScreenUtil.scaleSize(326)
    },
    btnRight: {
        justifyContent: 'center',
        alignItems: 'center',
        width: ScreenUtil.scaleSize(326)
    },
    resetBtn: {
        fontSize: ScreenUtil.setSpText(30),
        color: '#333333',
    },
    confirmBtn: {
        fontSize: ScreenUtil.setSpText(30),
        color: 'white',
        backgroundColor: 'transparent'
    },
    rightBtn: {
        position: 'absolute',
        bottom: 0,
        resizeMode: 'stretch',
        height: ScreenUtil.scaleSize(88),
        width: (ScreenUtil.screenW - ScreenUtil.scaleSize(98)) / 2
    },
    tabTextView: {
        borderRadius: ScreenUtil.scaleSize(8),
        width: ScreenUtil.scaleSize(184),
        height: ScreenUtil.scaleSize(56),
        marginBottom: ScreenUtil.scaleSize(20),
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: ScreenUtil.scaleSize(10)
    },
    tabText: {
        includeFontPadding: false,
        color: '#333',
        fontSize: ScreenUtil.setSpText(24),
    }
})