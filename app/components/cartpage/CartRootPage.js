/**
 * Created by Zhang.xinchun on 2017/5/22.
 * 购物车
 */
import React, { Component } from 'react';
import {
    Text,
    View,
    StyleSheet,
    TouchableOpacity,
    Platform,
    NetInfo,
    Image,
    DeviceEventEmitter,
} from 'react-native';
import { Actions } from 'react-native-router-flux';
import Toast, {DURATION} from 'react-native-easy-toast';
import CartList from './CartList';
import CartPage from './CartPage';
import {connect} from 'react-redux';
//购物车Action
import * as CartAction from 'APP/actions/cartaction/CartAction';
//常量定义
import * as Constants from 'APP/constants/Constants';
//loading
import showLoadingDialog from 'APP/actions/dialogaction/DialogUtils';
//购物车Dialog
import CartGiftPickUpDialog from 'FOUNDATION/dialog/CartGiftPickUpDialog';
import CartCategoryDialog from 'FOUNDATION/dialog/CartCategoryDialog';
import ConfirmDialog from 'FOUNDATION/cart/ConfirmDialog'
import CartDiscountCoupon from 'FOUNDATION/cart/CartDiscountCoupon';
import TaxDescriptionDialog from 'FOUNDATION/dialog/TaxDescriptionDialog';
//导航部
import NavigationBar from 'COMMON/NavigationBar';
//自适应
import * as ScreenUtils from 'UTILS/ScreenUtil';
//颜色配置
import Color from 'CONFIG/colors';
//检测token
import CheckToken from 'NET/group/CheckToken';
//全局
import Global from 'CONFIG/global';
import RnConnect from 'CONFIG/rnConnect';
import * as routeConfig from 'CONFIG/routeConfig'
import * as RouteManager from 'CONFIG/PlatformRouteManager';
import { DataAnalyticsModule } from 'CONFIG/AndroidModules';
//网络错误
import NetErro from 'COMPONENTS/error/NetErro';
import * as Utils from 'FOUNDATION/cart/CartUtils';
//计算价格，获取抵用券
import CalculatePriceRequest from 'NET/cart/CalculatePriceRequest';
// 依赖注入reducer
import { injectReducer } from 'REDUX';
import CartReducer from 'REDUX/cartreducer/CartReducer';

let priceRequestBody = {cart_seqs: ''};
let calculatePriceRequest = new CalculatePriceRequest(priceRequestBody, "POST");
let key = 0;
//购物车刷新数据
let updateBody = {cartItemList: []};

export class CartRootPage extends Component {
    constructor() {
        super();
        this.CartData = null;
        this.keepCartData = null;//购物车原数据
        this.allShoppingArray = [];//所有商品
        this.selectedShoppingArray = [];//选择所有商品对象
        this.selectedCartSeqs = [];//选择的购物车序号
        this.storeArray = new Map();//店铺内所有商品
        this.colors = [];//商品颜色
        this.Sizes = [];//商品尺寸
        this.CategoryDatas = {};//商品的规格信息
        this.storeIndex = 0;//店铺索引
        this.shopIndex = 0;//商品索引
        this.lookTicketInfo = {};//查看券时存储的信息
        this.state = {
            complete: false,//loading
            isRefreshing: false,//
            cartData: {},//购物车数据
            couponPriceData: null,//价格抵用券数据
            allSelected: false,//全选
            dataExistFlg: true,//购物车存在商品
            showCategoryDialog: false,//规格Dialog是否显示
            showGiftDialog: false,//赠品Dialog是否显示
            cartType: false,//购物车类型 false 完成 true 编辑
            showConfirm: false,//确认Dialog false 不显示 true 显示
            showCoupon: false,//显示底部券 false 不显示 true 显示
            showTaxDes: false,//显示税 false 不显示 true 显示
            couponDatas: [],//查看折扣券要显示的数据
            netStatus: true,//true:网络正常,false异常
            errStatus: true //true:无错误,false有错误
        }
    }

    componentWillMount() {
        // 依赖注入reducer
        injectReducer('CartReducer', CartReducer);
    }

    componentDidMount() {
        //埋点
        DataAnalyticsModule.trackPageBegin("AP1706C001");
        //查询购物车数据
        setTimeout(() => this.getCartData(), 50);
        //刷新购物车的监听
        DeviceEventEmitter.addListener('refreshCartData',  () => {
            //再拉取数据
            this.getCartData();
        });
    }

    componentWillUnmount() {
        //离开购物车埋点
        DataAnalyticsModule.trackPageEnd("AP1706C001");
    }

