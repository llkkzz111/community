/**
 * Created by Administrator on 2017/6/11.
 */
//搜索筛选页面单个筛选ITEM

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


export default class LabelText extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            selected:this.props.selected,
        };
        this.labelClick = this.labelClick.bind(this);
    }

    labelClick(){
        this.props.labelClick();
        this.setState({
            selected: !this.state.selected,
        });
    }

    componentWillReceiveProps(nextProps){
        this.setState({
            selected: nextProps.selected,
        });
    }

    componentWillMount() {

    }

    componentDidMount() {

    }


    render() {
        let { labelText } = this.props;
        return (
            <View>
                {
                    this.state.selected ?
                        <TouchableOpacity activeOpacity={1} onPress={()=>{this.labelClick()}}>
                            <View style={styles.itemStyleSelect}>
                                <Text numberOfLines={1} style={styles.itemStyleSelectText} allowFontScaling={false}>{labelText}</Text>
                            </View>
                            <Image source={require('../Img/searchpage/Icon_label_@3x.png')} style={styles.imgStyle}/>
                        </TouchableOpacity>
                        :
                        <TouchableOpacity activeOpacity={1} onPress={()=>{this.labelClick()}}>
                            <View style={styles.itemStyleNormal}>
                                <Text numberOfLines={1} style={styles.itemStyleNormalText} allowFontScaling={false}>{labelText}</Text>
                            </View>
                        </TouchableOpacity>
                }
            </View>
        )
    }


}

LabelText.propTypes = {
    labelText: React.PropTypes.string.isRequired,
    //labelClick: React.PropTypes.func.isRequired,

};

LabelText.defaultProps = {};


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
