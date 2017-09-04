/**
 * Created by Administrator on 2017/5/7.
 */

import React, { Component,PropTypes } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Image
} from 'react-native';
import { Actions } from 'react-native-router-flux';
// 适屏
import * as ScreenUtils from '../utils/ScreenUtil';
import * as routeConfig from '../../app/config/routeConfig'
import RnConnect from '../../app/config/rnConnect';
import Immutable from 'immutable'
import * as RouteManager from '../../app/config/PlatformRouteManager';
import {DataAnalyticsModule} from '../../app/config/AndroidModules';
export default class PersonalComment extends Component {
    constructor(props) {
        super(props);
        this.state={
            pgetlist:this.props.pgetlist,
            plInfoImge:"",
            plInfoName:"",

            order_no:"",
            order_type:"",

        }
    }

    componentWillReceiveProps(nextProps) {
        this.setState({
            pgetlist:nextProps.pgetlist
        });
    }

    shouldComponentUpdate(nextProps,nextState){
        return !Immutable.is(this.props.pgetlist,nextProps.pgetlist);
    }

    render() {
            let plInfoImge = this.state.pgetlist[0].items[0].contentImage ;
            this.state.plInfoName = this.state.pgetlist[0].items[0].item_name ;
            this.state.order_no =  this.state.pgetlist[0].items[0].order_no ;
            this.state.order_type =  this.state.pgetlist[0].items[0].order_type ;

            return(
                <View style={styles.plBoxStyle}>
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => {
                            DataAnalyticsModule.trackEvent3('AP1706C019D010002C010001', "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                            Actions.OrderCenter({'pageId':4,"actState":"preorder"});
                        }}
                        style={styles.plTopStyle}
                    >
                        <View style={styles.plTopStyleLeft}>
                            <Text allowFontScaling={false} style={styles.pnxiemStyle}>写点评送鸥点</Text>
                            <Text allowFontScaling={false} style={styles.mfitninfo}>有20点等你去领喔~</Text>
                        </View>
                        <Text allowFontScaling={false} style={styles.pogoto}> > </Text>
                    </TouchableOpacity>

                    <View style={styles.plBottom}>
                        <Image
                            style={styles.imgNmane}
                            source={{uri:plInfoImge}}
                        />
                        <View style={styles.plBottomRight}>
                            <Text allowFontScaling={false} numberOfLines={3}>{this.state.plInfoName?this.state.plInfoName:""}</Text>
                            <TouchableOpacity
                                activeOpacity={1}
                                style={styles.gotopj}
                                onPress={this._pingjiaClick.bind(this)}
                            >
                                <Text allowFontScaling={false} style={{
                                    color:"#E5290D",
                                    fontSize:ScreenUtils.setSpText(26)
                                }}>去评价</Text>
                            </TouchableOpacity>
                        </View>
                    </View>

                </View>
            )
    }

    //去评价
    _pingjiaClick = () =>{
        DataAnalyticsModule.trackEvent3('AP1706C019F008002O008001', "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName,'type':'评价商品','orderid':this.state.order_no});
       // RnConnect.pushs({
       //     page:routeConfig.OrderCenterocj_Valuate,
       //     param:{
       //         orderNo:this.state.order_no,
       //         ordertype:this.state.order_type
       //     }
       // });
        RouteManager.routeJump({
            page:routeConfig.Valuate,
            param:{
                orderNo:this.state.order_no,
                ordertype:this.state.order_type
            }
        })
    }

}

PersonalComment.propTypes = {
    goodsName:PropTypes.string,
    count:PropTypes.number,
};

PersonalComment.defaultProps = {
    goodsName:"我是假数据",
    count:20,
};

const styles = StyleSheet.create({
    plBoxStyle:{
        backgroundColor:"#FFF",
        // marginBottom:ScreenUtils.scaleSize(15),
        paddingLeft:ScreenUtils.scaleSize(30),
        paddingRight:ScreenUtils.scaleSize(30),
        paddingTop:ScreenUtils.scaleSize(30)
    },

    plTopStyle:{
        flexDirection:"row",
        flex:1,
        height:ScreenUtils.scaleSize(55),
        justifyContent:"space-between",
        borderBottomWidth:1,
        borderBottomColor:"#DDDDDD"
    },

    plTopStyleLeft:{
        flexDirection:"row"
    },
    plBottom:{
        flex:1,
        flexDirection:"row",
        paddingTop:ScreenUtils.scaleSize(30),
        paddingBottom:ScreenUtils.scaleSize(30)

    },
    imgNmane:{
        width:ScreenUtils.scaleSize(170),
        height:ScreenUtils.scaleSize(170),
        borderColor:"#dddddd",
        borderWidth:1,
    },

    plBottomRight:{
        marginLeft:ScreenUtils.scaleSize(10),
        flex:1,
    },

    gotopj:{
        width:ScreenUtils.scaleSize(120),
        height:ScreenUtils.scaleSize(50),
        justifyContent:"center",
        borderColor:"#E5290D",
        borderWidth:1,
        position:"absolute",
        bottom:0,
        right:0,
        borderRadius:4,
        alignItems:"center"
    },

    pnxiemStyle:{
        fontSize:ScreenUtils.setSpText(28),
        color:"#333333"
    },

    mfitninfo:{
        fontSize:ScreenUtils.setSpText(26),
        color:"#666666",
        marginLeft:ScreenUtils.scaleSize(5)
    }


});