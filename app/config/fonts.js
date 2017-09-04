/**
 * Created by wJJ on 17/5/17.
 */

import {Platform}from 'react-native';
import Global from './global'
import * as Util from '../../foundation/utils/ScreenUtil';
export default class Fonts {
    // iOS android 字体偏差纠正
    // Global.type 设置字体时需要修正的步长
    // Util 根据屏幕大小自动调节字体大小（例如5s）
    static platformStep = Platform.OS === 'ios' ? 0:0;

    static page_title_font() {
        return Util.setSpText((17 + this.platformStep)*2);
    }

    static standard_title_font() {
        return Util.setSpText((15 + this.platformStep)*2);
    }

    static page_normal_font() {
        return Util.setSpText((16 + this.platformStep)*2);
    }

    static standard_normal_font() {
        return Util.setSpText((14 + this.platformStep)*2);
    }

    static secondary_font() {
        return Util.setSpText((12 + this.platformStep)*2);
    }
    static tag_font() {
        return Util.setSpText((11 + this.platformStep)*2);
    }
}