    //获取购物车数据
    getCartData(message) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                //loading 显示
                showLoadingDialog(true);
                this.props.getCart({},
                    (result) => this.successGetCallback(result, message),
                    (errMsg, errCd) => this.failGetCallback(errMsg, errCd, message)
                );
            } else {
                this.loginToPay = false;
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        })

    }

    //跳转到详情页
    onShoppingClick(itemCode) {
        let {cart} = this.props;
        if (cart.type) {
            Actions.GoodsDetailMain({
                itemcode: itemCode,
            });
        }

    }

    //切换购物车状态
    onChangeCartType(cartType) {

        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                if (cartType) {
                    let obj = {
                        cartType: cartType,
                        //选择的购物车的编号
                        selectShopArr: [],
                    }
                    DataAnalyticsModule.trackEvent2("AP1706C001C003001A001001", "");
                    //loading 显示
                    showLoadingDialog(true);
                    //切换购物车状态
                    this.props.changeCartType(
                        obj,
                        (result) => this.successChgCartTypeCallback(result),
                        (errorMsg, errorCd) => this.failChgCartTypeCallback(errorMsg, errorCd));
                } else {
                    //loading 显示
                    if (updateBody.cartItemList.length > 0) {
                        showLoadingDialog(true);
                        this.props.clickShoppingSubmit(updateBody, Utils.norepeat(this.selectedCartSeqs), (result, isSubmit, msg) => this.successCallback(result, isSubmit, msg), (errMsg, errCd) => this.failCallback(errMsg, errCd, true));
                    } else {
                        this.getCartData();
                    }
                }
            } else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });
    }

    //切换购物车状态成功
    successChgCartTypeCallback(result) {
        let checkSelected = false;
        let btnDisable = false;
        //清空数据
        this.clearData();
        // console.log("======>调用服务结束" + new Date().getTime());
        //购物车原数据
        this.keepCartData = Utils.deepCopy(result);
        //购物车数据
        this.CartData = Utils.deepCopy(result);
        //购物车数据
        let cartDt = this.CartData.data;
        if (result.dataFlg === true) {
            //价格部是否全选
            checkSelected = this.checkAllSelected(cartDt);
            //按钮是否有效
            btnDisable = this.checkBtnDisabled(cartDt);
        }
        // 排序商铺
        this.sortFactory('ven_code' , cartDt.shop, this.state.cartData.shop);
        // 排序商铺列表
        cartDt.shop.forEach((d, index) => {
            cartDt.shop.cart_items_info && cartDt.shop.cart_items_info.forEach((d, index) => {
                this.sortFactory('item_code' , cartDt.shop.cart_items_info, this.state.cartData.shop.cart_items_info);
            });
        });
        this.setState({
            isRefreshing: false,
            complete: true,
            dataExistFlg: result.dataFlg,
            cartData: cartDt,
            allSelected: checkSelected,
            accountDisable: btnDisable,
            netStatus: true,
            errStatus: true,
        });
        //loading 消去
        showLoadingDialog(false);
    }

    //切换购物车状态失败
    failChgCartTypeCallback(errorMsg, errorCd) {
        //loading 消去
        showLoadingDialog(false);
        if (errorCd === 4010) {
            //去登录
            // RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //     if (event.tokenType === "self") {
            //         //重新拉取数据
            //         this.getCartData();
            //     }
            // });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }

        this.setState({
            isRefreshing: false,
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errorCd),
        });
        // console.log("======>调用服务结束" + new Date().getTime());
        this.showMessage(errorMsg, DURATION.LENGTH_SHORT);
        if (this.keepCartData !== null) {
            let cartData = this.keepCartData.data;
            this.setState({
                cartData: cartData,
            });
            this.forceUpdate();
        }
    }

    //打开商品规格PopUP
    onCommercialSpecification(data) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                let sizeName = Utils.isEmpty(data.size_name) ? "" : '“' + data.size_name + '” ';
                let colorName = Utils.isEmpty(data.color_name) ? "" : '  “' + data.color_name + '”';
                this.CategoryDatas = {
                    qty: data.qty,//商品数量
                    cs_code: data.cs_code,//规格code(colorCode+sizeCode)
                    cs_name: sizeName + colorName,//规格名称(colorName+sizeName)
                    price: data.price,//商品价格
                    cart_seq: data.cart_seq,//购物车编号
                    item_code: data.item_code,//商品编号
                    uri: data.uri,//商品uri
                    giftArr: data.gift_arr,//已选赠品数据
                    changeGiftCd: "",//要更换赠品code
                    shopGiftArr: [],//商品赠品数据
                    colors: [],//规格颜色
                    sizes: [],//规格尺寸
                    giftExistFlg: data.giftItem_yn,//商品是否有赠品
                    frmDialogFlg: true,//是否从规格打开赠品
                    size_name: data.size_name,
                    color_name: data.color_name,
                    size_code: data.size_code,
                    color_code: data.color_code,
                }
                let obj = {
                    //商品code
                    item_code: data.item_code,
                    IsNewSingle: "Y",
                }
                //loading
                showLoadingDialog(true);
                //打开规格Dialog
                this.props.clickCommercialSpecification(obj,
                    (result) => this.commercialSpecificationSuccessCallback(result),
                    (errMsg, errCd) => this.commercialSpecificationFailCallback(errMsg, errCd));
            } else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });

    }

    //规格数据成功回调
    commercialSpecificationSuccessCallback(result) {
        this.CategoryDatas.colors = [];
        this.CategoryDatas.sizes = [];
        //规格颜色
        this.CategoryDatas.colors = result.data.colors;
        //规格尺寸
        this.CategoryDatas.sizes = result.data.sizes;
        //loading
        showLoadingDialog(false);
        //规格Dialog打开,赠品Dialog关闭
        this.setState({
            showCategoryDialog: true,
            showGiftDialog: false,
            netStatus: true,
            errStatus: true,
        })
    }

    //规格数据失败回调
    commercialSpecificationFailCallback(errMsg, errCd) {
        //loading 消去
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            // RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //     if (event.tokenType === "self") {
            //         //重新拉取数据
            //         this.getCartData();
            //     }
            // });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }

        this.setState({
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });
        // console.log("======>调用服务结束" + new Date().getTime());
        this.showMessage(errMsg, DURATION.LENGTH_SHORT);
    }

    //规格确定
    confirmCommercialSpecification(data) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                let giftItemCodes = [];
                let unitCodes = [];
                let giftCartSeqs = [];
                this.CategoryDatas.giftArr.map((item) => {
                    giftItemCodes.push(item.item_code);
                    unitCodes.push(item.unit_code);
                    giftCartSeqs.push(item.giftcart_seq);
                })
                let obj = {
                    //数量
                    qty: String(this.CategoryDatas.qty),
                    //规格
                    unit_code: data.selectCodeStr,
                    //购物车seq
                    cart_seq: String(this.CategoryDatas.cart_seq),
                    //赠品编号
                    gift_item_code: Utils.norepeat(giftItemCodes),
                    //赠品规格
                    gift_unit_code: Utils.norepeat(unitCodes),
                    //店铺index
                    storeIndex: "",
                    //商品index
                    shopIndex: "",
                    //原数量
                    shopCnt: "",
                    //赠品购物车seq
                    gift_cart_seq: Utils.norepeat(giftCartSeqs),
                    selectShopArr: this.selectedCartSeqs,
                };
                //loading 显示
                showLoadingDialog(true);
                //规格Dialog消去
                this.setState({showCategoryDialog: false});
                //商品追加
                this.props.clickConfirmCommercial(obj,
                    (result) => this.successCallback(result),
                    (errMsg, errCd) => this.failCallback(errMsg, errCd));
            } else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });
    }

    //{
    //    "cartItemList": [
    //        {
    //            "cart_seq": 1,
    //            "giftcartItemInfos": [
    //                {
    //                    "item_code": "15190606",
    //                    "giftcart_seq": "1",
    //                    "unit_code": "001"
    //                }
    //                ],
    //            "item_qty": 6,
    //            "unit_code": "001"
    //        },...
    //    ]
    //}
    //更新编辑数组
    setUpdateBody(obj) {
        for (let index = 0; index < updateBody.cartItemList.length; index++) {
            let item = updateBody.cartItemList[index];
            if (item.cart_seq === obj.cart_seq) {
                updateBody.cartItemList[index] = {
                    cart_seq: obj.cart_seq,
                    item_qty: obj.qty ? obj.qty : obj.item_qty ? obj.item_qty : 1,
                    unit_code: obj.unit_code,
                    ...obj
                };
                return;
            }
        }
        updateBody.cartItemList.push({
            cart_seq: obj.cart_seq,
            item_qty: obj.qty ? obj.qty : obj.item_qty ? obj.item_qty : 1,
            unit_code: obj.unit_code,
            ...obj
        })
    }

    //编辑取消选中
    cancelChange(seq) {
        for (let index = 0; index < updateBody.cartItemList.length; index++) {
            let item = updateBody.cartItemList[index];
            if (item.cart_seq === seq) {
                updateBody.cartItemList.splice(index, 1);
            }
        }
    }

    getUpdateSeqs() {
        let seqs = [];
        updateBody.cartItemList.map((item) => {
            seqs.push(item.cart_seq);
        })
        return seqs;
    }

    // 打开商品数量加1
    onAdd(data) {
        // {
        //     shopCnt: 7,    // 购买数量
        //     shopIndex: 0,  // 商品索引
        //     storeIndex: 0  // 商铺索引
        // }
        //NetInfo.isConnected.fetch().done((isConnected) => {
        //有网络
        //if (isConnected) {
        this.selectedCartSeqs.push(data.cart.cart_seq);
        let obj = {
            //数量
            qty: String(data.cart.qty),
            //规格
            unit_code: data.cart.unit_code,
            //购物车seq
            cart_seq: String(data.cart.cart_seq),
            //赠品编号
            gift_item_code: [],
            //赠品规格
            gift_unit_code: [],
            //赠品购物车seq
            gift_cart_seq: [],
            //店铺index
            storeIndex: data.storeIndex,
            //商品index
            shopIndex: data.shopIndex,
            //原数量
            shopCnt: data.shopCnt,
            //需要选择的商品
            selectShopArr: Utils.norepeat(this.selectedCartSeqs),
        };
        //loading 显示
        //showLoadingDialog(true);
        DataAnalyticsModule.trackEvent3("AP1706C001B036001O001001", "", {itemcode: data.item_code});
        this.CartData.data.shop[data.storeIndex].cart_items_info[data.shopIndex].item_qty = data.cart.qty;
        this.setState({
            cartData: this.CartData.data
        });
        //商品追加
        //this.props.clickShoppingAdd(obj, (result) => this.successCallback(result), (errMsg, errCd) => this.failCallback(errMsg, errCd));
        this.setUpdateBody(obj);
        // } else {
        //     //网络异常
        //     this.setState({
        //         netStatus: false,
        //         errStatus: true,
        //     });
        // }
        //});
    }

    // 商品件数减1
    onPlus(data) {
        //NetInfo.isConnected.fetch().done((isConnected) => {
        //有网络
        //if (isConnected) {
        this.selectedCartSeqs.push(data.cart.cart_seq);
        let obj = {
            //数量
            qty: String(data.cart.qty),
            //规格
            unit_code: data.cart.unit_code,
            //购物车seq
            cart_seq: String(data.cart.cart_seq),
            //赠品编号
            gift_item_code: [],
            //赠品规格
            gift_unit_code: [],
            //赠品购物车seq
            gift_cart_seq: [],
            //店铺index
            storeIndex: data.storeIndex,
            //商品index
            shopIndex: data.shopIndex,
            //原数量
            shopCnt: data.shopCnt,
            //需要选择的商品
            selectShopArr: Utils.norepeat(this.selectedCartSeqs)
        };
        //loading 显示
        //showLoadingDialog(true);
        DataAnalyticsModule.trackEvent3("AP1706C001B036001O002001", "", {itemcode: data.item_code});
        this.CartData.data.shop[data.storeIndex].cart_items_info[data.shopIndex].item_qty = data.cart.qty;
        this.setState({
            cartData: this.CartData.data
        })
        //商品数量减1
        //this.props.clickShoppingPlus(obj, (result) => this.successCallback(result), (errMsg, errCd) => this.failCallback(errMsg, errCd));
        this.setUpdateBody(obj);
        //     } else {
        //         //网络异常
        //         this.setState({
        //             netStatus: false,
        //             errStatus: true,
        //         });
        //     }
        // });


    }

    //商品数量修改提交
    onSubmitEditing(data) {
        // NetInfo.isConnected.fetch().done((isConnected) => {
        //有网络
        // if (isConnected) {
        if (data.storeIndex !== undefined) {
            this.selectedCartSeqs.push(data.cart.cart_seq);
            let obj = {
                //数量
                qty: String(data.cart.qty),
                //规格
                unit_code: data.cart.unit_code,
                //购物车seq
                cart_seq: String(data.cart.cart_seq),
                //赠品编号
                gift_item_code: [],
                //赠品规格
                gift_unit_code: [],
                //赠品购物车seq
                gift_cart_seq: [],
                //店铺index
                storeIndex: data.storeIndex,
                //商品index
                shopIndex: data.shopIndex,
                //原数量
                shopCnt: data.shopCnt,
                //需要选择的商品
                selectShopArr: Utils.norepeat(this.selectedCartSeqs)
            };
            //loading 显示
            //showLoadingDialog(true);
            this.CartData.data.shop[data.storeIndex].cart_items_info[data.shopIndex].item_qty = data.cart.qty;
            this.setState({
                cartData: this.CartData.data
            });
            this.setUpdateBody(obj);
        }
        // else {
        //     //网络异常
        //     this.setState({
        //         netStatus: false,
        //         errStatus: true,
        //     });
        // }
        // }
        // });
    }

    //商品件数焦点离开
    onBlur(data) {
        //NetInfo.isConnected.fetch().done((isConnected) => {
        //有网络
        //if (isConnected) {
        if (data.storeIndex !== undefined) {
            this.selectedCartSeqs.push(data.cart.cart_seq);
            let obj = {
                //数量
                qty: String(data.cart.qty),
                //规格
                unit_code: data.cart.unit_code,
                //购物车seq
                cart_seq: String(data.cart.cart_seq),
                //赠品编号
                gift_item_code: [],
                //赠品规格
                gift_unit_code: [],
                //赠品购物车seq
                gift_cart_seq: [],
                //店铺index
                storeIndex: data.storeIndex,
                //商品index
                shopIndex: data.shopIndex,
                //原数量
                shopCnt: data.shopCnt,
                //需要选择的商品
                selectShopArr: Utils.norepeat(this.selectedCartSeqs)
            };
            //loading 显示
            //showLoadingDialog(true);
            this.CartData.data.shop[data.storeIndex].cart_items_info[data.shopIndex].item_qty = data.cart.qty;
            this.setState({
                cartData: this.CartData.data
            })
            //this.props.clickShoppingBlur(obj, (result) => this.successCallback(result), (errMsg, errCd) => this.failCallback(errMsg, errCd));
            this.setUpdateBody(obj);
            // } else {
            //     //网络异常
            //     this.setState({
            //         netStatus: false,
            //         errStatus: true,
            //     });
            // }
        }
        // });
    }

    //当前商品选择
    onSelected(data) {
        //NetInfo.isConnected.fetch().done((isConnected) => {
        //有网络
        // if (isConnected) {
        this.selectedCartSeqs = Utils.norepeat(this.selectedCartSeqs);
        if (data.check_cart_yn === Constants.Selected) {
            //移除已选择商品
            this.selectedCartSeqs.map((item, index) => {
                if (item === data.cart_seq) {
                    this.selectedCartSeqs.splice(index, 1);
                }
            })
        } else {
            //添加选择商品
            this.selectedCartSeqs.push(data.cart_seq);
        }
        let obj = {
            //选择的购物车的编号
            cart_seqs: Utils.norepeat(this.selectedCartSeqs),
        };
        //loading 显示
        showLoadingDialog(true);
        this.props.clickShoppingSelected(obj,
            (result) => this.successSelectCallback(result),
            (errMsg, errCd) => this.failSelectCallback(errMsg, errCd));
        // } else {
        //     //网络异常
        //     this.setState({
        //         netStatus: false,
        //         errStatus: true,
        //     });
        // }
        // });

    }

    /**
    * @actor weiyi
    * @description
    * 排序算法, 把旧数据排序为新数据
    * @param { string } - key     排序的键值
    * @param { Array } - oldData  老数据
    * @param { Array } - newData  新数据
    * @return { Array } - 排序后的新数组
    * @from react element diff 排序算法
    * @example
    * sortFactory('key', [{key: 'class1', a: 1}, {key: 'class2' , b: 1}], [{key: 'class2'}, {key: 'class1'}])
    * => [{key: 'class2', b: 1}, {key: 'class1' , a: 1}]
    **/
    sortFactory(key, oldData, newData) {
        if(!newData || !oldData) { return oldData; }
        /**
        * @description
        * 交换2个元素位置
        * @param { Array } - place 交换的位置 eg: [1, 2]
        * @param { Array } - arr   需要交换位置的数组
        * @return { Array } -      平移后的数组
        * @example
        * changePlace([0, 2], [1,2,3,4,5]);
        * => [3, 2, 1, 4, 5]
        **/
        const changePlace = (place, arr) => {
            const cache =  arr[place[0]];
            arr[place[0]] = arr[place[1]];
            arr[place[1]] = cache;
        	return arr;
        };
        /**
        * @description
        * 查询key位置所在索引
        * @example
        * findKeyIndex('123', [{key: 1}, {key: '123'}, {key: 2}]); => 1
        **/
        const findKeyIndex = (findKey, arr) => {
            let index = -1;
            for(let i =0; i < arr.length; i++) {
                if(arr[i][key] === findKey) {
                    index = i;
                    break;
                } else {
                    continue;
                }
            }
        	return index;
        };
        // 访问过的节点在新集合中的最右边位置
        let lastIndex = 0;
        // 元素在旧集合中的位置
        let _mountIndex = 0;
        // 遍历新数据
        newData.forEach((data, index) => {
            const newKey = data[key];
            // 找到元素在旧集合的位置
            _mountIndex = findKeyIndex(newKey, oldData);
            // 判断数据是否被删除(删除的数据不去平移)
            if (_mountIndex !== -1) {
                // 判断是否需要交换位置
                _mountIndex < lastIndex ? changePlace([index, _mountIndex], oldData) : null;
                // 更新访问过的节点
                lastIndex = Math.max(_mountIndex, lastIndex);
            }
        });
        return oldData;
    }

    //请求数据成功回调
    successSelectCallback(result) {
        let checkSelected = false;
        let btnDisable = false;
        //清空数据
        this.clearData();
        // console.log("======>调用服务结束" + new Date().getTime());
        //购物车原数据
        // 别deep了那么复杂的数据结构
        this.keepCartData = Utils.deepCopy(result);
        //购物车数据
        this.CartData = Utils.deepCopy(result);
        //购物车数据
        let cartDt = this.CartData.data;
        if (result.dataFlg === true) {
            // 价格部是否全选
            checkSelected = this.checkAllSelected(cartDt);
            // 按钮是否有效
            btnDisable = this.checkBtnDisabled(cartDt);
        }
        // 排序商铺
        this.sortFactory('ven_code' , cartDt.shop, this.state.cartData.shop);
        // 排序商铺列表
        cartDt.shop.forEach((d, index) => {
            cartDt.shop.cart_items_info && cartDt.shop.cart_items_info.forEach((d, index) => {
                this.sortFactory('item_code' , cartDt.shop.cart_items_info, this.state.cartData.shop.cart_items_info);
            });
        });
        // 保存之前的设置
        this.state.cartData.shop && cartDt.shop.forEach((d, i) => {
            d.cart_items_info.forEach((d, index) => {
                d.item_qty = this.state.cartData.shop[i].cart_items_info[index].item_qty;
            });
        });
        // this.sortFactory('ven_code' , cartDt.shop, this.state.cartData.shop);
        // console.log(cartDt.shop);
        // 排序每个商铺下商品
        // cartDt.shop.forEach((d, index) => {
        //     cartDt.shop[index].cart_items_info.forEach((d, index) => {
        //
        //     });
        // });
        // addChangeBuyNumber
        this.setState({
            isRefreshing: false,
            complete: true,
            dataExistFlg: result.dataFlg,
            cartData: cartDt,
            allSelected: checkSelected,
            accountDisable: btnDisable,
            netStatus: true,
            errStatus: true
        });
        //loading 消去
        showLoadingDialog(false);
        //重新获取选中价格
        this.requestCalculatePrice();
    }

    //请求数据失败回调
    failSelectCallback(errMsg, errCd) {
        //loading 消去
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            // RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //     if (event.tokenType === "self") {
            //         //重新拉取数据
            //         this.getCartData();
            //     }
            // });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }

        this.setState({
            isRefreshing: false,
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });
        // console.log("======>调用服务结束" + new Date().getTime());
        this.showMessage(errMsg, DURATION.LENGTH_SHORT);
        if (this.keepCartData !== null) {
            let cartData = this.keepCartData.data;
            this.setState({
                cartData: cartData,
            });
            this.forceUpdate();
        }
    }

    //移入收藏
    onCollection(data) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                let cartSeq = data.cart_seq;
                let itemCode = data.item_code;
                let selectShoppingArr = [];
                //this.selectedCartSeqs.push(cartSeq);
                //选择商品
                selectShoppingArr.push(cartSeq);
                let obj = {
                    //选择的购物车的编号
                    cart_seqs: selectShoppingArr,
                    //需要选择的商品
                    selectShopArr: Utils.norepeat(this.selectedCartSeqs)
                };
                DataAnalyticsModule.trackEvent3("AP1706C001B036001O003001", "", {type: "移入收藏", itemcode: itemCode});
                //loading 显示
                showLoadingDialog(true);
                this.props.clickShoppingCollection(obj,
                    (result) => this.successCollectionCallback(result),
                    (errMsg, errCd) => this.failCollectionCallback(errMsg, errCd));
            } else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });

    }

    //请求数据成功回调
    successCollectionCallback(result) {
        updateBody.cartItemList = [];
        let checkSelected = false;
        let btnDisable = false;
        //清空数据
        this.clearData();
        // console.log("======>调用服务结束" + new Date().getTime());
        //购物车原数据
        this.keepCartData = Utils.deepCopy(result);
        //购物车数据
        this.CartData = Utils.deepCopy(result);
        //购物车数据
        let cartDt = this.CartData.data;
        if (result.dataFlg === true) {
            //价格部是否全选
            checkSelected = this.checkAllSelected(cartDt);
            //按钮是否有效
            btnDisable = this.checkBtnDisabled(cartDt);
        }
        // // 排序商铺
        // this.sortFactory('ven_code' , cartDt.shop, this.state.cartData.shop);
        // // 排序商铺列表
        // cartDt.shop.forEach((d, index) => {
        //     cartDt.shop.cart_items_info && cartDt.shop.cart_items_info.forEach((d, index) => {
        //         this.sortFactory('item_code' , cartDt.shop.cart_items_info, this.state.cartData.shop.cart_items_info);
        //     });
        // });
        this.setState({
            isRefreshing: false,
            complete: true,
            dataExistFlg: result.dataFlg,
            cartData: cartDt,
            allSelected: checkSelected,
            accountDisable: btnDisable,
            netStatus: true,
            errStatus: true,
        });
        //loading 消去
        showLoadingDialog(false);
        this.requestCalculatePrice();
    }

    //请求数据失败回调
    failCollectionCallback(errMsg, errCd) {
        //loading 消去
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            // RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //     if (event.tokenType === "self") {
            //         //重新拉取数据
            //         this.getCartData();
            //     }
            // });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }

        this.setState({
            isRefreshing: false,
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });
        // console.log("======>调用服务结束" + new Date().getTime());
        this.showMessage(errMsg, DURATION.LENGTH_SHORT)
        if (this.keepCartData !== null) {
            let cartData = this.keepCartData.data;
            this.setState({
                cartData: cartData,
            });
            this.forceUpdate();
        }
    }

    //商品删除
    onDelete(data) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                let cartSeq = data.cart_seq;
                let itemCode = data.item_code;
                let cartSeqArr = [];
                //this.selectedCartSeqs.push(cartSeq);
                cartSeqArr.push(cartSeq);
                let obj = {
                    //选择的购物车的编号
                    cart_seqs: cartSeqArr,
                    //需要选择的商品
                    selectShopArr: Utils.norepeat(this.selectedCartSeqs),
                };
                //loading 显示
                DataAnalyticsModule.trackEvent3("AP1706C001B036001O004001", "", {type: "删除购物车", itemcode: itemCode});
                showLoadingDialog(true);
                this.props.clickShoppingDelete(obj,
                    (result) => this.successDeleteCallback(result),
                    (errMsg, errCd) => this.failDeleteCallback(errMsg, errCd));
            } else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });
    }

    //请求数据成功回调
    successDeleteCallback(result) {
        updateBody.cartItemList = [];
        let checkSelected = false;
        let btnDisable = false;
        //清空数据
        this.clearData();
        // console.log("======>调用服务结束" + new Date().getTime());
        //购物车原数据
        this.keepCartData = Utils.deepCopy(result);
        //购物车数据
        this.CartData = Utils.deepCopy(result);
        //购物车数据
        let cartDt = this.CartData.data;
        if (result.dataFlg === true) {
            //价格部是否全选
            checkSelected = this.checkAllSelected(cartDt);
            //按钮是否有效
            btnDisable = this.checkBtnDisabled(cartDt);
        }
        // // 排序商铺
        // this.sortFactory('ven_code' , cartDt.shop, this.state.cartData.shop);
        // // 排序商铺列表
        // cartDt.shop.forEach((d, index) => {
        //     cartDt.shop.cart_items_info && cartDt.shop.cart_items_info.forEach((d, index) => {
        //         this.sortFactory('item_code' , cartDt.shop.cart_items_info, this.state.cartData.shop.cart_items_info);
        //     });
        // });
        this.setState({
            isRefreshing: false,
            complete: true,
            dataExistFlg: result.dataFlg,
            cartData: cartDt,
            allSelected: checkSelected,
            accountDisable: btnDisable,
            netStatus: true,
            errStatus: true,
        });
        //loading 消去
        showLoadingDialog(false);
        this.requestCalculatePrice();
    }

    //请求数据失败回调
    failDeleteCallback(errMsg, errCd) {
        //loading 消去
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            //  RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //      if (event.tokenType === "self") {
            //          //重新拉取数据
            //          this.getCartData();
            //      }
            //  });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }

        this.setState({
            isRefreshing: false,
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });
        this.showMessage(errMsg, DURATION.LENGTH_SHORT)
        if (this.keepCartData !== null) {
            let cartData = this.keepCartData.data;
            this.setState({
                cartData: cartData,
            });
            this.forceUpdate();
        }
    }

    /**
    * @TODO
    * 增加了选择商铺位置不改变
    **/
    onStoreSelected(data) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                let obj = {};
                this.selectedCartSeqs = Utils.norepeat(this.selectedCartSeqs)
                if (data.check_shop_yn === Constants.Selected) {
                    //移除已选择店铺商品
                    this.storeArray.get(data.ven_code).map((item) => {
                        this.selectedCartSeqs.map((item2, index) => {
                            if ((item === item2)) {
                                this.selectedCartSeqs.splice(index, 1);
                            }
                        });
                    });
                } else {
                    this.storeArray.get(data.ven_code).map((item) => {
                        //添加选择店铺商品
                        this.selectedCartSeqs.push(item);
                    });
                }
                //loading 显示
                showLoadingDialog(true);
                //选择的购物车的编号
                obj.cart_seqs = this.selectedCartSeqs;
                // console.log("====选择店铺内商品Cart_Seqs: " + obj.cart_seqs);
                //该店铺内所有商品cart_seq
                this.props.clickStoreSelected(obj,
                    (result) => this.successSelectCallback(result),
                    (errMsg, errCd) => this.failSelectCallback(errMsg, errCd));
            } else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });
    }

    //完成状态购物车商品全选
    onAllFinishShoppingSelected(data) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                if (data.selected) {
                    //移除所有商品
                    this.selectedCartSeqs = [];
                } else {
                    this.allShoppingArray.map((item) => {
                        //添加所有商品
                        this.selectedCartSeqs.push(item);
                    });
                }
                let obj = {
                    //选择的购物车的编号
                    cart_seqs: Utils.norepeat(this.selectedCartSeqs),
                };
                //loading 显示
                showLoadingDialog(true);
                //该店铺内所有商品cart_seq
                this.props.clickAllSelected(obj,
                    (result) => this.successSelectCallback(result),
                    (errMsg, errCd) => this.failSelectCallback(errMsg, errCd));
            } else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });

    }

    //编辑状态商品全选
    onAllEditShoppingSelected(data) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                if (data.selected) {
                    //移除所有商品
                    this.selectedCartSeqs = [];
                } else {
                    this.allShoppingArray.map((item) => {
                        //添加所有商品
                        this.selectedCartSeqs.push(item);
                    });
                }
                let obj = {
                    //选择的购物车的编号
                    cart_seqs: Utils.norepeat(this.selectedCartSeqs),
                };
                //loading 显示
                showLoadingDialog(true);
                //该店铺内所有商品cart_seq
                this.props.clickAllSelected(obj,
                    (result) => this.successSelectCallback(result),
                    (errMsg, errCd) => this.failSelectCallback(errMsg, errCd));
            }
            else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });

    }

    //编辑状态移入收藏
    onCollectionSelectItem() {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                let cartSeqArr = this.getUpdateSeqs();
                this.selectedShoppingArray.map((item) => {
                    cartSeqArr.push(item.cart_seq);
                })
                let obj = {
                    //选择的购物车的编号
                    cart_seqs: Utils.norepeat(cartSeqArr),
                    selectShopArr: [],
                };
                //所选商品移入收藏
                if (cartSeqArr.length <= 0) {
                    this.showMessage("请选择商品,谢谢!", DURATION.LENGTH_SHORT);
                    return;
                }
                //loading 显示
                showLoadingDialog(true);
                this.props.clickCollectionSelectItem(obj,
                    (result) => this.successCollectionCallback(result),
                    (errMsg, errCd) => this.failCollectionCallback(errMsg, errCd));
            }
            else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });

            }
        });


    }

    //编辑状态商品删除
    onDeleteSelectItem() {

        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                let cartSeqArr = this.getUpdateSeqs();
                this.selectedShoppingArray.map((item) => {
                    cartSeqArr.push(item.cart_seq);
                })

                let obj = {
                    //选择的购物车的编号
                    cart_seqs: Utils.norepeat(cartSeqArr),
                    selectShopArr: [],
                };
                if (cartSeqArr.length <= 0) {
                    this.showMessage("请选择商品,谢谢!", DURATION.LENGTH_SHORT);
                    return;
                }
                //loading 显示
                showLoadingDialog(true);
                this.props.clickDeleteSelectItem(obj,
                    (result) => this.successDeleteCallback(result),
                    (errMsg, errCd) => this.failDeleteCallback(errMsg, errCd));
            }
            else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });

    }

    //去结算
    onGoToAccount() {

        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                let cartSeqArr = [];
                let cartPriceArr = [];
                let cartCntArr = [];
                let cartItemCodeArr = [];
                //已选择价格列表
                let priceDetail = Utils.norepeat(this.selectedShoppingArray);

                priceDetail.map((item) => {
                    if (item.item_status !== 1 && item.item_status !== 2) {
                        cartSeqArr.push(item.cart_seq);
                        cartPriceArr.push(item.sale_price);
                        cartCntArr.push(item.item_qty);
                        cartItemCodeArr.push(item.item_code);
                    }
                })

                if (cartSeqArr.length <= 0) {
                    this.showMessage("请选择商品,谢谢!", DURATION.LENGTH_SHORT);
                    return;
                }
                let obj = {
                    //选择的购物车的编号
                    cartSeqs: cartSeqArr.join(","),
                };


                DataAnalyticsModule.trackEvent3("AP1706C001F001001O006001", "", {
                    itemcodelist: cartItemCodeArr.join(","),
                    itempricelist: cartPriceArr.join(","),
                    itemcntlist: cartCntArr.join(","),
                });

                //检测token是否登录
                RnConnect.get_token((events) => {
                    this.checkToken(events.token, obj);
                });
            }
            else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });

    }

    //检测token是否登录token
    checkToken(token, obj) {
        this.CheckToken = new CheckToken({token: token ? token : Global.token}, 'GET');
        this.CheckToken.start(
            (response) => {
                if (response.code === 200 && response.data.isLogin) {
                    //loading 显示
                    showLoadingDialog(true);
                    this.props.clickGoToAccount(obj,
                        (result) => this.goToAccountSuccessCallback(result),
                        (errMsg, errCd) => this.goToAccountFailCallback(errMsg, errCd));
                } else {
                    //去登录
                    // RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
                    //     if (event.tokenType === "self") {
                    //         //重新拉取数据
                    //         this.getCartData();
                    //     }
                    // });
                    RouteManager.routeJump({
                        page: routeConfig.Login,
                        fromRNPage: routeConfig.CartRootPage,
                    }, (event) => {
                        if (event.tokenType === "self") {
                            //重新拉取数据
                            this.getCartData();
                        }
                    });
                }
            }, (erro) => {
                //去登录
                //  RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
                //      if (event.tokenType === "self") {
                //          //重新拉取数据
                //          this.getCartData();
                //      }
                //  });
                RouteManager.routeJump({
                    page: routeConfig.Login,
                    fromRNPage: routeConfig.CartRootPage,
                }, (event) => {
                    if (event.tokenType === "self") {
                        //重新拉取数据
                        this.getCartData();
                    }
                });//
            });
    }

    //去结算成功数据回调
    goToAccountSuccessCallback(result) {
        //loading消去
        showLoadingDialog(false);
        let cartSeqArr = [];
        //已选择价格列表
        let priceDetail = this.selectedShoppingArray;
        priceDetail.map((item) => {
            if (item.item_status !== 1 && item.item_status !== 2) {
                cartSeqArr.push(item.cart_seq);
            }
        })
        let resword = result.data.resword;//值为1时，使用员工折扣，为0时2不使用员工折扣
        if (resword === "1") {
            //显示是否使用折扣
            this.setState({
                showConfirm: true,
                netStatus: true,
                errStatus: true,
                resword: resword,
            });
        } else {
            //订单详情
            Actions.OrderFill({
                page: 'PAGE_FROM_CATRS',
                cartSeqs: cartSeqArr,
                dcrate_yn: "0",
                app_first_dc_yn: "yes"
            });
        }
    }

    //去结算失败数据回调
    goToAccountFailCallback(errMsg, errCd) {
        //loading 消去
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            //  RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //      if (event.tokenType === "self") {
            //          //重新拉取数据
            //          this.getCartData();
            //      }
            //  });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });//
            return;
        }
        this.setState({
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });

        this.showMessage(errMsg, DURATION.LENGTH_SHORT);
    }

    //去结算
    onUseEmpDiscount(data) {
        let cartSeqArr = [];
        //已选择价格列表
        let priceDetail = this.selectedShoppingArray;
        //是否使用折扣
        let resword = data.resword === "1" ? "1" : "0";
        priceDetail.map((item) => {
            cartSeqArr.push(item.cart_seq);
        })
        if (cartSeqArr.length <= 0) {
            return;
        }
        this.setState({
            showConfirm: false
        });
        //订单详情
        Actions.OrderFill({
            page: 'PAGE_FROM_CATRS',
            cartSeqs: cartSeqArr,
            dcrate_yn: resword,
            app_first_dc_yn: "yes"
        });
    }

    //跨境综合税说明
    onTaxIcon() {
        this.setState({
            showTaxDes: true,
        });
    }

    //关闭跨境综合税
    closeTaxDescription() {
        this.setState({
            showTaxDes: false,
        });
    }

    //打开赠品
    onOpenGiftDialog(data, selectedCategory, selectedCategoryCode) {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                //修改后的规格名称
                this.CategoryDatas.cs_name = selectedCategory;
                //修改后的规格code
                this.CategoryDatas.cs_code = selectedCategoryCode;
                //要更换赠品code
                this.CategoryDatas.changeGiftCd = data.giftCode;
                //商品编号
                let itemCode = this.CategoryDatas.item_code;
                let obj = {
                    item_code: itemCode,
                }
                //loading 显示
                showLoadingDialog(true);
                this.props.clickChangeGiftItem(obj,
                    (result) => this.giftSuccessCallback(result),
                    (errMsg, errCd) => this.giftFailCallback(errMsg, errCd));
            } else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });

    }

    //赠品数据成功回调
    giftSuccessCallback(result) {
        //loading消去
        showLoadingDialog(false);

        this.CategoryDatas.shopGiftArr = [];
        //赠品数据列表
        this.CategoryDatas.shopGiftArr = result.data.zpMap;
        //赠品Dialog显示,规格Dialog消失
        this.setState({
            showGiftDialog: true,
            showCategoryDialog: false,
            netStatus: true,
            errStatus: true,
        })
    }

    //赠品数据失败回调
    giftFailCallback(errMsg, errCd) {
        //loading 消去
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            // RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //     if (event.tokenType === "self") {
            //         //重新拉取数据
            //         this.getCartData();
            //     }
            // });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }
        this.setState({
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });

        this.showMessage(errMsg, DURATION.LENGTH_SHORT);
    }

    //购物车查看券
    getCouponDetailClick() {
        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                let cartSeqArr = [];
                let tmpArr = Utils.norepeat(this.selectedShoppingArray);
                tmpArr.map((item) => {
                    cartSeqArr.push(item.item_code);
                })

                let obj = {
                    //选择的购物车商品code
                    item_codes: Utils.norepeat(cartSeqArr),
                };
                showLoadingDialog(true);
                this.props.clickCouponDetailClick(obj,
                    (result) => this.couponDetailSuccessCallback(result),
                    (errMsg, errCd) => this.couponDetailFailCallback(errMsg, errCd));
            } else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });

    }

    //购物车查看券成功回调
    couponDetailSuccessCallback(result) {
        if (!result) {
            return;
        }
        //loading 消去
        showLoadingDialog(false);
        //满足条件券
        let satisfyArr = [];
        //未满足条件券
        let noSatisfyArr = [];

        let totalPrice = result.total_real_price;
        if (totalPrice === null || totalPrice === undefined) {
            return;
        }
        let satisfyPrice = 0;
        let noSatisfyPrice = 0;
        let satisfyTicketPrice = 0;
        if (Array.isArray(result.coupons) && result.coupons.length > 0) {
            result.coupons.map((item, index) => {
                //每张券的满足条件金额(满500 减20)
                satisfyTicketPrice = item.min_order_amt;

                //满足条件券
                // if (parseFloat(totalPrice) >= satisfyTicketPrice) {
                //立减
                //if (item.dc_gb === "10") {
                //    satisfyPrice = satisfyPrice + item.dc_amt;
                //} else if (item.dc_gb === "20") {
                //    satisfyPrice = satisfyPrice + (totalPrice * item.dc_rate / 100);
                //}
                satisfyPrice = result.dc_money;
                satisfyArr.push(item);
                // } else {
                //     //立减
                //     if (item.dc_gb === "10") {
                //         noSatisfyPrice = noSatisfyPrice + item.dc_amt;
                //     } else if (item.dc_gb === "20") {
                //         noSatisfyPrice = noSatisfyPrice + (satisfyTicketPrice * item.dc_rate / 100);
                //     }
                //     noSatisfyArr.push(item);
                // }
            })
        }

        this.lookTicketInfo = {
            satisfyPrice: satisfyPrice,//满足条件可节省多少钱
            satisfyArr: satisfyArr,//满足条件券
            noSatisfyPrice: noSatisfyPrice,//未满足条件可节省多少钱
            noSatisfyArr: noSatisfyArr,//未满足条件券
            totalPrice: totalPrice,//总额
        }
        this.setState({
            showCoupon: true,//显示券
            netStatus: true,
            errStatus: true,
        });

    }

    //购物车查看券失败回调
    couponDetailFailCallback(errMsg, errCd) {
        //loading 消去
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            // RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //     if (event.tokenType === "self") {
            //         //重新拉取数据
            //         this.getCartData();
            //     }
            // });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }
        this.setState({
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });

        this.showMessage(errMsg, DURATION.LENGTH_SHORT);
    }

    //关闭折扣券信息
    closeCartDiscountCoupon() {
        this.setState({
            showCoupon: false,//关闭券
        });
    }

    //赠品Dialog确定
    onConfirmGiftDialog(data) {
        let updataItem = {
            //主品seq
            cart_seq: data.cartSeq,
            activity: {
                zpMap: [{
                    ...data.selectedGift,
                    //赠品seq
                    cart_seq: data.giftSeq,
                }]
            },
            item_qty: data.itemQty ? data.itemQty : 1,
            unit_code: data.selectedGift.unit_code,
        };
        //从规格打开赠品
        if (data.fromPop) {
            //已选赠品数据
            if (this.CategoryDatas.giftArr.length !== this.CategoryDatas.qty) {
                //修改已存在赠品
                if (this.CategoryDatas.changeGiftCd !== "") {
                    this.CategoryDatas.giftArr.map((item, index) => {
                        if (item.gift_item_code === this.CategoryDatas.changeGiftCd) {
                            this.CategoryDatas.giftArr.splice(index, 1, item);
                        }
                    });
                } else {
                    //添加赠品
                    this.CategoryDatas.giftArr.push({
                        gift_item_code: data.selectedGift.gift_item_code,//赠品编号
                        unit_code: data.selectedGift.unit_code,//赠品规格
                        item_name: data.selectedGift.gift_item_name,//赠品名称
                        gift_cart_seq: data.cartSeq,//赠品购物车seq
                        nextAction: "更换赠品"
                    });
                }
                this.setUpdateBody(updataItem);
            }
            //赠品Dialog关闭 规格Dialog打开
            this.setState({
                showGiftDialog: false,
                showCategoryDialog: true,
            });
        } else {
            this.setUpdateBody(updataItem);
            //调用更新接口
            if (updateBody.cartItemList.length > 0) {
                showLoadingDialog(true);
                this.props.clickShoppingSubmit(updateBody, Utils.norepeat(this.selectedCartSeqs), (result, isSubmit, msg) => this.successCallback(result, isSubmit, msg), (errMsg, errCd) => this.failCallback(errMsg, errCd, true));
            }
        }
    }

    //打开商品赠品信息
    changeGiftItem(data) {
        this.storeIndex = 0;
        this.shopIndex = 0;
        //NetInfo.isConnected.fetch().done((isConnected) => {
        //有网络
        //if (isConnected) {
        this.storeIndex = data.storeIndex;
        this.shopIndex = data.shopIndex;
        let zpMap = this.CartData.data.shop[data.storeIndex].cart_items_info[data.shopIndex].activity.zpMap;
        if (!zpMap){
            return;
        }
        let gift_seq = this.CartData.data.shop[data.storeIndex].cart_items_info[data.shopIndex].giftcartItemInfos[0].giftcart_seq;
        let cart_seq = this.CartData.data.shop[data.storeIndex].cart_items_info[data.shopIndex].cart_seq;
        let item_qty = this.CartData.data.shop[data.storeIndex].cart_items_info[data.shopIndex].item_qty;
        this.CategoryDatas.shopGiftArr = [];
        this.CategoryDatas.cart_seq = cart_seq;
        this.CategoryDatas.gift_seq = gift_seq;
        this.CategoryDatas.item_qty = item_qty;
        //赠品数据列表
        this.CategoryDatas.shopGiftArr = zpMap;
        //赠品Dialog显示,规格Dialog消失
        this.setState({
            showGiftDialog: true,
            frmDialogFlg: false,
            netStatus: true,
            errStatus: true,
        })
        //商品code//
        //     let item_code = this.CartData.data.shop[data.storeIndex].cart_items_info[data.shopIndex].item_code;
        //     let obj = {
        //         item_code: item_code,
        //         sitem_code: data.gift_item_code,
        //     }
        //     //loading 显示
        //     showLoadingDialog(true);
        //     this.props.clickChangeGiftItem(obj,
        //         (result) => this.changeGiftSuccessCallback(result),
        //         (errMsg, errCd) => this.changeGiftFailCallback(errMsg, errCd));
        // } else {
        //     //网络异常
        //     this.setState({
        //         netStatus: false,
        //         errStatus: true,
        //     });
        // }
        // });
    }

    //赠品数据成功回调
    changeGiftSuccessCallback(result) {
        //loading消去
        showLoadingDialog(false);
        this.CategoryDatas.shopGiftArr = [];
        //赠品数据列表
        this.CategoryDatas.shopGiftArr = result.data.zpMap;
        //赠品Dialog显示,规格Dialog消失
        this.setState({
            showGiftDialog: true,
            frmDialogFlg: false,
            netStatus: true,
            errStatus: true,
        })
    }

    //赠品数据失败回调
    changeGiftFailCallback(errMsg, errCd) {
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            // RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //     if (event.tokenType === "self") {
            //         //重新拉取数据
            //         this.getCartData();
            //     }
            // });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }
        //loading 消去
        this.setState({
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });

        this.showMessage(errMsg, DURATION.LENGTH_SHORT);
    }

    //数据刷新
    onRefresh() {

        NetInfo.isConnected.fetch().done((isConnected) => {
            //有网络
            if (isConnected) {
                this.setState({
                    isRefreshing: true,
                });
                let cartSeqArr = [];
                //已选择价格列表
                let priceDetail = Utils.norepeat(this.selectedShoppingArray);

                priceDetail.map((item) => {
                    cartSeqArr.push(item.cart_seq);
                })
                let obj = {
                    //选择的购物车的编号
                    cart_seqs: cartSeqArr,
                };
                setTimeout(() => {
                    this.props.refreshData(obj,
                        (result) => this.successGetCallback(result),
                        (errMsg, errCd) => this.failGetCallback(errMsg, errCd));
                }, 100)
            }
            else {
                //网络异常
                this.setState({
                    netStatus: false,
                    errStatus: true,
                });
            }
        });

    }

    //请求数据成功回调
    successGetCallback(result, message) {
        let checkSelected = false;
        let btnDisable = false;
        //清空数据
        this.clearData();
        // console.log("======>调用服务结束" + new Date().getTime());

        //购物车原数据
        this.keepCartData = Utils.deepCopy(result);
        //购物车数据
        this.CartData = Utils.deepCopy(result);
        // console.log("this.keepCartData===this.CartData " + this.keepCartData === this.CartData)
        //购物车数据
        let cartDt = this.CartData.data;
        if (result.dataFlg === true) {
            //价格部是否全选
            checkSelected = this.checkAllSelected(cartDt);
            //按钮是否有效
            btnDisable = this.checkBtnDisabled(cartDt);
        }
        // 排序商铺
        this.sortFactory('ven_code' , cartDt.shop, this.state.cartData.shop);
        // 排序商铺列表
        cartDt.shop && cartDt.shop.forEach((d, index) => {
            cartDt.shop.cart_items_info && cartDt.shop.cart_items_info.forEach((d, index) => {
                this.sortFactory('item_code' , cartDt.shop.cart_items_info, this.state.cartData.shop.cart_items_info);
            });
        });
        this.setState({
            isRefreshing: false,
            complete: true,
            dataExistFlg: result.dataFlg,
            cartData: cartDt,
            allSelected: checkSelected,
            accountDisable: btnDisable,
            netStatus: true,
            errStatus: true,
        });
        //loading 消去
        showLoadingDialog(false);
        if (message) {
            this.showMessage(message, DURATION.LENGTH_LONG);
        }
        this.requestCalculatePrice();

    }

    //获取价格抢购券
    requestCalculatePrice() {
        priceRequestBody.cart_seqs = this.selectedCartSeqs.join(',');
        calculatePriceRequest.start(
            (responseJson) => {
                if (responseJson.code === 200) {
                    this.setState({
                        couponPriceData: responseJson.data,
                    })
                } else {
                    this.setState({
                        couponPriceData: null,
                    })
                }
            },
            (e) => {
                this.setState({
                    couponPriceData: null,
                })
                console.log(e);
            }
        )
    }

    //请求数据失败回调
    failGetCallback(errMsg, errCd, message) {
        //loading 消去
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            //  RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //      if (event.tokenType === "self") {
            //          //重新拉取数据
            //          this.getCartData();
            //      }
            //  });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }

        this.setState({
            isRefreshing: false,
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });
        //this.showMessage(errMsg, DURATION.LENGTH_SHORT);
        if (this.keepCartData !== null) {
            let cartData = this.keepCartData.data;

            this.setState({
                cartData: cartData,
            });
            this.forceUpdate();
        }
        if (message) {
            this.showMessage(message, DURATION.LENGTH_SHORT);
        }
        this.requestCalculatePrice();
    }

    //请求数据成功回调
    successCallback(result, isSubmit, message) {
        updateBody.cartItemList = [];
        let checkSelected = false;
        let btnDisable = false;
        //清空数据
        this.clearData();
        // console.log("======>调用服务结束" + new Date().getTime());

        //购物车原数据
        this.keepCartData = Utils.deepCopy(result);
        //购物车数据
        this.CartData = Utils.deepCopy(result);
        // console.log("this.keepCartData===this.CartData " + this.keepCartData === this.CartData)
        //购物车数据
        let cartDt = this.CartData.data;
        if (result.dataFlg === true) {
            //价格部是否全选
            checkSelected = this.checkAllSelected(cartDt);
            //按钮是否有效
            btnDisable = this.checkBtnDisabled(cartDt);
        }
        // 排序商铺
        this.sortFactory('ven_code' , cartDt.shop, this.state.cartData.shop);
        // 排序商铺列表
        cartDt.shop.forEach((d, index) => {
            cartDt.shop.cart_items_info && cartDt.shop.cart_items_info.forEach((d, index) => {
                this.sortFactory('item_code' , cartDt.shop.cart_items_info, this.state.cartData.shop.cart_items_info);
            });
        });
        this.setState({
            isRefreshing: false,
            complete: true,
            dataExistFlg: result.dataFlg,
            cartData: cartDt,
            allSelected: checkSelected,
            accountDisable: btnDisable,
            netStatus: true,
            errStatus: true,
        });
        //loading 消去
        showLoadingDialog(false);
        if (isSubmit) {
            this.getCartData(message);
        }
    }

    //请求数据失败回调
    failCallback(errMsg, errCd, isSubmit) {
        updateBody.cartItemList = [];
        //loading 消去
        showLoadingDialog(false);
        if (errCd === 4010) {
            //去登录
            //  RnConnect.pushs({page: routeConfig.MePageocj_Login}, (event) => {
            //      if (event.tokenType === "self") {
            //          //重新拉取数据
            //          this.getCartData();
            //      }
            //  });
            RouteManager.routeJump({
                page: routeConfig.Login,
                fromRNPage: routeConfig.CartRootPage,
            }, (event) => {
                if (event.tokenType === "self") {
                    //重新拉取数据
                    this.getCartData();
                }
            });
            return;
        }
        // console.log("======>调用服务结束" + new Date().getTime());

        this.setState({
            isRefreshing: false,
            netStatus: true,
            errStatus: Utils.chkErrCodeEmpty(errCd),
        });
        //this.showMessage(errMsg.error, DURATION.LENGTH_SHORT);
        if (this.keepCartData !== null && errMsg.storeIndex !== undefined && errMsg.storeIndex !== "") {
            let cartData = this.keepCartData.data;

            this.setState({
                cartData: cartData,
            });
            this.forceUpdate();
        }
        if (isSubmit) {
            this.getCartData();
        }
    }

    //价格部是否全选
    checkAllSelected(data) {
        let isSelected = true;
        if (data.shop !== null) {
            data.shop.map((item) => {
                if (item.check_shop_yn === Constants.UnSelected) {
                    isSelected = false;
                }
            });
        }
        return isSelected;
    }

    //检查按钮是否有效
    checkBtnDisabled(data) {
        let btnDisabled = false;
        data.shop.map((item) => {
            item.cart_items_info.map((item2) => {
                if (item2.check_cart_yn === Constants.Selected) {
                    btnDisabled = true;
                }
            });
        })
        return btnDisabled;
    }

    //数据对象清空
    clearData() {
        this.allShoppingArray = [];
        this.selectedShoppingArray = [];
        this.selectedCartSeqs = [];
        this.storeArray = new Map();
    }

    //提示消息
    showMessage(text, duration) {
        this.refs.toast && this.refs.toast.show(text, duration);
    }

    //顶部自定义导航
    renderNavigationBar(renderFlg, totalCnt) {
        let {cart} = this.props;
        let totalVal = totalCnt > 0 ? "(" + totalCnt + ")" : "";
        return (
            <NavigationBar
                key={++key}
                //不是从导航进购物车,显示返回键
                showLeft={this.props.sceneKey !== 'cartFrmRoot'}
                renderLeft={() => {
                    return (
                        <TouchableOpacity
                            activeOpacity={1}
                            onPress={() => {
                                DataAnalyticsModule.trackEvent2("AP1706C001C003001C005001", "");
                                if (this.props.beforepage) {
                                    // 购物车回退
                                    RouteManager.routeBack(this.props.beforepage);
                                } else if (this.state.cartData && this.state.cartData.price) {
                                    Actions.pop({refresh: {cartGoodCount: this.state.cartData.price.total_count}});
                                } else {
                                    Actions.pop({refresh: {cartGoodCount: 0}});
                                }
                            }}
                            style={styles.leftContainerDefaultStyle}>
                            <Image style={styles.leftArrowDefaultStyle}
                                   source={require('IMG/icons/Icon_back_.png')}
                            />
                        </TouchableOpacity>
                    );}}
                renderTitle={() => {
                    return (
                        <Text style={styles.navigationBar} allowFontScaling={false}>购物车{totalVal}</Text>
                    );}}
                showRight={renderFlg} renderRight={() => {
                    let cartVal = cart.type ? "编辑" : "完成";
                    return (
                        <TouchableOpacity activeOpacity={1} onPress={() => this.onChangeCartType(cart.type)}>
                            <Text style={styles.rightStyle} allowFontScaling={false}>{cartVal}</Text>
                        </TouchableOpacity>
                    );}}
                barStyle={'dark-content'}
                navigationStyle={{
                    borderBottomWidth: StyleSheet.hairlineWidth,
                    borderBottomColor: '#dddddd',
                    ...Platform.select({ios: {marginTop: -22}}),
                    height: ScreenUtils.scaleSize(128),}}
            />
        );
    }

    /**
     * 画面渲染
     * @returns {XML}
     */
    render() {
        let {cart} = this.props;
        let totalCount = 0
        if (this.state.couponPriceData && this.state.couponPriceData.total_count !== null) {
            totalCount = this.state.couponPriceData.total_count;
        }
        //网络错误
        if (!this.state.netStatus) {
            return (
                <View style={{flex: 1}}>
                    {this.renderNavigationBar(false, 0)}
                    <NetErro
                        style={{flex: 1}}
                        title={'您的网络好像很傲娇'}
                        confirmText={'刷新试试'}
                        icon={require('IMG/cart/img_net_error_3x.png')}
                        onButtonClick={() => {
                            //根据不同的页面做不同的请求
                            //购物车拉取数据
                            this.getCartData();
                        }}
                    />
                    <Toast ref="toast"/>
                </View>

            );
        }
        //异常发生
        if (!this.state.errStatus) {
            return (
                <View style={{flex: 1}}>
                    {this.renderNavigationBar(false, 0)}
                    <NetErro
                        style={{flex: 1}}
                        title={'亲,服务异常啦!'}
                        confirmText={'刷新试试'}
                        onButtonClick={() => {
                            //购物车拉取数据
                            this.getCartData();
                        }}
                    />
                    <Toast ref="toast"/>
                </View>
            );
        }
        //首次加载页
        if (!this.state.complete) {
            return (<View><Toast ref="toast"/></View>)
        }
        //空购物车
        if (this.state.dataExistFlg === false) {
            return (
                <View style={{flex: 1}}>
                    {this.renderNavigationBar(false, 0)}
                    <CartPage
                        recommendData={this.state.cartData}
                        showLeft={this.props.sceneKey !== 'cartFrmRoot'}
                    />
                    <Toast ref="toast"/>
                </View>)
        }
        //数据购物车
        return (
            <View style={{flex: 1}}>
                {this.renderNavigationBar(true, totalCount)}
                <CartList
                    cancelChange={(seq) => this.cancelChange(seq)}
                    cartData={this.state.cartData}
                    cartType={cart.type}
                    showCoupon={this.state.showCoupon}
                    isRefreshing={this.state.isRefreshing}
                    couponPriceData={this.state.couponPriceData}
                    onRefresh={() => this.onRefresh()}
                    storeArray={this.storeArray}
                    allShoppingArray={this.allShoppingArray}
                    selectedCartSeqs={this.selectedCartSeqs}
                    allSelected={this.state.allSelected}
                    accountDisable={this.state.accountDisable}
                    selectedShoppingArray={this.selectedShoppingArray}
                    onShoppingClick={(data) => this.onShoppingClick(data)}
                    onPlus={(data) => this.onPlus(data)}
                    onAdd={(data) => this.onAdd(data)}
                    onDelete={(data) => this.onDelete(data)}
                    onCollection={(data) => this.onCollection(data)}
                    onBlur={(data) => this.onBlur(data)}
                    onCommercialSpecification={(data) => this.onCommercialSpecification(data)}
                    onSelected={(data) => this.onSelected(data)}
                    onStoreSelected={(data) => this.onStoreSelected(data)}
                    onSubmitEditing={(data) => this.onSubmitEditing(data)}
                    onTaxIcon={() => this.onTaxIcon()}
                    allStoreSelected={(data) => this.onAllFinishShoppingSelected(data)}
                    onAllShoppingSelected={(data) => this.onAllEditShoppingSelected(data)}
                    onCollectionSelectItem={() => this.onCollectionSelectItem()}
                    onDeleteSelectItem={() => this.onDeleteSelectItem()}
                    goToAccount={() => this.onGoToAccount()}
                    toCouponDetailClick={() => this.couponDetailSuccessCallback(this.state.couponPriceData)}
                    changeGiftItem={(data) => this.changeGiftItem(data)}
                />
                {/*购物车规格Dialog */}
                <CartCategoryDialog
                    show={this.state.showCategoryDialog}
                    data={this.CategoryDatas}
                    closeCategoryDialog={() => {
                        this.setState({showCategoryDialog: false})
                    }}
                    openGiftDialog={(data, selectedCategory, selectedCategoryCode) => {
                        this.onOpenGiftDialog(data, selectedCategory, selectedCategoryCode)
                    }}
                    confirmCommercialSpecification={(data) => {
                        this.confirmCommercialSpecification(data)
                    }}
                />
                {/*购物车中赠品Dialog*/}
                <CartGiftPickUpDialog
                    giftData={this.CategoryDatas}
                    frmDialogFlg={this.CategoryDatas.frmDialogFlg}
                    cartSeq={this.CategoryDatas.cart_seq}
                    giftSeq={this.CategoryDatas.gift_seq}
                    itemQty={this.CategoryDatas.item_qty}
                    show={this.state.showGiftDialog}
                    ConfirmGiftDialog={(data) => {
                        this.onConfirmGiftDialog(data);
                        this.setState({showGiftDialog: false});
                    }}
                    closeGiftDialog={(data) => this.setState({showGiftDialog: false})}/>
                {/*确认Dialog*/}
                <ConfirmDialog
                    show={this.state.showConfirm}
                    resword={this.state.resword}
                    clickUseEmpDiscount={(data) => this.onUseEmpDiscount(data)}/>
                {/*券信息Dialog*/}
                <CartDiscountCoupon
                    show={this.state.showCoupon}
                    lookTicketInfo={this.lookTicketInfo}
                    closeCartDiscountCoupon={() => this.closeCartDiscountCoupon()}
                />
                {/*税Dialog*/}
                <TaxDescriptionDialog
                    show={this.state.showTaxDes}
                    closeDialog={() => this.closeTaxDescription()}
                />
                <Toast ref="toast"/>
            </View>
        )
    }
}
let styles = StyleSheet.create({
    navigationBar: {
        fontSize: ScreenUtils.setSpText(34),
        color: Color.text_black,
    },
    rightStyle: {
        fontSize: ScreenUtils.setSpText(30),
        color: Color.text_dark_grey,
        marginRight: ScreenUtils.scaleSize(30),
    },
    leftContainerDefaultStyle: {
        width: ScreenUtils.scaleSize(120),
        height: ScreenUtils.scaleSize(40),
        justifyContent: 'center',
    },
    leftArrowDefaultStyle: {
        width: ScreenUtils.scaleSize(16),
        height: ScreenUtils.scaleSize(24),
        marginLeft: ScreenUtils.scaleSize(20)
    },
});

