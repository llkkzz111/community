/**
 * Created by Administrator on 2017/5/20.
 */
'use strict';

import React, {
    PureComponent,
    PropTypes
} from 'react';

import {
    View,
    Text,
    TouchableOpacity,
    Image,
    StyleSheet,
} from 'react-native';
import Fonts from '../../app/config/fonts';
import Colors from '../../app/config/colors';
import * as ScreenUtils from '../utils/ScreenUtil';
import { Actions } from 'react-native-router-flux';
import {DataAnalyticsModule} from '../../app/config/AndroidModules';

export const ItemHeight = ScreenUtils.scaleSize(294+20);

export default class BrandGroupListItem extends PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            data:[],
        }
    }
    render() {
        // console.log('firstImgUrl' + this.state.data.firstImgUrl);
        return (
            <View style={styles.containers}>
                <TouchableOpacity activeOpacity={1} style={{flex:1}} onPress={() => {
                    if (this.props.data.codeValue) {
                        DataAnalyticsModule.trackEvent3(this.props.data.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                    }
                    Actions.GroupBuyDetails({id:this.props.data.destinationUrl})
                }}>
                    <Image style={styles.logo} source={{uri: this.props.data.firstImgUrl}} resizeMode={'stretch'} />
                </TouchableOpacity>
                <View style={styles.itemStyle}>
                    <Text style={styles.itemStyle1} allowFontScaling={false}>距离结束还剩{this.props.data.remainingDays}天</Text>
                    <Text style={styles.itemStyle2} allowFontScaling={false}>{Number(this.props.data.salesVolume)>0?this.props.data.salesVolume + '人已团购':''}</Text>
                </View>

            </View>
        )
    }
}

const styles = StyleSheet.create({
    containers: {
        flex: 1,
        width: ScreenUtils.screenW,
        height: ItemHeight,
        maxHeight: ScreenUtils.screenW,
        flexDirection: 'row',
        backgroundColor: Colors.background_grey,
        paddingTop: ScreenUtils.scaleSize(20),
    },
    logo: {
        flex:1,
        resizeMode: 'cover',
    },
    little: {
        width: 80,
        height: 40,
        maxHeight: 40,
        maxWidth: 80
    },
    desc: {
        fontSize: 13,
        color: Colors.text_black
    },
    discount: {
        fontSize: Fonts.standard_normal_font(),
        color: Colors.main_color
    },
    itemStyle: {
        bottom: 0,
        backgroundColor:'rgba(0,0,0,0.1)',
        position: 'absolute',
        height:ScreenUtils.scaleSize(50),
        width: ScreenUtils.screenW*0.64,
        right: ScreenUtils.screenW*0.36,
        justifyContent:'space-between',
        flexDirection:'row',
        alignItems:'center',
    },
    itemStyle1: {
        color: Colors.text_white,
        backgroundColor:'rgba(0,0,0,0)',
        fontSize: ScreenUtils.setSpText(26),
        // position: 'absolute',
        // bottom: ScreenUtils.scaleSize(6),
        // left: ScreenUtils.scaleSize(6),
    },
    itemStyle2: {
        color:  Colors.text_white,
        backgroundColor:'rgba(0,0,0,0)',
        fontSize: ScreenUtils.setSpText(26),
        // position: 'absolute',
        // bottom: ScreenUtils.scaleSize(6),
        // right: ScreenUtils.scaleSize(6),
    },
    discountTitle: {
        fontSize: Fonts.secondary_font(),
    },
});

BrandGroupListItem.propTypes = {

};
BrandGroupListItem.defaultProps = {
    data: {
        id:"6275971112295727104",
        title:null,
        codeId:"406",
        destinationUrl:null,
        firstImgUrl:"http://10.22.218.170:8080/cms/cms/151/05/2017/201705151041052.jpg",
        subtitle:null,
        contentCode:"12321",
        shortNumber:0,
        componentId:"19",
        salesVolume:"90",
        remainingDays:"4",
        componentList:null,
        isComponents:0,
        codeValue:"AP1706A0003J03001F01001",
        destinationUrlType:null,
    },
};
