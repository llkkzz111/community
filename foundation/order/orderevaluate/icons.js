/**
 * Created by Administrator on 2017/5/12.
 */
import React,{} from 'react';
import Icon from 'react-native-vector-icons/FontAwesome';
//这里使用了FontAwesome的字体库显示图片，请参考该组件的使用
export default icons = (params)=> <Icon name={params.name} style={[{color: '#FFDF99'}, params.style]} />;