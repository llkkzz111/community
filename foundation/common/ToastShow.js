/**
 * Created by wangwenliang on 2017/6/14.
 */
import Toast from 'react-native-root-toast';

functionUtils = {
    // log:(logMessage) => { console.log(logMessage);},
    toast:(message) => {
        let toast = Toast.show(message, {
            duration: 1000, // toast显示时长
            position: Toast.positions.CENTER, // toast位置
            shadow: true, // toast是否出现阴影
            animation: true, // toast显示/隐藏的时候是否需要使用动画过渡
            hideOnPress: true, // 是否可以通过点击事件对toast进行隐藏
            delay: 0, // toast显示的延时
            onShow: () => {
                // toast出现回调（动画开始时）
            },
            onShown: () => {
                // toast出现回调（动画结束时）
            },
            onHide: () => {
                // toast隐藏回调（动画开始时）
            },
            onHidden: () => {
                // toast隐藏回调（动画结束时）
            }
        });
    }

}
export default functionUtils;