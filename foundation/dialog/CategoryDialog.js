/**
 * @author Xiang
 *
 * 商品规格选择弹窗：
 * 商品图片、价格、当前选中规格、尺寸、颜色、赠品、数量
 * 调用页面：
 * 购物车、商品详情
 */
import React, {Component} from 'react';
import {connect} from 'react-redux';
import * as ClassificationPageAction from '../../app/actions/classificationpageaction/ClassificationPageAction';
import DonationRequest from '../../foundation/net/GoodsDetails/DonationRequest';
import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Image,
    Dimensions,
    FlatList,
    TouchableOpacity,
} from 'react-native';
import Colors from '../../app/config/colors'
import Fonts from '../../app/config/fonts';
import AddCartRequest from '../net/GoodsDetails/AddCartRequest';
import * as ScreenUtils from '../../foundation/utils/ScreenUtil';
import ToastShow from '../../foundation/common/ToastShow';
import Toast, {DURATION} from 'react-native-easy-toast';

let {width, height} = Dimensions.get('window');
let giftList = [];

class CategoryDialog extends Component {
    constructor(props) {
        super(props);
        this.state = {
            numDecrease: '#BBBBBB',
            selectStr: '',
            selectCodeStr: '',
            selectStr2: '',
            num: parseInt(this.props.setDatas.num) < parseInt(this.props.goodsNum) ? parseInt(this.props.goodsNum) : parseInt(this.props.setDatas.num),
            donationData: {
                have: false,
                datas: null,
                giftPromoNo: null,
            },
            showColorsAndSize: false,
            addressCode: this.props.addressCode,
            makeSureType: this.props.makeSureType,

            sizeItems:this.props.setDatas.sizeItems,
            colorItems:this.props.setDatas.colorItems,
            colorsizes:this.props.setDatas.colorsizes,
        };

        giftList = this.props.giftList;
        console.log("#####  在规格中giftList:" + JSON.stringify(giftList));

        if (!this.reqBody) {
            this.reqBody = {
                item_code: this.props.allDatasFromMain.goodsDetail.item_code,
                qty: this.state.num + "",
                unit_code: "001",
                gift_item_code: "",
                gift_unit_code: "",
                giftPromo_no: "",
                giftPromo_seq: "",
                media_channel: "",
                msale_source: "",
                msale_cps: "",
                source_url: "http%3A%2F%2Fm.ocj.com.cn%2Fsettle%2Fm_shop%2F9228%3Fdomain_id%3D7781_6481_12081_2_14318_WASTE",
                source_obj: "",
                timeStamp: "",
                ml_msale_gb: "",
                item_price: (this.props.allDatasFromMain.goodsDetail.last_sale_price + "") || (this.props.allDatasFromMain.goodsDetail.sale_price + "") || "",
                event_end_date: this.props.allDatasFromMain.goodsDetail.disp_end_dt ? (this.props.allDatasFromMain.goodsDetail.disp_end_dt + "") : "",

                area_lcode: (this.state.addressCode !== null && this.state.addressCode.provinceCode !== null) ? this.state.addressCode.provinceCode : "", /*省*/
                area_mcode: (this.state.addressCode !== null && this.state.addressCode.cityCode !== null) ? this.state.addressCode.cityCode : "", /*市*/
                area_scode: (this.state.addressCode !== null && this.state.addressCode.districtCode !== null) ? this.state.addressCode.districtCode : "", /*地区*/

            };
        }

        this.advanceOrderRequest();
    }


//判断是不是只有一种规格
    checkIsOne() {

        let sizes = ((this.state.sizeItems && this.state.sizeItems.length > 0 ) ? this.state.sizeItems : null);
        let colors = ((this.state.colorItems && this.state.colorItems.length > 0 ) ? this.state.colorItems : null);
        let css = ((this.state.colorsizes && this.state.colorsizes.length > 0 ) ? this.state.colorsizes : null);

        let selectItem = null;

// {
//     "cs_off": "",
//     "cs_code": "1000000002",
//     "cs_img": "http://image1.ocj.com.cn/item_images/item/15/12/5188/15125188S.jpg",
//     "hidden_wu": "N",
//     "is_show": "Y",
//     "cs_name": "黑色"
// }

        if (css != null && css.length == 1) { //只有一个规格颜色 有值

            if (css[0].cs_name === '无' || css[0].cs_name === '无/无' || css[0].cs_name === '无/无/其他'){//如果是只有一个"无" 则不显示

                let item = this.getSelectStr("", "", css[0].cs_name, "", "", css[0].cs_code, false);
                this.setState({
                    selectCodeStr:item.sizeColorCodeStr,
                    sizeItems:[],
                    colorItems:[],
                    colorsizes:[],
                });
                this.reqBody.unit_code = item.sizeColorCodeStr;

            }else { //正常情况
                selectItem = this.getSelectStr("", "", css[0].cs_name, "", "", css[0].cs_code, true);
            }

            // selectItem = this.getSelectStr("", "", css[0].cs_name, "", "", css[0].cs_code, true);

        } else if (sizes != null && sizes.length == 1 && colors == null) { //只有一个规格 没有颜色

            if (sizes[0].cs_name === '无'){

                let  item = this.getSelectStr(sizes[0].cs_name, "", "", sizes[0].cs_code, "", "", false);
                this.setState({
                    selectCodeStr:item.codeStr,
                    sizeItems:[],
                    colorItems:[],
                    colorsizes:[],
                });

                this.reqBody.unit_code = item.codeStr;
            }else {
                selectItem = this.getSelectStr(sizes[0].cs_name, "", "", sizes[0].cs_code, "", "", true);
            }

            // selectItem = this.getSelectStr(sizes[0].cs_name, "", "", sizes[0].cs_code, "", "", true);

        } else if (colors != null && colors.length == 1 && sizes == null) {//只有一个颜色 没规格

            if (colors[0].cs_name === '无'){

                let  item = this.getSelectStr("", colors[0].cs_name, "", "", colors[0].cs_code, "", false);
                this.setState({
                    selectCodeStr:item.codeStr,
                    sizeItems:[],
                    colorItems:[],
                    colorsizes:[],
                });
                this.reqBody.unit_code = item.codeStr;

            }else {
                selectItem = this.getSelectStr("", colors[0].cs_name, "", "", colors[0].cs_code, "", true);
            }

            // selectItem = this.getSelectStr("", colors[0].cs_name, "", "", colors[0].cs_code, "", true);

        } else if (colors != null && colors.length == 1 && sizes != null && sizes.length == 1) { //既有规格 又有颜色 且都只有一个

            if (colors[0].cs_name === '无' && sizes[0].cs_name === '无'){

                let  item = this.getSelectStr(sizes[0].cs_name, colors[0].cs_name, "", sizes[0].cs_code, colors[0].cs_code, "", false);
                this.setState({
                    selectCodeStr:item.codeStr,
                    sizeItems:[],
                    colorItems:[],
                    colorsizes:[],
                });
                this.reqBody.unit_code = item.codeStr;

            }else {
                selectItem = this.getSelectStr(sizes[0].cs_name, colors[0].cs_name, "", sizes[0].cs_code, colors[0].cs_code, "", true);
            }


            // selectItem = this.getSelectStr(sizes[0].cs_name, colors[0].cs_name, "", sizes[0].cs_code, colors[0].cs_code, "", true);
        }

        if (selectItem !== null) {
            this.setState({
                selectStr: selectItem.str ? selectItem.str : selectItem.sizeColorStr,
                selectCodeStr: selectItem.codeStr ? selectItem.codeStr : selectItem.sizeColorCodeStr,
                selectStr2: selectItem.str2 ? selectItem.str2 : selectItem.sizeColorStr2,
            });
            this.reqBody.unit_code = selectItem.codeStr ? selectItem.codeStr : selectItem.sizeColorCodeStr;
        }

        this.setState({showColorsAndSize: true});
    }

