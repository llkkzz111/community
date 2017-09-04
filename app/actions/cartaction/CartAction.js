/**
 * Created by Zhang.xinchun on 2017/5/1.
 *
 * 购物车Action
 */

import * as actionTypes from '../actionTypes'
import Encry from 'COMMON/NetworkInterface';
//webServer接口
import CheckCartDataRequest from 'NET/cart/CheckCartDataRequest';
import AddFavoriteDataRequest from 'NET/cart/AddFavoriteDataRequest';
import CheckUseEmpDiscountDataRequest from 'NET/cart/CheckUseEmpDiscountDataRequest';
import DeleteCartRequest from 'NET/cart/DeleteCartRequest';
import GetCartDataRequest from 'NET/cart/GetCartDataRequest';
import GetInitcolorsizeDataRequest from 'NET/cart/GetInitcolorsizeDataRequest';
import GetItemActivitiesDataRequest from 'NET/cart/GetItemActivitiesDataRequest';
import GetOtherItemsDataRequest from 'NET/cart/GetOtherItemsDataRequest';
import UpdateCartDataRequest from 'NET/cart/UpdateCartDataRequest';
import UpdateCartsDataRequest from 'NET/cart/UpdateCartsDataRequest';
import GetItemsCoupons from 'NET/cart/GetItemsCoupons';
export const fetchDataCreate = (type, data) => {
    return {
        type: type,
        payload: {
            data
        }
    }
};
//购物车编辑和完成状态切换
export const changeCartType = (data, successCallback, failCallback) => {

    return (dispatch, getState) => {
        let checkCart = new CheckCartDataRequest({
            cart_seqs: data.selectShopArr
        }, "POST");
        // console.log("购物车选择接口调用");
        checkCart.start(
            (response) => {
                if (response.message === 'succeed') {
                    if (response.data !== ""
                        && response.data.shop !== null
                        && response.data.shop.length > 0
                        && response.data.shop.cart_items_info !== null) {
                        //接口请求成功
                        successCallback({
                            data: response.data,
                            dataFlg: true,
                        });
                        //购物车列表展示
                        dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                            type: actionTypes.CHANGE_CART_TYPE,
                            result: data.cartType,
                            success: true
                        }))
                    } else {
                        //购物车同品推荐
                        let getOtherItemsDataRequestg = new GetOtherItemsDataRequest(null, "GET");
                        // console.log("同品推荐接口调用");
                        getOtherItemsDataRequestg.start(
                            (response) => {
                                if (response.message === 'succeed') {
                                    //接口请求成功
                                    successCallback({
                                        data: response.data,
                                        dataFlg: false,
                                    });
                                    //空购物车展示
                                    dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                        type: actionTypes.GETNCART,
                                        success: true
                                    }))
                                } else {
                                    failCallback(response.message, response.code);
                                }
                            }, (error) => {
                                failCallback(error.message, error.code);
                            });
                    }
                } else {
                    failCallback(response.message, response.code);
                }
            }, (error) => {
                failCallback(error.message, error.code);
            });
    }
}

