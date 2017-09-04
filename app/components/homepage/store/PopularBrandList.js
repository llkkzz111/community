/**
 * Created by YASIN on 2017/6/2.
 * 时尚大牌listview
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    StyleSheet,
    Text,
    FlatList,
    ScrollView,
    TouchableOpacity
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import * as IsEmptyUtil from '../../../../foundation/utils/IsEmptyUtil';

import PopularBrandItem from './PopularBrandItem';

import Immutable from 'immutable';

import {Actions} from 'react-native-router-flux';

import StoreDetailHtml5Request from '../../../../foundation/net/home/store/StoreDetailHtml5Request';

import {DataAnalyticsModule} from '../../../config/AndroidModules';

export default class PopularBrandList extends React.PureComponent {
    static propTypes = {
        ...View.propTypes.style,
        datas: React.PropTypes.array,
        headerDatas: React.PropTypes.array
    }

    constructor() {
        super();
        this._renderItem = this._renderItem.bind(this);
        this.jumpStoreH5 = this.jumpStoreH5.bind(this);
    }

    render() {
        let self = this;
        return (
            <View style={[styles.container, this.props.style]}>
                <FlatList
                    extarData={this.state}
                    horizontal={false}
                    data={this.props.datas}
                    renderItem={this._renderItem}
                    ListHeaderComponent={self._renderHeader.bind(self)}
                    overScrollMode={'never'}
                />
            </View>
        );
    }

    _renderItem(item, key) {
        let object = Immutable.fromJS(item);
        return (
            <PopularBrandItem
                selfCodeValue={item.item.codeValue}//自己的id
                codeValue={this.props.codeValue}//页面id
                pageVersionName={this.props.pageVersionName}//页面版本
                key={key}
                contentCode={object.get('item').get('contentCode')}
                componentList={object.get('item').get('componentList')}
                title={object.get('item').get('title')}
                desc={object.get('item').get('subtitle')}
                storeAvatar={{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(object.get('item').get('firstImgUrl'))) ? object.get('item').get('firstImgUrl') : ''}}
            />
        );
    }

    /**
     * 渲染头部广告位
     * @private
     */
    _renderHeader() {
        if (this.props.headerDatas && this.props.headerDatas.length > 0) {
            return (
                <ScrollView
                    horizontal={true}
                    showsHorizontalScrollIndicator={false}
                    style={styles.headerBrandContainer}>
                    {this.props.headerDatas.map((item, index) => {
                        let contentCode = item.contentCode;
                        return (
                            <View key={index} style={styles.headerItemView}>
                                <TouchableOpacity activeOpacity={1} onPress={() => {
                                    DataAnalyticsModule.trackEvent3(item.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                                    this.jumpStoreH5(contentCode);
                                }}>
                                    <Image
                                        style={styles.headerIconStyle}
                                        source={{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(item.firstImgUrl)) ? item.firstImgUrl : ''}}/>
                                </TouchableOpacity>
                                <Text allowFontScaling={false} style={styles.headerTitleStyle}>{item.title}</Text>
                            </View>
                        )
                    })}
                </ScrollView>
            );
        }
        return null;
    }

    jumpStoreH5(contentCode) {
        if (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(contentCode)) {
            let params = {
                id: 'AP1706A045',
                contentCode: String(contentCode)
            }
            this.StoreDetailHtml5Request = new StoreDetailHtml5Request(params, 'GET');
            this.StoreDetailHtml5Request.showLoadingView();
            this.StoreDetailHtml5Request.start((response) => {
                let object = Immutable.fromJS(response);
                if (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(object.get('destinationUrl'))) {
                    Actions.VipPromotion({value: object.get('destinationUrl')});
                }
            }, (error) => {

            });
        }
    }
}

const styles = StyleSheet.create({
    container: {
        width: ScreenUtils.screenW,
        alignItems: 'center',
        backgroundColor: Colors.text_white
    },
    headerItemView: {
        alignItems: 'center',
        width: ScreenUtils.scaleSize(180)
    },
    headerIconStyle: {
        width: ScreenUtils.scaleSize(148),
        height: ScreenUtils.scaleSize(148),
        borderWidth: StyleSheet.hairlineWidth,
        borderColor: Colors.text_light_grey
    },
    headerTitleStyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(22),
        marginTop: ScreenUtils.scaleSize(5),
        width: ScreenUtils.scaleSize(148),
        textAlign: 'center'
    },
    headerBrandContainer: {
        paddingBottom: ScreenUtils.scaleSize(20)
    }
});