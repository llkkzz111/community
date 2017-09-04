/**
 * Created by MASTERMIAO on 2017/5/19.
 * 多商品订单商品清单页面赠品隐藏部分组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    StyleSheet,
    ScrollView,
    Dimensions,
    ART
} from 'react-native';

const { width } = Dimensions.get('window');
const {Surface, Shape, Path} = ART;

import { List } from 'immutable';

export default class OrderListGiftItem extends React.PureComponent {
    constructor () {
        super();
        this.state = {
            shopText: ""
        }
    }

    render () {
        const path = Path()
            .moveTo(1, 1)
            .lineTo(width, 1);
        let { giftData } = this.props;
        return (
            <View style={styles.containers}>
                <ScrollView showsVerticalScrollIndicator={false}>
                    {
                        giftData !== null && giftData !== undefined && giftData instanceof List && giftData.size > 0
                        && giftData.map((it, key) => {
                            let giftName = it.get('item_name');
                            let giftNo = it.get('giftcart_seq');
                            let dtInfo = it.get('dt_info');
                            return (
                                <View style={styles.giftItem}>
                                    <Text allowFontScaling={false} style={styles.giftItemDescStyle}>
                                        赠品{String(giftNo != null && giftNo != undefined ? giftNo : 0)}
                                    </Text>
                                    <Text allowFontScaling={false} style={styles.giftDescStyle3}>
                                        {giftName}
                                    </Text>
                                    <Text allowFontScaling={false} style={styles.giftDescStyle2}>
                                        x1
                                    </Text>
                                </View>
                            )
                        })
                    }
                </ScrollView>
                {/*<Surface width={width} height={1}>*/}
                    {/*<Shape d={path} stroke="#DDDDDD" strokeWidth={2} strokeDash={[6,3]} />*/}
                {/*</Surface>*/}
                {/*<View style={styles.giftItem}>*/}
                    {/*<Text allowFontScaling={false} style={{fontSize:12, marginLeft: 5}}>*/}
                        {/*{this.state.shopText.substr(0, 27) + "..."}*/}
                    {/*</Text>*/}
                    {/*<Text allowFontScaling={false} style={{fontSize:12, marginLeft: 5}}>*/}
                        {/*x1*/}
                    {/*</Text>*/}
                {/*</View>*/}
            </View>
        );
    }
}

const styles = StyleSheet.create({
    containers: {
        width: width,
        backgroundColor: 'white'
    },
    giftItemDescStyle: {
        fontSize: 12,
        color: 'black',
        marginLeft: 5,
        marginRight: 5
    },
    giftItemDescStyle2: {
        fontSize: 12,
        color: '#666666',
        marginLeft: 5,
        marginTop: 5
    },
    giftItem: {
        width: width,
        height: 30,
        maxHeight: 30,
        flexDirection: 'row',
        alignItems: 'center'
    },
    giftDescStyle: {
        fontSize: 12,
        color: '#666666'
    },
    giftDescStyle2: {
        fontSize: 12,
        color: '#666666',
        marginRight: 20
    },
    giftDescStyle3: {
        fontSize: 12,
        color: '#666666',
        marginLeft: 5,
        flex: 1
    },
    giftBlueBgDesc: {
        fontSize: 12,
        color: 'white'
    },
    giftBlueBgDesc2: {
        fontSize: 12,
        color: '#666666',
        marginRight: 15
    },
    actionBg: {
        alignItems: 'center',
        flexDirection: 'row',
        marginRight: 5
    },
    actionImgStyle: {
        width: 7,
        height: 10,
        resizeMode: "contain",
        marginRight: 5
    }
});

OrderListGiftItem.propTypes = {
    giftData: React.PropTypes.any
}