    setFirstSelect() {
        let dfs = this.props.defaultSelect;

        let selectItem = this.getSelectStr(dfs.sizeSelectStr, dfs.colorSelectStr, dfs.colorSizeSelectStr, dfs.sizeSelectCode, dfs.colorSelectCode, dfs.colorSizeSelectCode, false);

        this.setState({
            selectStr: selectItem.str ? selectItem.str : selectItem.sizeColorStr,
            selectCodeStr: selectItem.codeStr ? selectItem.codeStr : selectItem.sizeColorCodeStr,
            selectStr2: selectItem.str2 ? selectItem.str2 : selectItem.sizeColorStr2,
        });
        this.reqBody.unit_code = selectItem.codeStr ? selectItem.codeStr : selectItem.sizeColorCodeStr;

        this.checkIsOne();
    }

    componentWillReceiveProps(nextProps) {
        let sa = this.state.addressCode;
        let na = nextProps.addressCode;
        if (this.state.addressCode !== nextProps.addressCode || (na !== null && sa !== null && (sa.provinceCode != na.provinceCode || sa.cityCode != na.cityCode || sa.districtCode != na.districtCode))) {
            this.setState({addressCode: nextProps.addressCode});
        }

        if (this.state.makeSureType !== nextProps.makeSureType) {
            this.setState({makeSureType: nextProps.makeSureType});
        }
    }

//请求 非随箱赠品数据
    advanceOrderRequest() {
        if (this.notationR) {
            this.notationR.setCancled(true)
        }

        let itemcode = this.props.allDatasFromMain !== null && this.props.allDatasFromMain.goodsDetail != null && this.props.allDatasFromMain.goodsDetail.item_code;
        this.notationR = new DonationRequest(null, "GET");
        this.notationR.setItemCode(itemcode);
        this.notationR.start((response) => {
            console.log('######## 非随箱赠品请求数据:' + JSON.stringify(response));
            if (response.code === 200) {
                if (response.data === null || response.data.zpMap === undefined || response.data.zpMap === null || response.data.zpMap.length < 1) {
                    return;
                } else {//有赠品显示选择赠品
                    console.log("#######　赠品内容：" + JSON.stringify(response.data));
                    let ishave = false;
                    for (let a in response.data) {
                        ishave = true;
                    }
                    if (ishave) {
                        this.setState({
                            donationData: {
                                have: ishave,
                                datas: response.data.zpMap,
                                giftPromoNo: response.data.zpMap[0].id,
                            }
                        })
                    }
                }

            } else {
// this.refs.toast.show("网络异常");
            }
        }, (err) => {
// this.refs.toast.show("网络异常");
        });
    }


//购物车网络请求
    cartRequest() {


        this.reqBody.qty = this.state.num;
        this.reqBody.unit_code = this.reqBody.unit_code || '001';
        let request = new AddCartRequest(this.reqBody, 'POST');
        console.log("##### 购物车请求参数:" + JSON.stringify(this.reqBody));
        request.start((result) => {

            //用户选择完规格后立即刷新主界面的库存状态
            this.props.refreshAddress();

            console.log("##### 购物车返回数据:" + JSON.stringify(result));
            if (result.code === 200) {
                try {
                    let jsonData = result.data;
                    ToastShow.toast(jsonData.result.cart_msg);
//关闭当前
//返回用户选择的数据
//                     this.props.closeCategoryShow(false);
                    this.props.openCategoryDialogShow(false);
                    this.props.closeCategoryDialog({
                        // show: false,
                        // giftList: giftList,
                        // goodsNum: this.state.num,
                        throught: true,
                        makeGiftCodes: {
                            ics: this.makeGiftCode().ics,
                            ucs: this.makeGiftCode().ucs,
                            giftPromoNo: this.state.donationData.have ? this.state.donationData.giftPromoNo : "",
                        },
                    });

                    this.props.setGoodsNum(this.state.num);

                    //刷新购物车数量
                    this.props.cartNumRequest();
                    //返回用户选择的信息
                    this.props.setShowInGD({
                        seq: jsonData.result.cart_seq,
                        selectStr: this.state.selectStr,//选中的规格字符串,再次展开要传
                        selectStr2: this.state.selectStr2,
                        selectCodeStr: this.state.selectCodeStr
                    })

                    this.props.startAnimated();

                } catch (e) {
                    this.refs.toast.show('网络异常');
                }

            } else if (result.message && result.message.length > 0) {
                this.refs.toast.show(result.message);
            } else {
                this.refs.toast.show('网络异常');
            }
// console.log(result);
        }, (e) => {
            if (e.message && e.message.length > 0) {
                this.refs.toast.show(e.message);
            } else {
                this.refs.toast.show('网络异常');
            }

            //用户选择完规格后立即刷新主界面的库存状态
            this.props.refreshAddress();

// this.refs.toast.show( CartShowErroMessage.errShow(e));
        });
    }


