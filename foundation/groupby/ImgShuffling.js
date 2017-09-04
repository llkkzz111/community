/**
 * Created by lu weiguo on 2017/6月3号.
 * 今日团购页面导航栏组件
 */
'use strict';

import React, {
    PureComponent,
} from 'react'

import {
    View,
    Image,
    Dimensions,
    TouchableOpacity,
    StyleSheet,
} from 'react-native'

import {DataAnalyticsModule} from '../../app/config/AndroidModules';

let deviceWidth = Dimensions.get('window').width;
import {Actions} from 'react-native-router-flux';
import * as ScreenUtils from '../utils/ScreenUtil';
import Colors from '../../app/config/colors';
// 引入图片轮播组件
import Swiper from 'react-native-swiper';
let key = 0;
export default class ImgShuffling extends PureComponent {
    // 构造
    constructor(props) {
        super(props);
        this.state = {
            dataSource: [],
            bannersLinks: []
        }

    }

    componentWillReceiveProps(nextPros) {
        this.setState({
            dataSource: nextPros.dataSource,
            bannersLinks: nextPros.bannersLinks,
        });
    }

    render() {
        // console.log(this.props.dataSource);
        // console.log(this.state.dataSource);
        return (
            <View style={styles.todayStyle} key={++key}>
                <Swiper
                    style={styles.sBlock}
                    height={ScreenUtils.scaleSize(300)}
                    showsButtons={false}
                    autoplay={true}
                    autoplayTimeout={2.5}
                    dot={
                        <View
                            style={{
                                backgroundColor: Colors.text_white,
                                width: 5,
                                height: 5,
                                borderRadius: 4,
                                marginLeft: 3,
                                marginRight: 3,
                            }}
                        />
                    }
                    activeDot={
                        <View
                            style={{
                                backgroundColor: Colors.magenta,
                                width: 5,
                                height: 5,
                                borderRadius: 4,
                                marginLeft: 3,
                                marginRight: 3,
                                marginTop: 3,
                                marginBottom: 3
                            }}
                        />
                    }
                    paginationStyle={{
                        bottom: 0,
                        left: 0,
                        right: 0
                    }}

                    loop
                >
                    {this.props.dataSource.map((item, key) => {
                        return (
                            <TouchableOpacity key={key} activeOpacity={1} onPress={() => {
                                DataAnalyticsModule.trackEvent3(item.codeValue, "", {'pID': this.props.codeValue, 'vID': this.props.pageVersionName});
                                this._bannerLink(item.destinationUrlType, item.destinationUrl)
                            }}>
                                <Image
                                    style={styles.imgBlock}
                                    source={{uri: item.firstImgUrl ? item.firstImgUrl : ""}}
                                />
                            </TouchableOpacity>
                        )
                    }) }
                </Swiper>
            </View>

        )
    }

    /**
     *
     * @param destinationUrlType  (1:跳转商品详情页， 6:跳转H5的活动页面)
     * @param destinationUrl （ 跳转的商品的 codeID ）
     * @private
     */
    _bannerLink(destinationUrlType, destinationUrl) {
        if (destinationUrlType === 6 || destinationUrlType === 3) {
            Actions.VipPromotion({value: destinationUrl});
        }
        if (destinationUrlType === 1) {
            Actions.GoodsDetailMain({'itemcode': destinationUrl});
        }

    }

}

const styles = StyleSheet.create({
    todayStyle: {
        width: deviceWidth,
        height: ScreenUtils.scaleSize(300),
    },
    sBlock: {},
    wrapper: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        flex: 1,

    },
    imgBlock: {
        width: deviceWidth,
        height: ScreenUtils.scaleSize(300),
        resizeMode: 'cover',
    },
});