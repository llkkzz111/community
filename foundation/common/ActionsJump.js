/**
 * Created by 卓原 on 2017/6/22.
 *
 */
import {
    Actions,
    RouteManager,
    routeConfig,
} from '../../app/config/UtilComponent'

export function actionsJump(obj) {
    switch (obj.title) {
        case '商城':
            Actions.HomeStore();
            break;
        case '团购':
            Actions.Group({destinationUrl: obj.destinationUrl});
            break;
        case 'vip':
            RouteManager.routeJump({
                page: routeConfig.VIP,
                fromRNPage: routeConfig.Home,
            });
            break;
        case '全球购':
            RouteManager.routeJump({
                fromRNPage: routeConfig.Home,
                targetNativePage: routeConfig.Global,
                page: routeConfig.Global
            });
            break;
        case '热销榜':
            Actions.HomeHotSale();
            break;
        case '抢红包':
            RouteManager.routeJump({
                page: routeConfig.Red,
                fromRNPage: routeConfig.Home,
            });
            break;
        default:
            break;
    }

}