//获取购物车商品
export const getCart = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        //购物车数据拉取
        let getCart = new GetCartDataRequest({area_mgroup: ""}, "POST").timeout(25);
        // console.log("购物车查询接口调用");
        getCart.start((response) => {
            if (response.message === 'succeed') {
                if (chkDataExists(response)) {
                    //接口请求成功
                    successCallback({
                        data: response.data,
                        dataFlg: true,
                    });
                    //购物车列表展示
                    dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                        type: actionTypes.GETCART,
                        success: true
                    }))
                } else {
                    //购物车同品推荐
                    let getOtherItemsDataRequestg = new GetOtherItemsDataRequest(null, "GET");
                    // console.log("同品推荐接口调用");
                    getOtherItemsDataRequestg.start(
                        (response) => {
                            if (response.message === 'succeed') {
                                //接口请求成功
                                successCallback({
                                    data: response.data,
                                    dataFlg: false,
                                });
                                //空购物车展示
                                dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                    type: actionTypes.GETNCART,
                                    success: true
                                }))
                            } else {
                                failCallback(response.message, response.code);
                            }
                        }, (error) => {
                            failCallback(error.message, error.code);
                        });
                }
            } else {
                failCallback(response.message, response.code);
            }
        }, (error) => {
            failCallback(error.message, error.code);
        });
    }
}
//刷新购物车商品
export const refreshData = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        let checkCart = new CheckCartDataRequest({
            cart_seqs: data.cart_seqs
        }, "POST");
        // console.log("购物车选择接口调用");
        checkCart.start(
            (response) => {
                if (response.message === 'succeed') {
                    if (chkDataExists(response)) {
                        //接口请求成功
                        successCallback({
                            data: response.data,
                            dataFlg: true,
                        });
                        //购物车列表展示
                        dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                            type: actionTypes.CHECKCART,
                            success: true
                        }))
                    } else {
                        //购物车同品推荐
                        let getOtherItemsDataRequestg = new GetOtherItemsDataRequest(null, "GET");
                        // console.log("同品推荐接口调用");
                        getOtherItemsDataRequestg.start(
                            (response) => {
                                if (response.message === 'succeed') {
                                    //接口请求成功
                                    successCallback({
                                        data: response.data,
                                        dataFlg: false,
                                    });
                                    //空购物车展示
                                    dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                        type: actionTypes.GETNCART,
                                        success: true
                                    }))
                                } else {
                                    failCallback(response.message, response.code);
                                }
                            }, (error) => {
                                failCallback(error.message, error.code);
                            });
                    }
                } else {
                    failCallback(response.message, response.code);
                }
            }, (error) => {
                failCallback(error.message, error.code);
            });
    }
}
//加入购物车
export const addCart = (data) => {
    return (dispatch, getState) => {
        Encry.addCart(data, (result) => {
            dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                type: actionTypes.ADDCART,
                result: {
                    ...result
                },
                success: true
            }))
        }, (error) => {
            dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                type: actionTypes.ADDCART,
                result: error,
                success: true
            }))
        });
    }
}
//（新）更新购物车
export const updateCarts = (data, selectSeq, successCallback, failCallback) => {
    return (dispatch, getState) => {
        let updateCarts = new UpdateCartsDataRequest(data, "POST");
        // console.log("购物车更新接口调用");
        let msg = '';
        updateCarts.start(
            (response) => {
                if (response.message === 'succeed') {
                    let checkCart = new CheckCartDataRequest({
                        cart_seqs: selectSeq
                    }, "POST");
                    if (response.data.result === 'false') {
                        response.data.errorItems.map((item) => {
                            msg += item.error_msg + '\n';
                        });
                    }
                    // console.log("购物车选择接口调用");
                    checkCart.start(
                        (response) => {
                            if (response.message === 'succeed') {

                                if (chkDataExists(response)) {
                                    //接口请求成功
                                    successCallback({
                                        data: response.data,
                                        dataFlg: true,
                                    }, true, msg);
                                    //购物车列表展示
                                    dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                        type: actionTypes.UPDATECART,
                                        success: true
                                    }))
                                } else {
                                    //购物车同品推荐
                                    let getOtherItemsDataRequestg = new GetOtherItemsDataRequest(null, "GET");
                                    // console.log("同品推荐接口调用");
                                    getOtherItemsDataRequestg.start(
                                        (response) => {
                                            if (response.message === 'succeed') {

                                                //接口请求成功
                                                successCallback({
                                                    data: response.data,
                                                    dataFlg: false,
                                                }, true, msg);
                                                //空购物车展示
                                                dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                                    type: actionTypes.GETNCART,
                                                    success: true
                                                }))
                                            } else {
                                                failCallback({
                                                    error: response.message,
                                                    storeIndex: data.storeIndex,
                                                    shopIndex: data.shopIndex,
                                                    cartCnt: data.shopCnt
                                                }, response.code, true);
                                            }
                                        }, (error) => {
                                            failCallback({
                                                error: error.message,
                                                storeIndex: data.storeIndex,
                                                shopIndex: data.shopIndex,
                                                cartCnt: data.shopCnt
                                            }, error.code, true);
                                        });
                                }
                            } else {
                                failCallback({
                                    error: response.message,
                                    storeIndex: data.storeIndex,
                                    shopIndex: data.shopIndex,
                                    cartCnt: data.shopCnt
                                }, response.code, true);
                            }
                        }, (error) => {
                            failCallback({
                                error: error.message,
                                storeIndex: data.storeIndex,
                                shopIndex: data.shopIndex,
                                cartCnt: data.shopCnt
                            }, error.code, true);
                        });

                } else {
                    failCallback({
                        error: response.message,
                        storeIndex: data.storeIndex,
                        shopIndex: data.shopIndex,
                        cartCnt: data.shopCnt
                    }, response.code, true);
                }
            }, (error) => {
                failCallback({
                    error: error.message,
                    storeIndex: data.storeIndex,
                    shopIndex: data.shopIndex,
                    cartCnt: data.shopCnt
                }, error.code, true);
            });
    }
}
//更新购物车
export const updateCart = (data, successCallback, failCallback) => {
    let qtyArr = [];
    let unitArr = [];
    let seqArr = [];
    qtyArr.push(data.qty);
    unitArr.push(data.unit_code);
    seqArr.push(data.cart_seq);
    return (dispatch, getState) => {
        //购物车更新
        let updateCart = new UpdateCartDataRequest({
            //数量
            qty: qtyArr,
            //规格
            unit_code: unitArr,
            //购物车seq
            cart_seq: seqArr,
            //赠品编号
            gift_item_code: data.gift_item_code,
            //赠品规格
            gift_unit_code: data.gift_unit_code,
            //赠品购物车seq
            gift_cart_seq: data.gift_cart_seq,
        }, "POST");
        // console.log("购物车更新接口调用");
        updateCart.start(
            (response) => {
                if (response.message === 'succeed') {
                    let checkCart = new CheckCartDataRequest({
                        cart_seqs: data.selectShopArr
                    }, "POST");
                    // console.log("购物车选择接口调用");
                    checkCart.start(
                        (response) => {
                            if (response.message === 'succeed') {
                                if (chkDataExists(response)) {
                                    //接口请求成功
                                    successCallback({
                                        data: response.data,
                                        dataFlg: true,
                                    });
                                    //购物车列表展示
                                    dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                        type: actionTypes.UPDATECART,
                                        success: true
                                    }))
                                } else {
                                    //购物车同品推荐
                                    let getOtherItemsDataRequestg = new GetOtherItemsDataRequest(null, "GET");
                                    // console.log("同品推荐接口调用");
                                    getOtherItemsDataRequestg.start(
                                        (response) => {
                                            if (response.message === 'succeed') {
                                                //接口请求成功
                                                successCallback({
                                                    data: response.data,
                                                    dataFlg: false,
                                                });
                                                //空购物车展示
                                                dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                                    type: actionTypes.GETNCART,
                                                    success: true
                                                }))
                                            } else {
                                                failCallback({
                                                    error: response.message,
                                                    storeIndex: data.storeIndex,
                                                    shopIndex: data.shopIndex,
                                                    cartCnt: data.shopCnt
                                                }, response.code);
                                            }
                                        }, (error) => {
                                            failCallback({
                                                error: error.message,
                                                storeIndex: data.storeIndex,
                                                shopIndex: data.shopIndex,
                                                cartCnt: data.shopCnt
                                            }, error.code);
                                        });
                                }
                            } else {
                                failCallback({
                                    error: response.message,
                                    storeIndex: data.storeIndex,
                                    shopIndex: data.shopIndex,
                                    cartCnt: data.shopCnt
                                }, response.code);
                            }
                        }, (error) => {
                            failCallback({
                                error: error.message,
                                storeIndex: data.storeIndex,
                                shopIndex: data.shopIndex,
                                cartCnt: data.shopCnt
                            }, error.code);
                        });

                } else {
                    failCallback({
                        error: response.message,
                        storeIndex: data.storeIndex,
                        shopIndex: data.shopIndex,
                        cartCnt: data.shopCnt
                    }, response.code);
                }
            }, (error) => {
                failCallback({
                    error: error.message,
                    storeIndex: data.storeIndex,
                    shopIndex: data.shopIndex,
                    cartCnt: data.shopCnt
                }, error.code);
            });
    }
}
//删除购物车
export const deleteCart = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        //购物车数据删除
        let deleteCart = new DeleteCartRequest({
            cart_seqs: data.cart_seqs,
        }, "POST");
        // console.log("购物车删除接口调用");
        deleteCart.start(
            (response) => {
                if (response.message === 'succeed') {
                    // console.log("a===>"+data.selectShopArr)
                    let checkCart = new CheckCartDataRequest({
                        cart_seqs: data.selectShopArr
                    }, "POST");
                    // console.log("购物车选择接口调用");
                    checkCart.start(
                        (response) => {
                            if (response.message === 'succeed') {
                                if (chkDataExists(response)) {
                                    //接口请求成功
                                    successCallback({
                                        data: response.data,
                                        dataFlg: true,
                                    });
                                    //购物车列表展示
                                    dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                        type: actionTypes.DELETECART,
                                        success: true
                                    }))
                                } else {
                                    //购物车同品推荐
                                    let getOtherItemsDataRequestg = new GetOtherItemsDataRequest(null, "GET");
                                    // console.log("同品推荐接口调用");
                                    getOtherItemsDataRequestg.start(
                                        (response) => {
                                            if (response.message === 'succeed') {
                                                //接口请求成功
                                                successCallback({
                                                    data: response.data,
                                                    dataFlg: false,
                                                });
                                                //空购物车展示
                                                dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                                    type: actionTypes.GETNCART,
                                                    success: true
                                                }))
                                            } else {
                                                failCallback(response.message, response.code);
                                            }
                                        }, (error) => {
                                            failCallback(error.message, error.code);
                                        });
                                }
                            } else {
                                failCallback(response.message, response.code);
                            }
                        }, (error) => {
                            failCallback(error.message, error.code);
                        });

                } else {
                    failCallback(response.message, response.code);
                }
            }, (error) => {
                failCallback(error.message, error.code);
            });
    }
}
//同品推荐
export const getOtherItem = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        //购物车同品推荐
        let getOtherItemsDataRequestg = new GetOtherItemsDataRequest(null, "GET");
        //console.log("同品推荐接口调用");
        getOtherItemsDataRequestg.start(
            (response) => {
                if (response.message === 'succeed') {
                    //接口请求成功
                    successCallback({
                        data: response.data,
                        dataFlg: false,
                    });
                    //空购物车展示
                    dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                        type: actionTypes.GETNCART,
                        success: true
                    }))
                } else {
                    failCallback(response.message);
                }
            }, (error) => {
                failCallback(error);
            });
    }
}
//选择购物车商品接口
export const checkCart = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        let checkCart = new CheckCartDataRequest({
            cart_seqs: data.cart_seqs
        }, "POST");
        // console.log("购物车选择接口调用");
        checkCart.start(
            (response) => {
                if (response.message === 'succeed') {
                    if (chkDataExists(response)) {
                        //接口请求成功
                        successCallback({
                            data: response.data,
                            dataFlg: true,
                        });
                        //购物车列表展示
                        dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                            type: actionTypes.CHECKCART,
                            success: true
                        }))
                    } else {
                        //购物车同品推荐
                        let getOtherItemsDataRequestg = new GetOtherItemsDataRequest(null, "GET");
                        // console.log("同品推荐接口调用");
                        getOtherItemsDataRequestg.start(
                            (response) => {
                                if (response.message === 'succeed') {
                                    //接口请求成功
                                    successCallback({
                                        data: response.data,
                                        dataFlg: false,
                                    });
                                    //空购物车展示
                                    dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                        type: actionTypes.GETNCART,
                                        success: true
                                    }))
                                } else {
                                    failCallback(response.message, response.code);
                                }
                            }, (error) => {
                                failCallback(error.message, error.code);
                            });
                    }
                } else {
                    failCallback(response.message, response.code);
                }
            }, (error) => {
                failCallback(error.message, error.code);
            });
    }
}
//加入收藏夹
export const addFavorite = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        //加入收藏夹
        let addFavorite = new AddFavoriteDataRequest({
            seq_cart_nums: data.cart_seqs,
        }, "POST");
        // console.log("购物车移入收藏接口调用");
        addFavorite.start(
            (response) => {
                if (response.message === 'succeed') {
                    let checkCart = new CheckCartDataRequest({
                        cart_seqs: data.selectShopArr
                    }, "POST");
                    // console.log("购物车选择接口调用");
                    checkCart.start(
                        (response) => {
                            if (response.message === 'succeed') {
                                if (chkDataExists(response)) {
                                    //接口请求成功
                                    successCallback({
                                        data: response.data,
                                        dataFlg: true,
                                    });
                                    //购物车列表展示
                                    dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                        type: actionTypes.ADDFAVORITE,
                                        success: true
                                    }))
                                } else {
                                    //购物车同品推荐
                                    let getOtherItemsDataRequestg = new GetOtherItemsDataRequest(null, "GET");
                                    // console.log("同品推荐接口调用");
                                    getOtherItemsDataRequestg.start(
                                        (response) => {
                                            if (response.message === 'succeed') {
                                                //接口请求成功
                                                successCallback({
                                                    data: response.data,
                                                    dataFlg: false,
                                                });
                                                //空购物车展示
                                                dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                                                    type: actionTypes.GETNCART,
                                                    success: true
                                                }))
                                            } else {
                                                failCallback(response.message, response.code);
                                            }
                                        }, (error) => {
                                            failCallback(error.message, error.code);
                                        });
                                }
                            } else {
                                failCallback(response.message, response.code);
                            }
                        }, (error) => {
                            failCallback(error.message, error.code);
                        });

                } else {
                    failCallback(response.message, response.code);
                }
            }, (error) => {
                failCallback(error.message, error.code);
            });
    }
}
//去结算
export const goToAccount = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        //去结算
        let goToAccount = new CheckUseEmpDiscountDataRequest({
            cartSeqs: data.cartSeqs,
        }, "GET");
        // console.log("购物车去结算接口调用");
        goToAccount.start(
            (response) => {
                if (response.message === 'succeed') {
                    //接口请求成功
                    successCallback({
                        data: response.data,
                    });

                } else {
                    failCallback(response.message, response.code);
                }
            }, (error) => {
                failCallback(error.message, error.code);
            });
    }
}
//购物车查看折扣券
export const getCouponDetailClick = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        //去结算
        let getItemsCoupons = new GetItemsCoupons({
            item_codes: data.item_codes,
        }, "POST");
        // console.log("购物车查看折扣券");
        getItemsCoupons.start(
            (response) => {
                if (response.message === 'succeed') {
                    //接口请求成功
                    successCallback({
                        data: response.data,
                    });

                } else {
                    failCallback(response.message, response.code);
                }
            }, (error) => {
                failCallback(error.message, error.code);
            });
    }
}
//获取购物车数量
export const getCartNumber = (data) => {
    return (dispatch, getState) => {
        Encry.getCartNumber(data, (result) => {
            dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                type: actionTypes.GETCARTNUMBER,
                result: {
                    ...result
                },
                success: true
            }))
        }, (error) => {
            dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                type: actionTypes.GETCARTNUMBER,
                result: error,
                success: true
            }))
        });
    }
}
//根据购物车商品计算价格
export const CalculatePriceCommodities = (data) => {
    return (dispatch, getState) => {
        Encry.CalculatePriceCommodities(data, (result) => {
            dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                type: actionTypes.CALCULATEPRICECOMMODITIES,
                result: {
                    ...result
                },
                success: true
            }))
        }, (error) => {
            dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
                type: actionTypes.CALCULATEPRICECOMMODITIES,
                result: error,
                success: true
            }))
        });
    }
}
//获取折扣券列表
export const getDiscountCoupon = (data) => {
    return (dispatch, getState) => {
        dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
            type: actionTypes.DISCOUNTCOUPON,
            result: 'test',
            success: true
        }))
    }
}
//关闭折扣券列表
export const closeDiscountCoupon = () => {
    return (dispatch, getState) => {
        dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
            type: actionTypes.DISCOUNTCOUPON_ClOSE,
            result: 'test',
            success: true
        }))
    }
}
//获取赠品列表
export const getGiftData = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        //获取赠品列表
        let getGiftData = new GetItemActivitiesDataRequest(null, "GET");
        getGiftData.requestUrl = () => {
            return "/api/events/activitys/get_item_events/" + data.item_code + "/";
        }
        // console.log("购物车获取赠品接口调用");
        getGiftData.start(
            (response) => {
                if (response.message === 'succeed') {
                    //接口请求成功
                    successCallback({
                        data: response.data,
                        dataFlg: true,
                    });
                } else {
                    failCallback(response.message, response.code);
                }
            }, (error) => {
                failCallback(error.message, error.code);
            });
    }
}
//获取规格情报
export const getCommercialSpecification = (data, successCallback, failCallback) => {
    return (dispatch, getState) => {
        //获取规格情报
        let getCommercialSpecification = new GetInitcolorsizeDataRequest({
            IsNewSingle: data.IsNewSingle,
            item_code: data.item_code,
        }, "GET");
        // console.log("购物车获取规格接口调用");
        getCommercialSpecification.start(
            (response) => {
                if (response.message === 'succeed') {
                    successCallback({
                        data: response.data,
                    });
                } else {
                    failCallback(response.message, response.code);
                }
            }, (error) => {
                failCallback(error.message, error.code);
            });
    }
}
//关闭规格Dialog
export const closeDialog = (type, data) => {
    return (dispatch, getState) => {
        dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
            type: actionTypes.CLOSE_DIALOG,
            result: data,
            success: true
        }))
    }
}
// 关闭/打开可换赠品列表
export const openGiftItems = (type, data) => {
    return (dispatch, getState) => {
        dispatch(fetchDataCreate(actionTypes.FetchDataAction, {
            type: actionTypes.OPEN_GIFT_DIALOG,
            result: data,
            closeOrOpen: data.openFlg,
            success: true
        }))
    }
}

export const chkDataExists = (response) => {
    let chkResult = false;
    if (response.data !== null
        && response.data.shop !== null
        && response.data.shop.length > 0) {
        chkResult = true;
    }
    return chkResult;
}
