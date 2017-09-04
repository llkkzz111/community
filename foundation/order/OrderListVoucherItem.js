/**
 * Created by MASTERMIAO on 2017/5/17.
 * 订单填写页面的多商品抵用券Dialog的条目组件
 */
'use strict';

import React from 'react';

import {
    View,
    Text,
    Image,
    Dimensions,
    StyleSheet,
    ScrollView,
    TouchableOpacity
} from 'react-native';

const { width } = Dimensions.get('window');

export default class OrderListVoucherItem extends React.PureComponent {
    constructor() {
        super();
        this.state = {
            currentNumber: 0,
            selected: false
        }
    }

    render() {
        let { productImgList, classNo, productNo } = this.props;
        return (
            <View style={styles.containers}>
                <View style={styles.classStyle}>
                    <Text allowFontScaling={false} style={styles.groupTitle}>分类{String(classNo)}</Text>
                    <Text allowFontScaling={false} style={styles.group}>(此组内商品已满足优惠券使用条件)</Text>
                </View>
                <View style={styles.generalStyle}>
                    <ScrollView style={{height: 100}}
                                showsVerticalScrollIndicator={false}
                                horizontal={true}>
                        <View style={{flexDirection: 'row', alignItems: 'center'}}>
                            {
                                productImgList.map((it) => {
                                    return (
                                        <Image style={styles.pImg} source={{uri: it.get('img')}} />
                                    )
                                })
                            }
                        </View>
                    </ScrollView>
                    <View style={{flexDirection: 'row'}}>
                        <Text allowFontScaling={false}>共{String(productNo)}件</Text>
                        <Image style={styles.appointAction} source={require('../Img/arrow_right.png')} />
                    </View>
                </View>
                <View style={{flexDirection: 'row', height: 30, alignItems: 'center'}}>
                    <Text allowFontScaling={false} style={styles.groupTitle}>可使用优惠券</Text>
                    <Text allowFontScaling={false} style={styles.group}>(已默认为您选择最优方案)</Text>
                </View>
                <TouchableOpacity activeOpacity={1} onPress={() => {this.props.openMenu();}} style={{flexDirection: 'row', alignItems: 'center', marginTop: 10}}>
                    <Text allowFontScaling={false} style={styles.group2}>{'满500元，省80元，(仅限甄选生活专营店)'}</Text>
                    <View style={{flexDirection: 'row'}}>
                        <Text allowFontScaling={false} style={styles.group2}>修改</Text>
                        <Image style={styles.appointAction} source={require('../Img/arrow_right.png')} />
                    </View>
                </TouchableOpacity>
            </View>
        )
    }

    onCheckBoxClick() {
        this.setState({selected: !this.state.selected});
    }
}

const styles = StyleSheet.create({
    containers: {
        flex: 1,
        width: width,
        height: 210,
        maxHeight: 210,
        backgroundColor: 'white',
        flexDirection: 'column',
        marginTop: 1
    },
    generalStyle: {
        flexDirection: 'row',
        alignItems: 'center'
    },
    classStyle: {
        flexDirection: 'row',
        height: 40,
        alignItems: 'center'
    },
    group: {
        fontSize: 12,
    },
    group2: {
        fontSize: 12,
        marginLeft: 10
    },
    groupTitle: {
        fontSize: 13,
        color: 'black',
        marginLeft: 10
    },
    appointAction: {
        width: 16,
        height: 16,
        marginRight: 10
    },
    pImg: {
        width: 80,
        height: 80,
        marginLeft: 10,
        borderRadius: 3,
        borderColor: '#DDDDDD',
        borderWidth: 1
    },
    imgStyle: {
        width: 17,
        height: 17
    }
});

OrderListVoucherItem.propTypes = {
    openMenu: React.PropTypes.func
}