    componentDidMount() {
//真实数据仍然为空
// reqBody.item_code = this.props.categoryDatas.categoryDialog.reqBody.item_code;
        this.setFirstSelect();
    }

    shouldComponentUpdate(nextProps, nextState) {
        return true;
    }

    getSelectStr = (size, color, sizeColor, sizeCode, colorCode, sizeColorCode, save) => {
        if (save === true) {
//保存选择的规格
            this.props.setDefaultSelect({
                noStockCodes: "",
                sizeSelectStr: size || "",
                sizeSelectCode: sizeCode || "",
                colorSelectStr: color || "",
                colorSelectCode: colorCode || "",
                colorSizeSelectStr: sizeColor || "",
                colorSizeSelectCode: sizeColorCode || "",
            });
        }

        let str = '';
        if (size.length > 0) {
            str += '“' + size + '”';
        }
        if (color.length > 0) {
            str += '  “' + color + '”';
        }

        let str2 = '';
        if (size.length > 0 && color.length == 0) {
            str2 += size;
        } else if (size.length > 0 && color.length > 0) {
            str2 += size + '，';
        }

        if (color.length > 0) {
            str2 += color + '';
        }

        let codeStr = '';
        if (colorCode.length > 0) {
            codeStr += colorCode;
        }
        if (sizeCode.length > 0) {
            codeStr += ':' + sizeCode;
        }
        return {
            str: str,
            codeStr: codeStr,
            str2: str2,
            sizeColorStr: '“' + sizeColor + '”',
            sizeColorStr2: sizeColor,
            sizeColorCodeStr: sizeColorCode
        };
    }

//判断是否还有规格未选择
    checkSelect() {
        let through = false;
        // let colorsize = this.props.allDatasFromMain.colorsize;
        let sizes = ((this.state.sizeItems && this.state.sizeItems.length > 0 ) ? this.state.sizeItems : null);
        let colors = ((this.state.colorItems && this.state.colorItems.length > 0 ) ? this.state.colorItems : null);
        let code = this.state.selectCodeStr;
        let css = ((this.state.colorsizes && this.state.colorsizes.length > 0 ) ? this.state.colorsizes : null);

        if (css !== null) {//规格和颜色一起的商品
            if (code !== null && code !== "") {
                through = true;
            }
        } else {//规格和颜色分开的商品
            if (sizes === null && colors === null) {//没有规格可选的情况 可点击
                through = true;
            } else if (sizes !== null && colors !== null) { // 规格和颜色都有的情况
                if (code.split(":")[0] && code.split(":")[1]) {
                    through = true;
                } else {
                    through = false;
                }
            } else { //单种选项
                if (code !== null && code !== "") {
                    through = true;
                } else {
                    through = false;
                }
            }
        }

        return through;
    }

//判断是否还有赠品未选择
    checkDonation() {
        let finishDonation = true;
        let giftList = this.props.giftList;
        for (let i = 0; i < giftList.length; i++) {
            if (!giftList[i].select) {//如果赠品列表中有未选择的 赠品 ，提示赠品未选择
                finishDonation = false;
                break;
            }
        }
        return finishDonation;
    }

//如果选择完了赠品，将赠品序列号排列
    makeGiftCode() {
// gift_item_codes:"",//赠品编号
//     gift_unit_codes:"",//赠品规格编号
        let ics = "";
        let ucs = "";
        let giftList = this.props.giftList;
        for (let i = 0; i < giftList.length; i++) {
            if (i < giftList.length - 1) {
                ics += giftList[i].gift_item_codes + ":";
                ucs += giftList[i].gift_unit_codes + ":";
            } else {
                ics += giftList[i].gift_item_codes;
                ucs += giftList[i].gift_unit_codes;
            }
        }
        return {ics: ics, ucs: ucs}
    }

