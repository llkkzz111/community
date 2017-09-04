/**
 * Created by zhenzhen on 2017/8/10.
 */
import {DataAnalyticsModule} from '../../config/AndroidModules';

const PAGES = {
    ALL: 0,
    NO_PAY: 1,
    NO_SEND: 2,
    SENDING: 3,
    COMMENT: 4,
    EXCHANGE: 5,
    APPOINTMENT: 6,
}
/**
 *返回键
 */
export function backPress(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C020D003001C003001');
                break;
            case PAGES.NO_PAY:
                DataAnalyticsModule.trackEvent('AP1706C021D003001C003001');
                break;
            case PAGES.NO_SEND:
                DataAnalyticsModule.trackEvent('AP1706C022D003001C003001');
                break;
            case PAGES.SENDING:
                DataAnalyticsModule.trackEvent('AP1706C023D003001C003001');
                break;
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C024D003001C003001');
                break;
            case PAGES.APPOINTMENT:
                DataAnalyticsModule.trackEvent('AP1706C025D003001C003001');
                break;
            case PAGES.EXCHANGE:
                DataAnalyticsModule.trackEvent('AP1706C026D003001C003001');
                break;
        }
    } catch (erro) {
    }
}
/**
 * 点击tab的时候
 * @param currPage
 */
export function onTabClick(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C020C006001I004001');
                break;
            case PAGES.NO_PAY:
                DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
                break;
            case PAGES.NO_SEND:
                DataAnalyticsModule.trackEvent('AP1706C020C006001I004003');
                break;
            case PAGES.SENDING:
                DataAnalyticsModule.trackEvent('AP1706C020C006001I004004');
                break;
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C020C006001I004005');
                break;
            case PAGES.EXCHANGE:
                DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
                break;
        }
    } catch (erro) {
    }
}
/**
 * 共几件点击
 * @param currPage
 */
export function onTotalClick(currPage, count) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent3('AP1706C020F010001A001001', '', {itemnum: '' + count});
                break;
            case PAGES.NO_PAY:
                DataAnalyticsModule.trackEvent3('AP1706C021F010001A001001', '', {itemnum: '' + count});
                break;
            // case PAGES.NO_SEND:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004003');
            //     break;
            // case PAGES.SENDING:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004004');
            //     break;
            // case PAGES.COMMENT:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004005');
            //     break;
            case PAGES.EXCHANGE:
                DataAnalyticsModule.trackEvent('AP1706C026F010001A001001');
                break;
            default:
                DataAnalyticsModule.trackEvent3('AP1706C020F010001A001001', '', {itemnum: '' + count});
                break;
        }
    } catch (erro) {
    }
}
/**
 * 立即付款
 */
export function goPay(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C020F008001O008001');
                break;
            case PAGES.NO_PAY:
                DataAnalyticsModule.trackEvent('AP1706C021F008001O008001');
                break;
            // case PAGES.NO_SEND:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004003');
            //     break;
            // case PAGES.SENDING:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004004');
            //     break;
            // case PAGES.COMMENT:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004005');
            //     break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
            default:
                DataAnalyticsModule.trackEvent('AP1706C020F008001O008001');
                break;
        }
    } catch (erro) {
    }
}

/**
 * 查看物流
 */
