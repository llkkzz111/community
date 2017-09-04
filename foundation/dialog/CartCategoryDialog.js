/**
 * @author Xiang
 *
 * 商品规格选择弹窗：
 * 商品图片、价格、当前选中规格、尺寸、颜色、赠品、数量
 * 调用页面：
 * 购物车、商品详情
 */
import React, {Component, PropTypes} from 'react';
import {connect} from 'react-redux';
import * as ClassificationPageAction from '../../app/actions/classificationpageaction/ClassificationPageAction';
import * as CartAction from '../../app/actions/cartaction/CartAction'
import showLoadingDialog from '../../app/actions/dialogaction/DialogUtils'

import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Image,
    Dimensions,
    Modal,
    FlatList,
    TouchableOpacity,
    Alert,
} from 'react-native';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
let {width, height} = Dimensions.get('window');
class CartCategoryDialog extends Component {
    constructor(props) {
        super(props);
        this.state = {
            data: {},
            selectCategory: '',
            selectCodeStr: '',
        }
    }

    componentWillMount() {

        this.setState({
            data: this.props.data,
            selectCategory: this.props.data.cs_name,
            selectCodeStr: this.props.data.cs_code,
        });
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            data: nextProps.data,
            selectCategory: nextProps.data.cs_name,
            selectCodeStr: nextProps.data.cs_code,
        });
    }

    getSelectStr = (size, color, sizeCode, colorCode) => {
        let str = '';
        if (size.length > 0) {
            str += '“' + size + '”'
        }
        if (color.length > 0) {
            str += '  “' + color + '”'
        }
        let codeStr = '';
        if (sizeCode.length > 0) {
            codeStr += sizeCode + ':'
        }
        if (colorCode.length > 0) {
            codeStr += colorCode + ':'
        }
        return {str: str, codeStr: codeStr};
    }

    render() {
        return (
            <Modal onRequestClose={() => {
            }}
                   animationType="fade"
                   transparent={true}
                   style={DialogStyle.container}
                   visible={this.props.show}>

                <View style={DialogStyle.contentContainer}>
                    <Text
                        onPress={() => {
                            this.props.closeCategoryDialog()
                        }}
                        style={{flex: 1}} allowFontScaling={false}/>

                    <View>
                        <View style={DialogStyle.titleContainer}>
                            <View style={DialogStyle.titleLeft}/>
                            <View style={DialogStyle.imgBorder}>
                                <Image
                                    source={{uri: this.state.data.uri}}
                                    style={DialogStyle.titleImg}/>
                            </View>
                            <View style={DialogStyle.titleTextContainer}>
                                <View style={DialogStyle.titleText}>
                                    <Text
                                        style={DialogStyle.price} allowFontScaling={false}>¥{String(this.state.data.price)}</Text>
                                    <Text style={DialogStyle.selection} allowFontScaling={false}>已选：{this.state.selectCategory}</Text>
                                </View>
                                <TouchableOpacity activeOpacity={1} style={DialogStyle.titleClose}
                                                  onPress={() => this.props.closeCategoryDialog()}>
                                    <Image source={require('../Img/dialog/icon_close_@3x.png')}
                                           style={DialogStyle.titleCloseImg}/>
                                </TouchableOpacity>
                            </View>
                        </View>
                        <View style={DialogStyle.divideLine}/>
                    </View>
                    <View style={DialogStyle.scrollView}>
                        <ScrollView
                            style={{paddingLeft: ScreenUtils.scaleSize(32), paddingRight: ScreenUtils.scaleSize(32),}}>
                            <SizeColorComponent
                                selSize={this.state.data.size_name}
                                selColor={this.state.data.color_name}
                                selSCode={this.state.data.size_code}
                                selCCode={this.state.data.color_code}
                                sizeItems={this.state.data.sizes}
                                colorItems={this.state.data.colors}
                                onSelectionChanged={(size, color, sizeCode, colorCode) => {
                                    this.setState({
                                        selectCategory: this.getSelectStr(size, color, sizeCode, colorCode).str,
                                        selectCodeStr: this.getSelectStr(size, color, sizeCode, colorCode).codeStr
                                    })
                                }
                                }/>
                            {this.state.data.giftExistFlg &&
                            <View>
                                <View style={DialogStyle.giftTitleContainer}>
                                    <Text style={DialogStyle.giftTitle} allowFontScaling={false}>赠品</Text>
                                </View>
                                <GiftListComponent selectGiftList={this.state.data.giftArr}
                                                   shoppingGiftList={this.state.data.shopGiftArr}
                                                   size={this.state.data.qty}
                                                   openGiftPickUpDialog={(data) => this.props.openGiftDialog(data, this.state.selectCategory, "0001:10002")}/>
                            </View>}

                        </ScrollView>
                    </View>

                    <TouchableOpacity activeOpacity={1} style={{
                        justifyContent: 'center',
                        alignItems: 'center',
                        height: ScreenUtils.scaleSize(100),
                    }} onPress={() => {
                        this.props.confirmCommercialSpecification({
                            selectedCategory: this.state.selectCategory,
                            selectCodeStr: this.state.selectCodeStr,
                        })
                    }}>
                        <Image source={require("../../foundation/Img/cart/Element_waikuang_@3x.png")} style={{
                            width: width,
                            height: ScreenUtils.scaleSize(100),
                            position: 'absolute',
                            bottom: 0
                        }}/>
                        <Text style={DialogStyle.confirmBtn} allowFontScaling={false}>确 定</Text>
                    </TouchableOpacity>
                </View>
            </Modal>
        );
    }
}
class GiftListComponent extends React.PureComponent {
    constructor(props) {
        super(props)
        this.selectGiftList = this.props.selectGiftList.slice(0);
        this.shoppingGiftList = this.props.shoppingGiftList.slice(0);
        this.state = {
            size: 1,
            data: [],
        }
    }

