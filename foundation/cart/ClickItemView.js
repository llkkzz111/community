/**
 * Created by wangwenliang on 2017/4/28.
 */
import React, { Component,PropTypes } from 'react';
import {
    Alert,
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image
} from 'react-native';

const Dimensions = require('Dimensions');
const screenWidth = Dimensions.get('window').width;

export default class ClickItemView extends Component {
    constructor(props){
        super(props);
    }

    //左侧图标，可选
    _renderLeftViewImage(){
        return(
            <Image style={styles.leftImageStyle} source={{uri:this.props.leftImageUri}} resizeMode={'contain'} />
        );
    }
    //左侧文字，可选
    _renderLeftText () {
        return(
            <Text style={[styles.leftTextStyle, {marginLeft:this.props.leftText ? 5 : 0 }]} allowFontScaling={false}>
                {this.props.leftText ? this.props.leftText : " "}
                </Text>
        );
    }

    //右侧文字，可选
    _renderRightText(){
        return(
            <Text style={[styles.rightTextStyle,{marginRight:this.props.noRightImage ? 0 : 5 }]} allowFontScaling={false}>{this.props.rightText}</Text>
        );
    }

    //中间文字，可选
    _renderMiddleText(){
        return(
            <Text style={styles.middleTextStyle} allowFontScaling={false}>{this.props.middleText}</Text>
        );
    }
    // 中间moulde，可选
    _renderMiddleMoule(){
        return(
          this.props.children
        );
    }
    //先判断传进来的是moudle还是简单的text，然后再渲染
    _renderMiddleMouldOrText(){
        // this.props.isMoudle ? this._renderMiddleMoule() : this._renderMiddleText();
        return(
            this.props.isMoudle ? this._renderMiddleMoule() : this._renderMiddleText()
        );
    }

    _renderRightImage(){
        return(
            <Image style={styles.rightImageStyle} source={require('../Img/arrow_right.png')}/>
        );
    }

    // _renderRightView(){
    //     return(
    //     {this.props.rightText && this._renderRightText()}
    //
    //     );
    // }

    _renderView(){
        return(
          <View style={{width:1,height:1}}/>
        );
    }

    render(){
        return(
            <TouchableOpacity activeOpacity={1} onPress={() => Alert.alert("来自条目的点击事件")} style={styles.container}>

                <View style={styles.leftViewStyle}>
                    {this.props.leftImageUri && this._renderLeftViewImage()}
                    {this.props.leftText ? this._renderLeftText() : this._renderView()}
                </View>

                <View style={styles.middleViewStyle}>
                    {this._renderMiddleMouldOrText()}
                    {/*{this._renderMiddleText()}*/}
                </View>

                <View style={styles.rightViewStyle}>
                    {this.props.rightText && this._renderRightText()}
                    {this.props.noRightImage ? this._renderView() : this._renderRightImage()}
                </View>

            </TouchableOpacity>
        );
    }
}

const styles = StyleSheet.create({
    container:{
        flexDirection:'row',
        justifyContent:'space-between',
        alignItems:'center',
        backgroundColor:'#fff',
        height:50,
        width:screenWidth
    },
    leftViewStyle:{
        flexDirection:'row',
        alignItems:'center',
        marginLeft:10,
    },
    rightViewStyle:{
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'flex-end',
        marginRight:10
    },
    middleViewStyle:{
        flexDirection:'row',
        justifyContent:'center',
        alignItems:'center',
    },
    middleTextStyle:{
        textAlign:'center',
    },
    leftImageStyle:{
        width:40,
        height:40,
    },
    leftTextStyle:{
        textAlign:'center',
        marginLeft:5,
    },
    rightImageStyle:{
        width:40,
        height:40,
    },
    rightTextStyle:{
        textAlign:'center',
        marginRight:5,
    }

});

//组件引用说明
ClickItemView.propTypes={
    leftImageUri:PropTypes.string, //左侧图片uri
    leftText:PropTypes.string, //左侧文字
    middleText:PropTypes.string, //中间文字
    rightText:PropTypes.string, //右侧文字
    isMoudle:PropTypes.bool, //右侧文字
    noRightImage:PropTypes.bool, //右侧文字
    moudle:PropTypes.func, //右侧文字
}