export function checkOrderLogistics(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C020F012001O006001');
                break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            // case PAGES.NO_SEND:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004003');
            //     break;
            case PAGES.SENDING:
                DataAnalyticsModule.trackEvent('AP1706C023F012001O006001');
                break;
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C024F012001O006002');
                break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 确认收货
 */
export function confirmDeliver(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C020F012001O006002');
                break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            // case PAGES.NO_SEND:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004003');
            //     break;
            // case PAGES.SENDING:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004004');
            //     break;
            // case PAGES.COMMENT:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004005');
            //     break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 查看发票
 */
export function viewFaPiao(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C020F012002O006001');
                break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            // case PAGES.NO_SEND:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004003');
            //     break;
            // case PAGES.SENDING:
            //     DataAnalyticsModule.trackEvent('AP1706C020F012002O006001');
            //     break;
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C024F012001O006001');
                break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 去评价
 */
export function goComment(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C020F012002O006003');
                break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            // case PAGES.NO_SEND:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004003');
            //     break;
            // case PAGES.SENDING:
            //     DataAnalyticsModule.trackEvent('AP1706C020F012002O006001');
            //     break;
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C024F012001O006003');
                break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 退换货详情
 */
export function exchangeDetails(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C026F008001O008001');
                break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            // case PAGES.NO_SEND:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004003');
            //     break;
            // case PAGES.SENDING:
            //     DataAnalyticsModule.trackEvent('AP1706C020F012002O006001');
            //     break;
            // case PAGES.COMMENT:
            //     DataAnalyticsModule.trackEvent('AP1706C024F012001O006003');
            //     break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
            default:
                DataAnalyticsModule.trackEvent('AP1706C026F008001O008001');
                break;
        }
    } catch (erro) {
    }
}
/**
 * 订单详情返回键
 */
export function detailsBackPress(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C027D003001C003001');
                break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            case PAGES.NO_SEND:
                DataAnalyticsModule.trackEvent('AP1706C029D003001C003001');
                break;
            case PAGES.SENDING:
                DataAnalyticsModule.trackEvent('AP1706C028D003001C003001');
                break;
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C030D003001C003001');
                break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
            // default:
            //     DataAnalyticsModule.trackEvent('AP1706C026F008001O008001');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情联系客服
 */
export function connectService(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C027F010001A001001');
                break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            case PAGES.NO_SEND:
                DataAnalyticsModule.trackEvent('AP1706C029D003002C003001');
                break;
            case PAGES.SENDING:
                DataAnalyticsModule.trackEvent('AP1706C028F010001A001001');
                break;
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C030D003002C003001');
                break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
            // default:
            //     DataAnalyticsModule.trackEvent('AP1706C026F008001O008001');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情取消订单
 */
export function cancelOrder(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C027F012001O006001');
                break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            case PAGES.NO_SEND:
                DataAnalyticsModule.trackEvent('AP1706C029F008001O008001');
                break;
            // case PAGES.SENDING:
            //     DataAnalyticsModule.trackEvent('AP1706C020F012002O006001');
            //     break;
            // case PAGES.COMMENT:
            //     DataAnalyticsModule.trackEvent('AP1706C024F012001O006003');
            //     break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
            // default:
            //     DataAnalyticsModule.trackEvent('AP1706C026F008001O008001');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情立即付款
 */
export function detailsGoPay(currPage) {
    try {
        switch (currPage) {
            case PAGES.ALL:
                DataAnalyticsModule.trackEvent('AP1706C027F012001O006002');
                break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            // case PAGES.NO_SEND:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004003');
            //     break;
            // case PAGES.SENDING:
            //     DataAnalyticsModule.trackEvent('AP1706C020F012002O006001');
            //     break;
            // case PAGES.COMMENT:
            //     DataAnalyticsModule.trackEvent('AP1706C024F012001O006003');
            //     break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
            // default:
            //     DataAnalyticsModule.trackEvent('AP1706C026F008001O008001');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情查看还有几件
 */
export function detailsLookMore(currPage) {
    try {
        switch (currPage) {
            // case PAGES.ALL:
            //     DataAnalyticsModule.trackEvent('AP1706C027F012001O006002');
            //     break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            case PAGES.NO_SEND:
                DataAnalyticsModule.trackEvent('AP1706C029D010001C010001');
                break;
            // case PAGES.SENDING:
            //     DataAnalyticsModule.trackEvent('AP1706C020F012002O006001');
            //     break;
            // case PAGES.COMMENT:
            //     DataAnalyticsModule.trackEvent('AP1706C024F012001O006003');
            //     break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
            // default:
            //     DataAnalyticsModule.trackEvent('AP1706C026F008001O008001');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情查看物流
 */
export function detailsLookLogistis(currPage) {
    try {
        switch (currPage) {
            // case PAGES.ALL:
            //     DataAnalyticsModule.trackEvent('AP1706C027F012001O006002');
            //     break;
            // case PAGES.NO_PAY:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004002');
            //     break;
            // case PAGES.NO_SEND:
            //     DataAnalyticsModule.trackEvent('AP1706C029D010001C010001');
            //     break;
            case PAGES.SENDING:
                DataAnalyticsModule.trackEvent('AP1706C028F012001O006001');
                break;
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C030F012004O006002');
                break;
            // case PAGES.EXCHANGE:
            //     DataAnalyticsModule.trackEvent('AP1706C020C006001I004006');
            //     break;
            // default:
            //     DataAnalyticsModule.trackEvent('AP1706C026F008001O008001');
            //     break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情整单退货
 */
export function detailsAllReturn(currPage) {
    try {
        switch (currPage) {
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C030F012001O006001');
                break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情申请退货
 */
export function applyReturn(currPage) {
    try {
        switch (currPage) {
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C030F012002O006001');
                break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情申请换货
 */
export function applyExchange(currPage) {
    try {
        switch (currPage) {
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C030F012003O006002');
                break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情申请安装
 */
export function applyInstall(currPage) {
    try {
        switch (currPage) {
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C030F012003O006003');
                break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情评价
 */
export function detailsComment(currPage) {
    try {
        switch (currPage) {
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C030F012004O006003');
                break;
        }
    } catch (erro) {
    }
}
/**
 * 商品详情查看发票
 */
export function detailsGoFaPiao(currPage) {
    try {
        switch (currPage) {
            case PAGES.COMMENT:
                DataAnalyticsModule.trackEvent('AP1706C030F012004O006001');
                break;
        }
    } catch (erro) {
    }
}