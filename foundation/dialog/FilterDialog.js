/**
 * @author Xiang
 *
 * 筛选
 */
import React from 'react'
import {connect} from 'react-redux'
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Image,
    TextInput,
    Modal,
    TouchableOpacity,
    FlatList,
} from 'react-native'
import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';
import TextItem from '../Search/TextItem';
import LabelText from '../Search/LabelText';
import Toast, {DURATION} from 'react-native-easy-toast';
//let priceData = ['0-200', '200-500', '500-2000', '2000-5000',];
let productType = ['主播推荐', '团购', '全球购', '促销商品'];
let key = 0;
class FilterDialog extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            open: this.props.open,
            selectedLogo: '',//选中品牌文字
            low: '',
            high: '',
            cancelAll: false,
            selectedLogoCodeArry: this.props.selectedLogoCodeArry,//上次选中品牌
            selectedProductType: this.props.selectedProductType,//上次选中商品类型
            otherSelects: this.props.otherSelects,//上次选中其他分类
        }
        this.logoClick = this.logoClick.bind(this);//品牌点击
        this.resetClick = this.resetClick.bind(this);//重置点击
        this.confirmClick = this.confirmClick.bind(this);//确定点击
        this.selectedCodeArry = [];//选中品牌code数组
        this.selectedNameArry = [];//选中品牌name数组
        this.selectsArray = [];//其他分类
        this.productTypes = [0, 0, 0, 0];
    }

    componentWillReceiveProps(nextProps) {
        this.selectedCodeArry = nextProps.selectedLogoCodeArry;
        this.selectedNameArry = nextProps.selectedNameArry;
        this.productTypes = nextProps.selectedProductType;
        this.selectsArray = nextProps.otherSelects;
        let tmpStr = '';
        for (let i = 0; i < this.selectedNameArry.length; i++) {
            if (i === 0) {
                tmpStr = tmpStr + this.selectedNameArry[i];
            } else {
                tmpStr = tmpStr + "/" + this.selectedNameArry[i];
            }
        }
        this.setState({
            selectedLogo: tmpStr,
            open: nextProps.open,
            selectedLogoCodeArry: nextProps.selectedLogoCodeArry,//上次选中品牌
            selectedProductType: nextProps.selectedProductType,//上次选中商品类型
            otherSelects: nextProps.otherSelects,//上次选中其他分类
        });
    }


    openBrandDialog(logos, names, types, others) {
        this.props.openBrandDialog(logos, names, types, others);
    }

    //品牌点击
    logoClick(id, text, index) {
        let position = this.selectedCodeArry.indexOf(id, 0);
        let tmpStr = '';
        if (position > -1) {
            this.selectedCodeArry.splice(position, 1);
            this.selectedNameArry.splice(position, 1);
            for (let i = 0; i < this.selectedNameArry.length; i++) {
                if (i === 0) {
                    tmpStr = tmpStr + this.selectedNameArry[i];
                } else {
                    tmpStr = tmpStr + "/" + this.selectedNameArry[i];
                }
            }
            this.setState({
                selectedLogo: tmpStr,
            });
            return true;
        } else {
            if (this.selectedCodeArry.length === 5) {
                this.refs.toast.show("筛选个数最多不超过5个", DURATION.LENGTH_LONG);
                return false;
            } else {
                this.selectedCodeArry.push(id);
                this.selectedNameArry.push(text);
                if (this.selectedCodeArry.length == 1) {
                    this.setState({
                        selectedLogo: this.state.selectedLogo + text,
                    });
                } else {
                    this.setState({
                        selectedLogo: this.state.selectedLogo + "/" + text,
                    });
                }
                return true;
            }
        }
    }

    //价格label点击
    // priceLabelClick(item,index){
    //     let arr = item.split("-");
    //     this.props.lowPrice(arr[0]);
    //     this.props.highPrice(arr[1]);
    //     this.setState({
    //         low:arr[0],
    //         high:arr[1],
    //         selectedIndex:index
    //     })
    //
    // }
    //重置
    resetClick() {
        this.state.low = '';
        this.state.high = '';
        this.state.selectedLogo = '';
        this.state.selectedLogoCodeArry = [];//上次选中品牌
        this.state.selectedProductType = [];//上次选中商品类型
        this.state.otherSelects = []; //上次选中其他分类
        // this.setState({
        //     low:'',
        //     high:'',
        //     selectedLogo:'',
        // });
        this.selectedCodeArry = [];//选中品牌code数组
        this.selectedNameArry = [];//选中品牌name数组
        this.productTypes = [0, 0, 0, 0];
        for (let i = 0; i < this.selectsArray.length; i++) {
            this.selectsArray[i].propertyValue = [];
        }
        this.state.cancelAll = !this.state.cancelAll;
        this.forceUpdate();
        //this.state.cancelAll = false;
    }

    //确定
    confirmClick(selectedCodeArry, selectsArray, productTypes, low, high, names) {
        this.props.confirmClick(selectedCodeArry, selectsArray, productTypes, low, high, names);
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

    labelClick(item, index, j, sxlist) {
        if (this.selectsArray.length > 0) {
            let tmp = this.selectsArray[j];
            let tmpArr = tmp.propertyValue;
            let position = tmpArr.indexOf(item, 0);
            if (position > -1) {//存在
                tmpArr.splice(position, 1);
            } else {
                tmpArr.push(item);
            }
            this.selectsArray[j].propertyValue = tmpArr;
        } else {
            let obj;
            if (sxlist !== null && sxlist.length > 0) {
                for (let i = 0; i < sxlist.length; i++) {
                    obj = new Object();
                    obj.propertyName = sxlist[i].propertyName;
                    obj.propertyValue = new Array();
                    if (i === j) {
                        obj.propertyValue.push(item);
                    }
                    this.selectsArray.push(obj);
                }
            }
        }
    }

    //商品类型点击
    productTypeClick(item, i) {
        switch (i) {
            case 0 :
                if (this.productTypes[0] === 0) {
                    this.productTypes[0] = 1;
                } else {
                    this.productTypes[0] = 0;
                }
                break;
            case 1 :
                if (this.productTypes[1] === 0) {
                    this.productTypes[1] = 1;
                } else {
                    this.productTypes[1] = 0;
                }
                break;
            case 2 :
                if (this.productTypes[2] === 0) {
                    this.productTypes[2] = 1;
                } else {
                    this.productTypes[2] = 0;
                }
                break;
            case 3 :
                if (this.productTypes[3] === 0) {
                    this.productTypes[3] = 1;
                } else {
                    this.productTypes[3] = 0;
                }
                break;
            default:
                break;
        }
    }

    selectOrNot(selectedCodeArry, item) {
        if (selectedCodeArry.indexOf(item.propertyName) > -1) {
            return true;
        } else {
            return false;
        }
    }

    productSelectedOrNot(index, selectedProductType) {
        switch (index) {
            case 0:
                if (selectedProductType[0] === 1) {
                    return true;
                } else {
                    return false;
                }
            case 1:
                if (selectedProductType[1] === 1) {
                    return true;
                } else {
                    return false;
                }
            case 2:
                if (selectedProductType[2] === 1) {
                    return true;
                } else {
                    return false;
                }
            case 3:
                if (selectedProductType[3] === 1) {
                    return true;
                } else {
                    return false;
                }
            default:
                return false;
        }
    }

    otherSelectOrNot(title, item, otherSelects) {
        for (let i = 0; i < otherSelects.length; i++) {
            if (otherSelects[i].propertyName === title) {
                if (otherSelects[i].propertyValue.indexOf(item) > -1) {
                    return true;
                } else {
                    return false;
                }
            }
        }
        return false;
    }

    renderContext(j, data, title, sxlist) {
        return (
            <FlatList
                extraData={this.state.cancelAll}
                data={ data }
                numColumns={3}
                renderItem={({item, index}) => {
                    return (
                        <LabelText selected={this.otherSelectOrNot(title, item, this.state.otherSelects)}
                                   labelText={item}
                                   labelClick={() => {
                                       this.labelClick(item, index, j, sxlist)
                                   }}/>
                    );
                }}
            />
        )
    }

    render() {
        let {brandinfo, sxlist} = this.props;
        // let linearGradient = new LinearGradient({
        //         '.1': '#FF6048', // blue in 1% position
        //         '1': '#E5290D' // opacity white in 100% position
        //     },
        //     "0", "0", "0", "400"
        // );
        return (
            <Modal
                onRequestClose={() => {
                }}
                animationType='fade'
                visible={this.state.open}
                transparent={true}
                //style={styles.modal}
            >
                <View style={{flexDirection: 'row', flex: 1, alignItems: "flex-end", width: ScreenUtil.screenW}}>
                    <TouchableOpacity activeOpacity={1} onPress={() => {
                        this.confirmClick(this.selectedCodeArry, this.selectsArray, this.productTypes, this.state.low, this.state.high, this.selectedNameArry)
                    }}>
                        <View style={styles.overlay}/>
                    </TouchableOpacity>
                    <View style={styles.container}>
                        <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
                            <View style={styles.rowContainer}>
                                <View style={[styles.titleContainer, {marginTop: ScreenUtil.scaleSize(64),}]}>
                                    <Text style={styles.titleTextContainer} allowFontScaling={false}>品牌</Text>
                                    <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                        <Text style={styles.brandSelection}
                                              numberOfLines={1} allowFontScaling={false}>{this.state.selectedLogo}</Text>
                                        <Image style={styles.collapseArrow}
                                               source={require('../Img/dialog/collapse_down@3x.png')}/>
                                    </View>
                                </View>

                                <FlatList
                                    extraData={this.state.cancelAll}
                                    data={ brandinfo }
                                    numColumns={3}
                                    renderItem={({item, index}) => {
                                        return (

                                            index < 8 ?
                                                <TextItem itemText={item}
                                                          selected={this.selectOrNot(this.state.selectedLogoCodeArry, item)}
                                                          textClick={(id, text) => {
                                                              return this.logoClick(id, text, index)
                                                          }}/>
                                                :
                                                <TouchableOpacity activeOpacity={1}
                                                                  onPress={() => {
                                                                      this.openBrandDialog(this.selectedCodeArry, this.selectedNameArry, this.productTypes, this.selectsArray)
                                                                  }}
                                                                  style={{
                                                                      justifyContent: 'center',
                                                                      alignItems: 'center',
                                                                      flexDirection: 'row',
                                                                      width: ScreenUtil.scaleSize(184)
                                                                  }}
                                                >
                                                    <Text style={styles.seeAll} allowFontScaling={false}>查看全部</Text>
                                                    <Image style={styles.rightGrey}
                                                           source={require('../Img/searchpage/Icon_right_grey_@3x.png')}/>
                                                </TouchableOpacity>


                                        );
                                    }}

                                />
                                <Text style={styles.titleTextContainer} allowFontScaling={false}>价格区间(元)</Text>
                                <View style={styles.priceSelection}>
                                    <TextInput style={styles.priceInputStyle}
                                               placeholder="最低价"
                                               placeholderTextColor={Colors.text_light_grey}
                                               keyboardType='numeric'
                                               onChangeText={(text) => {
                                                   this.setLow(text)
                                               }}
                                               value={this.state.low}
                                    />
                                    <Text style={styles.itemBlank} allowFontScaling={false}>—</Text>
                                    <TextInput style={styles.priceInputStyle}
                                               placeholder="最高价"
                                               placeholderTextColor={Colors.text_light_grey}
                                               keyboardType='numeric'
                                               onChangeText={(text) => {
                                                   this.setHigh(text)
                                               }}
                                               value={this.state.high}
                                    />
                                </View>
                                <Text style={styles.titleTextContainer} allowFontScaling={false}>商品类型</Text>
                                <FlatList
                                    style={styles.goodsType}
                                    extraData={this.state.cancelAll}
                                    data={ productType }
                                    numColumns={3}
                                    renderItem={({item, index}) => {
                                        return (
                                            <LabelText labelText={item}
                                                       selected={this.productSelectedOrNot(index, this.state.selectedProductType)}
                                                       labelClick={() => {
                                                           this.productTypeClick(item, index)
                                                       }}/>
                                        );
                                    }}
                                />
                                <FlatList
                                    extraData={this.state.cancelAll}
                                    data={ sxlist }
                                    renderItem={({item, index}) => {
                                        return (
                                            <View>
                                                <Text style={styles.titleTextContainer} allowFontScaling={false}>{item.propertyName}</Text>
                                                {
                                                    this.renderContext(index, item.propertyValue, item.propertyName, sxlist)
                                                }
                                            </View>
                                        );
                                    }}
                                />
                            </View>
                        </ScrollView>
                        <View style={styles.buttons}>
                            <TouchableOpacity activeOpacity={1}
                                              onPress={() => {
                                                  this.resetClick()
                                              }}
                                              style={styles.btnLeft}
                            >
                                <Text style={styles.resetBtn} allowFontScaling={false}>重置</Text>
                            </TouchableOpacity>
                            <TouchableOpacity activeOpacity={1}
                                              onPress={() => {
                                                  this.confirmClick(this.selectedCodeArry, this.selectsArray, this.productTypes, this.state.low, this.state.high, this.selectedNameArry)
                                              }}
                                              style={styles.btnRight}
                            >
                                <Image style={styles.rightBtn}
                                       source={require('../../foundation/Img/searchpage/icon_rightbtn_@2x.png')}/>
                                <Text style={styles.confirmBtn} allowFontScaling={false}>确定</Text>
                            </TouchableOpacity>
                        </View>
                    </View>
                </View>
                <Toast ref="toast"/>
            </Modal>
        )
    }
}
const styles = StyleSheet.create({
    modal: {
        height: ScreenUtil.screenH,
        width: ScreenUtil.screenW,
    },
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: 'white',
        width: ScreenUtil.screenW - ScreenUtil.scaleSize(120)
    },
    overlay: {
        height: ScreenUtil.screenH,
        backgroundColor: '#DDDDDD', opacity: 0.5,
        width: ScreenUtil.scaleSize(64)
    },
    scrollView: {
        backgroundColor: Colors.background_white,
        height: ScreenUtil.screenH - ScreenUtil.scaleSize(150),
        paddingLeft: ScreenUtil.scaleSize(12)
    },
    titleTextContainer: {
        fontSize: ScreenUtil.setSpText(28),
        color: Colors.text_black,
        marginTop: ScreenUtil.setSpText(20),
        marginBottom: ScreenUtil.setSpText(20),
    },
    rowContainer: {},
    titleContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
    gridContainer: {},
    brandSelection: {
        color: Colors.main_color,
        fontSize: ScreenUtil.setSpText(24),
        width: ScreenUtil.scaleSize(300),
        textAlign: 'right',
    },
    typeSelection: {
        color: Colors.text_dark_grey,
    },
    rightGrey: {
        height: ScreenUtil.scaleSize(24),
        width: ScreenUtil.scaleSize(16),
        marginLeft: ScreenUtil.scaleSize(10),
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
    itemLineStyle: {
        flex: 1,
        paddingTop: 5,
        paddingBottom: 5,
        flexDirection: 'row',
    },
    itemStyleNormal: {
        // flex: 1,
        fontSize: ScreenUtil.setSpText(24),
        textAlign: 'center',
        width: ScreenUtil.scaleSize(184),
        height: ScreenUtil.scaleSize(56),
        //marginLeft: 3,
        marginRight: ScreenUtil.scaleSize(18),
        marginTop: ScreenUtil.scaleSize(20),
        marginBottom: ScreenUtil.scaleSize(10),
        color: Colors.text_black,
        borderRadius: ScreenUtil.scaleSize(12),
        backgroundColor: Colors.line_grey,
        paddingTop: ScreenUtil.scaleSize(12)
        // lineHeight:ScreenUtil.scaleSize(56),
        //textAlignVertical:'center'
    },
    itemStyleSelect: {
        fontSize: ScreenUtil.setSpText(24),
        textAlign: 'center',
        width: ScreenUtil.scaleSize(184),
        height: ScreenUtil.scaleSize(56),
        marginRight: ScreenUtil.scaleSize(18),
        marginTop: ScreenUtil.scaleSize(20),
        marginBottom: ScreenUtil.scaleSize(10),
        color: '#F31918',
        borderRadius: ScreenUtil.scaleSize(12),
        backgroundColor: '#FFEBE8',
        paddingTop: ScreenUtil.scaleSize(12)
        // lineHeight:ScreenUtil.scaleSize(56),
        // textAlignVertical:'center'
    },
    imgStyle: {
        width: ScreenUtil.scaleSize(30),
        height: ScreenUtil.scaleSize(30),
        position: 'absolute',
        right: ScreenUtil.scaleSize(18),
        bottom: ScreenUtil.scaleSize(10),
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
    itemBlank: {
        //flex: 1,
        marginLeft: ScreenUtil.scaleSize(10),
        marginRight: ScreenUtil.scaleSize(10),
    },
    buttons: {
        flexDirection: 'row',
        height: ScreenUtil.scaleSize(88),
        marginRight: -1
    },
    btnLeft: {
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: 'white',
        borderTopWidth: ScreenUtil.scaleSize(1),
        borderTopColor: Colors.line_grey,
        height: ScreenUtil.scaleSize(87),
        flexGrow: 1,
    },
    btnRight: {
        justifyContent: 'center',
        alignItems: 'center',
        flexGrow: 1,
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
    seeAll: {
        fontSize: ScreenUtil.setSpText(24),
        color: '#333333',
        //textAlign:'right',
    },
    titleText: {
        color: '#333333',
        fontSize: 16,
        flex: 1,
        paddingTop: 5,
        paddingBottom: 5,
    },
    goodsType: {
        marginBottom: ScreenUtil.scaleSize(30)
    }
})
export default connect(state => ({}),
    dispatch => ({})
)(FilterDialog)