    render() {
        return (
            <View style={DialogStyle.contentContainer}>
                <Text style={{flex: 1}} onPress={() => {
                    this.props.openCategoryDialogShow(false);
                }} allowFontScaling={false}/>
                <View>
                    <View style={DialogStyle.titleContainer}>
                        <View style={DialogStyle.titleLeft}/>
                        <View style={DialogStyle.imgBorder}>
                            <View style={DialogStyle.thumbnailBorder}>
                                <Image
                                    source={{uri: this.props.setDatas.uri}}
                                    style={DialogStyle.titleImg}/>
                            </View>
                        </View>
                        <View style={DialogStyle.titleTextContainer}>
                            <View style={DialogStyle.titleText}>
                                <Text
                                    style={DialogStyle.price} allowFontScaling={false}>
                                    <Text allowFontScaling={false} style={{
                                        color: '#E5290D',
                                        fontSize: ScreenUtils.setSpText(24),
                                        paddingBottom: ScreenUtils.scaleSize(6),
                                        marginRight: ScreenUtils.scaleSize(10)
                                    }}>¥ </Text>
                                    <Text style={{
                                        color: '#E5290D',
                                        fontSize: ScreenUtils.setSpText(36),
                                        fontFamily: 'HelveticaNeue'
                                    }}
                                          allowFontScaling={false}>{this.props.setDatas.price}</Text>
                                </Text>

                                <Text
                                    allowFontScaling={false}
                                    style={DialogStyle.selection}>已选 {this.state.selectStr == "“”" ? "" : this.state.selectStr}</Text>
                            </View>
                            <TouchableOpacity activeOpacity={1} style={DialogStyle.titleClose}
                                              onPress={() => {
                                                  this.props.openCategoryDialogShow(false);

                                              }}>
                                <Image source={require('../Img/dialog/icon_close_@3x.png')}
                                       style={DialogStyle.titleCloseImg}/>
                            </TouchableOpacity>
                        </View>
                    </View>
                    <View style={DialogStyle.divideLine}/>
                </View>
                <View style={DialogStyle.scrollView}>
                    <ScrollView style={{paddingLeft: 16, paddingRight: 16,}}>
                        {this.state.showColorsAndSize &&
                        <SizeColorComponent
                            sizeItems={this.state.sizeItems}
                            colorItems={this.state.colorItems}
                            colorsizes={this.state.colorsizes}
                            onSelectionChanged={(size, color, colorSize, sizeCode, colorCode, colorSizeCode) => {
                                let selectItem = this.getSelectStr(size, color, colorSize, sizeCode, colorCode, colorSizeCode, true);
                                this.setState({
                                    selectStr: selectItem.str ? selectItem.str : selectItem.sizeColorStr,
                                    selectCodeStr: selectItem.codeStr ? selectItem.codeStr : selectItem.sizeColorCodeStr,
                                    selectStr2: selectItem.str2 ? selectItem.str2 : selectItem.sizeColorStr2,
                                });
                                this.reqBody.unit_code = selectItem.codeStr ? selectItem.codeStr : selectItem.sizeColorCodeStr;
                            }
                            }
                            defaultSelect={this.props.defaultSelect}
                        />
                        }

                        <View style={DialogStyle.selectNumContainer}>
                            <View style={{flexDirection: 'row', alignItems: 'center'}}>
                                <Text style={DialogStyle.numSelectText} allowFontScaling={false}>数量选择</Text>
                                <Text
                                    style={DialogStyle.numLimitText}
                                    allowFontScaling={false}>(每人限购{this.props.setDatas.numLimit}件)
                                    {this.props.setDatas.num != null &&
                                    this.props.setDatas.num !== "" &&
                                    this.props.setDatas.num != undefined &&
                                    this.props.setDatas.num != "1" &&
                                    this.props.setDatas.num != 1 &&
                                    (" 最少购买" + this.props.setDatas.num + "件")}</Text>
                            </View>
                            <View style={DialogStyle.numEditRow}>
                                <View style={DialogStyle.numEditContainer}>
                                    <TouchableOpacity activeOpacity={1} style={DialogStyle.minusTouch} onPress={() => {
                                        if (this.state.num > parseInt(this.props.setDatas.num)) {
                                            this.setState({num: this.state.num - 1})
                                            {/*this.state.donationData.have && giftList.pop();*/
                                            }
                                        } else {
                                        }
                                    }}>
                                        <Image source={require('../Img/cart/Icon_minus_@3x.png')}
                                               resizeMode={'contain'}
                                               style={DialogStyle.minus}/>
                                    </TouchableOpacity>

                                    <View style={DialogStyle.numEditorView}>
                                        <Text style={DialogStyle.numEditor}
                                              allowFontScaling={false}>{this.state.num + ""}</Text>
                                    </View>
                                    <TouchableOpacity activeOpacity={1} style={DialogStyle.minusTouch} onPress={() => {
                                        if (this.state.num < parseInt(this.props.setDatas.numLimit)) {
                                            {/*this.state.donationData.have && giftList.push({*/
                                            }
                                            {/*select: false,*/
                                            }
                                            {/*text: '还有赠品未选择，请选择赠品',*/
                                            }
                                            {/*nextAction: '领取赠品',*/
                                            }
                                            {/*gift_item_codes: "",//赠品编号*/
                                            }
                                            {/*gift_unit_codes: "",//赠品规格编号*/
                                            }
                                            {/*});*/
                                            }
                                            this.setState({
                                                num: this.state.num + 1,
                                            });
                                        }
                                    }}>
                                        <Image source={require('../Img/cart/Icon_add_@3x.png')}
                                               resizeMode={'contain'}
                                               style={DialogStyle.plus}/>
                                    </TouchableOpacity>
                                </View>
                            </View>
                        </View>
                        {
                            this.state.donationData.have == true && (giftList.length == 0 ? null :
                                <View>
                                    <View style={DialogStyle.giftTitleContainer}>
                                        <Text style={DialogStyle.giftTitle}
                                              allowFontScaling={false}>赠品（可领取{this.state.num}件赠品）</Text>
                                    </View>

                                    <GiftListComponent size={this.state.num} listData={giftList}
                                                       closeDiolog={() => {
                                                           // this.props.closeCategoryShow(false);
                                                           this.props.openCategoryDialogShow(false);

                                                           this.props.setGoodsNum(this.state.num);
                                                           this.props.setShowInGD({ //展示给商品详情主页面的内容
                                                               seq:"",
                                                               selectStr: this.state.selectStr,//选中的规格字符串,再次展开要传
                                                               selectStr2: this.state.selectStr2,
                                                               selectCodeStr: this.state.selectCodeStr
                                                           })


                                                       }
                                                       }

                                                       openGiftPickUpDialog={() => {

                                                           // this.props.giftShow(true);
                                                           this.props.openGiftPickUpDialogShow(true);

                                                           this.props.setGiftData(this.state.donationData.have && this.state.donationData.datas || []);

                                                       }}

                                    />
                                </View>)
                        }
                    </ScrollView>
                </View>

                <TouchableOpacity
                    activeOpacity={1}
                    style={{
                        justifyContent: 'center',
                        alignItems: 'center',
//  backgroundColor: 'red',
                        width: width,
                        height: 50
                    }}
                    onPress={() => {
//这里是确定按钮
//todo  判断用户是否选择完了赠品，如果没有选择完给出提示 ，待做
//请求服务器
                        if (this.props.requestCart) {
                            let througth = this.checkSelect();
                            let finishDonation = true;
                            if (this.state.donationData.have) {
                                finishDonation = this.checkDonation();
                            }
                            if (througth && finishDonation) {//判断用户有没有选择规格 选择了就加入购物车 没选择就提醒选择
                                this.reqBody.gift_item_code = this.makeGiftCode().ics;
                                this.reqBody.gift_unit_code = this.makeGiftCode().ucs;
                                this.cartRequest();
                            } else {
                                {/*alert("您有规格或者赠品未选择");*/
                                }
                                this.refs.toast.show("您有规格或者赠品未选择");
                            }
                        } else {

                            let througth = this.checkSelect();
                            let finishDonation = true;
                            if (this.state.donationData.have) {
                                finishDonation = this.checkDonation();
                            }

                            if (througth && finishDonation) {//判断用户有没有选择规格 选择了就加入购物车 没选择就提醒选择
                                // this.props.closeCategoryShow(false);
                                this.props.openCategoryDialogShow(false);
                                this.props.closeCategoryDialog({
                                    // show: false,
                                    // giftList: giftList,
                                    // goodsNum: this.state.num,
                                    throught: true,
                                    makeGiftCodes: {
                                        ics: this.makeGiftCode().ics,
                                        ucs: this.makeGiftCode().ucs,
                                        giftPromoNo: this.state.donationData.have ? this.state.donationData.giftPromoNo : "",
                                    }
                                });
                                this.props.setGoodsNum(this.state.num);
                                this.props.setShowInGD({
                                    seq: "",
                                    selectStr: this.state.selectStr,//选中的规格字符串,再次展开要传
                                    selectStr2: this.state.selectStr2,
                                    selectCodeStr: this.state.selectCodeStr
                                });



//用户选择完规格后立即刷新主界面的库存状态
                                this.props.refreshAddress();

// 判断从底部状态栏传过来的类型  根据类型回调底部状态栏 让底部状态栏执行下一步操作
                                if (this.state.makeSureType !== null) {
                                    this.props.sendResponseMsg(this.state.makeSureType);
                                }


                            } else {
                                {/*alert("您有规格或者赠品未选择");*/
                                }
                                this.refs.toast.show("您有规格或者赠品未选择");
                            }
                        }
                    }}
                >
                    <Image style={[DialogStyle.btnImage, {justifyContent: 'center', alignItems: 'center'}]}
                           source={require('../Img/home/globalshopping/icon_statusbg_@3x.png')}
                           resizeMode={'stretch'}>
                        <Text style={DialogStyle.confirmBtn} allowFontScaling={false}>确 定</Text>
                    </Image>
                </TouchableOpacity>

                <Toast ref="toast" position='center'/>

            </View>
        );
    }
}
//赠品列表
class GiftListComponent extends React.PureComponent {
    constructor(props) {
        super(props)
        this.state = {
            size: this.props.size,
        }
    }

