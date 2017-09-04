import React, { Component } from 'react';
import {
    Platform,
    ToastAndroid,
    View,
    DeviceEventEmitter,
    Dimensions,
    StyleSheet
} from 'react-native';
import {
    Reducer,
    Actions,
    ActionConst
} from 'react-native-router-flux';
import RButton from 'react-native-button';
import { connect } from 'react-redux';
import { getAppHeight }from '../foundation/common/NavigationBar';
import * as routeConfig from './config/routeConfig';
import LoadingDialog2 from '../foundation/dialog/LoadingDialog2';
import * as act from './actions/dialogaction/DialogAction';
import RnConnect from './config/rnConnect';
import routeByUrl from './components/homepage/RoutePageByUrl';
// 广告页面组件
import AdvertisementPage from './components/homepage/AdvertisementPage';
//回退
import * as RouteManager from './config/PlatformRouteManager';
//路由
import { Router } from './router';

// 设置编辑很完成按钮，默认为false
let fucManageState = false;
// 记录当前的Scene，只能push后能有效记录
let currentScene = {};
let i = false;
let currentTitle = undefined;
const intervalTimer = 2 * 60 * 1000;
let lastTimer = 0; // 上次进入首页的时间
RnConnect.showSign();//默认显示鸟

const reducerCreate = params => {
    const defaultReducer = new Reducer(params);
    return (state, action) => {
        if (action.key) {
            currentTitle = action.key
        }
        if ((action.scene && action.scene.sceneKey && action.scene.title)) {
            currentTitle = action.scene.title
        }
        if (currentTitle === '主页' || currentTitle === 'JumpTo') {
            if (lastTimer !== 0) {
                let currentTimer = new Date().getTime();
                if (currentTimer - lastTimer > intervalTimer) {
                    DeviceEventEmitter.emit("HomePageRefresh");
                    lastTimer = new Date().getTime();
                }
            } else {
                lastTimer = new Date().getTime();
            }
        } else {
        }

        switch (action.key) {
            case 'JumpTo'://首页
                DeviceEventEmitter.emit("SHOW_HOMEPAGE_VIEW");
                DeviceEventEmitter.emit("refreshhomestatus");
                RnConnect.showSign();
                if (i) {
                    DeviceEventEmitter.emit("scrollTop");
                }
                i = true;
                break;
            case routeConfig.Indexocj_Classification://分类
                DeviceEventEmitter.emit("refreshClassificationStatus");
                RnConnect.hideSign();
                i = false;
                break;
            case routeConfig.Tabocj_Shopping://看直播
                RnConnect.hideSign();
                DeviceEventEmitter.emit("refreshVideoStatus");
                i = false;
                break;
            case routeConfig.Tabocj_Cart://购物车
                DeviceEventEmitter.emit("refreshCartData");
                RnConnect.hideSign();
                i = false;
                break;
            case routeConfig.Tabocj_MePage://个人中心
                Actions.refresh();
                DeviceEventEmitter.emit("refreshApp", {type: 'checkMePage'});
                RnConnect.hideSign();
                i = false;
                break;
            case undefined://每一个Action调用多次
                if (action.scene !== undefined
                    && action.scene.sceneKey === 'Home') {//首页子页面回退首页条件判断
                    DeviceEventEmitter.emit("refreshhomestatus");
                    RnConnect.showSign();
                } else if (action.refresh !== undefined
                    && action.refresh.cartGoodCount !== undefined
                    && ActionConst.BACK_ACTION === action.type) {//购物车回退首页条件判断
                    RnConnect.showSign();
                }
                break;
            case 'Indexocj_Tab'://重新跳到首页  调用次数很多
                Actions.refresh();
                // DeviceEventEmitter.emit("jumpkey");
                break;
            default://非一级页面都隐藏签到和意见反馈
                RnConnect.hideSign();
                break;
        }
        //这种方法还算可靠,必须是从其他界面跳转到该界面才会设置,initial的login界面,那时的currentScene为'modal'
        if (action.type === ActionConst.FOCUS) {
            let scene = action.scene;
            this.currentScene = scene.sceneKey;
        }
        //当个人中心子页面按返回的时候，刷新订单
        if ((this.currentScene === routeConfig.MePage) && action.type !== ActionConst.PUSH) {
            DeviceEventEmitter.emit('refreshOrderCenter1');
        }
        return defaultReducer(state, action);
    };
};

const exitAppFn = params => {
    if (this.lastBackPressed && this.lastBackPressed + 2000 >= Date.now()) {
        //最近2秒内按过back键，可以退出应用。
        return false;
    }
    this.lastBackPressed = Date.now();
    ToastAndroid.show('再按一次退出应用', ToastAndroid.SHORT);
    return true;
};

//重写了backAndroidHandler,exitAppFn就是无效的了
const backAndroidHandler = params => {
    try {
        switch (this.currentScene) {
            case 'JumpTo':
                return true;
                break;
            case 'func_manage':
                fucManageState = false;
                params.finishManageState && params.finishManageState();
                break;
            case 'login':
                throw Error();
                break;
            case 'cartFromGoodsDetail'://监听购物车到商品详情
                DeviceEventEmitter.emit('RFRESHGOODDETAILS');
                break;
            case 'GoodsDetailMain'://截获商品详情物理回退键事件
                RouteManager.routeBack();
                return true;
                break;
            default:
                break;
        }
        //如果是根页面,会抛出异常的
        Actions.pop();
        return true;
    } catch (err) {
        //根据返回的值来判断是否退出程序
        //返回false表示退出程序,true表示不退出
        if (exitAppFn) {
            return exitAppFn({});
        }
        return false;
    }
};

// define this based on the styles/dimensions you use
const getSceneStyle = (/* NavigationSceneRendererProps */ props, computedProps) => {
    const style = {
        flex: 1,
        backgroundColor: '#fff',
        shadowColor: null,
        shadowOffset: null,
        shadowOpacity: null,
        shadowRadius: null,
    };
    if (computedProps.isActive) {
        style.marginTop = computedProps.hideNavBar ? (Platform.OS === 'android' ? 0 : 20) : (Platform.OS === 'android' ? 54 : 64);
        style.marginBottom = computedProps.hideTabBar ? 0 : 50;
    }
    return style;
};

const videoTab = props => {
    return (
        <RButton style={styles.allVideoStyle} onPress={() => Actions.allVideoListPage({})}>{'全部视频＞'}</RButton>
    )
}

const menu = (
    <RButton>
        {'菜单'}
    </RButton>
);

// root根组件
@connect(state => ({
    cartType: state.CartReducer,
    dialogState: state.DialogReducer
}), dispatch => ({
    showLoadingAction: () => dispatch(act.showLoading())
}))
export default class App extends Component {
    componentDidMount() {
        DeviceEventEmitter.addListener('huojian', (is) => {
            i = is;
        });
    }
    render() {
        //将App数据管理纳入redux，提取action及props纲入数据流管理
        let {dialogState, showLoadingAction} = this.props;
        return (
            //router是最父组件包裹所有的组件
            <View style={{height: getAppHeight()}}>
                <Router
                    backAndroidHandler={backAndroidHandler}
                    reducerCreate={reducerCreate}
                    getSceneStyle={getSceneStyle}
                    videoTab={videoTab}
                    menu={menu}
                />
                {dialogState.showLoading && (
                    <LoadingDialog2
                        canCancled={true}
                    />
                )}
                {/*广告页*/}
                <AdvertisementPage jumpToWebView={(url)=>{
                    routeByUrl(url);
                }}/>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    allVideoStyle: {
        fontSize: 16,
        color: '#FFFFFF'
    }
});
