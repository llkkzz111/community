/**
* @file 分流
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
import ScrollPageRedux, {scrollPage, getScrollPage} from './ScrollPageRedux';
import ScrollPageAction from './ScrollPageAction';

export const Action = ScrollPageAction;

export const selector = {
    scrollPage,
    getScrollPage
};

export default {
    ScrollPage: ScrollPageRedux
};