    componentWillMount() {
        this.setState({
            size: this.props.size,
        });
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            size: nextProps.size,
        });
    }

    componentDidMount() {
        /*if (this.props.selectGiftList.length < this.state.size) {
         for (let i = 0; i < this.state.size - this.props.selectGiftList.length; i++) {
         this.selectGiftList.push({
         item_name: "选择赠品",
         gift_item_code: "",
         nextAction: "",
         })
         }
         }*/
        this.setState({data: this.props.selectGiftList});
    }

    render() {
        return (
            <FlatList
                data={this.state.data}
                renderItem={({item}) => {
                    return this.renderListItem(item)
                }
                }
            />
        )
    }

    renderListItem(item) {
        return (
            <View>
                <View style={DialogStyle.giftListItem}>
                    <Text style={DialogStyle.checkedGift} numberOfLines={1} allowFontScaling={false}>{item.item_name}</Text>
                    <TouchableOpacity activeOpacity={1}
                        /* onPress={() => {
                         this.props.openGiftPickUpDialog({giftCode: item.gift_item_code});
                         }}*/
                        style={{flexDirection: 'row', alignItems: 'center'}}
                    >
                        <Text style={DialogStyle.getGift} allowFontScaling={false}>{item.nextAction}</Text>
                        {/*<Image style={DialogStyle.rightArrow}
                         source={require('../Img/dialog/Icon_right_hui_@3x.png')}/>*/}
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
}
class SizeColorComponent extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            noStockCodes: '',
            sizeSelectStr: this.props.selSize,
            sizeSelectCode: this.props.selSCode,
            colorSelectStr: this.props.selColor,
            colorSelectCode: this.props.selCCode,
        }
    }

    render() {
        return (
            <View>
                <Text style={DialogStyle.categoryTitle} allowFontScaling={false}>尺寸</Text>
                <SizeItems
                    selSize={this.props.selSize}
                    items={this.props.sizeItems}
                    noStockCodes={this.state.noStockCodes}
                    sizeSelect={this.state.sizeSelectStr}
                    onSelect={(i) => {
                        this.setState({
                            noStockCodes: this.props.sizeItems[i].cs_off,
                            sizeSelectStr: this.props.sizeItems[i].cs_name,
                            sizeSelectCode: this.props.sizeItems[i].cs_code,
                        })
                        this.props.onSelectionChanged(this.props.sizeItems[i].cs_name, this.state.colorSelectStr, this.props.sizeItems[i].cs_code, this.state.colorSelectCode);
                    }}

                />
                <Text style={DialogStyle.categoryTitle} allowFontScaling={false}>颜色</Text>
                <ColorItems
                    items={this.props.colorItems}
                    selColor={this.props.selSize}
                    noStockCodes={this.state.noStockCodes}
                    colorSelect={this.state.colorSelectStr}
                    onSelect={(i) => {
                        this.setState({
                            noStockCodes: this.props.colorItems[i].cs_off,
                            colorSelectStr: this.props.colorItems[i].cs_name,
                            colorSelectCode: this.props.colorItems[i].cs_code,
                        })
                        this.props.onSelectionChanged(this.state.sizeSelectStr, this.props.colorItems[i].cs_name, this.state.sizeSelectCode, this.props.colorItems[i].cs_code);
                    }}

                />
            </View>
        )
    }
}
class SizeItems extends React.PureComponent {
    render() {
        return (
            <View style={DialogStyle.categoryItems}>
                {
                    this.props.items.map((item, i) => {
                        let noStock = this.props.noStockCodes.includes(item.cs_code);
                        let select = item.cs_name === this.props.sizeSelect;
                        let itemColor = noStock ? '#DDDDDD' : select ? '#E5290D' : '#999999';

                        return (
                            <Text
                                onPress={() => {
                                    this.props.onSelect(i);
                                }
                                }
                                    style={[DialogStyle.itemNormal, {
                                    color: itemColor,
                                    borderColor: itemColor,
                                }]} allowFontScaling={false}>{item.cs_name}</Text>
                                    )
                                    })
                                    }
                        </View>
                        )
                    }
                }
                class ColorItems extends React.PureComponent {
                render() {
                return (
                <View style={DialogStyle.categoryItems}>
                {
                    this.props.items.map((item, i) => {
                        let noStock = this.props.noStockCodes.includes(item.cs_code);
                        let select = item.cs_name === this.props.colorSelect;
                        let itemColor = noStock ? '#DDDDDD' : select ? '#E5290D' : '#999999';
                        return (
                            <Text
                                onPress={() => {
                                    this.props.onSelect(i);
                                }
                                }
                                style={[DialogStyle.itemNormal, {
                                    color: itemColor,
                                    borderColor: itemColor,
                                }]} allowFontScaling={false}>{item.cs_name}</Text>
                        )
                    })
                }
                </View>
                );
            }
            }
                const DialogStyle = StyleSheet.create({
                itemNormal: {
                padding: ScreenUtils.scaleSize(6),
                textAlign: 'center',
                textAlignVertical: 'center',
                borderWidth: 1,
                borderRadius: 3,
                backgroundColor: 'white',
                marginVertical:ScreenUtils.scaleSize(5),
                marginHorizontal:ScreenUtils.scaleSize(5),
                minWidth:ScreenUtils.scaleSize(50)
            },
                container: {
                flex: 1,
                justifyContent: 'flex-end',
            },
                contentContainer: {
                width: width,
                height: height,
                flex: 1,
                flexDirection: 'column',
                backgroundColor: 'rgba(0,0,0,0.5)',
                justifyContent: 'flex-end',
            },
                titleContainer: {
                flexDirection: 'row',
            },
                scrollView: {
                height: ScreenUtils.scaleSize(450),
                width: width,
                backgroundColor: 'white',
            },
                titleLeft: {
                marginTop: ScreenUtils.scaleSize(50),
                width: ScreenUtils.scaleSize(32),
                backgroundColor: 'white',
            },
                imgBorder: {
                backgroundColor: 'white',
                borderTopLeftRadius: 3,
                borderTopRightRadius: 3,
            },
                titleImg: {
                borderRadius: 3,
                borderWidth: 5,
                borderColor: 'white',
                width: ScreenUtils.scaleSize(240),
                height: ScreenUtils.scaleSize(240),
                marginBottom: ScreenUtils.scaleSize(40),
                resizeMode: 'cover',
            },
                titleTextContainer: {
                flex: 1,
                flexDirection: 'row',
                marginTop: ScreenUtils.scaleSize(50),
                paddingLeft: ScreenUtils.scaleSize(20),
                paddingRight: ScreenUtils.scaleSize(20),
                backgroundColor: 'white',
            },
                titleText: {
                height: ScreenUtils.scaleSize(190),
                flex: 1,
                justifyContent: 'flex-end'
            },
                titleClose: {
                height: ScreenUtils.scaleSize(60),
                width: ScreenUtils.scaleSize(60),
                justifyContent: 'center',
                alignItems: 'center',
                marginTop: ScreenUtils.scaleSize(32),
                marginRight: ScreenUtils.scaleSize(12),
            },
                titleCloseImg: {
                width: ScreenUtils.scaleSize(30),
                height:  ScreenUtils.scaleSize(15),
                resizeMode: 'contain',
            },
                price: {
                fontSize: ScreenUtils.setSpText(36),
                color: '#E5290D',
                marginBottom: ScreenUtils.scaleSize(10),
            },
                selection: {
                fontSize: ScreenUtils.setSpText(24),
            },
                categoryTitle: {
                marginTop: ScreenUtils.setSpText(20),
                marginBottom: ScreenUtils.setSpText(20),
                color: '#333333',
                fontSize:ScreenUtils.setSpText(28)
            },
                categoryItems: {
                flexDirection: 'row',
                marginBottom: ScreenUtils.scaleSize(20),
                flexWrap:"wrap",

            },
                categoryItemText: {
                padding: ScreenUtils.scaleSize(10),
                marginLeft: ScreenUtils.scaleSize(10),
                marginRight: ScreenUtils.scaleSize(10),
                backgroundColor: '#666666',
                color: 'white',
                borderRadius: ScreenUtils.scaleSize(16),
            },
                giftTitleContainer: {
                paddingTop: ScreenUtils.scaleSize(10),
                paddingBottom: ScreenUtils.scaleSize(10),
                flexDirection: 'row',
            },
                giftTitle: {
                flex: 1,
                color: '#333333',
            },
                giftChange: {
                color: '#333333',
            },
                giftListItem: {
                flexDirection: 'row',
                paddingTop: ScreenUtils.scaleSize(10),
            },
                checkedGift: {
                flex: 1,
                color: '#666666',
            },
                getGift: {
                textAlignVertical: 'center',
                textAlign: 'right',
                color: '#666666',
            },
                giftListItem: {
                flexDirection: 'row',
            },
                giftItemText: {
                flex: 1,
                fontSize: ScreenUtils.setSpText(32),
                color: '#333333',
            },
                giftItemNum: {
                fontSize: 14,
                color: '#333333'
            },
                rightArrow: {
                height: ScreenUtils.scaleSize(20),
                width: ScreenUtils.scaleSize(14),
                marginLeft: ScreenUtils.scaleSize(20),
                resizeMode: 'contain',
            },
                selectNumContainer: {
                flexDirection: 'row',
                paddingTop: ScreenUtils.scaleSize(20),
                paddingBottom: ScreenUtils.scaleSize(20)
            },
                numSelectText: {
                color: '#333333'
            },
                numLimitText: {
                marginLeft: ScreenUtils.scaleSize(10),
                color: '#999999'
            },
                numEditContainer: {
                flexDirection: 'row',
                flex: 2,
                justifyContent: 'flex-end',
            },
                minus: {
                width: ScreenUtils.scaleSize(40),
                height: ScreenUtils.scaleSize(40),
                backgroundColor: '#E7E7E7',
                textAlign: 'center',
                textAlignVertical: 'center'
            },
                plus: {
                color: '#666666',
                width: ScreenUtils.scaleSize(40),
                height: ScreenUtils.scaleSize(40),
                backgroundColor: '#E7E7E7',
                textAlign: 'center',
                textAlignVertical: 'center'
            },
                numEditor: {
                color: '#666666',
                width: ScreenUtils.scaleSize(40),
                height: ScreenUtils.scaleSize(40),
                backgroundColor: '#F5F5F5',
                textAlign: 'center',
                textAlignVertical: 'center'
            },
                confirmBtn: {
                height: ScreenUtils.scaleSize(100),
                color: 'white',
                backgroundColor:'rgba(0,0,0,0)',
                marginTop:ScreenUtils.scaleSize(60)
            },
                divideLine: {
                backgroundColor: '#DDDDDD',
                height: 1,
            }
            });
                CartCategoryDialog.propTypes = {
                show: PropTypes.bool,
                closeCategoryDialog: PropTypes.func,
                openGiftDialog: PropTypes.func,
                confirmCommercialSpecification: PropTypes.func,
            }
                export default CartCategoryDialog