    componentWillReceiveProps(nextProps) {
        if (this.state.size !== nextProps.size) {
            this.setState({size: nextProps.size});
        }
    }

    render() {
        return (
            <FlatList
                data={this.props.listData}
                extraData={this.state}
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
                    <Text style={DialogStyle.checkedGift} numberOfLines={1} allowFontScaling={false}>{item.text}</Text>
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => {
//打开赠品弹窗 并且把赠品信息传过去
                            this.props.closeDiolog(); //关闭当前
                            this.props.openGiftPickUpDialog();
                        }}
                        style={{flexDirection: 'row', alignItems: 'center'}}
                    >
                        <Text style={DialogStyle.getGift} allowFontScaling={false}>{item.nextAction}</Text>
                        <Image style={DialogStyle.rightArrow}
                               source={require('../Img/dialog/Icon_right_hui_@3x.png')}/>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
}
//尺寸颜色
class SizeColorComponent extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            noStockCodes: this.props.defaultSelect.noStockCodes || '',
            sizeSelectStr: this.props.defaultSelect.sizeSelectStr || '',
            sizeSelectCode: this.props.defaultSelect.sizeSelectCode || '',
            colorSelectStr: this.props.defaultSelect.colorSelectStr || '',
            colorSelectCode: this.props.defaultSelect.colorSelectCode || '',
            colorSizeSelectStr: this.props.defaultSelect.colorSizeSelectStr || '',
            colorSizeSelectCode: this.props.defaultSelect.colorSizeSelectCode || '',
            sizeSelectItem: '',
            colorSelectItem: '',
            sizeNoStockCodes:'',
            colorNoStockCodes:'',
        }
    }

    render() {
        return (
            <View>
                {
                    this.props.sizeItems.length === 0 ? null :
                        <View>
                            <Text style={DialogStyle.categoryTitle} allowFontScaling={false}>尺寸</Text>
                            <SizeItems
                                items={this.props.sizeItems}
                                noStockCodes={this.state.sizeNoStockCodes}
                                sizeSelect={this.state.sizeSelectCode}
                                onSelect={(i) => {
                                    this.setState({
                                        colorNoStockCodes: this.props.sizeItems[i].cs_off,
                                        sizeSelectStr: this.props.sizeItems[i].cs_name,
                                        sizeSelectCode: this.props.sizeItems[i].cs_code,
                                    })
                                    this.props.onSelectionChanged(this.props.sizeItems[i].cs_name, this.state.colorSelectStr, '', this.props.sizeItems[i].cs_code, this.state.colorSelectCode, '');
                                }}
                                onCancelSelect={(isPassive) => {
                                    if (isPassive) {
                                        this.setState({
                                            sizeSelectStr: '',
                                            sizeSelectCode: '',
                                        })
                                    } else {
                                        this.setState({
                                            noStockCodes: '',
                                            sizeNoStockCodes:'',
                                            colorNoStockCodes:'',
                                            sizeSelectStr: '',
                                            sizeSelectCode: '',
                                        })
                                    }
                                    this.props.onSelectionChanged('', this.state.colorSelectStr, '', '', this.state.colorSelectCode, '');
                                }}
                            />
                        </View>
                }
                {
                    this.props.colorItems.length === 0 ? null :
                        <View>
                            <Text style={DialogStyle.categoryTitle} allowFontScaling={false}>颜色</Text>
                            <ColorItems
                                items={this.props.colorItems}
                                noStockCodes={this.state.colorNoStockCodes}
                                colorSelect={this.state.colorSelectCode}
                                onSelect={(i) => {
                                    this.setState({
                                        sizeNoStockCodes: this.props.colorItems[i].cs_off,
                                        colorSelectStr: this.props.colorItems[i].cs_name,
                                        colorSelectCode: this.props.colorItems[i].cs_code,
                                    })
                                    this.props.onSelectionChanged(this.state.sizeSelectStr, this.props.colorItems[i].cs_name, '', this.state.sizeSelectCode, this.props.colorItems[i].cs_code, '');
                                }}
                                onCancelSelect={(isPassive) => {
                                    if (isPassive) {
                                        this.setState({
                                            colorSelectStr: '',
                                            colorSelectCode: '',
                                        })
                                    } else {
                                        this.setState({
                                            noStockCodes: '',
                                            sizeNoStockCodes:'',
                                            colorNoStockCodes:'',
                                            colorSelectStr: '',
                                            colorSelectCode: '',
                                        })
                                    }
                                    this.props.onSelectionChanged(this.state.sizeSelectStr, '', '', this.state.sizeSelectCode, '', '');
                                }}
                            />
                        </View>
                }
                {
                    this.props.colorsizes.length === 0 ? null :
                        <View>
                            <Text style={DialogStyle.categoryTitle} allowFontScaling={false}>颜色尺寸</Text>
                            <ColorSizeItems
                                items={this.props.colorsizes}
                                colorSizeSelect={this.state.colorSizeSelectStr}
                                colorSizeSelectCode={this.state.colorSizeSelectCode}
                                onSelect={(i) => {
                                    this.setState({
                                        colorSizeSelectStr: this.props.colorsizes[i].cs_name,
                                        colorSizeSelectCode: this.props.colorsizes[i].cs_code,
                                    })
                                    this.props.onSelectionChanged('', '', this.props.colorsizes[i].cs_name, '', '', this.props.colorsizes[i].cs_code);
                                }}
                                onCancelSelect={() => {
                                    this.setState({
                                        colorSizeSelectStr: '',
                                        colorSizeSelectCode: '',
                                    })
                                    this.props.onSelectionChanged('', '', '', '', '', '');
                                }}
                            />
                        </View>
                }
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
                        let select = item.cs_code === this.props.sizeSelect;
                        let itemColor = noStock ? '#DDDDDD' : select ? '#E5290D' : '#999999';
                        if (noStock && select) {
                            this.props.onCancelSelect(true);
                        }
                        return (
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {
                                    if (!noStock) {
                                        if (select) {
                                            this.props.onCancelSelect(false);
                                        } else {
                                            this.props.onSelect(i);
                                        }
                                    }
                                }}
                                style={[DialogStyle.itemNormal, {
                                    borderColor: itemColor,
                                }]}>
                                <Text style={{
                                    color: itemColor,
                                    fontSize: ScreenUtils.setSpText(28),
                                }} allowFontScaling={false}>{item.cs_name}</Text>
                            </TouchableOpacity>
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
                        let select = item.cs_code === this.props.colorSelect;
                        let itemColor = noStock ? '#DDDDDD' : select ? '#E5290D' : '#999999';
                        if (noStock && select) {
                            this.props.onCancelSelect(true);
                        }
                        return (
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {
                                    if (!noStock) {
                                        if (select) {
                                            this.props.onCancelSelect(false);
                                        } else {
                                            this.props.onSelect(i);
                                        }
                                    }
                                }}
                                style={[DialogStyle.itemNormal, {
                                    borderColor: itemColor,
                                }]}>
                                <Text style={{
                                    color: itemColor,
                                    fontSize: ScreenUtils.setSpText(28),
                                }} allowFontScaling={false}>{item.cs_name}</Text>
                            </TouchableOpacity>
                        )
                    })
                }
            </View>
        );
    }
}
class ColorSizeItems extends React.PureComponent {
    render() {
        return (
            <View style={DialogStyle.categoryItems}>
                {
                    this.props.items.map((item, i) => {
                        let select = item.cs_code === this.props.colorSizeSelectCode;
                        let itemColor = select ? '#E5290D' : '#999999';
                        return (
                            <TouchableOpacity
                                activeOpacity={1}
                                onPress={() => {
                                    if (select) {
                                        this.props.onCancelSelect();
                                    } else {
                                        this.props.onSelect(i);
                                    }
                                }}
                                style={[DialogStyle.itemNormal, {
                                    borderColor: itemColor,
                                }]}>
                                <Text style={{
                                    color: itemColor,
                                    fontSize: ScreenUtils.setSpText(28),
                                }} allowFontScaling={false}>{item.cs_name}</Text>
                            </TouchableOpacity>
                        )
                    })
                }
            </View>
        );
    }
}

