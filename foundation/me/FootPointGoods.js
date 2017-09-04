/**
 * Created by Administrator on 2017/5/7.
 * 个人中心底部列表
 */

import React from 'react';
import {
    StyleSheet,
    Text,
    View,
    FlatList,
    TouchableOpacity,
    Image
} from 'react-native';
import History from './History';
import {Actions} from 'react-native-router-flux';
// 引入外部组件
import PersonLevelDesc from '../../foundation/me/PersonLevelDesc';
import LogisticalStatus from '../../foundation/me/LogisticalStatus';
import PersonalComment from '../../foundation/me/PersonalComment';
import CategoryItems from '../../foundation/me/CategoryItems'

export default class FootPointGoods extends React.PureComponent {
    constructor(props) {
        super(props);
    }

    render() {
        let self = this;
        return (
            <FlatList
                removeClippedSubviews={true}
                horizontal={false}
                data={this.props.dataSource}
                renderItem={({item}) => (
                    <FootItem itemData={item}/>
                )}
                keyExtractor={this._keyExtractor}
                ListHeaderComponent={self._renderHeader}
            />
        )
    }

    _renderHeader() {
        return (
            <View>
                <PersonLevelDesc personName={'无敌的小七阿姨'}
                                 clubDesc={'离钻石会员还差111元，就能解锁'}
                                 clubAction={'会员俱乐部'}
                                 level={'VIP会员'}/>
                <CategoryItems kind={0} data={[0, 0, 3, 34, 0]}/>
                <LogisticalStatus />
                <CategoryItems kind={1} data={[123, 54, 82, 54, 633670]}/>
                <PersonalComment />
                <CategoryItems kind={2} data={[]}/>
                <History />
            </View>
        );
    }
}

var viewer;

class FootItem extends React.PureComponent {
    constructor(props) {
        super(props);
        this.state = {
            data: this.props.itemData,
        }
    }

    componentWillMount() {
        if (this.state.data.prductType !== "") {
            this.state.data.prductName = "【" + this.state.data.prductType + "】" + this.state.data.prductName;
        }
        if (this.state.data.originPrductPrice !== "") {
            this.state.data.originPrductPrice = "￥ " + this.state.data.originPrductPrice;
        }

        viewer = <View />;
        if (this.state.data.integral !== "") {
            viewer = <View style={{flexDirection: 'row'}}>
                <Text allowFontScaling={false} style={styles.integralStyle}>积分</Text>
                <Text allowFontScaling={false} style={styles.integralValueStyle}>{this.state.data.integral} </Text>
            </View>
        }
    }

    render() {
        return (
            <View style={styles.footPointGoods}>
                <TouchableOpacity
                    activeOpacity={1}
                    onPress={() => {
                        Actions.classifyToGoodsDetailMain();
                    }}
                >
                    <Image source={{uri: this.state.data.productImgSrc}} style={{height: 100, width: 100}}/>
                </TouchableOpacity>
                <View style={styles.goodsInfor}>
                    <TouchableOpacity
                        activeOpacity={1}
                        onPress={() => {
                            Actions.classifyToGoodsDetailMain();
                        }}
                    >
                        <View style={styles.prductNameViewStyle}>
                            <Text allowFontScaling={false} style={styles.prductNameTextStyle} numberOfLines={2}>
                                {this.state.data.prductName ? this.state.data.prductName : ''}
                            </Text>
                        </View>
                    </TouchableOpacity>
                    <View style={styles.priceViewStyle}>
                        <Text allowFontScaling={false}
                            style={styles.priceTextStyle}> {Number(this.state.data.prductPrice)>0 ?'￥' +  this.state.data.prductPrice: ''}</Text>
                        <Text allowFontScaling={false}
                            style={styles.unPriceTextStyle}>{Number(this.state.data.prductPrice)>0 && this.state.data.originPrductPrice ? this.state.data.originPrductPrice : ''}</Text>
                        {viewer}
                    </View>
                    <View style={styles.alreadyBuyViewStyle}>
                        <Text allowFontScaling={false}>{String(this.state.data.broughtCount)} 人已购买</Text>
                        <View style={styles.cartViewStyle}>
                            <Image source={require('../Img/me/Icon_shoppingcart_line_@3x.png')}/>
                        </View>
                    </View>
                </View>
            </View>
        );
    }

    // 释放内存
    componentWillUnmount() {
        viewer = '';
    }
}

FootPointGoods.propTypes = {
    data: React.PropTypes.array,
};

FootPointGoods.defaultProps = {};

const styles = StyleSheet.create({
    footPointGoods: {
        padding: 10,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'flex-start',
        borderTopWidth: 0.5,
        borderColor: '#DDDDDD',
        backgroundColor: '#FFFFFF',
    },
    goodsInfor: {
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        marginLeft: 5,
    },
    prductNameTextStyle: {
        flexWrap: "wrap",
        color: '#333333',
    },
    priceViewStyle: {
        flex: 1,
        flexDirection: 'row',
        marginTop: 15
    },
    priceTextStyle: {
        color: '#E5290D',
        marginRight: 10,
    },
    unPriceTextStyle: {
        textDecorationLine: "line-through",
        marginRight: 10,
    },
    integralStyle: {
        backgroundColor: 'orange',
        color: '#FEFEFE',
        marginRight: 5,
        paddingLeft: 3,
        paddingRight: 3
    },
    integralValueStyle: {
        color: 'orange',
    },
    alreadyBuyViewStyle: {
        flex: 1,
        flexDirection: 'row',
        alignItems: 'flex-end',

    },
    cartViewStyle: {
        flex: 1,
        alignItems: 'flex-end',
    }
});
