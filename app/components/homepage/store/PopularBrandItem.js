/**
 * Created by YASIN on 2017/6/2.
 */
'use strict';

import React from 'react';

import {
    View,
    Image,
    TouchableOpacity,
    StyleSheet,
    Platform,
    Text,
    ScrollView
} from 'react-native';

import Colors from '../../../config/colors';

import * as ScreenUtils from '../../../../foundation/utils/ScreenUtil';

import * as IsEmptyUtil from '../../../../foundation/utils/IsEmptyUtil';

import {Actions}from'react-native-router-flux';

import Toast, {DURATION} from 'react-native-easy-toast';

import StoreDetailHtml5Request from '../../../../foundation/net/home/store/StoreDetailHtml5Request';

import Immutable from 'immutable';

import {DataAnalyticsModule} from '../../../config/AndroidModules';

export default class PopularBrandItem extends React.PureComponent {
    static propTypes = {
        storeAvatar: Image.propTypes.source,
        title: React.PropTypes.string,
        desc: React.PropTypes.string,
        componentList: React.PropTypes.any,
        destinationUrl: React.PropTypes.any,
        contentCode: React.PropTypes.any
    }

    render() {
        let {componentList, contentCode} = this.props;
        return (
            <View style={styles.container}>
                <View style={styles.headerContainer}>
                    <View style={styles.headerLeftContainer}>
                        <Image
                            style={styles.headerIconStyle}
                            source={this.props.storeAvatar}/>
                        <View style={styles.titleContainer}>
                            <Text allowFontScaling={false} style={styles.titleStyle}>{this.props.title}</Text>
                            <Text allowFontScaling={false} style={styles.descStyle}>{this.props.desc}</Text>
                        </View>
                    </View>
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={
                            () => {
                                DataAnalyticsModule.trackEvent3(this.props.selfCodeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                                this.jumpStoreH5(contentCode);
                            }
                        }>
                        <View style={styles.headerRightContainer}>
                            <Text allowFontScaling={false}
                                style={{fontSize: ScreenUtils.scaleSize(26), color: Colors.text_dark_grey}}>进入店铺</Text>
                            <Image
                                style={styles.rightArrowStyle}
                                source={require('../../../../foundation/Img/home/store/icon_view_more_.png')}
                            />
                        </View>
                    </TouchableOpacity>
                </View>
                <View style={styles.bodyContainer}>
                    <ScrollView horizontal={true} showsHorizontalScrollIndicator={false}>
                        {componentList !== null && componentList !== undefined && componentList.map((item, index) => {
                            let viewer = null;
                            if (IsEmptyUtil.stringIsEmptyAndUndefined(item.get('codeId'))) {
                                switch (parseInt(item.get('codeId'))) {
                                    case 404:
                                        if (IsEmptyUtil.stringIsEmptyAndUndefined(item.get('salePrice'))) {
                                            let price = item.get('salePrice')
                                            viewer = <View style={styles.priceContainer}>
                                                <Text allowFontScaling={false} style={styles.priceTyle}>¥</Text>
                                                <Text allowFontScaling={false} style={styles.price}>{String(price)}</Text>
                                            </View>
                                        }
                                    default:
                                        break;
                                }
                            }
                            return (
                                <View style={styles.itemContainer} key={index}>
                                    <TouchableOpacity activeOpacity={1} onPress={() => {
                                        DataAnalyticsModule.trackEvent3(this.props.selfCodeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                                        this.jumpGoodDetail(item.get('contentCode'));
                                    }}>
                                        <Image
                                            resizeMode={'stretch'}
                                            style={styles.itemIcon}
                                            source={{uri: (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(item.get('firstImgUrl'))) ? item.get('firstImgUrl') : ''}}/>
                                    </TouchableOpacity>
                                    <View style={styles.priceContainer}>
                                        <Text allowFontScaling={false} style={styles.itemTitleStyle} numberOfLines={1}>{item.get('title')}</Text>
                                    </View>
                                    {/*{viewer}*/}
                                    <View style={styles.priceContainer}>
                                        <Text allowFontScaling={false} style={styles.priceTyle}>¥</Text>
                                        <Text allowFontScaling={false} style={styles.price}>{item.get('salePrice')}</Text>
                                    </View>
                                </View>
                            );
                        })}
                    </ScrollView>
                </View>
                <Toast ref="toast" position='center'/>
            </View>
        );
    }

    jumpGoodDetail = (code) => {
        if (IsEmptyUtil.stringIsEmptyAndUndefinedAndNull(code)) {
            Actions.GoodsDetailMain({itemcode: code});
        }
    }

    jumpStoreH5 = (contentCode) => {
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
        alignItems: 'center'
    },
    headerContainer: {
        width: ScreenUtils.screenW,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: ScreenUtils.scaleSize(30),
        borderBottomColor: Colors.background_grey,
        borderBottomWidth: ScreenUtils.scaleSize(1),
        borderTopColor: Colors.background_grey,
        borderTopWidth: ScreenUtils.scaleSize(20)
    },
    headerLeftContainer: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headerRightContainer: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    headerIconStyle: {
        width: ScreenUtils.scaleSize(70),
        height: ScreenUtils.scaleSize(70),
        resizeMode: 'stretch'
    },
    titleContainer: {
        marginLeft: ScreenUtils.scaleSize(10)
    },
    titleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28)
    },
    descStyle: {
        color: Colors.text_dark_grey,
        fontSize: ScreenUtils.scaleSize(24),
        ...Platform.select({
            ios: {
                marginTop: ScreenUtils.scaleSize(4)
            }
        })
    },
    rightArrowStyle: {
        width: ScreenUtils.scaleSize(10),
        height: ScreenUtils.scaleSize(15),
        marginLeft: ScreenUtils.scaleSize(10)
    },
    bodyContainer: {
        paddingVertical: ScreenUtils.scaleSize(30),
        paddingHorizontal: ScreenUtils.scaleSize(15),
        alignItems: 'center',
        width: ScreenUtils.screenW
    },
    itemContainer: {
        width: (ScreenUtils.screenW - 2 * ScreenUtils.scaleSize(15)) / 3,
        alignItems: 'center',
        paddingHorizontal: ScreenUtils.scaleSize(15),
    },
    itemIcon: {
        width: (ScreenUtils.screenW - 6 * ScreenUtils.scaleSize(15)) / 3,
        height: (ScreenUtils.screenW - 6 * ScreenUtils.scaleSize(15)) / 3,
        maxWidth: (ScreenUtils.screenW - 6 * ScreenUtils.scaleSize(15)) / 3,
        maxHeight: (ScreenUtils.screenW - 6 * ScreenUtils.scaleSize(15)) / 3
    },
    itemTitleStyle: {
        color: Colors.text_black,
        fontSize: ScreenUtils.scaleSize(28),
        marginTop: ScreenUtils.scaleSize(5)
    },
    priceContainer: {
        flexDirection: 'row',
        alignItems: 'flex-end',
        marginTop: ScreenUtils.scaleSize(10),
        alignSelf: 'flex-start',
        marginLeft: ScreenUtils.scaleSize(5),
    },
    priceTyle: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(20)
    },
    price: {
        color: Colors.main_color,
        fontSize: ScreenUtils.scaleSize(24)
    },
    oldPrice: {
        color: Colors.text_light_grey,
        fontSize: ScreenUtils.scaleSize(20),
        marginLeft: ScreenUtils.scaleSize(10),
        textDecorationLine: 'line-through'
    }
});