const DialogStyle = StyleSheet.create({
    itemNormal: {
        padding: 3,
// textAlign: 'center',
// textAlignVertical: 'center',
        borderWidth: 1,
        borderRadius: 3,
        backgroundColor: 'white',
        marginLeft: 10,
        marginTop: 10,
        height: ScreenUtils.scaleSize(48),
        justifyContent: 'center',
        alignItems: 'center'
// fontSize: ScreenUtils.setSpText(28)
    },
    container: {
        flex: 1,
        justifyContent: 'flex-end',
    },
    contentContainer: {
        width: width,
        height: height,
        flexDirection: 'column',
        backgroundColor: 'rgba(0,0,0,0.5)',
        justifyContent: 'flex-end',
        position: 'absolute',
        left: 0,
        bottom: 0,
    },
    titleContainer: {
        flexDirection: 'row',
    },
    scrollView: {
        height: 300,
        width: width,
        backgroundColor: 'white',
    },
    titleLeft: {
        marginTop: 25,
        width: 16,
        backgroundColor: 'white',
    },
    imgBorder: {
        backgroundColor: 'white',
        borderTopLeftRadius: 3,
        borderTopRightRadius: 3,
    },
    thumbnailBorder: {
        backgroundColor: 'white',
        borderTopLeftRadius: 3,
        borderTopRightRadius: 3,
        borderBottomLeftRadius: 3,
        borderBottomRightRadius: 3,
        borderWidth: ScreenUtils.scaleSize(0.5),
        borderColor: Colors.line_grey,
        width: ScreenUtils.scaleSize(210),
        height: ScreenUtils.scaleSize(210),
    },
    titleImg: {
        borderRadius: 3,
        margin: 5,
        width: ScreenUtils.scaleSize(188),
        height: ScreenUtils.scaleSize(188),
        marginBottom: 20,
        resizeMode: 'cover',
    },
    titleTextContainer: {
        flex: 1,
        flexDirection: 'row',
        marginTop: 25,
        paddingLeft: 10,
        paddingRight: 10,
        backgroundColor: 'white',
    },
    titleText: {
        height: 95,
        flex: 1,
        justifyContent: 'flex-end'
    },
    titleClose: {
        height: 30,
        width: 30,
        justifyContent: 'center',
        alignItems: 'center',
        marginTop: 16,
        marginRight: 6,
    },
    titleCloseImg: {
        width: 15,
        height: 15,
        resizeMode: 'contain',
    },
    price: {
        fontSize: 18,
        color: '#E5290D',
        marginBottom: 5,
    },
    selection: {
        fontSize: 14,
    },
    categoryTitle: {
        marginTop: 10,
        marginBottom: 10,
        color: '#666666',
    },
    categoryItems: {
        flexWrap: 'wrap',
        flexDirection: 'row',
        marginBottom: 10,
    },
    categoryItemText: {
        padding: 5,
        marginLeft: 5,
        marginRight: 5,
        backgroundColor: '#666666',
        color: 'white',
        borderRadius: 8,
    },
    giftTitleContainer: {
        paddingTop: 5,
        paddingBottom: 5,
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
        paddingTop: 5,
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
    giftItemText: {
        flex: 1,
        fontSize: 16,
        color: '#333333',
    },
    giftItemNum: {
        fontSize: 14,
        color: '#333333'
    },
    rightArrow: {
        height: 10,
        width: 7,
        marginLeft: 10,
        resizeMode: 'contain',
    },
    selectNumContainer: {
        flexDirection: 'row',
        paddingTop: 10,
        paddingBottom: 10
    },
    numSelectText: {
        fontFamily: 'PingFangSC-Regular',
        fontSize: ScreenUtils.setSpText(28),
        color: '#666666'
    },
    numLimitText: {
        marginLeft: 5,
        fontFamily: 'PingFangSC-Regular',
        fontSize: ScreenUtils.setSpText(26),
        color: '#2A2A2A'
    },
    numEditRow: {
        flex: 2,
        justifyContent: 'center',
        alignItems: 'flex-end',
    },
    numEditContainer: {
        flexDirection: 'row',
        justifyContent: 'flex-end',
        alignItems: 'center',
        borderWidth: ScreenUtils.scaleSize(1),
// paddingLeft: 5,
// paddingRight: 5,
        borderColor: '#999999',
        borderRadius: ScreenUtils.scaleSize(3),
        backgroundColor: 'white'
    },
    minusTouch: {
        width: ScreenUtils.scaleSize(40),
        height: ScreenUtils.scaleSize(50),
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center'
    },
    minus: {
        width: ScreenUtils.scaleSize(23),
        height: ScreenUtils.scaleSize(36),
        resizeMode: 'contain'
    },
    plus: {
        width: ScreenUtils.scaleSize(23),
        height: ScreenUtils.scaleSize(36),
        resizeMode: 'contain'
    },
    numEditor: {
        textAlign: 'center',
        textAlignVertical: 'center',
        fontSize: Fonts.page_normal_font(),
// marginLeft: 5,
// marginRight: 5,
    },
    numEditorView: {
        borderLeftWidth: ScreenUtils.scaleSize(1),
        borderRightWidth: ScreenUtils.scaleSize(1),
        borderColor: '#999999',
        width: ScreenUtils.scaleSize(70),
        height: ScreenUtils.scaleSize(50),
        backgroundColor: 'white',
        justifyContent: 'center',
        alignItems: 'center',
    },
    btnImage: {
        height: 50,
        width: width,
    },
    confirmBtn: {
        fontSize: ScreenUtils.scaleSize(30),
        color: 'white',
        textAlign: 'center',
    },
    divideLine: {
        backgroundColor: '#DDDDDD',
        height: ScreenUtils.scaleSize(1),
    }
});


export default connect(
    state => ({
// openCategoryDialog: state.ClassificationPageReducer,
        categoryDatas: state.ClassificationPageReducer,
    }),
    dispatch => ({
        // openGiftPickUpDialog: (msg) => dispatch(ClassificationPageAction.giftPickUpDialogDatas(msg)),
        // giftShow: (msg) => dispatch(ClassificationPageAction.giftShow(msg)),
        closeCategoryDialog: (data) => dispatch(ClassificationPageAction.categoryDialogDatas(data)),
        // closeCategoryShow: (data) => dispatch(ClassificationPageAction.categoryShow(data)),
    })
)(CategoryDialog)