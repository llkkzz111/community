/**
* @file fetch请求中间件
* @author 魏毅
* @version 0.0.1
* @license 东方购物 2017
* @see {@link weiyi@ocj.com.cn}
**/
export default (store: Object) => (next: Object) => (action: Object) => {
    if (action.url && Object.prototype.toString.call(action.types).toLowerCase() === '[object array]') {
        (async function(store, next, action) {
            try {
                // 请求
                const pro = await fetch(action.url);
                // 触发成功的dispatch
                store.dispatch({
                    type: types[0],
                    data: pro
                });
            } catch(e) {
                // 触发失败的dispatch
                store.dispatch({
                    type: types[1],
                    data: e
                });
            }
        })(store, next, action);
    } else {
        return next(action);
    }
};
