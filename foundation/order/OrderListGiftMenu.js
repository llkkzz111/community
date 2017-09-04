/**
 * Created by MASTERMIAO on 2017/5/19.
 * 多商品订单商品清单页面赠品组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    Image,
    StyleSheet,
    Dimensions,
    TouchableOpacity
} from 'react-native';

const { width } = Dimensions.get('window');

import { List } from 'immutable';

import OrderListGiftItem from './OrderListGiftItem';

export default class OrderListGiftMenu extends React.PureComponent {
    constructor() {
        super();
        this.icons = {
            'down': require('../Img/cart/gift_menu.png'),
            'up': require('../Img/cart/gift_menu_up.png')
        };
        this.state = {
            open: true,
            expand: true
        }
    }

    render () {
        let icon = this.icons['down'];
        if (this.state.expanded) {
            icon = this.icons['up'];
        }
        let { giftData } = this.props;
        let giftDataOne;
        let giftName;
        let giftNo;
        let dtInfo;
        if (giftData !== null && giftData !== undefined && giftData instanceof List && giftData.size > 0) {
            giftDataOne = giftData.get(0);
            giftName = giftDataOne.get('item_name');
            giftNo = giftDataOne.get('giftcart_seq');
            dtInfo = giftDataOne.get('dt_info');
        }
        const isOpen = this.state.open ? <View style={styles.deltaContainer}>
            <TouchableOpacity activeOpacity={1}
                              onPress={this._menu} style={styles.viewContainers}>
                <View style={styles.giftTitleBg}>
                    <Text allowFontScaling={false} style={styles.giftStyle1}>
                        [赠品{String(giftNo != null && giftNo != undefined ? giftNo : 0)}]
                    </Text>
                </View>
                <View style={styles.giftTitleBg}>
                    <Text allowFontScaling={false} style={styles.giftDescStyle}>
                        {giftName}
                    </Text>
                </View>
                <View style={styles.giftBg}>
                    <Text allowFontScaling={false} style={styles.giftDescStyle}>
                        {giftNo != null && giftNo != undefined ? 'x1' : ''}
                    </Text>
                </View>
                <View style={styles.giftBg2}>
                    <Image style={styles.actionImg}
                           source={icon} />
                </View>
            </TouchableOpacity></View> : <View style={styles.deltaContainer2}>
            <TouchableOpacity activeOpacity={1}
                              onPress={this._menu}  style={styles.viewContainers2}>
                <View style={styles.viewContainers3}>
                    <View style={styles.giftTitleBg}>
                        <Text allowFontScaling={false} style={styles.giftStyle1}>
                            [赠品{String(giftNo != null && giftNo != undefined ? giftNo : 0)}]
                        </Text>
                    </View>
                    <View style={styles.giftTitleBg}>
                        <Text allowFontScaling={false} style={styles.giftDescStyle}>
                            {giftName}
                        </Text>
                    </View>
                    <View style={styles.giftBg}>
                        <Text allowFontScaling={false} style={styles.giftDescStyle}>
                            {giftNo != null && giftNo != undefined ? 'x1' : ''}
                        </Text>
                    </View>
                    <View style={styles.giftBg2}>
                        <Image style={styles.actionImg}
                               source={icon} />
                    </View>
                </View>
                <OrderListGiftItem giftData={giftData} />
            </TouchableOpacity></View>
        return (
            isOpen
        );
    }

    _menu = () => {
        this.setState({
            expanded : !this.state.expanded
        });
        if (this.state.open === true) {
            this.setState({ open: false });
        } else {
            this.setState({ open: true });
        }
    }
}

const styles = StyleSheet.create({
    deltaContainer: {
        width: width,
        height: 30,
        maxHeight: 30,
        flexDirection: 'column'
    },
    deltaContainer2: {
        width: width,
        flexDirection: 'column'
    },
    viewContainers: {
        width: width,
        height: 30,
        maxHeight: 30,
        flexDirection: 'row',
        backgroundColor: 'white'
    },
    viewContainers2: {
        width: width,
        flexDirection: 'column',
        backgroundColor: 'white'
    },
    viewContainers3: {
        width: width,
        height: 30,
        maxHeight: 30,
        backgroundColor: 'white',
        flexDirection: 'row'
    },
    giftStyle: {
        fontSize: 12,
        color: '#333333'
    },
    giftStyle1 : {
        fontSize: 12,
        color: '#333333',
        marginLeft: 5,
        position: 'relative'
    },
    giftDescStyle: {
        fontSize: 11,
        color: '#666666'
    },
    actionImg: {
        width: 17,
        height: 7,
        resizeMode: "contain"
    },
    giftTitleBg: {
        width: width / 6,
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'row',
        flex: 1
    },
    giftBg: {
        width: width / 8,
        alignItems: 'center',
        justifyContent: 'center',

    },
    giftBg2: {
        width: width / 8,
        alignItems: 'center',
        justifyContent: 'center',
        position: 'relative',
        right: 5
    },
    giftDescBg: {
        width: (width / 8) * 5,
        justifyContent: 'center'
    }
});

OrderListGiftMenu.propTypes = {
    giftData: React.PropTypes.any
}