let mapDispatchToProps = (dispatch) => {
    return ({
        //请求数据
        getCart: (data, successCallback, failCallback) => dispatch(CartAction.getCart(data, successCallback, failCallback)),
        refreshData: (data, successCallback, failCallback) => dispatch(CartAction.refreshData(data, successCallback, failCallback)),
        clickCommercialSpecification: (data, successCallback, failCallback) => dispatch(CartAction.getCommercialSpecification(data, successCallback, failCallback)),
        clickConfirmCommercial: (data, successCallback, failCallback) => dispatch(CartAction.updateCart(data, successCallback, failCallback)),
        clickShoppingAdd: (data, successCallback, failCallback) => dispatch(CartAction.updateCart(data, successCallback, failCallback)),
        clickShoppingPlus: (data, successCallback, failCallback) => dispatch(CartAction.updateCart(data, successCallback, failCallback)),
        clickShoppingSubmit: (data, selectSeq, successCallback, failCallback) => dispatch(CartAction.updateCarts(data, selectSeq, successCallback, failCallback)),
        clickShoppingBlur: (data, successCallback, failCallback) => dispatch(CartAction.updateCart(data, successCallback, failCallback)),
        //当前商品选择
        clickShoppingSelected: (obj, successCallback, failCallback) => dispatch(CartAction.checkCart(obj, successCallback, failCallback)),
        //商品删除
        clickShoppingDelete: (obj, successCallback, failCallback) => dispatch(CartAction.deleteCart(obj, successCallback, failCallback)),
        //移入收藏
        clickShoppingCollection: (obj, successCallback, failCallback) => dispatch(CartAction.addFavorite(obj, successCallback, failCallback)),
        clickStoreSelected: (data, successCallback, failCallback) => dispatch(CartAction.checkCart(data, successCallback, failCallback)),
        clickAllSelected: (data, successCallback, failCallback) => dispatch(CartAction.checkCart(data, successCallback, failCallback)),
        clickCollectionSelectItem: (obj, successCallback, failCallback) => dispatch(CartAction.addFavorite(obj, successCallback, failCallback)),
        clickDeleteSelectItem: (obj, successCallback, failCallback) => dispatch(CartAction.deleteCart(obj, successCallback, failCallback)),
        clickChangeGiftItem: (obj, successCallback, failCallback) => dispatch(CartAction.getGiftData(obj, successCallback, failCallback)),
        changeCartType: (data, successCallback, failCallback) => dispatch(CartAction.changeCartType(data, successCallback, failCallback)),
        clickGoToAccount: (obj, successCallback, failCallback) => dispatch(CartAction.goToAccount(obj, successCallback, failCallback)),
        clickCouponDetailClick: (data, successCallback, failCallback) => dispatch(CartAction.getCouponDetailClick(data, successCallback, failCallback)),
    })
}
let mapStateToProps = (state) => {
    return ({
        cart: state.CartReducer,
    });
}
export default connect(state => mapStateToProps, dispatch => mapDispatchToProps)(CartRootPage)
