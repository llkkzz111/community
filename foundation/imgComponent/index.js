/**
 * @file 分流
 * @author 魏毅
 * @version 0.0.1
 * @license 东方购物 2017
 * @see {@link weiyi@ocj.com.cn}
 */
import {
  Platform
} from 'react-native';
import ImgIos from './ios';
import ImgAndroid from './android';

export default Platform.OS === 'ios' ? ImgIos : ImgAndroid;
