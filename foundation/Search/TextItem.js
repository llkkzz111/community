/**
 * Created by Administrator on 2017/6/8.
 */
//搜索筛选页面单个品牌ITEM

import React from 'react';
import {
    StyleSheet,
    Text,
    TouchableOpacity,
    Image,
    View,
} from 'react-native';

import Colors from '../../app/config/colors';
import * as ScreenUtil from '../utils/ScreenUtil';


export default class TextItem extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
           selected:this.props.selected,
        };
        this.textClick = this.textClick.bind(this);
    }

    componentWillReceiveProps(nextProps){
        this.setState({
            selected: nextProps.selected,
        });
    }

    textClick(id,text){
        //品牌点击
       if (this.props.textClick(id,text)) {
            this.setState({
                selected: !this.state.selected,
            });
        }
    }

    componentWillMount() {

    }

    componentDidMount() {

    }


    render() {
        let { itemText } = this.props;
        return (
           <View>
            {
                this.state.selected ?
                <TouchableOpacity
                    style={{alignItems:"center",justifyContent:"center"}}
                    activeOpacity={1} onPress={()=>{this.textClick(itemText.propertyName,itemText.propertyValue)}}>
                    <View style={styles.itemStyleSelect}>
                        <Text numberOfLines={1} style={styles.itemStyleSelectText} allowFontScaling={false}>{itemText.propertyValue}</Text>
                    </View>
                    <Image source={require('../Img/searchpage/Icon_label_@3x.png')} style={styles.imgStyle}/>
                </TouchableOpacity>
                :
                <TouchableOpacity
                    style={{alignItems:"center",justifyContent:"center"}}
                    activeOpacity={1} onPress={()=>{this.textClick(itemText.propertyName,itemText.propertyValue)}}>
                    <View style={styles.itemStyleNormal}>
                        <Text numberOfLines={1} style={styles.itemStyleNormalText} allowFontScaling={false}>{itemText.propertyValue}</Text>
                    </View>
                </TouchableOpacity>
            }
           </View>
        )
    }


}

TextItem.propTypes = {
    itemText: React.PropTypes.object.isRequired,
    textClick: React.PropTypes.func.isRequired,

};

TextItem.defaultProps = {};


const styles = StyleSheet.create({
    itemStyleNormal: {
        textAlign: 'center',
        width:ScreenUtil.scaleSize(184),
        height:ScreenUtil.scaleSize(56),
        marginRight:ScreenUtil.scaleSize(16),
        marginTop:ScreenUtil.scaleSize(20),
        marginBottom:ScreenUtil.scaleSize(10),
        borderRadius: ScreenUtil.scaleSize(10),
        backgroundColor: Colors.line_grey,
        paddingTop:ScreenUtil.scaleSize(12),
    },
    itemStyleNormalText:{
        fontSize: ScreenUtil.setSpText(24),
        color: Colors.text_black,
        textAlign:'center',
    },
    itemStyleSelect:{
        textAlign: 'center',
        width:ScreenUtil.scaleSize(184),
        height:ScreenUtil.scaleSize(56),
        marginRight:ScreenUtil.scaleSize(16),
        marginTop:ScreenUtil.scaleSize(20),
        marginBottom:ScreenUtil.scaleSize(10),
        borderRadius: ScreenUtil.scaleSize(10),
        backgroundColor: '#FFEBE8',
        //textAlignVertical:'center'
        paddingTop:ScreenUtil.scaleSize(12),
    },
    itemStyleSelectText:{
        fontSize: ScreenUtil.setSpText(24),
        color: '#F31918',
        textAlign:'center',
    },

    imgStyle:{
        width:ScreenUtil.scaleSize(30),
        height:ScreenUtil.scaleSize(30),
        position:'absolute',
        right:ScreenUtil.scaleSize(18),
        bottom:ScreenUtil.scaleSize(10),

    }

});
