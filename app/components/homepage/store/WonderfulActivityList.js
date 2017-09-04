/**
 * Created by YASIN on 2017/6/1.
 * 精彩内容列表
 */
'use strict';

import React from 'react';

import {
    View,
    StyleSheet
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import * as IsEmptyUtil from '../../../../foundation/utils/IsEmptyUtil';

import WonderfulActivityItem from './WonderfulActivityItem';

import { Actions }from 'react-native-router-flux';

import Toast, { DURATION } from 'react-native-easy-toast';

import {DataAnalyticsModule} from '../../../config/AndroidModules';

export default class WonderfulActivityList extends React.PureComponent {
    static propTypes = {
        datas: React.PropTypes.array
    }

    render() {
        let datas = this.props.datas;
        return (
            <View>
                <View style={styles.wonderfulActivityList1}>
                    {datas[0] !== null && datas[0] !== undefined && <WonderfulActivityItem
                        style={styles.wonderfulActivityList11}
                        title={datas[0].title}
                        desc={datas[0].subtitle}
                        icons={[{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(datas[0].firstImgUrl)) ? datas[0].firstImgUrl : ''}]}
                        titleStyle={{color: Colors.main_color}}
                        onItemClick={this._onItemClick.bind(this, datas[0])}
                    />}
                    {datas[1] !== null && datas[1] !== undefined && <WonderfulActivityItem
                        style={styles.wonderfulActivityList12}
                        title={datas[1].title}
                        desc={datas[1].subtitle}
                        icons={[{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(datas[1].firstImgUrl)) ? datas[1].firstImgUrl : ''}]}
                        titleStyle={{color: Colors.main_color}}
                        onItemClick={this._onItemClick.bind(this, datas[1])}
                    />}
                </View>
                <View style={styles.wonderfulActivityList2}>
                    {datas[2] !== null && datas[2] !== undefined && <WonderfulActivityItem
                        style={styles.wonderfulActivityList21}
                        title={datas[2].title}
                        desc={datas[2].subtitle}
                        icons={[{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(datas[2].firstImgUrl)) ? datas[2].firstImgUrl : ''}]}
                        onItemClick={this._onItemClick.bind(this, datas[2])}
                    />}
                    {datas[3] !== null && datas[3] !== undefined && <WonderfulActivityItem
                        style={styles.wonderfulActivityList22}
                        title={datas[3].title}
                        desc={datas[3].subtitle}
                        icons={[{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(datas[3].firstImgUrl)) ? datas[3].firstImgUrl : ''}]}
                        onItemClick={this._onItemClick.bind(this,datas[3])}
                    />}
                    {datas[4] !== null && datas[4] !== undefined && <WonderfulActivityItem
                        style={styles.wonderfulActivityList23}
                        title={datas[4].title}
                        desc={datas[4].subtitle}
                        icons={[{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(datas[4].firstImgUrl)) ? datas[4].firstImgUrl : ''}]}
                        onItemClick={this._onItemClick.bind(this, datas[4])}
                    />}
                </View>
                <Toast ref="toast" position='center' />
            </View>
        )
    }

    /**
     * 点击item
     * @param data
     * @private
     */
    _onItemClick(data){
        DataAnalyticsModule.trackEvent3(data.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
        if(data.destinationUrl && typeof data.destinationUrl !== 'undefined' && data.destinationUrl !== undefined && data.destinationUrl !== '' && data.destinationUrl !== ""){
            Actions.VipPromotion({value: data.destinationUrl});
        }
    }
}
const styles = StyleSheet.create({
    wonderfulActivityList1:{
        flexDirection:'row',
        alignItems:'center'
    },
    wonderfulActivityList11:{
        flex:1,
        backgroundColor:Colors.text_white
    },
    wonderfulActivityList12:{
        flex:1,
        marginLeft:ScreenUtils.scaleSize(1),
        backgroundColor:Colors.text_white
    },
    wonderfulActivityList2:{
        flexDirection:'row',
        alignItems:'center',
        marginTop:ScreenUtils.scaleSize(1)
    },
    wonderfulActivityList21:{
        flex:1,
        backgroundColor:Colors.text_white
    },
    wonderfulActivityList22:{
        flex:1,
        marginLeft:ScreenUtils.scaleSize(1),
        backgroundColor:Colors.text_white
    },
    wonderfulActivityList23:{
        flex:1,
        marginLeft:ScreenUtils.scaleSize(1),
        backgroundColor:Colors.text_white
    }
});